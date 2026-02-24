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
