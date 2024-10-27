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
