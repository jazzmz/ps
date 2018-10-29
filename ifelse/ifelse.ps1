$a="Fals"
$b="True"
$c="Falsen"
$d="False"

# if ((($a -eq "False") -or ($b -eq "False")) -or (($c -eq "False") -or ($d -eq "False"))) {
if (($a -eq "False") -or ($b -eq "False") -or ($c -eq "False") -or ($d -ne "False")) {
echo "$a | $b | $c | $d";
}
