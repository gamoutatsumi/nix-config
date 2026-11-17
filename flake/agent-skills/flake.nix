{
  inputs = {
    # keep-sorted start block=yes
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    anthropics-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    hashicorp-skills = {
      url = "github:hashicorp/agent-skills";
      flake = false;
    };
    herdr-core = {
      url = "github:herdrdev/herdr-core";
      flake = false;
    };
    nixpkgs = {
      url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst";
    };
    # keep-sorted end
  };

  outputs =
    {
      agent-skills,
      anthropics-skills,
      herdr-core,
      ...
    }:
    {
      homeManagerModules = {
        default =
          { ... }:
          {
            imports = [
              agent-skills.homeManagerModules.default
            ];

            programs = {
              agent-skills = {
                enable = true;
                sources = {
                  anthropics = {
                    path = anthropics-skills;
                    subdir = "skills";
                  };
                  herdr-core = {
                    path = herdr-core;
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
                    "herdr-core"
                  ];
                  enableAll = [
                    "personal"
                  ];
                };
                targets = {
                  codex = {
                    enable = true;
                    dest = ".codex/skills";
                    structure = "link";
                  };
                  claude = {
                    enable = true;
                    dest = ".claude/skills";
                    structure = "link";
                  };
                  pi = {
                    enable = true;
                    dest = ".pi/agent/skills";
                    structure = "link";
                  };
                };
              };
            };
          };
      };
    };
}
