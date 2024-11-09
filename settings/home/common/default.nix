{ lib, pkgs, ... }:
let
  toINI = lib.generators.toINIWithGlobalSection { listsAsDuplicateKeys = true; };
in
{
  imports = [
    ./programs.nix
    ./services.nix
  ];
  home.file = {
    ".p10k.zsh" = {
      source = ./config/p10k.zsh;
    };
    ".aicommit2" = {
      text = toINI {
        globalSection = {
          logging = false;
          generate = "2";
          temperature = "1.0";
        };
        sections = {
          OLLAMA = {
            temperature = "0.7";
            "model[]" = [ "codestral:22b" ];
            host = "http://127.0.0.1:11434";
          };
        };
      };
    };
  };
  xdg = {
    configFile = {
      # "emacs/init.el".source = ./config/emacs/init.el;
      "zeno" = {
        source = ./config/zeno;
      };
      "ov/config.yaml" = {
        source = ./config/ov/config.yaml;
      };
      "tmux" = {
        source = ./config/tmux;
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
              files = [ "dpp/skkeleton.vim" ];
              skk_dict = "${pkgs.skk-dicts}";
            })
            ./config/nvim
          ];
        };
      };
      # "nvim".source = ./config/nvim;
      "alacritty/nightfly.toml" = {
        source = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/bluz71/vim-nightfly-colors/master/extras/nightfly-alacritty.toml";
          sha256 = "0ssgf9i5nrc2m57zvgfzlgfvyhcrwd73pkiny266ba201niv6qi1";
        };
      };
      "bat/themes/fly16.tmTheme" = {
        source = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/bluz71/fly16-bat/master/fly16.tmTheme";
          sha256 = "0xp10xdcsnfpwzhwpjj4jsgwjkzpaln2d2gc9iznfzkq95a9njs8";
        };
      };
      "git/template/hooks/pre-push" = {
        source = builtins.fetchurl {
          url = "https://gist.githubusercontent.com/quintok/815396509ff79d886656b2855e1a8a46/raw/e6770add98e7db57177c16d33be31bfdf2c23042/pre-push";
          sha256 = "0lynwihky1b6r8ssjzzw99p38vya39x204gknpi2fdg720jj87yj";
        };
      };
      "git/config" = {
        source = ./config/git/config;
      };
      "git/ignore" = {
        source = ./config/git/ignore;
      };
    };
    dataFile = {
      "tmux/plugins/tpm" = {
        source = builtins.fetchTarball {
          url = "https://github.com/tmux-plugins/tpm/archive/refs/heads/master.zip";
          sha256 = "01ribl326n6n0qcq68a8pllbrz6mgw55kxhf9mjdc5vw01zjcvw5";
        };
      };
    };
    enable = true;
  };
}
