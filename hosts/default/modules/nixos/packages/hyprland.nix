{ pkgs, inputs, ... }:

{
  # Hyprland and wayland-related packages
  environment.systemPackages = with pkgs; [
    # hyprland stuff
    gtk3 # for image rendering in waybar
    swayimg # image viewer
    nemo-with-extensions # file manager
    hyprsome # multiple monitor workspace configuration
    waybar # waybar
    glib # gsettings for gtk
    gsettings-desktop-schemas # for using themes
    pywal16 # colorcheme creator for wallpaper
    inputs.matugen.packages.${system}.default # colorscheme generator with dark&light mode
    mako # notifications
    swww # wallpaper
    kitty # default terminal
    alacritty # pref terminal
    rofi # app launcher
    fuzzel
    networkmanagerapplet
    hyprshot # standalone screenshot tool
    libnotify # library to send notification
    pavucontrol # sound controls
    clipse # clipbard manager
    hyprlock # lockscreen
    wlogout # logout menu
    # hyprland stuff over

    # # i3 stuff
    # autotiling # i3 autotiling script
    # polybarFull # status bar
    # feh # background
    # pamixer # for sound control with pipewire
    # xdotool # helper for some window actions
    # lightlocker # screenlock for lightdm
    # maim # screenshot utility
    # dunst # notification manager
    # jq # command line json processor
    # picom # compositor

    # river stuff
    wlr-randr # xrandr for wayland
  ];
}
