{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.x1c = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}