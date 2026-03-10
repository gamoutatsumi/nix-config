{
  upkgs,
  lib,
  inputs,
  config,
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
      mcpServers =
        (inputs.mcp-servers-nix.lib.evalModule upkgs {
          settings = {
            servers = {
              notion = {
                type = "http";
                url = "https://mcp.notion.com/mcp";
              };
            };
          };
          programs = {
            # keep-sorted start block=yes
            codex = {
              enable = true;
              inherit (config.programs.codex) package;
            };
            context7 = {
              enable = true;
            };
            git = {
              enable = false;
            };
            github = {
              enable = true;
              package = upkgs.github-mcp-server;
              env = {
                GITHUB_DYNAMIC_TOOLSETS = "1";
                GITHUB_READ_ONLY = "1";
              };
              passwordCommand = {
                GITHUB_PERSONAL_ACCESS_TOKEN = [
                  (lib.getExe config.programs.gh.package)
                  "auth"
                  "token"
                ];
              };
            };
            sequential-thinking = {
              enable = false;
            };
            serena = {
              enable = true;
              enableWebDashboard = false;
              context = "claude-code";
            };
            # keep-sorted end
          };
        }).config.settings.servers;
      settings = {
        permissions = {
          allow = [
            "Bash(rg:*)"
            "Bash(ls:*)"
            "Bash(cat:*)"
            "Bash(echo:*)"
            "Bash(tail:*)"
            "Bash(head:*)"
            "Bash(fd:*)"
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
