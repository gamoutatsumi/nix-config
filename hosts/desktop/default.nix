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
    ./disko-config.nix
    ./secrets.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  # keep-sorted start block=yes
  boot = {
    # keep-sorted start block=yes
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [
        "vmd"
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "uas"
        "sd_mod"
        "sr_mod"
      ];
      kernelModules = [ "nvidia-uvm" ];
    };
    kernel = {
      sysctl = {
        "net.ipv6.conf.enp0s20f0u8u4.disable_ipv6" = true;
        "net.ipv6.conf.enp5s0.disable_ipv6" = true;
      };
    };
    kernelModules = [ "kvm-intel" ];
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader = {
      systemd-boot = {
        enable = lib.mkForce false;
      };
    };
    supportedFilesystems = [ "ntfs" ];
    # keep-sorted end
  };
  environment = {
    systemPackages =
      (with pkgs; [
        sbctl
        efitools
        cifs-utils
      ])
      ++ (with upkgs; [
        vim
      ]);
  };
  hardware = {
    graphics = {
      enable = true;
    };
    nvidia = {
      modesetting = {
        enable = true;
      };
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    cpu = {
      intel = {
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
    extraHosts = ''
      43.207.80.85 admin.t.isucon.local
      43.207.80.85 isucon.t.isucon.local
      43.207.80.85 kayac.t.isucon.local
    '';
    hostName = "tat-nixos-desktop";
    networkmanager = {
      enable = false;
    };
    wireless = {
      enable = false;
    };
    useDHCP = lib.mkDefault true;
    interfaces = {
      "enp7s0" = {
        useDHCP = true;
        mtu = 9500;
      };
      "enp0s20f0u8u4" = {
        useDHCP = false;
      };
      "enp5s0" = {
        useDHCP = false;
      };
      "vlan10" = {
        useDHCP = true;
        mtu = 9500;
      };
    };
    vlans = {
      vlan10 = {
        id = 10;
        interface = "enp7s0";
      };
    };
  };
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config = {
      cudaSupport = true;
    };
  };
  services = {
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
      videoDrivers = [ "nvidia" ];
      displayManager = {
        setupCommands = "${lib.getExe pkgs.xorg.xrandr} --output DP-0 --auto --primary --output HDMI-0 --auto --left-of DP-0";
      };
      serverLayoutSection = ''
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
        Option "BlankTime" "0"
        Option "OffTime" "0"
      '';
    };
    ollama = {
      package = pkgs.ollama;
      enable = true;
      acceleration = "cuda";
      loadModels = [ "hf.co/mradermacher/Llama-3.1-8B-EZO-1.1-it-i1-GGUF:Q4_K_M" ];
      environmentVariables = {
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
      };
    };
    openssh = {
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
  system = {
    stateVersion = "24.11";
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
          "dialout"
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
  # keep-sorted end
}
