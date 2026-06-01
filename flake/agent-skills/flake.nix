{
  inputs = {
    # keep-sorted start block=yes
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs = {
        home-manager = {
          follows = "home-manager";
        };
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    hashicorp-skills = {
      url = "github:hashicorp/agent-skills";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-26.05";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs?ref=nixos-26.05&shallow=1";
    };
    # keep-sorted end
  };

  outputs =
    {
      agent-skills,
      anthropic-skills,
      hashicorp-skills,
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
                  anthropic = {
                    path = anthropic-skills;
                    subdir = "skills";
                  };
                  terraform-provider = {
                    path = hashicorp-skills;
                    subdir = "terraform/provider-development/skills";
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
                  enableAll = [
                    "personal"
                    "terraform-provider"
                  ];
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
            };
          };
      };
    };
}
