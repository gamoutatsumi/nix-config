{ pkgs, ... }:

pkgs.writeShellScriptBin "changeBrightness" ''
  function getProgressString() {
    ITEMS="''$1" # The total number of items(the width of the bar)
    FILLED_ITEM="''$2" # The look of a filled item 
    NOT_FILLED_ITEM="''$3" # The look of a not filled item
    STATUS="''$4" # The current progress status in percent

    # calculate how many items need to be filled and not filled
    FILLED_ITEMS=''$(echo "((''${ITEMS} * ''${STATUS})/100 + 0.5) / 1" | bc)
    NOT_FILLED_ITEMS=''$(echo "''$ITEMS - ''$FILLED_ITEMS" | ${pkgs.bc}/bin/bc)

    # Assemble the bar string
    msg=''$(printf "%''${FILLED_ITEMS}s" | ${pkgs.gnused}/bin/sed "s| |''${FILLED_ITEM}|g")
    msg=''${msg}''$(printf "%''${NOT_FILLED_ITEMS}s" | ${pkgs.gnused}/bin/sed "s| |''${NOT_FILLED_ITEM}|g")
    echo "''$msg"
  }

  # Arbitrary but unique message id

  ${pkgs.xorg.xbacklight}/bin/xbacklight "''$@" -time 1000 

  brightness="''$(${pkgs.xorg.xbacklight}/bin/xbacklight -get)"
  dunstify -h string:x-dunst-stack-tag:volume -a "changeBrightness" -u low -i "display-brightness-symbolic" \
    "Brightness: ''${brightness}%" "''$(getProgressString 10 "<b> </b>" "　" "''${brightness}")"
''
