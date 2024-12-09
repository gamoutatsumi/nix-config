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
    rbw = {
      settings = {
        pinentry = pkgs.pinentry_mac;
      };
    };
    # keep-sorted end
  };
  home = {
    packages =
      (with pkgs; [ docker-client ])
      ++ (with upkgs; [
        aicommit2
        deno
      ]);
  };
}
