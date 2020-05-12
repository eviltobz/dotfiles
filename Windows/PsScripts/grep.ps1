Write-Host "This is not proper grep. Use a WSL session instead!" -f RED
Get-ChildItem -r | Select-String -pattern $args[0]
