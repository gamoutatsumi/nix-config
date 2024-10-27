{ pkgs, username, ... }:
{
  # keep-sorted start block=yes
  boot = {
    tmp = {
      useTmpfs = true;
    };
  };
  environment = {
    systemPackages = with pkgs; [
      gparted
      gptfdisk
    ];
  };
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
  security = {
    pam = {
      u2f = {
        cue = true;
      };
      services = {
        login = {
          u2fAuth = true;
        };
        sudo = {
          u2fAuth = true;
        };
      };
    };
    rtkit = {
      enable = true;
    };
  };
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
      mouse = {
        accelProfile = "flat";
      };
      touchpad = {
        accelProfile = "flat";
      };
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
    tailscale = {
      enable = true;
    };
    udev = {
      packages = with pkgs; [ yubikey-personalization ];
      extraRules = ''
        ACTION=="remove",\
         ENV{ID_BUS}=="usb",\
         ENV{ID_MODEL_ID}=="0407",\
         ENV{ID_VENDOR_ID}=="1050",\
         ENV{ID_VENDOR}=="Yubico",\
         RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
      '';
    };
    xserver = {
      enable = true;
      excludePackages = with pkgs; [ xterm ];
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
            mini = {
              enable = true;
              user = username;
            };
            gtk = {
              enable = false;
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
