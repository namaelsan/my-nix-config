{ pkgs,... }:

{
  # Enable Udisks2 (the actual mounting service)
  services.udisks2.enable = true;

  # Enable GVFS (allows Nemo to manage trash, mount external drives, etc.)
  services.gvfs.enable = true;

  # Ensure you have a Polkit agent running (required for permissions).
  # You likely already have one if you are running Niri, but just in case:
  security.polkit.enable = true;

  # Add udiskie to your system packages
  environment.systemPackages = with pkgs; [
    udiskie
    # ... your other packages
  ];
}
