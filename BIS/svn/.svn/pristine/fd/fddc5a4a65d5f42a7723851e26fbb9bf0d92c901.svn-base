{pirsavelog.p}
/** 
                ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
*/

/** Глобальные определения */
{globals.i}
/** Используем информацию из броузера */
{tmprecid.def}
/** Функции для работы с метасхемой */
{intrface.get xclass}
/** Функции для работы со строками */
{intrface.get strng}
{intrface.get rsrv}
{intrface.get i254}

{sh-defs.i}

/******************************************* Определение переменных и др. */
DEFINE VARIABLE cTmpStr  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTranz   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDb      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCr      AS CHARACTER NO-UNDO.

cTranz = FGetSetting("PirPODFTDoc","",?).
cDb    = FGetSetting("PirPODFTDb","",?).
cCr    = FGetSetting("PirPODFTCr","",?).
{pir_exf_exl.i}

{exp-path.i &exp-filename = "'UpOp.xls'"}
{getdates.i}
/******************************************* Реализация */
PUT UNFORMATTED XLHead("200902", "CCCCCCNCDDC", "").

cTmpStr = XLCell("Status")
        + XLCell("Kod doc")
        + XLCell("Num")
        + XLCell("Tranzak")
        + XLCell("Debet")
        + XLCell("Kredit")
        + XLCell("Summa")
        + XLCell("Soder")
        + XLCell("Data doc")
        + XLCell("Data red")
        + XLCell("Time red")
.

PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd() .

FOR EACH op
   WHERE (op.op-date GE beg-date) AND (op.op-date LE end-date)
   NO-LOCK:

   put screen col 1 row 24 "Обрабатывается " + STRING(op.op-date).

   FIND FIRST op-entry OF op
      NO-LOCK NO-ERROR.

   IF (AVAIL op-entry)
   THEN DO:
      IF (GetXAttrValue("op", STRING(op.op), "PIRcheckPODFT") EQ "") AND
         (GetXAttrValue("op", STRING(op.op), "ПодозДокумент") EQ "") AND
         (NOT CAN-DO(cDb,op-entry.acct-db) OR
          NOT CAN-DO(cCr,op-entry.acct-cr)) AND
          NOT CAN-DO(cTranz, op.op-kind)
      THEN DO:

         FIND LAST history WHERE history.file-name EQ "op"
                             AND history.field-ref EQ STRING(op.op)
            NO-LOCK NO-ERROR.

         IF (AVAIL history) AND
            (((history.modif-date - op.op-date) GT 1) OR
            (((history.modif-date - op.op-date) EQ 1) AND
              (history.modif-time GT 39600)))
         THEN DO:
            cTmpStr = XLCell(op.op-status)
                    + XLCell(op.doc-type)
                    + XLCell(op.doc-num)
                    + XLCell(op.op-kind)
                    + XLCell(op-entry.acct-db)
                    + XLCell(op-entry.acct-cr)
                    + XLNumCell(op-entry.amt-rub)
                    + XLCell(op.details)
                    + XLDateCell(op.op-date)
                    + XLDateCell(history.modif-date)
                    + XLCell(STRING(history.modif-time, "HH:MM"))
            .
            PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd().
         END.
      END.
   END.
END.

PUT UNFORMATTED XLEnd().
put screen col 1 row 24 color normal STRING(" ","X(80)").

{intrface.del}
