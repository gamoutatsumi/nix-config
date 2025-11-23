{ pkgs }:
let
  tomlFormat = pkgs.formats.toml { };
in
pkgs.linkFarm "dpp-tomls" [
  {
    name = "vim.toml";
    path = tomlFormat.generate "vim.toml" (import ./vim.nix);
  }
  {
    name = "neovim.toml";
    path = tomlFormat.generate "neovim.toml" (import ./neovim.nix);
  }
  {
    name = "ddc.toml";
    path = tomlFormat.generate "ddc.toml" (import ./ddc.nix);
  }
  {
    name = "ddt.toml";
    path = tomlFormat.generate "ddt.toml" (import ./ddt.nix);
  }
  {
    name = "ddu.toml";
    path = tomlFormat.generate "ddu.toml" (import ./ddu.nix);
  }
  {
    name = "denops.toml";
    path = tomlFormat.generate "denops.toml" (import ./denops.nix);
  }
  {
    name = "dpp.toml";
    path = tomlFormat.generate "dpp.toml" (import ./dpp.nix);
  }
  {
    name = "lazy.toml";
    path = tomlFormat.generate "lazy.toml" (import ./lazy.nix);
  }
  {
    name = "merge.toml";
    path = tomlFormat.generate "merge.toml" (import ./merge.nix);
  }
  {
    name = "nvim_dap.toml";
    path = tomlFormat.generate "nvim_dap.toml" (import ./nvim_dap.nix);
  }
  {
    name = "nvim_lsp.toml";
    path = tomlFormat.generate "nvim_lsp.toml" (import ./nvim_lsp.nix);
  }
  {
    name = "telescope.toml";
    path = tomlFormat.generate "telescope.toml" (import ./telescope.nix);
  }
  {
    name = "treesitter.toml";
    path = tomlFormat.generate "treesitter.toml" (import ./treesitter.nix);
  }
  {
    name = "vim_lsp.toml";
    path = tomlFormat.generate "vim_lsp.toml" (import ./vim_lsp.nix);
  }
]
