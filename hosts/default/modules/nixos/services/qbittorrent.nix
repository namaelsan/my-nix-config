{ config, lib, ... }:

{
  services.qbittorrent = {
    enable = true;
  };

  # # nixflix forces the user attributes, dropping `home` and `createHome`.
  # # This restores them so qbittorrent can write to its dataDir.
  # users.users.qbittorrent = lib.mkForce {
  #   home = "/var/lib/qbittorrent";
  #   createHome = true;
  #   group = "media";
  #   isSystemUser = true;
  #   uid = 70; # hardcoded in nixflix to 70
  # };
}
