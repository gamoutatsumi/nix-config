{
  pkgs,
  config,
  username,
  ...
}:
{
  # keep-sorted start block=yes
  gtk = {
    # keep-sorted start block=yes
    enable = true;
    font = {
      package = pkgs.ibm-plex;
      name = "IBM Plex Sans";
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    iconTheme = {
      package = pkgs.flat-remix-icon-theme;
      name = "Flat-Remix-Cyan-Dark";
    };
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Cyan-Dark";
    };
    # keep-sorted end
  };
  home = {
    homeDirectory = "/home/${username}";
    file = {
      "backgrounds/atri.jpg".source = builtins.fetchurl {
        url = "https://atri-mdm.com/assets/img/special/present/wp_ATRI.jpg";
        sha256 = "069z1m3664xaciw9hhpqzsa5x5k802fpk9wxbkjxz4chmjnazzfj";
      };
      ".pki/nssdb/pkcs11.txt".text = "library=
name=NSS Internal PKCS #11 Module
parameters=configdir='sql:${config.home.homeDirectory}/.pki/nssdb' certPrefix='' keyPrefix='' secmod='secmod.db' flags=optimizeSpace updatedir='' updateCertPrefix='' updateKeyPrefix='' updateid='' updateTokenDescription=''
NSS=Flags=internal,critical trustOrder=75 cipherOrder=100 slotParams=(1={slotFlags=[ECC,RSA,DSA,DH,RC2,RC4,DES,RANDOM,SHA1,MD5,MD2,SSL,TLS,AES,Camellia,SEED,SHA256,SHA512] askpw=any timeout=30})

library=${pkgs.opensc}/lib/opensc-pkcs11.so
name=CAC Module\n";
    };
    pointerCursor = {
      name = "Vimix-Cursors";
      gtk = {
        enable = true;
      };
      x11 = {
        enable = true;
        defaultCursor = "left_ptr";
      };
      package = pkgs.vimix-cursor-theme;
    };
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-skk
    ];
  };
  services = {
    gnome-keyring.enable = true;
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
  xdg = {
    userDirs = {
      enable = true;
    };
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config = {
        common = {
          default = [ "gtk" ];
        };
      };
    };
    configFile = {
      "rofi".source = ./config/rofi;
      "easyeffects/output/Happy_your_Life_+_Downmix_to_mono.json".source = ./config/easyeffects/Happy_your_Life_+_Downmix_to_mono.json;
      "vivaldi.conf".text = "--force-dark-mode";
      "vivaldi-stable.conf".text = "--force-dark-mode";
      "libskk".source = ./config/libskk;
    };
  };
  # keep-sorted end
}
