{ inputs, ... }:
{
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
      packages = {
        runorraise = import ./runorraise.nix { inherit lib pkgs; };
        changeBrightness = import ./changeBrightness.nix { inherit lib pkgs; };
        toggleMicMute = import ./toggleMicMute.nix { inherit lib pkgs; };
        maimFull = import ./maimFull.nix { inherit lib pkgs; };
        maimSelect = import ./maimSelect.nix { inherit lib pkgs; };
        playerctlStatus = import ./playerctlStatus.nix { inherit lib pkgs; };
        getPulseVolume = import ./getPulseVolume.nix { inherit lib pkgs; };
        changeVolume = import ./changeVolume.nix { inherit lib pkgs; };
        launchPolybar = import ./launchPolybar.nix { inherit lib pkgs; };
        rofiSystem = import ./rofiSystem.nix { inherit lib pkgs; };
        xmonadpropread = import ./xmonadpropread { inherit pkgs; };
      };
    };
}
