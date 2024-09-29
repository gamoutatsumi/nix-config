{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # keep-sorted start
    alacritty
    discord
    firefox
    flat-remix-icon-theme
    materia-theme
    mpd
    pinentry-gtk2
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
    rofi = {
      enable = true;
    };
  };
}
