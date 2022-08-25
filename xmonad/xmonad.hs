import XMonad
import XMonad.Hooks.EwmhDesktops (ewmhFullscreen, ewmh)
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Cursor (setDefaultCursor)
-- import Graphics.X11 (xC_left_ptr)

statusbar :: StatusBarConfig
statusbar = statusBarProp "xmobar" $ pure def
  { ppCurrent = const "\xf111"
  , ppHidden = const "\xf10c"
  , ppHiddenNoWindows = const "\xf10c"
  , ppOrder = take 1
  }

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh . withEasySB statusbar defToggleStrutsKey $ def
  { terminal = "kitty"
  , borderWidth = 1
  -- , startupHook = setDefaultCursor xC_left_ptr
  }

