@echo off

REM if no arguments were passed be have like the normal CD
if [%1]==[] (
    chdir
) else (
    pushd %*
)

@echo on