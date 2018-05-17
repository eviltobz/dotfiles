function cd-source()
{
	cd c:\git\source
}
function cd-LXA()
{
	cd c:\git\source\ClientSpecific\LXA
}
#function cd-sourc1()
#{
#cd c:\dev\sourc1
#}
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

function fbuild()
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
new-alias cdlx cd-LXA
$pwd = pwd
if( ("$pwd" -eq "C:\Users\toby.carter") -or ("$pwd" -eq "C:\tools\cmder") -or ("$pwd" -eq "E:\tobz\Cmder_mini"))
{
	cd-source
}
