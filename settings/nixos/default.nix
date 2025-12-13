{
  pkgs,
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
    niri = {
      enable = true;
      package = pkgs.niri;
    };
    regreet =
      let
        atri_wp = pkgs.fetchurl {
          url = "https://atri-mdm.com/assets/img/special/present/wp_ATRI.jpg";
          sha256 = "069z1m3664xaciw9hhpqzsa5x5k802fpk9wxbkjxz4chmjnazzfj";
        };
      in
      {
        enable = true;
        iconTheme = {
          package = pkgs.vimix-icon-theme;
          name = "Vimix-doder-dark";
        };
        theme = {
          package = pkgs.vimix-gtk-themes;
          name = "Vimix-dark-doder";
        };
        font = {
          package = pkgs.plemoljp;
          name = "PlemolJP Regular";
        };
        cursorTheme = {
          name = "macOS";
          package = pkgs.apple-cursor;
        };
        settings = {
          GTK = {
            application_prefer_dark_theme = true;
          };
          background = {
            path = atri_wp;
            fit = "Cover";
          };
          commands = {
            reboot = [
              "systemctl"
              "reboot"
            ];
            poweroff = [
              "systemctl"
              "poweroff"
            ];
          };
        };
      };
    # keep-sorted end
  };
  security = {
    polkit = {
      enable = true;
    };
    pam = {
      services = {
        login = {
          enableGnomeKeyring = true;
        };
        greetd = {
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
    greetd =
      let
        minimumConfig = pkgs.writeText "minimum-config.kdl" ''
          hotkey-overlay {
            skip-at-startup
          }
          spawn-at-startup "sh" "-c" "${lib.getExe config.programs.regreet.package}; niri msg action quit --skip-confirmation"
        '';
      in
      {
        enable = true;
        settings = {
          default_session = {
            command = "env GTK_USE_PORTAL=0 GDK_DEBUG=no-portals ${lib.getExe config.programs.niri.package} --config ${minimumConfig}";
            user = "greeter";
          };
        };
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
      packages = with pkgs; [
        yubikey-personalization
        via
      ];
    };
    # keep-sorted end
  };
  time = {
    timeZone = "Asia/Tokyo";
    hardwareClockInLocalTime = true;
  };
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
    };
  };
  # keep-sorted end
}
