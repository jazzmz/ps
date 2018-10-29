$path="C:\test\nomschlooking"

function ConvertTo-Encoding ([string]$From, [string]$To){
	Begin{
		$encFrom = [System.Text.Encoding]::GetEncoding($from)
		$encTo = [System.Text.Encoding]::GetEncoding($to)
	}
	Process{
		$bytes = $encTo.GetBytes($_)
		$bytes = [System.Text.Encoding]::Convert($encFrom, $encTo, $bytes)
		$encTo.GetString($bytes)
	}
}

function Allowed ([string]$Num){
$fileallow="$path\allow.txt"
$flag=$true
Get-Content $fileallow | % {
if ($_ -eq $Num){
    $flag=$false
}
}
if (!$flag){
    #Not allowed
    return $false
}
else
{
    return $true
}

}

Clear-Host

Get-ChildItem $path File* | %{
    $filefullname=$_.FullName
    $FileExt=$_.Extension
    $fio=$null
    $naimorg=$null
    if ($FileExt -eq ".xml"){
        echo "File $filefullname have ext $FileExt"
        $xmlcontent = $null
        [xml]$xmlcontent=Get-Content $FileFullname
        foreach ($res in $xmlcontent.Файл.Документ){
         $NomSch=$res.СвСчет.НомСч
         $naimorg=$res.СвНП.НПРО.НаимОрг
         $fio=$res.СвНП.НПФЛ.ФИОФЛ.Фамилия + " " + $res.СвНП.НПФЛ.ФИОФЛ.Имя + " " + $res.СвНП.НПФЛ.ФИОФЛ.Отчество
         #echo $res
         if (($fio -eq $null) -and ($NomSch -eq $null)) {
              $text_to_send = $text_to_send + "`n" + "Wrong data!"
         }
         else
         {
         $NomSch="НомСч:$NomSch"
         echo $NomSch.Substring(6,5)
         $NomKr=$NomSch.Substring(6,5)
         }
        }
#        $all=Allowed ($NomKr)
#        echo "Document allowed? $all"
        if ($naimorg){
            echo $naimorg
        }
        else {
            echo $fio
        }

    }
    echo ""
}