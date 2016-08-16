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
    xmproc <- spawnPipe "~/bin/xmobar_restart"
    xmonad $ defaultConfig
        { terminal = "urxvt"
        , modMask = mod4Mask
        , borderWidth = 1
        , layoutHook = mkToggle (single NBFULL) $ avoidStruts  $ smartBorders $ layoutHook defaultConfig
        , startupHook = setWMName "LG3D"
        , handleEventHook = mconcat [ fullscreenEventHook, docksEventHook ]
        }
        `additionalKeysP`
        [ ("<XF86AudioMute>", spawn "pactl set-sink-mute 0 toggle")
        , ("<XF86AudioLowerVolume>", spawn "amixer set 'Master' 3%-")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set 'Master' 3%+")
        , ("<XF86Sleep>", spawn "sudo pm-suspend")
        --, ("M-x", spawn "xrdb ~/.Xresources")
        , ("M-l", spawn "slock")
        , ("M-f", sendMessage $ Toggle NBFULL)
        , ("M-S-f", spawn "firefox")
        -- , ("M-S-i", spawn "~/dev/intellij15/bin/idea.sh")
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
