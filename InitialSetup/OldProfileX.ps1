$SCRIPTS = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$env:path += ";$SCRIPTS"

$PROFILE = "$SCRIPTS\profile.ps1"

function EditProfile()
{
  vim $PROFILE
}

function EditVimrc()
{
  vim "$SCRIPTS\..\vim\_vimrc"
}
