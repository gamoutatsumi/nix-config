{ pkgs, denoVersion, ... }:
{
  home = {
    packages = with pkgs; [
      # keep-sorted start
      agenix-rekey
      chntpw
      deno.${denoVersion}
      discord
      firefox
      kcachegrind
      mpd
      pavucontrol
      slack
      xsel
      zoom-us
      # keep-sorted end
      (vivaldi.override {
        enableWidevine = true;
        proprietaryCodecs = true;
        commandLineArgs = "--force-dark-mode";
      })
      # keep-sorted start
      changeBrightness
      changeVolume
      getPulseVolume
      maimFull
      maimSelect
      playerctlStatus
      toggleMicMute
      xmonadpropread
      # keep-sorted end
    ];
  };
  programs = {
    # keep-sorted start block=yes
    alacritty = {
      settings = {
        import = [
          "${builtins.fetchurl {
            url = "https://raw.githubusercontent.com/bluz71/vim-nightfly-colors/master/extras/nightfly-alacritty.toml";
            sha256 = "0ssgf9i5nrc2m57zvgfzlgfvyhcrwd73pkiny266ba201niv6qi1";
          }}"
        ];
        shell = {
          args = [ "--login" ];
          program = "zsh";
        };
        font = {
          size = 11.5;
        };
      };
    };
    ncmpcpp = {
      enable = true;
      bindings = [
        {
          key = "j";
          command = "scroll_down";
        }
        {
          key = "k";
          command = "scroll_up";
        }
      ];
    };
    rbw = {
      settings = {
        pinentry = pkgs.pinentry-gtk2;
      };
    };
    rofi = {
      enable = true;
      plugins = with pkgs; [
        # keep-sorted start
        rofi-power-menu
        # keep-sorted end
      ];
      font = "IBM Plex Sans JP 14";
      location = "center";
      theme = "Arc-Dark";
      extraConfig = {
        modi = "drun,power-menu:rofi-power-menu";
        kb-cancel = "Escape";
        kb-mode-previous = "Shift+Tab";
        kb-mode-next = "Tab";
        show-icons = true;
        sidebar-mode = true;
        icon-theme = "Vimix-Doder-dark";
      };
    };
    # keep-sorted end
  };
}
