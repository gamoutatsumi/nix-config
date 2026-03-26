{
  inputs = {
    # keep-sorted start block=yes
    agent-browser = {
      url = "github:vercel-labs/agent-browser?ref=v0.22.3";
      flake = false;
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
    ast-grep-source = {
      url = "github:ast-grep/agent-skill";
      flake = false;
    };
    hashicorp-skills = {
      url = "github:hashicorp/agent-skills";
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
    nixpkgs = {
      url = "github:NixOS/nixpkgs?ref=nixos-25.11&shallow=1";
    };
    # keep-sorted end
  };

  outputs =
    {
      agent-skills,
      agent-browser,
      anthropic-skills,
      ast-grep-source,
      hashicorp-skills,
      ...
    }:
    {
      homeManagerModules = {
        default =
          { upkgs, ... }:
          {
            imports = [
              agent-skills.homeManagerModules.default
            ];

            programs = {
              agent-skills = {
                enable = true;
                sources = {
                  agent-browser-source = {
                    path = agent-browser;
                    subdir = "skills";
                  };
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
                    agent-browser = {
                      from = "agent-browser-source";
                      path = "agent-browser";
                      packages = with upkgs; [ llm-agents.agent-browser ];
                      transform =
                        { original, dependencies }:
                        ''
                          ${original}

                          ${dependencies}

                          - You should use ./agent-browser for execution.
                        '';
                    };
                    ast-grep = {
                      from = "ast-grep-source";
                      path = "ast-grep";
                      packages = with upkgs; [ ast-grep ];
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
