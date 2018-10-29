{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
*/

{globals.i}           /** Глобальные определения */
{tmprecid.def}        /** Используем информацию из броузера */
{intrface.get xclass} /** Функции для работы с метасхемой */
{intrface.get strng}  /** Функции для работы со строками */

{sh-defs.i}

/******************************************* Определение переменных и др. */
DEF VAR cSurr AS CHAR     NO-UNDO.
DEF VAR cDR1  AS CHAR     NO-UNDO.
DEF VAR cDR2  AS CHAR     NO-UNDO.
DEF VAR cBeg  AS CHAR     NO-UNDO.
DEF VAR cEnd  AS CHAR     NO-UNDO.
DEF VAR cSrok AS CHAR     NO-UNDO.
DEF VAR cKod  AS CHAR     NO-UNDO.

/******************************************* Реализация */
FOR FIRST tmprecid
   NO-LOCK,
   FIRST op
      WHERE (RECID(op) EQ tmprecid.id)
      NO-LOCK:

   cSurr = STRING(op.op).
   cDR1  = GetXAttrValue("op", cSurr, "ПодозДокумент").
   cDR2  = GetXAttrValue("op", cSurr, "КодОпОтмыв").
   cBeg  = GetXAttrValue("op", cSurr, "PIRKbegDate").
   cEnd  = GetXAttrValue("op", cSurr, "PIRKendDate").
   cSrok = GetXAttrValue("op", cSurr, "PIRKsrok").

   /* ===== Сообщение уже отправлено */
   IF (cDR2 NE "")
   THEN DO:
      MESSAGE 
         "Сообщение по документу N " + op.doc-num + " от " + STRING(op.op-date) SKIP
         "уже было отправлено с кодом " + cDR2
         VIEW-AS ALERT-BOX MESSAGE BUTTONS OK.
      RETURN.
   END.

   /* ===== Документ уже стоял на контроле */
   IF (cEnd NE "")
   THEN DO:
      MESSAGE 
         "Документ N " + op.doc-num + " от " + STRING(op.op-date) SKIP
         "уже стоял на контроле с " + cBeg + " по " + cEnd
         VIEW-AS ALERT-BOX MESSAGE BUTTONS OK.
      RETURN.
   END.

   IF (cBeg NE "")
   /* ===== Снимаем с контроля */
   THEN DO:
      RUN g-prompt.p("CHARACTER", "Код отправки в ФМ или пусто", "x(10)", cDR1,
                     "Снимаем с контроля документ N " + op.doc-num + " от " + STRING(op.op-date), 57, ",", "", ?, ?, OUTPUT cKod).
      IF (cKod EQ ?)
      THEN RETURN.

      UpdateSigns("op", cSurr, "PIRKendDate", STRING(TODAY, "99/99/9999"), NO).

      IF (cKod EQ "")
      THEN UpdateSigns("op", cSurr, "ПодозДокумент", "", YES).
      ELSE UpdateSigns("op", cSurr, "КодОпОтмыв", cKod, YES).
   END.
   /* ===== Ставим на контроль */
   ELSE DO:
      RUN g-prompt.p("DATE", "Срок контроля или пусто", "99/99/9999", STRING(TODAY),
                     "Ставим на контроль документ N " + op.doc-num + " от " + STRING(op.op-date, "99/99/9999"), 57, ",", "", ?, ?, OUTPUT cKod).
      IF (cKod EQ ?)
      THEN RETURN.
      ELSE UpdateSigns("op", cSurr, "PIRKsrok", STRING(DATE(cKod), "99/99/9999"), NO).

      IF (cDR1 EQ "")
      THEN UpdateSigns("op", cSurr, "ПодозДокумент", "6001", YES).

      UpdateSigns("op", cSurr, "PIRKbegDate", STRING(TODAY, "99/99/9999"), NO).
      UpdateSigns("op", cSurr, "PIRKontrol", "-", NO).
   END.

END.
{intrface.del}
