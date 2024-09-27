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

function DELETELINE($file, $old) {
  $content = Get-Content -Path $file
  $newContent = $content -replace $old, ""
  if($newContent -eq $content){
    Write-Host "$file - no change for: $old" -f RED
  } else {
    Write-Host "$file - changed $old to: $new" -f YELLOW
  }
  $newContent | Set-Content -Path $file
}


  Write-Host "Setting up GitHub Actions" -f Yellow

  REPLACELINE "scripts/set-vars.sh" "read -s aws_access_key_id" "read aws_access_key_id"
  REPLACELINE "readme.md" "./scripts/dockerfile" "./scripts/Dockerfile"
  REPLACELINE "scripts/Dockerfile" "scripts/cd/deploy.sh" "scripts/deploy.sh"

  $repo = (pwd).Path.Split("\") | select-object -last 1
  SKIP "6. Modify script/set-vars.sh. Set docker build -t 'nr/short-name' to '$repo' (line 41)" -f RED

# 7. Correctly handle 'apply' mode
  REPLACELINE "readme.md" " {ENVIRONMENT} {REGION} -f apply" " {ENVIRONMENT} {REGION} apply"
  REPLACELINE "scripts/deploy.sh" "<enviroment>" "<environment>"
  SKIP "7. Modify script/deploy.sh. Echoing usage (lines 5 - 8) and if clause (line 45)" -f RED

  SKIP "8. add terraform get (line 63) to scripts/deploy.sh" -f RED

  SKIP "9. A bunch of changes in scripts/Dockerfile" -f RED

  SKIP "10. Update newrelic provider version to 2.38 in terraform/main.tf (line 5)" -f RED


  REPLACELINE "readme.md" "#### Manual Deployments" "#### Manual Deployment"
  REPLACELINE "readme.md" "#### Continuous Deployments" "#### Continuous Deployment"
  REPLACELINE "readme.md" "Deployments are performed by running scripts in Docker, using New Relic Terraform Provider, per environment per region." "<<DELETE THIS LINE >>"

  ghavim
  gitextensions commit --message "feat: HH-499 ???  - Modifying files for GitHub Actions"
