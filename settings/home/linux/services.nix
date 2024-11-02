{ pkgs, networkManager, ... }:
{
  services = {
    mpd = {
      enable = true;
      extraConfig = ''
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
      enable = true;
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
