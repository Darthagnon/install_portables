; AHK Script to create shortcuts with selectable locations (Desktop, Start Menu\Portables, Taskbar Pinned)
; Compatible with AutoHotkey v1

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases
#SingleInstance Force  ; Ensures only one instance runs at a time
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory

; Check if an argument (EXE file path) is passed
if 0 < 1
{
    MsgBox Please drag and drop an executable file onto this script.
    ExitApp
}

; Retrieve the first argument **without using :=**
exePath = %1%

; Validate path
exePath := Trim(exePath, """")
if !FileExist(exePath) {
    MsgBox Invalid file path! (`exePath`) Please provide a valid executable.
    ExitApp
}

; Get the full (long) path to avoid short 8.3 filenames
Loop, %exePath%, 1 {
    exePath := A_LoopFileLongPath
    break
}

; Extract the filename without extension
SplitPath, exePath, exeName
exeName := RegExReplace(exeName, "\.exe$", "", "")  ; Remove ".exe" from the name

; Extract EXE icon to temp .ico file
iconPath := A_Temp "\temp_icon.ico"
IID_IPicture := "{7BF80981-BF32-101A-8BBB-00AA00300CAB}"

; Use built-in icon extraction (save as .ico)
hIcon := DllCall("Shell32\ExtractIcon", "Ptr", 0, "Str", exePath, "Int", 0, "Ptr")
if (hIcon) {
    ; Save icon to file for display
    hBitmap := DllCall("CreateCompatibleBitmap", "Ptr", DllCall("GetDC", "Ptr", 0, "Ptr"), "Int", 32, "Int", 32, "Ptr")
    hdc := DllCall("CreateCompatibleDC", "Ptr", 0, "Ptr")
    oldBmp := DllCall("SelectObject", "Ptr", hdc, "Ptr", hBitmap, "Ptr")
    DllCall("DrawIconEx", "Ptr", hdc, "Int", 0, "Int", 0, "Ptr", hIcon, "Int", 32, "Int", 32, "UInt", 0, "Ptr", 0, "UInt", 3)
    DllCall("SelectObject", "Ptr", hdc, "Ptr", oldBmp)
    DllCall("DeleteDC", "Ptr", hdc)

    ; Save to icon file
    pBitmap := ComObjCreate("WIA.ImageFile")
    pStream := ComObjCreate("ADODB.Stream")
    pStream.Type := 1
    pStream.Open()
    pStream.Write(DllCall("OleAut32\OleLoadPicture", "Ptr", hBitmap, "Int", 0, "Int", true, "Ptr", &IID_IPicture, "Ptr*"))
    pStream.SaveToFile(iconPath, 2)
    pStream.Close()
}

; GUI layout
Gui, +OwnDialogs +Resize
Gui, Add, Text, , (Select where to create shortcuts)

Gui, Add, Picture, x20 y45 w32 h32 vIconPreview, %iconPath%

; Create GUI
Gui, Add, Checkbox, vCreateDesktop Checked x+10, Create Desktop Shortcut
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
