{ pkgs, inputs, ... }:

{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    vscode # text editor
    protonplus # protonge etc. version installer
    rclone # used for mounting dropbox drive
    keepassxc
    git # version control
    universal-android-debloater # debloat your android device
    telegram-desktop # messaging app
    discord
    # spotify installed from flatpak
    android-studio # NOTE: android sdk was installed manually
    flutter # flutter programming language sdk
    # stremio # watch movies etc from different sources
    # inputs.nixohess.packages.${pkgs.system}.stremio-linux-shell
    font-awesome # font for waybar theme
    syncplay # play video files in sync online
    qbittorrent # torrent client
    lutris # game launcher/helper
    libreoffice-qt # fos office alternative
    puddletag # mp3 info editor
    cryptomator # encryipt files
    ffmpeg # video and stuff helper tool
    python3 # python programing language support
    prismlauncher # official minecraft launcher
    inputs.hyprism.packages.${system}.default # hytale launcher with local defined flake
    jetbrains.rider # webdevelopment
    signal-desktop # signal messaging app
    cemu # wiiu emulator
    ppsspp-sdl # psp emulator
    nodejs_24 # nodejs
    postman # api development env
    prettierd # formatting for various programming languages
    element-desktop
    lsfg-vk # framegen
    lsfg-vk-ui
    antigravity
  ];
}
