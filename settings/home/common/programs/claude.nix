{
  upkgs,
  inputs,
  config,
  ...
}:
{
  programs = {
    claude-code = {
      enable = true;
      package = upkgs.edge.claude-code;
      commandsDir = ../config/claude/commands;
      memory = {
        source = ../config/claude/CLAUDE.md;
      };
      mcpServers =
        (inputs.mcp-servers-nix.lib.evalModule upkgs {
          programs = {
            context7 = {
              enable = true;
            };
            serena = {
              enable = true;
              enableWebDashboard = false;
            };
            filesystem = {
              enable = true;
            };
            sequential-thinking = {
              enable = true;
            };
            git = {
              enable = true;
            };
            codex = {
              enable = true;
              inherit (config.programs.codex) package;
            };
            github = {
              enable = true;
              env = {
                GITHUB_TOOLSETS = "context,issues,pull_requests";
              };
              passwordCommand = {
                GITHUB_PERSONAL_ACCESS_TOKEN = [
                  (upkgs.lib.getExe config.programs.gh.package)
                  "auth"
                  "token"
                ];
              };
            };
          };
        }).config.settings.servers;
      settings = {
        permissions = {
          allow = [
          ];
          deny = [
            "Bash(sudo:*)"
            "Bash(rm:*)"
            "Bash(rm -rf:*)"
            "Bash(git push:*)"
            "Bash(git reset:*)"
            "Bash(git rebase:*)"
            "Read(.env.*)"
            "Read(id_rsa)"
            "Read(id_ed25519)"
            "Read(**/*token*)"
            "Read(**/*key*)"
            "Write(.env*)"
            "Write(**/secrets/**)"
            "Bash(curl:*)"
            "Bash(wget:*)"
            "Bash(nc:*)"
            "Bash(npm uninstall:*)"
            "Bash(npm remove:*)"
            "Bash(psql:*)"
            "Bash(mysql:*)"
            "Bash(mongod:*)"
            "mcp__supabase__execute_sql"
          ];
        };
      };
    };
  };
}
