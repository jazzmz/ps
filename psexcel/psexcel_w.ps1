$xl = New-Object -COM "Excel.Application"
#$xl.Visible = $true
$pathdir = "C:\test\psexcel\"
Get-Childitem -Filter *.xls $pathdir | foreach {
$name=$_.Name
$wb = $xl.Workbooks.Open("$pathdir\$name")
$ws = $wb.Sheets.Item(1)
$finalline = ""
$range=$ws.usedrange.cells
$numofcells=$range.Rows.Count

Get-Date
# echo $ws.Rows;
for ($i = 3; $i -le $numofcells; $i++) {
#  echo $ws.Cells.Item($i,4).Value2
   if ($finalline -eq "")
        {
        $finalline = $ws.Cells.Item($i,4).Value2
        }
   else
        {
        $finalline = $finalline + "," + $ws.Cells.Item($i,4).Value2
        }
}

echo "Last cell #$numofcells"
# sleep 3
$wb.Close()
$xl.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl)
echo $finalline
echo $finalline >"$pathdir\result_$name.csv"
Get-Date
}