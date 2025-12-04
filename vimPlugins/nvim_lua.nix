{ pkgs }:
let
  fetchers = pkgs.callPackage ../_sources/generated.nix { };
in
rec {
  plenary = fetchers.plenary.src;
  popup = fetchers.popup.src;
}
