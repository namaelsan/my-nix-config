{ ... }:

{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };

    # Configure keymap in X11
    xkb = {
      layout = "tr";
      variant = "";
    };
  };

  services.displayManager.defaultSession = "hyprland-uwsm";
  # services.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  #   settings = {
  #     General = {
  #       Numlock = "on"; # enable numlock on login
  #     };
  #   };
  # };
}
