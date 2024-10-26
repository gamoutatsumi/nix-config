{
  pkgs,
  upkgs,
  networkManager,
  ...
}:
{
  services = {
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
      package = upkgs.emacs-unstable;
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
