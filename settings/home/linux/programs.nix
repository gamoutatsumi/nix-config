{
  upkgs,
  pkgs,
  denoVersion,
  ...
}:
{
  home = {
    packages =
      with pkgs;
      [
        # keep-sorted start
        bitwarden-desktop
        chntpw
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
      ]
      ++ (with upkgs; [
        agenix-rekey
        deno.${denoVersion}

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
      ]);
  };
  programs = {
    # keep-sorted start block=yes
    alacritty = {
      settings = {
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
