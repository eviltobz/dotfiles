# Powershell doesn't support MKLINK, it's only in cmd.exe!!!

# May want to add intelligence to check what exists before changing things
# add prompts, auto backup old things etc

# make the script appropriately idempotent

function linkFile ($file, $dest) {
  write-host "Linking $file to $dest"
  cmd /c mklink /h $dest $file
}

function linkFolder ($file, $dest) {
  write-host "Linking $file to $dest"
  cmd /c mklink /j $dest $file
}

function gitGet ($name, $dest, $source) {
  Write-Host "Pulling $name from $source into $dest"
  git clone $source $dest
}

function PinToTaskbar($folder, $file)
{
  $sa = new-object -c shell.application
  $pn = $sa.namespace($folder).parsename($file)
  $pn.invokeverb('taskbarpin')
}

function chocoInstall($name) {
  if((choco list -l | findstr -i "^$name ").Count > 0) {
    Write-Host "Choco has already installed $name"
    choco list -l | findstr -i "^$name "
    return 1
  } else {
    choco install $name
    return 0
  }
}

function chocoToTaskbar($name, $folder, $exe) {
  if((chocoInstall $name) -eq 0) {
    PinToTaskbar $folder $exe
  }
}





# Windows Specific Things
#

# Some good windows explorer setup
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key AlwaysShowMenus 1
Set-ItemProperty $key NavPaneExpandToCurrentFolder 1
Set-ItemProperty $key NavPaneShowAllFolders 1
Set-ItemProperty $key ShowStatusBar 1

mv "$env:userprofile\Documents\WindowsPowerShell" "$env:userprofile\Documents\WindowsPowerShell_Backup"
linkFolder Windows\WindowsPowerShell "$env:userprofile\Documents\WindowsPowerShell"

if(Test-Path "C:\ProgramData\chocolatey\bin") {
  write-host "if this fails, run Set-ExecutionPolicy Bypass"
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

chocoToTaskbar(vim, "C:\Program Files (x86)\vim\vim80", "gvim.exe")
chocoToTaskbar(conemu, "C:\Program Files\ConEmu", "ConEmu64.exe")
chocoInstall poshgit
chocoToTaskbar(tailblazer, "C:\ProgramData\chocolatey\lib\tailblazer\tools", "TailBlazer.exe")



# Common settings
linkFile vimrc %USERPROFILE%\_vimrc
linkFile vsvimrc %USERPROFILE%\_vsvimrc

linkFolder . %USERPROFILE%\dotfiles
mkdir ~\vimfiles\backups

mkdir ~\vimfiles\autoload
curl https://tpo.pe/pathogen.vim -outfile ./vim/autoload/pathogen.vim

gitGet NERDtree vim/bundle/nerdtree https://github.com/scrooloose/nerdtree.git

git config --global core.editor vim

