{ pkgs }:
let
  fetchers = pkgs.callPackage ../_sources/generated.nix { };
  inherit (pkgs.callPackage ./nvim_lua.nix { }) plenary;
in
rec {
  neotest = pkgs.vimUtils.buildVimPlugin {
    name = "neotest";
    inherit (fetchers.neotest) src version;
    dependencies = [
      plenary
      nio
    ];
  };
  nio = pkgs.vimUtils.buildVimPlugin {
    name = "nio";
    inherit (fetchers.nio) src version;
  };
  neotest-go = pkgs.vimUtils.buildVimPlugin {
    name = "neotest-go";
    inherit (fetchers.neotest-go) src version;
    dependencies = [
      neotest
      nio
      plenary
    ];
  };
}
