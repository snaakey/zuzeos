{
  description = "Zuze OS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    systems.url = "github:nix-systems/default";
  };
  
  outputs = { self, nixpkgs, systems }: 
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      systemBase = {
        modules = [
          # our base nix configs
        ];
      };
    in
  {
    packages = eachSystem (system: {
      hello = nixpkgs.legacyPackages.${system}.hello;
      default = self.nixosConfigurations.${system}.gnomeIso.config.system.build.isoImage;
    });
    nixosConfigurations = eachSystem (system: {
      gnomeIso = nixpkgs.lib.nixosSystem {
        system = "${system}";
        modules = systemBase.modules ++ [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"
        ];
      };
    });
  };
}
