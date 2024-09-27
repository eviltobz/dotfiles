$dynRoot = "c:/git/dyn"

$items = Get-ChildItem $dynRoot
$count = 1

Write-Host "  [" -NoNewLine; Write-Host 0 -f Yellow -NoNewLine; Write-Host "] /git/dyn"
foreach($item in $items) {
    if($item.Attributes -eq "Directory")
    {
        $name = $item.Name.Replace("dyn-", "")
        Write-Host "  [" -NoNewLine; Write-Host $count -f Yellow -NoNewLine; Write-Host "] $name"
        $count++
    }
}

$selected = Read-Host "Select folder"

$count = 1
if("0" -eq $selected) {
    cd $dynRoot
    echo "meh1"
}
foreach($item in $items) {
    if($item.Attributes -eq "Directory")
    {
        if($count -eq $selected) {
            cd $item.FullName
        }
        $count++
    }
}