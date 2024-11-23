# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  # keep-sorted start
  config,
  lib,
  modulesPath,
  pkgs,
  upkgs,
  username,
  # keep-sorted end
  ...
}:

{
  imports = [
    ./secrets.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  # keep-sorted start block=yes
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usbhid"
        "uas"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernelParams = [ "video.use_native_backlight=1" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };
  environment = {
    systemPackages =
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
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/3a5d14bc-9846-40cd-b069-7c731184e764";
      fsType = "btrfs";
      options = [
        "subvol=rootfs"
        "compress=zstd"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/3a5d14bc-9846-40cd-b069-7c731184e764";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/3a5d14bc-9846-40cd-b069-7c731184e764";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd"
        "noatime"
      ];
    };
    "/.swapvol" = {
      device = "/dev/disk/by-uuid/3a5d14bc-9846-40cd-b069-7c731184e764";
      fsType = "btrfs";
      options = [ "subvol=swap" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/FEA6-D132";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
  hardware = {
    cpu = {
      amd = {
        updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
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
  networking = {
    hostName = "tat-nixos-laptop";
    networkmanager = {
      enable = true;
    };
    useDHCP = lib.mkDefault true;
  };
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
  };
  services = {
    tlp = {
      enable = true;
      settings = {
        USB_AUTOSUSPEND = 0;
      };
    };
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
            default = {
              clock = {
                allowed-rates = [
                  192000
                  176400
                  96000
                  88200
                  48000
                  44100
                ];
                quantum = 4096;
              };
            };
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
  swapDevices = [ { device = "/.swapvol/swapfile"; } ];
  system = {
    stateVersion = "24.05"; # Did you read the comment?
  };
  users = {
    mutableUsers = false;
    users = {
      ${username} = {
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
  };
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };
  #keep-sorted end
}
