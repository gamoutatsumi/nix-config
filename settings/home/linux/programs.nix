{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
    firefox
    vivaldi
    vivaldi-ffmpeg-codecs
    materia-theme
    vimix-cursor-theme
    flat-remix-icon-theme
    xclip
    slack
    rofi
    mpd
    pinentry-gtk2

    changeBrightness
    changeVolume
    getPulseVolume
    maimFull
    maimSelect
    playerctlStatus
    toggleMicMute
    launchPolybar
    rofiSystem
    xmonadpropread
  ];
}
