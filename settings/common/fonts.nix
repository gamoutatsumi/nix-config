{ pkgs, ... }:
{
  fonts = {
    fontDir = {
      enable = true;
    };
    packages = with pkgs; [
      # keep-sorted start
      hackgen-nf-font
      ibm-plex
      noto-fonts-cjk
      noto-fonts-emoji
      plemoljp
      plemoljp-nf
      # keep-sorted end
    ];
  };
}
