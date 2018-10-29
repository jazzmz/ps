/* ------------------------------------------------------
     File: $RCSfile: pir-turnexp1.p,v $ $Revision: 1.3 $ $Date: 2009-05-13 12:36:32 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: Приказ 21 от 27.03.2009
     Что делает: Автоматически сохраняет оборотно-сальдовую ведомость в Архив
     Как работает: используется стандартная процедура БИСКВИТ
                   нужно лишь правильно задать параметры-макросы
                   Параметры-макросы позволяют отключить все визуальные запросы к 
                   пользователю.
                   Еще позволяют отключить внутри отчета определение потока вывода
                   и отображение его на экран. Воспользовавшись этим 
                   можно определить свой поток в нужный файл. Для определения потока
                   используются стандартный механизм разработчиков ПИРБанка:
                   файлы pirraproc.def and pirraproc.i (см. коммент в pirraproc.i)
     Параметры: дата начала периода, дата окончания периода, файл экспорта, маска счетов
     Место запуска: из процедуры pir-turnexp0.p 
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.2  2009/04/17 09:36:20  Buryagin
     Изменения: Added preview. NOW, NOT RUN by scheduler!!!
     Изменения:
     Изменения: Revision 1.1  2009/04/15 13:49:35  Buryagin
     Изменения: New report to PirReportSystem. This procedures need for auto saving same reports, listed in PIRRepSystem classifier. Procedure pir-turnexp0.p - runs by BISQUIT scheduler. Procedure pir-turnexpm.p - runs manually.
     Изменения:
------------------------------------------------------ */
{globals.i}

/** интерфейс для автоматического сохранения */
DEF INPUT PARAM iBegDate    AS DATE NO-UNDO. /* Начальная дата         */
DEF INPUT PARAM iEndDate    AS DATE NO-UNDO. /* конечная дата          */
DEF INPUT PARAM iFile       AS CHAR NO-UNDO. /* передаваемое имя файла */
DEF INPUT PARAM iParam      AS CHAR NO-UNDO. /* маска счетов */

DEF VAR acctMask AS CHAR NO-UNDO.
acctMask = iParam.

{pirraproc.def}

{pirraproc.i &in-beg-date=iBegDate &in-end-date=iEndDate &arch_file_name=iFile &arch_file_name_var=yes}

{setdest.i &filename=arch_file_name &cols=175}

{genpos.i
	&mask-acct=acctMask
    &parDateEnd=iEndDate
    &parDateBeg=iBegDate
    &nobalcur=yes
	&setzerozo=no
	&destalready=yes
	
	&turnover=yes
  	&lastmove=yes
  	&outgoing=yes
  	&names=yes
}

{preview.i &filename=arch_file_name}

MESSAGE "Данные сохранены в " + arch_file_name + " ! Найдите файл и проверте!!!" VIEW-AS ALERT-BOX.    

