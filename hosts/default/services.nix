{ pkgs, ...}:

{
  systemd.services.rclone = {
    description = "rclone command for mounting a dropbox remote to documents";
    path = with pkgs; [ rclone ];
    serviceConfig.PassEnvironment = "DISPLAY";
    script = " mount.rclone dropbox: /home/namael/Documents/dropbox/";

  };
}
