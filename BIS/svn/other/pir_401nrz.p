{pirsavelog.p}
/** 
   ОТЧЕТ
   Вспомогательный отчет для Ф401.
   по клиентам физ.лицам, что сменили гражданство за период.
   Формирование spiska VP.
   Борисов А.В.
   30.12.2009
*/

{globals.i}           /* Глобальные определения */

/******************************************* Определение переменных и др. */

DEFINE VARIABLE I    AS INTEGER    NO-UNDO.
DEFINE VARIABLE cNm  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTmp AS CHARACTER  NO-UNDO.

/******************************************* Реализация */
{getdates.i}
{setdest.i}

PUT UNFORMATTED "Сменили гражданство с " STRING(beg-date, "99.99.9999") " по " STRING(end-date, "99.99.9999") SKIP(1)
"           Ф.И.О.             |Дата смены|    Поле    |   Было   |  Сейчас  |" SKIP
"------------------------------|----------|------------|----------|----------|" SKIP.

FOR EACH person
   NO-LOCK,
   EACH history
      WHERE history.file-name  EQ "person"
        AND history.field-ref  EQ STRING(person.person-id)
        AND history.modif-date GE beg-date
        AND history.modif-date LE end-date
      NO-LOCK
      BY history.modif-date:

   cNm = person.name-last + " " + person.first-names.
   put screen col 1 row 24 STRING(history.modif-date, "99.99.9999").

   IF (history.modify EQ "W")
   THEN
   DO I = 1 TO (NUM-ENTRIES(history.field-value) - 2) BY 2:
      IF     (ENTRY(I    , history.field-value) EQ "*Гражд")
         AND (ENTRY(I + 1, history.field-value) NE "")
      /* Нашли */
      THEN DO:
         cTmp = ENTRY(I, history.field-value).
         PUT UNFORMATTED
            cNm FORMAT "x(30)"
            "|" STRING(history.modif-date, "99.99.9999")
            "|" cTmp FORMAT "x(12)"
            "|" ENTRY(I + 1, history.field-value) FORMAT "x(10)"
            "|" GetXAttrValue("person", STRING(person.person-id), "Гражд") FORMAT "x(10)"
            "|" SKIP.
      END.
   END.
END.

put screen col 1 row 24 color normal STRING(" ","X(80)").
{preview.i}
{intrface.del}
