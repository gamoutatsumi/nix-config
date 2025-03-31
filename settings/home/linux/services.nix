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
      pinentryPackage = pkgs.pinentry-gtk2;
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
    # keep-sorted end
  };
}
