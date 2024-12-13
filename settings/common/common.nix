{
  inputs,
  pkgs,
  username,
  ...
}:
{
  nix = {
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
    monitored = {
      enable = false;
    };
    optimise = {
      automatic = true;
    };
    settings = {
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
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
