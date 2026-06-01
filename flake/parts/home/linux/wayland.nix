{ pkgs, ... }:
let
  atri_wp = pkgs.fetchurl {
    url = "https://atri-mdm.com/assets/img/special/present/wp_ATRI.jpg";
    sha256 = "069z1m3664xaciw9hhpqzsa5x5k802fpk9wxbkjxz4chmjnazzfj";
  };
in
{
  services = {
    hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        preload = [ "${atri_wp}" ];
        wallpaper = [
          {
            monitor = "";
            fit_mode = "cover";
            path = "${atri_wp}";
          }
        ];
      };
    };
  };
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
            "eDP-1"
            "DP-1"
            "DP-2"
          ];
          modules-left = [
            "niri/workspaces"
            "mpd"
            "mpris"
          ];
          modules-right = [
            "battery"
            "pulseaudio"
            "cpu"
            "memory"
            "tray"
            "clock"
          ];
          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "{capacity}%";
            format-plugged = "{capacity}%";
          };
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
