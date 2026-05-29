{ pkgs, ... }:

{
  # Install librewolf.
  programs.librewolf = {
    enable = true;
  };

  home.packages = with pkgs; [
    google-chrome
  ];
}
