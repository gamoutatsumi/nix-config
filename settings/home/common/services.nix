{ pkgs, ... }:
{
  services = {
    # Let Home Manager install and manage itself.
    blueman-applet = {
      enable = true;
    };
  };
}
