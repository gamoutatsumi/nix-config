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
    # keep-sorted start block=yes
    extraModulePackages = [ ];
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
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "video.use_native_backlight=1" ];
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    supportedFilesystems = [ "ntfs" ];
    # keep-sorted end
  };
  environment = {
    systemPackages =
      (with pkgs; [
        wget
        git
        curl
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
    # keep-sorted start block=yes
    amdgpu = {
      initrd = {
        enable = true;
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
    cpu = {
      amd = {
        updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
    sane = {
      brscan5 = {
        enable = true;
      };
    };
    # keep-sorted end
  };
  networking = {
    hostName = "tat-nixos-laptop";
    resolvconf = {
      enable = true;
    };
    networkmanager = {
      enable = true;
      wifi = {
        backend = "wpa_supplicant";
      };
    };
    useDHCP = lib.mkDefault true;
  };
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
  };
  services = {
    # keep-sorted start block=yes
    autorandr = {
      enable = true;
      hooks = {
        postswitch = {
          feh = "systemctl restart --user feh.service";
          polybar = "systemctl restart --user polybar.service";
        };
      };
      profiles = {
        # keep-sorted start block=yes
        "clamshell-dual-usbc-home" = {
          fingerprint = {
            "DisplayPort-1" =
              "00ffffffffffff0015c3483139f0ac02351f0104a53c2278fab095ab524ea0260f5054a10800a9408180d100b300a9c0810081c00101565e00a0a0a029503020350055502100001a000000ff0034343838383132310a20202020000000fd003b3d1f5919010a202020202020000000fc004556323739350a202020202020011a020312f145100403020123097f07830100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000063";
            "DisplayPort-2" =
              "00ffffffffffff0025e4911601010101081a010380301b782ead45a35752a1270d5054bfef0081808140b300950081c00101010101011a3680a070381f4030203500dd0d1100001a000000fd00374c1f530f000a202020202020000000ff004736504630333033313252370a000000fc004c43442d4d46323235580a20200091";
          };
          config = {
            "DisplayPort-1" = {
              enable = true;
              primary = true;
              mode = "2560x1440";
              position = "1920x0";
              rate = "60";
              crtc = 0;
            };
            "DisplayPort-2" = {
              enable = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "60";
              crtc = 2;
            };
            "eDP" = {
              enable = false;
            };
          };
        };
        "clamshell-usb-hdmi-home" = {
          fingerprint = {
            "DisplayPort-1" =
              "00ffffffffffff0015c3483139f0ac02351f0104a53c2278fab095ab524ea0260f5054a10800a9408180d100b300a9c0810081c00101565e00a0a0a029503020350055502100001a000000ff0034343838383132310a20202020000000fd003b3d1f5919010a202020202020000000fc004556323739350a202020202020011a020312f145100403020123097f07830100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000063";
            "HDMI-A-0" =
              "00ffffffffffff0025e4911601010101081a010380301b782ead45a35752a1270d5054bfef0081808140b300950081c00101010101011a3680a070381f4030203500dd0d1100001a000000fd00374c1f530f000a202020202020000000ff004736504630333033313252370a000000fc004c43442d4d46323235580a20200091";
          };
          config = {
            "DisplayPort-1" = {
              enable = true;
              primary = true;
              mode = "2560x1440";
              position = "1920x0";
              rate = "60";
              crtc = 0;
            };
            "HDMI-A-0" = {
              enable = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "60";
              crtc = 2;
            };
            "eDP" = {
              enable = false;
            };
          };
        };
        "default" = {
          fingerprint = {
            "eDP" =
              "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
          };
          config = {
            "eDP" = {
              enable = true;
              primary = true;
              mode = "1920x1080";
              position = "0x0";
              rate = "60";
              crtc = 0;
            };
          };
        };
        # keep-sorted end
      };
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    blueman = {
      enable = true;
    };
    openssh = {
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
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
    printing = {
      enable = true;
      drivers = with upkgs; [ mfcj7100cdw-cups ];
    };
    tlp = {
      enable = true;
      settings = {
        USB_AUTOSUSPEND = 0;
      };
    };
    xremap = {
      enable = true;
      withX11 = true;
      withNiri = true;
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
                free_hold = true;
              };
            };
          }
          {
            name = "IME";
            remap = {
              "Alt_L" = {
                alone = "Muhenkan";
                held = "Alt_L";
                free_hold = true;
              };
              "Alt_R" = {
                alone = "Henkan";
                held = "Alt_R";
                free_hold = true;
              };
            };
          }
        ];
      };
    };
    xserver = {
      videoDrivers = [ "amdgpu" ];
    };
    # keep-sorted end
  };
  swapDevices = [ { device = "/.swapvol/swapfile"; } ];
  system = {
    stateVersion = "25.11";
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
          "lp"
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
