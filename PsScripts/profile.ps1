function Get-Batchfile ($file) {
    $cmd = "`"$file`" & set"
    cmd /c $cmd | Foreach-Object {
        $p, $v = $_.split('=')
        Set-Item -path env:$p -value $v
    }
}
  
function VsVars32($version = "10.0")
{
    $key = "HKLM:SOFTWARE\Microsoft\VisualStudio\" + $version
    $VsKey = get-ItemProperty $key
    $VsInstallPath = [System.IO.Path]::GetDirectoryName($VsKey.InstallDir)
    $VsToolsDir = [System.IO.Path]::GetDirectoryName($VsInstallPath)
    $VsToolsDir = [System.IO.Path]::Combine($VsToolsDir, "Tools")
    $BatchFile = [System.IO.Path]::Combine($VsToolsDir, "vsvars32.bat")
    Get-Batchfile $BatchFile
    [System.Console]::Title = "Visual Studio " + $version + " Windows Powershell"
    #add a call to set-consoleicon as seen below...hm...!
}

function EditProfile()
{
  vim $PROFILE
}

function EditVimrc()
{
  vim "$SCRIPTS\..\vim\_vimrc"
}

$MODULEHOME = $env:PSModulePath.Split(";")[0]
Import-Module PsGet
#Import-Module Powertab
Import-Module "PowerTab" -ArgumentList "C:\Users\tobz\Documents\WindowsPowerShell\PowerTabConfig.xml"

$SCRIPTS = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$env:path += ";$SCRIPTS"

$PROFILE = "$SCRIPTS\profile.ps1"
. "$SCRIPTS\PoshGitProfile.ps1"

VsVars32
