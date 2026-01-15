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
    niri = {
      url = github:sodiboo/niri-flake;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = github:catppuccin/nix;

    slippi = {
      url = github:mrbjarksen/slippi-flake;
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
          winetricks = nixpkgs.legacyPackages.${system}.winetricks.overrideAttrs (final: prev: {
            patches = [
              (pkgs.fetchpatch {
                # make WINE_BIN and WINESERVER_BIN overridable
                # see https://github.com/NixOS/nixpkgs/issues/338367
                url = "https://github.com/Winetricks/winetricks/commit/1d441b422d9a9cc8b0a53fa203557957ca1adc44.patch";
                hash = "sha256-AYXV2qLHlxuyHC5VqUjDu4qi1TcAl2pMSAi8TEp8db4=";
              })
            ];
            postInstall = ''
              sed -i \
                -e '2i PATH="${final.pathAdd}:$PATH"' \
                -e '2i : "''${WINESERVER_BIN:=/run/current-system/sw/bin/wineserver}"' \
                -e '2i : "''${WINE_BIN:=/run/current-system/sw/bin/.wine}"' \
                "$out/bin/winetricks"
            '';
          });
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
