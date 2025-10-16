{
  lib,
  inputs,
  pkgs,
  upkgs,
  config,
  ...
}:
let
  toKeyValue = lib.generators.toKeyValue { listsAsDuplicateKeys = true; };
  # blocc = upkgs.callPackage ../../../nvfetcher/blocc.nix { };

  nodePkgs = upkgs.callPackage ../../../node2nix { };
in
{
  nix = {
    settings = {
      nix-path = [
        "nixpkgs=${inputs.nixpkgs.outPath}"
        "nixpkgs-unstable=${inputs.nixpkgs-unstable.outPath}"
      ];
    };
    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
      nixpkgs-unstable = {
        flake = inputs.nixpkgs-unstable;
      };
    };
  };
  imports = [
    ./programs.nix
    ./services.nix
  ];
  home = {
    activation = {
      zcompileZshrc = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        run ${lib.getExe config.programs.zsh.package} -c 'zcompile ${config.programs.zsh.dotDir}/.zshrc'
      '';
      zcompileZshenv = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        run ${lib.getExe config.programs.zsh.package} -c 'zcompile ${config.programs.zsh.dotDir}/.zshenv'
      '';
    };
    file = {
      ".vscode/argv.json".text = lib.strings.toJSON {
        password-store = "gnome-libsecret";
        locale = "ja";
      };
      ".p10k.zsh" = {
        source = ./config/p10k.zsh;
      };
      ".opencommit" = {
        text = toKeyValue {
          # keep-sorted start
          OCO_AI_PROVIDER = "ollama";
          OCO_API_KEY = "ollama";
          OCO_API_URL = "http://127.0.0.1:11434/api/chat";
          OCO_DESCRIPTION = true;
          OCO_EMOJI = true;
          OCO_GITPUSH = false;
          OCO_LANGUAGE = "en";
          OCO_MODEL = "phi4";
          OCO_ONE_LINE_COMMIT = false;
          OCO_PROMPT_MODULE = "conventional-commit";
          # keep-sorted end
        };
      };
    };
  };
  xdg = {
    configFile = {
      "ghostty/themes/nightfly.conf" = {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/bluz71/vim-nightfly-colors/refs/heads/master/extras/nightfly-ghostty.conf";
          sha256 = lib.fakeSha256;
        };
      };
      "claude/settings.json" = {
        text = builtins.toJSON {
          # hooks = {
          #   PostToolUse = [
          #     {
          #       matcher = "Write|Edit|MultiEdit";
          #       hooks = [
          #         {
          #           type = "command";
          #           command = "${lib.getExe blocc} 'nix flake check'";
          #         }
          #       ];
          #     }
          #   ];
          # };
          statusLine = {
            type = "command";
            command = "${lib.getExe' nodePkgs.ccusage "ccusage"} statusline";
          };
          permissions = {
            allow = [
            ];
            deny = [
              "Bash(sudo:*)"
              "Bash(rm:*)"
              "Bash(rm -rf:*)"
              "Bash(git push:*)"
              "Bash(git reset:*)"
              "Bash(git rebase:*)"
              "Read(.env.*)"
              "Read(id_rsa)"
              "Read(id_ed25519)"
              "Read(**/*token*)"
              "Read(**/*key*)"
              "Write(.env*)"
              "Write(**/secrets/**)"
              "Bash(curl:*)"
              "Bash(wget:*)"
              "Bash(nc:*)"
              "Bash(npm uninstall:*)"
              "Bash(npm remove:*)"
              "Bash(psql:*)"
              "Bash(mysql:*)"
              "Bash(mongod:*)"
              "mcp__supabase__execute_sql"
            ];
          };
        };
      };
      "claude/.mcp.json" = {
        source = import ../../../mcp.nix {
          format = "json";
          flavor = "claude";
          inherit config lib inputs;
          pkgs = upkgs;
        };
      };
      "claude/commands" = {
        source = ./config/claude/commands;
      };
      "zeno" = {
        source = ./config/zeno;
      };
      "ov/config.yaml" = {
        source = ./config/ov/config.yaml;
      };
      "sheldon" = {
        source = ./config/sheldon;
      };
      "nvim" = {
        source = pkgs.symlinkJoin {
          name = "nvim";
          paths = [
            (pkgs.replaceVarsWith {
              src = ./config/nvim/dpp/skkeleton.vim;
              replacements = {
                skk_dict = "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L";
              };
              dir = "dpp";
            })
            (pkgs.replaceVarsWith {
              src = ./config/nvim/lua/core/dpp.lua;
              replacements = {
                deno = lib.getExe upkgs.deno;
              };
              dir = "lua/core";
            })
            (pkgs.replaceVarsWith {
              src = ./config/nvim/dpp/copilot.lua;
              replacements = {
                copilot_ls = lib.getExe upkgs.copilot-language-server;
              };
              dir = "dpp";
            })
            (pkgs.replaceVarsWith {
              src = ./config/nvim/dpp/mcphub.lua;
              replacements = {
                mcp_hub = lib.getExe' upkgs.mcp-hub "mcp-hub";
                mcp_config = "${import ../../../mcp.nix {
                  format = "json";
                  pkgs = upkgs;
                  inherit config lib inputs;
                }}";
              };
              dir = "dpp";
            })
            (pkgs.replaceVarsWith {
              src = ./config/nvim/lua/core/vars.lua;
              replacements = {
                python3 = lib.getExe upkgs.python313;
              };
              dir = "lua/core";
            })
            "${(pkgs.callPackage ../../../_sources/generated.nix { }).treesitter.src}/runtime"
            (upkgs.symlinkJoin {
              name = "ts-parsers";
              paths = upkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
            })
            ./config/nvim
          ];
        };
      };
      "git/template/hooks/pre-push" = {
        source = pkgs.fetchurl {
          url = "https://gist.githubusercontent.com/quintok/815396509ff79d886656b2855e1a8a46/raw/e6770add98e7db57177c16d33be31bfdf2c23042/pre-push";
          sha256 = "0lynwihky1b6r8ssjzzw99p38vya39x204gknpi2fdg720jj87yj";
        };
      };
      "git/ignore" = {
        source = ./config/git/ignore;
      };
    };
    enable = true;
  };
  theme = {
    wallpaper = {
      file = pkgs.fetchurl {
        url = "https://atri-mdm.com/assets/img/special/present/wp_ATRI.jpg";
        sha256 = "069z1m3664xaciw9hhpqzsa5x5k802fpk9wxbkjxz4chmjnazzfj";
      };
    };
    tinty = {
      enable = false;
      generate = {
        variant = "dark";
        system = "base24";
      };
      shell = "zsh";
      themes = {
        alacritty = {
          enable = true;
        };
        shell = {
          enable = true;
        };
      };
    };
  };
}
