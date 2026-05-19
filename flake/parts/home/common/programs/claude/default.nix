{
  upkgs,
  ...
}:
{
  programs = {
    claude-code = {
      enable = true;
      package = upkgs.llm-agents.claude-code;
      commandsDir = ./commands;
      memory = {
        source = ./CLAUDE.md;
      };
      settings = {
        # keep-sorted start block=yes
        autoCompactEnabled = false;
        enableAllProjectMcpServers = true;
        enabledPlugins = {
          # keep-sorted start
          "codex@openai-codex" = true;
          "gopls-lsp@claude-plugins-official" = true;
          "using-cmux@hummer98-using-cmux" = true;
          # keep-sorted end
        };
        env = {
          USE_BUILTIN_RIPGREP = "0";
          USE_BUILTIN_FD = "0";
        };
        language = "日本語";
        outputStyle = "Explanatory";
        permissions = {
          allow = [
            # keep-sorted start
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
            "Bash(curl:*)"
            "Bash(git push:*)"
            "Bash(git rebase:*)"
            "Bash(git reset:*)"
            "Bash(mongod:*)"
            "Bash(mysql:*)"
            "Bash(nc:*)"
            "Bash(npm remove:*)"
            "Bash(npm uninstall:*)"
            "Bash(psql:*)"
            "Bash(rm -rf:*)"
            "Bash(rm:*)"
            "Bash(sudo:*)"
            "Bash(wget:*)"
            # keep-sorted end
          ];
        };
        statusLine = {
          type = "command";
          command = "echo $(cat) | ccusage statusline";
        };
        # keep-sorted end
      };
    };
  };
}
