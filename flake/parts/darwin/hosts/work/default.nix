{
  username,
  hostname,
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
      config = {
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
