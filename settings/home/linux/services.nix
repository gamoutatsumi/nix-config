{ pkgs, networkManager, ... }:
{
  services = {
    mpd = {
      enable = true;
    };
    mpris-proxy = {
      enable = true;
    };
    mpdris2 = {
      enable = true;
    };
    screen-locker = {
      enable = true;
      lockCmd = "${pkgs.lightlocker}/bin/light-locker-command -l";
      xautolock = {
        enable = true;
        detectSleep = true;
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
