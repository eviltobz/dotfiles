
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

function CdWork($dir) {
  Set-Location $dir
  ls
}

function GitExtensionsHere() {
  Write-Host "Starting Git Extensions in: " -NoNewLine ; Write-Host "$(pwd)" -f Yellow
  & "C:\Program Files\GitExtensions\GitExtensions.exe" browse .
# gitex browse .
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

#function TryOpenSlnInStudio () {
#  if((TryCdRepoRoot) -eq $false) {
#    [System.IO.FileInfo[]] $slns = Get-ChildItem *.sln
#    if( $slns.Length -ne 1) {
#      echo "horky borky"
#      return
#    }
#    Write-Host "Found .sln in current directory" -ForegroundColor Yellow
#  }
#  [System.IO.FileInfo[]] $slns = Get-ChildItem *.sln
#  if( $slns.Length -eq 1) {
#    $exe = """C:\Program Files (x86)\Common Files\Microsoft Shared\MSEnv\VSLauncher.exe"""
#    $mode = "Version Selector"
#
#    if($script:args[1] -eq "1") {
#      $exe = """C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe"""
#      $mode = "VS 2019"
#    }
#    if($script:args[1] -eq "2") {
#      $exe = """C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"""
#      $mode = "VS 2022"
#    }
#    Write-Host "Opening " -NoNewLine; Write-Host $slns[0].Name -f Yellow -NoNewLine ; Write-Host " in " -NoNewLine ; Write-Host $mode -f Yellow
#    $command = "& $exe ""$($slns[0].FullName)"""
#    Invoke-Expression $command
#  } else {
#    Write-Host "Can only open Visual Studio if there is 1 .sln file in the root. $($slns.Length) .slns were found" -f Red
#  }
#}

function TryOpenSlnInStudio () {
  [System.IO.FileInfo[]] $slns = Get-ChildItem *.sln
  if( $slns.Length -eq 0) {

    if((TryCdRepoRoot) -eq $false) {
      [System.IO.FileInfo[]] $slns = Get-ChildItem *.sln
      if( $slns.Length -ne 1) {
        echo "horky borky"
        return
      }
      Write-Host "Found .sln in current directory" -ForegroundColor Yellow
    }
  }
  [System.IO.FileInfo[]] $slns = Get-ChildItem *.sln
  if( $slns.Length -eq 0) {
    Write-Host "No .sln files were found!" -f Red
  }
  elseif( $slns.Length -eq 1) {
    OpenSlnInStudio($slns[0])
  } else {
    Write-Host "Multiple .sln files found. Which do you want to open?" -f Yellow
    for($index=0; $index -lt $slns.Length; $index++)
    {
      Write-Host "$index" -f Green -NoNewLine ; Write-Host ") $($slns[$index].Name)" 
    }
    $selection = Read-Host "Enter a number, or anything else to abort"
    if(($selection -ge 0) -AND ($selection -lt $slns.Length))
    {
      OpenSlnInStudio($slns[$selection])
    }
    else
    {
      Write-Host "Aborting." -f Red
    }
  }
}

function OpenSlnInStudio ($solutionFile) {
    $exe = """C:\Program Files (x86)\Common Files\Microsoft Shared\MSEnv\VSLauncher.exe"""
    $mode = "Version Selector"

    if($script:args[1] -eq "1") {
      $exe = """C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe"""
      $mode = "VS 2019"
    }
    if($script:args[1] -eq "2") {
      $exe = """C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"""
      $mode = "VS 2022"
    }
    Write-Host "Opening " -NoNewLine; Write-Host $solutionFile.Name -f Yellow -NoNewLine ; Write-Host " in " -NoNewLine ; Write-Host $mode -f Yellow
    $command = "& $exe ""$($solutionFile.FullName)"""
    Invoke-Expression $command
}

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
  DisplaySection "Editor shortcuts" $editorCommands
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
  # @("d", "CdDyn", "Go to the Dyn git folder"),
  # @("db", "CdDyn('\dyn-backend')", "Go to the dyn-backend git folder"),
  # @("a", "CdAxis", "Go to the Axis git folder"),
  @("r", "CdWork('C:\code\accurx\rosemary')", "Go to the main accurx git folder"),
#@("d", "CdDazn", "Go to the DAZN git folder"),
#@("dc", "CdDaznClient", "Go to the DAZN-CLIENT-OWNED git folder"),
#@("d3", "CdDaznD3", "Go to the DAZN-D3 git folder"),
  @("git", "GitExtensionsHere", "Open current folder in git extensions"),
  @("root", "CdRepoRoot", "Go to the root folder of the current git repo"),
  @("sub", "GitUpdateSubmodules", "Update the submodules to point to their latest commit")
#@("update", "GitLabPullAll", "Pull/clone all of the GitLab repos")
  )
$editorCommands = @(
  @("st", "TryOpenSlnInStudio", "Open the repo's .sln file in Visual Studio. Add arg 1 or 2 to force opening with VS2019 or VS2022."),
  @("", "", "") # Have a blank at the end because powershell arrays are mental
  )

# $buildCommands = @(
#   @("bld", "Build", "Build the solution"),
#   @("tst", "RunUnitTests", "Run the unit tests"),
#   @("chk", "CheckScripts", "Run the post-build check scripts. Add ""verbose"" for logging output"),
#   @("full", "FullBuild", "Build the solution, run the tests and the post-build checks")
#   )

# $configCommands = @(
#   @("config", "Config", "Configure settings. Call without args to display config, or [config item name] [value] to set."),
#   @("", "", "") # Have a blank at the end because powershell arrays are mental
# )

$wslCommands = @(
  @("ver", "WslVerToggle", "Toggle the WSL version for the specified distro. dev ver [distro name]."),
  @("", "", "") # Have a blank at the end because powershell arrays are mental
)

# $allCommands = $buildCommands + $gitCommands + $editorCommands + $wslCommands + $configCommands
$allCommands = $gitCommands + $editorCommands + $wslCommands 

Export-ModuleMember -Function dev
