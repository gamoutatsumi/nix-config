{
  description = "Nix(OS) Configurations";

  inputs = {
    # keep-sorted start block=yes
    agenix = {
      url = "github:yaxitech/ragenix";
      inputs = {
        agenix = {
          follows = "agenix_orig";
        };
        crane = {
          follows = "crane";
        };
        rust-overlay = {
          follows = "rust-overlay";
        };
        nixpkgs = {
          follows = "nixpkgs";
        };
        flake-utils = {
          follows = "flake-utils";
        };
      };
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs = {
        devshell = {
          follows = "devshell";
        };
        pre-commit-hooks = {
          follows = "";
        };
        nixpkgs = {
          follows = "nixpkgs";
        };
        flake-utils = {
          follows = "flake-utils";
        };
      };
    };
    agenix_orig = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
        systems = {
          follows = "systems";
        };
        home-manager = {
          follows = "home-manager";
        };
        darwin = {
          follows = "nix-darwin";
        };
      };
    };
    crane = {
      url = "github:ipetkov/crane";
    };
    dagger = {
      url = "github:dagger/nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    disko = {
      url = "github:nix-community/disko";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs = {
        nixpkgs-lib = {
          follows = "nixpkgs";
        };
      };
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs = {
        systems = {
          follows = "systems";
        };
      };
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
        flake-parts = {
          follows = "flake-parts";
        };
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs = {
        crane = {
          follows = "crane";
        };
        rust-overlay = {
          follows = "rust-overlay";
        };
        flake-utils = {
          follows = "flake-utils";
        };
        pre-commit-hooks-nix = {
          follows = "";
        };
        flake-compat = {
          follows = "";
        };
        flake-parts = {
          follows = "flake-parts";
        };
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        hercules-ci-effects = {
          follows = "";
        };
        git-hooks = {
          follows = "";
        };
        flake-compat = {
          follows = "";
        };
        flake-parts = {
          follows = "flake-parts";
        };
        neovim-src = {
          url = "github:neovim/neovim";
          flake = false;
        };
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
      };
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.05";
    };
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    oreore = {
      url = "github:gamoutatsumi/oreore-flake";
      inputs = {
        systems = {
          follows = "systems";
        };
        flake-compat = {
          follows = "flake-compat";
        };
        devenv = {
          follows = "";
        };
        nix = {
          follows = "";
        };
        flake-parts = {
          follows = "flake-parts";
        };
        pre-commit-hooks = {
          follows = "";
        };
        treefmt-nix = {
          follows = "";
        };
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat = {
          follows = "flake-compat";
        };
        gitignore = {
          follows = "gitignore";
        };
        nixpkgs-stable = {
          follows = "nixpkgs";
        };
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    systems = {
      url = "github:nix-systems/default";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    # keep-sorted end
  };
  outputs =
    {
      self,
      # keep-sorted start
      agenix,
      dagger,
      disko,
      flake-parts,
      home-manager,
      lanzaboote,
      neovim-nightly-overlay,
      nix-darwin,
      nixpkgs,
      nixpkgs-unstable,
      oreore,
      pre-commit-hooks,
      systems,
      treefmt-nix,
      # keep-sorted end
      ...
    }@inputs:
    (flake-parts.lib.mkFlake { inherit inputs; } (
      {
        inputs,
        lib,
        withSystem,
        ...
      }:
      {
        systems = import systems;
        imports =
          [ ]
          ++ lib.optionals (inputs.pre-commit-hooks ? flakeModule) [ inputs.pre-commit-hooks.flakeModule ]
          ++ lib.optionals (inputs.treefmt-nix ? flakeModule) [ inputs.treefmt-nix.flakeModule ]
          ++ lib.optionals (inputs.agenix-rekey ? flakeModule) [ inputs.agenix-rekey.flakeModule ];
        flake = {
          nixosConfigurations."tat-nixos-desktop" = withSystem "x86_64-linux" (
            {
              config,
              inputs',
              system,
              ...
            }:
            let
              username = "gamoutatsumi";
              overlays = [
                agenix.overlays.default
                inputs.agenix-rekey.overlays.default
                oreore.overlays.default
              ];
              upkgs = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
                overlays = [ neovim-nightly-overlay.overlays.default ];
              };
            in
            nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit inputs inputs';
                username = username;
                upkgs = upkgs;
              };
              modules = [
                { nixpkgs.overlays = overlays; }
                lanzaboote.nixosModules.lanzaboote
                disko.nixosModules.disko
                agenix.nixosModules.default
                inputs.agenix-rekey.nixosModules.default
                ./secrets.nix
                (import ./disko-config.nix { device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_24116U400484"; })
                ./hosts/desktop
                ./settings/nixos.nix
                home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = false;
                    users = {
                      "${username}" = {
                        imports = [ ./settings/home/linux.nix ];
                      };
                    };
                    extraSpecialArgs = {
                      username = username;
                      upkgs = upkgs;
                    };
                  };
                }
              ];
            }
          );
          apps = withSystem "aarch64-darwin" (
            {
              config,
              inputs',
              system,
              pkgs,
              ...
            }:
            {
              ${system} = {
                update = {
                  program = toString (
                    pkgs.writeShellScript "update" ''
                      set -e
                      echo "Updating ${system}..."
                      nix-channel --update
                      nix flake update --commit-lock-file
                      nix run nix-darwin -- switch --flake .#$1 --impure
                      echo "Updated ${system}"
                    ''
                  );
                  type = "app";
                };
              };
            }
          );
          darwinConfigurations.work = withSystem "aarch64-darwin" (
            {
              config,
              inputs',
              system,
              ...
            }:
            let
              darwinUser = builtins.getEnv "DARWIN_USER";
              darwinHost = builtins.getEnv "DARWIN_HOST";
              overlays = [ oreore.overlays.default ];
              upkgs = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
                overlays = [ neovim-nightly-overlay.overlays.default ];
              };
            in
            nix-darwin.lib.darwinSystem {
              inherit system;
              specialArgs = {
                inherit inputs;
                username = darwinUser;
                upkgs = upkgs;
                hostname = darwinHost;
              };
              modules = [
                { nixpkgs.overlays = overlays; }
                ./hosts/work_darwin
                ./settings/darwin.nix
                home-manager.darwinModules.home-manager
                {
                  home-manager = {
                    backupFileExtension = "backup";
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users = {
                      "${darwinUser}" = {
                        imports = [ ./settings/home/darwin.nix ];
                      };
                    };
                    extraSpecialArgs = {
                      username = darwinUser;
                      upkgs = upkgs;
                    };
                  };
                }
              ];
            }
          );
        };
        perSystem = (
          {
            system,
            pkgs,
            config,
            ...
          }:
          let
            upkgs = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
              overlays = [ neovim-nightly-overlay.overlays.default ];
            };
          in
          {
            agenix-rekey = {
              nodes = self.nixosConfigurations;
            };
            devShells = {
              default = pkgs.mkShellNoCC {
                packages =
                  (with pkgs; [
                    nixfmt-rfc-style
                    stylua
                  ])
                  ++ [ dagger.packages.${system}.dagger ];
                inputsFrom =
                  [ ]
                  ++ lib.optionals (inputs.pre-commit-hooks ? flakeModule) [ config.pre-commit.devShell ];
              };
            };
          }
          // lib.optionalAttrs (inputs.pre-commit-hooks ? flakeModule) {
            pre-commit = {
              check = {
                enable = true;
              };
              settings = {
                src = ./.;
                hooks = {
                  treefmt = {
                    enable = true;
                    packageOverrides.treefmt = config.treefmt.build.wrapper;
                  };
                };
              };
            };
          }
          // lib.optionalAttrs (inputs.treefmt-nix ? flakeModule) {
            formatter = config.treefmt.build.wrapper;
            treefmt = {
              projectRootFile = "flake.nix";
              flakeCheck = false;
              programs = {
                # keep-sorted start block=yes
                cue = {
                  enable = true;
                };
                deno = {
                  enable = true;
                  package = upkgs.deno;
                };
                keep-sorted = {
                  enable = true;
                };
                nixfmt = {
                  enable = true;
                };
                stylua = {
                  enable = true;
                };
                taplo = {
                  enable = true;
                };
                yamlfmt = {
                  enable = true;
                };
                # keep-sorted end
              };
            };
          }
        );
      }
    ));
}
