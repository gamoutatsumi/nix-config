{
  pkgs,
  username,
  config,
  lib,
  upkgs,
  ...
}:
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
      bitwarden-desktop
    ];
    etc = {
      "pkcs11/modules/opensc-pkcs11".text = ''
        module: ${pkgs.opensc}/lib/opensc-pkcs11.so
      '';
    };
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
        sansSerif = [
          "IBM Plex Sans JP"
          "Noto Sans CJK JP"
        ];
        serif = [
          "IBM Plex Serif JP"
          "Noto Serif CJK JP"
        ];
      };
    };
  };
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  i18n = {
    defaultLocale = "ja_JP.UTF-8";
  };
  programs = {
    # keep-sorted start block=yes
    dconf = {
      enable = true;
    };
    # keep-sorted end
  };
  security = {
    polkit = {
      enable = true;
    };
    pam = {
      u2f = {
        enable = true;
        settings = {
          cue = true;
        };
      };
      services = {
        login = {
          u2fAuth = lib.mkForce false;
          enableGnomeKeyring = true;
        };
      };
    };
    rtkit = {
      enable = true;
    };
  };
  services = {
    # keep-sorted start block=yes
    avahi = {
      enable = true;
    };
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
      package = upkgs.tailscale;
    };
    udev = {
      packages = with pkgs; [ yubikey-personalization ];
      extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="eae7", MODE="0660" GROUP="plugdev", TAG+="uaccess"
      '';
    };
    xserver = {
      enable = true;
      excludePackages = with pkgs; [ xterm ];
      exportConfiguration = true;
      displayManager = {
        session = [
          {
            manage = "desktop";
            name = "xsession";
            start = ''exec ${config.users.users.${username}.home}/.xsession'';
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
