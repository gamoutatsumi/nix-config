let
  denoVersion = "2.3.3";
in
{
  system,
  stdenv,
  lib,
  inputs,
}:
(import inputs.nixpkgs-unstable {
  inherit system;
  config = {
    allowUnfree = true;
  };
  overlays =
    [
      # keep-sorted start
      (_final: prev: { inherit (inputs.mcp-hub.packages.${prev.system}) mcp-hub; })
      (_final: prev: { inherit (inputs.mpd-mcp-server.packages.${prev.system}) mpd-mcp-server; })
      (_final: prev: { inherit (inputs.tombi.packages.${prev.system}) tombi; })
      (_final: prev: { inherit (inputs.yasunori.packages.${prev.system}) yasunori-mcp; })
      inputs.agenix-rekey.overlays.default
      inputs.agenix.overlays.default
      inputs.emacs-overlay.overlays.default
      inputs.ghostty.overlays.default
      inputs.neovim-nightly-overlay.overlays.default
      inputs.nix-vscode-extensions.overlays.default
      inputs.oreore.overlays.default
      inputs.vim-overlay.overlays.default
      # keep-sorted end
    ]
    ++ lib.optionals stdenv.isLinux [
      inputs.deno-overlay.overlays.deno-overlay
      (_final: prev: { deno = prev.deno.${denoVersion}; })
      (_final: prev: { copilot-language-server = prev.copilot-language-server.fhs; })
    ];
})
