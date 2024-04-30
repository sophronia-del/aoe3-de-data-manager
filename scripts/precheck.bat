@echo off

where sed > nul 2>&1
if %errorlevel% neq 0 (
    echo sed is not provided, consider add <path to git>/user/bin to command path
    pause
    exit
)

where sh > nul 2>&1
if %errorlevel% neq 0 (
    echo sh is not provided, consider add <path to git>/bin to command path
    pause
    exit
)
