{
  pkgs,
  upkgs,
  networkManager,
  ...
}:
{
  services = {
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
