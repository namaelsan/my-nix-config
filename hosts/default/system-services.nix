{ pkgs, lib, ... }:

{
  systemd.services.numLockOnTty = {
    wantedBy = [ "default.target" ];
    serviceConfig = {
      # /run/current-system/sw/bin/setleds -D +num < "$tty";
      # ExecStartPre = "${pkgs.coreutils}/bin/sleep 0.5"; # Delay of 0.5 seconds
      ExecStart = lib.mkForce (
        pkgs.writeShellScript "numLockOnTty" ''
          ${pkgs.coreutils}/bin/echo 'key x:Num_Lock' | ${pkgs.dotool}/bin/dotool
        ''
      );
    };
  };
}
