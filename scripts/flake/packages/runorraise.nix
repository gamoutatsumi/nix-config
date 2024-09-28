{ pkgs, ... }:

pkgs.writeShellScriptBin "runorraise" ''
  if [ ''$# -ge 3 ]; then
  if [ "''$(i3-msg "["''$1"="''$2"] focus")" != "[{\"success\":true}]" ]; then
  i3-msg exec -- --no-startup-id "''$3 ''${@:4}"
  fi
  else
  i3-nagbar -t error -f "xft:DejaVu Sans Mono 11px" -m "''${0##*/} : error (wrong number of arguments)"
          exit
          fi
''
