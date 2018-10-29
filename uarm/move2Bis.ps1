<#
Скрипт перекладывает файлы полученные из
РКЦ на вход АБС "Бисквит"
#>

##################################################### СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ #########################################################
$ARM_PATH='C:\test\uarm\files\';
$ARM_OUT=$ARM_PATH;
$BIS_IN='C:\test\uarm\files\out';
$BIS_OUT='q:\konva_w\in\*.xml';
$EXCLUDEFILENAME="exclude.dat";
$EXCLUDELIST=$ARM_PATH+ "tmp\" + $EXCLUDEFILENAME;

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
  $fil=$_.Name -split ".EPD"
  $fil1=$fil[0];
$FILEOUT=$BIS_IN + "\" + "acp" + $fil1 + ".dat";
ConvertFrom-Base64 $srtingbase64 > $FILEOUT; 
echo $_.Name >> $EXCLUDELIST;
};

dir -filter "*.ESID" $ARM_PATH | filterByExcludeList | % {
  $xml=[xml] (Get-Content $ARM_PATH\$_);  
  $var1="Object";
  $var2="SigEnvelope";
  $srtingbase64=$xml.$var2.$var1;
  $fil=$_.Name -split ".ESID"
  $fil1=$fil[0];
$FILEOUT=$BIS_IN + "\" + "esid_acp" + $fil1 + ".dat";
ConvertFrom-Base64 $srtingbase64 > $FILEOUT; 
echo $_.Name >> $EXCLUDELIST;
};
