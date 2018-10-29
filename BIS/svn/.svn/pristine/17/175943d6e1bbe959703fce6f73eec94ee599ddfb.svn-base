{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
                Формирование списка операций кредитных договоров для ф.808 справочно.
                Борисов А.В., 28.08.2009
*/

{globals.i}           /** Глобальные определения */
{pick-val.i}
{chkacces.i}
{intrface.get xclass} /** Функции для работы с метасхемой */
{intrface.get strng}  /** Функции для работы со строками */
{intrface.get date}   /** Функции для работы с датами */
{intrface.get instrum}

{sh-defs.i}
{ulib.i}

{pir_exf_exl.i}
{getdates.i}
DEFINE VARIABLE oClient AS TClient.

{exp-path.i &exp-filename = "'Vyp' + STRING(TIME) + '.xls' "}
/******************************************* Определение переменных и др. */
DEF VAR cXL       AS CHAR     NO-UNDO.
DEF VAR cKl       AS CHAR     NO-UNDO.
DEF VAR cINN      AS CHAR     NO-UNDO.

/******************************************* Реализация */
{tmprecid.def}          /* Таблица отметок. */

PUT UNFORMATTED XLHead("Klient", "DCCCCCCCNNNC", "71,83,70,150,200,200,110,150,110,110,110,200").

FOR EACH tmprecid NO-LOCK,
   FIRST acct
      WHERE recid(acct) = tmprecid.id
      NO-LOCK:

   RUN acct-pos IN h_base(acct.acct, acct.currency, beg-date, beg-date, cXL).
   oClient = new TClient(acct.acct).

   cXL = XLRow(0)
       + XLCell("Выписка по счету " + acct.acct + "  " + acct.details + " за период с "
                + STRING(beg-date, "99.99.9999") + " по " + STRING(end-date, "99.99.9999"))
       + XLRowEnd() + XLRow(0)
       + XLCell(oClient:name-short
                + " (ИНН: " + oClient:getInnByDate(end-date) + " )")
       + XLEmptyCells(6)
       + XLCell("Входящий остаток на счете:") + XLEmptyCell()
       + XLNumCell(ABS(sh-in-bal))
       + XLRowEnd()
       .
   DELETE OBJECT oClient.

   PUT UNFORMATTED XLRow(2) XLRowEnd() cXL.

   cXL = XLCell("Дата")
       + XLCell("N документа")
       + XLCell("Код банка")
       + XLCell("Корр.счет")
       + XLCell("Название банка")
       + XLCell("Название контрагента")
       + XLCell("ИНН контрагента")
       + XLCell("Счет контрагента")
       + XLCell("ДБ")
       + XLCell("КР")
       + XLCell("Сумма в валюте")
       + XLCell("Содержание операции")
       .
   PUT UNFORMATTED XLRow(2) cXL XLRowEnd() .

   FOR EACH op
      WHERE (op.op-date >= beg-date)
        AND (op.op-date <= end-date)
        AND NOT (op.doc-num BEGINS "П")
      NO-LOCK,
      EACH op-entry OF op
         WHERE (op-entry.acct-db EQ acct.acct)
            OR (op-entry.acct-cr EQ acct.acct)
      NO-LOCK
      BREAK BY op-entry.op-date:

      cXL = XLDateCell(op-entry.op-date)
          + XLCell(op.doc-num).

      FIND FIRST op-bank
         WHERE (op-bank.op EQ op.op)
           AND (op-bank.op-bank-type   EQ "")
           AND (op-bank.bank-code-type EQ "МФО-9")
         NO-LOCK NO-ERROR.

      IF AVAILABLE(op-bank)
      THEN DO:
         FIND FIRST banks-code OF op-bank
            NO-ERROR.
         FIND FIRST banks OF banks-code
            NO-ERROR.
         cXL = cXL 
             + XLCell(op-bank.bank-code)
             + XLCell(op-bank.corr-acct)
             + XLCell(banks.name)
             + XLCell(op.name-ben)
             + XLCell(op.inn)
             + XLCell(op.ben-acct).
      END.
      ELSE DO:
         cXL = cXL + XLEmptyCells(3).

         IF (op-entry.acct-db EQ acct.acct)
         THEN DO:
            cKl = GetAcctClientName_UAL(op-entry.acct-cr, false).
            IF (cKl NE "")
            THEN DO:
               cINN = GetXAttrValue("op", STRING(op.op), "inn-rec").
               IF (cINN = "")
               THEN cINN = GetClientInfo_ULL(GetAcctClientID_ULL(op-entry.acct-cr, FALSE), "inn", FALSE).
            END.
            ELSE cINN = "".
            cXL = cXL
                + XLCell(cKl)
                + XLCell(cINN)
                + XLCell(op-entry.acct-cr).
         END.
         ELSE DO:
            cKl = GetAcctClientName_UAL(op-entry.acct-db, false).
            IF (cKl NE "")
            THEN DO:
               cINN = GetXAttrValue("op", STRING(op.op), "inn-send").
               IF (cINN = "")
               THEN cINN = GetClientInfo_ULL(GetAcctClientID_ULL(op-entry.acct-db, FALSE), "inn", FALSE).
            END.
            ELSE cINN = "".
            cXL = cXL
                + XLCell(cKl)
                + XLCell(cINN)
                + XLCell(op-entry.acct-db).
         END.
      END.

      IF (op-entry.acct-db EQ acct.acct)
      THEN cXL = cXL + XLNumCell(op-entry.amt-rub) + XLEmptyCell().
      ELSE cXL = cXL + XLEmptyCell() + XLNumCell(op-entry.amt-rub).

      IF (acct.currency NE "")
      THEN cXL = cXL + XLNumCell(op-entry.amt-cur).
      ELSE cXL = cXL + XLEmptyCell().

      cXL = cXL + XLCell(op.details).

      IF FIRST-OF(op-entry.op-date)
      THEN PUT UNFORMATTED XLRow(1) cXL XLRowEnd().
      ELSE PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
   END.

   RUN acct-pos IN h_base(acct.acct, acct.currency, beg-date, end-date, cXL).
   cXL = XLRow(2)
       + XLCell("Итого :") + XLEmptyCells(6)
       + XLCell("Обороты :")
       + XLNumCell(sh-db)
       + XLNumCell(sh-cr)
       + XLRowEnd() + XLRow(0) + XLEmptyCells(7)
       + XLCell("Остаток на счете :") + XLEmptyCell()
       + XLNumCell(ABS(sh-bal))
       + XLRowEnd()
       .
   PUT UNFORMATTED cXL.
END.

PUT UNFORMATTED XLEnd().
MESSAGE "ГОТОВО!" VIEW-AS ALERT-BOX.
{intrface.del}
