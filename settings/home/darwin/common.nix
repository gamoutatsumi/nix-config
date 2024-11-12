{
  username,
  lib,
  pkgs,
  ...
}:
{
  home = {
    homeDirectory = lib.mkForce "/Users/${username}";
    sessionVariables = {
      HOMEBREW_PREFIX = "/opt/homebrew";
      HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
      INFOPATH = "/opt/homebrew/share/info:\${INFOPATH:-}";
      PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:\${PATH}";
    };
    file = {
      ".gnupg/gpg-agent.conf".text = ''
        pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
        enable-ssh-support
      '';
    };
  };
}
