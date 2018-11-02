
set DstModsDir=C:\Program Files (x86)\Steam\steamapps\common\Don't Starve Together\mods

CALL :InstallMod local-coordinates, 727774324
CALL :InstallMod camera-tweaks, 362906105, 1161850231
CALL :InstallMod complete-your-map, 352373173, 459280938
CALL :InstallMod quick-emotes, 369420067, 344071294
CALL :InstallMod remove-sand, 1240565842, 1292057450
CALL :InstallMod remove-insanity, 873350047, 1231473531

EXIT /B %ERRORLEVEL%

:InstallMod
set "mod=%~1"
set "id=%~2"
set "extid=%~3"
ATTRIB -r "%DstModsDir%\workshop-%id%"
ATTRIB -r "%DstModsDir%\workshop-%id%\*.*" /S /D
RD /S /Q "%DstModsDir%\workshop-%id%"
ROBOCOPY %mod% "%DstModsDir%\workshop-%id%" /E
ATTRIB +r "%DstModsDir%\workshop-%id%"
ATTRIB +r "%DstModsDir%\workshop-%id%\*.*" /S /D
RD /S /Q "%DstModsDir%\workshop-%extid%"
EXIT /B 0
