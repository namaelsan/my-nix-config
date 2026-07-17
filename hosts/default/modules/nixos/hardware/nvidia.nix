{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_EnableGpuFirmware=0" # gpu sdp disabled
  ];
  boot.extraModprobeConfig = ''
    options nvidia NVreg_RegistryDwords="RMUseSwI2c=0x01;RMI2cSpeed=100"
  '';

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      nvidia-vaapi-driver
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
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.production;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  # Nvidia Buffer Pool Fix
  # There is a known memory management bug where Wayland compositors fail to properly return freed buffers to the Nvidia driver, leading to stuttering during window animations. Niri's official documentation highly recommends patching this
  environment.etc."nvidia/nvidia-application-profiles-rc.d/50-niri-buffer-fix.json".text = ''
    {
        "rules": [
            {
                "pattern": { "feature": "procname", "matches": "niri" },
                "profile": "Limit Free Buffer Pool On Wayland Compositors"
            }
        ],
        "profiles": [
            {
                "name": "Limit Free Buffer Pool On Wayland Compositors",
                "settings": [ { "key": "GLVidHeapReuseRatio", "value": 0 } ]
            }
        ]
    }
  '';
}
