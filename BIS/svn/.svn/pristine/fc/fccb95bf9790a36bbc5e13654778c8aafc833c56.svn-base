/* ------------------------------------------------------
     File: $RCSfile: pir-turnexpm.p,v $ $Revision: 1.2 $ $Date: 2009-04-17 09:36:20 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: Приказ 21 от 27.03.2009
     Что делает: Вызывает процедуру которая реализует автоматическое сохранение в архив
     Как работает: Полная цепочка вызова всех процедур
                   примерно выглядит так:
                   
                   pir-turnexpm.p -> pir-turnexp1.p -> genpos.i
                   
     Параметры: <файл>;<маска счетов>
     Место запуска: БМ-Печать-Выходные формы-Отчеты по Лицевым счетам-РАЗНОЕ
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.1  2009/04/15 13:49:35  Buryagin
     Изменения: New report to PirReportSystem. This procedures need for auto saving same reports, listed in PIRRepSystem classifier. Procedure pir-turnexp0.p - runs by BISQUIT scheduler. Procedure pir-turnexpm.p - runs manually.
     Изменения:
------------------------------------------------------ */
{globals.i}

DEF INPUT PARAM iParam      AS CHAR NO-UNDO. /* маска счетов */

DEF VAR iBegDate    AS DATE NO-UNDO. /* Начальная дата         */
DEF VAR iEndDate    AS DATE NO-UNDO. /* конечная дата          */
DEF VAR iFile       AS CHAR NO-UNDO. /* передаваемое имя файла */

IF NUM-ENTRIES(iParam, ";") <> 2 THEN DO:
	MESSAGE "Неверное число параметров! Нужно <файл_экспорта>;<маска_счетов>" VIEW-AS ALERT-BOX.
	RETURN.
END.

{getdates.i}

iBegDate = beg-date.
iEndDate = end-date.

iFile = ENTRY(1, iParam, ";").
iParam = ENTRY(2, iParam, ";").

/** Если вы заметили, что последний параметр равняется 1 и его значение вы не понимаете, 
    не волнуйтесь, я его тоже не понял, но этот параметр необходим, и его значение,
    судя по экспериментам, ни на что не влияет. В genpos.i есть несколько 
    DEF INPUT PARAM, которые ограничены макросами &IF*, но видимо прекомпилятору
    пофиг, и он их все равно включает в общий интерфейс процедуры.
*/
RUN pir-turnexp1 (iBegDate,                    /* начальная дата         */
                  iEndDate,                    /* конечная дата          */
                  iFile,       /* передаваемое имя файла */
                  iParam,
                  "1").      /* параметры процедуры    */

