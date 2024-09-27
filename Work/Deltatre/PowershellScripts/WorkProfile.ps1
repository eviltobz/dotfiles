# See Applied & 15b for more ideas about stuff to go in here...
Write-Host "Adding Deltatre WorkProfile" -f Yellow

$initialPath = (pwd).Path

$env:Path += ";C:\Tools\MongoDevTools;C:\Program Files\MongoDB\Server\4.4\bin;C:\Users\toby.carter\dotfiles\Work\Deltatre\bin" +
   ";C:\Program Files\TobzWorkUtils"

function EditWorkProfile() { vi  "$($PSScriptRoot)\WorkProfile.ps1" }
function cdwork() { cd "$PSScriptRoot"} #; ls }

function mods() {
  Write-Host "Loading work modules" -f Yellow
  Import-Module "$($PSScriptRoot)\dev.psm1" -force
  Import-Module "$($PSScriptRoot)\d.psm1" -force
  Import-Module "$($PSScriptRoot)\ec2.psm1" -force
}

mods

#Import-Module "$($PSScriptRoot)\dev.psm1"
#Import-Module "$($PSScriptRoot)\d.psm1"
#Import-Module "$($PSScriptRoot)\ec2.psm1"

Write-Host " --- Tooling Ideas ---" 
Write-Host "* retrieve, bump & push the git tag to rebuild a PR to push to Octopus" 
Write-Host " --- " 


Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
Enter-VsDevShell 74d0e2c3

$DOCKER_DISTRO = "Ubuntu"
function wdck {
  wsl -d $DOCKER_DISTRO docker -H unix:///mnt/wsl/shared-docker/docker.sock @Args
}

# just cd-ing borks build stuff. maybe check the current directory, & only cd if it's something known & crap?...
#cd c:\git
if ($initialPath -eq "C:\Users\toby.carter") {
  cd c:\git\dyn
  Write-Host "Current power profile:"
  pwr -view
#Write-Host "-----------------------------------" -f RED
#Write-Host "...cd into the new project dir foo!" -f RED
#Write-Host "-----------------------------------" -f RED
} else {
  cd $initialPath
}
#$alteredPath = pwd
#Write-Host "Changing path from " -f cyan -nonewline; Write-Host "$alteredPath" -f yellow -nonewline; write-host " to " -f cyan -nonewline; write-host "$initialPath" -f green
#cd $initialPath


#
#
#
#
# BIG FAT NOTE TO SELF:
# The d* functions below are temporary for the dockerfile pinning job. However, it could be well worth nicking some of it for the day-to-day DAZN stuff.
# Have a start branch thingy that'll take the Jira - maybe interrogate Jira to build up the rest of the name. 
#   create the appropriate feat/fix/whatever branch. Based on the change type, auto bump the version in all the right places
# Have a commit thingy that'll again do the right type, add the jira in, and prompt for the required rest of the message. 
#   is there a nice way to start the gitext commit window from the CLI? 
# Push and/or auto create PR? Double check stuff like the version bumping. 
#
# Temporary functions to aid in a task to pin versions in all dockerfiles for the DAZN project. 
# Prolly not much use once that's done, so fair to delete...
# There's a few helper functions & a few to be used directly at the command line:
#   dfiles - open the files that are likely to need changing after trying to automatically make what changes it can
#   dcommit - add all changed files to a new commit with appropriate message
#   drevcommit - REMOVING APK PINNING - add all changed files to a new commit with appropriate message
#   dpr - push to github & create PR with appropriate title & body
#   drevpr - REMOVING APK PINNING - push to github & create PR with appropriate title & body
#   ddiff - show the diff of the last commit
#   dversion - automatically bump the version without automatic changes to the dockerfiles
#   drevversion - REMOVING APK PINNING - set up branch & automatically bump the version without automatic changes to the dockerfiles
#
#
#   Also
#   I'm using it as a starting point for a general DAZN CLI tool, so to begin with, I'll add this helper function
#   to call it in general DAZN mode, before stripping out the pinning stuff so it only does that.
function dz() {
#C:\git\eviltobz\Investigations\DockerFilePinner\DockerFilePinner\bin\Debug\net6.0\dockerfilepinner.exe dz $args
#C:\git\eviltobz\DaznCli\DaznCli\bin\Debug\net6.0\DaznCli.exe $args
#C:\git\eviltobz\DaznCli\DaznCli\bin\Release\net6.0\DaznCli.exe $args
  C:\git\eviltobz\DaznCli\DaznCli\bin\Release\net7.0\DaznCli.exe $args
}
function dy() {
  C:\git\eviltobz\DynCli\bin\Release\net7.0\DynCli.exe $args
}
function tc() {
  C:\git\eviltobz\Vvec\Vvec.Cli.TestApp\bin\Debug\net7.0\Vvec.Cli.TestApp.exe $args
}

function dcommon() {
  gvim c:\git\dazn\common.dockerfile
}

function dfiles() {
  Write-Host "Skipping branch check stuff at the mo. Put this back if I go back to just churning through pinning dockerfile stuff" -f RED
#  dCheckBranch

#  [System.IO.FileInfo[]] $dockerfiles = get-childitem -recurse -include *dockerfile*
#  [System.IO.FileInfo[]] $csprojs = (get-childitem -recurse -include *.csproj) | Where-Object { $_.Name.ToLower().EndsWith("tests.csproj") -eq $false}
#  [System.IO.FileInfo[]] $changelogs = get-childitem -recurse -include changelog.md
#  [System.IO.FileInfo[]] $planspecs = get-childitem -recurse -include planspec.java
##Write-Host "Found $($dockerfiles.Length) dockerfile(s), $($csprojs.Length) .csproj(s), $($changelogs.Length) changelog(s), $($planspecs.Length) planspec(s)"
#  [System.IO.FileInfo[]] $files = $dockerfiles + $csprojs + $changelogs + $planspecs
#Write-Host $files -f cyan
#foreach ($file in $files) {
#Write-Host "  $file" -f cyan
#}
  $files = dGetFiles
  C:\git\eviltobz\Investigations\DockerFilePinner\DockerFilePinner\bin\Debug\net6.0\dockerfilepinner.exe $files
  gvim $files
}

function drevfiles() {
  [System.IO.FileInfo[]] $files = get-childitem -recurse -include *dockerfile*
#C:\git\eviltobz\Investigations\DockerFilePinner\DockerFilePinner\bin\Debug\net6.0\dockerfilepinner.exe $files
  gvim $files
}


function dversion() {
  $files = dGetFiles
  C:\git\eviltobz\Investigations\DockerFilePinner\DockerFilePinner\bin\Debug\net6.0\dockerfilepinner.exe versionbump $files
  gvim $files
}

function drevversion() {
  git checkout main
  dCheckBranch
  $files = dGetFiles
  C:\git\eviltobz\Investigations\DockerFilePinner\DockerFilePinner\bin\Debug\net6.0\dockerfilepinner.exe versionbump $files
  gvim $files
}

function dGetFiles() {
  [System.IO.FileInfo[]] $dockerfiles = get-childitem -recurse -include *dockerfile*
  [System.IO.FileInfo[]] $changelogs = get-childitem -recurse -include changelog.md
  [System.IO.FileInfo[]] $csprojs = (get-childitem -recurse -include *.csproj) | Where-Object { $_.Name.ToLower().EndsWith("tests.csproj") -eq $false}
  [System.IO.FileInfo[]] $planspecs = get-childitem -recurse -include planspec.java
#Write-Host "Found $($dockerfiles.Length) dockerfile(s), $($csprojs.Length) .csproj(s), $($changelogs.Length) changelog(s), $($planspecs.Length) planspec(s)"
  return [System.IO.FileInfo[]] $files = $dockerfiles + $changelogs + $csprojs + $planspecs
}

function dRevert() {
  Write-Host "Deleting last commit." -f RED 
  git reset --hard HEAD^
}



function dbranch() {
  Write-Host "Updating from main" -f Yellow
  git.exe pull --rebase --progress "origin" 
  Write-Host "Creating feature branch" -f Yellow
  git checkout -b "techdebt/HH-4738-pin-dependencies-in-dockerfiles"
  git checkout "techdebt/HH-4738-pin-dependencies-in-dockerfiles"
}

function dCheckBranch() {
  $branch = git branch --show-current
  if($branch.Contains("HH-4738") -eq $false) {
    Write-Host "Not on HH-4738 feature branch. Current branch is " -f Yellow -NoNewLine ; Write-Host $branch -f Red
    dbranch
  }
}

function dcommit() {
  dCheckBranch
#  $branch = git branch --show-current
#  if($branch.Contains("HH-4738") -eq $false) {
#    Write-Host "Not on HH-4738 feature branch! Current branch is " -f Yellow -NoNewLine ; Write-Host $branch -f Red
#    Write-Host "(Should I just do dbranch here?)" -f cyan
#    return
#  }
  Write-Host "Pre-Commit Status" -f Yellow
  git status
  dAddToGit
  Write-Host "Committing" -f Yellow
  git commit -m "refac: HH-4738 - pinning dependencies in dockerfiles"
  Write-Host "Post-Commit Status" -f Yellow
  git status
}

function drevcommit() {
  dCheckBranch
#  $branch = git branch --show-current
#  if($branch.Contains("HH-4738") -eq $false) {
#    Write-Host "Not on HH-4738 feature branch! Current branch is " -f Yellow -NoNewLine ; Write-Host $branch -f Red
#    Write-Host "(Should I just do dbranch here?)" -f cyan
#    return
#  }
  Write-Host "REVERTING APK PINNING" -f Yellow
  Write-Host "Pre-Commit Status" -f Yellow
  git status
  dAddToGit
  Write-Host "Committing" -f Yellow
  git commit -m "refac: HH-4738 - undoing pinning of apk version in dockerfiles"
  Write-Host "Post-Commit Status" -f Yellow
  git status
}

function dpr() {
  dCheckBranch

  Write-Host "Pushing branch to the hubbery" -f Yellow
  #git push -u --recurse-submodules=check --progress "origin" refs/heads/techdebt/HH-4738-pin-dependencies-in-dockerfiles:refs/heads/techdebt/HH-4738-pin-dependencies-in-dockerfiles
  git push -u --progress --set-upstream "origin" techdebt/HH-4738-pin-dependencies-in-dockerfiles #refs/heads/techdebt/HH-4738-pin-dependencies-in-dockerfiles:refs/heads/techdebt/HH-4738-pin-dependencies-in-dockerfiles

#$prTitle = "Pinning dependencies in dockerfiles - HH-4738"
#$prBodyFile = "~\dotfiles\Work\Deltatre\PowershellScripts\HH-4738-PR.txt"
  Write-Host "Creating PR" -f Yellow
  $prCommand = "gh pr create --title ""Pinning dependencies in dockerfiles - HH-4738"" --body-file c:\Users\toby.carter\dotfiles\Work\Deltatre\PowershellScripts\HH-4738-PR.txt"
#Write-Host $prCommand
  iex $prCommand
gh pr create --title "Pinning dependencies in dockerfiles - HH-4738" --body-file c:\Users\toby.carter\dotfiles\Work\Deltatre\PowershellScripts\HH-4738-PR.txt
}

function drevpr() {
  dCheckBranch

  Write-Host "REVERTING APK PINNING" -f Yellow
  Write-Host "Pushing branch to the hubbery" -f Yellow
  #git push -u --recurse-submodules=check --progress "origin" refs/heads/techdebt/HH-4738-pin-dependencies-in-dockerfiles:refs/heads/techdebt/HH-4738-pin-dependencies-in-dockerfiles
  git push -u --progress --set-upstream "origin" techdebt/HH-4738-pin-dependencies-in-dockerfiles #refs/heads/techdebt/HH-4738-pin-dependencies-in-dockerfiles:refs/heads/techdebt/HH-4738-pin-dependencies-in-dockerfiles

#$prTitle = "Pinning dependencies in dockerfiles - HH-4738"
#$prBodyFile = "~\dotfiles\Work\Deltatre\PowershellScripts\HH-4738-PR.txt"
  Write-Host "Creating PR" -f Yellow
  $prCommand = "gh pr create --title ""Unpinning apk version in dockerfiles - HH-4738"" --body-file c:\Users\toby.carter\dotfiles\Work\Deltatre\PowershellScripts\HH-4738-PR-REV.txt"
#Write-Host $prCommand
  iex $prCommand
#gh pr create --title "Pinning dependencies in dockerfiles - HH-4738" --body-file c:\Users\toby.carter\dotfiles\Work\Deltatre\PowershellScripts\HH-4738-PR.txt
}

function dAddToGit() {
  [System.String[]]$changes = git status --porcelain
  $addString = ""
  foreach ($change in $changes) {
    $compare = $change.ToLower()
    if ($compare.Contains("dockerfile") -or ($compare.EndsWith(".csproj") -and $compare.EndsWith("tests.csproj") -eq $false) -or $compare.EndsWith("changelog.md") -or $compare.EndsWith("planspec.java")) {
      $index = $compare.LastIndexOf("/")
      $addString = $addString + " '" + $change.Substring(3) + "'"
    }
  }
  if ($addString -ne "") {
    Write-Host "git add " -f Yellow -NoNewLine ; Write-Host $addString -f Cyan
    iex "git add $addString"
  }
}

function ddiff() {
  [System.String[]]$changes = git status --porcelain
  if($changes.Length -eq 0) {
    Write-Host "No uncommitted changes. Showing diff of last commit" -f Yellow
    git log HEAD^..HEAD
    Write-Host "Press any key to continue..."
    $ignore = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    git diff HEAD~1
  } else {
    Write-Host "Showing uncommitted changes" -f Yellow
    Write-Host "Press any key to continue..."
    $ignore = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    git diff
  }
}

