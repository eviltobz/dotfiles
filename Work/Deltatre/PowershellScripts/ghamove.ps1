function SKIP($message) {
  Write-Host "SKIPPING STEP: " + $message -f RED
}

function REPLACELINE($file, $old, $new) {
  $content = Get-Content -Path $file
  $newContent = $content -replace $old, $new
  if($newContent -eq $content){
    Write-Host "$file - no change for: $old" -f RED
  } else {
    Write-Host "$file - changed $old to: $new" -f YELLOW
  }
  $newContent | Set-Content -Path $file
}


  Write-Host "Setting up GitHub Actions" -f Yellow

  Write-Host " - Simple moving & stuff" -f Yellow
  mkdir .github
  mkdir .github/workflows
  mv pull_request_template.md .github/
  rm scripts/cd/release.sh
  mv scripts/cd/deploy.sh scripts/
  git mv scripts/dockerfile scripts/Dockerfile
  cp c:\users\toby.carter\dotfiles\work\deltatre\powershellscripts\gha\cd-non-prod.yml .github/workflows/
  cp c:\users\toby.carter\dotfiles\work\deltatre\powershellscripts\gha\cd-prod.yml .github/workflows/
  cp c:\users\toby.carter\dotfiles\work\deltatre\powershellscripts\gha\ci.yml .github/workflows/
  cp c:\users\toby.carter\dotfiles\work\deltatre\powershellscripts\gha\manual.yml .github/workflows/

  Write-Host "DONE THE MOVING & CREATING. " -f Yellow
  Write-Host "Commit this first stage before doing the changes." -f Yellow
  gitextensions commit --message "feat: HH-499 ???  - Add workflows, move files, delete obsolete file"
