{
  description = "HyPrism - A multiplatform Hytale launcher";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

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

          installPhase = ''
            mkdir -p $out
            cp -r ../wwwroot/* $out/
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
            #   nix build .#default.passthru.fetch-deps && ./result deps.json
            nugetDeps = ./deps.json;

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

            runtimeDeps = with pkgs; [
              # Photino.NET deps
              gtk3
              glib
              webkitgtk_4_1
              libnotify
            ];

            nativeBuildInputs = with pkgs; [
              wrapGAppsHook3 # Handles GTK/GStreamer env setup
            ];

            # wrapGAppsHook3 automatically sets GIO_MODULE_DIR and GST_PLUGIN_PATH
            buildInputs = with pkgs; [
              gst_all_1.gst-plugins-base
              gst_all_1.gst-plugins-good
              glib-networking # TLS/SSL support for WebKit
            ];

            postFixup = ''
              mv $out/bin/HyPrism $out/bin/hyprism
            '';

            executables = [ "HyPrism" ];

            meta = with pkgs.lib; {
              description = "A multiplatform Hytale launcher with mod manager and more";
              homepage = "https://github.com/yyyumeniku/HyPrism";
              license = licenses.mit;
              platforms = platforms.linux;
              mainProgram = "hyprism";
            };
          };
        };
      }
    );
}
