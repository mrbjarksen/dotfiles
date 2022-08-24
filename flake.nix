{
  description = "Personal NixOS system configurations";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nur.url = github:nix-community/NUR;
    nixos-hardware.url = github:NixOS/nixos-hardware;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nur, nixos-hardware, home-manager }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ nur.overlay ];
    };
  in
  {
    nixosConfigurations.neumann = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ lib, ... }: with lib; {
          networking.hostName = "neumann"; 
          boot.kernelPatches = mkForce [];
          hardware.nvidiaOptimus.disable = mkForce false;
        })
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
