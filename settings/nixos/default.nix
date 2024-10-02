{ pkgs, ... }:
{
  # keep-sorted start block=yes
  fonts = {
    fontDir = {
      enable = true;
    };
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "PlemolJP Console" ];
        sansSerif = [ "IBM Plex Sans JP" ];
        serif = [ "IBM Plex Serif JP" ];
      };
    };
  };
  i18n.defaultLocale = "ja_JP.UTF-8";
  programs = {
    # keep-sorted start block=yes
    dconf = {
      enable = true;
    };
    # keep-sorted end
  };
  security.rtkit.enable = true;
  services = {
    # keep-sorted start block=yes
    kmscon = {
      enable = true;
      hwRender = true;
      fonts = [
        {
          name = "Source Code Pro";
          package = pkgs.source-code-pro;
        }
      ];
    };
    libinput = {
      enable = true;
    };
    openssh = {
      enable = true;
    };
    pcscd = {
      enable = true;
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber = {
        extraConfig = {
          bluetoothEnhancements = {
            "monitor.bluez.properties" = {
              "bluez5.enable-sbc-xq" = true;
              "bluez5.enable-msbc" = true;
              "bluez5.enable-hw-volume" = true;
              "bluez5.roles" = [
                "hsp_hs"
                "hsp_ag"
                "hfp_hf"
                "hfp_ag"
              ];
            };
          };
        };
      };
    };
    xserver = {
      enable = true;
      displayManager = {
        session = [
          {
            manage = "desktop";
            name = "xsession";
            start = ''exec $HOME/.xsession'';
          }
        ];
        lightdm = {
          enable = true;
          greeters = {
            gtk = {
              enable = true;
            };
          };
        };
      };
    };
    # keep-sorted end
  };
  time = {
    timeZone = "Asia/Tokyo";
    hardwareClockInLocalTime = true;
  };
  # keep-sorted end
}
