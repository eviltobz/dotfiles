if ($args[0] -eq $null) {
  $user = ""
} else {
  $user = $args[0].ToLower();
}

$eviltobz = "eviltobz","evil","tobz"
$15b = "15b","toby.carter"
if(-not $eviltobz.contains($user) -and -not $15b.contains($user)) {
  Write-Host "Please provide a valid user (eviltobz, 15b)"
} else {
  if($eviltobz.contains($user)) {
    git config --global user.email eviltobz@hotmail.com
    git config --global user.name eviltobz
  } else {
    git config --global user.email toby.carter@15below.com
    git config --global user.name "toby carter"
  }
}

Write-Host "...note - i may still need to do something about setting up git keys..." -foregroundcolor yellow
GitWho
