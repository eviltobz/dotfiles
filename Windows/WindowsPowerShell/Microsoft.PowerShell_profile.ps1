# Utility Methods
function PausePrompt()
{
	Write-Host "Press any key to continue..."
	$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function path()
{
	$a = $env:path
	$a.Split(";")
}

function isAdmin {  
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()  
      $principal = new-object System.Security.Principal.WindowsPrincipal($identity)  
      $admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator  
      $principal.IsInRole($admin)  
} 

function admin {
  if(isAdmin) {
    Write-Host "Running as " -nonewline; Write-Host "admin." -f Green
  } else {
    Write-Host "Running as " -nonewline; Write-Host "standard user." -f Red
  }
}

function cddot {
  cd $home\dotfiles
}

$PRIVATE:UtilsPath = "C:\Utils"
$DotfilesPath = "$home\dotfiles"
$PsScripts = "$DotfilesPath\windows\PsScripts"
#$AhkScripts = "$DotfilesPath\windows\AutoHotKeyScripts"
$WorkScripts = "$DotfilesPath\Work\15below\PowershellScripts"
	
function EditProfile() { vi $profile }
function EditVimrc() { vi $home\_vimrc }
function EditHosts() { vi "C:\Windows\System32\Drivers\etc\hosts" }
function ShowScripts() { cd "$PsScripts"; ls }
function clls() { cls; ls} 
function cdls($path) { cd $path; ls} 
function cddot() { cd $DotfilesPath; ls} 
echo "Use EditProfile EditHosts & EditVimrc to edit configuration"
admin

# Common 3rd Party Apps
new-alias vi vim -Force
& "$PsScripts\SetupVisualStudio.ps1"
. 'C:\Users\toby.carter\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1' # Load posh-git example profile
$env:GIT_SSH = "C:\Program Files (x86)\GitExtensions\PuTTY\plink.exe"
#AutoHotKey "$AhkScripts\WinWarden\WinWarden.ahk"

# My Scripts
$env:Path += ";.\;$PsScripts;$WorkScripts" 
. "$PsScripts\unixey.ps1"
& "$PsScripts\DockerUtils.ps1"


# General Work Utils
#$env:Path += ";$UtilsPath\CliApps\OctopusDeployHelper;$UtilsPath\CliApps\Octopus2DeployHelper;C:\Utils\CliApps\BuildOctopusProject;C:\dev\sourc0\.paket"


# Do these need to go before all the common scripts?!?!?! lets try to shift work scripts to the end, then wrap em all up in a single work one
#. "$WorkScripts\Set-Locations.ps1"
#. "$WorkScripts\SetWorkingDir.ps1"
. "$WorkScripts\WorkProfile.ps1"
$env:Path += ";D:\git\eviltobz\ObjKilla\bin\Debug\"



# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

gitas
