{ pkgs, config, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'uwsm start hyprland.desktop'";
        # command = "${config.programs.niri.package}/bin/niri-session";
        # user = "namael";
      };
    };
  };

  security.pam.services.greetd = {
    enableGnomeKeyring = true;
  };
}
