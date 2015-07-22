# Lets get the key base set of tweaks & installs that i'd likely want on any box in my control - main dev box, LOC vm etc.
# then a secondary script for the main box type of tools

# can we find a suitabubble location and download additional files there - support functions, config files for apps etc.
write-host "DEBUGGY STUFF"
write-host "current working folder is:"
pwd
write-host "END DEBUGGY STUFF"

function PinToTaskbar($folder, $file)
{
  $sa = new-object -c shell.application
  $pn = $sa.namespace($folder).parsename($file)
  $pn.invokeverb('taskbarpin')
}


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

# created in C:\tools\cmder
# -pre needs VC++ 2015 redist installed which isn't chocolatey... yet. should be soon though
cinst cmder #-pre
# copy cmder configs around somewhere???
PinToTaskbar "C:\tools\cmder\" "cmder.exe"

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



