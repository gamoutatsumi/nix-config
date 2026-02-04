{ withSystem, inputs, ... }:
{
  flake = {
    darwinConfigurations = {
      work = withSystem "aarch64-darwin" (
        {
          system,
          inputs',
          ...
        }:
        let
          darwinUser = builtins.getEnv "DARWIN_USER";
          darwinHost = builtins.getEnv "DARWIN_HOST";
          upkgs = import ./upkgs.nix {
            inherit system inputs;
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
            ./common
            ./darwin/config.nix
            ./darwin/hosts/work
            inputs.home-manager.darwinModules.home-manager
            inputs.nix-index-database.darwinModules.nix-index
            inputs.kanata-darwin-nix.darwinModules.default
            (
              _:
              import ./homemanager.nix {
                inherit upkgs inputs inputs';
                imports = [
                  ./home/common
                  ./home/darwin
                ];
                username = darwinUser;
              }
            )
          ];
        }
      );
    };
  };
}
