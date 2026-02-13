{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./packages.nix
    ./programs
    ./services
    ./desktop
    # ./xdg.nix
    ./gaming
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
    # # SOME SUBLIMETEXT EXTENSIONS USE OPENSSL & THEY ARE OLD SO SUBLIMETEXT HAS TO RELY ON AN OLD OPENSSL VERSION THATS EOL
    # "openssl-1.1.1w" # REMOVE THIS IF SUBLIMETEXT IS NOT INSTALLED

    "qtwebengine-5.15.19" # for stremio
  ];

  fonts.fontconfig.enable = true;

  programs.zen-browser = {
    enable = true;
    profiles."jj9242nc.Default (release)" = {
      sine.enable = true;
    };
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
