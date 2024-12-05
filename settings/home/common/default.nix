{
  lib,
  pkgs,
  upkgs,
  denoVersion,
  ...
}:
let
  toINI = lib.generators.toINIWithGlobalSection { listsAsDuplicateKeys = true; };
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
                "denops.toml"
              ];
              skk_dict = "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L";
              deno =
                if pkgs.stdenv.isLinux then "${upkgs.deno."${denoVersion}"}/bin/deno" else "${upkgs.deno}/bin/deno";
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
      enable = true;
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
