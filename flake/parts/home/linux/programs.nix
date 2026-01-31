{
  upkgs,
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit ((pkgs.callPackage ../../../../_sources/generated.nix { })) jdim;
in
{
  home = {
    packages =
      with pkgs;
      [
        # keep-sorted start
        bitwarden-desktop
        chntpw
        gcr
        gimp
        kdePackages.kcachegrind
        lssecret
        pavucontrol
        playerctl
        seahorse
        slack
        wl-clipboard
        zoom-us
        # keep-sorted end
        (stdenv.mkDerivation {
          inherit (jdim) src version pname;
          mesonFlags = [
            "-Dmigemo=enabled"
            "-Dmigemodict=${pkgs.cmigemo}/share/migemo/utf-8/migemo-dict"
          ];
          nativeBuildInputs = with pkgs; [
            gtest
            cmigemo
            gtkmm3
            gnutls
            meson
            ninja
            libxcrypt
            cmake
            pkg-config
          ];
        })
      ]
      ++ (with upkgs; [
        agenix-rekey
        obsidian
        xwayland-satellite
        (vivaldi.override {
          enableWidevine = true;
          proprietaryCodecs = false;
          inherit (upkgs) widevine-cdm;
          commandLineArgs = "--force-dark-mode --password-store=gnome-libsecret";
        })
      ]);
  };
  programs = {
    # keep-sorted start block=yes
    alacritty = {
      settings = {
        font = {
          size = 11.5;
        };
        window = {
          opacity = 0.9;
          decorations = "none";
        };
      };
    };
    discord = {
      enable = true;
    };
    ghostty = {
      package = upkgs.ghostty;
    };
    mpv = {
      enable = true;
      package = upkgs.mpv;
      config = {
        "sub-auto" = "fuzzy";
        "sub-font" = "IBM Plex Sans JP";
        "sub-bold" = true;
        "profile" = "gpu-hq";
        "vo" = "gpu";
        "slang" = "jp,ja,japanese,jpn";
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
    rofi =
      let
        powermenu = pkgs.writeShellScript "rofi-power-menu" (builtins.readFile ./config/rofi/powermenu.sh);
      in
      {
        enable = true;
        package = upkgs.rofi;
        font = "IBM Plex Sans JP 14";
        location = "center";
        theme = "Arc-Dark";
        extraConfig = {
          modi = "drun,power-menu:${powermenu}";
          kb-cancel = "Escape";
          kb-mode-previous = "Shift+Tab";
          kb-mode-next = "Tab";
          kb-element-next = "";
          show-icons = true;
          sidebar-mode = true;
          icon-theme = config.gtk.iconTheme.name;
        };
      };
    zsh = {
      shellAliases = {
        pbcopy = "xsel --clipboard --input";
        open = "xdg-open";
      };
    };
    swaylock = {
      enable = true;
    };
    obs-studio = {
      enable = true;
    };
    firefox = {
      enable = true;
      package = upkgs.firefox;
    };
    # keep-sorted end
  };
}
