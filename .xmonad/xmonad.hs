import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers

main = do
    xmproc <- spawnPipe "~/bin/xmobar_restart"
    xmonad $ defaultConfig
        { terminal = "urxvt"
        , modMask = mod4Mask
        , borderWidth = 1
        , manageHook = manageDocks <+> (isFullscreen --> doFullFloat) <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $ smartBorders $ layoutHook defaultConfig
        --, layoutHook = smartBorders $ layoutHook defaultConfig
        , startupHook = setWMName "LG3D"
        }
        `additionalKeysP`
        [ ("<XF86AudioMute>", spawn "pactl set-sink-mute 0 toggle")
        , ("<XF86AudioLowerVolume>", spawn "amixer set 'Master' 3%-")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set 'Master' 3%+")
        , ("<XF86Sleep>", spawn "sudo pm-suspend")
        , ("M-l", spawn "slock")
        , ("M-f", spawn "firefox")
        , ("M-i", spawn "~/dev/intellij15/bin/idea.sh")
        ]
