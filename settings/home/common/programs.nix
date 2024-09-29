{
  pkgs,
  config,
  upkgs,
  ...
}:
let
  gpgKey = pkgs.fetchurl {
    url = "https://github.com/gamoutatsumi.gpg";
    sha256 = "0p1xp2rq7r0hbdi7dkhw3fzrf2ij7b3p6a5nnk0fflda4cs6a814";
  };
in
{
  imports = [ ./packages/aicommit2.nix ];
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };
    wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./config/wezterm/wezterm.lua;
      colorSchemes = {
        nightfly = {
          background = "#011627";
          foreground = "#acb4c2";
          cursor_bg = "#9ca1aa";
          cursor_border = "#9ca1aa";
          cursor_fg = "#080808";
          selection_bg = "#b2ceee";
          selection_fg = "#080808";

          ansi = [
            "#1d3b53"
            "#fc514e"
            "#a1cd5e"
            "#e3d18a"
            "#82aaff"
            "#c792ea"
            "#7fdbca"
            "#a1aab8"
          ];
          brights = [
            "#7c8f8f"
            "#ff5874"
            "#21c7a8"
            "#ecc48d"
            "#82aaff"
            "#ae81ff"
            "#7fdbca"
            "#d6deeb"
          ];
        };
      };
    };
    home-manager = {

      enable = false;
    };
    neovim = {
      enable = true;
      package = upkgs.neovim;
      defaultEditor = true;
      vimAlias = false;
      viAlias = false;
      withNodeJs = true;
    };
    git = {
      enable = true;
      iniContent = {
        ghq = {
          user = "gamoutatsumi";
          root = "~/Repositories";
        };
      };
    };
    alacritty = {
      enable = true;
      settings = {
        import = [ "~/.config/alacritty/nightfly.toml" ];
        env = {
          TERM = "alacritty";
          USE_TMUX = "true";
        };
        font = {
          size = 12;
          normal = {
            family = "PlemolJP Console NF";
          };
        };
        keyboard = {
          bindings = [
            {
              action = "ToggleFullScreen";
              key = "F11";
            }
          ];
        };
        mouse = {
          bindings = [
            {
              action = "none";
              mouse = "Middle";
            }
          ];
        };
        shell = {
          args = [ "--login" ];
          program = "zsh";
        };
        window = {
          option_as_alt = "Both";
        };
      };
    };
    gpg = {
      enable = true;
      scdaemonSettings = {
        disable-ccid = true;
      };
      publicKeys = [
        {
          source = "${gpgKey}";
          trust = 5;
        }
      ];
    };
    zsh = {
      enable = true;
      sessionVariables = {
        TERM = "wezterm";
        EDITOR = "nvim";
        HISTSIZE = 1000;
        SAVEHIST = 100000;
        HISTFILE = "${config.xdg.dataHome}/zsh/history";
        ANSIBLE_HOME = "${config.xdg.dataHome}/ansible";
        LUAROCKS_HOME = "${config.xdg.dataHome}/luarocks";
        MYCLI_HISTFILE = "''${config.xdg.dataHome}/mycli/history";
        ESLINT_D_LOCAL_ESLINT_ONLY = 1;
        MANPAGER = "vim -c ASMANPAGER -";
        MAKEFLAGS = "-j";
        DOCKER_BUILDKIT = 1;
        LC_ALL = "ja_JP.UTF-8";
        LANG = "ja_JP.UTF-8";
        PAGER = "ov";
        WORDCHARS = "*?_.[]~-=&;!#$%^(){}<>";
        PURE_GIT_PULL = 0;
        ZENO_GIT_CAT = "bat";
        ZENO_ENABLE_SOCK = 1;
        ZENO_ENABLE_FZF_TMUX = 1;
        ZSH_AUTOSUGGEST_STRATEGY = [
          "match_prev_cmd"
          "history"
        ];
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=8";
        FZF_PREVIEW_ENABLE_TMUX = 1;
        FZF_PREVIEW_DEFAULT_SETTING = "--sync --height='80%' --preview-window='right:50%' --expect='ctrl-space' --header='C-Space: continue fzf completion'";
        FZF_PREVIEW_DEFAULT_BIND = "ctrl-d:preview-page-down,ctrl-u:preview-page-up,?:toggle-preview";
      };
      defaultKeymap = "emacs";
      dotDir = ".config/zsh";
      initExtra = builtins.readFile ./config/zshrc;
      envExtra = ''
        unsetopt global_rcs
        export ARCH=$(uname -m)

        # ostype returns the lowercase OS name
        ostype() {
          uname | tr "[:upper:]" "[:lower:]"
        }

        # os_detect export the SHELL_ENVIRONMENT variable as you see fit
        case "$(ostype)" in
          *'linux'*)  
            if grep -iq 'microsoft' "/proc/sys/kernel/osrelease"; then
              SHELL_ENVIRONMENT='wsl'
            else
              SHELL_ENVIRONMENT='linux'
              fi                         ;;
            *'darwin'*) SHELL_ENVIRONMENT='osx'     ;;
            *'bsd'*)    SHELL_ENVIRONMENT='bsd'     ;;
            *)          SHELL_ENVIRONMENT='unknown' ;;
          esac
          export SHELL_ENVIRONMENT

        # is_osx returns true if running OS is Macintosh
        is_osx() {
          if [[ "$SHELL_ENVIRONMENT" = "osx" ]]; then
            return 0
          else
            return 1
          fi
        }

        is_wsl() {
          if [[ "$SHELL_ENVIRONMENT" = "wsl" ]]; then
            return 0
          else
            return 1
          fi
        }

        is_ssh() {
          if [[ -n "$SSH_CONNECTION" ]]; then
            return 0
          else
            return 1
          fi
        }

        exists() {
          if (( $+commands[$@] )); then
            return 0
          else
            return 1
          fi
        }
      '';
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    (with pkgs; [
      ov
      nix-diff
      bc
      neofetch
      unar
      killall
      coreutils-full
      lsd
      ripgrep
      moreutils
      binutils
      file
      findutils
      sheldon
      ghq
      gh
      fzf
      bat
      gomi
      delta
      gojq
      jq
      dust
      fd
      dogdns
      git-lfs
      q-text-as-data
      tenv
      docker-slim
      gnumake
      cmake
      unzip
      xclip
      tmux
      nix-index
      kubectl
      agenix-rekey
      age-plugin-yubikey
    ])
    ++ (with upkgs; [ deno ]);

  # Let Home Manager install and manage itself.
  services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };
}
