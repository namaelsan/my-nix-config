{ pkgs, ... }:

{

  # hyprland communication between apps
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Set default applications
  xdg = {
    mime = {
      enable = true;
      defaultApplications = {
        # "" = [ "" ];

        # Web browser
        "text/html" = [ "zen-beta.desktop" ];
        "x-scheme-handler/http" = [ "zen-beta.desktop" ];
        "x-scheme-handler/https" = [ "zen-beta.desktop" ];

        # Compressed files
        "application/zip" = [ "ark.desktop" ];
        "application/vnd.rar" = [ "ark.desktop" ];

        # Torrent
        "application/x-bittorrent" = [ "deluge.desktop" ];

        # Document
        "application/vnd.oasis.opendocument.txt" = [ "writer.desktop" ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "impress" ];
        "application/vnd.ms-excel" = [ "calc.desktop" ];


        # PDF viewer
        "application/pdf" = [ "zen-beta.desktop" ];

        # Image viewer
        "image/png" = [ "swayimg.desktop" ];
        "image/jpeg" = [ "swayimg.desktop" ];
        "image/webp" = [ "swayimg.desktop" ];
        "image/svg+xml" = [ "swayimg.desktop" ];

        # Video player
        "video/mp4" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "application/vnd.apple.mpegurl" = [ "mpv.desktop" ]; # m3u8 files

        # Email client
        # "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      };
    };
  };
}
