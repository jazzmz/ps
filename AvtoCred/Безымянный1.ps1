$dir="N:\PUBLIC\D2\АВТОКРЕДИТЫ"
$i=0
$j=0

Get-Childitem $dir | % {

$filecount=0
$flag=$false
$j++
if ($_.PsIsContainer) {
Get-ChildItem $dir\$_ | % {
    if ( $_.Name -ne "Thumbs.db" ) {
        $filecount++
    }
    if ( $_.Name -eq "Паспорт.pdf" ) {$flag=$true}
}

if (( $filecount -ne 2 ) -and (!$flag)) {
    $name=$_.Name
    echo "$name" # $flag $i"
    Get-ChildItem $dir\$_
    $i++
}

}
}

echo "Total $j; NO Pasport $i"