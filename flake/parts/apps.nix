{ withSystem, ... }:
{
  flake = {
    apps = {
      "aarch64-darwin" = withSystem "aarch64-darwin" (
        {
          pkgs,
          ...
        }:
        {
          update = {
            program = toString (
              pkgs.writeShellScript "update" ''
                set -e
                nix flake update --commit-lock-file
                ${pkgs.lib.getExe pkgs.nh} darwin switch .# -H $1 -- --impure --show-trace --accept-flake-config
              ''
            );
            type = "app";
          };
        }
      );
      "x86_64-linux" = withSystem "x86_64-linux" (
        {
          pkgs,
          ...
        }:
        {
          update = {
            program = toString (
              pkgs.writeShellScript "update" ''
                set -e
                nix flake update --commit-lock-file
                ${pkgs.lib.getExe pkgs.nh} os switch . -- --show-trace --accept-flake-config
              ''
            );
          };
        }
      );
    };
  };
}
