; NSIS Installer Script for AHK Portable Program Shortcut Creator
; Installs compiled AHK script, adds registry context menu, and creates an uninstaller

!define PRODUCT_NAME "install_portables"
!define PRODUCT_VERSION "1.33"
!define PRODUCT_PUBLISHER "Darthagnon"
!define PRODUCT_URL "https://github.com/Darthagnon/install_portables"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

; Include Modern UI 2
!include "MUI2.nsh"

; Installer header and configuration
Outfile "install_portables_v1.33_x86.exe"
InstallDir $PROGRAMFILES\install_portables
RequestExecutionLevel admin
XPStyle on

; Define sections
Section "Main Section" SEC01

    ; Set the installation directory
    SetOutPath "$INSTDIR"

    ; Install the compiled AHK script (replace with the actual compiled .exe)
    File "install_portables.exe"

    ; Install icon, as Windows cannot load the icon from the AHK compiled .exe
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

    ; Display an installation message
    MessageBox MB_OK "${PRODUCT_NAME} installed successfully!"

SectionEnd

; Section for uninstaller
Section "Uninstall"

    ; Remove registry entries created by the installer
    DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"

    ; Delete installed files
    Delete "$INSTDIR\install_portables.exe"
    Delete "$INSTDIR\install_install_portables.bat"

    ; Remove the installation directory
    RMDir "$INSTDIR"

    ; Remove context menu registry keys
    DeleteRegKey HKCR "exefile\shell\install_portables"
    
    ; Display an uninstallation message
    MessageBox MB_OK "${PRODUCT_NAME} uninstalled successfully!"

SectionEnd

; Uninstaller configuration
!macro MUI_UNPAGE_CONFIRM
!insertmacro MUI_PAGE_UNINSTALLCONFIRM
!macroend

; Installer pages
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

; Uninstaller pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_PAGE_INSTFILES

; Installer and uninstaller sections
!insertmacro MUI_LANGUAGE "English"
