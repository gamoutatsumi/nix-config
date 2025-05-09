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
in
{
  imports = [
    ./programs.nix
    ./services.nix
  ];
  home = {
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
            (pkgs.substituteAllFiles {
              src = ./config/nvim;
              files = [
                "dpp/skkeleton.vim"
                "init/plugins/dpp.vim"
                "dpp/copilot.lua"
                "dpp/treesitter.lua"
                "dpp/mcphub.lua"
              ];
              skk_dict = "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L";
              deno = lib.getExe upkgs.deno;
              copilot_ls = lib.getExe upkgs.copilot-language-server;
              mcp_hub = lib.getExe' upkgs.mcp-hub "mcp-hub";
              mcp_config = "${import ../../../mcp.nix {
                format = "json";
                pkgs = upkgs;
                inherit config lib inputs;
              }}";
              treesitter_parsers = "${upkgs.symlinkJoin {
                name = "ts-parsers";
                paths = upkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
              }}";
            })
            ./config/nvim
          ];
        };
      };
      # "nvim".source = ./config/nvim;
      "git/template/hooks/pre-push" = {
        source = builtins.fetchurl {
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
      file = builtins.fetchurl {
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
