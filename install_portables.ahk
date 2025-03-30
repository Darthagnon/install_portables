; AHK Script to create shortcuts with selectable locations (Desktop, Start Menu\Portables, Taskbar Pinned)

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory

; Check if an argument (EXE file path) is passed
if (A_Args.Length() < 1)
{
    MsgBox, Please drag and drop an executable file onto this script.
    ExitApp
}

; Store the passed EXE file path
exePath := A_Args[1]

; Get the file name (without extension) to use as default shortcut name
FileGetName, exeName, %exePath%

; Create a GUI for user input (checkboxes and shortcut name)
Gui, Add, Checkbox, vCreateDesktop, Create Desktop Shortcut
Gui, Add, Checkbox, vCreateStartMenu, Create Start Menu\Portables Shortcut
Gui, Add, Checkbox, vCreateTaskbar, Pin to Taskbar
Gui, Add, Text,, Shortcut Name:
Gui, Add, Edit, vShortcutName, %exeName%  ; Default value is the EXE name
Gui, Add, Button, Default, OK
Gui, Show,, Shortcut Options

; Wait for user interaction
Return

; Handle the OK button press
ButtonOK:
Gui, Submit

; If no locations are selected, warn the user and exit
if (!CreateDesktop && !CreateStartMenu && !CreateTaskbar)
{
    MsgBox, Please select at least one location for the shortcut.
    ExitApp
}

; Define locations for shortcuts
desktop := A_Desktop
startMenu := A_StartMenu "\Portables"

; Ensure Start Menu "Portables" folder exists
IfNotExist, %startMenu%
    FileCreateDir, %startMenu%

; Function to create a shortcut
CreateShortcut(linkPath, target, shortcutName)
{
    FileCreateShortcut, %target%, %linkPath%, , , , , , , , , %shortcutName%
}

; Create shortcuts based on user selections
if (CreateDesktop)
{
    CreateShortcut(desktop "\" ShortcutName ".lnk", exePath, ShortcutName)
}

if (CreateStartMenu)
{
    CreateShortcut(startMenu "\" ShortcutName ".lnk", exePath, ShortcutName)
}

; Pin to Taskbar (only works on Windows 7 and later)
if (CreateTaskbar)
{
    Run, % "explorer.exe /select," exePath
    Sleep, 500
    Send, {AppsKey}  ; Opens context menu
    Sleep, 100
    Send, p  ; Pin to taskbar
}

; Notify user of success
MsgBox, Shortcuts created based on your selections.
ExitApp
