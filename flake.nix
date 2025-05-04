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
      inputs = {
        nixpkgs-lib = {
          follows = "nixpkgs-unstable";
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
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.11";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote?ref=v0.4.1";
      inputs = {
        pre-commit-hooks-nix = {
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
    mpd-mcp-server = {
      url = "github:gamoutatsumi/mpd-mcp-server";
      inputs = {
        systems = {
          follows = "systems";
        };
        flake-parts = {
          follows = "flake-parts";
        };
        pre-commit-hooks = {
          follows = "pre-commit-hooks";
        };
        treefmt-nix = {
          follows = "treefmt-nix";
        };
        flake-checker = {
          follows = "flake-checker";
        };
      };
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        git-hooks = {
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
      url = "github:neovim/neovim?ref=master&shallow=1";
      flake = false;
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin?ref=nix-darwin-24.11";
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
      url = "github:NixOS/nixpkgs?ref=nixos-24.11&shallow=1";
    };
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs?ref=5bf57e211f39a0e219c756789ed8d915b7e33389&shallow=1";
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
      url = "github:xremap/xremap?ref=v0.10.10";
      flake = false;
    };
    xremap-nix = {
      url = "github:xremap/nix-flake";
      inputs = {
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
    # keep-sorted end
  };
  outputs =
    {
      # keep-sorted start
      agenix-rekey,
      flake-parts,
      pre-commit-hooks,
      systems,
      treefmt-nix,
      # keep-sorted end
      ...
    }@inputs:
    flake-parts.lib.mkFlake
      {
        inherit inputs;
      }
      (
        {
          ...
        }:
        {
          systems = import systems;
          imports = [
            pre-commit-hooks.flakeModule
            treefmt-nix.flakeModule
            agenix-rekey.flakeModule
            ./flake/parts/perSystem.nix
            ./flake/parts/apps.nix
            ./flake/parts/darwin.nix
            ./flake/parts/nixos.nix
          ];
        }
      );
}
