{ pkgs, lib, ... }:

{
  systemd.services.numLockOnTty = {
    wantedBy = [ "display-manager.service" ];
    path = [pkgs.dotool pkgs.coreutils];
    serviceConfig = {
      Type = "simple";
      # /run/current-system/sw/bin/setleds -D +num < "$tty";
      # ExecStartPre = "${pkgs.coreutils}/bin/sleep 0.5"; # Delay of 0.5 seconds
      ExecStart = lib.mkForce (
        pkgs.writeShellScript "numLockOnTty7" ''
          # Wait for SDDM to start (optional delay)
          ${pkgs.coreutils}/bin/sleep 1.5

          # Set the DISPLAY environment variable for tty7
          export DISPLAY=":0"

          # Use dotool to simulate the NumLock key press
          echo key x:Num_Lock | dotool
        ''
      );
    };
  };
}
