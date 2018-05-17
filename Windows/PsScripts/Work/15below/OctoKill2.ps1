write-host "Tentacle\Applications\Packages"
write-host "-qa"
rm -force -recurse E:\Octopus2Tentacle\qa.localhost\Applications\.Tentacle\Packages\*.*
write-host "-ra"
rm -force -recurse E:\Octopus2Tentacle\ra.localhost\Applications\.Tentacle\Packages\*.*
write-host "-shared"
rm -force -recurse E:\Octopus2Tentacle\SharedDeploy\Applications\.Tentacle\Packages\*.*

write-host "Tentacle\Applications\LOC"
write-host "-qa"
get-childitem E:\Octopus2Tentacle\qa.localhost\Applications\LOC\  -recurse | remove-item -recurse -force
write-host "-ra"
get-childitem E:\Octopus2Tentacle\ra.localhost\Applications\LOC\  -recurse | remove-item -recurse -force
write-host "-shared"
get-childitem E:\Octopus2Tentacle\SharedDeploy\Applications\LOC\  -recurse | remove-item -recurse -force

write-host "Server\PackageCache\"
get-childitem E:\Octopus2ServerData\PackageCache\ -recurse | remove-item -recurse -force

Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
