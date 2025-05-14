# # planned structure
# common/*.nix # reference as `./common`
# home-manager/home.nix
# host/${hostname}#/configuration.nix
# lib/
# flake.nix

# nix.dev
# search.nixos.org
# mynixos.com
# wiki.nixos.org

# sudo nixos-rebuild switch --flake ./#hostname
# e.g. `... ./#hp_15-db`

# update `flake.lock` with
# nix flake update

# home-manager switch --flake ./#username
# e.g. `... ./#uiop`

{
  description = "root nixos config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    #home-manager = {
    #  url = "github:nix-community/home-manager/release-24.11";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };
  outputs = { nixpkgs, home-manager, ... }@inputs: let
    userName = "uiop";
    hosts = [
     { hostName = "hp_15-db"; system = "x86_64-linux"; stateVersion = "24.11"; }
    ];
    makeSystem = { hostName, system, stateVersion }: nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./host/${hostName}/configuration.nix ];
      specialArgs = {
        inherit inputs stateVersion hostName userName;
      };
    };
  in {
    nixosConfigurations = builtins.listToAttrs (map ({ hostName, ... }@host: {
      name = hostName;
      value = makeSystem host; # // {}
    }) hosts);

    #nixosConfigurations.hp_15-db = nixpkgs.lib.nixosSystem {
    #  system = "x86_64-linux";
    #  modules = [
    #    ./host/hp_15-db/configuration.nix
    #    ./common
    #  ];
    #};

    #homeConfigurations.uiop = home-manager.lib.homeManagerConfiguration {
    #  pkgs = nixpkgs.legacyPackages.${system};
    #  modules = [ ./home-manager/home.nix ];
    #};
  };
}
