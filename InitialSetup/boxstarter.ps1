# Lets get the key base set of tweaks & installs that i'd likely want on any box in my control - main dev box, LOC vm etc.
# then a secondary script for the main box type of tools


# Boxstarter options
$Boxstarter.RebootOk=$true # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot

# Basic setup
Update-ExecutionPolicy Unrestricted
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
 write-host "-navigation pane show all folders & auto expand... any pure powershell hacks?"
#try this:
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key AlwaysShowMenus 1
Set-ItemProperty $key NavPaneExpandToCurrentFolder 1
Set-ItemProperty $key NavPaneShowAllFolders 1
Set-ItemProperty $key ShowStatusBar 1
#end try...



# This gubbins was in a sample boxstarter script. do we actually want it?...
Enable-RemoteDesktop
Disable-InternetExplorerESC
Disable-UAC

if (Test-PendingReboot) { Invoke-Reboot }

# Update Windows and reboot if necessary
Install-WindowsUpdate -AcceptEula
if (Test-PendingReboot) { Invoke-Reboot }
# end gubbins...

cinst cmder #-pre
# copy cmder configs around somewhere???

cinst vim
# copy vimrc files etc into place
# set up plugins & whatnots


cinst notepadplusplus # or should it be notepadplusplus.install ???


# git - poshgit - kdiff3 - github? gitextensions
# git-credential-winstore ???

cinst 7zip.install

#autohotkey? sysinternals?




# copy powershell profile & scripts into place - this slows starting PS sessions, so lets leave it to the end...



###########
# main machine specific stuff to wap into a second file

# browsers? chrome, furryfux, opera? tor
# foxitreader
# linqpad
# dropbox et al.
# evernote, spotify

#cinst cygwin ????

# visual studio?
# visual studio plugins - vsvim aint listed, but some things like this - https://chocolatey.org/packages/alanstevens.vsextensions - install it, so have a look at what that does :)



