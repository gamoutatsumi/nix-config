{
  pkgs,
  config,
  username,
  lib,
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
      package = pkgs.vimix-icon-theme;
      name = "Vimix-Doder-dark";
    };
    theme = {
      package = pkgs.vimix-gtk-themes;
      name = "vimix-dark-doder";
    };
    # keep-sorted end
  };
  home = {
    homeDirectory = "/home/${username}";
    file = {
      ".vscode/argv.json".text = lib.strings.toJSON { password-store = "gnome-libsecret"; };
      ".pki/nssdb/pkcs11.txt".text =
        "library=
name=NSS Internal PKCS #11 Module
parameters=configdir='sql:${config.home.homeDirectory}/.pki/nssdb' certPrefix='' keyPrefix='' secmod='secmod.db' flags=optimizeSpace updatedir='' updateCertPrefix='' updateKeyPrefix='' updateid='' updateTokenDescription=''
NSS=Flags=internal,critical trustOrder=75 cipherOrder=100 slotParams=(1={slotFlags=[ECC,RSA,DSA,DH,RC2,RC4,DES,RANDOM,SHA1,MD5,MD2,SSL,TLS,AES,Camellia,SEED,SHA256,SHA512] askpw=any timeout=30})

library=${pkgs.p11-kit}/lib/p11-kit-proxy.so
name=p11-kit-proxy\n";
    };
    pointerCursor = {
      name = "Vimix-cursors";
      gtk = {
        enable = true;
      };
      x11 = {
        enable = true;
        defaultCursor = "left_ptr";
      };
      package = pkgs.vimix-cursors.overrideAttrs (
        _final: _prev: {
          patches = [
            (pkgs.writeText "diff.patch" ''
              diff --git a/build.sh b/build.sh
              index 71d26e6..f402af3 100755
              --- a/build.sh
              +++ b/build.sh
              @@ -47,7 +47,7 @@ function create {
               	cd $SRC
               
               	# generate cursors
              -	if [[ "$THEME" =~ White$ ]]; then
              +	if [[ "$THEME" =~ white-cursors$ ]]; then
               		BUILD="$SRC"/../dist-white
               	else BUILD="$SRC"/../dist
               	fi
              @@ -100,10 +100,10 @@ function create {
               
               # generate pixmaps from svg source
               SRC=$PWD/src
              -THEME="Vimix Cursors"
              +THEME="Vimix-cursors"
               
               create svg
               
              -THEME="Vimix Cursors - White"
              +THEME="Vimix-white-cursors"
               
               create svg-white
              diff --git a/dist/index.theme b/dist/index.theme
              index 988f265..f996f59 100644
              --- a/dist/index.theme
              +++ b/dist/index.theme
              @@ -1,3 +1,3 @@
               [Icon Theme]
              -Name=Vimix Cursors
              +Name=Vimix-cursors
               
              diff --git a/src/index.theme b/src/index.theme
              index 988f265..f996f59 100644
              --- a/src/index.theme
              +++ b/src/index.theme
              @@ -1,3 +1,3 @@
               [Icon Theme]
              -Name=Vimix Cursors
              +Name=Vimix-cursors
            '')
          ];
        }
      );
    };
  };
  i18n = {
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-skk
      ];
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
      "easyeffects/output/Happy_your_Life_+_Downmix_to_mono.json" = {
        source = ./config/easyeffects/Happy_your_Life_+_Downmix_to_mono.json;
      };
      "libskk" = {
        source = ./config/libskk;
      };
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
            ExecStart = "${pkgs.bitwarden-desktop}/bin/bitwarden";
            Restart = "on-failure";
            RestartSec = 5;
            TimeoutStopSec = 10;
          };
        };
      };
    };
  };
  # keep-sorted end
}
