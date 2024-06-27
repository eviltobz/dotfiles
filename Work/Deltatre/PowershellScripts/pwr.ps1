Param(
    [switch]$veryLow,
    [switch]$low,
    [switch]$mid,
    [switch]$mid2,
    [switch]$high,
    [switch]$view
)

# The GUIDs being used seem to be standard ones that are hardcoded into windows, so _shouldn't_ need changing.
# Using on a new O/S might require a setting to enable poking at the CPU frequencies though:
# REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100 /v Attributes /t REG_DWORD /d 2 /f
# Docs for powercfg are at https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh875530(v=ws.11)

function GetCurrentFrequency($mode) {
  $current = powercfg /q SCHEME_CURRENT  54533251-82be-4824-96c1-47b60b740d00
  $isFreq = $false
  $hexFreq = 0
  for( $i = 0; $i -lt $current.count; $i++)
  {
    if($current[$i].Contains("Maximum processor frequency")) {
      $isFreq = $true
    }
    if($isFreq -eq $true) {
      if($current[$i].Contains("Current $mode Power Setting")) { 
        $li = $current[$i].LastIndexOf(" ") + 1
        $hexFreq = $current[$i].Substring($li)
        $freq = [System.Convert]::ToInt32($hexFreq, 16)
        return $freq
      }
    }
  }
  return 0
}

function GetCurrentAcFrequency() {
  return GetCurrentFrequency "AC"
}

function GetCurrentDcFrequency() {
  return GetCurrentFrequency "DC"
}

function DisplayCurrent() {
  $freq = GetCurrentAcFrequency
  $dcFreq = GetCurrentDcFrequency
  Write-Host "Max frequency is on " -NoNewLine;
  if($freq -eq 2000) { Write-Host "low" -f Yellow -NoNewLine }
  elseif($freq -eq 2500) { Write-Host "mid" -f Yellow -NoNewLine }
  elseif($freq -eq 3000) { Write-Host "mid2" -f Yellow -NoNewLine }
  elseif($freq -eq 1000) { Write-Host "veryLow" -f Yellow -NoNewLine }
  elseif($freq -eq 0) { Write-Host "high" -f Yellow -NoNewLine }
  else { Write-Host "[UNKNOWN]" -f Red -NoNewLine } 
  Write-Host " setting. (" -NoNewLine; Write-Host $freq -f Yellow -NoNewLine; Write-Host " MHz.) " -NoNewLine
  Write-Host "DC:$dcFreq MHz."
}

function SetFrequency($acFreq, $dcFreq) {
  powercfg -setacvalueindex SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 75b0ae3f-bce0-45a7-8c89-c9611c25e100 $acFreq
  powercfg -setdcvalueindex SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 75b0ae3f-bce0-45a7-8c89-c9611c25e100 $dcFreq
  powercfg /SetActive SCHEME_CURRENT
}



if($low -eq $false -AND $veryLow -eq $false -AND $mid -eq $false -AND $mid2 -eq $false -AND $high -eq $false -AND $view -eq $false) {
  $freq = GetCurrentAcFrequency
  Write-Host "Toggling frequency: " -NoNewLine
  if($freq -eq 0) {
    Write-Host "low" -f Yellow -NoNewLine
    SetFrequency 2000 1400
  } else {
    Write-Host "high" -f Yellow -NoNewLine
    SetFrequency 0 0
  }
  Write-Host ". Use -veryLow, -low, -mid, -mid2, -high or -view to set speed to 1000, 2000, 2500, 3000, max, or just view the current setting." -f DarkGray
} elseif($view -eq $true) {
# nop
} else {
  $acFreq = 0;
  $dcFreq = 0;
  if($veryLow -eq $true) {$acFreq = 1000; $dcFreq = 800}
  if($low -eq $true) {$acFreq = 2000; $dcFreq = 1400}
  if($mid -eq $true) {$acFreq = 2500; $dcFreq = 2000}
  if($mid2 -eq $true) {$acFreq = 3000; $dcFreq = 2500}
  SetFrequency $acFreq $dcFreq
}
DisplayCurrent
