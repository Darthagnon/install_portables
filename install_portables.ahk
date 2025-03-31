#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%

; Check if EXE was dragged and dropped
if 0 < 1
{
    MsgBox, Please drag and drop an executable file onto this script.
    ExitApp
}

; Get the EXE path and clean it
exePath = %1%
exePath := Trim(exePath, """")  ; Remove surrounding quotes

if !FileExist(exePath)
{
    MsgBox, Invalid file path! (" . exePath . ")`nPlease provide a valid executable.
    ExitApp
}

; Convert to long path
Loop, %exePath%, 1
{
    exePath := A_LoopFileLongPath
    break
}

; Get base name for shortcut
SplitPath, exePath, exeName
exeName := RegExReplace(exeName, "\.exe$", "", "")


; GUI layout
Gui, +OwnDialogs +AlwaysOnTop
Gui, Add, Text, x20, (Select where to create shortcuts)

; Show EXE's icon in the GUI body; icon to the right, above OK button
Gui, Add, Picture, x220 y20 Center w32 h32 Icon0 vIconPreview, %exePath%
Gui, Font, s9 Bold
Gui, Add, Text, x210 y55 Center, %exeName%
Gui, Font  ; Reset to default

; Left-aligned checkboxes and fields with Desktop and Start Menu checked by default
Gui, Add, Checkbox, vCreateDesktop Checked x20 y60, Create Desktop Shortcut
Gui, Add, Checkbox, vCreateStartMenu Checked x20, Create Start Menu Shortcut
Gui, Add, Checkbox, vCreateTaskbar x20, Pin to Taskbar

; Folder and name fields
Gui, Add, Text, x20, Start Menu Folder Name (Optional):
Gui, Add, Edit, vStartMenuFolder w200 x20, Portables
Gui, Add, Text, x20, Shortcut Name:
Gui, Add, Edit, vShortcutName w200 x20, %exeName%

; OK button under the icon
Gui, Add, Button, x200 y230 w75 h23 Default, OK
Gui, Show,, Shortcut Options
Return

ButtonOK:
Gui, Submit

if !CreateDesktop and !CreateStartMenu and !CreateTaskbar
{
    MsgBox, Please select at least one location for the shortcut.
    ExitApp
}

desktop := A_Desktop
taskbar := A_AppData "\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"

if (StartMenuFolder != "")
    startMenu := A_StartMenu "\" StartMenuFolder
else
    startMenu := A_StartMenu

IfNotExist, %startMenu%
    FileCreateDir, %startMenu%

CreateShortcut(linkPath, target)
{
    FileCreateShortcut, %target%, %linkPath%
}

if CreateDesktop
    CreateShortcut(desktop "\" ShortcutName ".lnk", exePath)

if CreateStartMenu
    CreateShortcut(startMenu "\" ShortcutName ".lnk", exePath)

if CreateTaskbar
    CreateShortcut(taskbar "\" ShortcutName ".lnk", exePath)

MsgBox, Shortcuts created successfully.
ExitApp
