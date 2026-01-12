{ config, ... }:

{
  home.file = {
    ".config/hypr/hyprland.conf".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/dotfiles/hyprland/hyprland.conf;
    ".config/hypr/keybinds.conf".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/dotfiles/hyprland/keybinds.conf;
    ".config/hypr/windowrule.conf".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/dotfiles/hyprland/windowrule.conf;
    ".config/fish/config.fish".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/dotfiles/fish/config.fish;
    ".config/alacritty/alacritty.toml".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/dotfiles/alacritty/alacritty.toml;
    ".config/hypr/hyprlock.conf".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/dotfiles/hyprlock/hyprlock.conf;
    ".config/i3/config".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/dotfiles/i3/config;
    ".Xresources".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/dotfiles/xresources/xresources;
    ".config/picom/picom.conf".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/dotfiles/picom/picom.conf;
    ".config/wal/templates/dunstrc".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/dotfiles/dunst/dunstrc.wal.template;
    ".config/river/init".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/dotfiles/river/init;
    ".config/sublime-text/Packages/User/Preferences.sublime-settings".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/dotfiles/sublimetext4/preferences.sublime-settings;
    ".config/matugen/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/dotfiles/matugen/config.conf;
    ".config/wofi/config".source =
      config.lib.file.mkOutOfStoreSymlink /home/namael/nixos/dotfiles/wofi/config;
  };
}
