{pirsavelog.p}
/**             ООО КБ "ПРОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
Устанавливаем ДР СПОДПрибУбыт на проводках СПОД, для ф.102
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
DEF BUFFER aop-entry FOR op-entry.
DEFINE VARIABLE cSpod    AS CHARACTER          NO-UNDO.
DEFINE VARIABLE cSpodKod AS CHARACTER          NO-UNDO.
DEFINE VARIABLE cAccDb   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE cAccCr   AS CHARACTER          NO-UNDO.

/*{getdates.i}*/
/*Мы знаем что СПОД проводки будут с 01.01 и до текущей даты текущего года */
beg-date = DATE(1,1,YEAR(Today)).
end-date = DATE(3,31,YEAR(Today)).
/*Годовой отчет со СПОДами по ф.102 должен быть сформирован до 01.04 тегущего года.
поэтому если формируем после 01.04, то простановку СПОД не проверяем.
*/
if Today > end-date then return.
/******************************************* Реализация */

FOR EACH aop-entry
   WHERE (aop-entry.op-date GE beg-date)
     AND (aop-entry.op-date LE end-date)
   NO-LOCK:

   cSpod    = GetXAttrValue ("op-entry", STRING(aop-entry.op) + "," + STRING(aop-entry.op-entry), "СПОД").
   cSpodKod = GetXAttrValue ("op-entry", STRING(aop-entry.op) + "," + STRING(aop-entry.op-entry), "СПОДПрибУбыт").
   cAccDb   = SUBSTRING(aop-entry.acct-db, 1, 1).
   cAccCr   = SUBSTRING(aop-entry.acct-cr, 1, 1).

   IF         {assigned cSpod}
      AND NOT {assigned cSpodKod}
      AND ((cAccDb EQ "7")
        OR (cAccCr EQ "7"))
   THEN DO:

      IF (cAccDb EQ "7")
      THEN cSpodKod = SUBSTRING(aop-entry.acct-db,14,5).
      ELSE cSpodKod = SUBSTRING(aop-entry.acct-cr,14,5).

      CASE SUBSTRING(cSpodKod,2,1):
         WHEN "1" OR WHEN "2" THEN cSpodKod = cSpodKod + "_А".
         WHEN "3" OR WHEN "4" THEN cSpodKod = cSpodKod + "_Б".
         WHEN "5" OR WHEN "6" THEN cSpodKod = cSpodKod + "_Б".
         WHEN "7"             THEN cSpodKod = cSpodKod + "_В".
         OTHERWISE                 cSpodKod = "".
      END CASE.

      FIND FIRST op-entry
         WHERE (op-entry.op       EQ aop-entry.op)
           AND (op-entry.op-entry EQ aop-entry.op-entry)
         EXCLUSIVE-LOCK NO-ERROR.
      IF AVAIL op-entry
      THEN
         UpdateSigns("op-entry", STRING(op-entry.op) + "," + STRING(op-entry.op-entry), "СПОДПрибУбыт", cSpodKod, YES).
   END.
END.

{intrface.del}
