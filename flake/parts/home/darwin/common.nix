{
  username,
  lib,
  pkgs,
  ...
}:
{
  xdg = {
    configFile = {
      "karabiner/karabiner.json" = {
        source = ./karabiner/karabiner.json;
      };
    };
  };
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
        pinentry-program ${lib.getExe pkgs.pinentry_mac}
        enable-ssh-support
      '';
    };
  };
  targets = {
    darwin = {
      defaults = {
        NSGlobalDomain = {
          AppleLocale = "ja_JP";
        };
      };
    };
  };
}
