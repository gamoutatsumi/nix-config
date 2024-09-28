{
  pkgs,
  ghcBuild ? "ghc98",
  ...
}:
let
  inherit (pkgs.lib.trivial) flip pipe;
  haskellPackages = pkgs.haskell.packages."${ghcBuild}";
  pkg = haskellPackages.developPackage {
    root = ./.;
    modifier =
      drv:
      pipe drv [
        pkgs.haskell.lib.dontHaddock
        (flip pkgs.haskell.lib.addBuildTools (with haskellPackages; [ cabal-install ]))
      ];
  };
in
pkg
