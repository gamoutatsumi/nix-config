{
  upkgs,
  pkgs,
  ...
}:
let
  fetchers = pkgs.callPackage ../../../../../../_sources/generated.nix { };
in
{
  programs = {
    claude-code = {
      enable = true;
      package = upkgs.llm-agents.claude-code;
      commandsDir = ./commands;
      context = builtins.readFile ../../agents/AGENTS.md;
      rulesDir = ../../agents/rules;
      marketplaces = {
        "ast-grep-marketplace" = fetchers.ast-grep-marketplace.src;
        "openai-codex" = fetchers.openai-codex-marketplace.src;
        "claude-plugins-official" = fetchers.anthropic-official-marketplace.src;
      };
      settings = {
        # keep-sorted start block=yes
        autoCompactEnabled = false;
        enableAllProjectMcpServers = true;
        enabledPlugins = {
          # keep-sorted start
          "ast-grep@ast-grep-marketplace" = true;
          "codex@openai-codex" = true;
          "commit-commands@claude-plugins-official" = true;
          "explanatory-output-style@claude-plugins-official" = true;
          "feature-dev@claude-plugins-official" = true;
          "gopls-lsp@claude-plugins-official" = true;
          "security-guidance@claude-plugins-official" = true;
          # keep-sorted end
        };
        env = {
          USE_BUILTIN_RIPGREP = "0";
          USE_BUILTIN_FD = "0";
        };
        language = "日本語";
        model = "opusplan";
        outputStyle = "Explanatory";
        permissions = {
          allow = [
            # keep-sorted start
            "Bash(ast-grep:*)"
            "Bash(cat:*)"
            "Bash(cmux:*)"
            "Bash(echo:*)"
            "Bash(fd:*)"
            "Bash(head:*)"
            "Bash(ls:*)"
            "Bash(osascript:*)"
            "Bash(rg:*)"
            "Bash(sleep:*)"
            "Bash(tail:*)"
            # keep-sorted end
          ];
          deny = [
            # keep-sorted start
            "Bash(awk *.env*)"
            "Bash(bat *.env*)"
            "Bash(cat *.env*)"
            "Bash(curl:*)"
            "Bash(find:*)"
            "Bash(git push:*)"
            "Bash(git rebase:*)"
            "Bash(git reset:*)"
            "Bash(grep *.env*)"
            "Bash(grep:*)"
            "Bash(head *.env*)"
            "Bash(less *.env*)"
            "Bash(mongod:*)"
            "Bash(more *.env*)"
            "Bash(mysql:*)"
            "Bash(nano *.env*)"
            "Bash(nc:*)"
            "Bash(npm remove:*)"
            "Bash(npm uninstall:*)"
            "Bash(psql:*)"
            "Bash(rm -rf:*)"
            "Bash(rm:*)"
            "Bash(sed *.env*)"
            "Bash(sudo:*)"
            "Bash(tail *.env*)"
            "Bash(vim *.env*)"
            "Bash(wget:*)"
            "Read(*.env)"
            "Read(.env)"
            "Read(.env.*)"
            # keep-sorted end
          ];
        };
        statusLine = {
          type = "command";
          command = "echo $(cat) | ccusage statusline";
        };
        tui = "fullscreen";
        # keep-sorted end
      };
    };
  };
}
