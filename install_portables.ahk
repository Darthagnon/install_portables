; AHK Script to create shortcuts with selectable locations (Desktop, Start Menu\Portables, Taskbar Pinned)
; Compatible with AutoHotkey v1

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory
; GUI for user input
; Set window icon to shell32.dll,127
Gui, +OwnDialogs
Gui, Add, Text, , (Select where to create shortcuts)
Gui, Add, Checkbox, vCreateDesktop, Create Desktop Shortcut
Gui, Add, Checkbox, vCreateStartMenu, Create Start Menu\Portables Shortcut
Gui, Add, Checkbox, vCreateTaskbar, Pin to Taskbar
Gui, Add, Text,, Shortcut Name:
Gui, Add, Edit, vShortcutName w200  ; Default width 200px
Gui, Add, Button, x+10 w75 h23 Default, OK  ; Move to right, standard 75x23 size
Gui, Show,, Shortcut Options

; Wait for user interaction
; Set GUI icon
hIcon := DllCall("LoadImage", "UInt", 0, "Str", "shell32.dll", "UInt", 1, "Int", 127, "Int", 127, "UInt", 0x10)
SendMessage, 0x80, 1, hIcon, , A  ; WM_SETICON for big icon
SendMessage, 0x80, 0, hIcon, , A  ; WM_SETICON for small icon

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

; Set the correct target path
exePath := "C:\path\to\program.exe"

; Create shortcuts
if CreateDesktop
    CreateShortcut(desktop "\" shortcutName ".lnk", exePath)

if CreateStartMenu
    CreateShortcut(startMenu "\" shortcutName ".lnk", exePath)

if CreateTaskbar
    CreateShortcut(taskbar "\" shortcutName ".lnk", exePath)

MsgBox, Shortcuts created successfully.
ExitApp
