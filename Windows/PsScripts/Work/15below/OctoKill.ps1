write-host "E:\Octopus\Applications\.Tentacle\Packages\*.*"
rm -force -recurse E:\Octopus\Applications\.Tentacle\Packages\*.*
#rm -force -recurse E:\Octopus\Applications\LOC\*.*
#rm -force -recurse E:\Octopus\Data\PackageCache\*.*

write-host "E:\Octopus\Applications\LOC\"
get-childitem E:\Octopus\Applications\LOC\  -recurse | remove-item -recurse

write-host "E:\Octopus\Data\PackageCache\"
get-childitem E:\Octopus\Data\PackageCache\ -recurse | remove-item -recurse

Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
