
function getRootOfRepo() {
  return getRootOfRepoImpl(New-Object IO.DirectoryInfo(Get-Location))
}

function getRootOfRepoImpl($dir) {
  if( ($null -eq $dir) -or (test-path("$($dir.FullName)\.git")) ){
    return $dir
  } else {
    return getRootOfRepoImpl($dir.Parent)
  }
}

function CdApplied() {
  LoadConfig
  if($script:settingsGitPath -eq "") {
    Write-Host "GitPath is not configured" -ForegroundColor Red
    return
  }

  Set-Location "$($script:settingsGitPath)"
}

function CdRepoRoot() {
  if((silentCdRepo) -eq $false) {
     Write-Host "You're not in a git repo!" -f Red
  }
}

function TryCdRepoRoot() {
  if((silentCdRepo) -eq $false) {
     Write-Host "You're not in a git repo!" -f Red
     return $false
  }
  return $true
}

function silentCdRepo() {
  $path = getRootOfRepo
  if($null -eq $path) {
    return $false
  } else {
    Set-Location $path.FullName
    return $true
  }
}

function GitUpdateSubmodules() {
  if((TryCdRepoRoot) -eq $false) {
    return
  }
  $command = 'git submodule update --remote --merge'
  Write-Host 'Executing command: ' -NoNewLine; Write-Host "$command" -ForegroundColor Cyan
  Invoke-Expression $command
}

function CheckScripts($arg) {
  if((TryCdRepoRoot) -eq $false) {
    return
  }
  Write-Host "Starting post-build checks" -ForegroundColor Cyan
  $verbose = "false"
  if(($null -ne $script:args[1]) -AND ($script:args[1].ToLower() -eq "verbose")) {$verbose = "true"}
  .\shared-settings\BuildShared\SolutionCommonFiles\powershell\CheckSolutionDependencies.ps1 . $verbose
  Write-Host "Completed post-build checks" -ForegroundColor Green
}

function InstallNugets() {
  $configs = Get-ChildItem "packages.config" -Recurse
  foreach ($config in $configs) {
    Write-Host "Installing nugets for $config" -ForegroundColor Cyan
    $command = "nuget install -OutputDirectory '.\packages' '$config'"
    Invoke-Expression $command
  }
}

function Build () {
  Write-Host "Skipping TryCdRepoRoot" -ForegroundColor Red
  # if((TryCdRepoRoot) -eq $false) {
  #   return
  # }
  Write-Host "Building solution" -ForegroundColor Cyan
  $msbuild = 'c:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe'
  # TeamCity does a clean pull from source control, so add the Rebuild for local dev builds
  # NoWarn value taken from TC builds
  $buildArgs = '/t:Rebuild /p:Configuration=Release /p:Platform="Any CPU" /p:NoWarn="0618"' 
  InstallNugets
  $command = ". '$msbuild' $buildArgs"
  Invoke-Expression $command
}

function RunUnitTests () {
  if((TryCdRepoRoot) -eq $false) {
    return
  }
  Write-Host "Starting unit tests" -ForegroundColor Cyan
  $vstest = 'c:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\Extensions\TestPlatform\vstest.console.exe'
  Write-Host "Looking for test libraries"
  $specs = Get-ChildItem -Recurse *.specifications.dll
  $tests1 = Get-ChildItem -Recurse *.tests.dll
  $tests2 = Get-ChildItem -Recurse *.tests.*.dll
  [System.IO.FileInfo[]] $allTests = $specs + $tests1 + $tests2
  [System.Collections.Generic.List[String]] $distinctTests = [System.Collections.Generic.List[String]]::new()
  foreach ($test in $allTests) {
    if($test.FullName.ToLower().Contains("\bin\release\")) {
      if($distinctTests.Contains($test.FullName) -eq $false) {
        $distinctTests.Add($test.FullName)
      }
    }
  }

  if($distinctTests.Count -eq 0) {
    Write-Host "No unit tests found in this solution" -ForegroundColor Magenta
    return
  }

  Write-host "Found $($distinctTests.Count) test libraries"
  $fileNames = ""
  foreach ($test in $distinctTests) {
    $fileNames = $fileNames + " '$test'"
  }
  $command = ". '$vstest' $fileNames /Platform:x86" 

  Invoke-Expression $command
}

function FullBuild () {
  Write-Host "Starting full build process" -ForegroundColor Cyan
  Build
  if($LASTEXITCODE -ne 0) {
    Write-Host "Failed Full Build at Build step. Aborting run." -ForegroundColor Red
    return
  }
  RunUnitTests
  if($LASTEXITCODE -ne 0) {
    Write-Host "Failed Full Build at Testing step. Aborting run." -ForegroundColor Red
    return
  }
  CheckScripts
}

function CloneOrUpdateRepo([string] $name, [string] $url) {
    if(Test-Path($name)) {
        Set-Location "$name"

        $currentBranch = git branch --show-current
        if($currentBranch -ne 'master') {
            Write-Host "Repo '" -ForegroundColor Red -NoNewline
            Write-Host "$name" -ForegroundColor Yellow -NoNewline
            Write-Host "' is on branch '" -ForegroundColor Red -NoNewline
            Write-Host "$currentBranch" -ForegroundColor Yellow -NoNewline
            Write-Host "' not 'master'. Not updating!" -ForegroundColor Red
            return $false
        }

        [string[]]$state = git status --porcelain=1
        if($null -ne $state) {
            Write-Host "Repo '" -ForegroundColor Red -NoNewline
            Write-Host "$name" -ForegroundColor Yellow -NoNewline
            Write-Host "' has " -ForegroundColor Red -NoNewline
            Write-Host "$($state.Length)" -ForegroundColor Yellow -NoNewline
            Write-Host " local changes. Not updating!" -ForegroundColor Red
            return $false
        }

        Write-Host "Repo '" -ForegroundColor Cyan -NoNewline
        Write-Host "$name" -ForegroundColor Yellow -NoNewline
        Write-Host "' already exists. Pulling latest... " -ForegroundColor Cyan -NoNewline
        [string[]]$gitPull = git pull origin
        if($gitPull.Length -lt 2) {
          if("Already up to date." -ne $gitPull) {
            Write-Host "`nUnexpected git response: '$gitPull'"
            return $false
          }
          Write-Host $gitPull
        } else {
          Write-Host $gitPull[0]
          foreach ($item in $gitPull) {
            if($item.Contains("files changed") -or $item.Contains("file changed")) {
              Write-Host "  $($item.Trim())"
            }
          }
          $subModPull = git submodule update --init --recursive
          if($null -ne $subModPull) {
            Write-Host "  $subModPull"
          }
        }

    } else {
        Write-Host "Found new repo: $name. Cloning..." -ForegroundColor Yellow
        git clone "$url"
        Set-Location "$name"
        $subModPull = git submodule update --init --recursive
        Write-Host "  $subModPull"
    }
    return $true
}

function GitLabPullAll() {
  LoadConfig
  if($script:settingsGitLabApiToken -eq "") {
    Write-Host "GitLabApiToken is not configured" -ForegroundColor Red
    return
  }
  if($script:settingsGitPath -eq "") {
    Write-Host "GitPath is not configured" -ForegroundColor Red
    return
  }
  CdApplied

  $regencyTeamId = "9935553"
  $rootUrl =  "https://gitlab.com/api/v4/groups/$regencyTeamId/projects?simple=true"

  $response = Invoke-WebRequest -Uri "$rootUrl" -Method:Get -Headers @{"PRIVATE-TOKEN"="$($script:settingsGitLabApiToken)"} 
  $allRepos = ConvertFrom-Json $response.Content

  Write-Host "Found " -ForegroundColor Yellow -NoNewline; 
  Write-Host "$($allRepos.Length)" -ForegroundColor Green -NoNewline;
  Write-Host " GitLab repos" -ForegroundColor Yellow

  $currentDir = Get-Location
  $success = 0;
  $failure = 0;
  foreach ($repo in $allRepos) {
      $result = CloneOrUpdateRepo $repo.Name $repo.http_url_to_repo
      if($result -eq $true) {$success = $success + 1}
      else {if($result -eq $false) {$failure = $failure + 1}
      else {write-host "CloneOrUpdateRepo result = '$result'"} }
      Set-Location $currentDir
  }
  Write-Host "--------------------"
  if($success -gt 0) {
      Write-Host "Successfully updated " -ForegroundColor Green -NoNewline
      Write-Host "$success" -ForegroundColor Yellow -NoNewline
      Write-Host " repos." -ForegroundColor Green
  }
  if($failure -gt 0) {
      Write-Host "Failed to update " -ForegroundColor Red -NoNewline
      Write-Host "$failure" -ForegroundColor Yellow -NoNewline
      Write-Host " repos." -ForegroundColor Red
  }

}

function SaveConfig() {
  [string[]] $settings = @("GitPath=$($script:settingsGitPath)",
    "GitLabApiToken=$($script:settingsGitLabApiToken)")
  [System.IO.File]::WriteAllLines($script:settingsFile, $settings);
  Write-Host "Updated config in $($script:settingsFile)" -ForegroundColor Magenta
}
function LoadConfig() {
  if((Test-Path $script:settingsFile) -eq $false) {
    return
  }

  $lines = [System.IO.File]::ReadAllLines($script:settingsFile);
  foreach ($line in $lines) {
    $split = $line.split('=')
    if($split[0] -eq "GitPath") { $script:settingsGitPath = $split[1] }
    if($split[0] -eq "GitLabApiToken") { $script:settingsGitLabApiToken = $split[1] }
  }
}

function DisplayConfig() {
  LoadConfig
  Write-Host "GitPath:        " -ForegroundColor Yellow -NoNewline
  if($script:settingsGitPath -eq "") {
    Write-Host "Not Set" -ForegroundColor Red
  } else {
    Write-Host "$script:settingsGitPath" -ForegroundColor Cyan
  }

  Write-Host "GitLabApiToken: " -ForegroundColor Yellow -NoNewline
  if($script:settingsGitLabApiToken -eq "") {
    Write-Host "Not Set" -ForegroundColor Red
  } else {
    Write-Host "$script:settingsGitLabApiToken" -ForegroundColor Cyan
  }

}

function Config() {
  if(($null -ne $script:args[1]) -and ($null -ne $script:args[2])) {
    $key = $script:args[1]
    $val = $script:args[2]

    $updated = $false
    if($key -eq "GitPath") {
      $script:settingsGitPath = $val
      $updated = $true
    }
    if($key -eq "GitLabApiToken") {
      $script:settingsGitLabApiToken = $val
      $updated = $true
    }
    if($updated -eq $false) {
      Write-Host "Unknown config field: " -ForegroundColor Red -NoNewline
      Write-Host "$key" -ForegroundColor Yellow
    }
    if($updated) {
      SaveConfig
    }

  }
  DisplayConfig
}

#function WslVer() {
#  if(($null -eq $script:args[1]) -or ($null -eq $script:args[2])) {
#    displayUsage
#    return
#  }
#
#  $version = $script:args[1]
#  $distro = $script:args[2]
#  wsl --set-version $distro $version
#}

function WslVerToggle() {
  if($null -eq $script:args[1]) {
    Write-Host "WSL distros:" -ForegroundColor Yellow
    wsl -l -v
    return
  }
  $distro = $script:args[1].ToUpperInvariant()
  $output = wsl -l -v
#  Write-Host "Looking for [$distro] ($($distro.GetType()))" -f cyan
#  Write-Host "match: $("* UbuA                   Stopped         2".Contains($distro))" -f cyan
#  $meh = $output[2].Replace([string][char]0, "")
#  Write-Host "line: $meh"
#  Write-Host "match: $($meh.Contains($distro))" -f cyan
#  Write-Host "Line Chars:"
#  foreach ($char in $meh.ToCharArray()) {
#    write-host "[$($char):$([byte][char]$char)] " -NoNewLine
#  }
#  Write-Host ""
#
#  Write-Host "Distro Chars:"
#  foreach ($char in $distro.ToCharArray()) {
#    write-host "[$($char):$([byte][char]$char)] " -NoNewLine
#  }
#  Write-Host ""

  $notFound = $true

  foreach ($line in $output) {
    $line = $line.Replace([string][char]0, "").ToUpperInvariant()
    if ($line.Contains(" $($distro.ToUpperInvariant()) ")) {
      $notFound = $false
#Write-Host "[$line]" -f yellow
#Write-Host "match: $($line.Contains($distro))" -f cyan
      $verString = $line[$line.Length - 1]
#Write-Host "Version: $verString"
      if($verString -eq "1") {
        Write-Host "Upgrading " -ForegroundColor Yellow -NoNewLine
        Write-Host "$distro " -ForegroundColor Cyan -NoNewLine
        Write-Host "to WSL 2" -ForegroundColor Yellow
        wsl --set-version $distro 2
      } elseif($verString -eq "2") {
        Write-Host "Downgrading " -ForegroundColor Yellow -NoNewLine
        Write-Host "$distro " -ForegroundColor Cyan -NoNewLine
        Write-Host "to WSL 1" -ForegroundColor Yellow
        wsl --set-version $distro 1
      } else {
        Write-Host "Unexpected version: $verString" -ForegroundColor Red
        Write-Host "WSL description: $line" -ForegroundColor Red
      }
    }
  }
  if($notFound) {
      Write-Host "Distro " -ForegroundColor Red -NoNewLine
      Write-Host "$distro" -ForegroundColor Yellow -NoNewLine
      Write-Host " not found" -ForegroundColor Red -NoNewLine

  }
}


function DisplayCommand($command) {
  if($command[0] -eq "") {
    return
  }
  Write-Host "  $($command[0])".PadRight(12) -f Yellow -nonewline; 
  if($command.Length -eq 2) {
    Write-Host "- $($command[1])"
  } else {
    Write-Host "- $($command[2])"
  }
}

function GetCommand($argCommand) {
  if($null -eq $argCommand) {
    return $null
  }

  $expected = $argCommand.ToLower()
  foreach($command in $allCommands) {
    if($command -eq $expected) {
      return $command[1]
    }
  }
  Write-Host "Unknown command: " -nonewline ; Write-Host $argCommand -f Yellow
  return $null
}

function DisplaySection($title, $section) {
    Write-Host " $title" -f Green

    if($section[0].GetType() -eq "the type of a string".GetType()) {
      DisplayCommand $section
    } else {
      foreach($command in $section){
        DisplayCommand $command
      }
    }
  }

function displayUsage() {
  Write-Host "Usage: " -NoNewline -ForegroundColor Cyan 
  Write-Host " dev [command] [args]"

  DisplaySection "Build shortcuts" $buildCommands
  DisplaySection "Git shortcuts" $gitCommands
  DisplaySection "WSL shortcuts" $wslCommands
  DisplaySection "Config" $configCommands
}


function dev () {
  $a = GetCommand $args[0]
  $Script:Arg = $args[1] 
  $script:args = $args

  if(!$a) {
    displayUsage
  } else {
    Invoke-Expression $a
  }
}

$script:settingsFile = "$($script:MyInvocation.MyCommand.Path).ini"
$script:settingsGitPath = ""
$script:settingsGitLabApiToken = "" 

$gitCommands = @(
  @("git", "CdApplied", "Go to the main Applied git folder"),
  @("root", "CdRepoRoot", "Go to the root folder of the current git repo"),
  @("sub", "GitUpdateSubmodules", "Update the submodules to point to their latest commit"),
  @("update", "GitLabPullAll", "Pull/clone all of the GitLab repos")
  )

$buildCommands = @(
  @("bld", "Build", "Build the solution"),
  @("tst", "RunUnitTests", "Run the unit tests"),
  @("chk", "CheckScripts", "Run the post-build check scripts. Add ""verbose"" for logging output"),
  @("full", "FullBuild", "Build the solution, run the tests and the post-build checks")
  )

$configCommands = @(
  @("config", "Config", "Configure settings. Call without args to display config, or [config item name] [value] to set."),
  @("", "", "") # Have a blank at the end because powershell arrays are mental
)

$wslCommands = @(
  @("ver", "WslVerToggle", "Toggle the WSL version for the specified distro. dev ver [distro name]."),
  @("", "", "") # Have a blank at the end because powershell arrays are mental
)

$allCommands = $buildCommands + $gitCommands + $wslCommands + $configCommands

Export-ModuleMember -Function dev
