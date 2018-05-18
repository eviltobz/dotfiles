# Powershell doesn't support MKLINK, it's only in cmd.exe!!!

# May want to add intelligence to check what exists before changing things
# add prompts, auto backup old things etc

# make the script appropriately idempotent

function linkFile ($file, $dest) {
  if(-not (Test-Path $dest)) {
    write-host "Linking $file to $dest"
    cmd /c mklink /h $dest $file
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
  if(-not (Test-Path $path)) {
    Write-Host "Pulling $name from $source into $dest"
    git clone $source $dest
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
  if((choco list -l | findstr -i "^$name ").Count > 0) {
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

  Write-Host "Installing software:" -f Yellow
  chocoToTaskbar vim "C:\Program Files (x86)\vim\vim80" "gvim.exe"
  chocoToTaskbar conemu "C:\Program Files\ConEmu" "ConEmu64.exe"
  chocoInstall poshgit
  chocoToTaskbar tailblazer "C:\ProgramData\chocolatey\lib\tailblazer\tools" "TailBlazer.exe"

  linkFile Windows\ConEmu.xml $env:AppData\ConEmu.xml

# Common settings
  linkFolder . $env:userprofile\dotfiles

  linkFile vimrc $env:userprofile\_vimrc
  linkFile vsvimrc $env:userprofile\_vsvimrc
  ensureFolder .\vim\backups
  ensureFolder .\vim\bundle
  ensureFolder .\vim\autoload

  Invoke-WebRequest https://tpo.pe/pathogen.vim -outfile ./vim/autoload/pathogen.vim
  gitGet NERDtree ./vim/bundle/nerdtree https://github.com/scrooloose/nerdtree.git

  git config --global core.editor vim
}

function DoPrereqs() {
  if((Test-Path "$env:userprofile\Documents\WindowsPowerShell") -and (-not(Test-Path  "$env:userprofile\Documents\WindowsPowerShell_Backup"))) {
    mv "$env:userprofile\Documents\WindowsPowerShell" "$env:userprofile\Documents\WindowsPowerShell_Backup"
    linkFolder Windows\WindowsPowerShell "$env:userprofile\Documents\WindowsPowerShell"
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
