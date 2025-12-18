{
  lib,
  inputs,
  pkgs,
  upkgs,
  config,
  username,
  ...
}:
let
  toKeyValue = lib.generators.toKeyValue { listsAsDuplicateKeys = true; };
in
{
  home = {
    username = "${username}";
    stateVersion = "25.11"; # Please read the comment before changing.
  };
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
    ./programs
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
      "ghostty/themes/nightfly" = {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/bluz71/vim-nightfly-colors/refs/heads/master/extras/nightfly-ghostty.conf";
          sha256 = "/cR4H3FN7lHVD5dMXq7khjn+a5nMdXuEPpM5hC94meE=";
        };
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
              src = ./config/nvim/lua/core/dpp.lua;
              replacements = {
                deno = lib.getExe upkgs.deno;
                dpp_ts = "${
                  pkgs.linkFarm "dpp" [
                    {
                      name = "dpp.ts";
                      path = pkgs.replaceVars ./dpp/hooks/dpp.ts (import ./dpp/default.nix { pkgs = upkgs; });
                    }
                    {
                      name = "deno.json";
                      path = ./dpp/hooks/deno.json;
                    }
                  ]
                }/dpp.ts";
              };
              dir = "lua/core";
            })
            (pkgs.replaceVarsWith {
              src = ./config/nvim/lua/core/vars.lua;
              replacements = {
                python3 = lib.getExe upkgs.python313;
              };
              dir = "lua/core";
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
}
