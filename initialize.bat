del /f /q ".git\hooks\post-commit" 2>nul
del /f /q ".git\hooks\post-merge" 2>nul
mklink ".git\hooks\post-commit" "..\..\scripts\post-commit-or-merge.sh"
mklink ".git\hooks\post-merge" "..\..\scripts\post-commit-or-merge.sh"
