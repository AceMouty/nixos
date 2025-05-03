{
  description = "NixOS flake";

  inputs = {
    # select stable or unstable
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs.url = "nixpkgs/nixos-24.11"; # same as github:NixOs/nixpkgs/nixos-24.11

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nvf,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
  in {
    # NixOS config
    nixosConfigurations = {
      # nixos: matches host name defined in cofiguration.nix
      nixos = lib.nixosSystem {
        system = "x86_64-linux";
        #home-manager
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # create a backup of some existing file not managed by hm
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.ace = ./home.nix;
          }
        ];
      };
    };
  };
}
