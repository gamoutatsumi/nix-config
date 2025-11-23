{ pkgs }:
let
  inherit ((pkgs.callPackage ../_sources/generated.nix { })) denops;
in
pkgs.vimUtils.buildVimPlugin {
  name = "denops";
  inherit (denops) src version;
}
