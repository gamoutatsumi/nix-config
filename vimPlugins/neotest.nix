{ pkgs }:
let
  fetchers = pkgs.callPackage ../_sources/generated.nix { };
in
{
  neotest = fetchers.neotest.src;
  nio = fetchers.nio.src;
  neotest-go = fetchers.neotest-go.src;
  neotest-golang = fetchers.neotest-golang.src;
}
