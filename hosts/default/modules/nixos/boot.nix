{ pkgs, inputs, ... }:

{
  # Kernel configuration
  # default = lts kernel
  boot.kernelPackages = pkgs.linuxPackages_6_18; # use latest kernel
  # boot.kernelPackages = pkgs.linuxPackages_latest; # use latest kernel
  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  # nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  # Binary cache
  nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  nixpkgs.overlays = [
              # Use the exact kernel versions as defined in this repo.
              # Guarantees you have binary cache.
              inputs.nix-cachyos-kernel.overlays.pinned

              # Alternatively, build the kernels on top of nixpkgs version in your flake.
              # This might cause version mismatch/build failures!
              # nix-cachyos-kernel.overlays.default

              # Only use one of the two overlays!
            ];

  # Bootloader configuration
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

  # Swap configuration
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
}
