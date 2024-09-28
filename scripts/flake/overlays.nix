{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
  perSystem =
    {
      inputs',
      system,
      config,
      lib,
      pkgs,
      ...
    }:
    {
      overlayAttrs = {
        inherit (config.packages)
          runorraise
          changeBrightness
          toggleMicMute
          maimFull
          maimSelect
          playerctlStatus
          getPulseVolume
          changeVolume
          launchPolybar
          rofiSystem
          xmonadpropread
          ;
      };
    };
}
