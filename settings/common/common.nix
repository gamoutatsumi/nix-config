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
      "nixpkgs=flake"
      "nixpkgs"
    ];
    optimise = {
      automatic = true;
    };
    package = pkgs.nixVersions.latest;
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
