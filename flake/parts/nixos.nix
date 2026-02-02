{
  withSystem,
  inputs,
  self,
  ...
}:
{
  flake = {
    packages = {
      aarch64-linux = withSystem "aarch64-linux" (
        { pkgs, ... }:
        {
          limaK8s =
            let
              limaYaml = pkgs.writeText "nixos-k8s.yaml" (
                pkgs.lib.generators.toYAML { } {
                  images = [
                    {
                      location = "${self.nixosConfigurations.limaK8s.config.system.build.images.qemu-efi}/lima-k8s.qcow2";
                      arch = "aarch64";
                    }
                  ];
                  vmType = "vz";
                  networks = [
                    { vzNAT = true; }
                  ];
                  mountType = "virtiofs";
                  containerd = {
                    system = false;
                    user = false;
                  };
                  portForwards = [
                    {
                      guestSocket = "/run/docker.sock";
                      hostSocket = "{{ .Dir }}/sock/docker.sock";
                    }
                  ];
                }
              );
            in
            pkgs.runCommand "lima-k8s" { } ''
              mkdir -p $out
              cp ${limaYaml} $out/nixos-k8s.yaml
            '';
        }
      );
    };
    nixosConfigurations = {
      limaK8s = withSystem "aarch64-linux" (
        { system, ... }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./nixos/hosts/lima-vm/default.nix ];
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
          };
          modules = [
            inputs.monitored.nixosModules.default
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
            inputs.monitored.nixosModules.default
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
