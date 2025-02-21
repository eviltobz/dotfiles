# See Applied & 15b for more ideas about stuff to go in here...
Write-Host "Adding Accurx WorkProfile" -f Yellow

$initialPath = (pwd).Path

# $env:Path += ";C:\Users\toby.carter\dotfiles\Work\Deltatre\bin" +
#    ";C:\Program Files\TobzWorkUtils"

function EditWorkProfile() { vi  "$($PSScriptRoot)\WorkProfile.ps1" }
function cdwork() { cd "$PSScriptRoot"} #; ls }

function mods() {
  Write-Host "Loading work modules" -f Yellow
  Import-Module "$($PSScriptRoot)\dev.psm1" -force
  # Import-Module "$($PSScriptRoot)\d.psm1" -force
  # Import-Module "$($PSScriptRoot)\ec2.psm1" -force
}

mods

#Import-Module "$($PSScriptRoot)\dev.psm1"
#Import-Module "$($PSScriptRoot)\d.psm1"
#Import-Module "$($PSScriptRoot)\ec2.psm1"

# Write-Host " --- Tooling Ideas ---" 
# Write-Host "* retrieve, bump & push the git tag to rebuild a PR to push to Octopus" 
# Write-Host " --- " 


# Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
# Enter-VsDevShell 74d0e2c3

# $DOCKER_DISTRO = "Ubuntu"
# function wdck {
#   wsl -d $DOCKER_DISTRO docker -H unix:///mnt/wsl/shared-docker/docker.sock @Args
# }


# Azure gubbins
$ENV:PYTHONPATH = "C:\\Program Files\\Microsoft SDKs\\Azure\\CLI2"


if ($initialPath -eq "C:\Users\Toby Carter") {
  set-location C:\code\Accurx\rosemary
} else {
  cd $initialPath
}

