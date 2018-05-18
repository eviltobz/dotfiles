

function ensureFolder ($path) {
  if(-not (Test-Path $path)) {
    mkdir $path
  }
}
function gitGet ($name, $dest, $source) {
  Write-Host "Pulling $name from $source into $dest"
  git clone $source $dest
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


function DoPrereqs() {
  if(-not (Test-Path "C:\ProgramData\chocolatey\bin")) {
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  }
  chocoInstall git
  $env:path += ";c:\Program Files\Git\cmd"

  ensureFolder $path
  gitGet DotFiles $path https://github.com/eviltobz/dotfiles.git 
}

if ((get-executionpolicy) -ne "Bypass") {
  Write-Host "This machine is not set up to allow script execution. Its current policy is: $(Get-ExecutionPolicy)" -f red
  Write-Host "Attempting to alter policy." -f yellow
  Set-ExecutionPolicy Bypass
}

if ((get-executionpolicy) -eq "Bypass") {
  DoPrereqs
  cd $path
  & .\install.ps1
} else {
  Write-Host "Could not alter execution policy. The current policy is: $(Get-ExecutionPolicy)" -f red
  Write-Host "Please run the following command:" -f red
  Write-Host "Set-ExecutionPolicy Bypass" -f yellow
}
