{
  agent-skills,
  anthropic-skills,
  ...
}:
{
  imports = [
    agent-skills.homeManagerModules.default
  ];

  programs.agent-skills = {
    enable = true;
    sources = {
      anthropic = {
        path = anthropic-skills;
        subdir = "skills";
      };
      personal = {
        path = ./skills;
      };
    };
    skills = {
      enable = [
        "frontend-design"
        "skill-creator"
      ];
      enableAll = [ "personal" ];
    };
    targets = {
      codex = {
        dest = ".codex/skills";
        structure = "link";
      };
      claude = {
        dest = ".claude/skills";
        structure = "link";
      };
    };
  };
}
