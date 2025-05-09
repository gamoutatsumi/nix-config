if [[ -z "$TMUX" ]] && [[ "$USE_TMUX" == "true" ]] ;then
  SESSION=$(tmux list-sessions | fzf --height 40% --reverse --border --select-1 --exit-0 --prompt "Select a session: " | awk '{print $1}')
  if [[ -z "$SESSION" ]]; then
    exec tmux a
    else
    exec tmux attach-session -t $SESSION
  fi
fi
# ZCOMPILE {{{
# function source {
#   ensure_zcompiled $1
#   builtin source $1
# }
# function ensure_zcompiled {
#   local compiled="$1.zwc"
#   local target="$1"
#   if [[ -L "$1" ]]; then
#     target=$(readlink "$1")
#   fi
#   if [[ ! -r "$compiled" || "$target" -nt "$compiled" ]]; then
#     echo "Compiling $1"
#     zcompile $1
#   fi
# }
# ensure_zcompiled ~/.config/zsh/.zshrc
# ensure_zcompiled ~/.zshrc.local
# ensure_zcompiled ~/.zprofile
# ensure_zcompiled ~/.config/zsh/.zshenv
# ensure_zcompiled ~/.zshenv.local
# () {
#   local src
#   for src in $@; do
#     ([[ ! -e $src.zwc ]] || [ ${src:A} -nt $src ]) && zcompile $src
#   done
# } ~/.config/zsh/.zshrc
# }}}

# INITIALIZE {{{
if [[ -n "$ZSHRC_PROFILE" ]]; then
  zmodload zsh/zprof && zprof > /dev/null
fi
# }}}

# {{{ ENVVARS
# Setting PATH
export WORDCHARS='*?_.[]~-=&;!#$%^(){}<>' 

export PURE_GIT_PULL=0

# }}}

# {{{ PLUGINS
if [[ ! -d "${XDG_STATE_HOME}"/sheldon ]]; then
  mkdir "${XDG_STATE_HOME}"/sheldon
fi
if [[ ! -e "${XDG_STATE_HOME}/sheldon/sheldon.lock.zsh" ]] || [[ "${XDG_CONFIG_HOME}/sheldon/plugins.toml" -nt "${XDG_STATE_HOME}/sheldon/sheldon.lock.zsh" ]]; then
  sheldon source > "${XDG_STATE_HOME}/sheldon/sheldon.lock.zsh"
fi
source "${XDG_STATE_HOME}/sheldon/sheldon.lock.zsh"

ZSH_AUTOSUGGEST_CLEAR_WIDGETS+="zeno-auto-snippet-and-accept-line-fallback"

setopt nonomatch
      function set_fast_theme() {
        FAST_HIGHLIGHT_STYLES[path]='fg=cyan,underline'
        FAST_HIGHLIGHT_STYLES[path-to-dir]='fg=cyan,underline' 
        FAST_HIGHLIGHT_STYLES[suffix-alias]='fg=blue'
        FAST_HIGHLIGHT_STYLES[alias]='fg=blue'
        FAST_HIGHLIGHT_STYLES[precommand]='fg=blue'
        FAST_HIGHLIGHT_STYLES[command]='fg=blue'
        FAST_HIGHLIGHT_STYLES[arg0]='fg=025'
        FAST_HIGHLIGHT_STYLES[globbing]='fg=green,bold'
        FAST_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan'
        FAST_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan'
        FAST_HIGHLIGHT_STYLES[default]='fg=cyan'
        FAST_HIGHLIGHT_STYLES[unknown-token]='fg=196'
        FAST_HIGHLIGHT_STYLES[builtin]='fg=blue'
        FAST_HIGHLIGHT_STYLES[global-alias]='fg=green'
      }
set_fast_theme

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

function zeno-auto-snippet-fallback() {
  if [[ -n "$ZENO_LOADED" ]]; then
    zeno-auto-snippet
  else
    zle self-insert
  fi
}

function zeno-auto-snippet-and-accept-line-fallback() {
  if [[ -n "$ZENO_LOADED" ]]; then
    zeno-auto-snippet-and-accept-line
  else
    zle accept-line
  fi
}

function zeno-insert-snippet-fallback() {
  if [[ -n "$ZENO_LOADED" ]]; then
    zeno-insert-snippet
  fi
}

function zeno-completion-fallback() {
  if [[ -n "$ZENO_LOADED" ]]; then
    zeno-completion
  else
    zle expand-or-complete
  fi
}

function zeno-history-selection-fallback() {
  if [[ -n "$ZENO_LOADED" ]]; then
    zeno-history-selection
  else
    zle history-incremental-search-backward
  fi
}

function zeno-ghq-cd-fallback() {
 if [[ -n $ZENO_LOADED ]]; then
   zeno-ghq-cd
 else
   zle vi-find-next-char
 fi
}

zle -N zeno-auto-snippet-fallback
zle -N zeno-auto-snippet-and-accept-line-fallback
zle -N zeno-insert-snippet-fallback
zle -N zeno-completion-fallback
zle -N zeno-history-selection-fallback
zle -N zeno-ghq-cd-fallback

# zeno.zsh
bindkey ' '    zeno-auto-snippet-fallback
bindkey '^m'   zeno-auto-snippet-and-accept-line-fallback
bindkey '^x^s' zeno-insert-snippet-fallback
bindkey '^i'   zeno-completion-fallback
bindkey '^r'   zeno-history-selection-fallback
bindkey '^x^f' zeno-ghq-cd-fallback

bindkey '\e[Z' reverse-menu-complete

bindkey '^[k' tmk
bindkey '^[t' tms

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^xe" edit-command-line
bindkey "^x^e" edit-command-line
# }}}

# ALIAS {{{
# OS Settings
if is_osx; then
  alias arm="exec arch -arch arm64e /bin/zsh --login"
  alias x86="exec arch -arch x86_64 /bin/zsh --login"
  alias ubuntu="limactl shell docker"
else
  alias mozc_dic='/usr/lib/mozc/mozc_tool --mode=dictionary_tool'
  alias mozc_word='/usr/lib/mozc/mozc_tool --mode=word_register_dialog'
  alias open='xdg-open'
fi

if is_wsl; then
  alias pbcopy='/mnt/c/Windows/System32/clip.exe'
elif is_osx; then
  :
else
  alias pbcopy='xsel --clipboard --input'
fi

# ls alias
if exists lsd; then
  alias ls='lsd'
  alias ll='lsd -l --git'
  alias la='lsd -la --git'
  alias tree='lsd --tree'
fi

if exists gojq; then
  alias jq='gojq'
fi

# Utilities
alias du='du -sh *'
alias filecount='/usr/bin/ls -lF | grep -v / | wc -l'
alias ..='cd ..'
alias q='exit'
alias top='htop'
exists gomi && alias rm='gomi'

# editors
alias vim='nvim'
alias vi='vim'
alias v='vi'
alias vimdiff='nvim -d'
alias vimmerge='nvim -c vnew -c "windo diffthis" -c "setl scrollbind" -c "windo setl buftype=nofile"'

# dotfiles
alias dot='cd ~/.config/home-manager'
alias zshconfig='chezmoi edit ~/.zshrc'
alias cedit='chezmoi edit'
alias vimconfig='chezmoi edit ~/.config/nvim/init/core/init.vim'
alias tmuxconfig='chezmoi edit ~/.tmux.conf'
alias sshconfig='vim ~/.ssh/config'
alias gitconfig='chezmoi edit ~/.config/git/config'
alias reload='source ~/.zshrc'
alias path='echo $path'

alias p='paru'

# TMUX
alias ssh='TERM=xterm ssh'

alias bwp='BITWARDENCLI_APPDATA_DIR=~/.config/Bitwarden\ CLI\ Personal bw'
alias bww='BITWARDENCLI_APPDATA_DIR=~/.config/Bitwarden\ CLI\ Work bw'

globalias() {
  if [[ $LBUFFER =~ [A-Z0-9]+$ ]]; then
    zle _expand_alias
    zle expand-word
    zle self-insert
  else
    zle zeno-auto-snippet
  fi
}

# zle -N globalias
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

# {{{ GPG-SSH
# export GPG_TTY=$(tty)
#
# if ! is_ssh; then
#   if type "gpg" > /dev/null 2>&1; then
#     if ! is_wsl; then
#       if [[ -z $SSH_AUTH_SOCK ]]; then
#         gpg-connect-agent updatestartuptty /bye >/dev/null
#         gpgconf --launch gpg-agent
#         export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#       fi
#     fi
#   fi
# fi

# In WSL2
if is_wsl; then
  export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
  if ! ss -a | grep -q $SSH_AUTH_SOCK; then
    rm -f $SSH_AUTH_SOCK
    wsl2_ssh_pagent_bin="$HOME/.ssh/wsl2-ssh-pagent.exe"
    if test -x "$wsl2_ssh_pagent_bin"; then
      (setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$wsl2_ssh_pagent_bin" >/dev/null 2>&1 &)
    else
      echo >&2 "WARNING: $wsl2_ssh_pagent_bin"
    fi
    unset wsl2_ssh_pagent_bin
  fi

  export GPG_AGENT_SOCK=$HOME/.gnupg/S.gpg-agent
  if ! ss -a | grep -q $GPG_AGENT_SOCK; then
    /usr/bin/rm -rf $GPG_AGENT_SOCK
    config_path="C\:/Users/$USERNAME/AppData/Local/gnupg"
    wsl2_ssh_pagent_bin="$HOME/.ssh/wsl2-ssh-pagent.exe"
    if test -x "$wsl2_ssh_pagent_bin"; then
      (setsid nohup socat UNIX-LISTEN:$GPG_AGENT_SOCK,fork EXEC:"$wsl2_ssh_pagent_bin -gpgConfigBasepath ${config_path} -gpg S.gpg-agent" >/dev/null 2>&1 &)
    else
      echo >&2 "WARNING: $wsl2_ssh_pagent_bin"
    fi
    unset wsl2_ssh_pagent_bin
  fi
fi
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
function zsh-profiler() {
  ZSHRC_PROFILE=1 zsh -i -c zprof
}

function awsp() {
  local profile=$(aws configure list-profiles | sort | fzf)
  export AWS_PROFILE="$profile"
}

function osp() {
  local profile=$(cat ~/.config/openstack/clouds.yaml | yq '.clouds | keys | .[]' | fzf)
  export OS_CLOUD="$profile"
}

function dockercon() {
  ssh -L localhost:23750:/var/run/docker.sock $@
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

# unfunction source
