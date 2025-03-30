; AHK Script to create shortcuts with selectable locations (Desktop, Start Menu\Portables, Taskbar Pinned)
; Compatible with AutoHotkey v1

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory

; Check if an argument (EXE file path) is passed
if 0 < 1
{
    MsgBox, Please drag and drop an executable file onto this script.
    ExitApp
}

; Access the first argument properly
exePath := 1  ; No `%` needed

; Remove surrounding quotes if present
StringReplace, exePath, exePath, ", , All

; Validate path
if !FileExist(exePath)
{
    MsgBox, Invalid file path! Please provide a valid executable.
    ExitApp
}

; Extract the filename without extension
SplitPath, exePath, exeName

; GUI for user input
Gui, Add, Checkbox, vCreateDesktop, Create Desktop Shortcut
Gui, Add, Checkbox, vCreateStartMenu, Create Start Menu\Portables Shortcut
Gui, Add, Checkbox, vCreateTaskbar, Pin to Taskbar
Gui, Add, Text,, Shortcut Name:
Gui, Add, Edit, vShortcutName, %exeName%  ; Default value is the EXE name
Gui, Add, Button, Default, OK
Gui, Show,, Shortcut Options

; Wait for user interaction
Return

ButtonOK:
Gui, Submit

; Ensure at least one option is selected
if !CreateDesktop and !CreateStartMenu and !CreateTaskbar
{
    MsgBox, Please select at least one location for the shortcut.
    ExitApp
}

; Define shortcut locations
desktop := A_Desktop
startMenu := A_StartMenu "\Portables"
taskbar := A_AppData "\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"

; Ensure Start Menu "Portables" folder exists
IfNotExist, %startMenu%
    FileCreateDir, %startMenu%

; Function to create a shortcut
CreateShortcut(linkPath, target)
{
    FileCreateShortcut, %target%, %linkPath%
}

; Create shortcuts
if CreateDesktop
    CreateShortcut(desktop "\" shortcutName ".lnk", exePath)

if CreateStartMenu
    CreateShortcut(startMenu "\" shortcutName ".lnk", exePath)

if CreateTaskbar
    CreateShortcut(taskbar "\" shortcutName ".lnk", exePath)

MsgBox, Shortcuts created successfully.
ExitApp
