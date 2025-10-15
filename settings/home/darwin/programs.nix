{ pkgs, upkgs, ... }:
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
    ghostty = {
      package = upkgs.ghostty-bin;
    };
    rbw = {
      settings = {
        pinentry = pkgs.pinentry_mac;
      };
    };
    ssh = {
      package = pkgs.openssh;
    };
    # keep-sorted end
  };
}
