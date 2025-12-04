{ pkgs }:
let
  fetchers = pkgs.callPackage ../_sources/generated.nix { };
in
rec {
  plenary = pkgs.vimUtils.buildVimPlugin {
    name = "plenary";
    inherit (fetchers.plenary) src version;
    nvimSkipModules = [
      "plenary.neorocks.init"
      "plenary._meta._luassert"
    ];
  };
  popup = pkgs.vimUtils.buildVimPlugin {
    name = "popup";
    inherit (fetchers.popup) src version;
    dependencies = [ plenary ];
  };
}
