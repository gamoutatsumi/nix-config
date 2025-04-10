{
  description = "Nix(OS) Configurations";
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
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
    deno-overlay = {
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
      flake = false;
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
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs = {
        nixpkgs-unstable = {
          follows = "nixpkgs-unstable";
        };
        nixpkgs-stable = {
          follows = "nixpkgs";
        };
        zig = {
          follows = "zig";
        };
        flake-compat = {
          follows = "flake-compat";
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
    mcp-hub = {
      url = "github:ravitemer/mcp-hub";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
        flake-parts = {
          follows = "flake-parts";
        };
      };
    };
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
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
      url = "github:neovim/neovim/master?shallow=1";
      flake = false;
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
        flake-utils = {
          follows = "flake-utils";
        };
      };
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.11?shallow=1";
    };
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable?shallow=1";
    };
    oreore = {
      url = "github:gamoutatsumi/oreore-flake";
      inputs = {
        flake-checker = {
          follows = "";
        };
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
    yasunori = {
      url = "github:times-yasunori/awesome-yasunori";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
        treefmt-nix = {
          follows = "treefmt-nix";
        };
        flake-parts = {
          follows = "flake-parts";
        };
        systems = {
          follows = "systems";
        };
      };
    };
    zig = {
      url = "github:mitchellh/zig-overlay";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
        flake-compat = {
          follows = "";
        };
        flake-utils = {
          follows = "flake-utils";
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
      agenix-rekey,
      deno-overlay,
      disko,
      emacs-overlay,
      flake-parts,
      ghostty,
      hmd,
      home-manager,
      lanzaboote,
      mcp-hub,
      monitored,
      neovim-nightly-overlay,
      nix-darwin,
      nix-vscode-extensions,
      nixpkgs,
      nixpkgs-unstable,
      oreore,
      pre-commit-hooks,
      systems,
      treefmt-nix,
      vim-overlay,
      xremap-nix,
      yasunori,
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
          config = {
            allowUnfree = true;
          };
          overlays = [
            # keep-sorted start
            (_final: prev: { inherit (mcp-hub.packages.${prev.system}) mcp-hub; })
            (_final: prev: { inherit (yasunori.packages.${prev.system}) yasunori-mcp; })
            agenix-rekey.overlays.default
            agenix.overlays.default
            emacs-overlay.overlays.default
            ghostty.overlays.default
            neovim-nightly-overlay.overlays.default
            nix-vscode-extensions.overlays.default
            oreore.overlays.default
            vim-overlay.overlays.default
            # keep-sorted end
          ] ++ lib.optionals stdenv.isLinux [ deno-overlay.overlays.deno-overlay ];
        });
      denoVersion = "2.2.6";
      homeManagerConf =
        {
          imports,
          username,
          upkgs,
          mcp-servers-nix,
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
                mcp-servers-nix
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
        flake-parts-lib,
        ...
      }:
      let
        inherit (flake-parts-lib) importApply;
      in
      {
        systems = import systems;
        imports = [
          pre-commit-hooks.flakeModule
          treefmt-nix.flakeModule
          agenix-rekey.flakeModule
        ];
        flake = {
          nixosConfigurations = {
            "tat-nixos-laptop" = withSystem "x86_64-linux" (
              {
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
                    upkgs
                    username
                    ;
                };
                modules = [
                  monitored.nixosModules.default
                  lanzaboote.nixosModules.lanzaboote
                  xremap-nix.nixosModules.default
                  agenix.nixosModules.default
                  agenix-rekey.nixosModules.default
                  ./hosts/laptop
                  ./settings/nixos.nix
                  home-manager.nixosModules.home-manager
                  (
                    _:
                    homeManagerConf {
                      inherit username upkgs;
                      inherit (inputs) mcp-servers-nix;
                      imports = [ ./settings/home/linux.nix ];
                      networkManager = true;
                    }
                  )
                ];
              }
            );
            "tat-nixos-desktop" = withSystem "x86_64-linux" (
              {
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
                  agenix-rekey.nixosModules.default
                  ./hosts/desktop
                  ./settings/nixos.nix
                  home-manager.nixosModules.home-manager
                  (
                    _:
                    homeManagerConf {
                      inherit username upkgs;
                      inherit (inputs) mcp-servers-nix;
                      imports = [ ./settings/home/linux.nix ];
                    }
                  )
                ];
              }
            );
          };
          apps = import ./flake/parts/apps.nix {
            inherit withSystem;
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
                      inherit (inputs) mcp-servers-nix;
                      imports = [ ./settings/home/darwin.nix ];
                      username = darwinUser;
                    }
                  )
                ];
              }
            );
          };
        };
        perSystem = importApply ./flake/parts/perSystem.nix {
          inherit upkgsConf denoVersion;
          localFlake = self;
        };
      }
    );
}
