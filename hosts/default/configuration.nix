# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ./nvidia.nix
    ./game.nix
    ./services/system-services.nix
    ./nix-ld.nix
    ./network.nix
    # ./xdg-settings/xdg.nix
  ];

  # hyprland communication between apps
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    # config.common.default = [ "hyprland" ];
    # Ensure these packages are installed
    # extraPortals = [ pkgs.xdg-desktop-portal-hyprland ]; # Good fallback/compatibility
    # wlr.enable = true; # Explicitly enable the wlroots-based portal if needed
  };

  hardware.bluetooth.enable = false;
  hardware.i2c.enable = true;
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660", TAG+="uaccess"
  '';

  hardware.tuxedo-drivers.enable = true; # tuxedo keyboard driver

  # default = lts kernel
  boot.kernelPackages = pkgs.linuxPackages_latest; # use latest kernel
  # boot.kernelPackages = pkgs.linuxPackages_cachyos;
  # boot.kernelPackages = pkgs.linuxPackages_lqx; # Liquorix kernel
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot"; # ← use the same mount point here.
    };
    grub = {
      useOSProber = true;
      efiSupport = true;
      #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
      device = "nodev";
    };
  };

  # add swap file
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  programs.direnv.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  services = {
    # displayManager.lightdm.enable = true;
    # displayManager.gdm.enable = true;
    # displayManager.gdm.wayland = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'env WLR_RENDERER=vulkan __GLX_VENDOR_LIBRARY_NAME=mesa GBM_BACKEND=mesa-drm WLR_DRM_DEVICES=/dev/dri/card1 AQ_DRM_DEVICES=/dev/dri/card1 Hyprland'";
          user = "namael";
        };
      };
    };

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3status # gives you the default i3 status bar
          i3lock # default i3 screen locker
          i3blocks # if you are planning on using i3blocks over i3status
        ];
      };
    };

    displayManager.defaultSession = "hyprland-uwsm";
    # displayManager.sddm = {
    #   enable = true;
    #   wayland.enable = true;
    #   settings = {
    #     General = {
    #       Numlock = "on"; # enable numlock on login
    #     };
    #   };
    # };
    desktopManager.plasma6.enable = true;
    # xserver.desktopManager.gnome.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "tr";
      variant = "";
    };
  };

  # programs.coolercontrol = {
  #   enable = true;
  #   nvidiaSupport = true;
  # };
  programs.dconf.enable = true;

  programs.gamescope = {
    enable = true;
    # capSysNice = true;
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  # Enable hyprland
  programs.hyprland = {
    withUWSM = true;
    enable = true;
    # nvidiaPatches = true; #NO LONGER NEEDED DONT ADD BACK
    xwayland.enable = true;
  };
  services.hypridle.enable = true;
  programs.xwayland.enable = true;

  environment.sessionVariables = {
    # somehyprland variables
    # # If cursor becomes invisible ENABLE
    # WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    # WLR_RENDERER = "gles2";
    # # prefer igpu instead of dgpu
    # AQ_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
    # hyprland vars over

    MANGOHUD_CONFIG = "fps_limit=75,no_display";
  };

  # Configure console keymap
  console.keyMap = "trq";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  security.polkit.enable = true; # enable polkit

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

    # set min values to 256 to reduce cracks and pops in audio in cpu intensive situations
    extraConfig.pipewire-pulse."92-low-latency" = {
      "context.properties" = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = { };
        }
      ];
      "pulse.properties" = {
        "pulse.min.req" = "256/48000";
        "pulse.min.quantum" = "256/48000";
        "pulse.min.frag" = "256/48000";
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nix.settings.trusted-users = [
    "root"
    "namael"
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.i2c = { };
  users.users.namael = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Namael";
    extraGroups = [
      "networkmanager"
      "wheel"
      "gamemode"
      "input"
      "docker"
      "video"
      "i2c" # for brightness control
    ];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fish # shell
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    fastfetch # print system info but fast
    ntfs3g # read / mount ntfs
    lshw # hardware info
    ncdu # list files big size
    pstree # process tree
    gparted # gtk partition manager
    gedit # text editor
    qemu # virtualisation tool
    virt-manager # virtual machine manager
    home-manager # home manager for nixos
    vlc # video player
    mpv # video player
    killall # process killer
    zapret # dpi bypasser
    wine # windows compatibility layer
    winetricks # edit wine prefixes
    rar # enables rar compressing
    unrar # enables rar uncompressing
    sqlite # local sql database tool
    jdk # java development kit
    linux-wifi-hotspot # tool for hotspot
    nixfmt-rfc-style # format .nix files
    dotool # simulate key press
    protonvpn-gui # vpn
    heroic # Native GOG, Epic, and Amazon Games Launcher for Linux, Windows and Mac
    inputs.kwin-effects-forceblur.packages.${pkgs.system}.default # forceblur effect for manually setting blur in kde. transparency = blur in selected window classes
    mesa-demos # mesa tools (glxgears glxinfo)
    ddcutil # external monitor brightness
    brightnessctl # laptop display brightness
    devenv # development tool
    nix-output-monitor # pretty build dialog for nix
    btop # process & resource monitor
    powertop # view power consumption etc
    busybox # various unix tools ex: tree pwd ip bc
    gnome-keyring # gnome keyring manager
    intel-gpu-tools
    toybox # for cmdline tool file
    mangohud # hardware info hud ingame
    vulkan-tools

    # hyprland stuff
    gtk3 # for image rendering in waybar
    swayimg # image viewer
    nemo-with-extensions # file manager
    hyprsome # multiple monitor workspace configuration
    waybar # waybar
    glib # gsettings for gtk
    pywal16 # colorcheme creator for wallpaper
    imagemagick # cli image manipulation tools
    mako # notifications
    swww # wallpaper
    kitty # default terminal
    alacritty # pref terminal
    rofi # app launcher
    networkmanagerapplet
    hyprshot # standalone screenshot tool
    libnotify # library to send notification
    wl-clipboard # copy to clipboard wayland
    pavucontrol # sound controls
    clipse # clipbard manager
    hyprlock # lockscreen
    # hyprland stuff over

    # i3 stuff
    autotiling # i3 autotiling script
    polybarFull # status bar
    feh # background
    pamixer # for sound control with pipewire
    xdotool # helper for some window actions
    lightlocker # screenlock for lightdm
    maim # screenshot utility
    dunst # notification manager
    jq # command line json processor
    pantheon.pantheon-agent-polkit # polkit authenticator
    picom # compositor

    # river stuff
    wlr-randr # xrandr for wayland

    # greetd
    tuigreet
  ];

  fonts.packages = with pkgs; [
    fira # fira font family
    jetbrains-mono
    nerd-fonts.symbols-only
  ];

  virtualisation.libvirtd.enable = true;

  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --log-format internal-json --flake /home/namael/nixos/#default &| nom --json";
    nixdiff = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
    "cd.." = "cd ..";
    "cd-" = "cd -";
    hotspot = "sudo create_ap wlo1 enp4s0 MyAccesPoint";
    nixupdate = "cd /home/namael/nixos & nix flake update & cd-";
  };

  # android debugger
  programs.adb.enable = true;

  services = {
    qbittorrent = {
      enable = true;
      user = "namael";
    };

    flatpak.enable = true;

    power-profiles-daemon.enable = true; # has to be disabled to use tlp

    # tlp = {
    #   enable = true;
    #   settings = {
    #     # Set the min/max/turbo frequency for the Intel GPU. Possible values depend on your hardware. See the output of tlp-stat -g for available frequencies.
    #     INTEL_GPU_MIN_FREQ_ON_AC = 500;
    #     INTEL_GPU_MIN_FREQ_ON_BAT = 100;
    #     # INTEL_GPU_MAX_FREQ_ON_AC=0
    #     # INTEL_GPU_MAX_FREQ_ON_BAT=0
    #     # INTEL_GPU_BOOST_FREQ_ON_AC=0
    #     # INTEL_GPU_BOOST_FREQ_ON_BAT=0
    #   };
    # };
  };

  programs.appimage.enable = true;

  # shell
  programs.fish.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "namael" = import ./home.nix;
    };
    # #DONT ENABLE THIS LINE SDDM WONT LOGIN
    # shell = pkgs.fish;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
