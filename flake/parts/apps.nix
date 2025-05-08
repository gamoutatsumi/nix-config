{ withSystem, ... }:
{
  flake = {
    apps = {
      "aarch64-darwin" = withSystem "aarch64-darwin" (
        {
          system,
          pkgs,
          ...
        }:
        {
          update = {
            program = toString (
              pkgs.writeShellScript "update" ''
                set -e
                echo "Updating ${system}..."
                nix flake update --commit-lock-file nixpkgs neovim-nightly-overlay neovim-src nixpkgs-unstable oreore home-manager systems treefmt-nix pre-commit-hooks nix-darwin
                old_system=$(${pkgs.lib.getExe' pkgs.coreutils "readlink"} -f /run/current-system)
                nix run nix-darwin -- switch --flake .#$1 --impure --show-trace
                new_system=$(${pkgs.lib.getExe' pkgs.coreutils "readlink"} -f /run/current-system)
                ${pkgs.lib.getExe pkgs.nvd} diff "''${old_system}" "''${new_system}"
              ''
            );
            type = "app";
          };
        }
      );
      "x86_64-linux" = withSystem "x86_64-linux" (
        {
          system,
          pkgs,
          ...
        }:
        {
          update = {
            program = toString (
              pkgs.writeShellScript "update" ''
                set -e
                set -o pipefail
                echo "Updating ${system}..."
                nix flake update --commit-lock-file
                old_system=$(${pkgs.lib.getExe' pkgs.coreutils "readlink"} -f /run/current-system)
                sudo nixos-rebuild switch --flake . --show-trace
                new_system=$(${pkgs.lib.getExe' pkgs.coreutils "readlink"} -f /run/current-system)
                ${pkgs.lib.getExe pkgs.nvd} diff "''${old_system}" "''${new_system}"
              ''
            );
          };
        }
      );
    };
  };
}
