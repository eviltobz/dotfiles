if ($args[0] -eq $null) {
  $user = ""
} else {
  $user = $args[0].ToLower();
}

if ($user -eq "current") {
  $verbose = $false
  $user = ""
} else {
  $verbose = $true
}


$eviltobz = "eviltobz","evil","tobz"
$deltatre = "delta","deltatre" 

if($verbose)
{
    Write-Host "...Note - I still need to do something about setting up git keys..." -foregroundcolor yellow -backgroundcolor red
}

if($user -eq "") {
  if($verbose)
  {
    Write-Host "Call with 'evil' or 'delta' to change user" 
    Write-Host 
  }
  Write-Host "Current git config" -f Green  
} else {
    if( -not $eviltobz.contains($user) -and -not $deltatre.contains($user)) {
    Write-Host "User '" -nonewline; Write-Host $user -f Red -nonewline; Write-Host "' is not supported. Please provide a valid user (" -nonewline
      Write-Host "$eviltobz / $deltatre" -f Green -nonewline; Write-Host ")"
  } else {
    if($eviltobz.contains($user)) {
      git config --global user.email eviltobz@hotmail.com
      git config --global user.name eviltobz
    } else {
      git config --global user.email toby.carter@deltatre.com
      git config --global user.name "toby carter"
    }
  }
}

Write-Host "UserName: " -nonewline; Write-Host $(git config user.name) -f Yellow
Write-Host "Email   : " -nonewline; Write-Host $(git config user.email) -f Yellow
