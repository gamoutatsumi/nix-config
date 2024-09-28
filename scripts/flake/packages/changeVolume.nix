{ pkgs, ... }:

pkgs.writeShellScriptBin "changeVolume" ''
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

  # changeVolume

  # Arbitrary but unique message id

  if [[ "''$@" == "mute" ]]; then
    ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle
  else
    ${pkgs.pulseaudio}/bin/pactl -- set-sink-volume @DEFAULT_SINK@ "''$@"
  fi

  default_sink="''$(LANG=C LC_ALL=C ${pkgs.pulseaudio}/bin/pactl info | ${pkgs.gnugrep}/bin/grep "^Default Sink" | ${pkgs.gawk}/bin/awk '{print ''$3}')"
  volume="''$(LANG=C LC_ALL=C ${pkgs.pulseaudio}/bin/pactl list sinks | ${pkgs.gnugrep}/bin/grep "Name: ''${default_sink}" -A 10 | ${pkgs.gnugrep}/bin/grep '^[[:space:]]Volume:' | ${pkgs.gnused}/bin/sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')"
  mute="''$(LANG=C LC_ALL=C ${pkgs.pulseaudio}/bin/pactl list sinks | ${pkgs.gnugrep}/bin/grep "Name: ''${default_sink}" -A 10 | ${pkgs.gnugrep}/bin/grep 'Mute:' | ${pkgs.gnused}/bin/sed 's/^[[:space:]]//' | ${pkgs.coreutils-full}/bin/cut -d " " -f 2)"
  if [[ ''$volume == 0 || "''$mute" == "yes" ]]; then
      # Show the sound muted notification
      dunstify -h string:x-dunst-stack-tag:volume -a "changeVolume" -u low -i "audio-volume-muted-symbolic" "Volume muted"
  else
      # Show the volume notification
      dunstify -h string:x-dunst-stack-tag:volume -a "changeVolume" -u low -i "audio-volume-high-symbolic" \
      "Volume: ''${volume}%" "''$(getProgressString 10 "<b> </b>" "　" "''${volume}")"
  fi
''
