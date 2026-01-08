{ pkgs, inputs, ... }:

{
  # Desktop applications
  environment.systemPackages = with pkgs; [
    gparted # gtk partition manager
    gedit # text editor
    qemu # virtualisation tool
    virt-manager # virtual machine manager
    vlc # video player
    mpv # video player
    zapret # dpi bypasser
    wine # windows compatibility layer
    winetricks # edit wine prefixes
    rar # enables rar compressing
    unrar # enables rar uncompressing
    sqlite # local sql database tool
    jdk # java development kit
    # linux-wifi-hotspot # tool for hotspot ## doesnt build?
    dotool # simulate key press
    protonvpn-gui # vpn
    heroic # Native GOG, Epic, and Amazon Games Launcher for Linux, Windows and Mac
    inputs.kwin-effects-forceblur.packages.${pkgs.system}.default # forceblur effect for manually setting blur in kde
    mangohud # hardware info hud ingame
    gnome-keyring # gnome keyring manager
  ];
}
