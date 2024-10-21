{
  description = "Nix(OS) Configurations";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
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
          follows = "pre-commit-hooks";
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
          follows = "pre-commit-hooks";
        };
        flake-compat = {
          follows = "flake-compat";
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
          follows = "hercules-ci-effects";
        };
        git-hooks = {
          follows = "pre-commit-hooks";
        };
        flake-compat = {
          follows = "flake-compat";
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
        flake-parts = {
          follows = "flake-parts";
        };
        pre-commit-hooks = {
          follows = "pre-commit-hooks";
        };
        flake-compat = {
          follows = "flake-compat";
        };
        treefmt-nix = {
          follows = "treefmt-nix";
        };
        dagger = {
          follows = "dagger";
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
      agenix-rekey,
      dagger,
      disko,
      flake-utils,
      home-manager,
      lanzaboote,
      neovim-nightly-overlay,
      nix-darwin,
      nixpkgs,
      nixpkgs-unstable,
      oreore,
      pre-commit-hooks,
      treefmt-nix,
      # keep-sorted end
      ...
    }@inputs:
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hooks = pre-commit-hooks.lib.${system};
        treefmtEval = (treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
      in
      {
        formatter = (treefmtEval.config.build.wrapper);
        checks = {
          pre-commit-check = hooks.run {
            src = ./.;
            hooks = {
              treefmt = {
                packageOverrides.treefmt = (treefmtEval.config.build.wrapper);
                enable = true;
              };
            };
          };
        };
        devShells = {
          default = pkgs.mkShellNoCC {
            packages =
              (with pkgs; [
                nixfmt-rfc-style
                stylua
              ])
              ++ [ dagger.packages.${system}.dagger ];
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
          };
        };
      }
    ))
    // (
      let
        username = "gamoutatsumi";
        system = "x86_64-linux";
        overlays = [
          oreore.overlays.default
          agenix.overlays.default
          agenix-rekey.overlays.default
        ];
        upkgs = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          overlays = [ neovim-nightly-overlay.overlays.default ];
        };
      in
      {
        nixosConfigurations."tat-nixos-desktop" = nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit inputs;
            username = username;
            upkgs = upkgs;
          };
          modules = [
            { nixpkgs.overlays = overlays; }
            lanzaboote.nixosModules.lanzaboote
            disko.nixosModules.disko
            agenix.nixosModules.default
            agenix-rekey.nixosModules.default
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
        };
      }
    )
    // {
      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nodes = self.nixosConfigurations;
      };
    }
    // (
      let
        system = "aarch64-darwin";
        darwinUser = builtins.getEnv "DARWIN_USER";
        darwinHost = builtins.getEnv "DARWIN_HOST";
        overlays = [ oreore.overlays.default ];
        pkgs = import nixpkgs { inherit system; };
        upkgs = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          overlays = [ neovim-nightly-overlay.overlays.default ];
        };
      in
      {
        apps.${system}.update = {
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
        darwinConfigurations.work = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
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
        };
      }
    );
}
