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
        Restart = "on-failure";
        RestartSec = "5s";
      };
      Unit = {
        Description = "Rclone Sync Service"; # Set the description here
      };
      Install = {
        WantedBy = [ "graphical-session.target" ]; # Starts the service at graphical session
      };
    };
  };
}
