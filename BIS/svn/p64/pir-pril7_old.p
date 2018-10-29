{pirsavelog.p}
/* ------------------------------------------------------
File          : $RCSfile: pir-pril7.p,v $ $Revision: 1.1 $ $Date: 2008-04-30 06:46:21 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Базируется    : POSNEW1.P
Причина       : Приказ №64 от 25.10.2005
Назначение    : Приложение №7
Параметры     : - Начальная дата
              : - Конечная дата
              : - Код подразделения
              : - имя отчета             
              : - имя класса данных              
Место запуска : Планировщик задач, процедура pir-shdrep.p 
Автор         : $Author: kuntash $ 
Изменения     : $Log: not supported by cvs2svn $
------------------------------------------------------ */
DEF INPUT PARAM iBegDate    AS DATE NO-UNDO. /* начальна дата         */
DEF INPUT PARAM iEndDate    AS DATE NO-UNDO. /* конечная дата         */
DEF INPUT PARAM iBranch     AS CHAR NO-UNDO. /* код подразделения     */
DEF INPUT PARAM iReport     AS CHAR NO-UNDO. /* имя отчета          */
DEF INPUT PARAM iClass      AS CHAR NO-UNDO. /* имя класса данных      */
DEF INPUT PARAM iBalCat     AS CHAR NO-UNDO. /* список балансовых счетов */



DEFINE VARIABLE in-DataClass-Id LIKE DataClass.DataClass-Id NO-UNDO.
DEFINE VARIABLE in-branch-id    LIKE DataBlock.Branch-Id    NO-UNDO.
DEFINE VARIABLE Out-Data-Id     LIKE DataBlock.Data-Id      NO-UNDO.
DEFINE VARIABLE in-beg-date     LIKE DataBlock.beg-date     NO-UNDO.
DEFINE VARIABLE in-end-date     LIKE DataBlock.end-date     NO-UNDO.
DEFINE VARIABLE in-partition    LIKE user-proc.partition    NO-UNDO.

{globals.i}
{norm.i NEW}

ASSIGN
   in-beg-date     = iBegDate
   in-end-date     = iEndDate
   in-dataClass-Id = iClass
   in-branch-id    = iBranch
.

gRemote = yes.

{norm-beg.i 
   &recalc    = YES
   &nobeg     = YES 
   &noend     = YES 
   &hibeg     = YES 
   &nofil     = YES
   &title     = "'ГЕНЕРАЦИЯ ОТЧЕТА'" 
   &is-branch = YES 
   &with-zo   = YES}

{justamin}  
RUN sv-get.p (       in-dataClass-Id, 
                     in-branch-id, 
                     in-end-date, 
                     in-end-date, 
              OUTPUT out-data-id).

RUN norm-rpt.p (in-partition, iReport, in-branch-id, in-end-date, in-end-date).
 
