{
  # keep-sorted start
  config,
  pkgs,
  upkgs,
  # keep-sorted end
  ...
}:
let
  gpgKey = pkgs.fetchurl {
    url = "https://github.com/gamoutatsumi.gpg";
    sha256 = "0p1xp2rq7r0hbdi7dkhw3fzrf2ij7b3p6a5nnk0fflda4cs6a814";
  };
in
{
  # keep-sorted start block=yes
  programs = {
    # keep-sorted start block=yes
    alacritty = {
      enable = true;
      settings = {
        import = [ "~/.config/alacritty/nightfly.toml" ];
        env = {
          TERM = "alacritty";
          USE_TMUX = "true";
        };
        font = {
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
    awscli = {
      enable = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };
    gh = {
      enable = true;
      settings = {
        git_protocol = "https";
        editor = "nvim";
        prompt = "enabled";
        pager = "ov";
        aliases = {
          co = "pr checkout";
          is = ''!gh issue list -s all | fzf-tmux --prompt "issue preview>" --preview "echo {} | cut -f1 | xargs gh issue view " | cut -f1 | xargs --no-run-if-empty gh issue ''${@:-view -w}'';
          myissue = ''!gh issue list -s all -A gamoutatsumi | fzf-tmux --prompt "issue preview>" --preview "echo {} | cut -f1 | xargs gh issue view " | cut -f1 | xargs --no-run-if-empty gh issue ''${@:-view -w}'';
          assigned = ''!gh issue list -s all -a gamoutatsumi | fzf-tmux --prompt "issue preview>" --preview "echo {} | cut -f1 | xargs gh issue view " | cut -f1 | xargs --no-run-if-empty gh issue ''${@:-view -w}'';
          prs = ''!gh pr list -s all | fzf-tmux --prompt "PR preview>" --preview "echo {} | cut -f1 | xargs gh pr view " | cut -f1 | xargs --no-run-if-empty gh pr ''${@:-view -w}'';
          prv = ''pr view -w'';
          iv = ''issue view -w'';
        };
      };
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
    home-manager = {
      enable = false;
    };
    neovim = {
      enable = true;
      extraPackages = with upkgs; [
        nil
        tree-sitter
      ];
      package = upkgs.neovim;
      defaultEditor = true;
      vimAlias = false;
      viAlias = false;
      withNodeJs = true;
      withRuby = false;
      withPython3 = false;
    };
    rbw = {
      enable = true;
      settings = {
        email = "wryuto@gmail.com";
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
    zsh = {
      enable = true;
      sessionVariables = {
        # keep-sorted start block = yes
        ANSIBLE_HOME = "${config.xdg.dataHome}/ansible";
        DOCKER_BUILDKIT = 1;
        EDITOR = "nvim";
        ESLINT_D_LOCAL_ESLINT_ONLY = 1;
        FZF_PREVIEW_DEFAULT_BIND = "ctrl-d:preview-page-down,ctrl-u:preview-page-up,?:toggle-preview";
        FZF_PREVIEW_DEFAULT_SETTING = "--sync --height='80%' --preview-window='right:50%' --expect='ctrl-space' --header='C-Space: continue fzf completion'";
        FZF_PREVIEW_ENABLE_TMUX = 1;
        HISTFILE = "${config.xdg.dataHome}/zsh/history";
        HISTSIZE = 1000;
        LANG = "ja_JP.UTF-8";
        LC_ALL = "ja_JP.UTF-8";
        LUAROCKS_HOME = "${config.xdg.dataHome}/luarocks";
        MAKEFLAGS = "-j";
        MANPAGER = "nvim -c ASMANPAGER -";
        MYCLI_HISTFILE = "${config.xdg.dataHome}/mycli/history";
        PAGER = "ov";
        PURE_GIT_PULL = 0;
        SAVEHIST = 100000;
        TERM = "wezterm";
        WORDCHARS = "*?_.[]~-=&;!#$%^(){}<>";
        ZENO_ENABLE_FZF_TMUX = 1;
        ZENO_ENABLE_SOCK = 1;
        ZENO_GIT_CAT = "bat";
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=8";
        ZSH_AUTOSUGGEST_STRATEGY = [
          "match_prev_cmd"
          "history"
        ];
        # keep-sorted end
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
    # keep-sorted end
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = (
    with pkgs;
    [
      (wrapHelm kubernetes-helm {
        plugins = with kubernetes-helmPlugins; [
          helm-diff
          helm-secrets
          helm-git
        ];
      })
      # keep-sorted start
      age-plugin-yubikey
      #aicommit2
      bat
      bc
      binutils
      cmake
      coreutils-full
      curlFull
      delta
      deno."2.0.3"
      docker-slim
      dogdns
      dust
      fd
      file
      findutils
      fzf
      gawk
      ghq
      git-crypt
      git-lfs
      gnugrep
      gnumake
      gnused
      gojq
      gomi
      jq
      killall
      kubectl
      kubie
      lsd
      moreutils
      mycli
      neofetch
      nix-diff
      nix-index
      nix-tree
      ov
      q-text-as-data
      ripgrep
      sheldon
      stern
      tmux
      unar
      unzip
      # keep-sorted end
    ]
  );
  # keep-sorted end
}
