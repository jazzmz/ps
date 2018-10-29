{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pirp14-9bas.p,v $ $Revision: 1.3 $ $Date: 2007-10-18 07:42:23 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Базируется    : p14-9bas.p
Причина       : Приказ №64 от 25.10.2005
Назначение    : Приложение №8
Место запуска : БМ/Печать/выходные формы/План счетов(приложения 6..9), Форма 101/План счетов:прил 8,9/Рабочий план счетов
Автор         : ??????
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.2  2007/08/17 07:32:40  Lavrinenko
Изменения     : 1. Добавлен стандартный заголовок 2. произведены работы для корректного выноса norm-end.i norm-rpt.i
Изменения     :
------------------------------------------------------ */

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ТОО "Банковские информационные системы"
     Filename: p14-9bas.p
      Comment: Переходник для запуска отчета Приложение 9. из базового модуля
   Parameters:
         Uses:
      Used by:
      Created: 19/05/2003 YUSS
     Modified:
*/

DEFINE INPUT  PARAMETER iClassList AS CHARACTER  NO-UNDO.
/* Глобальные определения */
{ globals.i }
{ norm.i NEW }
{ intrface.get xclass }
{ intrface.get acct }
{ intrface.get date }
&glob beg-date in-beg-date
/* Локальные переменные */
{ wordwrap.def }
{ r-prl9.def NEW }
{ p14-9.def &workplan=yes }

DEFINE VARIABLE mClass     AS INTEGER   NO-UNDO.
DEFINE VARIABLE mDataID    AS INTEGER   NO-UNDO.
DEFINE VARIABLE mResult    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE mNoZero    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE vWidthChar AS CHARACTER NO-UNDO.

DEFINE VARIABLE vDelNullRazLog AS LOGICAL   NO-UNDO.

vDelNullRazLog = (INDEX(iClassList,"Разд.РАБ") <> 0).

/* Инициализация */
{ norm-beg.i
   &nobeg     = YES
   &hibeg     = YES
   &IS-BRANCH = YES
   &NOFIL     = YES
   &DEFS      = YES
   &TITLE     = "'ГЕНЕРАЦИЯ ОТЧЕТА'"
}

in-Beg-Date = in-End-Date. /* т.к. начальная дата не задается */
{ num-pril.i 8 "БАЛАНС||КРЕДИТНОЙ_ОРГАНИЗАЦИИ_РОССИЙСКОЙ_ФЕДЕРАЦИИ||НА_&2"}

vWorkPlanLog = fWorkPlan().
IF vWorkPlanLog EQ ? THEN RETURN.

vAllAcctLog = fAllAcct().
IF vAllAcctLog EQ ? THEN RETURN.

{r-tp.def &p14-9=yes}

IF NOT vAllAcctLog THEN
DO:
   vDelNullStrLog = fDelNullStr().
   IF vDelNullStrLog EQ ? THEN RETURN.
END.

IF NUM-ENTRIES (iClassList) = 1 THEN
   CASE SUBSTR (TRIM(iClassList), 1, 1):
      WHEN "b" THEN /* Баланс */
         vWidthChar = "164".
      WHEN "o" THEN /* Внебаланс */
         vWidthChar = "102".
      OTHERWISE    /* Все остальные категории */
         vWidthChar = "97".
   END CASE.
ELSE
   vWidthChar = "164".

&GLOB cols 0 + INT(vWidthChar)

{ modhead.i &out = "vHdrPril" &enddate = "in-end-date" }
/*
{pirraproc.def}
&GLOB filename arch_file_name
IF in-Branch-ID = "000000" THEN DO:
    {pirraproc.i &arch_file_name="pril_9s.txt"}
END.
IF in-Branch-ID = "0000" THEN DO:
    {pirraproc.i &arch_file_name="pril_9g.txt"}
END.
*/

{setdest.i}

run stdhdr_p.p (output mResult,
                       in-beg-date,
                       in-end-date,
                       vWidthChar + "," + vNumPril + "TOP" + ",{&in-LA-NCN1}," + vHdrPril + ",,YES").
/* Главный цикл */
DO mClass = 1 TO NUM-ENTRIES (iClassList):

   IF INDEX(ENTRY (mClass,iClassList),"Разд.РАБ") <> 0 THEN NEXT.

   /* Текущий класс */
   in-DataClass-Id = ENTRY (mClass,iClassList).
   RUN sv-get.p (       in-DataClass-ID,
                        in-Branch-ID,
                        in-Beg-Date,
                        in-End-Date,
                 OUTPUT mDataID).
   /* Запуск процедуры печати */
   CASE SUBSTR (in-DataClass-ID, 1, 1):
      /* Баланс */
      WHEN "b" THEN
      DO:
         IF vAllAcctLog THEN
            RUN p14-9b0.p (mDataID,vWorkPlanLog).
         ELSE
            RUN p14-9b.p (mDataID,vWorkPlanLog,vDelNullStrLog,vDelNullRazLog).
      END.
      /* Внебаланс */
      WHEN "o" THEN RUN p14-9v1.p (mDataID,vWorkPlanLog,vAllAcctLog,vDelNullStrLog).
      /* Все остальные категории */
      OTHERWISE     RUN p14-91b.p (mDataID,vWorkPlanLog,vAllAcctLog,vDelNullStrLog).
   END CASE.
END. /* Главный цикл */

/* очистка памяти */
{ intrface.del acct }
{ intrface.del date }

/* {signp8p9.i &department = branch } выводит дублирующие подписи под отчетом */
{signatur.i &department = branch }

{ norm-end.i
   &NOFIL = YES
}
/* Просмотр готового отчета */
{ preview.i}

