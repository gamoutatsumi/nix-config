{ pkgs }:
let
  inherit ((pkgs.callPackage ../_sources/generated.nix { })) plamo;
in
pkgs.buildPythonPackage {
  inherit (plamo)
    pname
    version
    src
    ;
  pyproject = true;
}
