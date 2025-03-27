{
  lib,
  pkgs,
  upkgs,
  denoVersion,
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
          OCO_MODEL = "codestral:22b-v0.1-q4_K_S";
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
      "mcp/mcpservers.json" = {
        text = lib.strings.toJSON { mcpServers = { }; };
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
              ];
              skk_dict = "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L";
              deno =
                if pkgs.stdenv.isLinux then "${upkgs.deno."${denoVersion}"}/bin/deno" else "${upkgs.deno}/bin/deno";
              copilot_ls = "${upkgs.copilot-language-server}/bin/copilot-language-server";
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
