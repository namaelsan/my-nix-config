{ inputs, pkgs, ... }:

{
  imports = [ inputs.hytale-f2p.homeManagerModules.default ];
  
  # programs.hytale-f2p.enable = true;

  home.packages = with pkgs; [
    # inputs.deadlock-mod-manager.packages.${pkgs.system}.default
  ];
}
