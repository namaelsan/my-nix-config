{ pkgs, ...}:

{
  # systemd.services.rclone = {
  #   enable = true;
  #   description = "rclone command for mounting a dropbox remote to documents";
  #   path = with pkgs; [ rclone ];
  #   serviceConfig.PassEnvironment = "DISPLAY";
  #   script = " mount.rclone dropbox: /home/namael/Documents/dropbox/";

  # };

  systemd.services."rclone-sync" = {
    enable = true;
    description = "Rclone Sync Service";
    wantedBy = ["default.target"]; # user service
    path  = with pkgs; [ rclone getent ];
    serviceConfig = {
      RemainAfterExit = true;
      WorkingDirectory = "/home/namael/";
    };

    script = "rclone mount dropbox: /home/namael/Documents/dropbox/ --config /home/namael/.config/rclone/rclone.conf";

  };

}
