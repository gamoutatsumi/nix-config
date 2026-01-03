{
  pkgs,
  upkgs,
  lib,
  config,
  ...
}:
{
  home = {
    packages = with upkgs; [
      # keep-sorted start block=yes
      arto
      colima
      container
      docker-client
      podman
      # keep-sorted end
    ];
  };
  services = {
    jankyborders = {
      enable = true;
    };
  };
  programs = {
    # keep-sorted start block=yes
    aerospace =
      let
        sketchybar = lib.getExe config.programs.sketchybar.package;
      in
      {
        enable = true;
        launchd = {
          enable = true;
        };
        extraConfig = ''
          [[on-window-detected]]
          if.app-id = "com.tinyspeck.slackmacgap"
          run = "move-node-to-workspace 10"
          [[on-window-detected]]
          if.app-id = "org.alacritty"
          run = "move-node-to-workspace 3"
          [[on-window-detected]]
          if.app-id = "com.vivaldi.Vivaldi"
          run = "move-node-to-workspace 1"
          [[on-window-detected]]
          if.app-id = "com.google.Chrome"
          run = "move-node-to-workspace 2"
          [[on-window-detected]]
          if.app-id = "com.hnc.Discord"
          run = "move-node-to-workspace 9"
        '';
        userSettings = {
          exec-on-workspace-change = [
            "/bin/bash"
            "-c"
            "${sketchybar} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
          ];
          on-focus-changed = [ "move-mouse window-lazy-center" ];
          gaps = {
            inner = {
              horizontal = 10;
              vertical = 10;
            };
            outer = {
              left = 10;
              bottom = 10;
              top = 10;
              right = 10;
            };
          };
          mode = {
            main = {
              binding = {
                alt-left = "focus left";
                alt-down = "focus down";
                alt-up = "focus up";
                alt-right = "focus right";
                alt-shift-left = "focus-monitor left";
                alt-shift-right = "focus-monitor right";
                alt-ctrl-left = "move left";
                alt-ctrl-down = "move down";
                alt-ctrl-up = "move up";
                alt-ctrl-right = "move right";
                alt-shift-ctrl-left = "move-workspace-to-monitor left";
                alt-shift-ctrl-right = "move-workspace-to-monitor right";
                alt-slash = "layout tiles horizontal vertical";
                alt-comma = "layout accordion horizontal vertical";
                alt-1 = "workspace 1";
                alt-2 = "workspace 2";
                alt-3 = "workspace 3";
                alt-4 = "workspace 4";
                alt-5 = "workspace 5";
                alt-6 = "workspace 6";
                alt-7 = "workspace 7";
                alt-8 = "workspace 8";
                alt-9 = "workspace 9";
                alt-0 = "workspace 10";
              };
            };
          };
        };
      };
    alacritty = {
      settings = {
        font = {
          size = 15;
        };
      };
    };
    ghostty = {
      package = upkgs.ghostty-bin;
    };
    rbw = {
      settings = {
        pinentry = pkgs.pinentry_mac;
      };
    };
    sketchybar =
      let
        date = pkgs.writeShellScript "sketchybar-date" ''
          DATE=$(date '+%m/%d %a')
          sketchybar --set "$NAME" label="$DATE"
        '';
        time = pkgs.writeShellScript "sketchybar-time" ''
          TIME=$(date '+%I:%M %p')
          sketchybar --set "$NAME" label="$TIME"
        '';
        aerospace = lib.getExe config.programs.aerospace.package;
        aerospacePlugin = pkgs.writeShellScript "aerospace" ''
          SID=$(echo "$NAME" | sed 's/space\.//')
          if [ -n "$FOCUSED_WORKSPACE" ]; then
            FOCUSED="$FOCUSED_WORKSPACE"
          else
            FOCUSED=$(${aerospace} list-workspaces --focused 2>/dev/null || echo "1")
          fi

          if [ "$SID" = "$FOCUSED" ]; then
            sketchybar --set "$NAME" \
               background.color="${colors.cyan}" \
               icon.color="${colors.foreground}"
          else
            WINDOWS=$(${aerospace} list-windows --workspace "$SID" 2>/dev/null | wc -l | tr -d ' ')
            if [ "$WINDOWS" -gt 0 ]; then
              sketchybar --set "$NAME" \
                 background.color="${colors.transparent}" \
                 icon.color=${colors.foreground}
            else
              sketchybar --set "$NAME" \
              background.color=${colors.transparent} \
              icon.color=${colors.comment}
            fi
          fi
        '';
        colors = {
          background = "0xff011627";
          backgroundTransparent = "0xcc011627";
          currentLine = "0xff0e293f";
          foreground = "0xfffbdc1c6";
          comment = "0xff7c8f8f";
          cyan = "0xff316394";
          green = "0xffa1cd5e";
          orange = "0xfff78c6c";
          pink = "0xffffcb8b";
          purple = "0xffae881ff";
          red = "0xfffc514e";
          yellow = "0xffe3d18a";
          transparent = "0x00000000";
          black = "0xff011627";
        };
      in
      {
        enable = false;
        service = {
          enable = false;
        };
        config = ''
          bar=(
            height=40
            color="${colors.backgroundTransparent}"
            shadow=on
            position=top
            sticky=on
            padding_left=8
            padding_right=8
            margin=8
            corner_radius=12
            blur_radius=30
            notch_width=200
            y_offset=4
          )
          sketchybar --bar "''${bar[@]}"
          default=(
            icon.font="PlemolJP Console NF:Bold:14.0"
            label.font="PlemolJP Console NF:Bold:12.0"
            background.color="${colors.transparent}"
            background.corner_radius=8
            background.height=28
          )
          sketchybar --default "''${default[@]}"
          sketchybar --add item apple_logo left \
                     --set apple_logo \
                           icon=" " \
                           icon.font="SF Pro:Bold:16.0" \
                           background.corner_radius=10 \
                           background.height=28 \
                           background.color="${colors.cyan}" \
                           icon.padding_left=8 \
                           icon.padding_right=4 \
                           click_script="sketchybar --update"
          sketchybar --add item date right \
                     --set date \
                           icon="" \
                           script="${date}" \
                           update_freq=60 \
                           icon.color="${colors.orange}"
          sketchybar --add item time right \
                     --set time \
                           icon="" \
                           script="${time}" \
                           update_freq=30 \
                           icon.color="${colors.yellow}"
          #sketchybar --add event aerospace_workspace_change
          #SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
          #for i in "''${!SPACE_ICONS[@]}"; do
          #  sid="''${SPACE_ICONS[$i]}"
          #  if [ "$sid" -eq "10" ]; then
          #    display_icon="0"
          #  else
          #    display_icon="$sid"
          #  fi
          #  
          #  sketchybar --add item space.$sid left \
          #              --set space.$sid \
          #                    script="${aerospacePlugin}" \
          #                    icon="$display_icon" \
          #                    icon.font="PlemolJP Console NF:Bold:14.0" \
          #                    icon.padding_left=8 \
          #                    icon.padding_right=8 \
          #                    background.corner_radius=8 \
          #                    background.height=28 \
          #                    update_freq=1 \
          #              --subscribe space.$sid aerospace_workspace_change
          #done
          #sketchybar --add bracket spaces_bracket '/space\..*/' \
          #            --set spaces_bracket \
          #                  background.color="${colors.cyan}" \
          #                  background.corner_radius=10 \
          #                  background.height=28
        '';
      };
    ssh = {
      package = pkgs.openssh;
    };
    # keep-sorted end
  };
}
