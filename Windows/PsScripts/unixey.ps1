function touch($filename) {
  write-host "unixey override touch $args - NOTE: only creates new, won't update timestamps on existing"
  New-Item $filename -type file
}

function rm() {
  if($args[0] -eq "-rf") {
    write-host "unixey override rm -rf $args[1]"
    Remove-Item -recurse -force $args[1]
  } else {
    write-host "unixey override passthrough to Remove-Item $args"
    iex "Remove-Item $args"
  }
}

function ls() {
  if($args[0] -eq "-lah") {
    write-host "unixey override ls -lah $args[1]"
    Get-ChildItem -force "$args[1]"
  } else {
    write-host "unixey override passthrough to Get-ChildItem $args"
    iex "Get-ChildItem '$args'"
  }
}

function l() {
  Write-Host "unixey override l $args[0]"
  Get-ChildItem -force $args[0]
}

function ll() {
  Write-Host "unixey override ll $args[0]"
  Get-ChildItem $args[0]
}

function take($foldername) {
  write-host "unixey override take $args - ZSH command that creates and moves into a new folder"
  mkdir $foldername
  cd $foldername
}

function time($block) {
    $sw = [Diagnostics.Stopwatch]::StartNew()
    &$block
    $sw.Stop()
    $sw.Elapsed
}

Write-Host "Loaded Unixey overrides - touch, rm -rf, ls -lah, l, ll, take, time"
remove-item alias:rm -ErrorAction SilentlyContinue
remove-item alias:ls -ErrorAction SilentlyContinue
