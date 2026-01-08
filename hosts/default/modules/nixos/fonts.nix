{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    fira # fira font family
    jetbrains-mono
    nerd-fonts.symbols-only
  ];
}
