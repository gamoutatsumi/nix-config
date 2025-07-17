{ pkgs, lib }:
let
  inherit ((pkgs.callPackage ../_sources/generated.nix { })) blocc;
in
pkgs.buildGo124Module {
  inherit (blocc)
    pname
    version
    src
    ;
  vendorHash = lib.fakeHash;
}
