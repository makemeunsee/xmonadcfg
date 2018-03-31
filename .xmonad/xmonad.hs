import Data.IORef
import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.Spacing
import qualified Data.Map as M
import qualified XMonad.StackSet as W

randomFeh = "feh --randomize --bg-max "
randomWallpaper = randomFeh ++ "~/Pictures/wallpapers/"
randomInfographics = randomFeh ++ "~/Pictures/infographics/"

main = do
    kbLayoutIdRef <- newIORef 0
    _ <- spawnPipe "~/bin/xmobar_restart"
    _ <- spawnPipe randomWallpaper
    xmonad $ def
        { terminal = "urxvt"
        , modMask = mod4Mask
        , borderWidth = 2
        , normalBorderColor = "#224488"
        , focusedBorderColor = "#ff2200"
        , layoutHook = smartSpacing 8 $ mkToggle (single NBFULL) $ avoidStruts  $ smartBorders $ layoutHook def
        , startupHook = setWMName "LG3D"
        , handleEventHook = mconcat [ fullscreenEventHook, docksEventHook ]
        }
        `additionalKeysP`
        [ ("<XF86AudioMute>", spawn "amixer sset Master toggle")
        , ("<XF86AudioLowerVolume>", spawn "amixer set 'Master' 3%-")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set 'Master' 3%+")
        , ("<XF86Sleep>", spawn "sudo pm-suspend")
        --, ("M-x", spawn "xrdb ~/.Xresources")
        , ("M-S-l", spawn "slock")
        , ("M-f", sendMessage $ Toggle NBFULL)
        , ("M-S-f", spawn "firefox")
        , ("M-S-s", cycleKbLayout kbLayoutIdRef)
        , ("M-S-i", spawn randomInfographics)
        , ("M-S-w", spawn randomWallpaper)
        ]

layouts 0 = "us -option compose:caps"
layouts 1 = "ch -variant fr"
layouts _ = layouts 0

cycleKbLayout :: IORef Integer -> X ()
cycleKbLayout ref = do
  val <- io $ readIORef ref
  let newVal = mod (val + 1) 2
  io $ writeIORef ref newVal
  spawn $ "setxkbmap -layout " ++ (layouts newVal)
