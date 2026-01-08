{
  config,
  pkgs,
  inputs,
  ...
}:

let
  custom-zen =
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta-unwrapped.overrideAttrs
      (oldAttrs: rec {
        libName = "zen-bin-1.17.15b";
        fsautoconfig = (
          builtins.fetchurl {
            url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
            sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
          }
        );
        configpref = (
          builtins.fetchurl {
            url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/refs/heads/master/program/defaults/pref/config-prefs.js";
            sha256 = "sha256-a/0u0TnRj/UXjg/GKjtAWFQN2+ujrckSwNae23DBfs4=";
          }
        );

        postInstall = (oldAttrs.postInstall or "") + ''
          chmod -R u+w "$out/lib/${libName}"
          cp "${fsautoconfig}" "$out/lib/${libName}/config.js"
          mkdir -p "$out/lib/${libName}/defaults/pref"
          cp "${configpref}" "$out/lib/${libName}/defaults/pref/config-pref.js"
        '';
      });
in
{
  imports = [
    ./packages.nix
    ./programs
    ./services
    ./desktop
    ./xdg.nix
    inputs.zen-browser.homeModules.beta
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "namael";
  home.homeDirectory = "/home/namael";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  # RELEVANT: https://github.com/sublimehq/sublime_text/issues/5984
  nixpkgs.config.permittedInsecurePackages = [
    # SOME SUBLIMETEXT EXTENSIONS USE OPENSSL & THEY ARE OLD SO SUBLIMETEXT HAS TO RELY ON AN OLD OPENSSL VERSION THATS EOL
    "openssl-1.1.1w" # REMOVE THIS IF SUBLIMETEXT IS NOT INSTALLED

    "qtwebengine-5.15.19" # for stremio
  ];

  fonts.fontconfig.enable = true;

  programs.zen-browser = {
    enable = true;
    package = (config.lib.nixGL.wrap ((pkgs.wrapFirefox) custom-zen { }));
  };

  nixpkgs.config = {
    android_sdk.accept_license = true;
  };

  home.sessionVariables = {
    EDITOR = "sublime";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
