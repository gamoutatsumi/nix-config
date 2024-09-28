{ pkgs, ... }:
{
  fonts = {
    fontDir = {
      enable = true;
    };
    packages = with pkgs; [
      noto-fonts-cjk
      noto-fonts-emoji
      plemoljp-nf
      plemoljp
      hackgen-nf-font
      ibm-plex
    ];
  };
}
