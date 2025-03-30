; AHK Script to create shortcuts with selectable locations (Desktop, Start Menu\Portables, Taskbar Pinned)
; Compatible with AutoHotkey v1

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases
#SingleInstance Force  ; Ensures only one instance runs at a time
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory

; Check if an argument (EXE file path) is passed
if 0 < 1 {
    MsgBox Please drag and drop an executable file onto this script.
    ExitApp
}

exePath = %1%
exePath := Trim(exePath, """")  ; Remove surrounding quotes

; Validate path
if !FileExist(exePath) {
    MsgBox Invalid file path! (`%exePath%`) Please provide a valid executable.
    ExitApp
}

; Get the full (long) path to avoid short 8.3 filenames
Loop, %exePath%, 1 {
    exePath := A_LoopFileLongPath
    break
}

SplitPath, exePath, exeName
exeName := RegExReplace(exeName, "\.exe$", "", "")

; Extract icon from EXE
iconIndex := 0
iconHandle := DllCall("Shell32\ExtractIcon", "UInt", 0, "Str", exePath, "Int", iconIndex, "Ptr")
if (iconHandle <= 1) {
    MsgBox Failed to extract icon from the EXE.
    ExitApp
}

; Create GUI
Gui, +OwnDialogs +AlwaysOnTop
Gui, Add, Text,, (Select where to create shortcuts)

; Add icon preview
Gui, Add, Picture, x20 y50 w32 h32 Icon%iconIndex% vIconPreview, %exePath%

; Shortcut options
Gui, Add, Checkbox, vCreateDesktop Checked x+50 y55, Create Desktop Shortcut
Gui, Add, Checkbox, vCreateStartMenu Checked, Create Start Menu Shortcut
Gui, Add, Checkbox, vCreateTaskbar, Pin to Taskbar
Gui, Add, Text,, Start Menu Folder Name (Optional):
Gui, Add, Edit, vStartMenuFolder w200, Portables  ; Default value is "Portables"
Gui, Add, Text,, Shortcut Name:
Gui, Add, Edit, vShortcutName w200, %exeName%
Gui, Add, Button, x+10 w75 h23 Default, OK

Gui, Show,, Shortcut Options
Return

ButtonOK:
Gui, Submit

; Ensure at least one option is selected
if !CreateDesktop and !CreateStartMenu and !CreateTaskbar {
    MsgBox Please select at least one location for the shortcut.
    ExitApp
}

; Define shortcut locations
desktop := A_Desktop
taskbar := A_AppData "\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"

; Check if the user entered a Start Menu folder name
if (StartMenuFolder != "")
    startMenu := A_StartMenu "\" StartMenuFolder
else
    startMenu := A_StartMenu  ; Default to root Start Menu if empty

; Ensure Start Menu folder exists
IfNotExist, %startMenu%
    FileCreateDir, %startMenu%

; Function to create a shortcut
CreateShortcut(linkPath, target) {
    FileCreateShortcut, %target%, %linkPath%
}

; Create shortcuts
if CreateDesktop
    CreateShortcut(desktop "\" ShortcutName ".lnk", exePath)

if CreateStartMenu
    CreateShortcut(startMenu "\" ShortcutName ".lnk", exePath)

if CreateTaskbar
    CreateShortcut(taskbar "\" ShortcutName ".lnk", exePath)

MsgBox Shortcuts created successfully.
ExitApp
