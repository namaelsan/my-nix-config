{
  description = "HyPrism - REMOTE BUILD (uses github:yyyumeniku/HyPrism)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    hyprism.url = "github:yyyumeniku/HyPrism/main";
    hyprism.flake = false;
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      flake-utils,
      hyprism,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pkgsUnstable = nixpkgs-unstable.legacyPackages.${system};

        wailsRuntimeDeps = with pkgs; [
          gtk3
          webkitgtk
          glib
          cairo
          pango
          gdk-pixbuf
          libsoup
          mesa
          mesa.drivers
          libGL
          libglvnd
          vulkan-loader
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-ugly
          gst_all_1.gst-libav
          xdg-utils
          dbus
          at-spi2-core
          shared-mime-info
        ];

        gameDeps =
          (with pkgs; [
            SDL2
            SDL2_image
            SDL2_mixer
            SDL2_ttf
            libpng
            libjpeg
            dotnetCorePackages.runtime_8_0
            libGL
            libglvnd
            openal
            libvorbis
            libogg
          ])
          ++ (with pkgsUnstable; [
            sdl3
            sdl3-image
          ]);

        frontend = pkgs.buildNpmPackage {
          pname = "hyprism-frontend";
          version = "remote";
          src = "${hyprism}/frontend";
          npmDepsHash = "sha256-l/wJ1H8txNIBJuC/0OwloURz32291XJI9JQB7JC4OuI=";
          buildPhase = "runHook preBuild; npm run build; runHook postBuild";
          installPhase = "runHook preInstall; mkdir -p $out; cp -r dist/* $out/; runHook postInstall";
        };

      in
      {
        packages.default = pkgs.buildGoModule {
          pname = "hyprism-remote";
          version = "remote";
          src = hyprism;
          vendorHash = "sha256-VZ0wVSeyPzQEOFVUHQqp/efzbASjQkbwGaHwxwm3rsc=";

          nativeBuildInputs = with pkgs; [
            pkg-config
            makeWrapper
          ];
          buildInputs = wailsRuntimeDeps;

          preBuild = "mkdir -p frontend/dist; cp -r ${frontend}/* frontend/dist/";

          buildPhase = ''
            runHook preBuild
            export HOME=$TMPDIR CGO_ENABLED=1
            go build -tags desktop,production -ldflags "-s -w" -o HyPrism .
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            cp HyPrism $out/bin/

            # Wrapper to sanitize environment for xdg-open
            mkdir -p $out/libexec
            echo '#!${pkgs.bash}/bin/bash' > $out/libexec/xdg-open
            echo 'unset LD_LIBRARY_PATH' >> $out/libexec/xdg-open
            echo 'unset GIO_MODULE_DIR' >> $out/libexec/xdg-open
            echo 'unset GDK_BACKEND' >> $out/libexec/xdg-open
            echo 'unset LIBGL_DRIVERS_PATH' >> $out/libexec/xdg-open
            echo 'unset __EGL_VENDOR_LIBRARY_FILENAMES' >> $out/libexec/xdg-open
            echo 'unset WEBKIT_DISABLE_COMPOSITING_MODE' >> $out/libexec/xdg-open
            echo 'unset GST_PLUGIN_SYSTEM_PATH_1_0' >> $out/libexec/xdg-open
            echo 'unset GDK_PIXBUF_MODULE_FILE' >> $out/libexec/xdg-open
            echo 'exec ${pkgs.xdg-utils}/bin/xdg-open "$@"' >> $out/libexec/xdg-open
            chmod +x $out/libexec/xdg-open

            wrapProgram $out/bin/HyPrism \
              --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath (wailsRuntimeDeps ++ gameDeps)}" \
              --set GDK_BACKEND "x11" \
              --set LIBGL_DRIVERS_PATH "${pkgs.mesa.drivers}/lib/dri" \
              --set __EGL_VENDOR_LIBRARY_FILENAMES "${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json" \
              --set WEBKIT_DISABLE_COMPOSITING_MODE "1" \
              --prefix PATH : "$out/libexec:$out/bin:${pkgs.glib}/bin:/run/current-system/sw/bin:${pkgs.xdg-utils}/bin" \
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
            runHook postInstall
          '';

          meta.mainProgram = "HyPrism";
        };
      }
    );
}
