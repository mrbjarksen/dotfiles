import XMonad
import XMonad.Hooks.EwmhDesktops (ewmhFullscreen, ewmh)
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

statusbar :: StatusBarConfig
statusbar = statusBarProp "xmobar ~/.config/xmobar/xmobarrc" (pure def)

settings = def
    { terminal = "kitty"
    , borderWidth = 1
    }

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh . withSB statusbar $ settings 
