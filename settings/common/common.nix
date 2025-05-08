{
  inputs,
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
      enable = true;
    };
    nixPath = [
      "nixpkgs=flake"
      "nixpkgs"
    ];
    optimise = {
      automatic = true;
    };
    registry = {
      nixpkgs = {
        from = {
          type = "indirect";
          id = "nixpkgs";
        };
        to = {
          type = "path";
          path = "${inputs.nixpkgs.outPath}";
        };
      };
    };
    settings = {
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
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
      download-buffer-size = 128 * 1024 * 1024;
      keep-outputs = true;
      keep-derivations = true;
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
