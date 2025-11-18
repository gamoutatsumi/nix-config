{
  # keep-sorted start
  config,
  lib,
  pkgs,
  upkgs,
  # keep-sorted end
  ...
}:
{
  programs = {
    zsh = {
      # keep-sorted start block=yes
      autocd = true;
      defaultKeymap = "emacs";
      dirHashes = {
        dot = "${config.xdg.configHome}/home-manager";
      };
      dotDir = ".config/zsh";
      enable = true;
      envExtra = lib.strings.concatLines [
        (builtins.readFile (
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/bluz71/vim-nightfly-colors/refs/heads/master/extras/nightfly-fzf.sh";
            sha256 = "sha256-KHRkQEPk7rzgnPK/sehr6AXo267YB0Tfi8KaVDjnkUE=";
          }
        ))
        "source ${config.xdg.configHome}/zsh/.zshenv.local"
        "export FPATH=${config.xdg.dataHome}/zsh/functions:\$FPATH"
      ];
      history = {
        extended = true;
        size = 1000;
        path = "${config.xdg.dataHome}/zsh/history";
        save = 100000;
        ignoreDups = true;
        expireDuplicatesFirst = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        findNoDups = true;
        saveNoDups = true;
        ignorePatterns = [
          "q"
          "exit"
          "cd"
          "pwd"
          "dot"
          ".."
        ];
      };
      initContent = ''
        ${builtins.readFile ../config/.zshrc}
        ${lib.getExe pkgs.any-nix-shell} zsh --info-right | source /dev/stdin
        export FPATH
      '';
      sessionVariables = {
        # keep-sorted start block = yes
        ANSIBLE_HOME = "${config.xdg.dataHome}/ansible";
        ANTHROPIC_MODEL = "claude-haiku-4-5-20251001";
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
      shellAliases = {
        # keep-sorted start
        q = "exit";
        rm = "${lib.getExe upkgs.gomi}";
        ssh = "TERM=xterm ssh";
        tree = "${config.programs.lsd.package} --tree";
        v = "${lib.getExe config.programs.neovim.finalPackage}";
        vi = "${lib.getExe config.programs.neovim.finalPackage}";
        vim = "${lib.getExe config.programs.neovim.finalPackage}";
        # keep-sorted end
      };
      #keep-sorted end
    };
  };
}
