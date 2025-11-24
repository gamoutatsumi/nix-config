_: {
  programs = {
    waybar = {
      enable = true;
      systemd = {
        enable = true;
      };
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          output = [
            "DP-1"
            "eDP-1"
          ];
          modules-left = [
            "niri/workspaces"
            "mpd"
            "mpris"
          ];
          modules-right = [
            "pulseaudio"
            "cpu"
            "memory"
            "tray"
            "clock"
          ];
          mpris = {
            format = " {player}: {player_icon} {dynamic}";
            format-paused = " {player}: {status_icon} <i>{dynamic}</i>";
            player-icons = {
              spotify = " ";
              default = " ";
            };
            status-icons = {
              paused = " ";
            };
            ignored-players = [ "mpd" ];
          };
          mpd = {
            format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S})";
            format-disconnected = "MPD disconnected";
            format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped";
            interval = 1;
            consume-icons = {
              on = " ";
            };
            random-icons = {
              off = " ";
              on = "<span color=\"#f53c3c\"></span> ";
            };
            repeat-icons = {
              off = " ";
              on = "<span color=\"#f53c3c\"></span> ";
            };
            single-icons = {
              off = "1 ";
              on = "<span color=\"#f53c3c\">1</span>";
            };
            state-icons = {
              paused = "";
              playing = "";
            };
            tooltip-format = "MPD (connected)";
            tooltip-format-disconnected = "MPD (disconnected)";
          };
          pulseaudio = {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-muted = "";
            format-icons = {
              "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
              "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = "";
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              phone-muted = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
              ];
            };
            scroll-step = 1;
            on-click = "pavucontrol";
            ignored-sinks = [ "Easy Effects Sink" ];
          };
          cpu = {
            interval = 10;
            format = "{}% ";
            max-length = 10;
          };
          memory = {
            interval = 10;
            format = "{}% ";
            max-length = 10;
          };
        };
        subBar = {
          layer = "top";
          position = "top";
          height = 30;
          output = [
            "HDMI-A-1"
          ];
          modules-left = [ "niri/workspaces" ];
          modules-right = [
            "clock"
          ];
        };
      };
    };
  };
  i18n = {
    inputMethod = {
      fcitx5 = {
        waylandFrontend = true;
      };
    };
  };
}
