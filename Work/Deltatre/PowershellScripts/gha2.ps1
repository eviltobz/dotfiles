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


Write-Host "OBSOLETED" -f Red -b Yellow
#
#  Write-Host "Setting up GitHub Actions" -f Yellow
#
#  Write-Host " - Simple moving & stuff" -f Yellow
#  mkdir .github
#  mkdir .github/workflows
#  mv pull_request_template.md .github/
#  rm scripts/cd/release.sh
#  mv scripts/cd/deploy.sh scripts/
#  git mv scripts/dockerfile scripts/Dockerfile
#  cp c:\users\toby.carter\dotfiles\work\deltatre\powershellscripts\gha\cd-non-prod.yml .github/workflows/
#  cp c:\users\toby.carter\dotfiles\work\deltatre\powershellscripts\gha\cd-prod.yml .github/workflows/
#  cp c:\users\toby.carter\dotfiles\work\deltatre\powershellscripts\gha\ci.yml .github/workflows/
#  cp c:\users\toby.carter\dotfiles\work\deltatre\powershellscripts\gha\manual.yml .github/workflows/
#
#  Write-Host "DONE THE MOVING & CREATING. " -f Yellow
#  Write-Host "Commit this first stage before doing the changes." -f Yellow
#  gitextensions commit --message "feat: HH-499 ???  - Add workflows, move files, delete obsolete file"
#  Write-Host "Press enter to continue..." 
#  Read-Host
#
#  REPLACELINE "scripts/set-vars.sh" "read -s aws_access_key_id" "read aws_access_key_id"
#  REPLACELINE "readme.md" "./scripts/dockerfile" "./scripts/Dockerfile"
#  REPLACELINE "scripts/Dockerfile" "scripts/cd/deploy.sh" "scripts/deploy.sh"
#
#  $repo = (pwd).Path.Split("\") | select-object -last 1
#  SKIP "6. Modify script/set-vars.sh. Set docker build -t 'nr/short-name' to '$repo' (line 41)" -f RED
#
## 7. Correctly handle 'apply' mode
#  REPLACELINE "readme.md" " {ENVIRONMENT} {REGION} -f apply" " {ENVIRONMENT} {REGION} apply"
#  SKIP "7. Modify script/deploy.sh. Echoing usage (lines 5 - 8) and if clause (line 45)" -f RED
#
#  SKIP "8. add terraform get (line 63) to scripts/deploy.sh" -f RED
#
#  SKIP "9. A bunch of changes in scripts/Dockerfile" -f RED
#
#  SKIP "10. Update newrelic provider version to 2.38 in terraform/main.tf (line 5)" -f RED
#
#
#
