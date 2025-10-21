if [[ -z "$TMUX" ]] && [[ "$USE_TMUX" == "true" ]] ;then
  SESSION=$(tmux list-sessions | fzf --height 40% --reverse --border --select-1 --exit-0 --prompt "Select a session: " | awk '{print $1}')
  if [[ -z "$SESSION" ]]; then
    exec tmux a
    else
    exec tmux attach-session -t $SESSION
  fi
fi

# {{{ PLUGINS
setopt nonomatch
if [[ ! -d "${XDG_STATE_HOME}"/sheldon ]]; then
  mkdir "${XDG_STATE_HOME}"/sheldon
fi
if [[ ! -e "${XDG_STATE_HOME}/sheldon/sheldon.lock.zsh" ]] || [[ "${XDG_CONFIG_HOME}/sheldon/plugins.toml" -nt "${XDG_STATE_HOME}/sheldon/sheldon.lock.zsh" ]]; then
  sheldon source > "${XDG_STATE_HOME}/sheldon/sheldon.lock.zsh"
fi
source "${XDG_STATE_HOME}/sheldon/sheldon.lock.zsh"
# }}}

# KEY {{{
typeset -A key

if [[ -n "${terminfo}" ]]; then
  key[Home]="${terminfo[khome]}"
  key[End]="${terminfo[kend]}"
  key[Insert]="${terminfo[kich1]}"
  key[Delete]="${terminfo[kdch1]}"
  key[Up]="${terminfo[kcuu1]}"
  key[Down]="${terminfo[kcud1]}"
  key[Left]="${terminfo[kcub1]}"
  key[Right]="${terminfo[kcuf1]}"
  key[PageUp]="${terminfo[kpp]}"
  key[PageDown]="${terminfo[knp]}"

  # setup key accordingly
  [[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
  [[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
  [[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
  [[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
  [[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
  [[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
  [[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
  [[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
  [[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
  [[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history
fi

# word
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init () {
    printf '%s' "${terminfo[smkx]}"
  }
  function zle-line-finish () {
    printf '%s' "${terminfo[rmkx]}"
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

bindkey '\e[Z' reverse-menu-complete

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^xe" edit-command-line
bindkey "^x^e" edit-command-line
# }}}

# GENERAL {{{
setopt AUTO_CD
setopt IGNOREEOF

stty stop undef
stty start undef

# opam configuration
if [[ -r "$HOME/.opam/opam-init/init.zsh" ]]; then
  source "$HOME/.opam/opam-init/init.zsh" 2>&1 /dev/null || true
fi
#}}}

#{{{ HISTORY
export HISTORY_IGNORE="q|exit|cd|pwd|dot"

zshaddhistory() {
  emulate -L zsh
  [[ ${1%%$'\n'} != ${~HISTORY_IGNORE} ]]
}

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP
setopt HIST_REDUCE_BLANKS
#}}}

# {{{ STYLE
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || . ~/.p10k.zsh

zstyle ':completion:*:default' menu select=2

# 補完関数の表示を強化する
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

zstyle ':prompt:pure:prompt:success' color green
zstyle ':prompt:pure:git:branch' color green

# Disalbe Right Prompt
RPROMPT=""
# }}}

# {{{ TMUX
autoload -Uz add-zsh-hook
function tmux_ssh_preexec() {
  local command=$1
  if [[ "$command" = *ssh* ]]; then
    tmux setenv TMUX_SSH_CMD_"$(tmux display -p "#I")" "${command}"
  fi
}
add-zsh-hook preexec tmux_ssh_preexec

function precmd() {
  if [[ -n $TMUX ]]; then
    tmux refresh-client -S
  fi
}

function f() {
  local project dir repository session current_session out
  local ghq_command="ghq list -p | sed -e \"s|$HOME|~|\""
  local fzf_options_="--expect=ctrl-space --preview='eval bat --paging=never --style=plain --color=always {}/README.md'"
  local fzf_command="fzf-tmux ${fzf_options_}"
  fzf_command+=" ${FZF_PREVIEW_DEFAULT_SETTING}"
  fzf_command+=" --bind='${FZF_PREVIEW_DEFAULT_BIND}'"
  local command="${ghq_command} | ${fzf_command}"

  out=$(eval "${command}")
  dir=$(tail -1 <<< "${out}")
  project=${dir/$(ghq root)//}

  if [[ $project == "" ]]; then
    return 1
  fi

  if [[ -n ${TMUX} ]]; then
    repository=${dir##*/}
    session=${repository//./-}
    current_session=$(tmux list-sessions | grep 'attached' | cut -d":" -f1)

    tmux list-sessions | cut -d":" -f1 | grep -qe "^${session}\$"
    local ret=$?
    if [[ $ret = 0 ]]; then
      local is_duplicate=true
    else
      local is_duplicate=false
    fi

    if [[ $current_session =~ ^[0-9]+$ ]]; then
      if ! $is_duplicate; then
        eval builtin cd "$dir"
        tmux rename-session -t "$current_session" "$session"
      else
        tmux switch-client -t "$session"
      fi
    else
      if ! $is_duplicate; then
        eval tmux new-session -d -c "${dir}" -s "${session}"
        tmux switch-client -t "$session"
      else
        tmux switch-client -t "$session"
      fi
    fi
  fi
}

function _left-pane() {
  tmux select-pane -L
}
zle -N left-pane _left-pane

function _down-pane() {
  tmux select-pane -D
}
zle -N down-pane _down-pane

function _up-pane() {
  tmux select-pane -U
}
zle -N up-pane _up-pane

function _right-pane() {
  tmux select-pane -R
}
zle -N right-pane _right-pane

function _backspace-or-left-pane() {
  if [[ "${#BUFFER}" -gt 0 ]]; then
    zle backward-delete-char
  elif [[ -n ${TMUX} ]]; then
    zle left-pane
  fi
}
zle -N backspace-or-left-pane _backspace-or-left-pane

function _kill-line-or-up-pane() {
  if [[ "${#BUFFER}" -gt 0 ]]; then
    zle kill-line
  elif [[ -n ${TMUX} ]]; then
    zle up-pane
  fi
}
zle -N kill-line-or-up-pane _kill-line-or-up-pane

function _accept-line-or-down-pane() {
  if [[ $#BUFFER -gt 0 ]]; then
    zle accept-line
  elif [[ ! -z ${TMUX} ]]; then
    zle down-pane
  fi
}
zle -N accept-line-or-down-pane _accept-line-or-down-pane

bindkey '^k' kill-line-or-up-pane
bindkey '^l' right-pane
bindkey '^h' backspace-or-left-pane
bindkey '^j' accept-line-or-down-pane
# }}}

# FUNCTIONS {{{
function vim-startuptime-detail() {
  local time_file
  time_file=$(mktemp --suffix "_vim_startuptime.txt")
  echo "output: $time_file"
  time nvim --startuptime "$time_file" -c q
  tail -n 1 "$time_file" | cut -d " " -f1 | tr -d "\n" && printf " [ms]\n"
  sort -n -k 2 < "$time_file" | tail -n 20
}

function awsp() {
  local profile=$(aws configure list-profiles | sort | fzf)
  export AWS_PROFILE="$profile"
}

function osp() {
  local profile=$(cat ~/.config/openstack/clouds.yaml | yq ".clouds | keys | .[]" | fzf)
  local auth_url=$(cat ~/.config/openstack/clouds.yaml | yq ".clouds.${profile}.auth.auth_url")
  local password=$(cat ~/.config/openstack/clouds.yaml | yq ".clouds.${profile}.auth.password")
  local username=$(cat ~/.config/openstack/clouds.yaml | yq ".clouds.${profile}.auth.username")
  local project_name=$(cat ~/.config/openstack/clouds.yaml | yq ".clouds.${profile}.auth.project_name")
  local project_id=$(cat ~/.config/openstack/clouds.yaml | yq ".clouds.${profile}.auth.project_id")
  local user_domain_name=$(cat ~/.config/openstack/clouds.yaml | yq ".clouds.${profile}.auth.user_domain_name")
  export OS_CLOUD="$profile"
  export OS_AUTH_URL="$auth_url"
  export OS_PASSWORD="$password"
  export OS_USERNAME="$username"
  export OS_PROJECT_NAME="$project_name"
  export OS_PROJECT_ID="$project_id"
  export OS_USER_DOMAIN_NAME="$user_domain_name"
}

function sheldonupdate() {
  sheldon lock --update && sheldon source | grep -v "^$" > "${XDG_STATE_HOME}/sheldon/sheldon.lock.zsh"
}

function fk() {
  local pid
  local fzf_command
  if [[ -z $TMUX ]]; then
    fzf_command="fzf"
  else
    fzf_command="fzf-tmux"
  fi
  pid=$(ps -ef | sed 1d | $fzf_command -m | awk '{print $2}')

  if [[ "x$pid" != "x" ]]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

function envinit() {
  echo "export GITHUB_API_TOKEN=$(gh auth token)\nexport HOMEBREW_GITHUB_API_TOKEN=\$GITHUB_API_TOKEN\nexport AQUA_GITHUB_TOKEN=\$GITHUB_API_TOKEN" > ~/.zshenv.local
  source ~/.zshenv.local
}
# }}}

# {{{ HOOKS
add-zsh-hook preexec git_auto_save
function git_auto_save() {
  if [[ -d .git ]] && [[ -f .git/auto-save ]] && [[ $(find .git/auto-save -mmin -$((60)) | wc -l) -eq 0 ]]; then
    if [[ ! -f ".git/MERGE_HEAD" ]] && [[ $(git --no-pager diff --cached | wc -l) -eq 0 ]] && [[ ! -f .git/index.lock ]] && [[ ! -d .git/rebase-merge ]] && [[ ! -d .git/rebase-apply ]]; then
      touch .git/auto-save && git add --all && git commit --no-verify --message "Auto save: $(date -R)" >/dev/null && git reset HEAD^ >/dev/null
      echo "Git auto save!"
    fi
  fi
}

export COMPINIT_DIFF=""
_chpwd_compinit() {
  if [ -n "$IN_NIX_SHELL" -a "$COMPINIT_DIFF" != "$DIRENV_DIFF" ]; then
    compinit
    COMPINIT_DIFF="$DIRENV_DIFF"
  fi
}
if [[ -z ${precmd_functions[(r)_chpwd_compinit]} ]]; then
  precmd_functions=( ${precmd_functions[@]} _chpwd_compinit )
fi
if [[ -z ${chpwd_functions[(r)_chpwd_compinit]} ]]; then
  chpwd_functions=( ${chpwd_functions[@]} _chpwd_compinit )
fi
# }}}
