{
  username,
  hostname,
  pkgs,
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
  environment = {
    etc = {
      "pam.d/sudo_local" = {
        text = ''
          auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
          auth       sufficient     pam_tid.so
        '';
      };
    };
  };
}
