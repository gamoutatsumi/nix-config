{ pkgs }:
let
  nvim_dap = pkgs.callPackage ./vimPlugins/nvim_dap.nix { };
in
{
  plugins = [
    {
      repo = "mfussenegger/nvim-dap";
      name = "nvim-dap";
      path = nvim_dap.dap;
      hooks_file = [ ./hooks/dap.lua ];
    }
    {
      repo = "rcarriga/nvim-dap-ui";
      name = "nvim-dap-ui";
      path = nvim_dap.dap-ui;
    }
    {
      repo = "theHamsta/nvim-dap-virtual-text";
      name = "nvim-dap-virtual-text";
      path = nvim_dap.dap-virtual-text;
    }
    {
      repo = "leoluz/nvim-dap-go";
      name = "nvim-dap-go";
      path = nvim_dap.dap-go;
    }
  ];
}
