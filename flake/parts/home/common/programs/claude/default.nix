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
        # keep-sorted end
      };
    };
  };
}
