# Powershell doesn't support MKLINK, it's only in cmd.exe!!!

# May want to add intelligence to check what exists before changing things
# add prompts, auto backup old things etc

# make the script appropriately idempotent


# get the starting path
$current = pwd
echo "Current path is $pwd"
if($current.ToString().ToUpper().EndsWith("INSTALL")){
  cd ..
}
$dotfiles = pwd



function linkFile ($file, $dest) {
  if(-not (Test-Path $dest)) {
    write-host "Linking $file to $dest"
#cmd /c mklink /h $dest $file
    cmd /c mklink $dest $file
  }
}

function linkFolder ($file, $dest) {
  if(-not (Test-Path $dest)) {
    write-host "Linking $file to $dest"
    cmd /c mklink /j $dest $file
  }
}

function ensureFolder ($path) {
  if(-not (Test-Path $path)) {
    mkdir $path
  }
}

function gitGet ($name, $dest, $source) {
  if(-not (Test-Path $dest)) {
    Write-Host "Pulling $name from $source into $dest"
    git clone --depth=1 $source $dest
  } else {
    Write-Host "Already have the git repo $name pulled." -f red
    Write-Host "Maybe we should do a pull here, keep it up to date..." -f red
  }
}

function PinToTaskbar($folder, $file)
{
  echo "pinning $folder $file"
  $sa = new-object -c shell.application
  $pn = $sa.namespace($folder).parsename($file)
  $pn.invokeverb('taskbarpin')
}

$chocInstallCode = 0
function chocoInstall($name) {
  if((choco list -l | findstr -i "^$name ").Count -gt 0) {
    Write-Host "Choco has already installed $name"
    choco list -l | findstr -i "^$name "
    $chocInstallCode = 1
  } else {
    choco install $name --confirm
    $chocInstallCode = 0
  }
}

function chocoToTaskbar($name, $folder, $exe) {
  chocoInstall $name
  if($chocInstallCode -eq 0) {
    PinToTaskbar $folder $exe
  }
}

function startupAutoHotKeyScript($name, $source, $icon) {
  $ahk = "C:\Program Files\AutoHotkey\AutoHotKey.exe" 
  $dest = "$($env:userprofile)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\$name.lnk"
  if(-not (Test-Path $dest)) {
    Write-Host "Creating startup item $name from $source"
    Write-Host "Creating in $dest"
    Write-Host "ahk in $ahk"

    $s=(New-Object -COM WScript.Shell).CreateShortcut($dest);
    $s.TargetPath = $ahk
    $s.WorkingDirectory = $source
    $s.Arguments = "$source\$name.ahk"
    $s.IconLocation = "$source\$name.exe, 0";
    $s.Save()
  }
}


function DoSetup() {

# Windows Specific Things
#

# Some good windows explorer setup
#Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
  $AdvancedKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
  $AdvancedKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState'
  Set-ItemProperty $AdvancedKey AlwaysShowMenus 1
  Set-ItemProperty $AdvancedKey Hidden 1
  Set-ItemProperty $AdvancedKey ShowSuperHidden 1
  Set-ItemProperty $AdvancedKey HideFileExt 0
  Set-ItemProperty $AdvancedKey NavPaneExpandToCurrentFolder 1
  Set-ItemProperty $AdvancedKey NavPaneShowAllFolders 1
  Set-ItemProperty $AdvancedKey ShowStatusBar 1
  Set-ItemProperty $AdvancedKey FullPath 1

#startupAutoHotKeyScript WinWarden $env:userprofile\dotfiles\Windows\AutoHotKeyScripts\WinWarden WinWarden.gif

  Write-Host "Installing software:" -f Yellow
#chocoToTaskbar vim "C:\Program Files (x86)\vim\vim80" "gvim.exe"
#  chocoToTaskbar conemu "C:\Program Files\ConEmu" "ConEmu64.exe"
#  chocoInstall poshgit
#  chocoInstall puretext
#  chocoToTaskbar tailblazer "C:\ProgramData\chocolatey\lib\tailblazer\tools" "TailBlazer.exe"
#  chocoInstall autohotkey

  Remove-Item "C:\Program Files\ConEmu\ConEmu.xml" 
  linkFile Windows\ConEmu.xml "C:\Program Files\ConEmu\ConEmu.xml" 

# Common settings
  linkFolder $dotfiles $env:userprofile\dotfiles

#startupAutoHotKeyScript WinWarden $env:userprofile\dotfiles\Windows\AutoHotKeyScripts\WinWarden WinWarden.gif

  #linkFile .\vim\vimrc $env:userprofile\_vimrc
  #linkFile .\vim\vsvimrc $env:userprofile\_vsvimrc
  echo "Linkage should go here"
  linkFile $dotfiles\vim\vimrcs\win.vimrc $env:userprofile\_vimrc
  linkFile $dotfiles\vim\vimrcs\vsvim.vimrc $env:userprofile\_vsvimrc
  echo "Linkage should go there"
  linkFolder $dotfiles\vim $env:userprofile\vimfiles
  ensureFolder $dotfiles\vim\backups
  ensureFolder $dotfiles\vim\bundle
  ensureFolder $dotfiles\vim\autoload

  Invoke-WebRequest https://tpo.pe/pathogen.vim -outfile $dotfiles/vim/autoload/pathogen.vim
  gitGet NERDtree $dotfiles/vim/bundle/nerdtree https://github.com/scrooloose/nerdtree.git
  gitGet Syntastic $dotfiles/vim/bundle/syntastic https://github.com/vim-syntastic/syntastic.git

  git config --global core.editor vim
}

function DoPrereqs() {
  if(-not(Test-Path "$env:userprofile\Documents\WindowsPowerShell")) {
    linkFolder $dotfiles\Windows\WindowsPowerShell "$env:userprofile\Documents\WindowsPowerShell"
  }

  if((Test-Path "$env:userprofile\Documents\WindowsPowerShell") -and (-not(Test-Path  "$env:userprofile\Documents\WindowsPowerShell_Backup"))) {
    mv "$env:userprofile\Documents\WindowsPowerShell" "$env:userprofile\Documents\WindowsPowerShell_Backup"
    linkFolder $dotfiles\Windows\WindowsPowerShell "$env:userprofile\Documents\WindowsPowerShell"
  }

  if(-not (Test-Path "C:\ProgramData\chocolatey\bin")) {
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host "Chocolatey probably needs the shell to be reopened now." -f Yellow
    Write-Host "Please re-run the script after." -f Yellow
  } else {
    DoSetup
  }
}

if ((get-executionpolicy) -ne "Bypass") {
  Write-Host "This machine is not set up to allow script execution. Its current policy is: $(Get-ExecutionPolicy)" -f red
  Write-Host "Attempting to alter policy." -f yellow
  Set-ExecutionPolicy Bypass
}

if ((get-executionpolicy) -eq "Bypass") {
  DoPrereqs
} else {
  Write-Host "Could not alter execution policy. The current policy is: $(Get-ExecutionPolicy)" -f red
  Write-Host "Please run the following command:" -f red
  Write-Host "Set-ExecutionPolicy Bypass" -f yellow
}
