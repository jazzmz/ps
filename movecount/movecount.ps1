$dirfrom = "Q:\mns\440\send_out\" 
$dirto = "O:\F440\temp\"

$limit = 100

$count=0
Get-Childitem $dirfrom | foreach {
        $count++;
        $item = $_.Fullname
        if ($count -le $limit) {
            Move-Item -Force "$item" "$dirto"
        }
        else { break }  
}