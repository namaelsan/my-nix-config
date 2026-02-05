{ inputs, ... }:

{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    enable = true;
    # systemd = {
    #   enable = false; # if you prefer starting from your compositor
    #   target = "graphical-session.target";
    #   environment = [ ];
    # };
    settings = {
      appearance = {
        spacing.scale = 0.8;
        anim.durations.scale = 0.8;
        transparency = {
          enabled = true;
          base = 0.9;
          layers = 0.7;
        };
      };
      bar = {
        persistent = false;
        showOnHover = true;
        clock.showIcon = false;
        tray = {
          background = true;
          recolour = true;
          compact = true;
        };
        status = {
          showBattery = true;
          showAudio = true;
          showLockStatus = true;
          showNetwork = true;
          showWifi = true;
          showBluetooth = true;
        };
      };
      background = {
        visualiser = {
          enabled = true;
          autoHide = true;
        };
      };
      notifs = {
        expire = true;
        defaultExpireTimeout = 8000;
      };
      border = {
        rounding = 8;
        thickness = 6;
      };
      paths.wallpaperDir = "~/Wallpapers";
      services = {
        defaultPlayer = "Spotify";
      };
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = false;
      };
    };
  };
}
