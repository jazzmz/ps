{pirsavelog.p}
/** pir_ree321p1.p  ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007, Борисов А.В.
    Реестр ПОДФТ
    Запускается в рабочем дне через меню Ctrl-G
  15/02/12 SStepanov - идет теперь по блоку данных Legal321 за текущий опердень.
*/

{globals.i}           /** Глобальные определения */
{tmprecid.def}        /** Используем информацию из броузера */
{intrface.get xclass} /** Функции для работы с метасхемой */
{intrface.get strng}  /** Функции для работы со строками */
{ulib.i}              /*  Библиотека функций для работы со счетами */

{sh-defs.i}
{setdest.i} /* Вывод в preview */

/******************************************* Определение переменных и др. */
DEF VAR cKOP       AS CHAR EXTENT 5 NO-UNDO.
DEF VAR cId        AS CHAR          NO-UNDO.
DEF VAR cSndName   AS CHAR EXTENT 5 NO-UNDO.
DEF VAR cSndAcct   AS CHAR          NO-UNDO.
DEF VAR cRsvName   AS CHAR EXTENT 5 NO-UNDO.
DEF VAR cRsvAcct   AS CHAR          NO-UNDO.
DEF VAR cDelail    AS CHAR EXTENT 5 NO-UNDO.
DEF VAR cT1        AS CHAR          NO-UNDO.
DEF VAR cT2        AS CHAR          NO-UNDO.
DEF VAR cT3        AS CHAR          NO-UNDO.
DEF VAR DATE-ree   AS DATE          NO-UNDO.
DEF VAR I          AS INTEGER       NO-UNDO.
DEFINE QUERY q-oe FOR op-entry.

&SCOP FILE_sword_p NO
{pirpp-uni.var}                     /* определение переменных        */
{pirpp-uni.prg}                     /* описание стандартных процедур */

/* Alternativ date */
/*
FOR FIRST tmprecid NO-LOCK,
    FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK
   DATE-ree = op.op-DATE.
END.
*/
   DATE-ree = gend-date.

/******************************************* Реализация */
/* Шапка отчета */
PUT UNFORMATTED
"                                         Реестр операций, подлежащих С\С по 321-П за " STRING(DATE-ree) SKIP(1)
"┌────────┬──────┬────────────────────┬───────────────────────────────────┬────────────────────┬───────────────────────────────────┬───┬───────────────┬───────────────┬──────────────────────────────────────────────────┬───────────┬──────────┐" SKIP
"│  Дата  │№ Док.│ Счет плательщика   │             Плательщик            │  Счет получателя   │             Получатель            │Код│     Сумма     │     Сумма     │                Назначение платежа                │Исполнитель│   Код    │" SKIP
"│  Док.  │      │      (дебет)       │                                   │      (кредит)      │                                   │вал│   ин.валюты   │  нац.валюты   │                                                  │           │ операции │" SKIP
.
/*
FOR EACH tmprecid
   NO-LOCK,
   FIRST op
      WHERE RECID(op) EQ tmprecid.id
   NO-LOCK:
*/
FOR /* FIRST DataClass
	WHERE DataBlock.Beg-Date  EQ gend-date
	NO-LOCK
	, */ EACH DataBlock
	WHERE DataBlock.Beg-Date  EQ gend-date
	  AND DataBlock.Branch-Id EQ '0000' /* AND DataBlock.Data-Id EQ 539824 */
	  AND DataBlock.DataClass-Id EQ 'Legal321' AND DataBlock.End-Date EQ gend-date
	NO-LOCK
	,
    EACH DataLine OF DataBlock
	WHERE DataLine.Sym2 = "Общие данные"
	  AND DataLine.Data-ID EQ DataBlock.Data-Id
	NO-LOCK ,
    FIRST op
      WHERE op.op = INT(DataLine.val[12])
	NO-LOCK
:
   OPEN QUERY q-oe
      FOR EACH op-entry OF op
      NO-LOCK
      BY op-entry.amt-rub DESCENDING.

   GET FIRST q-oe.

   if entry(8,DataLine.txt,CHR(10)) ne "0" then
	   cKOP[1]   = GetXAttrValue("op", STRING(op.op), "КодОпОтмыв") + "/" + entry(8,DataLine.txt,CHR(10)). 
   else  cKOP[1]   = GetXAttrValue("op", STRING(op.op), "КодОпОтмыв").

   IF     (cKOP[1] NE "")
      AND (cKOP[1] NE "8001")
   THEN DO:

      RUN Collection-Info.


      IF    (op.doc-type EQ "03")
         OR (op.doc-type EQ "031")
      THEN DO:
         /* реквизиты плательщика                     */
         cSndAcct    = op-entry.acct-db.
         IF (cSndAcct BEGINS "20202")
           THEN cSndName[1] = cBankName.
           ELSE cSndName[1] = GetAcctClientName_UAL(cSndAcct, NO).
         /* реквизиты получателя                      */
         cRsvAcct    = op-entry.acct-cr.
         IF (cRsvAcct BEGINS "20202")
           THEN cRsvName[1] = cBankName.
           ELSE cRsvName[1] = GetAcctClientName_UAL(cRsvAcct, NO).
      END.
      ELSE DO:
         /* реквизиты плательщика                     */
         RUN for-pay("ДЕБЕТ,ПЛАТЕЛЬЩИК,БАНКПЛ,БАНКГО,БАНКФИЛ", "ВО",
                     OUTPUT cSndName[1], OUTPUT cSndAcct,
                     OUTPUT cT1, OUTPUT cT2, OUTPUT cT3).
         /* реквизиты получателя                      */
         RUN for-rec("КРЕДИТ,ПОЛУЧАТЕЛЬ,БАНКПОЛ,БАНКГО,БАНКФИЛ", "ВО",
                     OUTPUT cRsvName[1], OUTPUT cRsvAcct,
                     OUTPUT cT1, OUTPUT cT2, OUTPUT cT3).
      END.

      RUN DelInnKpp(INPUT-OUTPUT cSndName[1]).
      RUN DelInnKpp(INPUT-OUTPUT cRsvName[1]).
      cDelail[1] = op.details.

      {wordwrap.i &s=cSndName &n=5 &l=35}
      {wordwrap.i &s=cRsvName &n=5 &l=35}
      {wordwrap.i &s=cDelail  &n=5 &l=50}
      {wordwrap.i &s=cKOP     &n=5 &l=10}

      /* Выводим строку таблицы */
      PUT UNFORMATTED 
         "├────────┼──────┼────────────────────┼───────────────────────────────────┼────────────────────┼───────────────────────────────────┼───┼───────────────┼───────────────┼──────────────────────────────────────────────────┼───────────┼──────────┤" SKIP
         "│" op.op-date    	FORMAT "99/99/99"
         "│" op.doc-num 	FORMAT "x(6)"
         "│" cSndAcct 		FORMAT "x(20)"
         "│" cSndName[1] 	FORMAT "x(35)"
         "│" cRsvAcct 		FORMAT "x(20)"
         "│" cRsvName[1] 	FORMAT "x(35)"
         "│" IF op-entry.currency EQ ""
		THEN "643"
		ELSE op-entry.currency
         "│" op-entry.amt-cur 	FORMAT "->>>,>>>,>>9.99"
         "│" op-entry.amt-rub 	FORMAT "->>>,>>>,>>9.99"
         "│" cDelail[1] 	FORMAT "x(50)"
         "│" op.user-id 	FORMAT "x(11)"
         "│" cKOP[1] 		FORMAT "x(10)"
         "│" SKIP.

      DO I = 2 TO 5
         WHILE (cSndName[I] NE "")
            OR (cRsvName[I] NE "")
            OR (cDelail[I]  NE "")
            OR (cKOP[I]  NE "")
      :
         PUT UNFORMATTED
         "│        "
         "│      "
         "│                    "
         "│" cSndName[I] FORMAT "x(35)"
         "│                    "
         "│" cRsvName[I] FORMAT "x(35)"
         "│   "
         "│               "
         "│               "
         "│" cDelail[I] FORMAT "x(50)"
         "│           "
         "│" cKOP[I] FORMAT "x(10)"
         "│" SKIP.
      END.

      FOR EACH Info-Store:
        DELETE Info-Store.
      END.

   END.
END.

PUT UNFORMATTED
"└────────┴──────┴────────────────────┴───────────────────────────────────┴────────────────────┴───────────────────────────────────┴───┴───────────────┴───────────────┴──────────────────────────────────────────────────┴───────────┴──────────┘" SKIP.
.
/* Отображаем содержимое preview */
{preview.i}

{intrface.del}

PROCEDURE DelInnKpp:
   DEFINE INPUT-OUTPUT PARAMETER cN  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE iT1  AS INTEGER NO-UNDO.
   DEFINE VARIABLE iT2  AS INTEGER NO-UNDO.

   iT1 = INDEX(cN, "ИНН").
   IF iT1 NE 0
   THEN DO:
      iT2 = INDEX(cN, " ", iT1 + 4).
      cN  = SUBSTRING(cN, 1, iT1 - 1) + SUBSTRING(cN, iT2 + 1, LENGTH(cN) - iT2).
   END.

   iT1 = INDEX(cN, "КПП").
   IF iT1 NE 0
   THEN DO:
      iT2 = INDEX(cN, " ", iT1 + 4).
      cN  = SUBSTRING(cN, 1, iT1 - 1) + SUBSTRING(cN, iT2 + 1, LENGTH(cN) - iT2).
   END.

END PROCEDURE.