{
  description = "Personal NixOS system configurations";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    # nixpkgs.url = github:NixOS/nixpkgs/nixos-24.11;
    nixos-hardware.url = github:NixOS/nixos-hardware;
    disko = {
      url = github:nix-community/disko;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager;
      # url = github:nix-community/home-manager/release-24.11;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = github:sodiboo/niri-flake;
    catppuccin.url = github:catppuccin/nix;

    ssbm-nix = {
      url = github:mrbjarksen/ssbm-nix;
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, disko, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        # overlays = [
        #   inputs.niri.overlays.niri
        #   inputs.ssbm-nix.overlay
        # ];
      };
      common = [
        {
          nixpkgs.overlays = [
            inputs.niri.overlays.niri
            inputs.ssbm-nix.overlays.ssbm-nix
          ];
        }
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mrbjarksen = {
            imports = [
              ./home/mrbjarksen.nix
              inputs.catppuccin.homeModules.catppuccin
              inputs.ssbm-nix.homeModules.ssbm-nix
            ];
          };
        }
        inputs.niri.nixosModules.niri
        { programs.niri.enable = true; }
        inputs.catppuccin.nixosModules.catppuccin
      ];
    in {
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
          # nixos-hardware.nixosModules.common-cpu-amd-zenpower
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
          ./system/galois.nix
        ];
      };
    };
}
