{ pkgs, ... }:

{
  # Install steam

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    gamescopeSession.enable = true;
  };

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  hardware = {
    opengl.enable = true;
    xpadneo.enable = true; # controller in xbox one mode
  };
}
