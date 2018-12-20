$gitPath = 'd:\git'

function cd-source() { cd $gitPath\source }
function cd-client($Code) { cd "$gitPath\source\ClientSpecific\$Code" }

function acc()
{
  cd-source
  iex ".\.build\PostBuild-Runners\TemplateAcceptanceTests-Local.bat $args"
  echo "FullAcceptance return code: $LastExitCode"
}
function accQ()
{
  cd-source
  iex ".\.build\PostBuild-Runners\TemplateAcceptanceTests-LocalQuick.bat $args"
  echo "QuickAcceptance return code: $LastExitCode"
}

function bld()
{
  cd-source
  iex ".\build.bat $args"
  echo "Build return code: $LastExitCode"
}

function facc()
{
  cd-source
  iex ".\build.bat quickbuildandnuget"
  if( "$LastExitCode" -eq "0")
  {
    iex ".\.build\PostBuild-Runners\TemplateAcceptanceTests-Local.bat LXA"
  }
}

new-alias cds cd-source
function cdlx { cd-client("LXA") }
function cdly { cd-client("LY") }

$pwd = pwd
if( ("$pwd" -eq "C:\Users\toby.carter") -or ("$pwd" -eq "C:\tools\cmder") -or ("$pwd" -eq "E:\tobz\Cmder_mini"))
{
	cd-source
}

$QDrive = '\\15belowsbs\15Below\'

# General Work Utils
$env:Path += ";$gitPath\eviltobz\loc\Loc\bin\Debug;" + "$gitPath\eviltobz\CommandLineUtils\objKilla\bin\Debug"
#$env:Path += ";$UtilsPath\CliApps\OctopusDeployHelper;$UtilsPath\CliApps\Octopus2DeployHelper;C:\Utils\CliApps\BuildOctopusProject;C:\dev\sourc0\.paket"
