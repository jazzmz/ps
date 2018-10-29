$filename = "20120725.zip"
$preday_1 = $filename -split '201207'
$day_ext = $preday_1[1]
$day_arr = $day_ext -split '\.'
$day = $day_arr[0]
echo $day