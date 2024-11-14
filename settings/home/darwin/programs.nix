{ pkgs, upkgs, ... }:
{
  programs = {
    # keep-sorted start block=yes
    alacritty = {
      settings = {
        general = {
          import = [
            "${builtins.fetchurl {
              url = "https://raw.githubusercontent.com/bluz71/vim-nightfly-colors/master/extras/nightfly-alacritty.toml";
              sha256 = "0ssgf9i5nrc2m57zvgfzlgfvyhcrwd73pkiny266ba201niv6qi1";
            }}"
          ];
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
        docker-client
        aicommit2
      ])
      ++ (with upkgs; [ deno ]);
  };
}
