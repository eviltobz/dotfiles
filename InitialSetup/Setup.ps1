$currentDir = Split-Path -parent $MyInvocation.MyCommand.Definition

function RedirectVimrc()
{
  $vimrcPath = "$HOME\_vimrc"
  if(Test-Path $vimrcPath)
  {
    $vimrc = ls $vimrcPath
    if($vimrc.Length -eq 0)
    {
      rm $vimrcPath
    }
    else
    {
      echo "Backing up old vimrc"
      mv $vimrcPath .\OldVimrc
    }
  }
  cmd /c mklink $vimrcPath "$currentDir\..\vim\_vimrc"
}

function RedirectProfile()
{
  $OldProfile = "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
  if($OldProfile -ne $PROFILE)
  {
    echo "Not redirecting profile. Current profile: $PROFILE" 
    echo "Expected: $OldProfile"
  }
  else
  {
    if(Test-Path $OldProfile)
    {
      echo "Backing up old powershell profile"
      mv $OldProfile .\OldProfile.ps1
    }
    $newProfile = ". $currentDir\..\PsScripts\profile.ps1"
    echo "new profile path: $newProfile"
    echo "Setting profile contents to $newProfile"
    echo $newProfile > $PROFILE
  }
}

function InstallPsGet()
{
  (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | Invoke-Expression
}

$MODULEHOME = $env:PSModulePath.Split(";")[0]

InstallPsGet
Install-Module posh-git
cp Powertab $MODULEHOME

RedirectVimrc
RedirectProfile
