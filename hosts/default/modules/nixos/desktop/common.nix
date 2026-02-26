{ ... }:

{
  # Polkit for authentication
  security.polkit.enable = true;

  # GNOME keyring
  services.gnome.gnome-keyring.enable = true;

  # CUPS printing
  services.printing.enable = true;
}
