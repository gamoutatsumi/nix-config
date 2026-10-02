{
  # keep-sorted start
  pkgs,
  upkgs,
  # keep-sorted end
  ...
}:
{
  programs = {
    alacritty = {
      enable = true;
      package = upkgs.alacritty;
      settings = {
        general = {
          import = [
            "${pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/bluz71/vim-nightfly-colors/master/extras/nightfly-alacritty.toml";
              sha256 = "0sc2j2vshpdclz97g8pk9699qzjpafi5zf1mb7k8jzs3n692sdrk";
            }}"
          ];
        };
        terminal = {
          shell = {
            args = [ "--login" ];
            program = "zsh";
          };
        };
        env = {
          TERM = "alacritty-direct";
          WINIT_X11_SCALE_FACTOR = "1.1";
        };
        font = {
          normal = {
            family = "PlemolJP Console NF";
          };
        };
        keyboard = {
          bindings = [
            {
              action = "ToggleFullScreen";
              key = "F11";
            }
            {
              chars = "\\u001b[98;6u";
              key = "b";
              mods = "Control|Shift";
            }
            {
              chars = "\\u001b[102;6u";
              key = "f";
              mods = "Control|Shift";
            }
          ];
        };
        mouse = {
          bindings = [
            {
              action = "none";
              mouse = "Middle";
            }
          ];
        };
        window = {
          option_as_alt = "Both";
        };
      };
    };
  };
}
