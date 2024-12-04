{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      # keep-sorted start
      hackgen-font
      hackgen-nf-font
      ibm-plex
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      plemoljp
      plemoljp-nf
      # keep-sorted end
    ];
  };
}
