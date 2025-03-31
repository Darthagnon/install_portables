; AHK Script to create shortcuts with selectable locations (Desktop, Start Menu\Portables, Taskbar Pinned)
; Compatible with AutoHotkey v1

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases
#SingleInstance Force  ; Ensures only one instance runs at a time
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory

; Check if an argument (EXE file path) is passed, i.e. if EXE was dragged and dropped
if 0 < 1 {
    MsgBox, Please drag and drop an executable file onto this script.
    ExitApp
}

; Get the EXE path and clean it
exePath = %1%
exePath := Trim(exePath, """")  ; Remove surrounding quotes

; Validate path
if !FileExist(exePath) {
    MsgBox, Invalid file path! (" . exePath . ")`nPlease provide a valid executable.
    ExitApp
}

; Get the full (long) path to avoid short 8.3 filenames
Loop, %exePath%, 1 {
    exePath := A_LoopFileLongPath
    break
}

; Get base name for shortcut
SplitPath, exePath, exeName
exeName := RegExReplace(exeName, "\.exe$", "", "")

; GUI with EXE icon preview
Gui, +OwnDialogs +AlwaysOnTop
Gui, Add, Text,, (Select where to create shortcuts)

; Icon to the right, above OK button
Gui, Add, Picture, x250 y10 w32 h32 Icon0 vIconPreview, %exePath%
Gui, Font, s9 Bold
Gui, Add, Text, x250 y45 Center, %exeName%
Gui, Font  ; Reset to default

; Add checkboxes with Desktop and Start Menu checked by default
; Left-aligned checkboxes and fields
Gui, Add, Checkbox, vCreateDesktop Checked x20 y60, Create Desktop Shortcut
Gui, Add, Checkbox, vCreateStartMenu Checked x20, Create Start Menu Shortcut
Gui, Add, Checkbox, vCreateTaskbar x20, Pin to Taskbar

; Folder and name fields
Gui, Add, Text, x20, Start Menu Folder Name (Optional):
Gui, Add, Edit, vStartMenuFolder w200 x20, Portables  ; Default value is "Portables"
Gui, Add, Text, x20, Shortcut Name:
Gui, Add, Edit, vShortcutName w200 x20, %exeName%

; OK button under the icon
Gui, Add, Button, x250 y55 w75 h23 Default, OK
Gui, Submit

; Ensure at least one option is selected
if !CreateDesktop and !CreateStartMenu and !CreateTaskbar {
    MsgBox, Please select at least one location for the shortcut.
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

MsgBox, Shortcuts created successfully.
ExitApp
