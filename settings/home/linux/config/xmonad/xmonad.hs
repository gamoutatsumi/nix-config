import           Keys
import           Layouts
import           Workspace
import           XMonad
import           XMonad.Config.Desktop
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.Rescreen
import           XMonad.Hooks.StatusBar
import           XMonad.Hooks.StatusBar.PP
import           XMonad.Util.Cursor
import           XMonad.Util.EZConfig
import           XMonad.Util.NamedScratchpad
import           XMonad.Util.SpawnOnce

main =
  xmonad $
    addRandrChangeHook myRandrChangeHook $
      ewmhFullscreen . ewmh $
        withSB myPolybarConf $
          docks
            myConfig

mydefLogPP =
  def {ppHiddenNoWindows = stickmyfavorit}

stickmyfavorit "home" = "home"
stickmyfavorit _      = ""

myPolybarConf =
  def
    { sbLogHook =
        xmonadPropLog
          =<< dynamicLogString polybarPPdef
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

myStartupHook = do
  setDefaultCursor xC_left_ptr

myConfig =
  desktopConfig
    { borderWidth = fromIntegral borderwidth,
      terminal = "alacritty",
      focusFollowsMouse = False,
      manageHook = myManageHook,
      layoutHook = myLayoutHook,
      workspaces = myWorkspaces,
      modMask = modm,
      mouseBindings = newMouse,
      startupHook = myStartupHook
    }
    `removeKeysP` myRemoveKeysP
    `additionalKeysP` myAdditionalKeysP
    `additionalKeys` myAddtionalKeys
