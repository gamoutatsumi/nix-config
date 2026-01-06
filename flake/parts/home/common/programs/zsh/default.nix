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
  fzf_preview_default_bind = "ctrl-d:preview-page-down,ctrl-u:preview-page-up,?:toggle-preview";
in
{
  programs = {
    zsh = {
      autocd = true;
      defaultKeymap = "emacs";
      dirHashes = {
        dot = "${config.xdg.configHome}/home-manager";
      };
      dotDir = "${config.xdg.configHome}/zsh";
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
        ${builtins.readFile ./.zshrc}
        ${lib.getExe pkgs.any-nix-shell} zsh --info-right | source /dev/stdin
        export FPATH
      '';
      sessionVariables = {
        # keep-sorted start block = yes
        ANSIBLE_HOME = "${config.xdg.dataHome}/ansible";
        ANTHROPIC_MODEL = "claude-opus-4-5-20251101";
        DIRENV_LOG_FORMAT = "";
        DOCKER_BUILDKIT = 1;
        ESLINT_D_LOCAL_ESLINT_ONLY = 1;
        FZF_PREVIEW_DEFAULT_BIND = fzf_preview_default_bind;
        FZF_PREVIEW_DEFAULT_SETTING = "--preview-window='right:50%' --expect='ctrl-space' --header='C-Space: continue fzf completion'";
        LANG = "ja_JP.UTF-8";
        LC_ALL = "ja_JP.UTF-8";
        LUAROCKS_HOME = "${config.xdg.dataHome}/luarocks";
        MAKEFLAGS = "-j";
        MANPAGER = "${lib.getExe config.programs.neovim.finalPackage} -c ASMANPAGER -";
        MYCLI_HISTFILE = "${config.xdg.dataHome}/mycli/history";
        NIX_CONFIG = "access-tokens = github.com=$(gh auth token)";
        OPENCODE_DISABLE_LSP_DOWNLOAD = "true";
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
      siteFunctions =
        let
          tmux_exe = lib.getExe config.programs.tmux.package;
          yq_exe = lib.getExe upkgs.yq;
          fzf-tmux_exe = lib.getExe' config.programs.fzf.package "fzf-tmux";
          openstackConfig = "${config.xdg.configHome}/openstack/clouds.yaml";
        in
        {
          f = ''
            local project dir repository session current_session out
            local ghq_command="${lib.getExe pkgs.ghq} list -p | ${lib.getExe pkgs.gnused} -e \"s|$HOME|~|\""
            local fzf_options_="--expect=ctrl-space --preview='eval bat --paging=never --style=plain --color=always {}/README.md'"
            local fzf_command="${fzf-tmux_exe} ''${fzf_options_}"
            fzf_command+=" ''${FZF_PREVIEW_DEFAULT_SETTING}"
            fzf_command+=" --bind='${fzf_preview_default_bind}'"
            local command="''${ghq_command} | ''${fzf_command}"

            out=$(eval "''${command}")
            dir=$(tail -1 <<< "''${out}")
            project=''${dir/$(ghq root)//}

            if [[ $project == "" ]]; then
              return 1
            fi

            if [[ -n ''${TMUX} ]]; then
              repository=''${dir##*/}
              session=''${repository//./-}
              current_session=$(${tmux_exe} list-sessions | grep 'attached' | cut -d":" -f1)

              ${tmux_exe} list-sessions | cut -d":" -f1 | grep -qe "^''${session}\$"
              local ret=$?
              if [[ $ret = 0 ]]; then
                local is_duplicate=true
              else
                local is_duplicate=false
              fi

              if [[ $current_session =~ ^[0-9]+$ ]]; then
                if ! $is_duplicate; then
                  eval builtin cd "$dir"
                  ${tmux_exe} rename-session -t "$current_session" "$session"
                else
                  ${tmux_exe} switch-client -t "$session"
                fi
              else
                if ! $is_duplicate; then
                  eval ${tmux_exe} new-session -d -c "''${dir}" -s "''${session}"
                  ${tmux_exe} switch-client -t "$session"
                else
                  ${tmux_exe} switch-client -t "$session"
                fi
              fi
            fi
          '';
          sheldonupdate = ''
            ${lib.getExe upkgs.sheldon} lock --update && ${lib.getExe upkgs.sheldon} source | grep -v "^$" > "${config.xdg.stateHome}/sheldon/sheldon.lock.zsh"
          '';
          awsp = ''
            local profile=$(${lib.getExe config.programs.awscli.package} configure list-profiles | sort | ${fzf-tmux_exe})
            export AWS_PROFILE="$profile"
          '';
          osp = ''
            local profile=$(cat ${openstackConfig} | ${yq_exe} -r ".clouds | keys | .[]" | ${fzf-tmux_exe})
            if [ -z "$profile" ]; then
              return 1
            fi
            local auth_url=$(cat ${openstackConfig} | ${yq_exe} -r ".clouds.\"''${profile}\".auth.auth_url")
            local password=$(cat ${openstackConfig} | ${yq_exe} -r ".clouds.\"''${profile}\".auth.password")
            local username=$(cat ${openstackConfig} | ${yq_exe} -r ".clouds.\"''${profile}\".auth.username")
            local project_name=$(cat ${openstackConfig} | ${yq_exe} -r ".clouds.\"''${profile}\".auth.project_name")
            local project_id=$(cat ${openstackConfig} | ${yq_exe} -r ".clouds.\"''${profile}\".auth.project_id")
            local user_domain_name=$(cat ${openstackConfig} | ${yq_exe} -r ".clouds.\"''${profile}\".auth.user_domain_name")
            export OS_CLOUD="$profile"
            export OS_AUTH_URL="$auth_url"
            export OS_PASSWORD="$password"
            export OS_USERNAME="$username"
            export OS_PROJECT_NAME="$project_name"
            export OS_PROJECT_ID="$project_id"
            export OS_USER_DOMAIN_NAME="$user_domain_name"
          '';
        };
    };
  };
}
