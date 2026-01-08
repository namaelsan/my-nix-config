{ ... }:

{
  # Enable hyprland
  programs.hyprland = {
    withUWSM = true;
    enable = true;
    # nvidiaPatches = true; #NO LONGER NEEDED DONT ADD BACK
    xwayland.enable = true;
  };
  services.hypridle.enable = true;
  programs.xwayland.enable = true;

  environment.sessionVariables = {
    # somehyprland variables
    # # If cursor becomes invisible ENABLE
    # WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    # WLR_RENDERER = "gles2";
    # # prefer igpu instead of dgpu
    # AQ_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
    # hyprland vars over

    MANGOHUD_CONFIG = "fps_limit=75,no_display";
  };
}
