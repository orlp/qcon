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
        WinGet, ActiveId, ID, A
        WinHide quake_style_console
        
        if (ActiveId == ConsoleId)
        {
            WinActivate ahk_id %LastActiveId%
        }
    }
    else
    {
        WinShow quake_style_console
        WinActivate quake_style_console
        WinGet, ConsoleId, ID, quake_style_console
    }
    
    return
}
else
{
    DetectHiddenWindows, off
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
    WinRestore ahk_id %windowUnderCursor%

  MouseGetPos mouseX, mouseY
  WinGetPos windowX, windowY, windowWidth, windowHeight, ahk_id %windowUnderCursor%

  isRightHalf  := mouseX > windowX + windowWidth / 2
  isBottomHalf := mouseY > windowY + windowHeight / 2

  changeX      := isRightHalf  ? 0 : 1
  changeWidth  := isRightHalf  ? 1 : -1
  changeY      := isBottomHalf ? 0 : 1
  changeHeight := isBottomHalf ? 1 : -1

  loop {
    GetKeyState buttonState, RButton, P
    if buttonState = U
      break

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
    
    WinMove, quake_style_console,, (A_ScreenWidth/2)-(Width/2), 0, Width, height

    return
}