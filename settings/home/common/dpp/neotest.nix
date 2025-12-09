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
      repo = "fredrikaverpil/neotest-golang";
      name = "neotest-golang";
      path = neotest.neotest-golang;
    }
    {
      repo = "nvim-neotest/neotest";
      name = "neotest";
      path = neotest.neotest;
      hooks_file = [
        "$BASE_DIR/dpp/neotest.lua"
      ];
    }
    {
      repo = "andythigpen/nvim-coverage";
      name = "nvim-coverage";
      path = neotest.coverage;
      hooks_file = [
        "$BASE_DIR/dpp/coverage.lua"
      ];
    }
  ];
}
