{pirsavelog.p}
/* ------------------------------------------------------
File          : $RCSfile: pir-swpn.p,v $ $Revision: 1.5 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Базируется    : sword.i
Причина       : 13.08.2007, Кирносова , бухгалтерия.
              : Сортировака документов по номеру документа
Назначение    : Сводный мемориальный ордер
Описание      : 
Параметры     : 
Место запуска : Операции/Документы дня/Ctrl+G/Отчеты по проводкам
Автор         : $Author: anisimov $
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.4  2007/09/07 12:00:45  lavrinenko
Изменения     : *** empty log message ***
Изменения     :
Изменения     : Revision 1.3  2007/09/07 11:41:50  lavrinenko
Изменения     : Исправление заголовка
Изменения     :
------------------------------------------------------ */

{globals.i}
{pp-uni.var}
{pp-uni.prg}
{intrface.get strng}    /* Библиотека для работы со строками. */
{flt-val.i}
{strtout3.i &cols=95 &custom="printer.page-lines - "}
{get_set.i "Банк"}

DEFINE VARIABLE sDate        AS CHARACTER FORMAT "x(29)"   NO-UNDO.  /* дата         */
DEFINE VARIABLE sFilt        AS CHARACTER FORMAT "x(29)"   NO-UNDO.  /* имя фильтра  */
DEFINE VARIABLE acct-db      AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE acct-cr      AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cAmtStr      AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cDecStr      AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE amtstr1      AS CHARACTER EXTENT 3         NO-UNDO.
DEFINE VARIABLE i-amt-rub    LIKE op-entry.amt-rub  INIT 0 NO-UNDO.
DEFINE VARIABLE i-amt-cur    LIKE op-entry.amt-cur  INIT 0 NO-UNDO.
DEFINE VARIABLE i-cur        LIKE op-entry.currency INIT ? NO-UNDO.
DEFINE VARIABLE mKolStr      AS INTEGER                    NO-UNDO.  /* счетчик непустых строк поля op.details после разбиения */
DEFINE VARIABLE mBegDate     AS DATE                       NO-UNDO.
DEFINE VARIABLE mEndDate     AS DATE                       NO-UNDO.
DEFINE VARIABLE mDetail      AS Character Extent         7 No-Undo.

{tmprecid.def}        /** Используем информацию из броузера */

DEFINE TEMP-TABLE totals NO-UNDO /* итоги тут */
    FIELD currency LIKE op-entry.currency
    FIELD amt-rub  LIKE op-entry.amt-rub
    FIELD amt-cur  LIKE op-entry.amt-cur
    FIELD i        AS   INT /* кол-во проводок */.
.

PUT UNFORMATTED  setting.val SKIP(2). /* название банка */

ASSIGN
   i-amt-rub    = 0
   i-amt-cur    = 0
   mBegDate     = IF GetFltVal('op-date1') = ?
                  THEN gend-date
                  ELSE DATE(GetFltVal('op-date1'))
   mEndDate     = IF GetFltVal('op-date2') = ?    
                  THEN gend-date                  
                  ELSE DATE(GetFltVal('op-date2'))
   PackagePrint = YES
   sDate        = STRING(CAPS({term2str mBegDate mEndDate YES}), "x(30)" )
   sFilt        = FStrCenter(IF IsFieldChange("*") 
                             THEN ('Фильтр "' + GetEntries(3,GetFltVal("UserConf"),",","?") + '"') 
                             ELSE "Все документы",75 )
.

PUT UNFORMATTED  "                     СВОДНЫЙ МЕМОРИАЛЬНЫЙ ОРДЕР" SKIP.
PUT UNFORMATTED  "                       ЗА " + STRING(sDate, "x(24)") SKIP(1).
PUT UNFORMATTED  "┌──────┬────────────────────┬────────────────────┬────┬───────────────────┬───────────────────┬──────────────────────────────┐" SKIP.
PUT UNFORMATTED  "│Док.N │        Дебет       │       Кредит       │Вал.│    Сумма в валюте │ Сумма в нац.вал.  │       Назначение платежа     │" SKIP.
PUT UNFORMATTED  "├──────┼────────────────────┼────────────────────┼────┼───────────────────┼───────────────────┼──────────────────────────────┤" SKIP.


FOR EACH tmprecid NO-LOCK,


   FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK,
   EACH op-entry OF op NO-LOCK BREAK BY op-entry.currency  by int(op.doc-num) BY op-entry.amt-rub:
/*   FIRST op-entry WHERE RECID(op-entry) = tmprecid.id NO-LOCK,
   FIRST op OF op-entry NO-LOCK BREAK  BY op-entry.currency by int(op.doc-num) BY op-entry.amt-rub:*/


      ASSIGN
         acct-cr =  IF (op-entry.acct-cr <> ?) THEN op-entry.acct-cr ELSE ""
         acct-db =  IF (op-entry.acct-db <> ?) THEN op-entry.acct-db ELSE ""
      .
      ACCUMULATE op-entry.amt-rub (TOTAL COUNT BY op-entry.currency).
      ACCUMULATE op-entry.amt-cur (TOTAL COUNT BY op-entry.currency).

/*&IF DEFINED(FILE_SWORD_I_NAZN) NE 0
&THEN*/
      RUN DefDetail.
      mDetail = op.details.
      {wordwrap.i &s = mDetail &n = 7 &l = 30}
/* &ENDIF */
      PUT UNFORMATTED
         "│" + STRING(op.doc-num, "xxxxxx")                    +
         "│" + STRING(acct-db, "x(20)")                        +
         "│" + STRING(acct-cr, "x(20)")                        +
         "│" + STRING(op-entry.currency, "x(4)")               +
         "│" + STRING(op-entry.amt-cur, "->>>,>>>,>>>,>>9.99") +
         "│" + STRING(op-entry.amt-rub, "->>>,>>>,>>>,>>9.99").

/*&IF DEFINED(FILE_SWORD_I_NAZN) NE 0
&THEN*/
      PUT UNFORMATTED "│" STRING(mDetail[1],"x(30)").
      DO mKolStr = 2 TO 7:
         IF mDetail[mKolStr] NE "" THEN
            PUT UNFORMATTED "│" SKIP "│      │                    │                    │    │                   │                   │"
                + STRING(mDetail[mKolStr],"x(30)").
      END.
/* &ENDIF*/
      PUT UNFORMATTED "│" SKIP.

      IF LAST-OF(op-entry.currency) THEN DO:
         CREATE totals.
         ASSIGN
            totals.currency = op-entry.currency
            totals.amt-rub = (ACCUM TOTAL BY op-entry.currency op-entry.amt-rub)
            totals.amt-cur = (ACCUM TOTAL BY op-entry.currency op-entry.amt-cur)
            totals.i =       (ACCUM COUNT BY op-entry.currency op-entry.amt-rub)
         .
      END. /* LAST-OF */
END. /* FOR EACH tmprecid */

/*&IF DEFINED(FILE_SWORD_I_NAZN) NE 0
&THEN*/
PUT UNFORMATTED "├──────┴────────────────────┴────────────────────┴────┴───────────────────┴───────────────────┴──────────────────────────────┤" SKIP.
/* &ENDIF*/

FOR EACH totals:
   PUT UNFORMATTED  "│ Итого: " 
       + STRING(totals.i, ">>>>9") + " пров.  " 
       + "                            " 
       + STRING(totals.currency, "xxxx") + " " 
       + STRING(totals.amt-cur,  "->>>,>>>,>>>,>>9.99") + " " 
       + STRING(totals.amt-rub,  "->>>,>>>,>>>,>>9.99") +

/*&IF DEFINED(FILE_SWORD_I_NAZN) NE 0
&THEN*/
       FILL(" ",31) +
/*&ENDIF**/
      "│" SKIP.

   ASSIGN
      i-amt-rub = i-amt-rub + totals.amt-rub
      i-amt-cur = i-amt-cur + totals.amt-cur
   .
   IF i-cur = ? THEN i-cur = totals.currency.
   ELSE IF i-cur <> totals.currency THEN i-cur = "".
END. /* FOR EACH totals */

{empty totals}

/* &IF DEFINED(FILE_SWORD_I_NAZN) NE 0
&THEN */
   PUT UNFORMATTED "└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘" SKIP.
/* &ENDIF */

PUT UNFORMATTED SKIP(2).

PUT UNFORMATTED "Бухгалтер _______________________    Контролер __________________________" SKIP(2).

PackagePrint = FALSE.
{endout3.i}
