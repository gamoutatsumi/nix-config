{pkgs,...}:{
  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;
  i18n.defaultLocale = "ja_JP.UTF-8";
  time.timeZone = "Asia/Tokyo";
  time.hardwareClockInLocalTime = true;
  security.rtkit.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.pipewire = {
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

  services.openssh = {
  enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      };
  };
  programs.dconf.enable = true;

  # Enable the X11 windowing system.
  services = {
    pcscd = {
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
    libinput.enable = true;
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
  };

}
