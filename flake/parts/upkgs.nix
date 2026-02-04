{
  system,
  inputs,
}:
(import inputs.nixpkgs-unstable {
  inherit system;
  config = {
    allowUnfree = true;
  };
  overlays = [
    # keep-sorted start
    inputs.agenix-rekey.overlays.default
    inputs.agenix.overlays.default
    inputs.brew-nix.overlays.default
    inputs.emacs-overlay.overlays.default
    inputs.llm-agents.overlays.default
    inputs.neovim-nightly-overlay.overlays.default
    inputs.nix-vscode-extensions.overlays.default
    inputs.nvim-treesitter-main.overlays.default
    inputs.vim-overlay.overlays.default
    # keep-sorted end
  ];
})
