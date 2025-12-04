{ pkgs }:
let
  neotest = pkgs.callPackage ../../../../vimPlugins/neotest.nix { };
in
{
  plugins = [
    {
      repo = "nvim-neotest/nvim-nio";
      name = "nvim-nio";
      path = neotest.nio;
      merged = false;
    }
    {
      repo = "nvim-neotest/neotest-go";
      name = "neotest-go";
      path = neotest.neotest-go;
    }
    {
      repo = "nvim-neotest/neotest";
      name = "neotest";
      path = neotest.neotest;
      hooks_file = [
        "$BASE_DIR/dpp/neotest.lua"
      ];
    }
  ];
}
