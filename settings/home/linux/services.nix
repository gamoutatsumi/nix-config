{
  pkgs,
  upkgs,
  networkManager,
  ...
}:
{
  services = {
    mpris-proxy = {
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
      package = upkgs.emacsWithPackagesFromUsePackage {
        config = builtins.toFile "empty.el" "";
        package = upkgs.emacs-unstable;
        extraEmacsPackages =
          epkgs: with epkgs; [
            ddskk
            mermaid-mode
            lsp-mode
            hydra
            leaf
            leaf-keywords
            leaf-tree
            leaf-convert
            org
            tree-sitter
            modus-themes
            ein
            go-mode
            bind-key
            htmlize
          ];
      };
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
