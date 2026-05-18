{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    fira # fira font family
    jetbrains-mono
    nerd-fonts.symbols-only
    font-awesome # font for waybar theme
    vista-fonts
    corefonts
  ];
}
