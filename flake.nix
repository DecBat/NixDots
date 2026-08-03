{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.x1c = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./hosts/x1c/default.nix
        ./modules/common.nix
        ./modules/desktop.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.declan = import ./home/declan.nix;
        }
      ];
    };
  };
}