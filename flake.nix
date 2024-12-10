{
  description = "Nix(OS) Configurations";
  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

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
          follows = "nixpkgs-unstable";
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
          follows = "pre-commit-hooks";
        };
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
        flake-parts = {
          follows = "flake-parts";
        };
        treefmt-nix = {
          follows = "treefmt-nix";
        };
      };
    };
    agenix_orig = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
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
          follows = "nixpkgs-unstable";
        };
      };
    };
    deno = {
      url = "github:haruki7049/deno-overlay";
      inputs = {
        flake-parts = {
          follows = "flake-parts";
        };
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
        treefmt-nix = {
          follows = "treefmt-nix";
        };
        flake-compat = {
          follows = "flake-compat";
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
          follows = "nixpkgs-unstable";
        };
      };
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
        nixpkgs-stable = {
          follows = "nixpkgs";
        };
      };
    };
    fenix = {
      url = "https://flakehub.com/f/nix-community/fenix/0.1.*";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    flake-checker = {
      url = "github:DeterminateSystems/flake-checker";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
        fenix = {
          follows = "fenix";
        };
        naersk = {
          follows = "naersk";
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
          follows = "nixpkgs-unstable";
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
    hmd = {
      url = "github:pedorich-n/home-manager-diff";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
        systems = {
          follows = "systems";
        };
        flake-parts = {
          follows = "flake-parts";
        };
        flake-utils = {
          follows = "flake-utils";
        };
        poetry2nix = {
          follows = "poetry2nix";
        };
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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
    monitored = {
      url = "github:ners/nix-monitored";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
      };
    };
    naersk = {
      url = "https://flakehub.com/f/nix-community/naersk/0.1.*";
      inputs = {
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
          follows = "neovim-src";
        };
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
      };
    };
    neovim-src = {
      url = "github:neovim/neovim";
      flake = false;
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
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    oreore = {
      url = "github:gamoutatsumi/oreore-flake";
      inputs = {
        tinty-schemes = {
          follows = "tinty-schemes";
        };
        nixpkgs-unstable = {
          follows = "nixpkgs-unstable";
        };
        rust-overlay = {
          follows = "rust-overlay";
        };
        systems = {
          follows = "systems";
        };
        flake-compat = {
          follows = "flake-compat";
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
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
        systems = {
          follows = "systems";
        };
        flake-utils = {
          follows = "flake-utils";
        };
        nix-github-actions = {
          follows = "";
        };
        treefmt-nix = {
          follows = "";
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
          follows = "nixpkgs-unstable";
        };
      };
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
      };
    };
    systems = {
      url = "github:nix-systems/default";
    };
    tinty-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
      };
    };
    vim-overlay = {
      url = "github:kawarimidoll/vim-overlay";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
        pre-commit-hooks = {
          follows = "pre-commit-hooks";
        };
        vim-src = {
          follows = "vim-src";
        };
      };
    };
    vim-src = {
      url = "github:vim/vim";
      flake = false;
    };
    xremap = {
      url = "github:xremap/xremap?ref=v0.10.2";
      flake = false;
    };
    xremap-nix = {
      url = "github:xremap/nix-flake";
      inputs = {
        crane = {
          follows = "crane";
        };
        devshell = {
          follows = "devshell";
        };
        hyprland = {
          follows = "";
        };
        flake-parts = {
          follows = "flake-parts";
        };
        home-manager = {
          follows = "home-manager";
        };
        treefmt-nix = {
          follows = "treefmt-nix";
        };
        xremap = {
          follows = "xremap";
        };
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
      deno,
      disko,
      emacs-overlay,
      flake-checker,
      flake-parts,
      hmd,
      home-manager,
      lanzaboote,
      monitored,
      neovim-nightly-overlay,
      nix-darwin,
      nixpkgs,
      nixpkgs-unstable,
      oreore,
      pre-commit-hooks,
      systems,
      treefmt-nix,
      vim-overlay,
      xremap-nix,
      # keep-sorted end
      ...
    }@inputs:
    let
      upkgsConf =
        {
          system,
          stdenv,
          lib,
        }:
        (import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            # keep-sorted start
            agenix.overlays.default
            emacs-overlay.overlays.default
            inputs.agenix-rekey.overlays.default
            neovim-nightly-overlay.overlays.default
            oreore.overlays.default
            vim-overlay.overlays.default
            # keep-sorted end
          ] ++ lib.optionals stdenv.isLinux [ deno.overlays.deno-overlay ];
        });
      denoVersion = "2.1.3";
      homeManagerConf =
        {
          imports,
          username,
          upkgs,
          networkManager ? false,
        }:
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = false;
            users = {
              "${username}" = {
                imports = [
                  oreore.homeManagerModules.theme
                  hmd.hmModules.default
                ] ++ imports;
              };
            };
            backupFileExtension = "bak";
            extraSpecialArgs = {
              inherit
                username
                upkgs
                denoVersion
                networkManager
                ;
            };
          };
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        inputs,
        lib,
        withSystem,
        ...
      }:
      {
        systems = import systems;
        imports =
          lib.optionals (inputs.pre-commit-hooks ? flakeModule) [ inputs.pre-commit-hooks.flakeModule ]
          ++ lib.optionals (inputs.treefmt-nix ? flakeModule) [ inputs.treefmt-nix.flakeModule ]
          ++ lib.optionals (inputs.agenix-rekey ? flakeModule) [ inputs.agenix-rekey.flakeModule ];
        flake = {
          nixosConfigurations = {
            "tat-nixos-laptop" = withSystem "x86_64-linux" (
              {
                inputs',
                system,
                pkgs,
                ...
              }:
              let
                username = "gamoutatsumi";
                upkgs = upkgsConf {
                  inherit system;
                  inherit (pkgs) stdenv lib;
                };
              in
              nixpkgs.lib.nixosSystem {
                specialArgs = {
                  inherit
                    inputs
                    inputs'
                    upkgs
                    username
                    ;
                };
                modules = [
                  monitored.nixosModules.default
                  lanzaboote.nixosModules.lanzaboote
                  xremap-nix.nixosModules.default
                  agenix.nixosModules.default
                  inputs.agenix-rekey.nixosModules.default
                  ./hosts/laptop
                  ./settings/nixos.nix
                  home-manager.nixosModules.home-manager
                  (
                    _:
                    homeManagerConf {
                      inherit username upkgs;
                      imports = [ ./settings/home/linux.nix ];
                      networkManager = true;
                    }
                  )
                ];
              }
            );
            "tat-nixos-desktop" = withSystem "x86_64-linux" (
              {
                inputs',
                system,
                pkgs,
                ...
              }:
              let
                username = "gamoutatsumi";
                upkgs = upkgsConf {
                  inherit system;
                  inherit (pkgs) stdenv lib;
                };
              in
              nixpkgs.lib.nixosSystem {
                specialArgs = {
                  inherit
                    inputs
                    inputs'
                    upkgs
                    username
                    ;
                  device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_24116U400484";
                };
                modules = [
                  monitored.nixosModules.default
                  lanzaboote.nixosModules.lanzaboote
                  disko.nixosModules.disko
                  agenix.nixosModules.default
                  inputs.agenix-rekey.nixosModules.default
                  ./hosts/desktop
                  ./settings/nixos.nix
                  home-manager.nixosModules.home-manager
                  (
                    _:
                    homeManagerConf {
                      inherit username upkgs;
                      imports = [ ./settings/home/linux.nix ];
                    }
                  )
                ];
              }
            );
          };
          apps = {
            "aarch64-darwin" = withSystem "aarch64-darwin" (
              {
                system,
                pkgs,
                ...
              }:
              {
                update = {
                  program = toString (
                    pkgs.writeShellScript "update" ''
                      set -e
                      echo "Updating ${system}..."
                      nix flake update --commit-lock-file nixpkgs neovim-nightly-overlay neovim-src nixpkgs-unstable oreore home-manager hmd systems
                      old_system=$(${pkgs.coreutils}/bin/readlink -f /run/current-system)
                      nix run nix-darwin -- switch --flake .#$1 --impure --show-trace |& ${pkgs.nix-output-monitor}/bin/nom
                      new_system=$(${pkgs.coreutils}/bin/readlink -f /run/current-system)
                      ${pkgs.nvd}/bin/nvd diff "''${old_system}" "''${new_system}"
                    ''
                  );
                  type = "app";
                };
              }
            );
            "x86_64-linux" = withSystem "x86_64-linux" (
              {
                system,
                pkgs,
                ...
              }:
              {
                update = {
                  program = toString (
                    pkgs.writeShellScript "update" ''
                      set -e
                      set -o pipefail
                      echo "Updating ${system}..."
                      nix flake update --commit-lock-file
                      old_system=$(${pkgs.coreutils}/bin/readlink -f /run/current-system)
                      sudo nixos-rebuild switch --flake . --show-trace |& ${pkgs.nix-output-monitor}/bin/nom
                      new_system=$(${pkgs.coreutils}/bin/readlink -f /run/current-system)
                      ${pkgs.nvd}/bin/nvd diff "''${old_system}" "''${new_system}"
                    ''
                  );
                };
              }
            );
          };
          darwinConfigurations = {
            work = withSystem "aarch64-darwin" (
              {
                system,
                pkgs,
                ...
              }:
              let
                darwinUser = builtins.getEnv "DARWIN_USER";
                darwinHost = builtins.getEnv "DARWIN_HOST";
                upkgs = upkgsConf {
                  inherit system;
                  inherit (pkgs) stdenv lib;
                };
              in
              nix-darwin.lib.darwinSystem {
                inherit system;
                specialArgs = {
                  inherit inputs upkgs;
                  username = darwinUser;
                  hostname = darwinHost;
                };
                modules = [
                  ./hosts/work_darwin
                  ./settings/darwin.nix
                  monitored.darwinModules.default
                  home-manager.darwinModules.home-manager
                  (
                    _:
                    homeManagerConf {
                      inherit upkgs;
                      imports = [ ./settings/home/darwin.nix ];
                      username = darwinUser;
                    }
                  )
                ];
              }
            );
          };
        };
        perSystem =
          {
            system,
            pkgs,
            config,
            ...
          }:
          let
            upkgs = upkgsConf {
              inherit system;
              inherit (pkgs) stdenv lib;
            };
            treefmtBuild = config.treefmt.build;
            deno = if pkgs.stdenv.isLinux then upkgs.deno."${denoVersion}" else upkgs.deno;
          in
          {
            agenix-rekey = {
              inherit (self) nixosConfigurations;
              pkgs = upkgs;
            };
            devShells = {
              default = pkgs.mkShellNoCC {
                packages =
                  (with pkgs; [
                    efm-langserver
                    lua-language-server
                    (pkgs.haskell.packages.ghc98.ghcWithPackages (
                      haskellPackages:
                      with haskellPackages;
                      [
                        containers
                        unix
                        directory
                        haskell-language-server
                      ]
                      ++ lib.optionals pkgs.stdenv.isLinux [
                        xmonad
                        xmonad-extras
                        xmonad-contrib
                      ]
                    ))
                  ])
                  ++ [ dagger.packages.${system}.dagger ];
                inputsFrom =
                  lib.optionals (inputs.pre-commit-hooks ? flakeModule) [ config.pre-commit.devShell ]
                  ++ lib.optionals (inputs.treefmt-nix ? flakeModule) [ treefmtBuild.devShell ];
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
                  # keep-sorted start block=yes
                  check-json = {
                    enable = true;
                  };
                  check-toml = {
                    enable = true;
                  };
                  deadnix = {
                    enable = true;
                  };
                  denolint = {
                    enable = true;
                    package = deno;
                  };
                  flake-checker = {
                    enable = true;
                    package = flake-checker.packages.${system}.flake-checker;
                  };
                  statix = {
                    enable = true;
                  };
                  treefmt = {
                    enable = true;
                    packageOverrides.treefmt = treefmtBuild.wrapper;
                  };
                  yamllint = {
                    enable = true;
                  };
                  # keep-sorted end
                };
              };
            };
          }
          // lib.optionalAttrs (inputs.treefmt-nix ? flakeModule) {
            formatter = treefmtBuild.wrapper;
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
                  package = deno;
                };
                jsonfmt = {
                  enable = true;
                };
                keep-sorted = {
                  enable = true;
                };
                nixfmt = {
                  enable = true;
                };
                shfmt = {
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
          };
      }
    );
}
