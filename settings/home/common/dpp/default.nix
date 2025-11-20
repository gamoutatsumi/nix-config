{ pkgs }:
let
  tomlFormat = pkgs.formats.toml { };
in
pkgs.linkFarm "dpp-tomls" [
  {
    name = "vim.toml";
    path = tomlFormat.generate "vim.toml" (import ./vim.nix);
  }
]
