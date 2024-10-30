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
    };
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
