{
  pkgs,
  networkManager,
  lib,
  ...
}:
{
  services = {
    # keep-sorted start block=yes
    blueman-applet = {
      enable = true;
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
      profiles = {
        dual-monitor = {
          outputs = [
            {
              criteria = "Eizo Nanao Corporation EV2795 44888121";
            }
            {
              criteria = "I-O Data Device Inc LCD-MF225X G6PF030312R7";
              position = "0,0";
            }
          ];
          exec = [
            ''niri msg action move-workspace-to-monitor --reference chat "I-O Data Device Inc LCD-MF225X G6PF030312R7"''
            ''niri msg action focus-monitor "Eizo Nanao Corporation EV2795 44888121"''
          ];
        };
        docked = {
          outputs = [
            {
              criteria = "Eizo Nanao Corporation EV2795 44888121";
            }
            {
              criteria = "I-O Data Device Inc LCD-MF225X G6PF030312R7";
              position = "0,0";
            }
            {
              criteria = "eDP-1";
              status = "disable";
            }
          ];
          exec = [
            ''niri msg action move-workspace-to-monitor --reference chat "I-O Data Device Inc LCD-MF225X G6PF030312R7"''
            ''niri msg action focus-monitor "Eizo Nanao Corporation EV2795 44888121"''
          ];
        };
      };
    };
    mako = {
      enable = true;
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
      enable = networkManager;
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
          command = "niri msg action power-off-monitors";
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
