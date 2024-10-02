{ pkgs, ... }:
{
  programs = {
    # keep-sorted start block=yes
    alacritty = {
      settings = {
        font = {
          size = 15;
        };
      };
    };
    rbw = {
      settings = {
        pinentry = pkgs.pinentry_mac;
      };
    };
    zsh = {
      initExtraFirst = ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };
    # keep-sorted end
  };
}
