$xl = New-Object -COM "Excel.Application"
$xl.Visible = $true
$wb = $xl.Workbooks.Open("C:\test\psexcel\list1.xlsx")
$ws = $wb.Sheets.Item(1)
# echo $ws.Rows;
for ($i = 1; $i -le 10; $i++) {
   echo $ws.Cells.Item($i,1).Value2
}

$numofcells=$ws.usedrange.countlarge
echo "Last cell #$numofcells"
sleep 3
$wb.Close()
$xl.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl)