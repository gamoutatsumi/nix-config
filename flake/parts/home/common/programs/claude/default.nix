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
        enabledPlugins = {
          "codex@openai-codex" = true;
        };
        env = {
          USE_BUILTIN_RIPGREP = "0";
          USE_BUILTIN_FD = "0";
        };
        permissions = {
          allow = [
            "Bash(rg:*)"
            "Bash(ls:*)"
            "Bash(cat:*)"
            "Bash(echo:*)"
            "Bash(tail:*)"
            "Bash(head:*)"
            "Bash(fd:*)"
            "Bash(cmux:*)"
            "Bash(osascript:*)"
            "Bash(sleep:*)"
          ];
          deny = [
            "Bash(sudo:*)"
            "Bash(rm:*)"
            "Bash(rm -rf:*)"
            "Bash(git push:*)"
            "Bash(git reset:*)"
            "Bash(git rebase:*)"
            "Bash(curl:*)"
            "Bash(wget:*)"
            "Bash(nc:*)"
            "Bash(npm uninstall:*)"
            "Bash(npm remove:*)"
            "Bash(psql:*)"
            "Bash(mysql:*)"
            "Bash(mongod:*)"
          ];
        };
      };
    };
  };
}
