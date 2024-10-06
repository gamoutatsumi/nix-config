# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  # keep-sorted start
  config,
  lib,
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
  ];
  # keep-sorted start block=yes
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    kernel = {
      sysctl = {
        "net.ipv6.conf.enp0s20f0u8u4.disable_ipv6" = true;
        "net.ipv6.conf.enp5s0.disable_ipv6" = true;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    sbctl
    efitools
  ];
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
  networking = {
    hostName = "tat-nixos-desktop";
    networkmanager.enable = false;
    wireless.enable = false;
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
  nixpkgs.config.cudaSupport = true;
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
        enable = true;
        user = username;
      };
      defaultSession = "xsession";
    };
    xserver = {
      displayManager = {
        setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output DP-0 --auto --primary --output HDMI-0 --auto --left-of DP-0";
      };
    };
    ollama = {
      package = upkgs.ollama;
      enable = true;
      acceleration = "cuda";
    };
    openssh = {
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
  system.stateVersion = "24.05";
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
  # keep-sorted end
}
