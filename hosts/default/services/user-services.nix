{ pkgs, ... }:

{
  systemd.user.services = {
    rclone-sync = {
      Service = {
        WorkingDirectory = "/home/namael/";
        KillSignal = "SIGTERM"; # Sends SIGTERM when stopping or killing the service
        KillMode = "mixed"; # Ensures the signal propagates to child processes
        ExecStart = "${pkgs.rclone}/bin/rclone mount dropbox: /home/namael/Documents/dropbox/ --config /home/namael/.config/rclone/rclone.conf";
        # Retry every 5 seconds if the mount fails
        Restart = "always";
        RestartSec = "30s";
      };
      Unit = {
        Description = "Rclone Sync Service"; # Set the description here
      };
      Install = {
        WantedBy = [ "graphical-session.target" ]; # Starts the service at graphical session
      };
    };
  };

  nix.gc = {
    automatic = true;
    dates = "daily"; # every 3 days
    persistent = true;
    options = "--delete-older-than 3d";
  };
  nix.settings.auto-optimise-store = true;
}
