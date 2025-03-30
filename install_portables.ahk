; AHK Script to create shortcuts with selectable locations (Desktop, Start Menu\Portables, Taskbar Pinned)
; Compatible with AutoHotkey v1

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory

; Check if an argument (EXE file path) is passed (check number of arguments)
if 0 = 0
{
    MsgBox, Please run the script with an executable file as an argument or drag-and-drop it onto the script.
    ExitApp
}

; Access the first passed argument (EXE file path)
exePath := %1%

; Get the file name (without extension) to use as default shortcut name
SplitPath, exePath, exeName

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

ButtonOK:
Gui, Submit

; If no locations are selected, warn the user and exit
if !CreateDesktop and !CreateStartMenu and !CreateTaskbar
{
    MsgBox, Please select at least one location for the shortcut.
    ExitApp
}

; Define locations for shortcuts
desktop := A_Desktop
startMenu := A_StartMenu "\Portables"
taskbar := A_AppData "\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"

; Ensure Start Menu "Portables" folder exists
IfNotExist, %startMenu%
{
    FileCreateDir, %startMenu%
}

; Function to create a shortcut
CreateShortcut(linkPath, target, shortcutName)
{
    FileCreateShortcut, %target%, %linkPath%, , , , , , , , , %shortcutName%
}

; Create shortcuts based on user selections
if CreateDesktop
{
    CreateShortcut(desktop "\" ShortcutName ".lnk", exePath, ShortcutName)
}

if CreateStartMenu
{
    CreateShortcut(startMenu "\" ShortcutName ".lnk", exePath, ShortcutName)
}

; Create Taskbar shortcut
if CreateTaskbar
{
    IfNotExist, %taskbar%
    {
        FileCreateDir, %taskbar%
    }
    CreateShortcut(taskbar "\" ShortcutName ".lnk", exePath, ShortcutName)
}

; Notify user of success
MsgBox, Shortcuts created based on your selections.
ExitApp
