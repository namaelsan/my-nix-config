{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-alien.url = "github:thiagokokada/nix-alien";

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      # Do not override its nixpkgs input, otherwise there can be mismatch between patches and kernel version
    };

    matugen = {
      url = "github:/InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprism = {
      url = "path:/home/namael/nixos/hosts/default/flakes/hyprism";
    };

    hytale-f2p = {
      url = "path:/home/namael/nixos/hosts/default/flakes/hytale-f2p";
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
    # kwin-effects-forceblur = {
    #   url = "github:taj-ny/kwin-effects-forceblur";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    sls-steam = {
      url = "github:AceSLS/SLSsteam";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixflix = {
      url = "github:kiriwalawren/nixflix";
      # url = "path:/home/namael/nixflix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tuxedo-nixos = {
      url = "github:sund3RRR/tuxedo-nixos";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-cowork-service.url = "github:patrickjaja/claude-cowork-service";

    deadlock-mod-manager = {
      url = "github:deadlock-mod-manager/deadlock-mod-manager";
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
          ./hosts/default/default.nix
          inputs.home-manager.nixosModules.default
          inputs.tuxedo-nixos.nixosModules.default
          inputs.nixflix.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          {
            hardware.tuxedo-control-center.enable = true;
            hardware.tuxedo-control-center.package = inputs.tuxedo-nixos.packages.x86_64-linux.default;

            sops.secrets = {
              "sonarr/api_key" = { };
              "sonarr/password" = { };
              "radarr/api_key" = { };
              "radarr/password" = { };
              "prowlarr/api_key" = { };
              "prowlarr/password" = { };
              "jellyfin/api_key" = { };
              "jellyfin/admin_password" = { };
              "jellyseerr/api_key" = { };
            };

            sops.defaultSopsFile = ./secrets/secrets.yaml;
            sops.age.keyFile = "/home/namael/.config/sops/age/keys.txt";
          }
        ];
      };
    };
}
