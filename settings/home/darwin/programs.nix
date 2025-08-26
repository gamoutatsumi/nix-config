{ pkgs, ... }:
{
  home = {
    packages = [ pkgs.code-cursor ];
  };
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
    ssh = {
      package = pkgs.openssh;
    };
    # keep-sorted end
  };
}
