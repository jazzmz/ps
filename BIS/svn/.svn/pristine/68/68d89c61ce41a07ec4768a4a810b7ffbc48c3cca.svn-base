{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-pril9.p,v $ $Revision: 1.5 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Базируется    : p14-9bas.p
Причина       : Приказ №64 от 25.10.2005
Назначение    : Приложение №8
Параметры     : - Начальная дата
              : - Конечная дата
              : - Код подразделения
              : - Имя файла
              : - Список балансовых категорий счетов участвующих в построении отчета              
              : - Дополнительные параметры процедуры через ","              
Место запуска : Планировщик задач, процедура pir-shdrep.p 
Автор         : $Author: anisimov $ 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.4  2007/08/21 13:39:00  lavrinenko
Изменения     : Реализовано сохранение в месячные и годовые е каталоги
Изменения     :
Изменения     : Revision 1.3  2007/08/16 14:08:30  Lavrinenko
Изменения     : Исправление описания
Изменения     :
Изменения     : Revision 1.2  2007/08/16 13:12:30  Lavrinenko
Изменения     : изменение формата вызова
Изменения     :
Изменения     : Revision 1.1  2007/08/15 14:22:54  Lavrinenko
Изменения     : Реализация  приказа N9
Изменения     :
------------------------------------------------------ */
{globals.i}

DEF INPUT PARAM iBegDate    AS DATE NO-UNDO. /* Начальная дата         */
DEF INPUT PARAM iEndDate    AS DATE NO-UNDO. /* Конечная дата          */
DEF INPUT PARAM iBranch     AS CHAR NO-UNDO. /* Код подразделения      */
DEF INPUT PARAM iFile       AS CHAR NO-UNDO. /* передаваемое имя файла */
DEF INPUT PARAM iParam      AS CHAR NO-UNDO. /* список балансовых категорий счетов участвующих в построении отчета */

ASSIGN
   gRemote   = YES 
   gbeg-date = iBegDate
   gend-date = iEndDate
.

FIND FIRST branch WHERE branch.branch-id EQ iBranch NO-LOCK NO-ERROR.

{pirraproc.def}
{pirraproc.i &in-beg-date=iBegDate &in-end-date=iEndDate &arch_file_name=iFile &arch_file_name_var=yes}

&GLOB filename arch_file_name
&GLOBAL-DEFINE p14-8 YES /*таким хитрым образом меняется номер распоряжения. заявка #2809*/

{p14-9bas.p }
