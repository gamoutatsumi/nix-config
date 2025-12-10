{ pkgs }:
let
  fetchers = pkgs.callPackage ../_sources/generated.nix { };
in
{
  dap = fetchers.nvim-dap.src;
  dap-ui = fetchers.nvim-dap-ui.src;
  dap-go = fetchers.nvim-dap-go.src;
  dap-virtual-text = fetchers.nvim-dap-virtual-text.src;
}
