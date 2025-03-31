; NSIS Installer Script for AHK Portable Program Shortcut Creator
; Installs compiled AHK script, adds registry context menu, and creates an uninstaller

!define PRODUCT_NAME "install_portables"
!define PRODUCT_VERSION "1.33"
!define PRODUCT_PUBLISHER "Darthagnon"
!define PRODUCT_URL "https://github.com/Darthagnon/install_portables"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

; Include Modern UI 2
!include "MUI2.nsh"

; Define the installer window title and text for all pages

; Window title for the installer
Name "${PRODUCT_NAME}"
!define MUI_HEADER_TEXT "${PRODUCT_NAME} Setup"
!define MUI_ICON "install_portables.ico"  ; Custom icon (optional)
!define MUI_UNICON "install_portables.ico"  ; Uninstaller icon (optional)

; Abort warning
!define MUI_ABORTWARNING
!define MUI_ABORTWARNING_TEXT "Are you sure you wish to cancel the ${PRODUCT_NAME} installation?"

; Customizing Welcome Page 1
!define MUI_WELCOMEPAGE_TITLE "Welcome to the ${PRODUCT_NAME} Installer"
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of ${PRODUCT_NAME} version ${PRODUCT_VERSION}. $\r$\n$\r$\ninstall_portables allows you to create Desktop, Start Menu and Taskbar shorcuts for portable software conveniently, since Windows does not index portable software by default. $\r$\n$\r$\nPress Next to continue."

; Customizing Directory Page 2
!define MUI_PAGE_HEADER_TEXT "Select Installation Folder"
!define MUI_PAGE_HEADER_SUBTEXT "Choose the folder in which to install ${PRODUCT_NAME}."
!define MUI_DIRECTORYPAGE_TEXT_TOP "Once installed, right-click on any portable .exe. A new context menu entry $\"Install Portable program$\" will allow you to create Desktop, Start Menu and Pinned Taskbar shortcuts. No other other changes to the portable program are made; config files are still stored alongside the .exe. It is recommended to store portable programs in permanent standard location, e.g. $\"C:\Portables\$\", so that the shortcuts you create keep working. To $\"uninstall$\" a portable program, simply delete the shortcuts and .exe manually."
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "Setup will install ${PRODUCT_NAME} in the following folder."
!define MUI_DIRECTORYPAGE_TITLE "Select Installation Folder"
!define MUI_DIRECTORYPAGE_BUTTON "Browse..."

; Customizing Install Files Page
!define MUI_INSTFILES_PAGE_TITLE "Installing ${PRODUCT_NAME}"
!define MUI_INSTFILES_PAGE_TEXT "Please wait while ${PRODUCT_NAME} is being installed."

; Customizing Finish Page
!define MUI_FINISHPAGE_TITLE "Installation Complete"
!define MUI_FINISHPAGE_TEXT "The installation of ${PRODUCT_NAME} is now complete. Click Finish to close this wizard."

; Customizing Uninstaller
!define MUI_UNPAGE_CONFIRM_TITLE "Uninstall ${PRODUCT_NAME}"
!define MUI_UNPAGE_CONFIRM_SUBTITLE "This will remove ${PRODUCT_NAME} from your computer. NOTE: Any shortcuts made to portable software will not be removed."

!define MUI_UNPAGE_FINISH_TITLE "Uninstallation Complete"
!define MUI_UNPAGE_FINISH_TEXT "The uninstallation of ${PRODUCT_NAME} is now complete. NOTE: Any shorcuts made to portable software are still present and can be removed manually. Click Finish to close this wizard."


; Installer header and configuration
Outfile "install_portables_v1.33_x86.exe"
InstallDir "$PROGRAMFILES\install_portables"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" "InstallLocation"
SetCompressor /SOLID lzma
RequestExecutionLevel admin
XPStyle on

; Modern UI settings for installer
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Modern UI settings for uninstaller
!insertmacro MUI_UNPAGE_INSTFILES

; Load language once for both installer and uninstaller
!insertmacro MUI_LANGUAGE "English"

; Define sections
Section "Main Section" SEC01

    ; Uninstall and replace previous installation
    IfFileExists "$INSTDIR\uninstall.exe" 0 +2
    ExecWait '"$INSTDIR\uninstall.exe" /S'

    ; Set the installation directory
    SetOutPath "$INSTDIR"

    ; Install the compiled AHK script (replace with the actual compiled .exe)
    File "install_portables.exe"

    ; Install the BAT file to add registry keys
    File "install_portables.ico"

    ; Install the BAT file to add registry keys
    File "install_install_portables.bat"

    ; Run the BAT file silently to add registry entries
    ExecWait '"$INSTDIR\install_install_portables.bat"'

    ; Write uninstaller information in the registry
    WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "DisplayName" "${PRODUCT_NAME}"
    WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "UninstallString" "$INSTDIR\uninstall.exe"
    WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "DisplayVersion" "${PRODUCT_VERSION}"
    WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "Publisher" "${PRODUCT_PUBLISHER}"
    WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "URLInfoAbout" "${PRODUCT_URL}"

    ; Write the uninstaller executable to the install directory
    WriteUninstaller "$INSTDIR\uninstall.exe"
    
    ; Write install directory to registry for future updates
    WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "InstallLocation" "$INSTDIR"

    ; Display an installation message
    MessageBox MB_OK "${PRODUCT_NAME} installed successfully!"

SectionEnd

; Section for uninstaller
Section "Uninstall"

    ; Remove registry entries created by the installer
    DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"

    ; Delete installed files
    Delete "$INSTDIR\install_portables.exe"
    Delete "$INSTDIR\install_portables.ico"
    Delete "$INSTDIR\install_install_portables.bat"

    ; Remove the installation directory
    RMDir "$INSTDIR"

    ; Remove context menu registry keys
    DeleteRegKey HKCR "exefile\shell\install_portables"
    
    ; Display an uninstallation message
    MessageBox MB_OK "${PRODUCT_NAME} uninstalled successfully!"

SectionEnd
