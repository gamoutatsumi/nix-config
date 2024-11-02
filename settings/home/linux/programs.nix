{ pkgs, denoVersion, ... }:
{
  home.packages = with pkgs; [
    # keep-sorted start
    agenix-rekey
    chntpw
    deno.${denoVersion}
    discord
    firefox
    flat-remix-icon-theme
    materia-theme
    mpd
    pavucontrol
    rofi
    slack
    vivaldi
    vivaldi-ffmpeg-codecs
    xsel
    zoom-us
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
        import = [ "~/.config/alacritty/nightfly.toml" ];
        shell = {
          args = [ "--login" ];
          program = "zsh";
        };
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
