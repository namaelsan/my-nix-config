{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{

  # specialisation = {
  #   docked-mode.configuration = {
  #     system.nixos.tags = [ "docked-mode" ];
  #     hardware.nvidia = { 
  #       prime = {
  #         sync.enable = lib.mkForce true;
  #         offload = {
  #           enable = lib.mkForce false;
  #           enableOffloadCmd = lib.mkForce false;
  #         };
  #       };
  #       # Sync mode keeps the GPU awake, so we must disable finegrained power management
  #       # to prevent it from trying to turn the card off.
  #       powerManagement.finegrained = lib.mkForce false;
  #     };
  #   };
  # };
  boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" ];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [
    "nvidia"
    "modesetting"
  ];

  hardware.nvidia = {

    prime = {
      # sync.enable = true;
      offload = {
        enable = true;
        enableOffloadCmd = true; # run stuff prefixed with nvidia-offload
      };
      # Make sure to use the correct Bus ID values for your system!
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
    };

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
