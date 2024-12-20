{
  description = "Personal NixOS system configurations";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:NixOS/nixos-hardware;
    disko = {
      url = github:nix-community/disko;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = github:sodiboo/niri-flake;
  };

  outputs = { self, nixpkgs, nixos-hardware, disko, home-manager, niri }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      common = [
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mrbjarksen = import ./home/mrbjarksen.nix;
        }
        niri.nixosModules.niri
        { nixpkgs.overlays = [ niri.overlays.niri ]; programs.niri.enable = true; }
      ];
    in {
      nixosConfigurations.neumann = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = common ++ [
          nixos-hardware.nixosModules.dell-xps-17-9700-nvidia
          ./system/neumann.nix
        ];
      };

      nixosConfigurations.galois = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = common ++ [
          nixpkgs.nixosModules.notDetected
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-cpu-amd-zenpower
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
          ./system/galois.nix
        ];
      };
    };
}
