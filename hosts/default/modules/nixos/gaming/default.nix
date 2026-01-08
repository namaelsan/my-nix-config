{ pkgs, ... }:

{
  imports = [
    ./steam.nix
    ./performance.nix
  ];

  programs.gamescope = {
    enable = true;
    capSysNice = false;
    # package = inputs.nixpkgs-gamescope.legacyPackages.${pkgs.system}.gamescope;
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  hardware = {
    xpadneo.enable = true; # controller in xbox one mode
  };
}
