{ pkgs, upkgs, ... }:
{
  programs = {
    # keep-sorted start block=yes
    alacritty = {
      settings = {
        general = {
          import = [ "~/.config/alacritty/nightfly.toml" ];
        };
        terminal = {
          shell = {
            args = [ "--login" ];
            program = "zsh";
          };
        };
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
      (with pkgs; [
        docker
        pinentry_mac
        aicommit2
      ])
      ++ (with upkgs; [ deno ]);
  };
}
