{
  modulesPath,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/image/file-options.nix")
    ./lima-init.nix
  ];

  virtualisation = {
    docker = {
      enable = true;
    };
  };

  image = {
    baseName = "lima-k8s";
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "@wheel" ];
    };
  };

  # Read Lima configuration at boot time and run the Lima guest agent
  services = {
    lima = {
      enable = true;
    };
    openssh = {
      enable = true;
    };
    k3s = {
      enable = true;
    };
  };

  programs = {
    zsh = {
      enable = true;
      syntaxHighlighting = {
        enable = true;
      };
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;
  };

  security = {
    sudo = {
      wheelNeedsPassword = false;
    };
  };

  # system mounts
  boot = {
    kernelParams = [ "console=tty0" ];
    loader = {
      grub = {
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };
  fileSystems = {
    "/boot" = {
      device = lib.mkForce "/dev/vda1"; # /dev/disk/by-label/ESP
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
        "discard"
      ];
    };
  };

  # misc
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # pkgs
  environment = {
    systemPackages = with pkgs; [
      vim
      git
      kubectl
    ];
  };
  system = {
    stateVersion = "25.11";
  };
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 6443 ];
    };
  };
}
