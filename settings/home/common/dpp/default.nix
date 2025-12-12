{ pkgs }:
let
  tomlFormat = pkgs.formats.toml { };
in
{
  vim_toml = tomlFormat.generate "vim.toml" (import ./vim.nix);
  neovim_toml = tomlFormat.generate "neovim.toml" (import ./neovim.nix { inherit pkgs; });
  ddc_toml = tomlFormat.generate "ddc.toml" (import ./ddc.nix { inherit pkgs; });
  ddt_toml = tomlFormat.generate "ddt.toml" (import ./ddt.nix);
  ddu_toml = tomlFormat.generate "ddu.toml" (import ./ddu.nix { inherit pkgs; });
  denops_toml = tomlFormat.generate "denops.toml" (import ./denops.nix { inherit pkgs; });
  dpp_toml = tomlFormat.generate "dpp.toml" (import ./dpp.nix);
  lazy_toml = tomlFormat.generate "lazy.toml" (import ./lazy.nix);
  merge_toml = tomlFormat.generate "merge.toml" (import ./merge.nix);
  nvim_dap_toml = tomlFormat.generate "nvim_dap.toml" (import ./nvim_dap.nix { inherit pkgs; });
  nvim_lsp_toml = tomlFormat.generate "nvim_lsp.toml" (import ./nvim_lsp.nix);
  treesitter_toml = tomlFormat.generate "treesitter.toml" (import ./treesitter.nix);
  vim_lsp_toml = tomlFormat.generate "vim_lsp.toml" (import ./vim_lsp.nix);
  neotest_toml = tomlFormat.generate "neotest.toml" (import ./neotest.nix { inherit pkgs; });
  nvim_lua_toml = tomlFormat.generate "nvim_lua.toml" (import ./nvim_lua.nix { inherit pkgs; });
}
