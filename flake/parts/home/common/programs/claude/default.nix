{
  upkgs,
  inputs,
  config,
  ...
}:
let
  anthropicsSkills =
    (upkgs.callPackage ../../../../../../_sources/generated.nix { }).anthropics-skills.src;
  atusyDotfiles = (upkgs.callPackage ../../../../../../_sources/generated.nix { }).atusy-dotfiles.src;
  scrumSkills = upkgs.runCommand "scrum-skills" { } ''
    mkdir -p $out
    find ${atusyDotfiles}/dot_claude/skills -name "scrum*" -type d -exec ln -s {} $out/ \;
  '';
in
{
  programs = {
    claude-code = {
      enable = true;
      package = upkgs.llm-agents.claude-code;
      commandsDir = ./commands;
      skillsDir = upkgs.symlinkJoin {
        name = "claude-code-skills";
        paths = [
          "${anthropicsSkills}/skills"
          scrumSkills
          ./skills
        ];
      };
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
