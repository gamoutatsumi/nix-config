{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs?ref=nixos-25.11&shallow=1";
    };
    ast-grep-source = {
      url = "github:ast-grep/agent-skill";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-25.11";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
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
  };

  outputs =
    {
      agent-skills,
      anthropic-skills,
      ast-grep-source,
      hashicorp-skills,
      ...
    }:
    {
      homeManagerModules = {
        default =
          { pkgs, ... }:
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
                  ast-grep-source = {
                    path = ast-grep-source;
                    subdir = "ast-grep/skills";
                  };
                  personal = {
                    path = ./skills;
                  };
                };
                skills = {
                  explicit = {
                    ast-grep = {
                      from = "ast-grep-source";
                      path = "ast-grep";
                      packages = with pkgs; [ ast-grep ];
                      transform =
                        { original, dependencies }:
                        ''
                          ${original}

                          ${dependencies}

                          - You should use ./ast-grep for execution.
                        '';
                    };
                  };
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
