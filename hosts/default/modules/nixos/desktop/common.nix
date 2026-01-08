{ ... }:

{
  # Communication between apps
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    # config.common.default = [ "hyprland" ];
    # Ensure these packages are installed
    # extraPortals = [ pkgs.xdg-desktop-portal-hyprland ]; # Good fallback/compatibility
    # wlr.enable = true; # Explicitly enable the wlroots-based portal if needed
  };

  # Polkit for authentication
  security.polkit.enable = true;

  # GNOME keyring
  services.gnome.gnome-keyring.enable = true;

  # CUPS printing
  services.printing.enable = true;
}
