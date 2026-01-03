{
  upkgs,
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
      package = upkgs.edge.claude-code;
      commandsDir = ./commands;
      skillsDir = upkgs.symlinkJoin {
        name = "claude-code-skills";
        paths = [
          "${anthropicsSkills}/skills"
          scrumSkills
        ];
      };
      memory = {
        source = ./CLAUDE.md;
      };
      # mcpServers =
      #   (inputs.mcp-servers-nix.lib.evalModule upkgs {
      #     programs = {
      #       # keep-sorted start block=yes
      #       codex = {
      #         enable = true;
      #         inherit (config.programs.codex) package;
      #       };
      #       context7 = {
      #         enable = true;
      #       };
      #       git = {
      #         enable = true;
      #       };
      #       github = {
      #         enable = true;
      #         package = upkgs.github-mcp-server;
      #         env = {
      #           GITHUB_DYNAMIC_TOOLSETS = "1";
      #           GITHUB_READ_ONLY = "1";
      #         };
      #         passwordCommand = {
      #           GITHUB_PERSONAL_ACCESS_TOKEN = [
      #             (lib.getExe config.programs.gh.package)
      #             "auth"
      #             "token"
      #           ];
      #         };
      #       };
      #       sequential-thinking = {
      #         enable = true;
      #       };
      #       serena = {
      #         enable = true;
      #         enableWebDashboard = false;
      #         context = "claude-code";
      #       };
      #       # keep-sorted end
      #     };
      #   }).config.settings.servers;
      settings = {
        permissions = {
          allow = [
          ];
          deny = [
            "Edit"
            "Glob"
            "Grep"
            "Read"
            "Write"
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
