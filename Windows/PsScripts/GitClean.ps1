if ($args[0] -eq $null) {
  $mode = ""
} else {
  $mode = $args[0].ToLower();
}

$exclusions = " -e *tobzhaxx* -e *ncrunch* -e *.csproj.user -e *.suo -e .vs "
if($mode -eq "") {
  cls
  Write-Host "Files to be removed (excluding bin & obj)" -f Green  
  iex "git clean -dxn -e bin -e obj $exclusions"
  Write-Host "Run with" -f Yellow -nonewline  
    Write-Host " -f " -f Red -nonewline 
    Write-Host "to force removal, or" -f Yellow -nonewline 
    Write-Host " -b " -f Green -nonewline 
    Write-Host "to show with bin & obj files" -f Yellow  
} elseif($mode -eq "-b") {
    cls
    Write-Host "Files to be removed (including bin & obj)" -f Green  
    iex "git clean -dxn $exclusions"
    Write-Host "Run with" -f Yellow -nonewline  
      Write-Host " -f " -f Red -nonewline 
      Write-Host "to force removal, or no argument to show without bin & obj files" -f Yellow 
} elseif($mode -eq "-f") {
    cls
    $command = "git clean -dxf $exclusions" 
    Write-Host "Executing: " -nonewline ; Write-Host $command -f Yellow  
    iex $command
} else {
  Write-Host "Unexpected argument '" -nonewline ; Write-Host $mode -f Red -nonewline ; Write-Host "'"
  Write-Host "Run with" -f Yellow -nonewline  
    Write-Host " -f " -f Red -nonewline 
    Write-Host "to force removal," -f Yellow -nonewline 
    Write-Host " -b " -f Green -nonewline 
    Write-Host "to show with bin & obj files, or no argument to show without bin & obj files" -f Yellow  
}
