{
  upkgs,
  ...
}:
{
  programs = {
    vscode = {
      enable = false;
      package = upkgs.vscode;
      profiles = {
        default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;
          extensions =
            with upkgs.vscode-extensions;
            [
              # keep-sorted start
              bbenoist.nix
              eamodio.gitlens
              editorconfig.editorconfig
              github.copilot
              github.copilot-chat
              github.github-vscode-theme
              golang.go
              ms-ceintl.vscode-language-pack-ja
              oderwat.indent-rainbow
              saoudrizwan.claude-dev
              vscode-icons-team.vscode-icons
              # keep-sorted end
            ]
            ++ (with upkgs.nix-vscode-extensions.vscode-marketplace; [
              taiyofujii.novel-writer
              google.geminicodeassist
            ]);
          userSettings = {
            "chat.mcp.enabled" = true;
            "chat.mcp.discovery.enabled" = true;
            "editor.fontFamily" = "PlemolJP Console NF";
            "editor.fontLigatures" = true;
            "editor.fontSize" = 14;
            "editor.renderWhitespace" = "boundary";
            "editor.minimap.enabled" = true;
            "editor.minimap.renderCharacters" = true;
            "workbench.colorTheme" = "GitHub Dark Dimmed";
            "workbench.iconTheme" = "vscode-icons";
            "cline.mcpMarketplace.enabled" = false;
            "cline.preferredLanguage" = "Japanese - 日本語";
            "github.copilot.chat.codesearch.enabled" = true;
            "github.copilot.chat.agent.thinkingTool" = true;
          };
        };
      };
    };
  };
}
