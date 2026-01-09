{
  description = "Nix(OS) Configurations";
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
      "https://gamoutatsumi-nix-config.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "gamoutatsumi-nix-config.cachix.org-1:5quoMby5QSByFx7JxJy75/JOkMmvbD314bwph5BToSw="
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
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
      };
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs = {
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
    arto = {
      url = "github:lambdalisue/rs-arto?ref=v0.8.0";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
      };
    };
    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
        nix-darwin = {
          follows = "nix-darwin";
        };
        brew-api = {
          follows = "brew-api";
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
    edgepkgs = {
      url = "github:natsukium/edgepkgs";
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
    flake-checker = {
      url = "github:DeterminateSystems/flake-checker";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-25.11";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote?ref=v1.0.0&shallow=1";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
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
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
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
      url = "github:neovim/neovim?ref=master&shallow=1";
      flake = false;
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin?ref=nix-darwin-25.11&shallow=1";
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
      };
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs?ref=nixos-25.11&shallow=1";
    };
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs?ref=nixos-unstable&shallow=1";
    };
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter?ref=main&shallow=1";
      flake = false;
    };
    nvim-treesitter-main = {
      url = "github:iofq/nvim-treesitter-main";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
        # nvim-treesitter = {
        #   follows = "nvim-treesitter";
        # };
        nvim-treesitter-textobjects = {
          follows = "nvim-treesitter-textobjects";
        };
      };
    };
    nvim-treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects?ref=main&shallow=1";
      flake = false;
    };
    opencode = {
      url = "github:anomalyco/opencode?ref=v1.1.8&shallow=1";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
      };
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
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
        systems = {
          follows = "systems";
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
        nixpkgs-stable = {
          follows = "nixpkgs";
        };
      };
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
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
      url = "github:vim/vim?shallow=1";
      flake = false;
    };
    xremap = {
      url = "github:xremap/xremap?ref=v0.14.6&shallow=1";
      flake = false;
    };
    xremap-nix = {
      url = "github:xremap/nix-flake";
      inputs = {
        flake-parts = {
          follows = "flake-parts";
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
      # keep-sorted start
      flake-parts,
      # keep-sorted end
      ...
    }@_inputs:
    flake-parts.lib.mkFlake
      {
        inputs = _inputs;
      }
      (
        {
          inputs,
          ...
        }:
        {
          systems = import inputs.systems;
          imports = [
            inputs.pre-commit-hooks.flakeModule
            inputs.treefmt-nix.flakeModule
            inputs.agenix-rekey.flakeModule
            ./flake/parts/perSystem.nix
            ./flake/parts/apps.nix
            ./flake/parts/darwin.nix
            ./flake/parts/nixos.nix
          ];
          transposition = {
            lib = { };
          };
        }
      );
}
