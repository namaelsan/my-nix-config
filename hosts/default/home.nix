{
  config,
  pkgs,
  inputs,
  ...
}:

let
  system = "x86_64-linux";
in
{
  imports = [
    ./user-services.nix
    inputs.zen-nebula.homeModules.default
    ./xdg-home.nix
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
    vscode # text editor
    protonplus # protonge etc. version installer
    rclone # used for mounting dropbox drive
    vesktop # discord with plugins
    keepassxc
    git # version control
    gamescope # tool for starting games in isolated environments
    gamemode # optimize system resources for gameplay
    mangohud # systeminfo hud
    universal-android-debloater # debloat your android device
    telegram-desktop # messaging app
    # spotify installed from flatpak
    android-studio # NOTE: android sdk was installed manually
    vdhcoapp # video download helper coapp
    flutter # flutter programming language sdk
    stremio # watch movies etc from different sources
    font-awesome # font for waybar theme
    syncplay # play video files in sync online
    # qbittorrent # torrent client
    lutris # game launcher/helper
    libreoffice-qt # fos office alternative
    puddletag # mp3 info editor
    cryptomator # encryipt files
    ffmpeg # video and stuff helper tool
    python3 # python programing language support
    prismlauncher # official minecraft launcher
    jetbrains.rider # webdevelopment
    signal-desktop # signal messaging app
    inputs.zen-browser.packages."${system}".default # zen browser
    cemu # wiiu emulator
    ppsspp-sdl # psp emulator
    nodejs_24 # nodejs
    postman # api development env
    prettierd # formatting for various programming languages
    sublime4
  ];

  # RELEVANT: https://github.com/sublimehq/sublime_text/issues/5984
  nixpkgs.config.permittedInsecurePackages = [
    # SOME SUBLIMETEXT EXTENSIONS USE OPENSSL & THEY ARE OLD SO SUBLIMETEXT HAS TO RELY ON AN OLD OPENSSL VERSION THATS EOL
    "openssl-1.1.1w" # REMOVE THIS IF SUBLIMETEXT IS NOT INSTALLED
  ];

  zen-nebula = {
    enable = true;
    profile = "0atmftff.Default"; # add firefox profile name here
  };

  fonts.fontconfig.enable = true;

  programs.git = {
    enable = true;
    userName = "namaelsan";
    userEmail = "x.arybidx@gmail.com";
  };

  # Install librewolf.
  programs.librewolf = {
    enable = true;
  };

  programs.lazydocker.enable = true;

  home.file = {
    ".config/hypr/hyprland.conf".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/hosts/default/dotfiles/hyprland/hyprland.conf;
    ".config/hypr/keybinds.conf".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/hosts/default/dotfiles/hyprland/keybinds.conf;
    ".config/hypr/windowrule.conf".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/hosts/default/dotfiles/hyprland/windowrule.conf;
    ".config/fish/config.fish".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/hosts/default/dotfiles/fish/config.fish;
    ".config/alacritty/alacritty.toml".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/hosts/default/dotfiles/alacritty/alacritty.toml;
    ".config/hypr/hyprlock.conf".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/hosts/default/dotfiles/hyprlock/hyprlock.conf;
    ".config/i3/config".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/hosts/default/dotfiles/i3/config;
    ".Xresources".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/hosts/default/dotfiles/xresources/xresources;
    ".config/picom/picom.conf".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/hosts/default/dotfiles/picom/picom.conf;
    ".config/wal/templates/dunstrc".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/hosts/default/dotfiles/dunst/dunstrc.wal.template;
    ".config/river/init".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/hosts/default/dotfiles/river/init;
    ".config/sublime-text/Packages/User/Preferences.sublime-settings".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/hosts/default/dotfiles/sublimetext4/preferences.sublime-settings;

  };

  home.sessionVariables = {
    EDITOR = "sublime";
  };

  nixpkgs.config = {
    android_sdk.accept_license = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
