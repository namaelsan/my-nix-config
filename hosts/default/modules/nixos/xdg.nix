{ pkgs, ... }:

{

  # hyprland communication between apps
  # xdg.portal.config.common.default = [ "gtk" ]; # Tells portals to use GTK for opening files/folders
  # xdg.portal.config.hyprland.default = [ "hyprland" "gtk" ]; # Tells portals to use GTK for opening files/folders
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      common.default = [ "gnome" ];
    };
  };


  # Set default applications
  xdg = {
    mime = {
      enable = true;
      defaultApplications = {
        # "" = [ "" ];

        # File Manager
        "inode/directory" = "nemo.desktop";

        # Web browser
        "text/html" = [ "zen-beta.desktop" ];
        "x-scheme-handler/http" = [ "zen-beta.desktop" ];
        "x-scheme-handler/https" = [ "zen-beta.desktop" ];

        # Compressed files
        "application/zip" = [ "ark.desktop" ];
        "application/vnd.rar" = [ "ark.desktop" ];

        # Torrent
        "application/x-bittorrent" = [ "org.qbittorrent.qBittorrent.desktop" ];

        # Document
        "application/vnd.oasis.opendocument.txt" = [ "writer.desktop" ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "impress" ];
        "application/vnd.ms-excel" = [ "calc.desktop" ];
        "text/plain" = ["org.gnome.gedit.desktop"];


        # PDF viewer
        "application/pdf" = [ "zen-beta.desktop" ];

        # Image viewer
        "image/png" = [ "swayimg.desktop" ];
        "image/jpeg" = [ "swayimg.desktop" ];
        "image/webp" = [ "swayimg.desktop" ];
        "image/svg+xml" = [ "swayimg.desktop" ];

        # Video player
        "video/mp4" = [ "mpv.desktop" ];
        "video/quicktime" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "application/vnd.apple.mpegurl" = [ "mpv.desktop" ]; # m3u8 files

        # Email client
        # "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      };
    };
  };
}
