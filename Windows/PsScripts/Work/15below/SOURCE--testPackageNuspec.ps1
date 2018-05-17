Param(
  [alias("n")][string]$Nuspec
)

$scriptDir = Split-Path ((Get-Variable MyInvocation -Scope 0).Value.MyCommand.Path)

if($Nuspec -eq "")
{
	write-host "You need to enter Nuspec package (Param -n)"
	return
}
if($Nuspec.ToLower().Contains("0.0.0.0"))
{
	write-host "You need to enter Nuspec package without version"
	return
}
if($Nuspec.ToLower().Contains("nuspec"))
{
	write-host "You need to enter Nuspec package without the nuspec '.nuspec' extension on it"
	return
}

$Nuspec = $Nuspec.Trim()

$NuSpecPath = ".\NuSpecs\" + $Nuspec + ".nuspec"
$NugetFeed = ".\NugetFeed\" + $Nuspec 
$NuGetPath =  $NugetFeed + "\" + $Nuspec + ".0.0.0.0.nupkg"

if(!(Test-Path $NuSpecPath))
{
	write-host "NuSpec file $Nuspec.nuspec doesn't exist in Nupecs Folder" 
	write-host "Assuming there will be a nuget package in NugetFeed Folder"
}
else
{
	if(!(Test-Path .\NugetFeed))
	{
		write-host "Creating NugetFeed folder" 
		New-Item .\NugetFeed -type directory
	}

	if(Test-Path $NuGetPath)
	{
		write-host "Removing the $NuGetPath package."
		Remove-Item $NuGetPath
	}

	write-host "Packaging NuSpec: $NuSpecPath"
	.\build\Tools\Nuget\nuget pack $NuSpecPath -nopackageanalysis -outputdirectory $NugetFeed
}

if(!(Test-Path $NuGetPath))
{
	write-host "Failed To Package" 
}
else
{
	write-host "Package Success" 
}
