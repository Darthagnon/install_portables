; AHK Script to create shortcuts on Desktop and Start Menu\Portables folders

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

; Prompt the user for a shortcut name, defaulting to the EXE name
InputBox, shortcutName, Shortcut Name, Enter the name for the shortcut:, , 400, 150,, , , %exeName%
if ErrorLevel
{
    MsgBox, Shortcut creation cancelled.
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
    FileCreateShortcut, %target%, %linkPath%, , , , , , , , , , %shortcutName%
}

; Create Desktop shortcut
CreateShortcut(desktop "\" shortcutName ".lnk", exePath, shortcutName)

; Create Start Menu\Portables shortcut
CreateShortcut(startMenu "\" shortcutName ".lnk", exePath, shortcutName)

; Notify user of success
MsgBox, Shortcuts created on Desktop and Start Menu\Portables.
ExitApp
