/*
Формирование отчетов по клиентам с прописанным доп.реком PIR-Group
вида S*.xls из Анализа.
*/

{bislogin.i}
{globals.i}
{getdate.i}

IF Search("pir-vkladch.r") <> ? then run value("pir-vkladch.r").
	else RUN Value("pir-vkladch.p").

IF Search("pir-zaemsch.r") <> ? then run value("pir-zaemsch.r").
	else RUN Value("pir-zaemsch.p").

MESSAGE "Расчет отчетов по вкладчикам и заемщикам окончен." VIEW-AS ALERT-BOX.
