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
                    input = "anthropic-skills";
                    subdir = "skills";
                    idPrefix = "anthropic";
                  };
                  terraform-provider = {
                    input = "hashicorp-skills";
                    subdir = "terraform/provider-development/skills";
                    idPrefix = "terraform-provider";
                  };
                  personal = {
                    path = ./skills;
                    idPrefix = "personal";
                  };
                };
                skills = {
                  enable = [
                    "anthropic/frontend-design"
                    "anthropic/skill-creator"
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
