{ pkgs }:
let
  nvim_lua = pkgs.callPackage ../../../../vimPlugins/nvim_lua.nix { };
in
{
  plugins = [
    {
      repo = "nvim-lua/plenary.nvim";
      name = "plenary.nvim";
      path = nvim_lua.plenary;
    }
    {
      repo = "nvim-lua/popup.nvim";
      name = "popup.nvim";
      path = nvim_lua.popup;
    }
  ];
}
