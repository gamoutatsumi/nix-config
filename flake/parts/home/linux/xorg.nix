{
  pkgs,
  lib,
  upkgs,
  config,
  ...
}:
{
  theme = {
    wallpaper = {
      file = pkgs.fetchurl {
        url = "https://atri-mdm.com/assets/img/special/present/wp_ATRI.jpg";
        sha256 = "069z1m3664xaciw9hhpqzsa5x5k802fpk9wxbkjxz4chmjnazzfj";
      };
    };
    tinty = {
      enable = false;
      generate = {
        variant = "dark";
        system = "base24";
      };
      shell = "zsh";
      themes = {
        alacritty = {
          enable = true;
        };
        shell = {
          enable = true;
        };
      };
    };
  };
  services = {
    polybar = {
      enable = true;
      package = upkgs.polybarFull.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ config.services.mpd.package ];
      });
      script = lib.getExe upkgs.launchPolybar;
      config = {
        colors = {
          bg = "#222D32";
          fg = "#CFD8DC";
          adapta-cyan = "#00BCD4";
          adapta-red = "#FF5252";
          adapta-yellow = "#C9BC0E";
          adapta-lightgreen = "#4DB6AC";
          adapta-green = "#009688";
          adapta-grey = "#475359";
        };
        margin = {
          for-modules = 1;
        };

        "bar/main" = {
          width = "100%";
          height = "3%";
          fixed-center = true;
          line-size = 2;
          background = "\${colors.bg}";
          foreground = "\${colors.fg}";
          font-0 = "Plemol JP Console NF:pixelsize=10;2";
          font-1 = "Plemol JP Console NF:pixelsize=22;4";
          font-2 = "Plemol JP Console NF:pixelsize=13;2";
          font-3 = "Plemol JP Console NF:pixelsize=12;4";
          font-4 = "Symbols Nerd Font:pixelsize=10;2";
          font-5 = "IBM Plex Sans JP:pixelsize=10;2";
          cursor-click = "pointer";
          monitor = "\${env:MONITOR:}";
          modules-left = [
            "xmonad"
            "mpd"
          ];
          modules-right = [
            "cpu"
            "memory"
            "network"
            "pulseaudio"
            "battery"
            "date"
            "tray"
          ];
        };

        "bar/sub" = {
          width = "100%";
          height = "3%";
          fixed-center = true;
          line-size = 2;
          background = "\${colors.bg}";
          foreground = "\${colors.fg}";
          font-0 = "Plemol JP Console NF:pixelsize=10;2";
          font-1 = "Plemol JP Console NF:pixelsize=22;4";
          font-2 = "Plemol JP Console NF:pixelsize=13;2";
          font-3 = "Plemol JP Console NF:pixelsize=12;4";
          font-4 = "Symbols Nerd Font:pixelsize=10;2";
          font-5 = "IBM Plex Sans JP:pixelsize=10;2";
          cursor-click = "pointer";
          monitor = "\${env:MONITOR:}";
          modules-left = "xmonad";
        };

        "module/xmonad" = {
          type = "custom/script";
          exec = lib.getExe upkgs.xmonadpropread;
          tail = true;
          format-padding = 1;
        };

        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          use-ui-max = true;
          format-volume = "<ramp-volume> <label-volume>";
          label-muted = " muted";
          ramp-volume-0 = "";
          ramp-volume-1 = "";
          ramp-volume-2 = "";
          click-right = lib.getExe upkgs.pavucontrol;
          format-volume-underline = "\${colors.adapta-cyan}";
          format-muted-underline = "\${colors.adapta-grey}";
          format-volume-margin = 1;
          format-muted-margin = 1;
          interval = 5;
        };

        "module/workspaces" = {
          type = "internal/xworkspaces";
          pin-workspaces = false;
          enable-click = false;
          enable-scroll = false;
          format-padding = 1;
          icon-default = "○";
          format = "<label-state>";
          label-active = "● ";
          label-occupied = "◉ ";
          label-urgent = "● ";
          label-empty = "○ ";
          label-empty-foreground = "\${colors.fg}";
        };

        "module/i3" = {
          type = "internal/i3";
          pin-workspaces = false;
          enable-click = false;
          enable-scroll = false;
          format-padding = 1;
          icon-default = "○";
          format = "<label-state>";
          label-focused = "● ";
          label-unfocused = "◉ ";
          label-urgent = "● ";
          label-visible = "○ ";
          label-visible-foreground = "\${colors.fg}";
          index-sort = true;
        };

        "module/date" = {
          type = "internal/date";
          interval = 1;
          label = "%time%";
          label-padding = 1;
          label-underline = "\${colors.adapta-cyan}";
          time = "%Y/%m/%d %a %H:%M";
          label-margin = "\${margin.for-modules}";
        };

        "module/xbacklight" = {
          type = "internal/xbacklight";
          enable_scroll = true;
          format = " <label>";
          format-underline = "\${colors.adapta-cyan}";
          format-padding = 1;
          label = "%percentage%%";
        };

        "module/pulseaudio-control" = {
          type = "custom/script";
          tail = true;
          format-underline = "\${colors.adapta-cyan}";
          label-padding = 2;
          label-foreground = "\${colors.fg}";
          exec = ''LC_ALL=C pulseaudio-control --icons-volume " , " --icon-muted " " --sink-nicknames-from "device.description" listen'';
          click-right = lib.getExe upkgs.pavucontrol;
          click-left = "${lib.getExe upkgs.changeVolume} mute";
          scroll-up = "${lib.getExe upkgs.changeVolume} +1%";
          scroll-down = "${lib.getExe upkgs.changeVolume} -1%";
        };

        "module/cpu" = {
          type = "internal/cpu";
          interval = 3;
          format-prefix = " ";
          format-underline = "\${colors.adapta-cyan}";
          format-margin = "\${margin.for-modules}";
          format-padding = 1;
          label = "%percentage:2%%";
        };

        "module/memory" = {
          type = "internal/memory";
          interval = 3;
          format-prefix = " ";
          format-underline = "\${colors.adapta-cyan}";
          format-padding = 1;
          label = "%percentage_used:2%%";
        };

        "module/battery" = {
          type = "internal/battery";
          full-at = 99;
          battery = "BAT0";
          adapter = "ADP1";
          format-charging = "<animation-charging> <label-charging>";
          format-charging-underline = "\${colors.adapta-cyan}";
          format-charging-padding = 1;
          label-charging = "%percentage%%";
          format-discharging = "<ramp-capacity> <label-discharging>";
          format-discharging-underline = "\${colors.adapta-cyan}";
          format-discharging-padding = 1;
          label-discharging = "%percentage:2%%";
          format-full = "<label-full>";
          format-full-underline = "\${colors.adapta-cyan}";
          format-full-padding = 1;
          format-charging-margin = "\${margin.for-modules}";
          format-discharging-margin = "\${margin.for-modules}";
          format-full-margin = "\${margin.for-modules}";
          format-full-prefix = "󰁹 ";
          ramp-capacity-0 = "󰁺";
          ramp-capacity-1 = "󰁻";
          ramp-capacity-2 = "󰁼";
          ramp-capacity-3 = "󰁽";
          ramp-capacity-4 = "󰁾";
          ramp-capacity-5 = "󰁿";
          ramp-capacity-6 = "󰁿";
          ramp-capacity-7 = "󰂀";
          ramp-capacity-8 = "󰂁";
          ramp-capacity-9 = "󰂂";
          ramp-capacity-0-foreground = "\${colors.adapta-red}";
          ramp-capacity-1-foreground = "\${colors.adapta-red}";
          ramp-capacity-2-foreground = "\${colors.adapta-red}";
          ramp-capacity-3-foreground = "\${colors.adapta-red}";
          ramp-capacity-4-foreground = "\${colors.adapta-yellow}";
          ramp-capacity-5-foreground = "\${colors.adapta-yellow}";
          ramp-capacity-foreground = "\${colors.fg}";
          animation-charging-0 = "󰢜";
          animation-charging-1 = "󰂆";
          animation-charging-2 = "󰂇";
          animation-charging-3 = "󰂈";
          animation-charging-4 = "󰢝";
          animation-charging-5 = "󰂉";
          animation-charging-6 = "󰢞";
          animation-charging-7 = "󰂊";
          animation-charging-8 = "󰂋";
          animation-charging-9 = "󰂅";
          animation-charging-foreground = "\${colors.fg}";
          animation-charging-framerate = 750;
        };

        "module/network" = {
          type = "internal/network";
          interface = "\${env:DEFAULT_INTERFACE:}";
          interval = 3;
          format-connected = "<label-connected>";
          format-connected-underline = "\${colors.adapta-cyan}";
          format-connected-padding = 1;
          format-connected-margin = 1;
          label-connected = "%upspeed:9% %downspeed:9%";
        };

        "module/kernel" = {
          type = "custom/script";
          exec = "uname -rm";
          interval = 0;
        };

        "module/mpd" = {
          type = "internal/mpd";
          host = "127.0.0.1";
          port = "6600";
          interval = 1;
          format-online = "<icon-prev> <icon-seekb> <icon-stop> <toggle> <icon-seekf> <icon-next>  <icon-repeat> <icon-random>  <bar-progress> <label-time>  <label-song>";
          label-song = "%artist% - %title%";
          label-offline = "mpd is offline";
          icon-play = "󰐊";
          icon-pause = "󰏤";
          icon-stop = "󰓛";
          icon-prev = "󰒫";
          icon-next = "󰒬";
          icon-seekb = "󰓕";
          icon-seekf = "󰓗";
          icon-random = "󰒟";
          icon-repeat = "󰑖";
          icon-repeatone = "󰑘";
          icon-single = "󰊍";
          icon-consume = "󰆐";
          toggle-on-foreground = "#ff";
          toggle-off-foreground = "#55";
          bar-progress-width = 45;
          bar-progress-indicator = "|";
          bar-progress-fill = "─";
          bar-progress-empty = "─";
        };

        "module/tray" = {
          type = "internal/tray";
          format-margin = "8px";
          tray-spacing = "8px";
          tray-size = "40%";
        };
      };
    };
  };
  xsession = {
    enable = false;
    initExtra = ''
      ${lib.getExe pkgs.xorg.xinput} disable 'SynPS/2 Synaptics TouchPad'
      ${lib.getExe' pkgs.lightlocker "light-locker"} &
    '';
    windowManager = {
      xmonad = {
        enable = true;
        config = ./config/xmonad/xmonad.hs;
        enableContribAndExtras = true;
        haskellPackages = pkgs.haskell.packages.ghc98;
        extraPackages =
          haskellPackages: with haskellPackages; [
            containers
            unix
            directory
          ];
        libFiles = {
          "Keys.hs" = ./config/xmonad/lib/Keys.hs;
          "Layouts.hs" = ./config/xmonad/lib/Layouts.hs;
          "Types.hs" = ./config/xmonad/lib/Types.hs;
          "Workspace.hs" = ./config/xmonad/lib/Workspace.hs;
        };
      };
      i3 = {
        enable = false;
        package = pkgs.i3-gaps;
        config = {
          assigns = {
            web = [ { class = "^Vivaldi-stable$"; } ];
            slack = [ { class = "^Slack$"; } ];
            terminal = [ { class = "^Alacritty$"; } ];
          };
          window = {
            titlebar = false;
          };
          bars = [ ];
          keybindings =
            let
              modifier = "Mod4";
              menu = ''"rofi -show"'';
            in
            lib.mkDefault {
              "${modifier}+Return" = ''"exec --no-startup-id runorraise class Alacritty alacritty"'';
              "Mod1+space" = "exec --no-startup-id ${menu}";
              "${modifier}+c" = "kill";
              "${modifier}+Shift+q" = "reload";
              "XF86AudioRaiseVolume" = ''"exec --no-startup-id changeVolume +1%"'';
              "XF86AudioLowerVolume" = ''"exec --no-startup-id changeVolume -1%"'';
              "XF86AudioMute" = ''"exec --no-startup-id changeVolume mute"'';
              "XF86AudioMicMute" = ''"exec --no-startup-id toggleMicMute"'';
              "Shift+XF86AudioMute" = ''"exec --no-startup-id toggleMicMute"'';
              "${modifier}+w" =
                ''"exec --no-startup-id runorraise class Vivaldi-stable vivaldi --force-dark-mode"'';
              "${modifier}+Shift+s" = ''"exec --no-startup-id runorraise class Slack slack"'';
              "${modifier}+Shift+h" = ''"move workspace to output left"'';
              "${modifier}+Shift+l" = ''"move workspace to output right"'';
            };
        };
      };
    };
  };
}
