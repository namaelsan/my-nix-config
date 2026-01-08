{ inputs, ... }:

{
  imports = [
    ./boot.nix
    ./locale.nix
    ./users.nix
    ./nix-settings.nix
    ./audio.nix
    ./programs.nix
    ./fonts.nix
    ./virtualisation.nix
    ./nix-ld.nix
    ./shell-aliases.nix
    ./hardware
    ./desktop
    ./networking
    ./gaming
    ./packages
    ./services
  ];
}
