# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./nvidia.nix
      #./game.nix
    ];

  programs.ssh.askPassword = lib.mkForce "/nix/store/awb6dzl5kcwi2910frjcw0b96988fp2b-ksshaskpass-6.2.4/bin/ksshaskpass";

  # default = lts kernel
  # boot.kernelPackages = pkgs.linuxPackages_latest; # use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_lqx; # Liquorix kernel
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
    swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 16*1024;
  } ];


  programs.direnv.enable = true;
  networking.hostName = "nixos-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    wifi.scanRandMacAddress = false;
  };

  networking.firewall.allowedTCPPorts = [ 29549 57621 ];  # Replace PORT_NUMBER with qBittorrent's port.

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
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    xserver.enable = false;

    # Enable the KDE Plasma Desktop Environment.
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      settings = {
        General = {
          Numlock = "on"; # enable numlock on login
        };
      };
    };
    desktopManager.plasma6.enable = true;
    xserver.desktopManager.gnome.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "tr";
      variant = "";
    };
  };

  # Enable hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    # somehyprland variables
    # # If cursor becomes invisible ENABLE
    # WLR_NO_HARDWARE_CURSORS = "1";
    # # Hint electron apps to use wayland
    # NIXOS_OZONE_WL = "1";
    # hyprland vars over
  };


  # Configure console keymap
  console.keyMap = "trq";

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.namael = {
    isNormalUser = true;
    description = "Namael";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  programs.steam.enable = true;
  programs.gamescope.enable = true;

  # Install firefox.
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = with pkgs; [ vdhcoapp ];
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
    nixpkgs-fmt # format .nix files
    libinput

    # hyprland stuff
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    }))
    pywal # colorcheme creator for wallpaper
    mako # notifications
    swww # wallpaper
    kitty # default terminal
    alacritty # pref terminal
    rofi-wayland # app launcher
    networkmanagerapplet
    grim # screenshot
    slurp # select from screenshot
    wl-clipboard # copy to clipboard wayland
    # hyprland stuff over
  ];


  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  virtualisation.libvirtd.enable = true;

  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /home/namael/nixos/#default";
    nixdiff = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
    "cd.." = "cd ..";
    "cd-" = "cd -";
    hotspot = "sudo create_ap wlo1 enp4s0 MyAccesPoint";
  };

  services.zapret.enable = true;
  services.zapret.params = ["--dpi-desync=fake --dpi-desync-ttl=3"];

  # android debugger
  programs.adb.enable = true;

  services.flatpak.enable = true;

  # shell
  programs.fish.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
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
