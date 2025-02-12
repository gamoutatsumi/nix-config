module Keys
  ( modm,
    myAdditionalKeysP,
    myAddtionalKeys,
    myRemoveKeysP,
    newMouse,
  )
where

import qualified Data.Map                      as M
import           Layouts
import           Workspace
import           XMonad
import           XMonad.Actions.CopyWindow
import           XMonad.Actions.CycleWS
import qualified XMonad.Actions.FlexibleResize as Flex
import           XMonad.Actions.FloatKeys
import           XMonad.Config.Desktop         (desktopConfig)
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.ToggleLayouts
import qualified XMonad.StackSet               as W
import           XMonad.Util.EZConfig
import           XMonad.Util.NamedScratchpad

myRemoveKeysP =
  [ "M-S-p",
    "M-S-c",
    "M-S-<Return>"
  ]

modm = mod4Mask

myAdditionalKeysP =
  [ -- Shrink / Expand the focused window
    ("M-,", sendMessage Shrink),
    ("M-.", sendMessage Expand),
    ("M-z", sendMessage MirrorShrink),
    ("M-a", sendMessage MirrorExpand),
    -- Close the focused window
    ("M-c", kill1),
    -- Toggle layout (Fullscreen mode)
    ("M-f", sendMessage ToggleLayout),
    ("M-S-f", withFocused (keysMoveWindow (-borderwidth, -borderwidth))),
    -- Move the focused window
    ("M-C-l", withFocused (keysMoveWindow (moveWD, 0))),
    ("M-C-h", withFocused (keysMoveWindow (-moveWD, 0))),
    ("M-C-k", withFocused (keysMoveWindow (0, -moveWD))),
    ("M-C-j", withFocused (keysMoveWindow (0, moveWD))),
    -- Increase / Decrese the number of master pane
    ("M-S-;", sendMessage $ IncMasterN 1),
    ("M--", sendMessage $ IncMasterN (-1)),
    -- Go to the next / previous workspace
    ("M-<R>", nextWS'),
    ("M-<L>", prevWS'),
    ("M-l", nextWS'),
    ("M-h", prevWS'),
    -- Shift the focused window to the next / previous workspace
    ("M-S-<R>", shiftToNext'),
    ("M-S-<L>", shiftToPrev'),
    ("M-S-l", shiftToNext'),
    ("M-S-h", shiftToPrev'),
    -- CopyWindow
    ("M-v", windows copyToAll),
    ("M-S-v", killAllOtherCopies),
    -- Move the focus down / up
    ("M-<D>", windows W.focusDown),
    ("M-<U>", windows W.focusUp),
    ("M-j", windows W.focusDown),
    ("M-k", windows W.focusUp),
    -- Swap the focused window down / up
    ("M-S-j", windows W.swapDown),
    ("M-S-k", windows W.swapUp),
    -- Shift the focused window to the master window
    ("M-S-m", windows W.shiftMaster),
    -- Move the focus to next screen (multi screen)
    ("M-<Tab>", nextScreen),
    -- Lock screen
    ("M1-C-l", spawn "loginctl lock-sessions"),
    ("<XF86ScreenSaver>", spawn "loginctl lock-sessions"),
    -- Launch terminal with a float window
    ("M-<Esc>", namedScratchpadAction myScratchpads "alacritty"),
    -- Launch terminal
    ("M-<Return>", spawn "XMODIFIERS= alacritty"),
    -- Launch file manager
    ("M-e", spawn "thunar"),
    -- Launch web browser
    ("M-w", namedScratchpadAction myScratchpads "vivaldi"),
    -- Launch BashTOP
    ("M-p", namedScratchpadAction myScratchpads "bashtop"),
    -- Launch Discord
    ("M-d", namedScratchpadAction myScratchpads "discord"),
    ("M-S-s", namedScratchpadAction myScratchpads "slack"),
    ("M-b", namedScratchpadAction myScratchpads "sidekick"),
    ("M-y", namedScratchpadAction myScratchpads "mpsyt"),
    -- Volume setting media keys
    ("<XF86AudioRaiseVolume>", spawn "changeVolume 1%+"),
    ("<XF86AudioLowerVolume>", spawn "changeVolume 1%-"),
    ("<XF86AudioMute>", spawn "changeVolume mute"),
    ("<XF86AudioMicMute>", spawn "toggleMicMute"),
    ("S-<XF86AudioMute>", spawn "toggleMicMute"),
    -- Media player controls
    ("<XF86AudioPlay>", spawn "playerctl play-pause"),
    ("<XF86AudioPause>", spawn "playerctl play-pause"),
    ("<XF86AudioNext>", spawn "playerctl next"),
    ("<XF86AudioPrev>", spawn "playerctl previous"),
    -- Brightness Keys
    ("<XF86MonBrightnessUp>", spawn "changeBrightness 2.5%+"),
    ("<XF86MonBrightnessDown>", spawn "changeBrightness 2.5%-"),
    -- Take a screenshot (selected area)
    ("M-<Print>", spawn "maimFull"),
    ("C-<Print>", spawn "maimSelect"),
    ("M1-<Space>", spawn "rofi -show"),
    ("M-m", spawn "mono.sh")
  ]

-- `additionalKeys`
myAddtionalKeys =
  [ ((m .|. mod4Mask, k), windows $ f i)
    | (i, k) <- zip myWorkspaces [xK_1 ..],
      (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask), (copy, controlMask)]
  ]

-- Mouse setting
myMouse x = [((modm, button3), \w -> focus w >> Flex.mouseResizeWindow w)]

newMouse x = M.union (mouseBindings desktopConfig x) (M.fromList (myMouse x))
