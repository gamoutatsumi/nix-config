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
    activation = {
      macskk = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD cp ${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L "$HOME/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.L"
      '';
    };
    sessionVariables = {
      HOMEBREW_PREFIX = "/opt/homebrew";
      HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
      INFOPATH = "/opt/homebrew/share/info:\${INFOPATH:-}";
      PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:\${PATH}";
    };
    file = {
      ".gnupg/gpg-agent.conf" = {
        text = ''
          pinentry-program ${lib.getExe pkgs.pinentry_mac}
          enable-ssh-support
        '';
      };
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
