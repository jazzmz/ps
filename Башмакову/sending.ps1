###########################################################################
### ���������: ������ ��� �������� ������ ���-� 		###########
### �����: ������ �.�.						###########
### ���� ��������� ���������: 05.03.2013			###########
###								###########
###########################################################################

# ������������� ����������
$i = 0
$text_to_send = "C:\test\���������\label.txt"		#���� ��� �������� ����������� �����
$currDay = Get-Date -format "dd"
$currMonth = Get-Date -format "MM"
$currYear = Get-Date -format "yyyy"
$path_to_out_local = "C:\test\���������\out\"		#��������� ����� ��� ������������� ������
$path_to_out_remote = "C:\test\���������\outremote\"    #��������� ����� ��� ������������� ������
$path_with_files = "C:\test\���������\"			#����� ������ ����� ����� SMEV
$blat_exe = "C:\test\���������\blat\blat.exe"		#���� �� ���������� � ���������� �������� �����
$addresses = "C:\test\���������\blat\listofsending.txt" #���� �� ������� �����������

#�������� ���� �� ���� ������ �������� � ���� ���, �� ������� ����� � ��������
$flag = Test-Path $path_to_out_local\$currYear #������� ���
	if (!$flag) {
				mkdir $path_to_out_local\$currYear | Out-Null
			      };
$flag = Test-Path $path_to_out_local\$currYear\$currMonth # ������ �����
	if (!$flag) {
				mkdir $path_to_out_local\$currYear\$currMonth | Out-Null
			      };
$flag = Test-Path $path_to_out_local\$currYear\$currMonth\$currDay # ������ ����
	if (!$flag) {
				mkdir $path_to_out_local\$currYear\$currMonth\$currDay | Out-Null
			      };

# �������� ���� �� ���� ������ �������� � ���� ���, �� ������� ����� � ��������

# ��� ������ �������� �������� �� ������ ��������� �������

$flag_rem_access = Test-Path $path_to_out_remote

if ($flag_rem_access) {
	$flag = Test-Path $path_to_out_remote\$currYear #������� ���
		if (!$flag) {
					mkdir $path_to_out_remote\$currYear | Out-Null
				      };
	$flag = Test-Path $path_to_out_remote\$currYear\$currMonth # ������ �����
		if (!$flag) {
					mkdir $path_to_out_remote\$currYear\$currMonth | Out-Null
				      };
	$flag = Test-Path $path_to_out_remote\$currYear\$currMonth\$currDay # ������ ����
		if (!$flag) {
					mkdir $path_to_out_remote\$currYear\$currMonth\$currDay | Out-Null
				      };
				  } # ����� ������� � ����������� ��������� �����


del $text_to_send
	echo ---------------------------------------------------------------- >> $text_to_send
dir -Filter SMEV*xml -Name $path_with_files | % {$i = $i + 1}
echo "���� �������� $i XML ������" >> $text_to_send
	echo ---------------------------------------------------------------- >> $text_to_send


cp $path_with_files\$_ $path_to_out_local\$currYear\$currMonth\$currDay # �������� ��������

if ($flag_rem_access) {
	cp $path_with_files\$_ $path_to_out_remote\$currYear\$currMonth\$currDay # �������� �������� ���� ���� ����� �����������
				  };

del $path_with_files\$_ # ������

}

if ($i -ne 0) { #���� ���� ���� ���� ���� ��� ���������

cmd /c start $blat_exe $text_to_send -tf $addresses -subject "����� �� ��������� ������ �� ��������"
};

