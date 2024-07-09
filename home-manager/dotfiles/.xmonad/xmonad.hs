import System.IO
import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Ungrab

-- actions
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.Submap
import XMonad.Actions.WindowGo

-- utils
import XMonad.Util.Run

-- layout

import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing

main :: IO ()
main = do
    xmonad $
        def
            { terminal = myTerminal
            , modMask = myModMask
            , borderWidth = 3
            -- , mouseBindings = myMouseBindings
            -- , startupHook = myStartupHook
            -- , layoutHook = myLayoutHook
            -- , manageHook = myManageHook
            -- , handleEventHook = myHandleEventHook
            -- , logHook = myLogHook
            }
            `additionalKeysP` myKeys

myTerminal = "wezterm"
myModMask = mod4Mask -- Win key or Super_L
myKeys =
    [ ("M-q", kill)
    , ("M-<Retern>", spawn $ "wezterm")
    , ("M-j", windows W.focusDow)
    , ("M-k", windows W.focusUp)
    , ("M-o", spawn $ "firefox")
    , ("M-d", spawn $ "rofi -show combi")
    , ("Shift_L-<Print>", spawn $ "maim -s | xclip -selection clipboard -t image/png")
    ]
