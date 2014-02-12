#NoTrayIcon
#SingleInstance force
#NoEnv
SetBatchLines -1
ListLines Off
SetWinDelay 0
CoordMode Mouse


loop 
{    
    ; get the current window's handle
    WinGet, ActiveId, ID, A
    
    if (ActiveId != ConsoleId)
    {
        WinWaitNotActive, ahk_id %ActiveId%
        LastActiveId := ActiveId
    }
}

#`::
DetectHiddenWindows, on
IfWinExist quake_style_console
{
    DetectHiddenWindows, off
    IfWinExist quake_style_console
    {
        if (ActiveId == ConsoleId)
        {
            WinGet, ActiveId, ID, A
            WinHide quake_style_console
            WinActivate ahk_id %LastActiveId%
        } else {
            WinActivate quake_style_console
        }
    } else {
        WinShow quake_style_console
        WinActivate quake_style_console
        WinGet, ConsoleId, ID, quake_style_console
    }
    
    return
} else {
    DetectHiddenWindows, off
    RefreshEnvironment()
    Run, console2\console.exe -t cmd1 -t cmd2 -t cmd3 -t cmd4 -t cmd5 -t cmd6 -t cmd7 -t cmd8 -t cmd9
    
    WinWait quake_style_console
    WinGet, ConsoleId, ID
    Send ^1
    
    return
}

; source https://github.com/jesseschalken/easy-move-resize/blob/master/easy-move-resize.ahk
#IfWinActive quake_style_console
Alt & RButton::
{
    MouseGetPos, , , windowUnderCursor

    WinSet Top, , ahk_id %windowUnderCursor%
    WinGet isMaximised, MinMax, ahk_id %windowUnderCursor%
    if isMaximised
    {
        WinRestore ahk_id %windowUnderCursor%
    }

    MouseGetPos mouseX, mouseY
    WinGetPos windowX, windowY, windowWidth, windowHeight, ahk_id %windowUnderCursor%

    isRightHalf  := mouseX > windowX + windowWidth / 2
    isBottomHalf := mouseY > windowY + windowHeight / 2

    changeX      := isRightHalf  ? 0 : 1
    changeWidth  := isRightHalf  ? 1 : -1
    changeY      := isBottomHalf ? 0 : 1
    changeHeight := isBottomHalf ? 1 : -1

    loop
    {
        GetKeyState buttonState, RButton, P
        if buttonState = U
        {
            break
        }

        MouseGetPos newMouseX, newMouseY
        WinGetPos windowX, windowY, windowWidth, windowHeight, ahk_id %windowUnderCursor%

        WinMove ahk_id %windowUnderCursor%,
            , windowX      + changeX      * (newMouseX - mouseX)
            , windowY      + changeY      * (newMouseY - mouseY)
            , windowWidth  + changeWidth  * (newMouseX - mouseX)
            , windowHeight + changeHeight * (newMouseY - mouseY)

        mouseX := newMouseX
        mouseY := newMouseY
    }

    return
}

#IfWinActive quake_style_console
F11::
{
    WinGetPos,,, Width, height
    WinMove, quake_style_console, , (A_ScreenWidth/2)-(Width/2), 0, Width, height

    return
}

; http://www.autohotkey.com/board/topic/63858-function-to-refresh-environment-variables/#entry402575
RefreshEnvironment()
{
    ; load the system-wide environment variables first in case there are user-level
    ; variables with the same name (since they override the system definitions).
    ; treat PATH and PATHEXT special - we must contactenate the user and system values.
    sysPATH := ""
    sysPATHEXT := ""
    Loop, HKLM, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, 0, 0
    {
        RegRead, vEnvValue
        If (A_LoopRegType == "REG_EXPAND_SZ") {
            If (!ExpandEnvironmentStrings(vEnvValue)) {
                Return False
            }
        }
        EnvSet, %A_LoopRegName%, %vEnvValue%
        if (A_LoopRegName = "PATH") {
            sysPATH := vEnvValue
            }
        else if (A_LoopRegName = "PATHEXT") {
            sysPATHEXT := vEnvValue
            }
    }

    ; now load the user level environment variables
    Loop, HKCU, Environment, 0, 0
    {
        RegRead, vEnvValue
        If (A_LoopRegType == "REG_EXPAND_SZ") {
            If (!ExpandEnvironmentStrings(vEnvValue)) {
                Return False
            }
        }
        envVal := vEnvValue
        if (A_LoopRegName = "PATH") {
            envVal := envVal . ";" . sysPATH
          }
        else if (A_LoopRegName = "PATHEXT") {
            envVal := envVal . ";" . sysPATHEXT
          }
        EnvSet, %A_LoopRegName%, %envVal%
    }

    ; return success.
    Return True
}

; http://www.autohotkey.com/board/topic/63858-function-to-refresh-environment-variables/#entry402575
ExpandEnvironmentStrings(ByRef vInputString)
{
    ; get the required size for the expanded string
    vSizeNeeded := DllCall("ExpandEnvironmentStrings", "Str", vInputString, "Int", 0, "Int", 0)
    If (vSizeNeeded == "" || vSizeNeeded <= 0)
        return False ; unable to get the size for the expanded string for some reason

    vByteSize := vSizeNeeded + 1
    If (A_PtrSize == 8) { ; Only 64-Bit builds of AHK_L will return 8, all others will be 4 or blank
        vByteSize *= 2 ; need to expand to wide character sizes
    }
    VarSetCapacity(vTempValue, vByteSize, 0)

    ; attempt to expand the environment string
    If (!DllCall("ExpandEnvironmentStrings", "Str", vInputString, "Str", vTempValue, "Int", vSizeNeeded))
        return False ; unable to expand the environment string
    vInputString := vTempValue

    ; return success
    Return True
}