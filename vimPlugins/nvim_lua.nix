{ pkgs }:
let
  fetchers = pkgs.callPackage ../_sources/generated.nix { };
in
{
  plenary = fetchers.plenary-nvim.src;
  popup = fetchers.popup-nvim.src;
  statuscol = fetchers.statuscol-nvim.src;
  avante = fetchers.avante-nvim.src;
}
