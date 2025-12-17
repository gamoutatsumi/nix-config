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
  imports = [
    # keep-sorted start
    ./alacritty.nix
    ./claude
    ./codex.nix
    ./emacs
    ./vscode.nix
    ./zsh
    # keep-sorted end
  ];
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
        ast-grep
        bc
        binutils
        cacert
        coreutils-full
        file
        findutils
        gawk
        ghq
        git-crypt
        gnugrep
        gnumake
        gnused
        gojq
        ibm-plex
        killall
        magika
        moreutils
        nix-diff
        nix-index
        nix-output-monitor
        nix-search-cli
        nix-tree
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        paperkey
        picocom
        plemoljp
        plemoljp-nf
        q-text-as-data
        ssm-session-manager-plugin
        unzip
        yubico-piv-tool
        yubikey-manager
        zbar
        # keep-sorted end
      ])
      ++ (with upkgs; [
        # keep-sorted start
        argocd
        curlFull
        deno
        docker-credential-helpers
        docker-slim
        dogdns
        dust
        fd
        google-cloud-sdk
        istioctl
        kn
        kubectl
        kubie
        mycli
        s3cmd
        sheldon
        stern
        unar
        vim
        # keep-sorted end
      ]);
  };
  programs = {
    # keep-sorted start block=yes
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
      settings = {
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
        user = {
          email = "tatsumi@gamou.dev";
          name = "gamoutatsumi";
        };
        # keep-sorted end
      };
      lfs = {
        enable = true;
      };
      signing = {
        key = "8BABD254FC4AB38A";
      };
    };
    delta = {
      enable = true;
      enableGitIntegration = true;
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
      enableZshIntegration = true;
    };
    neovim = {
      vimdiffAlias = true;
      enable = true;
      plugins = [
        (pkgs.callPackage ../../../../vimPlugins/denops.nix { })
        upkgs.vimPlugins.nvim-treesitter.withAllGrammars
      ];
      extraPackages =
        (with pkgs; [ nil ])
        ++ (with upkgs; [
          tree-sitter
          jinja-lsp
          efm-langserver
          nodejs
          yaml-language-server
          vscode-langservers-extracted
          typos-lsp
          gotestsum
          luajitPackages.busted
          delve
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
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
      };
    };
    tmux = {
      enable = true;
      sensibleOnTop = false;
      prefix = "C-s";
      shell = lib.getExe pkgs.zsh;
      terminal = "alacritty";
      extraConfig = lib.strings.concatLines [
        (builtins.readFile ../config/tmux/tmux.conf)
        (builtins.readFile ../config/tmux/tmuxline-nightfly.conf)
        ''run "''${TMUX_PLUGIN_MANAGER_PATH}/tpm/tpm"''
      ];
      mouse = true;
      baseIndex = 1;
      newSession = true;
      escapeTime = 10;
      historyLimit = 4096;
    };
    wezterm = {
      enable = false;
      extraConfig = builtins.readFile ../config/wezterm/wezterm.lua;
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
    zathura = {
      enable = true;
      options = {
        synctex = true;
        synctex-editor-command = "texlab inverse-search -i %{input} -l %{line}";
      };
    };
    nh = {
      enable = true;
      flake = "${config.xdg.configHome}/home-manager";
    };
    ghostty = {
      enable = true;
      enableZshIntegration = true;
      installBatSyntax = true;
      settings = {
        # keep-sorted start
        auto-update = "off";
        background-opacity = 0.8;
        theme = "nightfly";
        # keep-sorted end
      };
    };
    # keep-sorted end
  };
  # keep-sorted end
}
