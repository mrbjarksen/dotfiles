import XMonad

main :: IO ()
main = xmonad $ def
    { terminal = "kitty"
    , borderWidth = 1
    }
