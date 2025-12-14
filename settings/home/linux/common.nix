{
  pkgs,
  inputs,
  config,
  username,
  lib,
  upkgs,
  ...
}:
{
  # keep-sorted start block=yes
  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
  gtk = {
    # keep-sorted start block=yes
    enable = true;
    font = {
      package = pkgs.ibm-plex;
      name = "IBM Plex Sans";
    };
    gtk2 = {
      extraConfig = ''
        gtk-application-prefer-dark-theme = 0
        gtk-enable-primary-paste = 0
        gtk-im-module = "fcitx"
      '';
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-enable-primary-paste = false;
        gtk-im-module = "fcitx";
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-enable-primary-paste = false;
        gtk-im-module = "fcitx";
      };
    };
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela-blue-dark";
    };
    theme = {
      package = pkgs.orchis-theme;
      name = "Orchis-Dark";
    };
    # keep-sorted end
  };
  home = {
    homeDirectory = "/home/${username}";
    file = {
      ".pki/nssdb/pkcs11.txt".text =
        "library=
name=NSS Internal PKCS #11 Module
parameters=configdir='sql:${config.home.homeDirectory}/.pki/nssdb' certPrefix='' keyPrefix='' secmod='secmod.db' flags=optimizeSpace updatedir='' updateCertPrefix='' updateKeyPrefix='' updateid='' updateTokenDescription=''
NSS=Flags=internal,critical trustOrder=75 cipherOrder=100 slotParams=(1={slotFlags=[ECC,RSA,DSA,DH,RC2,RC4,DES,RANDOM,SHA1,MD5,MD2,SSL,TLS,AES,Camellia,SEED,SHA256,SHA512] askpw=any timeout=30})

library=${pkgs.p11-kit}/lib/p11-kit-proxy.so
name=p11-kit-proxy\n";
    };
    pointerCursor = {
      name = "macOS";
      size = 22;
      gtk = {
        enable = true;
      };
      x11 = {
        enable = true;
        defaultCursor = "left_ptr";
      };
      package = pkgs.apple-cursor;
    };
  };
  i18n = {
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-skk
        ];
      };
    };
  };
  qt = {
    enable = true;
    platformTheme = {
      name = "gtk3";
    };
  };
  services = {
    picom = {
      enable = true;
      backend = "glx";
      vSync = true;
      settings = {
        glx-no-stencil = true;
        xrender-sync-fence = true;
        unredir-if-possible = false;
        refresh-rate = 0;
      };
    };
    random-background = {
      enable = true;
      imageDirectory = "%h/backgrounds";
    };
  };
  systemd = {
    user = {
      services = {
        bitwarden-desktop = {
          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
          Unit = {
            Description = "Bitwarden Desktop";
            After = [ "basic.target" ];
            PartOf = [ "graphical-session.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = lib.getExe pkgs.bitwarden-desktop;
            Restart = "on-failure";
            RestartSec = 5;
            TimeoutStopSec = 10;
          };
        };
      };
    };
  };
  xdg = {
    userDirs = {
      enable = true;
    };
    configFile = {
      "Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json" = {
        source = import ../../../mcp.nix {
          format = "json";
          flavor = "claude";
          inherit config inputs;
          pkgs = upkgs;
        };
      };
      "easyeffects/output/Happy_your_Life_+_Downmix_to_mono.json" = {
        source = ./config/easyeffects/Happy_your_Life_+_Downmix_to_mono.json;
      };
      "libskk" = {
        source = ./config/libskk;
      };
    };
  };
  # keep-sorted end
}
