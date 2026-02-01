{
  description = "HyPrism - Game Launcher (.NET/Photino) - REMOTE BUILD";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    hyprism = {
      url = "github:yyyumeniku/HyPrism/75c0292ea069f494c1ee5a0297956f92ec6e7abf";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      hyprism,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Runtime dependencies for Photino (WebKitGTK-based)
        runtimeDeps = with pkgs; [
          gtk3
          webkitgtk_4_1
          glib
          cairo
          pango
          gdk-pixbuf
          libsoup_3
          at-spi2-core
          dbus
          xdg-utils
          shared-mime-info
          libnotify
          # GL support
          mesa
          mesa.drivers
          libGL
          libglvnd
          # GStreamer for media
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-ugly
          gst_all_1.gst-libav
        ];

        # Game runtime dependencies
        gameDeps = with pkgs; [
          SDL2
          SDL2_image
          SDL2_mixer
          SDL2_ttf
          libpng
          libjpeg
          libGL
          libglvnd
          openal
          libvorbis
          libogg
        ];

        # Build the React frontend from remote source
        frontend = pkgs.buildNpmPackage {
          pname = "hyprism-frontend";
          version = "1.0.0";
          src = "${hyprism}/frontend";
          npmDepsHash = "sha256-DKfG9BN0B5xS9el8LDyB6gpr9d8aslEOixXYizBF/0E=";
          buildPhase = "runHook preBuild; npm run build; runHook postBuild";
          installPhase = "runHook preInstall; mkdir -p $out; cp -r ../wwwroot/* $out/; runHook postInstall";
        };

      in
      {
        packages.default = pkgs.buildDotnetModule {
          pname = "hyprism";
          version = "1.0.0";
          src = hyprism;

          projectFile = "HyPrism.csproj";
          nugetDeps = ./deps.nix;

          dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0;
          dotnet-runtime = pkgs.dotnetCorePackages.runtime_8_0;

          nativeBuildInputs = with pkgs; [
            makeWrapper
            pkg-config
          ];

          buildInputs = runtimeDeps;

          # Copy frontend to wwwroot before build
          preBuild = ''
            mkdir -p wwwroot
            cp -r ${frontend}/* wwwroot/
          '';

          # Wrap with runtime library paths and environment
          postInstall = ''
            # Create xdg-open wrapper that sanitizes environment
            mkdir -p $out/libexec
            cat > $out/libexec/xdg-open << 'EOF'
            #!${pkgs.bash}/bin/bash
            unset LD_LIBRARY_PATH
            unset GIO_MODULE_DIR
            unset GST_PLUGIN_SYSTEM_PATH_1_0
            unset LIBGL_DRIVERS_PATH
            unset __EGL_VENDOR_LIBRARY_FILENAMES
            exec /run/current-system/sw/bin/xdg-open "$@"
            EOF
            chmod +x $out/libexec/xdg-open

            wrapProgram $out/lib/hyprism/HyPrism \
              --prefix LD_LIBRARY_PATH : "$out/lib/hyprism:${
                pkgs.lib.makeLibraryPath (runtimeDeps ++ gameDeps)
              }" \
              --prefix PATH : "$out/libexec:/run/current-system/sw/bin" \
              --set LIBGL_DRIVERS_PATH "${pkgs.mesa.drivers}/lib/dri" \
              --set __EGL_VENDOR_LIBRARY_FILENAMES "${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json" \
              --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${
                pkgs.lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
                  pkgs.gst_all_1.gstreamer
                  pkgs.gst_all_1.gst-plugins-base
                  pkgs.gst_all_1.gst-plugins-good
                  pkgs.gst_all_1.gst-plugins-bad
                  pkgs.gst_all_1.gst-plugins-ugly
                  pkgs.gst_all_1.gst-libav
                ]
              }"
          '';

          meta = {
            description = "HyPrism Game Launcher";
            mainProgram = "HyPrism";
          };
        };

        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs =
            with pkgs;
            [
              dotnetCorePackages.sdk_8_0
              nodejs
              pkg-config
            ]
            ++ runtimeDeps
            ++ gameDeps;

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (runtimeDeps ++ gameDeps);
        };
      }
    );
}
