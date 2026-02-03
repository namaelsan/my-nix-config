{
  description = "HyPrism - A multiplatform Hytale launcher";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # HyPrism source - update this to track a different branch/commit
    hyprism-src = {
      url = "github:yyyumeniku/HyPrism/75c0292ea069f494c1ee5a0297956f92ec6e7abf";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      hyprism-src,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        dotnet-sdk = pkgs.dotnet-sdk_8;
        dotnet-runtime = pkgs.dotnetCorePackages.runtime_8_0;
        version = "2.0.3";

        # Build the React/Vite frontend first
        # The frontend outputs to ../wwwroot which is used by the .NET backend
        frontend = pkgs.buildNpmPackage {
          pname = "hyprism-frontend";
          version = version;
          src = "${hyprism-src}/frontend";
          # Hash of npm dependencies - update with lib.fakeHash if package-lock.json changes
          npmDepsHash = "sha256-DKfG9BN0B5xS9el8LDyB6gpr9d8aslEOixXYizBF/0E=";

          # Vite outputs to ../wwwroot, so we need to create the directory structure
          postUnpack = ''
            mkdir -p $sourceRoot/../wwwroot
          '';

          buildPhase = ''
            runHook preBuild
            npm run build
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            mkdir -p $out
            cp -r ../wwwroot/* $out/
            runHook postInstall
          '';
        };
      in
      {
        packages = {
          default = pkgs.buildDotnetModule {
            pname = "HyPrism";
            version = version;
            src = hyprism-src;

            projectFile = "./HyPrism.csproj";
            dotnet-sdk = dotnet-sdk;
            dotnet-runtime = dotnet-runtime;

            # NuGet dependencies - regenerate with:
            #   nix build .#default.passthru.fetch-deps && ./result nix/deps.json
            nugetDeps = ./nix/deps.json;

            # =====================================================
            # NixOS Compatibility Patches
            # =====================================================
            # Replace hardcoded Unix paths with Nix store paths
            # These paths don't exist on NixOS
            postPatch = ''
              substituteInPlace Backend/AppService.cs \
                --replace-quiet '"/bin/chmod"' '"${pkgs.coreutils}/bin/chmod"' \
                --replace-quiet '"/bin/bash"' '"${pkgs.bash}/bin/bash"' \
                --replace-quiet '"/bin/sh"' '"${pkgs.bash}/bin/sh"'
            '';

            # Copy the pre-built frontend assets before .NET build
            preBuild = ''
              mkdir -p wwwroot
              cp -r ${frontend}/* wwwroot/
            '';

            # =====================================================
            # Runtime Dependencies for Photino.NET (WebView)
            # =====================================================
            # Photino.NET uses WebKitGTK for rendering the UI
            runtimeDeps = with pkgs; [
              # GTK and WebKit for Photino.NET WebView
              gtk3
              webkitgtk_4_1

              # X11 libraries for window management
              xorg.libX11
              xorg.libXrandr
              xorg.libXi
              xorg.libXcursor
              xorg.libXdamage
              xorg.libXfixes
              xorg.libXcomposite
              xorg.libXext
              xorg.libXrender

              # Core GTK dependencies
              glib
              pango
              cairo
              atk
              gdk-pixbuf

              # Desktop integration
              libnotify
              dbus

              # GStreamer for WebKit media support (videos, audio)
              gst_all_1.gstreamer
              gst_all_1.gst-plugins-base
              gst_all_1.gst-plugins-good
              gst_all_1.gst-plugins-bad
              gst_all_1.gst-libav

              # WebKit networking/SSL support (for loading images over HTTPS)
              glib-networking
              libsoup_3
              cacert
            ];

            # =====================================================
            # Build-time Dependencies and Wrapping
            # =====================================================
            nativeBuildInputs = with pkgs; [
              wrapGAppsHook3 # Handles GTK/GStreamer env setup
              gst_all_1.gstreamer
            ];

            # wrapGAppsHook3 automatically sets GIO_MODULE_DIR and GST_PLUGIN_PATH
            buildInputs = with pkgs; [
              gst_all_1.gstreamer
              gst_all_1.gst-plugins-base
              gst_all_1.gst-plugins-good
              gst_all_1.gst-plugins-bad
              gst_all_1.gst-libav
              glib-networking # TLS/SSL support for WebKit
            ];

            dontWrapGApps = false;

            # Additional wrapper arguments for NixOS compatibility
            preFixup = ''
              gappsWrapperArgs+=(
                --prefix PATH : ${
                  pkgs.lib.makeBinPath [
                    pkgs.coreutils
                    pkgs.bash
                  ]
                }
                --set SSL_CERT_FILE "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
              )
            '';

            executables = [ "HyPrism" ];

            meta = with pkgs.lib; {
              description = "A multiplatform Hytale launcher with mod manager and more";
              homepage = "https://github.com/yyyumeniku/HyPrism";
              license = licenses.mit;
              platforms = platforms.linux;
              mainProgram = "HyPrism";
            };
          };
        };

        # Development shell with all tools needed to work on HyPrism
        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              dotnet-sdk
              pkgs.nodejs
              pkgs.git
            ];
          };
        };
      }
    );
}
