$tfsPath = 'c:\tfs\SourceSafe Projects\'

function cd-tfs() { cd $tfsPath }

function git-update-submodules() {
  $command = 'git submodule update --remote --merge'
  Write-Host 'Executing command: ' -NoNewLine; Write-Host "$command" -ForegroundColor Yellow
  iex $command
}

function Build-CheckSolutionDependencies() {
  .\shared-settings\BuildShared\SolutionCommonFiles\powershell\CheckSolutionDependencies.ps1 . false
}

Import-Module "$($PSScriptRoot)\dev.psm1"


#$gitPath = 'd:\git'
#
#function cd-git() { cd $gitPath }
#function cd-source() { cd $gitPath\source }
#function cd-sourc2() { cd $gitPath\sourc2 }
#function cd-client($Code) { cd "$gitPath\source\ClientSpecific\$Code" }
#function ShowWorkScripts() { cd $PSScriptRoot }
#
#function acc()
#{
#  cd-source
#  iex ".\.build\PostBuild-Runners\TemplateAcceptanceTests-Local.bat $args"
#  echo "FullAcceptance return code: $LastExitCode"
#}
#function accQ()
#{
#  cd-source
#  iex ".\.build\PostBuild-Runners\TemplateAcceptanceTests-LocalQuick.bat $args"
#  echo "QuickAcceptance return code: $LastExitCode"
#}
#
#
##function bld()
##{
##  $arg = ""
##  if($args[0] -eq $null) {$arg = "QuickBuildAndTest"}
##  if($args[0] -eq "only") {$arg = "QuickBuild"}
##  if($args[0] -eq "nuget") {$arg = "QuickBuildAndNuget"}
##  if($args[0] -eq "full") {$arg = "FullBuild"}
##  if($args[0] -eq "clean") {$arg = "clean"}
##  if($arg -eq "") {echo "Defaults to QuickBuildAndTest. 'only' to run QuickBuild, 'nuget' for QuickBuildAndNuget, 'full' for FullBuild, 'clean' to remove bldTmp & run objkilla in the current directory"}
##  else
##  {
##    if($arg -eq "clean") {
##      if(Test-Path(".\bldTmp")) {
##        Write-Host "Removing bldTmp" -f Yellow
##        rm -r bldTmp
##      } else {
##        Write-Host "bldTmp not present" -f Yellow
##      }
##      objkilla commit
##    } else {
##      cd-source
##      iex ".\tobzhaxx_build.bat $arg"
##      echo "Build return code: $LastExitCode"
##    }
##  }
##}
#
#function facc()
#{
#  cd-source
#  iex ".\build.bat quickbuildandnuget"
#  if( "$LastExitCode" -eq "0")
#  {
#    iex ".\.build\PostBuild-Runners\TemplateAcceptanceTests-Local.bat LXA"
#  }
#}
#
##function getRootOfRepo() {
##  return getRootOfRepoImpl(New-Object IO.DirectoryInfo(pwd))
##}
##
##function getRootOfRepoImpl($dir) {
##  if( ($dir -eq $null) -or (test-path("$($dir.FullName)\.git")) ){
##    return $dir
##  } else {
##    return getRootOfRepoImpl($dir.Parent)
##  }
##}
##
##function buildPath([IO.DirectoryInfo]$dir, $item) {
##  return "$($dir.FullName)\$($item)"
##}
##
##function getSubFolder([IO.DirectoryInfo]$dir, $subDir) {
##  $path = buildPath $dir $subDir
##  if([IO.Directory]::Exists($path)){
##    return $path
##  } else {
##    return $null
##  }
##}
##
##function cdRepo() {
##  $path = getRootOfRepo
##  if($path -eq $null) {
##    Write-Host "You're not in a git repo!" -f Red
##  } else {
##    cd $path.FullName
##  }
##}
##
##function getFile([IO.DirectoryInfo]$dir, $fileName) {
##  $path = buildPath $dir $fileName
##  if([IO.File]::Exists($path)){
##    return $path
##  } else {
##    return $null
##  }
##}
##
##function removeFolder($dir, $subDir) {
##  $path = getSubFolder $dir $subDir
##  if($path -ne $null) {
##    Write-Host "Removing folder: " -nonewline; Write-Host $path -f Yellow
##    [IO.Directory]::Delete($path, $true)
##  }
##}
##
##function runBuildScript([IO.DirectoryInfo]$dir) {
##  $script = getFile $dir "run.cmd"
##  if($script -eq $null) {
##    Write-Host "Build script not found in $dir :("
##  } else {
##    iex $script
##  }
##}
##
##function tidyBuildDir([IO.DirectoryInfo]$dir) {
##  removeFolder $dir "bldTmp"
##  removeFolder $dir "yourmum"
##
##  objkilla commit
##}
##
##function rb()
##{
##  Write-Host "Running RootBuild for the current git repo"
##  $root = getRootOfRepo #New-Object IO.DirectoryInfo(pwd))
##  if($root -eq $null) {
##    Write-Host "You're not in a git repo!" -f Red
##  } else {
##    Write-Host "Git repo found in: " -nonewline; Write-Host $root -f Yellow
##    tidyBuildDir $root
##    runBuildScript $root
##  }
##}
##
#new-alias cds cd-source -Force
#new-alias cds2 cd-sourc2 -Force
#new-alias cdg cd-git -Force
#function cdlx { cd-client("LXA") }
#function cdly { cd-client("LY") }
#
##new-alias pkt1 .\.paket\paket.exe
##new-alias pkt2 .\packages\fake\Paket\tools\paket.exe
#
##function pkt() {
##  $locations = ".\packages\fake\Paket\tools\paket.exe", ".\.paket\paket.exe"
##  foreach($possibility in $locations) {
##    if(test-path $possibility) {
##      Write-Host "Running paket from " -nonewline; Write-Host $possibility -f Yellow
##      & $possibility $args
##    }
##  }
##}
#
#
#$pwd = pwd
#if( ("$pwd" -eq "C:\Users\toby.carter") -or ("$pwd" -eq "C:\tools\cmder") -or ("$pwd" -eq "E:\tobz\Cmder_mini"))
#{
#	cd-source
#}
#
#$QDrive = '\\15belowsbs\15Below\'
#
## General Work Utils
#$env:Path += ";$gitPath\eviltobz\loc\Loc\bin\Debug;" + "$gitPath\eviltobz\CommandLineUtils\objKilla\bin\Debug;" + "C:\Users\toby.carter\dotfiles\Work\15below\bins\pasngrlookup;"
##$env:Path += ";$UtilsPath\CliApps\OctopusDeployHelper;$UtilsPath\CliApps\Octopus2DeployHelper;C:\Utils\CliApps\BuildOctopusProject;C:\dev\sourc0\.paket"
#$dockerId = 'tobz15below'
#
#Import-Module "$($PSScriptRoot)\Build.psm1"

function UnGit() { mv "c:\TFS\SourceSafe Projects\.git" "c:\TFS\SourceSafe Projects\.git.TfsSux" }
function ReGit() { mv "c:\TFS\SourceSafe Projects\.git.TfsSux" "c:\TFS\SourceSafe Projects\.git" }

new-alias rbuild "msbuild -target:Rebuild -p:Configuration=Release -m"
#-WarnAsError
