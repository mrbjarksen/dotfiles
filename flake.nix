{
  description = "Personal NixOS system configurations";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:NixOS/nixos-hardware;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in
  {
    nixosConfigurations.neumann = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ ... }: { networking.hostname = "neumann"; })
        nixos-hardware.nixosModules.dell-xps-17-9700-intel
        ./neumann.nix
      ];
    };

    homeConfigurations.mrbjarksen = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./mrbjarksen.nix ];
    };
  };
}
