{ ... }:

{
  fileSystems."/home/namael/Games" = {
    device = "/dev/disk/by-uuid/5ea0a5e2-6aa2-4926-9584-20b872792d48";
    fsType = "ext4"; # or whatever blkid reported
    options = [
      "defaults"
      "nofail"
      "rw"
    ];
  };
}
