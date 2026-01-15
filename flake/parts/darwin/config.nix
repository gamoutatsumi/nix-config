{
  # keep-sorted start block=yes
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    casks = [
      # keep-sorted start
      "chatgpt"
      "discord"
      "karabiner-elements"
      "macskk"
      "obsidian"
      "raycast"
      "vivaldi"
      # keep-sorted end
    ];
    masApps = {
      Bitwarden = 1352778147;
      "Slack for Desktop" = 803453959;
      Velja = 1607635845;
    };
  };
  launchd = {
    daemons = {
      "limits.maxfile" = {
        serviceConfig = {
          Label = "limits.maxfile";
          ProgramArguments = [
            "/bin/launchctl"
            "limit"
            "maxfiles"
            "524288"
            "524288"
          ];
          RunAtLoad = true;
          ServiceIPC = false;
        };
      };
      "limits.maxproc" = {
        serviceConfig = {
          Label = "limits.maxproc";
          ProgramArguments = [
            "/bin/launchctl"
            "limit"
            "maxproc"
            "2048"
            "2048"
          ];
          RunAtLoad = true;
          ServiceIPC = false;
        };
      };
    };
  };
  nix = {
    settings = {
      sandbox = true;
      max-jobs = "auto";
    };
    extraOptions = ''
      build-users-group = nixbld
      bash-prompt-prefix = (nix:$name)\040
      extra-nix-path = nixpkgs=flake:nixpkgs
    '';
  };
  programs = {
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  };
  security = {
    pam = {
      services = {
        sudo_local = {
          enable = true;
          touchIdAuth = true;
          reattach = true;
        };
      };
    };
  };
  # keep-sorted end
}
