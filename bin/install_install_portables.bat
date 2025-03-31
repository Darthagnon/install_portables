@echo off
setlocal

:: Get the full path of the icon and escape backslashes
set "currentDir=%~dp0"
set "iconPath=%currentDir%install_portables.ico"
set "ahkScriptPath=%currentDir%install_portables.exe"

:: Escape backslashes for registry (.reg) file
set "iconPath=%iconPath:\=\\%"
set "ahkScriptPath=%ahkScriptPath:\=\\%"

:: Create a temporary .reg file
> AddToContextMenu.reg (
    echo Windows Registry Editor Version 5.00
    echo.
    echo [HKEY_CLASSES_ROOT\exefile\shell\InstallPortableProgram]
    echo @="Install Portable program"
    echo "Icon"="%iconPath%"
    echo.
    echo [HKEY_CLASSES_ROOT\exefile\shell\InstallPortableProgram\command]
    echo @="\"%ahkScriptPath%\" \"%%1\""
)

:: Add the registry entries silently
regedit /s AddToContextMenu.reg

:: Clean up
del AddToContextMenu.reg

echo Context menu entry added successfully.
pause
