{
  upkgs,
  pkgs,
  lib,
  config,
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
        gcr
        gimp
        kdePackages.kcachegrind
        lssecret
        pavucontrol
        playerctl
        seahorse
        slack
        xsel
        zoom-us
        # keep-sorted end
      ]
      ++ (with upkgs; [
        agenix-rekey
        ghostty
        (vivaldi.override {
          enableWidevine = true;
          proprietaryCodecs = false;
          commandLineArgs = "--force-dark-mode --password-store=gnome-libsecret";
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
        execute_on_song_change = ''${lib.getExe' pkgs.libnotify "notify-send"} "Now Playing" "$(${lib.getExe pkgs.mpc} --format '%title% \n %artist% - %album%' current)"'';
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
        modi = "drun,power-menu:${lib.getExe pkgs.rofi-power-menu}";
        kb-cancel = "Escape";
        kb-mode-previous = "Shift+Tab";
        kb-mode-next = "Tab";
        kb-element-next = "";
        show-icons = true;
        sidebar-mode = true;
        icon-theme = config.gtk.iconTheme.name;
      };
    };
    # keep-sorted end
  };
}
