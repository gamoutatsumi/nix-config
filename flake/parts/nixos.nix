{ withSystem, inputs, ... }:
{
  flake = {
    nixosConfigurations = {
      "tat-nixos-laptop" = withSystem "x86_64-linux" (
        {
          system,
          pkgs,
          ...
        }:
        let
          username = "gamoutatsumi";
          upkgs = import ../../upkgs.nix {
            inherit system inputs;
            inherit (pkgs) stdenv lib;
          };
        in
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              upkgs
              username
              ;
          };
          modules = [
            inputs.monitored.nixosModules.default
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.xremap-nix.nixosModules.default
            inputs.agenix.nixosModules.default
            inputs.agenix-rekey.nixosModules.default
            ../../hosts/laptop
            ../../settings/nixos.nix
            inputs.home-manager.nixosModules.home-manager
            (
              _:
              import ../../homemanager.nix {
                inherit username upkgs inputs;
                imports = [ ../../settings/home/linux.nix ];
                networkManager = true;
              }
            )
          ];
        }
      );
      "tat-nixos-desktop" = withSystem "x86_64-linux" (
        {
          system,
          pkgs,
          ...
        }:
        let
          username = "gamoutatsumi";
          upkgs = import ../../upkgs.nix {
            inherit system inputs;
            inherit (pkgs) stdenv lib;
          };
        in
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              upkgs
              username
              ;
            device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_24116U400484";
          };
          modules = [
            inputs.monitored.nixosModules.default
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.disko.nixosModules.disko
            inputs.agenix.nixosModules.default
            inputs.agenix-rekey.nixosModules.default
            ../../hosts/desktop
            ../../settings/nixos.nix
            inputs.home-manager.nixosModules.home-manager
            (
              _:
              import ../../homemanager.nix {
                inherit username upkgs inputs;
                imports = [ ../../settings/home/linux.nix ];
              }
            )
          ];
        }
      );
    };
  };
}
