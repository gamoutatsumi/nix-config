{ pkgs }:
let
  inherit ((pkgs.callPackage ../_sources/generated.nix { })) denops-vim;
in
pkgs.vimUtils.buildVimPlugin {
  name = "denops";
  inherit (denops-vim) src version;
}
