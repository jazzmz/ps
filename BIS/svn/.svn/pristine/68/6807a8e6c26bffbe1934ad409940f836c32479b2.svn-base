/* {pirsavelog.p} */
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
*/

/** Глобальные определения */
{globals.i}
/** Используем информацию из броузера */
{tmprecid.def}
/** Функции для работы с метасхемой */
{intrface.get xclass}
/** Функции для работы со строками */
{intrface.get strng}

{sh-defs.i}

/******************************************* Определение переменных и др. */
DEF INPUT PARAM inParam    AS CHAR.
DEF VAR cInList   AS CHAR             NO-UNDO.
DEF VAR cOutList  AS CHAR             NO-UNDO.

DEF VAR cClassL   AS CHAR             NO-UNDO.
DEF VAR cTmpStr   AS CHAR             NO-UNDO.
DEF VAR cFSurr    AS CHAR             NO-UNDO.
DEF VAR cFHSurr   AS CHAR             NO-UNDO.
DEF VAR cf1       AS CHAR             NO-UNDO.
DEF VAR cf2       AS CHAR             NO-UNDO.
DEF VAR cS        AS CHAR             NO-UNDO.
DEF VAR I         AS INTEGER          NO-UNDO.
/*
DEF VAR N         AS INTEGER          NO-UNDO.
*/
DEF BUFFER tform  FOR formula.
DEF BUFFER thist  FOR history.
DEF BUFFER tmetd  FOR dclass-method.

{pir_exf_exl.i}

/******************************************* Реализация */
FUNCTION fClassList RETURNS CHARACTER
   (INPUT cPrnt AS CHARACTER,
    INPUT cOutL AS CHARACTER).

   DEFINE VARIABLE cList AS CHARACTER  NO-UNDO.
   DEFINE BUFFER tDClass FOR DataClass.

   FIND FIRST tDClass
      WHERE (tDClass.DataClass-Id EQ cPrnt)
      NO-ERROR.
   IF NOT tDClass.IsFolder THEN RETURN (cPrnt + ",").

   cList = "".

   FOR EACH DataClass
      WHERE (DataClass.Parent-Id EQ cPrnt)
        AND NOT CAN-DO(cOutL, DataClass.DataClass-Id)
      NO-LOCK:

      IF DataClass.IsFolder THEN cList = cList + fClassList(DataClass.DataClass-Id, cOutL).
                            ELSE cList = cList + DataClass.DataClass-Id + ",".
   END.

   RETURN cList.

END FUNCTION. /* fClassList */

/******************************************* Реализация */
cTmpStr = STRING(YEAR(TODAY)) + STRING(MONTH(TODAY), "99") + STRING(DAY(TODAY), "99").
cTmpStr = "formula-" + cTmpStr + ".xls".
{exp-path.i &exp-filename = cTmpStr}

PUT UNFORMATTED XLHead("formula", "CCCCIDDCCCDCD", "100,140,70,70,50,75,75,70,70,75,75,75,75").

cTmpStr = XLCell("DataClass-Id")
        + XLCell("var-id")
        + XLCell("Class+id")
        + XLCell("var-name")
        + XLCell("order")
        + XLCell("since")
        + XLCell("since_OLD")
        + XLCell("formula")
        + XLCell("formula_OLD")
        + XLCell("Создал")
        + XLCell("Дата создания")
        + XLCell("Правил")
        + XLCell("Дата правки")
.
PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd() .

/* ---------------------------------------------------- */
cInList  = ENTRY(1, inParam, "|").
cOutList = ENTRY(2, inParam, "|").

cClassL = "".

DO I = 1 TO NUM-ENTRIES(cInList):
   cClassL = cClassL + fClassList(ENTRY(I, cInList), cOutList).
END.

cClassL = SUBSTRING(cClassL, 1, LENGTH(cClassL) - 1).

/* ---------------------------------------------------- */
FOR EACH formula
   WHERE CAN-DO(cClassL, formula.DataClass-Id)
   NO-LOCK:

   cFSurr  = formula.DataClass-Id + "," + formula.var-id.
   cFHSurr = cFSurr + "," + STRING(formula.since).

   FOR EACH tform
      WHERE tform.DataClass-Id EQ formula.DataClass-Id
        AND tform.var-id EQ formula.var-id
      BY tform.since DESCENDING
   :
      LEAVE.
   END.

   FIND LAST thist
      WHERE thist.file-name EQ "formula"
        AND thist.field-ref EQ cFHSurr
      NO-ERROR.

   IF     (tform.since EQ formula.since)
      AND (GetXAttrValue("formula", cFSurr, "close-date") EQ "")
      AND ((NOT AVAIL thist) OR (thist.modify NE "D"))
   THEN DO:

      cf1 = IF (GetXAttrValue("formula", cFSurr, "Не_перегруж") EQ "Да") THEN "(-)" ELSE "".

      /* Преобразование формулы - доб.перевод строки */
      cf2 = REPLACE(formula.formula, "~~", "~~&#10;").
      IF (LENGTH(cf2) GE 1)
      THEN DO:
         IF (SUBSTRING(formula.formula, LENGTH(formula.formula), 1) EQ "~~")
         THEN
            SUBSTRING(cf2, LENGTH(cf2) - 4, 5) = "".
      END.

      cTmpStr = XLCell(formula.DataClass-Id)
              + XLCell(formula.var-id)
              + XLCell(REPLACE(REPLACE(formula.DataClass-Id + " / " + formula.var-id + " /", "*", "!"), ".", "`"))
              + XLCell(formula.var-name)
              + XLNumCell(formula.order)
              + XLDateCell(formula.since)
              + XLEmptyCell()
              + XLCell(cf2)
              + XLCell(" ")
      .

      /* Поиск даты создания */
      FIND LAST history WHERE history.file-name EQ "formula"
                          AND history.field-ref EQ cFHSurr
                          AND history.modify    EQ "C"
         NO-ERROR .

      IF AVAIL history THEN
         cTmpStr = cTmpStr
                 + XLCell(cf1 + history.user-id)
                 + XLDateCell(history.modif-date)
         .
      ELSE
         cTmpStr = cTmpStr + XLCell(cf1 + " ") + XLEmptyCell().

      /* Поиск последней правки */
      FIND LAST history WHERE history.file-name EQ "formula"
                          AND history.field-ref EQ cFHSurr
                          AND history.modify    EQ "W"
         NO-ERROR .

      IF AVAIL history THEN
         cTmpStr = cTmpStr
                 + XLCell(history.user-id)
                 + XLDateCell(history.modif-date)
         .
      ELSE
         cTmpStr = cTmpStr + XLEmptyCell() + XLEmptyCell().

/* 
   FIND LAST history WHERE history.file-name EQ "formula"
                       AND history.field-ref EQ cFSurr
                       AND history.modify    EQ "D"
      NO-ERROR .

   IF AVAIL history THEN
      cTmpStr = cTmpStr
              + XLCell(history.user-id)
              + XLDateCell(history.modif-date)
      .
   ELSE
      cTmpStr = cTmpStr + XLEmptyCell() + XLEmptyCell().
*/
      PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd() .
   END.

END.

/* ---------------------------------------------------- */
FOR EACH dclass-method
   WHERE CAN-DO(cClassL, dclass-method.DataClass-Id)
   NO-LOCK
   BY dclass-method.DataClass-Id
   BY dclass-method.Method-Id:

   FOR EACH tmetd
      WHERE tmetd.DataClass-Id EQ dclass-method.DataClass-Id
        AND tmetd.Method-Id    EQ dclass-method.Method-Id
        AND tmetd.Method-Code  EQ dclass-method.Method-Code
      BY tmetd.since DESCENDING
   :
      LEAVE.
   END.

   IF (tmetd.since EQ dclass-method.since)
   THEN DO:

      cTmpStr = XLCell(dclass-method.DataClass-Id)
              + XLCell(dclass-method.Method-Id + " / " + dclass-method.Method-Code)
              + XLCell(dclass-method.DataClass-Id + " / " + dclass-method.Method-Id + " / " + dclass-method.Method-Code)
              + XLCell("Метод")
              + XLEmptyCell()
              + XLDateCell(dclass-method.since)
              + XLEmptyCell()
              + XLCell(dclass-method.procedure + " ( " + dclass-method.Params + " )")
              + XLCell(" ")
      .

      PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd().

   END.
END.

PUT UNFORMATTED XLEnd().
{intrface.del}
