{ pkgs, ... }:

pkgs.writeShellScriptBin "maimFull" ''
  FILENAME="''${HOME}/Pictures/screenshot-''$(${pkgs.coreutils-full}/bin/date +%Y-%m-%d-%T).png"

  ${pkgs.maim}/bin/maim "''${FILENAME}" 

  ${pkgs.xclip}/bin/xclip -selection c -t image/png "''${FILENAME}"
''
