$str="fgfg паыва ыв :23 ысмлот FПРr"

function ChangeStr ([String]$str){
$newstr = ""
    for ($i=0;$i -lt $str.length; $i++){
        switch -casesensitive ($str[$i]) {
            "а" {$addsym = "a"}
            "б" {$addsym = "b"}
            "в" {$addsym = "v"}
            "г" {$addsym = "g"}
            "д" {$addsym = "d"}
            "е" {$addsym = "e"}
            "ё" {$addsym = "yo"}
            "ж" {$addsym = "j"}
            "з" {$addsym = "z"}
            "и" {$addsym = "i"}
            "й" {$addsym = "y"}
            "к" {$addsym = "k"}
            "л" {$addsym = "l"}
            "м" {$addsym = "m"}
            "н" {$addsym = "n"}
            "о" {$addsym = "o"}
            "п" {$addsym = "p"}
            "р" {$addsym = "r"}
            "с" {$addsym = "s"}
            "т" {$addsym = "t"}
            "у" {$addsym = "u"}
            "ф" {$addsym = "f"}
            "х" {$addsym = "h"}
            "ц" {$addsym = "ts"}
            "ч" {$addsym = "ch"}
            "ш" {$addsym = "sh"}
            "щ" {$addsym = "shch"}
            "ъ" {$addsym = ""}
            "ы" {$addsym = "i"}
            "ь" {$addsym = ""}
            "э" {$addsym = "e"}
            "ю" {$addsym = "yu"}
            "я" {$addsym = "ya"}
            "А" {$addsym = "A"}
            "Б" {$addsym = "B"}
            "В" {$addsym = "V"}
            "Г" {$addsym = "G"}
            "Д" {$addsym = "D"}
            "Е" {$addsym = "E"}
            "Ё" {$addsym = "YO"}
            "Ж" {$addsym = "J"}
            "З" {$addsym = "Z"}
            "И" {$addsym = "I"}
            "Й" {$addsym = "Y"}
            "К" {$addsym = "K"}
            "Л" {$addsym = "L"}
            "М" {$addsym = "M"}
            "Н" {$addsym = "N"}
            "О" {$addsym = "O"}
            "П" {$addsym = "P"}
            "Р" {$addsym = "R"}
            "С" {$addsym = "S"}
            "Т" {$addsym = "T"}
            "У" {$addsym = "U"}
            "Ф" {$addsym = "F"}
            "Х" {$addsym = "H"}
            "Ц" {$addsym = "TS"}
            "Ч" {$addsym = "CH"}
            "Ш" {$addsym = "SH"}
            "Щ" {$addsym = "SHCH"}
            "Ъ" {$addsym = ""}
            "Ы" {$addsym = "I"}
            "Ь" {$addsym = ""}
            "Э" {$addsym = "E"}
            "Ю" {$addsym = "YU"}
            "Я" {$addsym = "YA"}
            Default {$addsym = $str[$i]}
        }
        $newstr = $newstr + $addsym
    }
 return $newstr   
 }

$newst = ChangeStr($str)
echo $newst