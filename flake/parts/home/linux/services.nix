{
  pkgs,
  nixosConfig,
  lib,
  osConfig,
  ...
}:
let
  claudecodeui = pkgs.callPackage ./claudecodeui.nix { };
in
{
  systemd = {
    user = {
      services = {
        claude-code-ui = {
          Service = {
            ExecStart = "${claudecodeui}/bin/claude-code-ui";
            Environment = "DATABASE_PATH=%h/.local/share/claude-code-ui/database/auth.db";
          };
        };
      };
    };
  };
  services = {
    # keep-sorted start block=yes
    blueman-applet = {
      inherit (nixosConfig.services.blueman) enable;
    };
    emacs = {
      enable = true;
      client = {
        enable = true;
      };
    };
    gnome-keyring = {
      enable = true;
    };
    gpg-agent = {
      enable = true;
      enableScDaemon = true;
      enableSshSupport = true;
      enableZshIntegration = true;
      pinentry = {
        package = pkgs.pinentry-gtk2;
      };
    };
    kanshi = {
      enable = true;
      settings = [
        {
          output = {
            criteria = "Eizo Nanao Corporation EV2795 44888121";
            alias = "MAIN";
          };
        }
        {
          output = {
            criteria = "I-O Data Device Inc LCD-MF225X G6PF030312R7";
            alias = "SIDE";
            position = "0,0";
          };
        }
        {
          profile = {
            name = "dual-monitor";
            outputs = [
              {
                criteria = "$MAIN";
                status = "enable";
              }
              {
                criteria = "$SIDE";
                status = "enable";
              }
            ];
            exec = [
              ''${lib.getExe osConfig.programs.niri.package} msg action move-workspace-to-monitor --reference chat "I-O Data Device Inc LCD-MF225X G6PF030312R7"''
              ''${lib.getExe osConfig.programs.niri.package} msg action focus-monitor "Eizo Nanao Corporation EV2795 44888121"''
            ];
          };
        }
        {
          profile = {
            name = "docked";
            outputs = [
              {
                criteria = "$MAIN";
                status = "enable";
              }
              {
                criteria = "$SIDE";
                status = "enable";
              }
              {
                criteria = "eDP-1";
                status = "disable";
              }
            ];
            exec = [
              ''${lib.getExe osConfig.programs.niri.package} msg action move-workspace-to-monitor --reference chat "I-O Data Device Inc LCD-MF225X G6PF030312R7"''
              ''${lib.getExe osConfig.programs.niri.package} msg action focus-monitor "Eizo Nanao Corporation EV2795 44888121"''
            ];
          };
        }
      ];
    };
    mako = {
      enable = true;
      settings = {
        default-timeout = 5000;
      };
    };
    mpd = {
      enable = true;
      package = pkgs.mpd.overrideAttrs (
        _: prev: {
          buildInputs = prev.buildInputs ++ [ pkgs.wavpack ];
          nativeBuildInputs = prev.nativeBuildInputs ++ [ pkgs.wavpack ];
          mesonFlags = prev.mesonFlags ++ [ "-Dwavpack=enabled" ];
        }
      );
      extraConfig = ''
        playlist_plugin {
        name "cue"
        enabled "false"
        }
        audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
        }
      '';
    };
    mpd-discord-rpc = {
      enable = false;
      settings = {
        format = {
          large_image = "";
          small_image = "";
        };
      };
    };
    mpdris2 = {
      enable = true;
    };
    mpris-proxy = {
      enable = true;
    };
    network-manager-applet = {
      inherit (nixosConfig.networking.networkmanager) enable;
    };
    playerctld = {
      enable = true;
    };
    screen-locker = {
      enable = false;
      lockCmd = "${lib.getExe' pkgs.systemd "loginctl"} lock-sessions";
      xautolock = {
        enable = false;
      };
    };
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 601;
          command = "${lib.getExe osConfig.programs.niri.package} msg action power-off-monitors";
        }
        {
          timeout = 600;
          command = "${lib.getExe pkgs.swaylock} -fF";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${lib.getExe pkgs.swaylock} -fF";
        }
      ];
    };
    # keep-sorted end
  };
}
