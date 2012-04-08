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
  if(Test-Path $PROFILE)
  {
    echo "Backing up old powershell profile"
    mv $PROFILE .\OldProfile.ps1
  }
  $newProfile = ". $currentDir\..\PsScripts\profile.ps1"
  echo "Setting profile contents to $newProfile"
  echo $newProfile > $PROFILE
}

RedirectVimrc
RedirectProfile

