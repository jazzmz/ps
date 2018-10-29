{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
                Формирование списка операций кредитных договоров для ф.808 справочно.
                Борисов А.В., 28.08.2009
*/

{globals.i}           /** Глобальные определения */
{intrface.get xclass} /** Функции для работы с метасхемой */
{intrface.get strng}  /** Функции для работы со строками */
{intrface.get date}   /** Функции для работы с датами */
{intrface.get instrum}
{intrface.get loan}
{intrface.get i254}
{intrface.get db2l}
{intrface.get rsrv}
{ulib.i}              /** Библиотека функций для работы со счетами */

{sh-defs.i}

{pir_exf_exl.i}
{getdates.i}
{exp-path.i &exp-filename = "'kred_706.xls'"}

/******************************************* Определение переменных и др. */
DEF INPUT PARAM inParam    AS CHARACTER.
DEF VAR cXL       AS CHAR     NO-UNDO.
DEF VAR iNumOE    AS INTEGER  NO-UNDO.
DEF VAR cDbBal    AS CHAR     NO-UNDO.
DEF VAR cCrBal    AS CHAR     NO-UNDO.
DEF VAR cDbKAU    AS CHAR     NO-UNDO.
DEF VAR cCrKAU    AS CHAR     NO-UNDO.
DEF VAR cDR       AS CHAR     NO-UNDO.
DEF VAR cSYM5     AS CHAR     NO-UNDO.
DEF VAR cSYM2     AS CHAR     NO-UNDO.
DEF VAR cOp       AS CHAR     NO-UNDO.
DEF VAR cErr      AS CHAR     NO-UNDO.
DEF VAR cNew      AS CHAR     NO-UNDO.
DEF VAR cDog      AS CHAR     NO-UNDO.
DEF VAR cDogT     AS CHAR     NO-UNDO.
DEF VAR cSurr     AS CHAR     NO-UNDO.

/******************************************* Реализация */
PUT UNFORMATTED XLHead("op", "DCCCCCNCCCCCC", "71,50,150,150,150,150,110,150,150,150,50,50").

cXL = XLCell("Дата")
    + XLCell("N документа")
    + XLCell("Дебет счета")
    + XLCell("КАУ по дебету")
    + XLCell("Кредит счета")
    + XLCell("КАУ по кредиту")
    + XLCell("Сумма")
    + XLCell("Содержание")
    + XLCell("ДР ПричИзмРезерва")
    + XLCell("ДР New")
    + XLCell("Ошибки")
    + XLCell("Операция")
    + XLCell("Тип договора")
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

iNumOE = 0.

/* ======= Цикл по Op =======  */
FOR EACH op
   WHERE (op.op-date GE beg-date)
     AND (op.op-date LE end-date),
   EACH op-entry OF op
   BREAK BY op.op-date BY op.doc-num.

   IF FIRST-OF(op.op-date)
   THEN put screen col 1 row 24 "Обрабатывается " + STRING(op.op-date).

   cDbBal = SUBSTRING(op-entry.acct-db, 1, 5).
   cCrBal = SUBSTRING(op-entry.acct-cr, 1, 5).
   cDbKAU = op-entry.kau-db.
   cCrKAU = op-entry.kau-cr.
   cSurr  = STRING(op-entry.op) + "," + STRING(op-entry.op-entry).
   cDR    = GetXAttrValue("op-entry", cSurr, "ПричИзмРезерва").

   IF    (NOT op-entry.acct-db MATCHES "70601810.000016305..")
     AND (NOT op-entry.acct-db MATCHES "70606810.000025302..")
     AND (NOT op-entry.acct-cr MATCHES "70601810.000016305..")
     AND (NOT op-entry.acct-cr MATCHES "70606810.000025302..")
   THEN DO:
      IF (cDR NE "")
      THEN cErr = "*4 - лишний ДР".
      ELSE NEXT.
   END.
   ELSE DO:

      cErr   = "".
      cOp    = "".
      cDogT  = "".
      cNew   = "".

      IF  (cDbBal EQ "70601") OR  (cCrBal EQ "70606") OR
         ((cDbBal EQ "70606") AND (cCrBal EQ "70601"))
      THEN cErr = "0 - Счета не на месте".
      ELSE DO:

         IF (cDbBal EQ "70606")
         THEN DO:
            cSYM2 = SUBSTRING(op-entry.acct-db, 19, 2).

            IF (NUM-ENTRIES(cCrKAU) EQ 3)
            THEN
               ASSIGN
                  cOp   = ENTRY(3, cCrKAU)
                  cDog  = ENTRY(2, cCrKAU)
                  cDogT = ENTRY(1, cCrKAU)
               .
            ELSE
               ASSIGN
                  cOp   = ""
                  cDog  = ""
                  cDogT = ""
               .

            IF    (NOT CAN-DO("32,136,470,473,429", cOp) AND (cDR EQ "") AND (cSYM2 NE "19"))
               OR (    CAN-DO("32,136,470,473,429", cOp) AND (cDR EQ "")
               AND NOT CAN-DO("01,02,03,04,05,10,11,12,13,14,15,16,17,18,19", cSYM2))
            THEN NEXT.

            IF   ((CAN-DO("01,02,03,04,05", cSYM2) AND CAN-DO("32,136",  cOp))
               OR (CAN-DO("13,14,15,16",    cSYM2) AND CAN-DO("470,473", cOp))
               OR (CAN-DO("17,18",          cSYM2) AND CAN-DO("429",     cOp))
               OR ("19" EQ cSYM2))
            THEN DO:
               IF (cDR EQ "") OR (cDR EQ ?)
               THEN DO:
                  cErr = "*1 - Отсутствует ДР".
                  cNew = "1_4=" + STRING(op-entry.amt-rub).
               END.
            END.
            ELSE DO:
               IF (cDR NE "")
               THEN DO:
                  cErr = "*2 - лишний ДР".
                  cNew = "".
               END.
            END.

            IF (CAN-DO("470,473,429", cOp) AND NOT (cDR BEGINS "1_4") AND (cErr EQ ""))
            THEN DO:
               cErr = "*3 - в ДР д.б. 1_4".
               cNew = "1_4" + SUBSTRING(cDR, 4, LENGTH(cDR) - 3).
            END.
         END.
         ELSE DO:
            cSYM2 = SUBSTRING(op-entry.acct-cr, 19, 2).

            IF (NUM-ENTRIES(cDbKAU) EQ 3)
            THEN
               ASSIGN
                  cOp   = ENTRY(3, cDbKAU)
                  cDog  = ENTRY(2, cDbKAU)
                  cDogT = ENTRY(1, cDbKAU)
               .
            ELSE
               ASSIGN
                  cOp   = ""
                  cDog  = ""
                  cDogT = ""
               .

            IF    (NOT CAN-DO("33,137,471,474,430", cOp) AND (cDR EQ "") AND (cSYM2 NE "19"))
               OR (    CAN-DO("33,137,471,474,430", cOp) AND (cDR EQ "")
               AND NOT CAN-DO("01,02,03,04,05,10,11,12,13,14,15,16,17,18,19", cSYM2))
            THEN NEXT.

            IF   ((CAN-DO("01,02,03,04,05", cSYM2) AND CAN-DO("33,137",  cOp))
               OR (CAN-DO("13,14,15,16",    cSYM2) AND CAN-DO("471,474", cOp))
               OR (CAN-DO("17,18",          cSYM2) AND CAN-DO("430",     cOp))
               OR ("19" EQ cSYM2))
            THEN DO:
               IF (cDR EQ "") OR (cDR EQ ?)
               THEN DO:
                  cErr = "*1 - Отсутствует ДР".
                  cNew = "2_5=" + STRING(op-entry.amt-rub).
               END.
            END.
            ELSE DO:
               IF (cDR NE "")
               THEN DO:
                  cErr = "*2 - лишний ДР".
                  cNew = "".
               END.
            END.

            IF (CAN-DO("471,474,430", cOp) AND NOT (cDR BEGINS "2_5") AND (cErr EQ ""))
            THEN DO:
               cErr = "*3 - в ДР д.б. 2_5".
               cNew = "2_5" + SUBSTRING(cDR, 4, LENGTH(cDR) - 3).
            END.
         END.

         IF (cOp NE "")
         THEN DO:
            FOR EACH loan
               WHERE (loan.contract  EQ cDogT)
                 AND (loan.cont-code EQ cDog)
               NO-LOCK:

               cDogT = loan.cont-type.
               LEAVE.
            END.
         END.

      END.
   END.

   IF     (cErr    NE "")
      AND (inParam EQ "DR")
   THEN
      UpdateSigns("op-entry", cSurr, "ПричИзмРезерва", cNew, NO).

   IF (cDR NE "") AND CAN-DO("32,33,136,137", cOp) THEN iNumOE = iNumOE + 1.

   cXL = XLDateCell(op.op-date)
       + XLCell(op.doc-num)
       + XLCell(op-entry.acct-db)
       + XLCell(cDbKAU)
       + XLCell(op-entry.acct-cr)
       + XLCell(cCrKAU)
       + XLNumCell(op-entry.amt-rub)
       + XLCell(op.details)
       + XLCell(cDR)
       + XLCell(cNew)
       + XLCell(cErr)
       + XLCell(cOp)
       + XLCell(cDogT)
       .
   PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
END.

PUT UNFORMATTED XLRow(2) XLCell("Всего " + STRING(iNumOE) + " проводок с ДР.") XLRowEnd().
PUT UNFORMATTED XLEnd().

put screen col 1 row 24 color normal STRING(" ","X(80)").
{intrface.del}
