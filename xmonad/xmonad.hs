{-# LANGUAGE FlexibleContexts #-}

import XMonad
import qualified XMonad.StackSet as W

import XMonad.Hooks.EwmhDesktops (ewmhFullscreen, ewmh)

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Hooks.InsertPosition
import XMonad.Hooks.Place

import XMonad.Layout.TwoPanePersistent
import XMonad.Layout.Spacing (spacingWithEdge)
import XMonad.Layout.LayoutHints (layoutHintsWithPlacement)
import XMonad.Layout.Renamed (renamed, Rename(Replace))

import qualified XMonad.Actions.ConstrainedResize as CR
import XMonad.Actions.MouseGestures
import XMonad.Actions.CycleWS
import XMonad.Actions.SwapWorkspaces (swapWithCurrent)
import XMonad.Actions.TiledWindowDragging
import XMonad.Layout.DraggingVisualizer

import qualified Data.Map as M
import Control.Monad (join)
import Data.List (find)
import Data.Bool (bool)
import System.Exit (exitSuccess)
import XMonad.Actions.Submap (submap)

---- Statusbar ----

statusbar :: StatusBarConfig
statusbar = statusBarProp "xmobar" $ pure def
  { ppCurrent = const "\xf111"
  , ppHidden = const "\xf10c"
  , ppHiddenNoWindows = const "\xf10c"
  , ppOrder = take 1
  }

---- Spawn based on `CWD` X property ----

getCWD :: Maybe (W.Stack Window) -> X (Maybe String)
getCWD Nothing = return Nothing
getCWD (Just stack) = asks display >>= fmap getFirst . getProp "CWD" windows
  where getFirst = join . find (/=Nothing)
        getProp p ws d = mapM (flip (getStringProperty d) p) ws
        windows = W.focus stack : reverse (W.up stack) ++ W.down stack

spawnCWD :: String -> (String -> String) -> X ()
spawnCWD cmd cwdToArgs = args >>= spawn . (cmd++)
  where cwd = withWindowSet $ getCWD . W.stack . W.workspace . W.current
        args = maybe "" ((' ':) . cwdToArgs) <$> cwd

quoted :: String -> String
quoted = ('"':) . (<>['"'])

---- Placement of floating windows ----

floatPlacement :: Placement
floatPlacement = withGaps (100, 100, 100, 100) $ smart (0.5, 0.5)

floatWin :: Window -> W.StackSet i l Window s sd -> W.StackSet i l Window s sd
floatWin = flip W.float (W.RationalRect 0.25 0.25 0.5 0.5)

toggleFloat :: Window -> X ()
toggleFloat win = gets (W.floating . windowset) >>=
  windows . ($win) . bool floatWin W.sink . M.member win

---- Swap focused window with an arbitrary window in stack (while retaining focus) ----

swapFocused :: Window -> W.Stack Window -> W.Stack Window
swapFocused win s@(W.Stack f up down) =
  if f == win then s else
  case (break (==win) up, break (==win) down) of
    ((xs, w:up'), _)   -> W.Stack f up' (reverse xs ++ w:down)
    (_, (xs, w:down')) -> W.Stack f (reverse xs ++ w:up) down'
    _ -> s

---- Bindings ----

userKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
userKeys conf = M.fromList $
  [ ((mod,  xK_Return   ), spawn    terminal       )
  , ((modS, xK_Return   ), spawnCWD terminal quoted)
  , ((mod,  xK_BackSpace), kill                    )

  , ((mod,  xK_j        ), windows W.focusDown     )
  , ((mod,  xK_k        ), windows W.focusUp       )
  , ((mod,  xK_m        ), windows W.focusMaster   )
  , ((modS, xK_j        ), windows W.swapDown      )
  , ((modS, xK_k        ), windows W.swapUp        )
  , ((modS, xK_m        ), windows W.swapMaster    )

  , ((mod,  xK_h        ), sendMessage Shrink      )
  , ((mod,  xK_l        ), sendMessage Expand      )

  , ((modC, xK_Right    ), nextWS                  )
  , ((modC, xK_Left     ), prevWS                  )
  , ((modC, xK_p        ), toggleWS                )

  , ((mod,  xK_Tab      ), withFocused toggleFloat )

  , ((mod,  xK_q        ), io exitSuccess          )
  , ((mod,  xK_r        ), spawn reloadCmd         )

  , ((mod, xK_space), submap . M.fromList $ [0, mod] >>= \mask ->
      [ ((mask, xK_t), sendMessage $ JumpToLayout "Tall")
      , ((mask, xK_w), sendMessage $ JumpToLayout "Wide")
      , ((mask, xK_f), sendMessage $ JumpToLayout "Full")
      , ((mask, xK_p), sendMessage $ JumpToLayout "Pane")
      ])
  ]
  ++
  [ ((mask, key), windows $ func ws)
    | (key,  ws  ) <- zip [xK_1 .. xK_9] workspaces
    , (mask, func) <- [(mod, W.view), (modS, W.shift), (modC, swapWithCurrent)]
  ]
  where mod  = modMask conf
        modS = mod .|. shiftMask
        modC = mod .|. controlMask
        terminal = XMonad.terminal conf
        workspaces = XMonad.workspaces conf
        reloadCmd = concat
          [ "if type xmonad;"
          , "then xmonad --recompile && xmonad --restart;"
          , "else xmessage cmonad not in \\$PATH: \"$PATH\";"
          , "fi"
          ]

userMouseBindings :: XConfig Layout -> M.Map (ButtonMask, Button) (Window -> X())
userMouseBindings conf = M.fromList
  [ ((mod,  button1), \w -> focus w >> mouseMoveWindow   w)
  , ((modS, button1), \w -> focus w >> mouseResizeWindow w)
  , ((modC, button1), \w -> focus w >> mouseResizeWinAR  w)
  , ((mod,  button2), windows . W.modify' . swapFocused   )
  , ((modS, button2), dragWindow                          )
  , ((0,    button3), mouseGesture threeFingerGestures    )
  ]
  where mod  = modMask conf
        modS = mod .|. shiftMask
        modC = mod .|. controlMask
        mouseResizeWinAR = flip CR.mouseResizeWindow True
        threeFingerGestures = M.fromList
          [ ([R], const nextWS)
          , ([L], const prevWS)
          ]

---- Hooks ----

userManageHook :: ManageHook
userManageHook = composeAll
  [ insertPosition End Newer
  , placeHook floatPlacement
  , manageHook def
  ]

userLayoutHook = draggingVisualizer . addGaps . respectHints
   $  rename "Tall" tiled
  ||| rename "Wide" (Mirror tiled)
  ||| rename "Full" Full
  ||| rename "Pane" (TwoPanePersistent Nothing delta ratio)
  where tiled = Tall nmaster delta ratio
        nmaster = 1
        ratio   = 1/2
        delta   = 3/100
        rename name = renamed [Replace name]
        addGaps = spacingWithEdge 10
        respectHints = layoutHintsWithPlacement (0.5, 0.5)

userHandleEventHook = handleEventHook def
userLogHook = logHook def
userStartupHook = startupHook def

---- Configuration ----

userConfig = XConfig
  { terminal = "kitty"

  , borderWidth        = 4
  , normalBorderColor  = "#2a2a2a"
  , focusedBorderColor = "#cccccc"

  , workspaces = map show [1..9]

  , focusFollowsMouse = False
  , clickJustFocuses  = False
  , mouseBindings     = userMouseBindings

  , modMask = mod1Mask
  , keys    = userKeys

  , manageHook      = userManageHook
  , layoutHook      = userLayoutHook
  , handleEventHook = userHandleEventHook
  , logHook         = userLogHook
  , startupHook     = userStartupHook 

  , clientMask = clientMask def
  , rootMask   = rootMask def

  , handleExtraArgs = handleExtraArgs def

  , extensibleConf = M.empty
  }

main :: IO ()
main = xmonad . handleEwmh . addStatusBar $ userConfig
  where handleEwmh = ewmhFullscreen . ewmh
        addStatusBar conf = docks . withSB statusbar $
          conf { layoutHook = avoidStruts $ layoutHook conf }
