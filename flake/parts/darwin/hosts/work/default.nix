{
  username,
  hostname,
  lib,
  ...
}:
{
  # environment.systemPackages = with pkgs; [
  #   vim
  #   git
  # ];
  system = {
    stateVersion = 5;
    primaryUser = username;
    defaults = {
      WindowManager = {
        GloballyEnabled = false;
      };
      NSGlobalDomain = {
        _HIHideMenuBar = false;
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = true;
        FXEnableExtensionChangeWarning = false;
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      dock = {
        autohide = true;
        show-recents = true;
        magnification = false;
        orientation = "bottom";
      };
    };
  };

  networking = {
    hostName = hostname;
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
  };
  nix = {
    linux-builder = {
      enable = true;
      ephemeral = true;
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      config = {
        boot = {
          binfmt = {
            emulatedSystems = [ "x86_64-linux" ];
          };
        };
        virtualisation = {
          cores = 6;
          memorySize = lib.mkForce (16 * 1024);
          diskSize = lib.mkForce (50 * 1024);
        };
        nix = {
          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
            ];
          };
        };
      };
    };
  };
  users = {
    users = {
      ${username} = {
        home = "/Users/${username}";
      };
    };
  };
}
