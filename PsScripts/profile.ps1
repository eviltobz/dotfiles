function EditProfile()
{
  vim $PROFILE
}

function EditVimrc()
{
  vim "$SCRIPTS\..\vim\_vimrc"
}

Import-Module PsGet

$SCRIPTS = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$env:path += ";$SCRIPTS"

$PROFILE = "$SCRIPTS\profile.ps1"
. "$SCRIPTS\PoshGitProfile.ps1"
