{ pkgs, networkManager, ... }:
{
  services = {
    playerctld = {
      enable = true;
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
    mpris-proxy = {
      enable = true;
    };
    mpdris2 = {
      enable = true;
    };
    screen-locker = {
      enable = false;
      lockCmd = "${pkgs.systemd}/bin/loginctl lock-sessions";
      xautolock = {
        enable = false;
      };
    };
    emacs = {
      enable = true;
      client = {
        enable = true;
      };
    };
    network-manager-applet = {
      enable = networkManager;
    };
    gpg-agent = {
      enable = true;
      enableScDaemon = true;
      enableSshSupport = true;
      enableZshIntegration = true;
      pinentryPackage = pkgs.pinentry-gtk2;
    };
    blueman-applet = {
      enable = true;
    };
  };
}
