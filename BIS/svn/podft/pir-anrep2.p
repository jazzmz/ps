{pirsavelog.p}
/* ---------------------------------------------------------------------
Copyright  : (C) 2007, КБ ООО "Пpоминвестрасчет"
Office memo: ПОДФТ, Гаман В.В.
Function   : Построение отчета по клиентам, чьи анкеты давно не обновлялись.
Created    : 12.08.2009 borisov
---------------------------------------------------------------------- */

DEFINE INPUT PARAMETER ipParam AS CHAR NO-UNDO. /* Тип клиента */
DEF VAR ipTypeCli              AS CHAR NO-UNDO.
DEF VAR ipUpravl               AS CHAR NO-UNDO.

ipTypeCli = ENTRY(1, ipParam).
ipUpravl  = REPLACE(ENTRY(2, ipParam), ";", ",").

DEF VAR lLevelRisk   AS CHAR LABEL "Уровень риска"    VIEW-AS COMBO-BOX LIST-ITEMS "Высокий", "Низкий", "Неуказан" FORMAT "x(10)" INITIAL "Высокий" NO-UNDO. /* Степень риска */
DEF VAR lLastUpdate  AS DATE LABEL "Дата обновления"  NO-UNDO. /* Дата последнего обновления        */
/* DEF VAR lBlockAcct   AS DATE LABEL "Дата блокировки"  NO-UNDO.  пороговая дата блокировки счета   */
DEF VAR clLastUpdate AS DATE         NO-UNDO.
DEF VAR iCount       AS INTEGER      NO-UNDO.

DEF VAR gcSotr       AS CHAR         NO-UNDO.
DEF VAR gcAcct       AS CHAR         NO-UNDO.
DEF VAR gdLastMove   AS DATE         NO-UNDO.
DEF VAR gdAcctOpen   AS DATE         NO-UNDO.
DEF VAR gdAcctClose  AS DATE         NO-UNDO.
DEF VAR gdAnketaLast AS DATE         NO-UNDO.
DEF VAR gcOGRN       AS CHAR         NO-UNDO.

DEF VAR cTmpStr      AS CHAR         NO-UNDO. 

{globals.i}
{intrface.get xclass}
{pir_exf_exl.i}

/*******************************************************************************************************/
/* ------------------------------------------------------- */
/** Процедура поиска даты последнего движения по счету ********/
/** Код срисован из файлов acct-pos.i и last-pos.i pos ********/

FUNCTION LookLastMove RETURNS DATE (INPUT in-acct     AS CHAR,
                                    INPUT in-currency AS CHAR).

   DEFINE VARIABLE vLastPos AS DATE  NO-UNDO.
/*
   vLastPos = TODAY.
   REPEAT:
      FIND LAST acct-pos WHERE
         acct-pos.acct EQ in-acct AND
         acct-pos.currency EQ in-currency AND
         acct-pos.since LT vLastPos
         NO-LOCK NO-ERROR.
      /* только в случае отсутствия транзакции, иначе происходит
         переполнение таблицы блокировок */
      IF NOT TRANSACTION AND AVAIL acct-pos THEN DO:
         /* уменьшаем дату для исключения поиска заблокированной записи */
         vLastPos = acct-pos.since.
         FIND CURRENT acct-pos
            SHARE-LOCK NO-WAIT NO-ERROR.
         IF NOT AVAIL acct-pos THEN
            /* если запись успели удалить при откате дня
            или она заблокирована при закрытии дня */
            NEXT.
         ELSE
            /* освобождаем захват */
            FIND CURRENT acct-pos
               NO-LOCK NO-ERROR.
      END.
      LEAVE.
   END.
   RETURN(IF AVAILABLE acct-pos THEN acct-pos.since ELSE ?).
*/

   FOR EACH op-entry
      WHERE (op-entry.acct-db EQ in-acct) OR (op-entry.acct-cr EQ in-acct)
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
FUNCTION IsUserAcct RETURNS LOG (INPUT  ipType  AS CHAR,
                                 INPUT  ipId    AS INTEGER,
                                 INPUT  ipAcctL AS CHAR).

   DEF VAR dAcctLastMove AS DATE  NO-UNDO.

   gcAcct = "".
   gdLastMove = 01/01/1900.
   FOR EACH acct 
      WHERE acct.cust-cat   EQ ipType
        AND acct.cust-id    EQ ipId
        AND acct.currency   EQ ""
        AND CAN-DO(ipAcctL, acct.acct)
      NO-LOCK:

      dAcctLastMove = LookLastMove(acct.acct, acct.currency).

      IF (dAcctLastMove NE ?) AND (dAcctLastMove GT gdLastMove) THEN
         ASSIGN
            gcAcct      = acct.acct
            gdLastMove  = dAcctLastMove
            gdAcctOpen  = acct.open-date
            gdAcctClose = acct.close-date
            .
   END.

   IF (gcAcct EQ "") THEN
      FOR EACH acct 
         WHERE acct.cust-cat   EQ ipType
           AND acct.cust-id    EQ ipId
           AND acct.currency   NE ""
           AND CAN-DO(ipAcctL, acct.acct)
         NO-LOCK:

         dAcctLastMove = LookLastMove(acct.acct, acct.currency).

         IF (dAcctLastMove NE ?) AND (dAcctLastMove GT gdLastMove) THEN
            ASSIGN
               gcAcct      = acct.acct
               gdLastMove  = dAcctLastMove
               gdAcctOpen  = acct.open-date
               gdAcctClose = acct.close-date
               .
      END.
/*
   IF (gcAcct EQ "") THEN
      FOR EACH acct 
         WHERE acct.cust-cat   EQ ipType
           AND acct.cust-id    EQ ipId
         NO-LOCK:

         dAcctLastMove = LookLastMove(acct.acct, acct.currency).

         IF (dAcctLastMove NE ?) AND (dAcctLastMove GT gdLastMove) THEN
            ASSIGN
               gcAcct      = acct.acct
               gdLastMove  = dAcctLastMove
               gdAcctOpen  = acct.open-date
               gdAcctClose = acct.close-date
               .
      END.
*/
   RETURN(gcAcct NE "").

END FUNCTION. /* IsUserAcct */

/* ------------------------------------------------------- */
/* получение даты последнего изменения по карточке клиента */
FUNCTION GetLastHistDate RETURNS DATE
   (INPUT ipName AS CHAR, INPUT ipId AS CHAR, INPUT iSotr AS CHAR).

   FIND LAST history
      WHERE history.file-name EQ ipName
        AND history.field-ref EQ ipId
/*
        AND (history.modif-date GT ipSince OR ipSince EQ ?) */
        AND CAN-DO(iSotr, history.user-id)
      NO-LOCK NO-ERROR.

   RETURN (IF AVAIL history THEN history.modif-date ELSE ?).

END FUNCTION. /* GetLastHistDate  */

/* ------------------------------------------------------- */
/* проверка соотвествия установленному уровню риска */
FUNCTION IsNeedUpDate RETURNS LOG (INPUT  ipType  AS CHAR,
                                   INPUT  ipName  AS CHAR,
                                   INPUT  ipId    AS CHAR,
                                   INPUT  ipRlvl  AS CHAR,
                                   INPUT  ipLDate AS DATE).

   DEF VAR clLevelRisk  LIKE lLevelRisk    NO-UNDO.
   DEF VAR cAcctList    AS CHAR            NO-UNDO.

/* clType = (IF ipName EQ 'cust-corp' THEN 'Ю' ELSE IF ipName EQ 'banks' THEN 'Б' ELSE 'Ч'). */
   CASE ipType:
      WHEN 'Ю' THEN
         cAcctList = "405*,406*,407*,40802*,40807*".
      WHEN 'Б' THEN
         cAcctList = "*".
      OTHERWISE
         cAcctList = "40817*,40820*,423*,426*".
   END CASE.

   gcOGRN      = GetXAttrValueEx(ipName, ipId, "ОГРН","").
   clLevelRisk = GetXAttrValueEx(ipName, ipId, "РискОтмыв",?).

   /* определение принадлежности к выбранной группе риска */
   IF (ipRlvl EQ "Высокий"  AND clLevelRisk BEGINS "П")  OR
      (ipRlvl EQ "Низкий"   AND clLevelRisk EQ "Низкий") OR
      (ipRlvl EQ "Неуказан" AND ((clLevelRisk NE "Низкий" AND NOT clLevelRisk BEGINS "П") OR clLevelRisk EQ ?))
   THEN DO:

      /* проверка наличия счетов */
      IF IsUserAcct(ipType, INTEGER(ipId), cAcctList)
      THEN DO:
         gdAnketaLast = GetLastHistDate(ipName, ipId, gcSotr).
         RETURN (gdAnketaLast LE ipLDate).
      END.

   END. /* IF lLevelRisk */

   RETURN NO.
END FUNCTION. /* IsNeedUpDate */

/* ------------------------------------------------------- */
/*  */
PROCEDURE StrOutXL.
DEFINE INPUT PARAMETER ipClName AS CHAR NO-UNDO.

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

/* Формирование списка сотрудников */
gcSotr = "".
FOR EACH _user:
   IF CAN-DO(ipUpravl, GetXAttrValue("_user", _user._Userid, "group-id"))
      THEN gcSotr = gcSotr + "," + _user._Userid.
END.
gcSotr = SUBSTRING(gcSotr, 2, LENGTH(gcSotr) - 1).

/* ввод параметров поиска */
lLastUpdate = DATE(MONTH(TODAY), DAY(TODAY), YEAR(TODAY) - 1).
PAUSE 0.
DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE WITH FRAME params:
   DISPLAY   lLevelRisk  SKIP
             lLastUpdate SKIP
      WITH FRAME params COLOR BRIGHT-WHITE.

   UPDATE
      lLevelRisk  HELP "Присвоенный клиенту уровень риска"
      lLastUpdate HELP "Дата, до которой анкеты считаются необновленными"
      WITH CENTERED ROW 10 OVERLAY SIDE-LABELS 1 COL
      TITLE "[ ЗАДАЙТЕ ПАРАМЕТРЫ ]"
      EDITING:
         READKEY.

         ON  VALUE-CHANGED, LEAVE OF lLevelRisk  IN FRAME params DO:
            CASE lLevelRisk:SCREEN-VALUE:
               WHEN 'Высокий' THEN 
                  ASSIGN lLastUpdate = DATE (MONTH(TODAY), DAY (TODAY), YEAR(TODAY) - 1 ).
               WHEN 'Низкий' THEN 
                  ASSIGN lLastUpdate = DATE (MONTH(TODAY), DAY (TODAY), YEAR(TODAY) - 3 ).
            END CASE. /* CASE lLevelRisk   */
         END.

         ON "F1" OF lLastUpdate IN FRAME params   DO:
            RUN calend.p.
            IF RETURN-VALUE NE ? AND {assigned pick-value} THEN SELF:SCREEN-VALUE = pick-value.
         END.

         DISPLAY /* lLastUpdate kuntash */ WITH FRAME params.
         APPLY LASTKEY.
      END. /* EDITING*/

END. /* DO ON ERROR UNDO */

HIDE FRAME params NO-PAUSE.

IF KEYFUNC(LASTKEY) = "end-error" THEN
   {ifdef {&return}} {&return} {else} */ return {endif} */.

/* ============ */
{exp-path.i &exp-filename = "'Anketa.xls'"}

PUT UNFORMATTED XLHead(STRING(lLastUpdate, "99.99.9999"), "CDDDDCC", "").

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
   WHEN 'Ю' THEN DO:
      FOR EACH cust-corp 
/*         WHERE (cust-corp.last-date LT lLastUpdate) */
         NO-LOCK
/*         BY cust-corp.name-short */ :

         IF IsNeedUpDate(ipTypeCli, "cust-corp", STRING(cust-corp.cust-id), lLevelRisk, lLastUpdate)
         THEN DO:
            iCount = iCount + 1.
            RUN StrOutXL(cust-corp.cust-stat + " " + cust-corp.name-corp).
         END. /* IF IsNeedUpDate("cust-corp"  */
      END. /* FOR EACH cust-corp */
   END. /* WHEN 'Ю'*/

   WHEN 'Б' THEN DO:
      FOR EACH banks WHERE banks.last-date LT lLastUpdate NO-LOCK BY banks.name:

         IF IsNeedUpDate(ipTypeCli, "banks", STRING(banks.bank-id), lLevelRisk, lLastUpdate)
         THEN DO:
            iCount = iCount + 1.
            RUN StrOutXL(banks.name).
         END. /* IF IsNeedUpDate("banks" */
      END. /* FOR EACH cust-corp */
   END. /* WHEN 'Б'*/

   WHEN 'Ч' THEN DO:
      FOR EACH person WHERE person.last-date LT lLastUpdate NO-LOCK BY person.name-last:

         IF IsNeedUpDate(ipTypeCli, "person", STRING(person.person-id), lLevelRisk, lLastUpdate)
         THEN DO:
            iCount = iCount + 1.
            RUN StrOutXL(person.name-last + " " + person.first-names).
         END. /*  IF IsNeedUpDate("person",   */
      END. /* FOR EACH cust-corp */
   END. /* WHEN 'Ч'*/

END. /*CASE*/

PUT UNFORMATTED XLEnd().

{intrface.del}
