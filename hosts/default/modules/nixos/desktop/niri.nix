{ pkgs, ... }:

{
  programs.niri.enable = true;
  # programs.regreet = {
  #   enable = true;
  #   theme.name = "adw-gtk3"; # or "Adwaita"
  #   font = {
  #     name = "Cantarell";
  #     size = 16;
  #   };
  #   cursorTheme.name = "Adwaita";
  #   cageArgs = [
  #     "-s"
  #     "-m"
  #     "last"
  #   ]; # -s = single output, -m last = last connected monitor
  # };

  environment.systemPackages = with pkgs; [
    xwayland-satellite # for stuff to work with xwayland niri
  ];
}
