{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    nix-alien.url = "github:thiagokokada/nix-alien";

    matugen = {
      url = "github:/InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixohess.url = "gitlab:fazzi/nixohess";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up to date or simply don't specify the nixpkgs input
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sls-steam = {
    #   url = "github:AceSLS/SLSsteam";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    tuxedopkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    tuxedo-nixos = {
      url = "github:sund3RRR/tuxedo-nixos";
      inputs.nixpkgs.follows = "tuxedopkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/default/configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.tuxedo-nixos.nixosModules.default
          inputs.stylix.nixosModules.stylix
          # inputs.chaotic.nixosModules.default
          {
            hardware.tuxedo-control-center.enable = true;
            hardware.tuxedo-control-center.package = inputs.tuxedo-nixos.packages.x86_64-linux.default;
          }
        ];
      };
    };
}
