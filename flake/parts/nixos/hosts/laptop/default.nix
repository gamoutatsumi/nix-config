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
let
  mfcj7100cdw-cups = pkgs.callPackage ../../packages/mfcj7100cdw-cups.nix { };
in
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
    kernel = {
      sysctl = {
        "vm.swappiness" = 10;
      };
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
        brightnessctl
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
      drivers = [ mfcj7100cdw-cups ];
    };
    tlp = {
      enable = true;
      settings = {
        USB_AUTOSUSPEND = 0;
      };
    };
    xremap = {
      enable = true;
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
