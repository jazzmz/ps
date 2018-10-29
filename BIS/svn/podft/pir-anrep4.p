{pirsavelog.p}
/* ---------------------------------------------------------------------
Copyright  : (C) 2007, КБ ООО "Пpоминвестрасчет"
Office memo: ПОДФТ, Гаман В.В.
Function   : Построение отчета по клиентам, чьи анкеты давно не обновлялись.
Created    : 12.08.2009 borisov
---------------------------------------------------------------------- */

DEFINE INPUT PARAMETER ipTypeCli  AS CHARACTER NO-UNDO. /* Тип клиента */

DEF VAR lLevelRisk   AS CHARACTER LABEL "Уровень риска"
                        VIEW-AS COMBO-BOX LIST-ITEMS "Высокий", "Средний", "Низкий", "Неуказан"
                        FORMAT "x(10)" INITIAL "Высокий"   NO-UNDO. /* Степень риска */
DEF VAR lLastUpdate  AS DATE      LABEL "Дата обновления"  NO-UNDO. /* Дата последнего обновления        */
/* DEF VAR lBlockAcct   AS DATE LABEL "Дата блокировки"  NO-UNDO.  пороговая дата блокировки счета   */
DEF VAR clLastUpdate AS DATE         NO-UNDO.
DEF VAR iCount       AS INTEGER      NO-UNDO.

DEF VAR gcSotr       AS CHARACTER    NO-UNDO.
DEF VAR gcAcct       AS CHARACTER    NO-UNDO.
DEF VAR gdLastMove   AS DATE         NO-UNDO.
DEF VAR gdAcctOpen   AS DATE         NO-UNDO.
DEF VAR gdAcctClose  AS DATE         NO-UNDO.
DEF VAR gdAnketaLast AS DATE         NO-UNDO.
DEF VAR gcOGRN       AS CHARACTER    NO-UNDO.

DEF VAR cTmpStr      AS CHARACTER    NO-UNDO. 

{globals.i}
{intrface.get xclass}
{pir_exf_exl.i}
{pir_anketa.fun}

/*******************************************************************************************************/
/* ------------------------------------------------------- */
/** Поиск даты последнего движения по счету ********/
FUNCTION LookLastMove RETURNS DATE
   (INPUT in-acct     AS CHAR,
    INPUT in-currency AS CHAR).

   DEFINE VARIABLE vLastPos AS DATE  NO-UNDO.

   FOR EACH op-entry
      WHERE (op-entry.acct-db EQ in-acct)
         OR (op-entry.acct-cr EQ in-acct)
      NO-LOCK,
      FIRST op
         WHERE (op.op EQ op-entry.op)
           AND (op.op-status GE "√")
           NO-LOCK
      BY op-entry.op-date DESCENDING:

      RETURN op-entry.op-date.
   END.

   RETURN ?.

END FUNCTION.

/* ------------------------------------------------------- */
/*  */
FUNCTION IsUserAcct RETURNS LOG
   (INPUT ipType  AS CHARACTER,
    INPUT ipId    AS INTEGER,
    INPUT ipLDate AS DATE).

   DEFINE VARIABLE dLastMove AS DATE       NO-UNDO.
   DEFINE VARIABLE cAcctList AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cTmpAL    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iALNum    AS INTEGER    NO-UNDO.
   DEFINE VARIABLE iI        AS INTEGER    NO-UNDO.

   cAcctList  = KlientAcctList(ipType).
   iALNum     = NUM-ENTRIES(cAcctList, ";").
   gcAcct     = "".
   gdLastMove = 01/01/1900.

   DO iI = 1 TO (iALNum - 1):

      cTmpAL = ENTRY(iI, cAcctList, ";").

      FOR EACH acct
         WHERE acct.cust-cat   EQ KlType(ipType)
           AND acct.cust-id    EQ ipId
           AND NOT CAN-DO("Накоп,СпецТр,Тр*", acct.contract)
           AND acct.close-date EQ ?
           AND CAN-DO(cTmpAL, acct.acct)
         NO-LOCK:

         dLastMove = LookLastMove(acct.acct, acct.currency).

         IF     (dLastMove NE ?)
            AND (dLastMove GT gdLastMove)
         THEN
            ASSIGN
               gcAcct      = acct.acct
               gdLastMove  = dLastMove
               gdAcctOpen  = acct.open-date
               gdAcctClose = ?
            .
      END.

      IF (gcAcct NE "")
      THEN RETURN YES.
   END.

   /* Проверяем закрытые счета */
   gdAcctClose = 01/01/1900.

   DO iI = 1 TO (iALNum - 1):

      cTmpAL = ENTRY(iI, cAcctList, ";").

      FOR EACH acct
         WHERE acct.cust-cat   EQ KlType(ipType)
           AND acct.cust-id    EQ ipId
           AND NOT CAN-DO("Накоп,СпецТр,Тр*", acct.contract)
           AND CAN-DO(cTmpAL, acct.acct)
         NO-LOCK:

         dLastMove = LookLastMove(acct.acct, acct.currency).

         IF (acct.close-date GT gdAcctClose)
         THEN
            ASSIGN
               gcAcct      = acct.acct
               gdLastMove  = dLastMove
               gdAcctOpen  = acct.open-date
               gdAcctClose = acct.close-date
            .
      END.

      IF (gcAcct NE "")
      THEN RETURN (gdAcctClose GE ipLDate).
   END.

   RETURN NO.

END FUNCTION. /* IsUserAcct */

/* ------------------------------------------------------- */
/* получение даты последнего изменения по карточке клиента 
FUNCTION GetLastHistDate RETURNS DATE
   (INPUT ipName AS CHAR, INPUT ipId AS CHAR, INPUT iSotr AS CHAR).

   FIND LAST history
      WHERE history.file-name EQ ipName
        AND history.field-ref EQ ipId

spisok polej 

        AND (history.modif-date GT ipSince OR ipSince EQ ?) 
        AND CAN-DO(iSotr, history.user-id)
      NO-LOCK NO-ERROR.

   RETURN (IF AVAIL history THEN history.modif-date ELSE ?).

END FUNCTION.  GetLastHistDate  */

/* ------------------------------------------------------- */
/* проверка соотвествия установленному уровню риска */
FUNCTION IsNeedUpDate RETURNS LOGICAL
   (INPUT  ipType  AS CHARACTER,
    INPUT  ipId    AS CHARACTER,
    INPUT  ipRlvl  AS CHARACTER,
    INPUT  ipLDate AS DATE).

   DEFINE VARIABLE clLevelRisk  LIKE lLevelRisk    NO-UNDO.
   DEFINE VARIABLE cTmp         AS CHARACTER       NO-UNDO.

   gcOGRN      = GetXAttrValue(KlTabl(ipType), ipId, "ОГРН").
   clLevelRisk = GetXAttrValue(KlTabl(ipType), ipId, "РискОтмыв").

   /* определение принадлежности к выбранной группе риска */
   IF    (ipRlvl EQ "Высокий"  AND clLevelRisk BEGINS "П")
      OR (ipRlvl EQ "Средний"   AND clLevelRisk EQ "Средний")
      OR (ipRlvl EQ "Низкий"   AND clLevelRisk EQ "Низкий")
      OR (ipRlvl EQ "Неуказан" AND clLevelRisk NE "Низкий"
                               AND NOT clLevelRisk BEGINS "П")
   THEN DO:

      /* проверка наличия счетов */
      IF IsUserAcct(ipType, INTEGER(ipId), ipLDate)
      THEN DO:
/*         gdAnketaLast = GetLastHistDate(ipName, ipId, gcSotr). */
         RUN GetLastAnketaDate(ipType, INTEGER(ipId), OUTPUT gdAnketaLast, OUTPUT cTmp).

         IF (gdAcctClose EQ ?)
         THEN RETURN (gdAnketaLast LE ipLDate).
         ELSE RETURN (DATE(MONTH(gdAnketaLast), DAY(gdAnketaLast), YEAR(gdAnketaLast)
                      + (IF (ipRlvl EQ "Высокий") THEN 1 ELSE 3)) LE gdAcctClose).
      END.

   END. /* IF lLevelRisk */

   RETURN NO.
END FUNCTION. /* IsNeedUpDate */

/* ------------------------------------------------------- */
/*  */
PROCEDURE StrOutXL.
DEFINE INPUT PARAMETER ipClName AS CHARACTER  NO-UNDO.

   cTmpStr = XLCell(gcAcct)
           + XLDateCell(gdAcctOpen)
           + XLDateCell(gdAcctClose)
           + XLDateCell(gdLastMove)
           + XLDateCell(gdAnketaLast)
           + XLCell(gcOGRN)
           + XLCell(ipClName)
           .

   PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd() .

END PROCEDURE. /* StrOutXL */
/*******************************************************************************************************/

/* ввод параметров поиска */
lLastUpdate = DATE(MONTH(TODAY), DAY(TODAY), YEAR(TODAY) - 1).

DO ON ERROR  UNDO, LEAVE
   ON ENDKEY UNDO, LEAVE
   WITH FRAME params:

   DISPLAY lLevelRisk  SKIP
           lLastUpdate SKIP
      WITH FRAME params COLOR BRIGHT-WHITE.

   UPDATE
      lLevelRisk  HELP "Присвоенный клиенту уровень риска"
      lLastUpdate HELP "Дата, до которой анкеты считаются необновленными"
      WITH CENTERED ROW 10 OVERLAY SIDE-LABELS 1 COL
      TITLE "[ ЗАДАЙТЕ ПАРАМЕТРЫ ]"
      EDITING:
         READKEY.

         ON VALUE-CHANGED,
            LEAVE OF lLevelRisk IN FRAME params
            DO:

            CASE lLevelRisk:SCREEN-VALUE:
               WHEN 'Высокий' THEN DO:
                  lLastUpdate = DATE (MONTH(TODAY), DAY (TODAY), YEAR(TODAY) - 1 ).
                  DISPLAY lLastUpdate
                     WITH FRAME params.
               END.
               WHEN 'Средний' THEN DO:
                  lLastUpdate = DATE (MONTH(TODAY), DAY (TODAY), YEAR(TODAY) - 2 ).
                  DISPLAY lLastUpdate
                     WITH FRAME params.
               END.
               WHEN 'Низкий'  THEN DO:
                  lLastUpdate = DATE (MONTH(TODAY), DAY (TODAY), YEAR(TODAY) - 3 ).
                  DISPLAY lLastUpdate
                     WITH FRAME params.
               END.
            END CASE. /* CASE lLevelRisk   */
         END.

         ON "F1" OF lLastUpdate IN FRAME params   DO:
            RUN calend.p.

            IF     (RETURN-VALUE NE ?)
               AND {assigned pick-value}
            THEN SELF:SCREEN-VALUE = pick-value.
         END.

         DISPLAY
            WITH FRAME params.
         APPLY LASTKEY.
      END. /* EDITING*/

END. /* DO ON ERROR UNDO */

HIDE FRAME params NO-PAUSE.

IF KEYFUNC(LASTKEY) = "end-error" THEN
   {ifdef {&return}} {&return} {else} */ return {endif} */.

/* ============ */
{exp-path.i &exp-filename = "'Anketa4.xls'"}

PUT UNFORMATTED XLHead(STRING(lLastUpdate, "99.99.9999"), "CDDDDCC", "150,85,85,85,85,115,300").

cTmpStr = XLCell("Счет")
        + XLCell("Дата открытия")
        + XLCell("Дата закрытия")
        + XLCell("Дата последнего движения")
        + XLCell("Дата последнего исправления анкеты")
        + XLCell("ОГРН")
        + XLCell("Клиент")
        .

PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd() .

/* ============== */
CASE ipTypeCli:
   WHEN "Ю" THEN DO:
      FOR EACH cust-corp 
/*         WHERE (cust-corp.last-date LT lLastUpdate) */
         NO-LOCK
/*         BY cust-corp.name-short */ :

         IF IsNeedUpDate(UL-IP(cust-corp.cust-stat), STRING(cust-corp.cust-id), lLevelRisk, lLastUpdate)
         THEN DO:
            iCount = iCount + 1.
            RUN StrOutXL(cust-corp.cust-stat + " " + cust-corp.name-corp).
         END.
      END.
   END.

   WHEN "Б" THEN DO:
      FOR EACH banks
         WHERE (banks.last-date LT lLastUpdate)
         NO-LOCK
         BY banks.name:

         IF IsNeedUpDate("Б", STRING(banks.bank-id), lLevelRisk, lLastUpdate)
         THEN DO:
            iCount = iCount + 1.
            RUN StrOutXL(banks.name).
         END.
      END.
   END.

   WHEN "Ч" THEN DO:
      FOR EACH person
         WHERE (person.last-date LT lLastUpdate)
         NO-LOCK
         BY person.name-last:

         IF IsNeedUpDate("ФЛ", STRING(person.person-id), lLevelRisk, lLastUpdate)
         THEN DO:
            iCount = iCount + 1.
            RUN StrOutXL(person.name-last + " " + person.first-names).
         END.
      END.
   END.

END. /*CASE*/

PUT UNFORMATTED XLEnd().

{intrface.del}
