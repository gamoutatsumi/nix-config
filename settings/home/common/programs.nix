{
  # keep-sorted start
  config,
  lib,
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
  home = {
    packages =
      (with pkgs; [
        (wrapHelm kubernetes-helm {
          plugins = with kubernetes-helmPlugins; [
            helm-diff
            helm-secrets
            helm-git
          ];
        })
        # keep-sorted start
        age-plugin-yubikey
        argocd
        bc
        binutils
        cacert
        coreutils-full
        curlFull
        dblab
        docker-credential-helpers
        docker-slim
        dogdns
        dust
        fd
        file
        findutils
        gawk
        gemini-cli
        ghq
        git-crypt
        gnugrep
        gnumake
        gnused
        gojq
        gomi
        google-cloud-sdk
        killall
        kubectl
        kubie
        magika
        moreutils
        mycli
        nix-diff
        nix-index
        nix-output-monitor
        nix-search-cli
        nix-tree
        paperkey
        picocom
        pinact
        q-text-as-data
        s3cmd
        sheldon
        ssm-session-manager-plugin
        stern
        unar
        unzip
        yubico-piv-tool
        yubikey-manager
        zbar
        # keep-sorted end
      ])
      ++ (with upkgs; [
        deno
        claude-code
        vim
        opencommit
      ]);
  };
  programs = {
    # keep-sorted start block=yes
    alacritty = {
      enable = true;
      package = upkgs.alacritty;
      settings = {
        general = {
          import = [
            "${builtins.fetchurl {
              url = "https://raw.githubusercontent.com/bluz71/vim-nightfly-colors/master/extras/nightfly-alacritty.toml";
              sha256 = "0ssgf9i5nrc2m57zvgfzlgfvyhcrwd73pkiny266ba201niv6qi1";
            }}"
          ];
        };
        terminal = {
          shell = {
            args = [ "--login" ];
            program = "zsh";
          };
        };
        env = {
          TERM = "alacritty";
          USE_TMUX = "true";
          WINIT_X11_SCALE_FACTOR = "1.1";
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
            {
              chars = "\\u001b[98;6u";
              key = "b";
              mods = "Control|Shift";
            }
            {
              chars = "\\u001b[102;6u";
              key = "f";
              mods = "Control|Shift";
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
        window = {
          option_as_alt = "Both";
        };
      };
    };
    awscli = {
      enable = true;
    };
    bat = {
      enable = true;
      config = {
        theme = "fly16";
      };
      themes = {
        fly16 = {
          src = pkgs.fetchFromGitHub {
            owner = "bluz71";
            repo = "fly16-bat";
            rev = "d13c2c2a03e84819b2df2c50bc824b74604b9844";
            hash = "sha256-QtZurXK6wNnyWiiQWfyAMFsV5ZWyi84jJNkTgZYoMCE=";
          };
          file = "fly16.tmTheme";
        };
      };
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
      config = {
        global = {
          hide_env_diff = true;
        };
      };
    };
    emacs = {
      enable = true;
      package = upkgs.emacsWithPackagesFromUsePackage {
        package =
          if upkgs.stdenv.isLinux then
            upkgs.emacs-unstable
          else
            upkgs.emacs-unstable.override { withNativeCompilation = false; };
        config = ./config/emacs/init.el;
        defaultInitFile = true;
        extraEmacsPackages =
          epkgs: with epkgs; [
            (treesit-grammars.with-grammars (
              p: with p; [
                # keep-sorted start
                tree-sitter-bash
                tree-sitter-c
                tree-sitter-c-sharp
                tree-sitter-cmake
                tree-sitter-css
                tree-sitter-dockerfile
                tree-sitter-elisp
                tree-sitter-go
                tree-sitter-html
                tree-sitter-javascript
                tree-sitter-json
                tree-sitter-make
                tree-sitter-markdown
                tree-sitter-markdown-inline
                tree-sitter-nix
                tree-sitter-python
                tree-sitter-ruby
                tree-sitter-rust
                tree-sitter-scss
                tree-sitter-toml
                tree-sitter-tsx
                tree-sitter-typescript
                tree-sitter-yaml
                # keep-sorted end
              ]
            ))
          ];
      };
    };
    fzf = {
      enable = true;
      tmux = {
        enableShellIntegration = false;
      };
      defaultOptions = [
        "--sync"
      ];
      enableZshIntegration = true;
      package = pkgs.fzf;
    };
    gh = {
      enable = true;
      package = upkgs.gh;
      gitCredentialHelper = {
        enable = true;
      };
      extensions = with pkgs; [ gh-copilot ];
      settings = {
        git_protocol = "https";
        editor = lib.getExe config.programs.neovim.finalPackage;
        prompt = "enabled";
        pager = lib.getExe' pkgs.ov "ov";
        aliases = {
          co = "pr checkout";
          is = ''!gh issue list -s all | fzf --prompt "issue preview>" --preview "echo {} | cut -f1 | xargs gh issue view " | cut -f1 | xargs --no-run-if-empty gh issue ''${@:-view -w}'';
          myissue = ''!gh issue list -s all -A gamoutatsumi | fzf --prompt "issue preview>" --preview "echo {} | cut -f1 | xargs gh issue view " | cut -f1 | xargs --no-run-if-empty gh issue ''${@:-view -w}'';
          assigned = ''!gh issue list -s all -a gamoutatsumi | fzf --prompt "issue preview>" --preview "echo {} | cut -f1 | xargs gh issue view " | cut -f1 | xargs --no-run-if-empty gh issue ''${@:-view -w}'';
          prs = ''!gh pr list -s all | fzf --prompt "PR preview>" --preview "echo {} | cut -f1 | xargs gh pr view " | cut -f1 | xargs --no-run-if-empty gh pr ''${@:-view -w}'';
          prv = ''pr view -w'';
          iv = ''issue view -w'';
        };
      };
    };
    git = {
      enable = true;
      userEmail = "tatsumi@gamou.dev";
      userName = "gamoutatsumi";
      lfs = {
        enable = true;
      };
      signing = {
        key = "8BABD254FC4AB38A";
      };
      difftastic = {
        enable = false;
        background = "dark";
      };
      delta = {
        enable = true;
        options = {
          features = "line-numbers decorations";
          plus-style = ''syntax "#012800"'';
          minus-style = ''syntax "#340001"'';
          hunk-header-style = "file line-number";
          side-by-side = true;
          tabs = 0;
          interactive = {
            keep-plus-minus-markers = false;
          };
        };
      };
      extraConfig = {
        # keep-sorted start block=yes
        alias = {
          graph = ''log --graph --date-order -C -M --pretty=format:"<%h> %ad [%an] %Cgreen%d%Creset %s" --all --date=short'';
          pushf = "push --force-with-lease --force-if-includes";
        };
        color = {
          status = {
            added = "green";
            changed = "red";
            untracked = "yellow";
            unmerged = "magenta";
          };
        };
        commit = {
          gpgSign = true;
          verbose = true;
        };
        core = {
          untrackedCache = true;
          fsmonitor = true;
          autocrlf = false;
          quotepath = false;
        };
        diff = {
          tool = "${lib.getExe config.programs.neovim.finalPackage} -d";
          algorithm = "histogram";
        };
        difftool = {
          prompt = false;
        };
        fetch = {
          prune = true;
        };
        ghq = {
          user = "gamoutatsumi";
          root = "~/Repositories";
        };
        http = {
          postBuffer = 524288000;
        };
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = false;
        };
        push = {
          default = "current";
          useForceWithLease = true;
        };
        rerere = {
          enabled = true;
        };
        status = {
          showUntrackedFiles = "all";
        };
        # keep-sorted end
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
    jq = {
      enable = true;
    };
    lsd = {
      enable = true;
    };
    neovim = {
      enable = true;
      extraPackages =
        (with pkgs; [ nil ])
        ++ (with upkgs; [
          tree-sitter
          efm-langserver
          nodejs
          yaml-language-server
          nodePackages_latest.vscode-json-languageserver
          typos-lsp
        ])
        ++ lib.optionals pkgs.stdenv.isLinux [
          upkgs.gcc
        ];
      package = upkgs.neovim;
      defaultEditor = true;
      vimAlias = false;
      viAlias = false;
      withNodeJs = false;
      withRuby = false;
      withPython3 = false;
    };
    rbw = {
      enable = true;
      settings = {
        email = "wryuto@gmail.com";
      };
    };
    ripgrep = {
      enable = true;
    };
    ssh = {
      enable = true;
      includes = [ "${config.home.homeDirectory}/.ssh/config_work" ];
    };
    tmux = {
      enable = true;
      sensibleOnTop = false;
      prefix = "C-s";
      shell = lib.getExe pkgs.zsh;
      terminal = "alacritty";
      extraConfig = lib.strings.concatLines [
        (builtins.readFile ./config/tmux/tmux.conf)
        (builtins.readFile ./config/tmux/tmuxline-nightfly.conf)
      ];
      mouse = true;
      baseIndex = 1;
      newSession = true;
      escapeTime = 10;
      historyLimit = 4096;
    };
    vscode = {
      enable = true;
      package = upkgs.vscode;
      profiles = {
        default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;
          extensions =
            with upkgs.vscode-extensions;
            [
              # keep-sorted start
              bbenoist.nix
              eamodio.gitlens
              editorconfig.editorconfig
              github.copilot
              github.copilot-chat
              github.github-vscode-theme
              golang.go
              ms-ceintl.vscode-language-pack-ja
              oderwat.indent-rainbow
              saoudrizwan.claude-dev
              vscode-icons-team.vscode-icons
              # keep-sorted end
            ]
            ++ (with upkgs.nix-vscode-extensions.vscode-marketplace; [
              taiyofujii.novel-writer
              google.geminicodeassist
            ]);
          userSettings = {
            "chat.mcp.enabled" = true;
            "chat.mcp.discovery.enabled" = true;
            "editor.fontFamily" = "PlemolJP Console NF";
            "editor.fontLigatures" = true;
            "editor.fontSize" = 14;
            "editor.renderWhitespace" = "boundary";
            "editor.minimap.enabled" = true;
            "editor.minimap.renderCharacters" = true;
            "workbench.colorTheme" = "GitHub Dark Dimmed";
            "workbench.iconTheme" = "vscode-icons";
            "cline.mcpMarketplace.enabled" = false;
            "cline.preferredLanguage" = "Japanese - 日本語";
            "github.copilot.chat.codesearch.enabled" = true;
            "github.copilot.chat.agent.thinkingTool" = true;
          };
        };
      };
    };
    wezterm = {
      enable = false;
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
      history = {
        size = 1000;
        path = "${config.xdg.dataHome}/zsh/history";
        save = 100000;
      };
      sessionVariables = {
        # keep-sorted start block = yes
        ANSIBLE_HOME = "${config.xdg.dataHome}/ansible";
        CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
        DIRENV_LOG_FORMAT = "";
        DOCKER_BUILDKIT = 1;
        ESLINT_D_LOCAL_ESLINT_ONLY = 1;
        FZF_PREVIEW_DEFAULT_BIND = "ctrl-d:preview-page-down,ctrl-u:preview-page-up,?:toggle-preview";
        FZF_PREVIEW_DEFAULT_SETTING = "--preview-window='right:50%' --expect='ctrl-space' --header='C-Space: continue fzf completion'";
        LANG = "ja_JP.UTF-8";
        LC_ALL = "ja_JP.UTF-8";
        LUAROCKS_HOME = "${config.xdg.dataHome}/luarocks";
        MAKEFLAGS = "-j";
        MANPAGER = "${lib.getExe config.programs.neovim.finalPackage} -c ASMANPAGER -";
        MYCLI_HISTFILE = "${config.xdg.dataHome}/mycli/history";
        NIX_CONFIG = "access-tokens = github.com=$(gh auth token)";
        PAGER = "${lib.getExe' pkgs.ov "ov"}";
        PURE_GIT_PULL = 0;
        TERM = "alacritty";
        TMUX_PLUGIN_MANAGER_PATH = "${config.xdg.dataHome}/tmux/plugins";
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
      initContent = ''
        ${builtins.readFile ./config/.zshrc}
        ${lib.getExe pkgs.any-nix-shell} zsh --info-right | source /dev/stdin
        export FPATH
      '';
      envExtra = builtins.readFile ./config/.zshenv;
    };
    # keep-sorted end
  };
  # keep-sorted end
}
