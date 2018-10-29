<#
Скрипт перекладывает файлы полученные из
РКЦ на вход АБС "Бисквит"
Modified by Dorkin Dmitry 20 june 2013
#>

##################################################### СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ #########################################################
$ARM_PATH='C:\test\uarm\exg\chk';
$ARM_OUT=$ARM_PATH;
$BIS_IN='C:\test\uarm\konva_w\out';
$BIS_OUT='C:\test\uarm\konva_w\in\*.xml';
$ARM_CLI='C:\test\uarm\exg\cli';
$TEMP_DIR='C:\test\uarm\tmp'
$TEMP_DIR_ED='C:\test\uarm\tmp2'
$EXCLUDEFILENAME="exclude.dat";
$EXCLUDELIST=$TEMP_DIR + "\" + $EXCLUDEFILENAME;

################################################# КОНЕЦ СЛУЖЕБНЫХ ПЕРЕМЕННЫХ #####################################################
$RES=Test-Path $EXCLUDELIST;
if (!$RES)
  {
     date -format "dd.MM.yyyy" > $EXCLUDELIST;
  }

Function filterByExcludeList() {

<#################################################
 #   Функция проверяет наличие в файле           #
 #  $EXCLUDELIST наличие компьютера с            #
 #   именем $_.computerName.			         #
 #   Если такой компьютер есть,			         #
 #   то он исключается.						     #
 #   То есть дальше в конвейер не передается.    #
##################################################>

BEGIN { }
 Process {
  $isFileCopy = $false;
  $File2Copy = $_;
  
   ############ Проверяем есть ли компьютер в списке исключений ################
   (Get-Content $EXCLUDELIST) | % { if ($_ -eq $File2Copy.Name) { $isFileCopy=$true; return; }};

   if (-not $isFileCopy)
     {
	   return $File2Copy;
	 };

 }
 END { }
 }

<# Функция отбраковывает файлы с заданым SystemCode #>

Function filterByPacketSystemCode() {
param($sc);
BEGIN {}

PROCESS {
$FILEWPATH=$TEMP_DIR + "\" + $_.Name;
$xml = [xml] (Get-Content $FILEWPATH);
 
if ($xml.PacketEPD.SystemCode -ne $sc) {
  return $_; 
}

}
END {}
};

Function filterByPacketType() {
 <#####################################
   # Функция определяет является ли
   # указанный файл, файлом с платежными
   # документами
  ######################################>
param ($PacketType)
BEGIN {}

PROCESS {
$FILEWPATH=$TEMP_DIR + "\" + $_.Name;
$xml = [xml] (Get-Content $FILEWPATH);
if ($xml.get_DocumentElement().get_Name() -eq $PacketType) 
  {
      return  $_;
  };

}
END {}
}

Function filterEd206()
{
BEGIN {}
PROCESS {
$FILEWPATH=$TEMP_DIR + "\" + $_.Name; 
$xml=[xml] (Get-Content $FILEWPATH); 
$RES=$xml.PacketESID.ED206;
if ($RES)
 {
   return $_;
  };
}
END {}
}

Function filterByPacketType_ED() {

 <#####################################
   # Функция определяет является ли
   # указанный файл, файлом с платежными
   # документами
  ######################################>
param ($PacketType)
BEGIN {}

PROCESS {
$FILEWPATH=$TEMP_DIR_ED + "\" + $_.Name;
$xml = [xml] (Get-Content $FILEWPATH);
if ($xml.get_DocumentElement().get_Name() -eq $PacketType) 
  {
      return  $_;
  };

}
END {}
}


Function getED501Content($FWP)
{
  <# 
    Функция в качестве входного параметра, 
   	 получает имя файла с ED501.
   	 Затем из этого файла выбирает и
   	 возвращает значение
   	 тэга ProprietoryDocument .
    #>
  
  $xml=[xml] (Get-Content $FWP);  
  return $xml.ED501.ProprietoryDocument;
}

function ConvertFrom-Base64($string) 
{
  <# 
    Функция производит преобразование
	строки в кодировке UNICODE в UTF-8.
	Предполагается, что отправитель действует
	следующим образом:
	1. Сохранил текстовку в Win-1251;
	2. Закодировал ее в Base64;
	3. Отправил нам.
  #>
  
   <# Получаем кодировки #>    
   $utf8=[System.Text.Encoding]::GetEncoding('utf-8');
   $cp1251=[System.Text.Encoding]::GetEncoding('windows-1251');
   
   <# Выполняем дешифрацию из Base64 #>
   $bytes  = [System.Convert]::FromBase64String($string);
   
   <# Выполняем преобразование из win-1251 в utf-8 #>   
   
   $bytesInUtf = [System.Text.Encoding]::Convert($cp1251,$utf8,$bytes);
   $decoded = [System.Text.Encoding]::UTF8.GetString($bytesInUtf);

   return $decoded;
}

dir -filter "*.EPD" $ARM_PATH | filterByExcludeList | % {
  $xml=[xml] (Get-Content $ARM_PATH\$_);  
  $var1="Object";
  $var2="SigEnvelope";
  $srtingbase64=$xml.$var2.$var1;
$FILEOUT=$TEMP_DIR + "\" + $_.Name;
ConvertFrom-Base64 $srtingbase64 > $FILEOUT; 
# echo $_.Name >> $EXCLUDELIST;
};

dir -filter "*.ESID" $ARM_PATH | filterByExcludeList | % {
  $xml=[xml] (Get-Content $ARM_PATH\$_);  
  $var1="Object";
  $var2="SigEnvelope";
  $srtingbase64=$xml.$var2.$var1;
$FILEOUT=$TEMP_DIR + "\" + $_.Name;
ConvertFrom-Base64 $srtingbase64 > $FILEOUT; 
# echo $_.Name >> $EXCLUDELIST;
};

dir -filter "*.ED" $ARM_PATH | filterByExcludeList | % {
  $xml=[xml] (Get-Content $ARM_PATH\$_);  
  $var1="Object";
  $var2="SigEnvelope";
  $srtingbase64=$xml.$var2.$var1;
$FILEOUT=$TEMP_DIR_ED + "\" + $_.Name;
ConvertFrom-Base64 $srtingbase64 > $FILEOUT; 
# echo $_.Name >> $EXCLUDELIST;
};

dir -filter "*.EDS" $ARM_PATH | filterByExcludeList | % {
  $xml=[xml] (Get-Content $ARM_PATH\$_);  
  $var1="Object";
  $var2="SigEnvelope";
  $srtingbase64=$xml.$var2.$var1;
$FILEOUT=$TEMP_DIR_ED + "\" + $_.Name;
ConvertFrom-Base64 $srtingbase64 > $FILEOUT; 
# echo $_.Name >> $EXCLUDELIST;
};


# ПАКЕТЫ #
dir -filter 4585* $TEMP_DIR | filterByExcludeList | filterByPacketType "PacketEPD"| filterByPacketSystemCode "05" | % {
echo "PacketEPD $_";
$FILENAME=$ARM_PATH + "\" + $_.Name; 
$FILEOUT=$BIS_IN + "\" + "acp" + $_.Name + ".dat";
cp $FILENAME $FILEOUT;  
if ($?) {
		echo $_.Name >> $EXCLUDELIST
		};
};

# ED101 #

dir -filter 4585* $TEMP_DIR_ED | filterByExcludeList | filterByPacketType_ED "ED101" | % { 
echo "ED101 $_";
$FILENAME=$ARM_PATH + "\" + $_.Name; 
$FILEOUT=$BIS_IN + "\" + "acp" + $_.Name + ".dat";
cp $FILENAME $FILEOUT;  
	if ($?) {
			echo $_.Name >> $EXCLUDELIST			
			};
};

# ED273 #

dir -filter 4585* $TEMP_DIR_ED | filterByExcludeList | filterByPacketType_ED "ED273" | % { 
echo "ED273 $_";
$FILENAME=$ARM_PATH + "\" + $_.Name; 
$FILEOUT=$BIS_IN + "\" + "acp" + $_.Name + ".dat";
cp $FILENAME $FILEOUT;
 
	if ($?) {
			echo $_.Name >> $EXCLUDELIST			
			};
};

###########################
 # Подтверждения по рейсам #
 ###########################
 
# ED206 #
# 
#Добавляем в файла  префикс esid, необходимо
#для того чтобы оператор отличал какие-файлы когда
#необходимо загружать
#
dir -filter 4585* $TEMP_DIR | filterByExcludeList | filterByPacketType "PacketESID" |  filterEd206 | % { 
echo "PacketESID $_";
$FILENAME=$ARM_PATH + "\" + $_.Name; 
$FILEOUT=$BIS_IN + "\" + "ESID_acp" + $_.Name + ".dat"; 
cp $FILENAME $FILEOUT;  
	if ($?) {
			 echo $_.Name >> $EXCLUDELIST
			 };
};

 ############################
 # ИНФОРМАЦИОННЫЕ СООБЩЕНИЯ #
 ############################
 
 
 # ED501 #
 #    
 #   Заявка: #545
 #	Автор: Маслов Д. А.
 #	Дата создания: 30.11.2010
 #
dir -filter 4585* $TEMP_DIR | filterByExcludeList | filterByPacketType "ED501" | % {
echo "ED501 $_";
$FILENAME=$ARM_PATH + "\" + $_.Name; 
$FILEOUT=$BIS_IN + "\" + "inf_acp" + $_.Name + ".dat";
$ProprietoryDocument = getED501Content $FILENAME;
ConvertFrom-Base64 $ProprietoryDocument > $FILEOUT; 
if ($?) { 
echo $_.Name >> $EXCLUDELIST 
};
};

# ED374 #
# 
# Добавляем в файл префикс spr, необходимо
# для того, чтобы оператор вовремя загружал справочник
#
dir -filter "*.EDS" $TEMP_DIR_ED | filterByExcludeList | filterByPacketType_ED "ED374" | % {
echo "SPRAV $_";
$FILENAME=$ARM_PATH + "\" + $_.Name; 
$FILEOUT=$BIS_IN + "\" + "SPR_acp" + $_.Name + ".dat"; 
cp $FILENAME $FILEOUT;  
echo $_.Name >> $EXCLUDELIST
};

 #############################
  # АРМ КБР <----- БИСКВИТ   #
  #############################

mv $BIS_OUT $ARM_CLI


#rm -force $TEMP_DIR\*EPD
#rm -force $TEMP_DIR\*ESID
#rm -force $TEMP_DIR_ED\*ED 
#rm -force $TEMP_DIR_ED\*EDS