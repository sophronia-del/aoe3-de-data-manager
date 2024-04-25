# Data Manager For AOE3

## Instructions for Use
1. Run initialize.bat
2. Extract Data.bar into directory [Data]
3. Decode XMB files into directory [xml-data-source]
4. Modify XMB files, git hooks will automatically encode xml files and make bar package named [Data_latest.bar] at folder [output] after committed
5. Go to AOE3 game data folder, such as [\<steam\>\steamapps\common\AoE3DE\Game\Data], delete file named Data.bar, then create a symbolic link target to the output bar file
```
mklink Data.bar "<absolute path of this folder>\output\Data_latest.bar"
```
