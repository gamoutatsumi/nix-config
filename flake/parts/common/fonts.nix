{ upkgs, ... }:
{
  fonts = {
    packages = with upkgs; [
      # keep-sorted start
      ibm-plex
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      plemoljp
      plemoljp-nf
      # keep-sorted end
    ];
  };
}
