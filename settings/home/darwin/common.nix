{ username, lib, ... }:
{
  home.homeDirectory = lib.mkForce "/Users/${username}";
  home.sessionVariables = {
    HOMEBREW_PREFIX = "/opt/homebrew";
    HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
    HOMEBREW_REPOSITORY = "/opt/homebrew";
    INFOPATH = "/opt/homebrew/share/info:\${INFOPATH:-}";
    PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:\${PATH}";
  };
}
