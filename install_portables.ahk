; AHK Script to create shortcuts with selectable locations (Desktop, Start Menu\Portables, Taskbar Pinned)
; Compatible with AutoHotkey v1

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases
#SingleInstance Force  ; Ensures only one instance runs at a time
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory

; Check if an argument (EXE file path) is passed
if 0 < 1
{
    MsgBox, Please drag and drop an executable file onto this script.
    ExitApp
}

; Retrieve the first argument **without using :=**
exePath = %1%

; Remove surrounding quotes if present
exePath := Trim(exePath, """")  ; Properly remove leading and trailing quotes

; Validate path
if !FileExist(exePath)
{
    MsgBox, Invalid file path! (`%exePath%`) Please provide a valid executable.
    ExitApp
}

; Extract the filename without extension
SplitPath, exePath, exeName

; Create GUI
Gui, +OwnDialogs
Gui, Add, Text, , (Select where to create shortcuts)
Gui, Add, Checkbox, vCreateDesktop, Create Desktop Shortcut
Gui, Add, Checkbox, vCreateStartMenu, Create Start Menu\Portables Shortcut
Gui, Add, Checkbox, vCreateTaskbar, Pin to Taskbar
Gui, Add, Text,, Shortcut Name:
Gui, Add, Edit, vShortcutName w200, %exeName%  ; Default width 200px
Gui, Add, Button, x+10 w75 h23 Default, OK  ; Standard Windows button size, positioned to the right
Gui, Show,, Shortcut Options

; Wait for user interaction
; Set GUI icon to shell32.dll,127
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

; Create shortcuts
if CreateDesktop
    CreateShortcut(desktop "\" ShortcutName ".lnk", exePath)

if CreateStartMenu
    CreateShortcut(startMenu "\" ShortcutName ".lnk", exePath)

if CreateTaskbar
    CreateShortcut(taskbar "\" ShortcutName ".lnk", exePath)

MsgBox, Shortcuts created successfully.
ExitApp
