/*
��ନ஢���� ���⮢ �� �����⠬ � �ய�ᠭ�� ���.४�� PIR-Group
���� S*.xls �� �������.
*/

{bislogin.i}
{globals.i}
{getdate.i}

IF Search("pir-vkladch.r") <> ? then run value("pir-vkladch.r").
	else RUN Value("pir-vkladch.p").

IF Search("pir-zaemsch.r") <> ? then run value("pir-zaemsch.r").
	else RUN Value("pir-zaemsch.p").

MESSAGE "����� ���⮢ �� �����稪�� � ����騪�� ����祭." VIEW-AS ALERT-BOX.
