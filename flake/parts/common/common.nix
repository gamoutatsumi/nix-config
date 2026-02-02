{
  inputs,
  pkgs,
  username,
  ...
}:
{
  # keep-sorted start block=yes
  nix = {
    # keep-sorted start block=yes
    channel = {
      enable = false;
    };
    monitored = {
      enable = false;
    };
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
    optimise = {
      automatic = true;
    };
    package = pkgs.nixVersions.latest;
    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
      nixpkgs-unstable = {
        flake = inputs.nixpkgs-unstable;
      };
    };
    settings = {
      substituters = [
        "https://nix-community.cachix.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      accept-flake-config = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "nixbld"
        username
      ];
      download-buffer-size = 1024 * 1024 * 1024; # 1 MiB
      keep-outputs = true;
      keep-derivations = true;
      nix-path = [
        "nixpkgs=${inputs.nixpkgs.outPath}"
        "nixpkgs-unstable=${inputs.nixpkgs-unstable.outPath}"
      ];
    };
    # keep-sorted end
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  # keep-sorted end
}
