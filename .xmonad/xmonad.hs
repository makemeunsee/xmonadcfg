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

main = do
    kbLayoutIdRef <- newIORef 0
    _ <- spawnPipe "~/bin/xmobar_restart"
    _ <- spawnPipe "~/bin/wallpapers"
    xmonad $ defaultConfig
        { terminal = "urxvt"
        , modMask = mod4Mask
        , borderWidth = 1
        , normalBorderColor = "#224488"
        , focusedBorderColor = "#bb3322"
        , layoutHook = mkToggle (single NBFULL) $ avoidStruts  $ smartBorders $ layoutHook defaultConfig
        , startupHook = setWMName "LG3D"
        , handleEventHook = mconcat [ fullscreenEventHook, docksEventHook ]
        }
        `additionalKeysP`
        [ ("<XF86AudioMute>", spawn "amixer sset Master toggle")
        , ("<XF86AudioLowerVolume>", spawn "amixer set 'Master' 3%-")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set 'Master' 3%+")
        , ("<XF86Sleep>", spawn "sudo pm-suspend")
        , ("M-S-x", spawn "xrdb ~/.Xresources")
        , ("M-S-l", spawn "slock")
        , ("M-f", sendMessage $ Toggle NBFULL)
        , ("M-S-f", spawn "firefox")
        , ("M-S-s", cycleKbLayout kbLayoutIdRef)
        ]

layouts 0 = "us"
layouts 1 = "ch -variant fr"
layouts _ = layouts 0

cycleKbLayout :: IORef Integer -> X ()
cycleKbLayout ref = do
  val <- io $ readIORef ref
  let newVal = mod (val + 1) 2
  io $ writeIORef ref newVal
  spawn $ "setxkbmap -layout " ++ (layouts newVal)
