.\ConfigureBaseGit.ps1

git config --global user.name "eviltobz"
git config --global user.email "eviltobz@hotmail.com"

$sshKeyPath = "$home\.ssh\id_rsa"
if(!$(Test-Path $sshKeyPath))
{
  echo "Can't find $sshKeyPath"
}
