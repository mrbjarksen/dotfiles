{
  description = "Personal NixOS system configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";

    slippi = {
      url = "github:mrbjarksen/slippi-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, disko, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      overlays = [
        inputs.niri.overlays.niri
        inputs.slippi.overlays.slippi
        (final: prev: {
          bscpylgtv = pkgs.callPackage ./packages/bscpylgtv.nix {}; 
          cormorant = pkgs.callPackage ./packages/cormorant.nix {}; 
        })
      ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };
      common = [
        { nixpkgs.overlays = overlays; }
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hmbkp";
          home-manager.users.mrbjarksen = {
            imports = [
              ./home/mrbjarksen.nix
              inputs.catppuccin.homeModules.catppuccin
              { catppuccin.firefox.profiles = nixpkgs.lib.mkForce { }; }
              inputs.slippi.homeModules.slippi
            ];
          };
        }
        inputs.nix-index-database.nixosModules.default
        {
          programs.nix-index.enable = true;
          programs.nix-index-database.comma.enable = true;
        }
        inputs.niri.nixosModules.niri
        {
          programs.niri.enable = true;
          programs.niri.package = pkgs.niri-unstable;
        }
        inputs.catppuccin.nixosModules.catppuccin
      ];
    in
    {
      packages.${system}.bscpylgtv = pkgs.callPackage ./packages/bscpylgtv.nix {};

      nixosConfigurations.neumann = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = common ++ [
          nixos-hardware.nixosModules.dell-xps-17-9700-nvidia
          ./system/neumann.nix
        ];
      };

      nixosConfigurations.galois = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = common ++ [
          nixpkgs.nixosModules.notDetected
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
          ./system/galois.nix
        ];
      };
    };
}
