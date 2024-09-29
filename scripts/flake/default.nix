{ ... }:
{
  imports = [
    ./overlays.nix
    ./packages
  ];
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-rfc-style;
    };
}
