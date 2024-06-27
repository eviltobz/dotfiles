$dynRoot = "c:\git\Dyn"

function CdPath($dir) {
  Set-Location $dir
  ls
}

function CdDyn($subFolder) {
  Set-Location "$dynRoot\$subfolder"
  ls
}

function CdAxis() {
  Set-Location "c:\git\Axis"
  ls
}


function DisplayCommand($command) {
  if($command[0] -eq "") {
    return
  }
  Write-Host "  $($command[0])".PadRight(7) -f Yellow -nonewline; 
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

function promptForCd() {
  Write-Host " Dyn Folders" -f Green
  $items = Get-ChildItem $dynRoot
  $count = 1

  Write-Host "  [" -NoNewLine; Write-Host 0 -f Yellow -NoNewLine; Write-Host "] /git/dyn"
  foreach($item in $items) {
      if($item.Attributes -eq "Directory")
      {
          $name = $item.Name.Replace("dyn-", "")
          Write-Host "  [" -NoNewLine; Write-Host $count -f Yellow -NoNewLine; Write-Host "] $name"
          $count++
      }
  }

  $selected = Read-Host "Select folder"

  $count = 1
  if("0" -eq $selected) {
      cd $dynRoot
  }
  foreach($item in $items) {
      if($item.Attributes -eq "Directory")
      {
          if($count -eq $selected) {
              cd $item.FullName
          }
          $count++
      }
  }
}

function displayUsage() {
  Write-Host "Usage: " -NoNewline -ForegroundColor Cyan 
  Write-Host " dev [command]"

  DisplaySection "cd shortcuts" $cdCommands
}


function d () {
  $a = GetCommand $args[0].ToString()
  $Script:Arg = $args[1] 
  $script:args = $args

  if(!$a) {
    displayUsage
    promptForCd
  } else {
    Invoke-Expression $a
  }
}


$cdCommands = @(
  @("0", "CdDyn('')", "/git/dyn"),
  @("c", "CdDyn('dyn-axis-svc-catalog')", "dyn-axis-svc-catalog"),
  @("b", "CdDyn('dyn-backend/utilities')", "dyn-backend/utilities"),
  @("br", "CdDyn('dyn-backend')", "dyn-backend (root)"),
#@("e", "CdDyn('dyn-backend-entitlements')", "dyn-backend-entitlements"),
#@("f", "CdDyn('dyn-backend-favorites')", "dyn-backend-favourites"),
#@("d", "CdDyn('dyn-dips')", "dyn-backend-dips"),
#@("n", "CdDyn('dyn-nightwatch')", "dyn-nightwatch"),
  @("r", "CdDyn('dyn-rocket')", "dyn-rocket"),

  @("a", "CdAxis", "Go to the Axis git folder"),
  @("rand", "CdPath('C:\git\RandomClientBits')", "Go to the RandomClientBits git folder")
  )

$allCommands = $cdCommands

Export-ModuleMember -Function d
