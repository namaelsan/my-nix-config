{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    tuxedopkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up to date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tuxedo-nixos = {
      url = "github:sund3RRR/tuxedo-nixos";
      inputs.nixpkgs.follows = "tuxedopkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-nebula = {
      url ="github:JustAdumbPrsn/Nebula-A-Minimal-Theme-for-Zen-Browser";
      inputs.nixpkgs.follows = "nixpkgs";
      };

  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/default/configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.tuxedo-nixos.nixosModules.default
          {
            hardware.tuxedo-control-center.enable = true;
            hardware.tuxedo-control-center.package = inputs.tuxedo-nixos.packages.x86_64-linux.default;
          }
        ];
      };
    };
}
