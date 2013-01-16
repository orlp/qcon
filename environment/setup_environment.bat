@cls
@echo off

REM welcome message
for /f "tokens=1 delims=:" %%j in ('ping %computername% -4 -n 1 ^| findstr Reply') do (
    set localip=%%j
)
echo Windows Command Prompt at %computername% (%localip:~11%)

setlocal ENABLEDELAYEDEXPANSION

set CMDRC_PATH=%~dp0
set CONSOLE_NR=%1

REM don't bother setting up an environment if we're not interactive
echo %CMDCMDLINE% | find /i "/c" >nul
if not errorlevel 1 goto exit

REM always use pushd
doskey dirs=pushd
doskey pd=popd $*
doskey cd=%CMDRC_PATH%pushd_cd_alias $*

REM set up msls
doskey ls=%CMDRC_PATH%msls\ls.exe $*

REM enable ansi colors
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    %CMDRC_PATH%ansicon\x86\ansicon.exe -p
) else (
    %CMDRC_PATH%ansicon\x64\ansicon.exe -p
)

REM run clink (this HAS to be the last command, that's why we already put echo to on)
echo on
@%CMDRC_PATH%clink\clink.bat inject --quiet

:exit