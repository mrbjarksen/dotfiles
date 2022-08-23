import XMonad
import XMonad.Hooks.EwmhDesktops (ewmhFullscreen, ewmh)
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

statusbar :: StatusBarConfig
statusbar = statusBarProp "xmobar ~/.config/xmobar/xmobarrc" $ pure def
  { ppCurrent = const "\xf111"
  , ppHidden = const "\xf10c"
  , ppHiddenNoWindows = const "\xf10c"
  , ppOrder = take 1
  }

settings = def
  { terminal = "kitty"
  , borderWidth = 1
  }

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh . withEasySB statusbar defToggleStrutsKey $ settings 
