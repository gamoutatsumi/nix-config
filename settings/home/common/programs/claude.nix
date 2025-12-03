{ upkgs, ... }:
{
  programs = {
    claude-code = {
      enable = true;
      package = upkgs.edge.claude-code;
      commandsDir = ../config/claude/commands;
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
