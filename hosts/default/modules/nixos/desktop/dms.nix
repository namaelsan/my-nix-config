{ pkgs, ... }:

{
  programs.dms-shell = {
    enable = true;

    systemd = {
      enable = true; # Systemd service for auto-start
      restartIfChanged = true; # Auto-restart dms.service when dank-material-shell changes
    };
    # settings = {
    #   theme = "dark";
    #   dynamicTheming = true;
    #   # Add any other settings here
    # };
  };

  services.displayManager.dms-greeter = {
    enable = true;
    compositor = {
      name = "niri"; # Required. Can be also "hyprland" or "sway"
      # customConfig = ''
      #   # Optional custom compositor configuration
      # '';
    };

    # Sync your user's DankMaterialShell theme with the greeter. You'll probably want this
    configHome = "/home/namael";

    # Custom config files for non-standard config locations
    # configFiles = [
    #   "/home/namael/.config/DankMaterialShell/settings.json"
    # ];

    # Save the logs to a file
    logs = {
      save = true;
      path = "/tmp/dms-greeter.log";
    };

    # Custom Quickshell Package
    quickshell.package = pkgs.quickshell;
  };
}
