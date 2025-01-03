
{ config, pkgs, ... }:


{
  imports = [
      ./services.nix
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    vscode
    protonplus
    rclone
    vesktop
    keepassxc
    git
    steam
    gamescope
    gamemode
    mangohud
    universal-android-debloater
    telegram-desktop
    spotify
    android-studio # NOTE: android sdk was installed manually
    vdhcoapp # video download helper coapp
    flutter
    stremio
    font-awesome
    syncplay
    qbittorrent
    lutris
  ];

  fonts.fontconfig.enable =  true;

  programs.git = {
    enable = true;
    userName = "namaelsan";
    userEmail = "x.arybidx@gmail.com";
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/hosts/default/dotfiles/hyprland/hyprland.conf;
  };

  home.sessionVariables = {
    EDITOR = "code";
  };

  nixpkgs.config = {
    android_sdk.accept_license = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
