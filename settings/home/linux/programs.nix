{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # keep-sorted start
    agenix-rekey
    alacritty
    discord
    firefox
    flat-remix-icon-theme
    materia-theme
    mpd
    pavucontrol
    rofi
    slack
    vimix-cursor-theme
    vivaldi
    vivaldi-ffmpeg-codecs
    xsel
    # keep-sorted end

    # keep-sorted start
    changeBrightness
    changeVolume
    getPulseVolume
    launchPolybar
    maimFull
    maimSelect
    playerctlStatus
    rofiSystem
    toggleMicMute
    xmonadpropread
    # keep-sorted end
  ];
  programs = {
    # keep-sorted start block=yes
    alacritty = {
      settings = {
        font = {
          size = 11.5;
        };
      };
    };
    rbw = {
      settings = {
        pinentry = pkgs.pinentry-gtk2;
      };
    };
    rofi = {
      enable = true;
    };
    # keep-sorted end
  };
}
