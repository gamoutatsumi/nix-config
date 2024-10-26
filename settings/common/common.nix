{ pkgs, ... }:
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
    };
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
