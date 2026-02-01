{
  description = "Hytale F2P Launcher - A modern, cross-platform launcher for Hytale";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Fetch the latest source from GitHub
    hytale-f2p-src = {
      url = "github:amiayweb/Hytale-F2P";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      hytale-f2p-src,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        pname = "hytale-f2p-launcher";
        version = "2.1.1";

        # Runtime libraries needed by Electron and game client
        runtimeLibs = with pkgs; [
          gtk3
          nss
          nspr
          at-spi2-atk
          cups
          dbus
          expat
          libdrm
          mesa
          libglvnd
          alsa-lib

          xorg.libX11
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXrandr
          xorg.libxcb
          glib
          pango
          cairo
          atk
          gdk-pixbuf
          libxkbcommon
          dbus
          at-spi2-atk
          cups
          expat
          nspr
          libglvnd
          # SDL2 and Wayland support for game client
          SDL2
          wayland
          libxkbcommon
          libffi
          # SDL3 and image libraries for game client
          sdl3
          sdl3-image
          libpng
          libjpeg
          libwebp
          # Vulkan support
          vulkan-loader
        ];

        # Build using buildNpmPackage with proper npm deps hash
        hytale-f2p = pkgs.buildNpmPackage {
          inherit pname version;
          src = hytale-f2p-src;

          # To get this hash:
          # 1. Run: nix build with an invalid hash (like pkgs.lib.fakeHash)
          # 2. The error will show the correct hash
          # 3. Replace the hash below with the correct one
          # If you haven't fetched the hash yet, use:
          # npmDepsHash = pkgs.lib.fakeHash;
          npmDepsHash = "sha256-Fu3MBTAKA0JQtMZbz/c/ry6hSwZT0RyoTxhVPRwmvto=";

          # Required for git dependencies in package-lock.json
          forceGitDeps = true;

          nativeBuildInputs = with pkgs; [
            makeWrapper
          ];

          # Skip the build phase - we just want to bundle the app
          dontNpmBuild = true;

          # Use legacy-peer-deps to avoid compatibility issues
          npmFlags = [
            "--legacy-peer-deps"
            "--ignore-scripts"
          ];

          # Make npm cache writable and skip electron binary download
          makeCacheWritable = true;
          env = {
            ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
          };

          installPhase = ''
                        runHook preInstall

                        # Create app directory
                        mkdir -p $out/lib/${pname}
                        cp -r main.js preload.js package.json backend GUI node_modules $out/lib/${pname}/

                        # Copy icon
                        cp icon.png $out/lib/${pname}/

                        # Create .env if needed
                        if [ -f .env ]; then
                          cp .env $out/lib/${pname}/
                        elif [ -f .env.example ]; then
                          cp .env.example $out/lib/${pname}/.env
                        fi

                        # Create wrapper script with environment fixes for Wayland/Hyprland compatibility
                        mkdir -p $out/bin

                        # Create xdg-open wrapper to sanitize environment (fixes "Open Game Location")
                        # Named hytale-xdg-open to avoid conflict with other packages
                        mkdir -p $out/libexec/hytale-f2p
                        echo '#!${pkgs.bash}/bin/bash' > $out/libexec/hytale-f2p/xdg-open
                        echo 'unset LD_LIBRARY_PATH' >> $out/libexec/hytale-f2p/xdg-open
                        echo 'unset GIO_MODULE_DIR' >> $out/libexec/hytale-f2p/xdg-open
                        echo 'unset GDK_BACKEND' >> $out/libexec/hytale-f2p/xdg-open
                        echo 'unset LIBGL_DRIVERS_PATH' >> $out/libexec/hytale-f2p/xdg-open
                        echo 'unset __EGL_VENDOR_LIBRARY_FILENAMES' >> $out/libexec/hytale-f2p/xdg-open
                        echo 'unset GDK_PIXBUF_MODULE_FILE' >> $out/libexec/hytale-f2p/xdg-open
                        echo 'exec ${pkgs.xdg-utils}/bin/xdg-open "$@"' >> $out/libexec/hytale-f2p/xdg-open
                        chmod +x $out/libexec/hytale-f2p/xdg-open

                        makeWrapper ${pkgs.electron}/bin/electron $out/bin/${pname} \
                          --add-flags "$out/lib/${pname}" \
                          --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}" \
                          --set GDK_BACKEND "x11" \
                          --set LIBGL_DRIVERS_PATH "${pkgs.mesa}/lib/dri" \
                          --set __EGL_VENDOR_LIBRARY_FILENAMES "${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json" \
                          --prefix PATH : "$out/libexec/hytale-f2p:${
                            pkgs.lib.makeBinPath [
                              pkgs.pciutils
                            ]
                          }"

                        # Install desktop file
                        mkdir -p $out/share/applications
                        cat > $out/share/applications/Hytale-F2P.desktop << EOF
            [Desktop Entry]
            Type=Application
            Name=Hytale F2P Launcher
            Comment=A modern, cross-platform launcher for Hytale with automatic updates and multi-client support
            Exec=$out/bin/${pname}
            Categories=Game;
            Icon=Hytale-F2P
            Terminal=false
            StartupNotify=true
            EOF

                        # Install icon
                        mkdir -p $out/share/icons/hicolor/512x512/apps
                        cp icon.png $out/share/icons/hicolor/512x512/apps/Hytale-F2P.png

                        runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Hytale F2P Launcher - unofficial Hytale Launcher for free to play with multiplayer support";
            homepage = "https://github.com/amiayweb/Hytale-F2P";
            license = licenses.mit;
            platforms = platforms.linux;
            mainProgram = pname;
          };
        };

      in
      {
        packages = {
          default = hytale-f2p;
        };

        apps = {
          default = flake-utils.lib.mkApp {
            drv = hytale-f2p;
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs =
            with pkgs;
            [
              nodejs
              electron
            ]
            ++ runtimeLibs;

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath runtimeLibs;

          shellHook = ''
            echo "Hytale F2P development environment"
            echo "Run 'npm install' to install dependencies"
            echo "Run 'npm start' to start the application"
          '';
        };
      }
    )
    // {
      # NixOS module for easy integration
      nixosModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        with lib;
        let
          cfg = config.programs.hytale-f2p;
        in
        {
          options.programs.hytale-f2p = {
            enable = mkEnableOption "Hytale F2P Launcher";
          };

          config = mkIf cfg.enable {
            environment.systemPackages = [ self.packages.${pkgs.system}.default ];
          };
        };

      # Home-manager module
      homeManagerModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        with lib;
        let
          cfg = config.programs.hytale-f2p;
        in
        {
          options.programs.hytale-f2p = {
            enable = mkEnableOption "Hytale F2P Launcher";

            package = mkOption {
              type = types.package;
              default = self.packages.${pkgs.system}.default;
              description = "The Hytale F2P Launcher package to use";
            };
          };

          config = mkIf cfg.enable {
            home.packages = [ cfg.package ];
          };
        };
    };
}
