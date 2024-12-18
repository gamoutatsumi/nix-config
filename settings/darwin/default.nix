{
  # keep-sorted start block=yes
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
    };
    casks = [
      # keep-sorted start
      "chatgpt"
      "karabiner-elements"
      "ollama"
      "raycast"
      "utm"
      "vivaldi"
      # keep-sorted end
    ];
    masApps = {
      Bitwarden = 1352778147;
      "Slack for Desktop" = 803453959;
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
    extraOptions = ''
      build-users-group = nixbld
      bash-prompt-prefix = (nix:$name)\040
      max-jobs = auto
      extra-nix-path = nixpkgs=flake:nixpkgs

      # Generated by https://github.com/DeterminateSystems/nix-installer.
      # See `/nix/nix-installer --version` for the version details.

      extra-trusted-substituters = https://cache.flakehub.com
      extra-trusted-public-keys = cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM= cache.flakehub.com-4:Asi8qIv291s0aYLyH6IOnr5Kf6+OF14WVjkE6t3xMio= cache.flakehub.com-5:zB96CRlL7tiPtzA9/WKyPkp3A2vqxqgdgyTVNGShPDU= cache.flakehub.com-6:W4EGFwAGgBj3he7c5fNh9NkOXw0PUVaxygCVKeuvaqU= cache.flakehub.com-7:mvxJ2DZVHn/kRxlIaxYNMuDG1OvMckZu32um1TadOR8= cache.flakehub.com-8:moO+OVS0mnTjBTcOUh2kYLQEd59ExzyoW1QgQ8XAARQ= cache.flakehub.com-9:wChaSeTI6TeCuV/Sg2513ZIM9i0qJaYsF+lZCXg0J6o= cache.flakehub.com-10:2GqeNlIp6AKp4EF2MVbE1kBOp9iBSyo0UPR9KoR0o1Y=
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
  services = {
    nix-daemon = {
      enable = true;
    };
  };
  # keep-sorted end
}
