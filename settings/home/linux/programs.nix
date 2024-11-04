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
      flat-remix-icon-theme
      kcachegrind
      materia-theme
      mpd
      pavucontrol
      rofi
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
      launchPolybar
      maimFull
      maimSelect
      playerctlStatus
      rofiSystem
      toggleMicMute
      xmonadpropread
      # keep-sorted end
    ];
  };
  programs = {
    # keep-sorted start block=yes
    alacritty = {
      settings = {
        import = [ "~/.config/alacritty/nightfly.toml" ];
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
    };
    # keep-sorted end
  };
}
