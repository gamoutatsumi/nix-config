{ username, hostname, ... }:
{
  # environment.systemPackages = with pkgs; [
  #   vim
  #   git
  # ];

  system = {
    stateVersion = 4;
    defaults = {
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

  users = {
    users = {
      ${username} = {
        home = "/Users/${username}";
      };
    };
  };
  security = {
    pam = {
      enableSudoTouchIdAuth = true;
    };
  };
}
