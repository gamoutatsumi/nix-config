{
  upkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  programs = {
    claude-code = {
      enable = true;
      package = upkgs.edge.claude-code;
      commandsDir = ./commands;
      memory = {
        source = ./CLAUDE.md;
      };
      mcpServers =
        (inputs.mcp-servers-nix.lib.evalModule upkgs {
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
              enable = true;
            };
            github = {
              enable = true;
              env = {
                GITHUB_TOOLSETS = "context,issues,pull_requests";
                GITHUB_DYNAMIC_TOOLSETS = 1;
                GITHUB_READ_ONLY = 1;
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
              enable = true;
            };
            serena = {
              enable = true;
              enableWebDashboard = false;
            };
            # keep-sorted end
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
