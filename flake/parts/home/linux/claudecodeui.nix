{ pkgs, buildNpmPackage, ... }:
let
  inherit ((pkgs.callPackage ../../../../_sources/generated.nix { })) claudecodeui;
in
buildNpmPackage {
  inherit (claudecodeui) src version pname;
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  npmDepsHash = "sha256-YiwuHSW3oy4HsDaTkzJMijaBjCIKtTBj3PvwDR8sFGQ=";
}
