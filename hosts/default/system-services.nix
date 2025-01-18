{ pkgs, ... }:

{
  systemd.services.enableNumlock = {
    enable = true;
    description = "Enable NumLock on TTY2 at boot";
    after = [ "sysinit.target" ];  # Ensure it runs after the system initializes
    wantedBy = [ "multi-user.target" ]; # Run in multi-user mode

    serviceConfig = {
      ExecStart = "/usr/bin/setleds +num < /dev/tty2";
      Type = "oneshot"; # Run the command once
      StandardInput = "tty"; # Required for `setleds` to work with TTY
    };
  };
}
