{ pkgs }:
let
  nvim_lua = pkgs.callPackage ./vimPlugins/nvim_lua.nix { };
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
    {
      repo = "luukvbaal/statuscol.nvim";
      name = "statuscol.nvim";
      path = nvim_lua.statuscol;
      hooks_file = [ ./hooks/statuscol.lua ];
    }
    {
      repo = "yetone/avante.nvim";
      name = "avante.nvim";
      path = nvim_lua.avante;
      hooks_file = [ ./hooks/avante.lua ];
    }
  ];
}
