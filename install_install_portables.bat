@echo off
setlocal

:: Get the current directory where the AHK script is located
set "currentDir=%~dp0"

:: Set the path for the AHK script (replace backslashes with double backslashes for the registry key)
set "ahkScriptPath=%currentDir%CreateShortcutsWithTaskbarPinning.ahk"
set "ahkScriptPath=%ahkScriptPath:\=\\%"

:: Create a temporary .reg file
echo Windows Registry Editor Version 5.00 > AddToContextMenu.reg
echo. >> AddToContextMenu.reg
echo [HKEY_CLASSES_ROOT\exefile\shell\InstallPortableProgram] >> AddToContextMenu.reg
echo @="Install Portable program" >> AddToContextMenu.reg
echo "Icon"="shell32.dll,271" >> AddToContextMenu.reg
echo. >> AddToContextMenu.reg
echo [HKEY_CLASSES_ROOT\exefile\shell\InstallPortableProgram\command] >> AddToContextMenu.reg
echo @="\"%ahkScriptPath%\" \"%%1\"" >> AddToContextMenu.reg

:: Add the registry entries
regedit /s AddToContextMenu.reg

:: Delete the temporary .reg file
del AddToContextMenu.reg

echo Context menu entry added successfully.
pause
