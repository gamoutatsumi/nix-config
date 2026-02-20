{
  pkgs,
  inputs,
  ...
}:
{
  virtualisation = {
    docker = {
      enable = true;
    };
  };

  networking = {
    hostName = "vfkit-nixos";
    firewall = {
      enable = true;
    };
  };
  microvm = {
    vmHostPackages = inputs.nixpkgs.legacyPackages.aarch64-darwin;
    virtiofsd = {
      package = pkgs.virtiofsd;
    };
    hypervisor = "vfkit";
    vfkit.rosetta = {
      enable = true;
      install = true;
    };
    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
      }
    ];
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

  services = {
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

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
  };

  users = {
    users = {
      root = {
        password = "";
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      vim
      git
      kubectl
      file
      pkgsCross.gnu64.hello
    ];
  };
  system = {
    stateVersion = "25.11";
  };
}
