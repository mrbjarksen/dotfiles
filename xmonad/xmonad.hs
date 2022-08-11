import XMonad

main :: IO ()
main = xmonad $ def
    { modMask = mod4Mask
    , terminal = "kitty"
    , borderWidth = 1
    }
