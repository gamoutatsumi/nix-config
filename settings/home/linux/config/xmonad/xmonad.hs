import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.SpawnOnce

import Keys
import Layouts
import Workspace

main =
  xmonad $
    ewmhFullscreen . ewmh $
      withSB (myPolybarConf "$HOME/.config/polybar/launch.sh") $
        docks
          myConfig

mydefLogPP =
  def {ppHiddenNoWindows = stickmyfavorit}

stickmyfavorit "home" = "home"
stickmyfavorit _ = ""

myPolybarConf cmd =
  def
    { sbLogHook =
        xmonadPropLog
          =<< dynamicLogString polybarPPdef,
      sbStartupHook = spawn cmd,
      sbCleanupHook = spawn "killall polybar"
    }

polybarPPdef =
  mydefLogPP
    { ppTitle = const "",
      ppVisible = const "◉",
      ppCurrent = const "●",
      ppHidden = const "◉",
      ppVisibleNoWindows = Just (const "○"),
      ppHiddenNoWindows = const "○",
      ppLayout = const ""
    }

polybarColor :: String -> String -> String -> String
polybarColor fore_color back_color =
  wrap ("%{B" <> back_color <> "} ") " %{B-}"
    . wrap ("%{F" <> fore_color <> "} ") " %{F-}"

-- StartupHook setting
myStartupHook = do
  spawnOnce "nm-applet"
  spawnOnce "blueman-applet"
  spawnOnce "fcitx5"
  spawn "$HOME/.fehbg"
  spawnOnce "picom"
  spawnOnce "light-locker --no-late-locking --lock-on-suspend"
  spawnOnce "kdeconnect-indicator"

myConfig =
  desktopConfig
    { borderWidth = fromIntegral borderwidth,
      terminal = "alacritty",
      focusFollowsMouse = False,
      startupHook = myStartupHook,
      manageHook = myManageHook,
      layoutHook = myLayoutHook,
      workspaces = myWorkspaces,
      modMask = modm,
      mouseBindings = newMouse
    }
    `removeKeysP` myRemoveKeysP
    `additionalKeysP` myAdditionalKeysP
    `additionalKeys` myAddtionalKeys
