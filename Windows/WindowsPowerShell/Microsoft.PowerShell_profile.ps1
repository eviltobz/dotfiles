if([Environment]::CommandLine.endsWith(".ps1")) {
    Write-Host "Executing script without profile: " -NoNewLine 
    Write-Host "$([Environment]::CommandLine)" -ForegroundColor DarkGray
    Exit
}


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
  Write-Host
  if(isAdmin) {
    Write-Host "Running as " -nonewline; Write-Host "admin." -f Green
  } else {
    Write-Host "Running as " -nonewline; Write-Host "standard user." -f Red
    Write-Host "Reopen as admin? y/n"
    $key = $Host.UI.RawUI.ReadKey()
    if($key.Character -eq 'y') {
      gsudo C:\Users\toby.carter\AppData\Local\Microsoft\WindowsApps\wt.exe
    } elseif($key.Character -eq 'n') {
    } else {
      Write-Host ""
      Write-Host "Unexpected input '" -NoNewLine; Write-Host $key.Character -f Yellow -NoNewLine; Write-Host "'"
      Write-Host "Remaining as standard user. To open an admin window run the command:"
      Write-Host "gsudo C:\Users\toby.carter\AppData\Local\Microsoft\WindowsApps\wt.exe" -f Yellow
    }
  }
}

function cddot {
  cd $home\dotfiles
}

$PRIVATE:UtilsPath = "C:\Utils"
$DotfilesPath = "$home\dotfiles"
$PsScripts = "$DotfilesPath\windows\PsScripts"
#$AhkScripts = "$DotfilesPath\windows\AutoHotKeyScripts"
$WorkScripts = "$DotfilesPath\Work\Deltatre\PowershellScripts"
	
function EditProfile() { vi $profile }
function EditVimrc() { vi $home\_vimrc }
function EditHosts() { vi "C:\Windows\System32\Drivers\etc\hosts" }
function ShowScripts() {echo "Use CdScripts now for consistency, innit."}
function CdScripts() { cd "$PsScripts"}
function clls() { cls; ls} 
function cdls($path) { set-location $path; ls }
function cddot() { cd $DotfilesPath}
function cd..() { cdls .. }
echo "Use EditProfile EditHosts & EditVimrc to edit configuration"

# Common 3rd Party Apps
new-alias vi vim -Force
del alias:cat
new-alias cat bat -Force


# My aliases
del alias:cd
new-alias cd cdls -Force
new-alias prj C:\git\eviltobz\Vvec\Vvec.Prj\prj.ps1




write-host "Skipping VisualStudio setup" -f Yellow
#& "$PsScripts\SetupVisualStudio.ps1"
. 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\profile.example.ps1' choco
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
$env:Path += ";C:\Program Files\Git\bin"
# this should go in a work place...
#$env:Path += ";C:\Users\tcarter\.cargo\bin"



# Chocolatey profile
#$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
#if (Test-Path($ChocolateyProfile)) {
#  Import-Module "$ChocolateyProfile"
#}
Import-Module "c:\programdata\Chocolatey\helpers\chocolateyProfile.psm1"

Write-Host
gitas current

Set-PSReadlineOption -BellStyle None

# Set TLS - the default settings for what TLS is supported don't work with cmdlets that try to update things from MS's own sites. WTF?!?!
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


### wrap poshgit prompt with my own code - SHOULD BE COMPANY-SPECIFIC
# $poshGitPrompt = (Get-Command Prompt).ScriptBlock
# function prompt {
# $x = (& $poshGitPrompt)
# Write-Prompt "`nCHECK IF CSPROJ IS x-PRE-x>" -f RED
# " "
# }

admin
