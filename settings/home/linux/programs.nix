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
        pavucontrol
        playerctl
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
        ghostty

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
      settings = {
        media_library_primary_tag = "album_artist";
      };
      bindings = [
        {
          key = "j";
          command = "scroll_down";
        }
        {
          key = "k";
          command = "scroll_up";
        }
        {
          key = "h";
          command = "previous_column";
        }
        {
          key = "l";
          command = "next_column";
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
      font = "IBM Plex Sans JP 14";
      location = "center";
      theme = "Arc-Dark";
      extraConfig = {
        modi = "drun,power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
        kb-cancel = "Escape";
        kb-mode-previous = "Shift+Tab";
        kb-mode-next = "Tab";
        kb-element-next = "";
        show-icons = true;
        sidebar-mode = true;
        icon-theme = "Vimix-Doder-dark";
      };
    };
    # keep-sorted end
  };
}
