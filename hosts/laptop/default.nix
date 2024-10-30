# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  # keep-sorted start
  config,
  pkgs,
  upkgs,
  username,
  # keep-sorted end
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./secrets.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tat-nixos-laptop";
  networking.networkmanager.enable = true;

  environment.systemPackages =
    (with pkgs; [
      wget
      git
      curl
      autorandr
      gcc
      sbctl
      efitools
    ])
    ++ (with upkgs; [ vim ]);

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          KernelExperimental = true;
        };
      };
    };
  };

  services = {
    udev = {
      extraRules = ''
        ACTION=="remove",\
         ENV{ID_BUS}=="usb",\
         ENV{ID_MODEL_ID}=="0407",\
         ENV{ID_VENDOR_ID}=="1050",\
         ENV{ID_VENDOR}=="Yubico",\
         RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
      '';
    };
    xremap = {
      withX11 = true;
      config = {
        modmap = [
          {
            name = "Global";
            remap = {
              "CapsLock" = "Ctrl_L";
            };
          }
          {
            name = "SandS";
            remap = {
              "Space" = {
                alone = "Space";
                held = "Shift_L";
              };
            };
          }
          {
            name = "IME";
            remap = {
              "Alt_L" = {
                alone = "Muhenkan";
                held = "Alt_L";
              };
              "Alt_R" = {
                alone = "Henkan";
                held = "Alt_R";
              };
            };
          }
        ];
      };
    };
    blueman = {
      enable = true;
    };
    printing = {
      enable = true;
    };
    pipewire = {
      extraConfig = {
        pipewire = {
          "11-clock-rate" = {
            default.clock.allowed-rates = [
              192000
              176400
              96000
              88200
              48000
              44100
            ];
            default.clock.quantum = 4096;
          };
        };
      };
    };
    displayManager = {
      autoLogin = {
        enable = false;
        user = username;
      };
      defaultSession = "xsession";
    };
    xserver = {
      displayManager = {
        setupCommands = "${pkgs.autorandr}/bin/autorandr -c";
      };
    };
    openssh = {
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
  users = {
    mutableUsers = false;
    users.${username} = {
      isNormalUser = true;
      extraGroups = [
        "users"
        "wheel"
        "video"
        "audio"
        "docker"
        "network"
      ];
      shell = pkgs.zsh;
      hashedPasswordFile = config.age.secrets.${username}.path;
    };
  };
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };
  system.stateVersion = "24.05"; # Did you read the comment?
}
