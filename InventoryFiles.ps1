# Measure-Command {./InventoryFiles.ps1}
clear-host 
Write-host "================================================"
write-host "This tool will recursively query each 1st level"
Write-host "folder it finds and will return the following:"
Write-host "FullFolderName, countOfObjects, Size(MB), DateTime"
Write-host "Pipe Delimited Output file: FileShareSummary.log"
Write-host "================================================"
$startFolder = Read-Host "Enter a UNC or mapped path to query"
$colItems = (Get-ChildItem $startFolder | Where-Object {$_.PSIsContainer -eq $True} | Sort-Object)
foreach ($i in $colItems)
    {
        $a = Get-Date
		$subFolderItems = (Get-ChildItem $i.FullName -recurse  | Where-Object {$_.PSIsContainer -eq $False} | Measure-Object -property length -sum)
        $i.FullName+"|"+$a+"|"+(Get-ChildItem -path $startFolder'\'$i -Recurse).count+"|"+"{0:N2}" -f ($subFolderItems.sum / 1MB) | Out-File FileShareSummary.log -Append
    }
