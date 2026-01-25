{ pkgs, ... }:

{
  # CLI tools and utilities
  environment.systemPackages = with pkgs; [
    fastfetch # print system info but fast
    ncdu # list files big size
    pstree # process tree
    btop # process & resource monitor
    powertop # view power consumption etc
    ddcutil # external monitor brightness
    brightnessctl # laptop display brightness
    mesa-demos # mesa tools (glxgears glxinfo)
    vulkan-tools
    intel-gpu-tools
    wl-clipboard # copy to clipboard wayland
    imagemagick # cli image manipulation tools
    devenv # development tool
    jq
    gettext
    baobab # gnome disk usage analyzer
    android-tools # adb
  ];
}
