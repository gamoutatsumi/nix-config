{ pkgs, lib, ... }:
{
  xsession = {
    enable = false;
    initExtra = ''
      ${lib.getExe pkgs.xorg.xinput} disable 'SynPS/2 Synaptics TouchPad'
      ${lib.getExe' pkgs.lightlocker "light-locker"} &
    '';
    windowManager = {
      xmonad = {
        enable = true;
        config = ./config/xmonad/xmonad.hs;
        enableContribAndExtras = true;
        haskellPackages = pkgs.haskell.packages.ghc98;
        extraPackages =
          haskellPackages: with haskellPackages; [
            containers
            unix
            directory
          ];
        libFiles = {
          "Keys.hs" = ./config/xmonad/lib/Keys.hs;
          "Layouts.hs" = ./config/xmonad/lib/Layouts.hs;
          "Types.hs" = ./config/xmonad/lib/Types.hs;
          "Workspace.hs" = ./config/xmonad/lib/Workspace.hs;
        };
      };
      i3 = {
        enable = false;
        package = pkgs.i3-gaps;
        config = {
          assigns = {
            web = [ { class = "^Vivaldi-stable$"; } ];
            slack = [ { class = "^Slack$"; } ];
            terminal = [ { class = "^Alacritty$"; } ];
          };
          window = {
            titlebar = false;
          };
          bars = [ ];
          keybindings =
            let
              modifier = "Mod4";
              menu = ''"rofi -show"'';
            in
            lib.mkDefault {
              "${modifier}+Return" = ''"exec --no-startup-id runorraise class Alacritty alacritty"'';
              "Mod1+space" = "exec --no-startup-id ${menu}";
              "${modifier}+c" = "kill";
              "${modifier}+Shift+q" = "reload";
              "XF86AudioRaiseVolume" = ''"exec --no-startup-id changeVolume +1%"'';
              "XF86AudioLowerVolume" = ''"exec --no-startup-id changeVolume -1%"'';
              "XF86AudioMute" = ''"exec --no-startup-id changeVolume mute"'';
              "XF86AudioMicMute" = ''"exec --no-startup-id toggleMicMute"'';
              "Shift+XF86AudioMute" = ''"exec --no-startup-id toggleMicMute"'';
              "${modifier}+w" =
                ''"exec --no-startup-id runorraise class Vivaldi-stable vivaldi --force-dark-mode"'';
              "${modifier}+Shift+s" = ''"exec --no-startup-id runorraise class Slack slack"'';
              "${modifier}+Shift+h" = ''"move workspace to output left"'';
              "${modifier}+Shift+l" = ''"move workspace to output right"'';
            };
        };
      };
    };
  };
}
