$i=0
$totalflag=$false
do {
    $i++
    echo $i
    if ($i -ge "10"){$totalflag=$true}
}
While (!$totalflag)
