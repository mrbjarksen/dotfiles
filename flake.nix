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
  };

  outputs = { self, nixpkgs, nixos-hardware, disko, home-manager, niri, catppuccin }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      common = [
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mrbjarksen = {
            imports = [
              ./home/mrbjarksen.nix
              catppuccin.homeModules.catppuccin
            ];
          };
        }
        niri.nixosModules.niri
        { nixpkgs.overlays = [ niri.overlays.niri ]; programs.niri.enable = true; }
        catppuccin.nixosModules.catppuccin
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
