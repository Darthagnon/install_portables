# Install Portables
Portable programs are convenient, as they don't require installation and save all their savedata next to the EXE. This means they can run off memory sticks, removable storage, and survive Windows reinstallations. 

However, Windows was built to work with installed programs - they are listed in the Start Menu, linked on the Desktop and pinned to the Taskbar. It is irksome to manually create shortcuts to your favourite portables.

This little program does the job for you. It "installs" portables to your choice of Desktop, Start Menu, or Taskbar, all from the context menu on any EXE.

## Usage
**Current working version: v1.2**

1. Download and install `install_portables_vX.XX.exe`
2. Right click on a portable EXE that lacks shortcuts
3. Select `Install Portable Program` from the context menu
4. Select where you want shortcuts and what you want them to be called
5. Click OK

You will now be able to launch the portable program more conveniently from shortcuts on the Desktop, Start Menu, or taskbar.

## Build
Built with ChatGPT4o (March 2025), AutoHotkey v1.1.33.02 x86, UPX 3.96w and NSIS v2.51. Contains icon 271 from shell32.dll (Windows 7).

Works with Windows 7, 8, 8.1, 10, 11. Untested with WinXP, Win2000, WinMe.

Note that UPX may result in antivirus false-positives; it will take a tiny bit less HDD space and a tiny bit more RAM. It doesn't need to be `amd64`, so it can work on more machines.

## TODO
- ~~proper Git version control from initial drafts to final~~
- ~~Display program icon in popup window~~
- ~~Test BAT~~
- Test NSIS installer
- Uninstaller for "installed" portables?
- ~~Symlink to PATH?~~ Beyond scope, tested and it kinda works with *.lnk 
- Add HTML/MD Readme and/or About info
- Ensure script never stays running in the background
- Add links to alternatives, e.g. [ISMONISM](https://github.com/Winkie1000/ISMONISM) ([DonationCoder NANY 2020](https://www.donationcoder.com/forum/index.php?topic=49299.0))
- Add suggested permanent storage for portables in Program
- File > Open Start Menu folder, Open Taskbar Pinned folder, Open Desktop folder?
- Add build script
