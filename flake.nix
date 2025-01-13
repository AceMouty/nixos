{
  description = "NixOS flake";

  inputs = {
    # uncomment for unstable
    # nixpkgs.url = "nixpkgs/nixos-unstable";

    nixpkgs.url = "nixpkgs/nixos-24.11"; # same as github:NixOs/nixpkgs/nixos-24.11
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nvf.url = "github:notashelf/nvf";

  };

  outputs = {self, nixpkgs, home-manager, nvf, ...}: 
    let
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in
    {
      # NixOS config
      nixosConfigurations = {
        # nixos: matches host name defined in cofiguration.nix
        nixos = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration.nix ];
        };
      };

      # Home-Manager config
      homeConfigurations = {
        # nixos: matches host name defined in cofiguration.nix
        ace = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ 
            nvf.homeManagerModules.default # enable nvf module
            ./home.nix
          ];
        };
      };

    };
}
