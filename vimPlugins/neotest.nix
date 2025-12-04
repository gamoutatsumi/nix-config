{ pkgs }:
let
  fetchers = pkgs.callPackage ../_sources/generated.nix { };
in
rec {
  neotest = fetchers.neotest.src;
  nio = fetchers.nio.src;
  neotest-go = fetchers.neotest-go.src;
}
