{ withSystem, inputs, ... }:
{
  flake = {
    darwinConfigurations = {
      work = withSystem "aarch64-darwin" (
        {
          system,
          pkgs,
          ...
        }:
        let
          darwinUser = builtins.getEnv "DARWIN_USER";
          darwinHost = builtins.getEnv "DARWIN_HOST";
          upkgs = import ../../upkgs.nix {
            inherit system inputs;
            inherit (pkgs) stdenv lib;
          };
        in
        inputs.nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit inputs upkgs;
            username = darwinUser;
            hostname = darwinHost;
          };
          modules = [
            ../../hosts/work_darwin
            ../../settings/darwin.nix
            inputs.monitored.darwinModules.default
            inputs.home-manager.darwinModules.home-manager
            (
              _:
              import ../../homemanager.nix {
                inherit upkgs inputs;
                imports = [ ../../settings/home/darwin.nix ];
                username = darwinUser;
              }
            )
          ];
        }
      );
    };
  };
}
