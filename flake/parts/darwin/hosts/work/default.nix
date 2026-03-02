{
  username,
  hostname,
  inputs,
  ...
}:
{
  # environment.systemPackages = with pkgs; [
  #   vim
  #   git
  # ];
  services = {
    darwin-vz = {
      enable = true;
      cores = 6;
      memory = 8192;
      diskSize = "50G";
      rosetta = true;
      idleTimeout = 180;
      kernelPath = "${inputs.darwin-vz-nix.packages.aarch64-linux.guest-kernel}/Image";
      initrdPath = "${inputs.darwin-vz-nix.packages.aarch64-linux.guest-initrd}/initrd";
      systemPath = "${inputs.darwin-vz-nix.packages.aarch64-linux.guest-system}";
    };
  };
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
  users = {
    users = {
      ${username} = {
        home = "/Users/${username}";
      };
    };
  };
}
