{ lib, pkgs, ... }:

pkgs.writeShellScriptBin "launchPolybar" ''
  coreutils=${pkgs.coreutils}/bin/coreutils
  sleep="''$coreutils --coreutils-prog=sleep"
  head="''$coreutils --coreutils-prog=head"
  cut="''$coreutils --coreutils-prog=cut"
  while ${pkgs.procps}/bin/pgrep -u ''$UID -x polybar > /dev/null; do ''$sleep 0.1; done

  i=0
  while true; do
    if [[ ''$i -eq 10 ]]; then
      break
    fi
    export DEFAULT_INTERFACE=''$(${pkgs.iproute2}/bin/ip route | ${pkgs.gnugrep}/bin/grep '^default' | ${pkgs.gawk}/bin/awk '{print ''$5}' | ''$head -n1)
    if [[ -n ''$DEFAULT_INTERFACE ]]; then
      break
    fi
    let "i++"
    ''$sleep 1
  done
  IFS=''$'\n'
  for m in ''$(polybar --list-monitors); do
    if ${pkgs.gnugrep}/bin/grep -q primary <(echo ''$m); then
      MONITOR=''$(echo ''$m | ''$coreutils --coreutils-prog=cut -d":" -f1) polybar --reload main >/dev/null 2>&1 &
    else
      MONITOR=''$(echo ''$m | ''$coreutils --coreutils-prog=cut -d":" -f1) polybar --reload sub >/dev/null 2>&1 &
    fi
  done
''
