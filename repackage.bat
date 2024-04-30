@echo off

call scripts/precheck.bat
if %errorlevel% neq 0 (
    exit
)

sh .git/hooks/post-commit
