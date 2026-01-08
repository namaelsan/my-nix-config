{ pkgs, inputs, ... }:

{
  # Core system packages
  environment.systemPackages = with pkgs; [
    fish # shell
    wget
    ntfs3g # read / mount ntfs
    lshw # hardware info
    home-manager # home manager for nixos
    killall # process killer
    nixfmt-rfc-style # format .nix files
    nix-output-monitor # pretty build dialog for nix
    busybox # various unix tools ex: tree pwd ip bc
    toybox # for cmdline tool file
    inputs.nix-alien.packages.${system}.nix-alien
  ];
}
