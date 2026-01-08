{ pkgs, lib, ... }:

{
  systemd.services.numLockOnTty = {
    wantedBy = [ "display-manager.service" ];
    path = [
      pkgs.dotool
      pkgs.coreutils
    ];
    serviceConfig = {
      Type = "simple";
      # /run/current-system/sw/bin/setleds -D +num < "$tty";
      # ExecStartPre = "${pkgs.coreutils}/bin/sleep 0.5"; # Delay of 0.5 seconds
      ExecStart = lib.mkForce (
        pkgs.writeShellScript "numLockOnTty7" ''
          # Wait for SDDM to start (optional delay)
          ${pkgs.coreutils}/bin/sleep 2

          # Set the DISPLAY environment variable for tty7
          export DISPLAY=":0"

          # Use dotool to simulate the NumLock key press
          echo key x:Num_Lock | dotool
        ''
      );
    };
  };

  nix.gc = {
    automatic = true;
    # dates = "*-*-1/3 03:00:00"; # every 3 days
    dates = "daily";
    persistent = true;
    options = "--delete-older-than 3d";
  };
  nix.settings.auto-optimise-store = true;
}
