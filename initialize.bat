@echo off

call scripts/precheck.bat
if %errorlevel% neq 0 (
    exit
)

REM convert CRLF to LF
sed -i 's/\r$//' "scripts\post-commit-or-merge.sh"

del /f /q ".git\hooks\post-commit" 2>nul
del /f /q ".git\hooks\post-merge" 2>nul
mklink ".git\hooks\post-commit" "..\..\scripts\post-commit-or-merge.sh"
mklink ".git\hooks\post-merge" "..\..\scripts\post-commit-or-merge.sh"
