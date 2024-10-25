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
    ./secrets.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tat-nixos-laptop";
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    autorandr
    gcc
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