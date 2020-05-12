function BuildSource()
{
  $arg = ""
  if($args[0] -eq $null) {$arg = "QuickBuildAndTest"}
  if($args[0] -eq "only") {$arg = "QuickBuild"}
  if($args[0] -eq "nuget") {$arg = "QuickBuildAndNuget"}
  if($args[0] -eq "full") {$arg = "FullBuild"}
  if($args[0] -eq "clean") {$arg = "clean"}
  if($arg -eq "") {echo "Defaults to QuickBuildAndTest. 'only' to run QuickBuild, 'nuget' for QuickBuildAndNuget, 'full' for FullBuild, 'clean' to remove bldTmp & run objkilla in the current directory"}
  else
  {
    if($arg -eq "clean") {
      if(Test-Path(".\bldTmp")) {
        Write-Host "Removing bldTmp" -f Yellow
        rm -r bldTmp
      } else {
        Write-Host "bldTmp not present" -f Yellow
      }
      objkilla commit
    } else {
      cd-source
      if(Test-Path(".\tobzhaxx_build.bat")) {
        iex ".\tobzhaxx_build.bat $arg"
        echo "Build return code: $LastExitCode"
      } else {
        iex ".\build.bat $arg"
        echo "Build return code: $LastExitCode"
      }
    }
  }
}

enum RepoType {
  Source
  Platform
}

function getRepoType($dir) {
  $file = joinPath $dir "PASNGR.version"
  if(Test-Path($file)) {
    return [RepoType]::Source
  } else {
    return [RepoType]::Platform
  }
}

function getRootOfRepo() {
  return getRootOfRepoImpl(New-Object IO.DirectoryInfo(pwd))
}

function getRootOfRepoImpl($dir) {
  if( ($dir -eq $null) -or (test-path("$($dir.FullName)\.git")) ){
    return $dir
  } else {
    return getRootOfRepoImpl($dir.Parent)
  }
}

function joinPath([IO.DirectoryInfo]$dir, $item) {
  return "$($dir.FullName)\$($item)"
}

function getSubFolder([IO.DirectoryInfo]$dir, $subDir) {
  $path = joinPath $dir $subDir
  if([IO.Directory]::Exists($path)){
    return $path
  } else {
    return $null
  }
}

function cdRepo() {
  $path = getRootOfRepo
  if($path -eq $null) {
    Write-Host "You're not in a git repo!" -f Red
  } else {
    cd $path.FullName
  }
}

function getFile([IO.DirectoryInfo]$dir, $fileName) {
  $path = joinPath $dir $fileName
  if([IO.File]::Exists($path)){
    return $path
  } else {
    return $null
  }
}

function removeFolder($dir, $subDir) {
  $path = getSubFolder $dir $subDir
  if($path -ne $null) {
    Write-Host "Removing folder: " -nonewline; Write-Host $path -f Yellow
    [IO.Directory]::Delete($path, $true)
  }
}

function RunBuildScript([IO.DirectoryInfo]$dir) {
  $script = getFile $dir "run.cmd"
  if($script -eq $null) {
    Write-Host "Build script not found in $dir :("
  } else {
    iex $script
  }
}

function TidyBuildDir([IO.DirectoryInfo]$dir) {
  removeFolder $dir "bldTmp"

  objkilla commit
}

function BuildPlatform([IO.DirectoryInfo]$root) {
  TidyBuildDir $root
  RunBuildScript $root
}

function bld()
{
  Write-Host "Running RootBuild for the current git repo"
  $root = getRootOfRepo #New-Object IO.DirectoryInfo(pwd))
  if($root -eq $null) {
    Write-Host "You're not in a git repo!" -f Red
  } else {
    Write-Host "Git repo found in: " -nonewline; Write-Host $root -f Yellow
    $type = getRepoType $root
    if($type -eq [RepoType]::Source) {
      BuildSource
    } else {
      BuildPlatform $root
    }
  }
}

function pkt() {
  $locations = ".\packages\fake\Paket\tools\paket.exe", ".\.paket\paket.exe"
  foreach($possibility in $locations) {
    if(test-path $possibility) {
      Write-Host "Running paket from " -nonewline; Write-Host $possibility -f Yellow
      & $possibility $args
    }
  }
}

function bldcfg()
{
  Write-Host "Hacking the build's config..."
  $root = getRootOfRepo #New-Object IO.DirectoryInfo(pwd))
  if($root -eq $null) {
    Write-Host "You're not in a git repo!" -f Red
  } else {
    Write-Host "Git repo found in: " -nonewline; Write-Host $root -f Yellow
    echo "todo..."
    $Path = "$root\.fake-script\fake.LocalBuild.config"
     
# load it into an XML object:
    $xml = New-Object -TypeName XML
    $xml.Load($Path)
    echo "loaded $Path"
# note: if your XML is malformed, you will get an exception here
# always make sure your node names do not contain spaces
     
# simply traverse the nodes and select the information you want:
#$Xml.configuration.appSettings.add | Select-Object 
#$Xml.configuration.appSettings.add | Where-Object {$_.key -eq "DefaultTarget:RunAllPreBuildChecks"} | Select-Object 
#$bob = $Xml.configuration.appSettings.add | Where-Object {$_.key -eq "DefaultTarget:RunAllPreBuildChecks"} | Select-Object 
#echo "bob= $($bob.key) :: $($bob.value)"
#$bob.value = "False"
    $allOptions = {"AllPreBuildChecks", "Tests", "Docker", "BinaryPackages", "DeploymentPackages"}
    $disableOptions = @("AllPreBuildChecks", "Docker", "BinaryPackages", "DeploymentPackages")
    foreach($item in (Select-XML -Xml $Xml -XPath "//configuration/appSettings/add")) #/[key='DefaultTarget:RunAllPreBuildChecks']")
    {
      echo "** $($item.node.key)::$($item.node.value) **"
    }

    foreach($item in $disableOptions)
    {
#echo "looking for //configuration/appSettings/add[@key='DefaultTarget:Run$item']"
      $xThing = (Select-XML -Xml $Xml -XPath "//configuration/appSettings/add[@key='DefaultTarget:Run$item']")
#echo "xThing = $xThing.node"
#echo "xThing.value = $($xThing.node.value)"
      $xThing.node.value = "False"
    }
    foreach($item in (Select-XML -Xml $Xml -XPath "//configuration/appSettings/add")) #/[key='DefaultTarget:RunAllPreBuildChecks']")
    {
      echo "** $($item.node.key)::$($item.node.value) **"
    }

    $xml.Save($Path)
  }
}

Export-ModuleMember -Function cdRepo
Export-ModuleMember -Function bld
Export-ModuleMember -Function bldcfg
Export-ModuleMember -Function pkt
