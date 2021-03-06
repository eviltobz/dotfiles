if ($args[0] -eq $null) {
  $user = ""
} else {
  $user = $args[0].ToLower();
}

$eviltobz = "eviltobz","evil","tobz"
$applied = "applied","tcarter"
if($user -eq "") {
  Write-Host "Current git config" -f Green  
} else {
    if( -not $eviltobz.contains($user) -and -not $applied.contains($user)) {
    Write-Host "User '" -nonewline; Write-Host $user -f Red -nonewline; Write-Host "' is not supported. Please provide a valid user (" -nonewline
      Write-Host "$eviltobz / $applied" -f Green -nonewline; Write-Host ")"
  } else {
    if($eviltobz.contains($user)) {
      git config --global user.email eviltobz@hotmail.com
      git config --global user.name eviltobz
    } else {
      git config --global user.email tcarter@appliedsystems.com
      git config --global user.name "toby carter"
    }
    Write-Host "...note - i may still need to do something about setting up git keys..." -foregroundcolor yellow
  }
}

Write-Host "UserName: " -nonewline; Write-Host $(git config user.name) -f Yellow
Write-Host "Email   : " -nonewline; Write-Host $(git config user.email) -f Yellow
