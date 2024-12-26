{ pkgs, ... }:

{
  systemd.user.services = {
  rclone-sync = {
      Service = {
        WorkingDirectory = "/home/namael/";
        KillSignal = "SIGTERM";          # Sends SIGTERM when stopping or killing the service
        KillMode = "mixed";              # Ensures the signal propagates to child processes
        ExecStart = "${pkgs.rclone}/bin/rclone mount dropbox: /home/namael/Documents/dropbox/ --config /home/namael/.config/rclone/rclone.conf";
      };
      Unit = {
        Description = "Rclone Sync Service"; # Set the description here
      };
      Install = {
        WantedBy = ["default.target"]; # Starts the service at login
      };
    };
  };
}