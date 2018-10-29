###########################################################################
### Программа: Скрипт для отправки файлов БИС-у 		###########
### Автор: Доркин Д.В.						###########
### Дата последних изменений: 05.03.2013			###########
###								###########
###########################################################################

# Инициализация переменных
$i = 0
$text_to_send = "C:\test\Башмакову\label.txt"		#Путь где хранится формируемый отчет
$currDay = Get-Date -format "dd"
$currMonth = Get-Date -format "MM"
$currYear = Get-Date -format "yyyy"
$path_to_out_local = "C:\test\Башмакову\out\"		#Локальная папка для раскладывания файлов
$path_to_out_remote = "C:\test\Башмакову\outremote\"    #Удаленная папка для раскладывания файлов
$path_with_files = "C:\test\Башмакову\"			#Папка откуда берем файлы SMEV
$blat_exe = "C:\test\Башмакову\blat\blat.exe"		#Путь до директории с программой отправки почты
$addresses = "C:\test\Башмакову\blat\listofsending.txt" #Лист со списком получателей

#Проверим есть ли куда класть ЛОКАЛЬНО и если нет, то сделаем папок и подпапок
$flag = Test-Path $path_to_out_local\$currYear #Сначала год
	if (!$flag) {
				mkdir $path_to_out_local\$currYear | Out-Null
			      };
$flag = Test-Path $path_to_out_local\$currYear\$currMonth # Теперь месяц
	if (!$flag) {
				mkdir $path_to_out_local\$currYear\$currMonth | Out-Null
			      };
$flag = Test-Path $path_to_out_local\$currYear\$currMonth\$currDay # Теперь день
	if (!$flag) {
				mkdir $path_to_out_local\$currYear\$currMonth\$currDay | Out-Null
			      };

# Проверим есть ли куда класть Удаленно и если нет, то сделаем папок и подпапок

# Для начала проверим доступен ли вообще удаленный каталог

$flag_rem_access = Test-Path $path_to_out_remote

if ($flag_rem_access) {
	$flag = Test-Path $path_to_out_remote\$currYear #Сначала год
		if (!$flag) {
					mkdir $path_to_out_remote\$currYear | Out-Null
				      };
	$flag = Test-Path $path_to_out_remote\$currYear\$currMonth # Теперь месяц
		if (!$flag) {
					mkdir $path_to_out_remote\$currYear\$currMonth | Out-Null
				      };
	$flag = Test-Path $path_to_out_remote\$currYear\$currMonth\$currDay # Теперь день
		if (!$flag) {
					mkdir $path_to_out_remote\$currYear\$currMonth\$currDay | Out-Null
				      };
				  } # конец условия о доступности удаленной папки


del $text_to_send
	echo ---------------------------------------------------------------- >> $text_to_send
dir -Filter SMEV*xml -Name $path_with_files | % {$i = $i + 1}
echo "Было выложено $i XML файлов" >> $text_to_send
	echo ---------------------------------------------------------------- >> $text_to_send


cp $path_with_files\$_ $path_to_out_local\$currYear\$currMonth\$currDay # копирнем локально

if ($flag_rem_access) {
	cp $path_with_files\$_ $path_to_out_remote\$currYear\$currMonth\$currDay # копирнем удаленно если есть такая возможность
				  };

del $path_with_files\$_ # удалим

}

if ($i -ne 0) { #если есть хоть один файл для обработки

cmd /c start $blat_exe $text_to_send -tf $addresses -subject "Отчет об обработке файлов на отправку"
};

