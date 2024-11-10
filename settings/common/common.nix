{ pkgs, username, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;
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
    };
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
