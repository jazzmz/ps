/*нужна для отчетности не удалять */
/* {pirsavelog.p} */
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2009
*/

{globals.i}           /** Глобальные определения */
{intrface.get xclass} /** Функции для работы с метасхемой */
{intrface.get strng}  /** Функции для работы со строками */

{sh-defs.i}

/******************************************* Определение переменных и др. */
DEFINE VARIABLE cDR  AS CHAR     NO-UNDO.
DEFINE BUFFER   oe1  FOR op-entry.

{pir_exf_exl.i}
{getdates.i}

/******************************************* Реализация */
FOR EACH oe1
   WHERE (oe1.op-date GE beg-date)
     AND (oe1.op-date LE end-date)
     AND (CAN-DO("Кредит*47.", oe1.kau-db)
      OR  CAN-DO("Кредит*47.", oe1.kau-cr))
   NO-LOCK:

   cDR = GetXAttrValue("op-entry", STRING(oe1.op) + "," + STRING(oe1.op-entry), "ПричИзмРезерва").
   IF SUBSTRING(cDR, 1, 1) = "1" THEN SUBSTRING(cDR, 3, 1) = "4".
   IF SUBSTRING(cDR, 1, 1) = "2" THEN SUBSTRING(cDR, 3, 1) = "5".

   IF NOT UpdateSigns("op-entry", STRING(oe1.op) + "," + STRING(oe1.op-entry), "ПричИзмРезерва", cDR, NO)
   THEN DO:
      FIND FIRST op WHERE op.op EQ oe1.op
         NO-ERROR.
      MESSAGE "??? " + STRING(oe1.op-date) + " " + op.doc-num + " " + cDR
         VIEW-AS ALERT-BOX.
   END.
END.

{intrface.del}
