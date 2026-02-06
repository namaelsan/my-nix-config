{ pkgs, ... }:

{
  gtk = {
    enable = true;

    cursorTheme = {
      name = "Breeze-cursors";
      package = pkgs.breeze-hacked-cursor-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3 = {
      theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };

    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
  };

  # home.sessionVariables = {
  #   GTK_THEME = "adw-gtk3-dark";
  # };

  home.packages = with pkgs; [
    # glib # gsettings for gtk
    # gsettings-desktop-schemas # for using themes
  ];
}
