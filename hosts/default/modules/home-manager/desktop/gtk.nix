{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    gtk4.extraCss = "@import url(\"file:///home/namael/.config/gtk-4.0/colors.css\");";
    gtk3.extraCss = "@import url(\"file:///home/namael/.config/gtk-3.0/colors.css\");";
  };
}
