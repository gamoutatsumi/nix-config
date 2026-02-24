{
  withSystem,
  inputs,
  ...
}:
{
  flake = {
    nixosConfigurations = {
      vfkitK8s = withSystem "aarch64-darwin" (
        { system, ... }:
        inputs.nixpkgs.lib.nixosSystem {
          system = inputs.nixpkgs.lib.replaceString "-darwin" "-linux" system;
          specialArgs = { inherit inputs system; };
          modules = [
            inputs.microvm.nixosModules.microvm
            ./nixos/hosts/vfkit-k8s
          ];
        }
      );
      headlessIso = withSystem "x86_64-linux" (
        { system, ... }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./nixos/hosts/iso/default.nix ];
        }
      );
      tat-nixos-laptop = withSystem "x86_64-linux" (
        {
          inputs',
          system,
          ...
        }:
        let
          username = "gamoutatsumi";
          upkgs = import ./upkgs.nix {
            inherit inputs system;
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
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.xremap-nix.nixosModules.default
            inputs.agenix.nixosModules.default
            inputs.agenix-rekey.nixosModules.default
            inputs.nix-index-database.nixosModules.default
            ./nixos/hosts/laptop
            ./common
            ./nixos/config.nix
            inputs.home-manager.nixosModules.home-manager
            (
              _:
              import ./homemanager.nix {
                inherit
                  username
                  upkgs
                  inputs
                  inputs'
                  ;
                imports = [
                  ./home/common
                  ./home/linux
                ];
              }
            )
          ];
        }
      );
      tat-nixos-desktop = withSystem "x86_64-linux" (
        {
          system,
          inputs',
          ...
        }:
        let
          username = "gamoutatsumi";
          upkgs = import ./upkgs.nix {
            inherit system inputs;
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
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.disko.nixosModules.disko
            inputs.agenix.nixosModules.default
            inputs.agenix-rekey.nixosModules.default
            inputs.nix-index-database.nixosModules.default
            ./nixos/hosts/desktop
            ./common
            ./nixos/config.nix
            inputs.home-manager.nixosModules.home-manager
            (
              _:
              import ./homemanager.nix {
                inherit
                  username
                  upkgs
                  inputs
                  inputs'
                  ;
                imports = [
                  ./home/common
                  ./home/linux
                ];
              }
            )
          ];
        }
      );
    };
  };
}
