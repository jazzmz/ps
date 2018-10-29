{pirsavelog.p}
/* ---------------------------------------------------------------------
File       : $RCSfile: pir-anrep.p,v $ $Revision: 1.12 $ $Date: 2008-10-02 10:31:36 $
Copyright  : (C) 2007, КБ ООО "Пpоминвестрасчет"
Office memo: 18.05.2007, Отдел противодействия Легализации, Утина В.А.
Function   : Построение отчета по клиентам, чьи анкеты давно не обновлялись.
Created    : 21.05.2007 17:28 lavrinenko
Modified   : $Log: not supported by cvs2svn $
Modified   : Revision 1.11  2007/11/28 06:43:50  borisov
Modified   : Добавлена проверка на "клиентские" счета: 405*-408*
Modified   :
Modified   : Revision 1.10  2007/11/28 06:43:50  kuntash
Modified   : razreshil vozmognost izmenenia pervoi daty
Modified   :
Modified   : Revision 1.9  2007/10/19 05:53:40  kuntash
Modified   : dobavlena proverka tolko po balansovim acct
Modified   :
Modified   : Revision 1.8  2007/10/18 07:42:21  anisimov
Modified   : no message
Modified   :
Modified   : Revision 1.7  2007/09/19 14:01:05  lavrinenko
Modified   : Добавлен отсевсклиентов с о счетами, которые были заблокированны давным-давно
Modified   :
Modified   : Revision 1.6  2007/08/09 06:39:40  lavrinenko
Modified   : Добавлен календарь
Modified   :
Modified   : Revision 1.5  2007/08/03 05:22:04  lavrinenko
Modified   : Выыводится полное наименование клиента-юридического лица
Modified   :
Modified   : Revision 1.4  2007/07/31 05:51:52  lavrinenko
Modified   : Добавлена проверка на открытые счета и выгрузка
Modified   :
Modified   : Revision 1.3  2007/07/30 11:16:40  lavrinenko
Modified   : специально для Утиной написаны комментарии
Modified   :
Modified   : Revision 1.2  2007/07/30 09:52:22  lavrinenko
Modified   : Добавлено определение даты  последнего обновлдения клиента
Modified   :
Modified   : Revision 1.1  2007/05/24 06:58:06  lavrinenko
Modified   : Отчет по просроченным анкетам клиентов
Modified   :
---------------------------------------------------------------------- */

DEFINE INPUT PARAMETER ipTypeCli AS CHAR NO-UNDO. /* Тип клиента */

DEF VAR lLevelRisk   AS CHAR LABEL "Уровень риска"    VIEW-AS COMBO-BOX LIST-ITEMS "Высокий", "Низкий", "Неуказан" FORMAT "x(10)" INITIAL "Высокий" NO-UNDO. /* Степень риска */
DEF VAR lLastUpdate  AS DATE LABEL "Дата обновления"  NO-UNDO. /* Дата последнего обновления        */
DEF VAR lBlockAcct   AS DATE LABEL "Дата блокировки"  NO-UNDO. /* пороговая дата блокировки счета   */
DEF VAR clLastUpdate AS DATE         NO-UNDO.
DEF VAR iCount       AS INT          NO-UNDO.
DEF VAR cSigns       AS CHAR         NO-UNDO.

{globals.i}
{intrface.get xclass}

/*******************************************************************************************************/
/* получение даты последнего изменения по карточке клиента */
FUNCTION isClient RETURNS LOG  (INPUT ipType AS CHAR,
                                INPUT ipId   AS CHAR). 

   FIND FIRST cust-role WHERE cust-role.cust-cat   EQ ipType  AND 
              cust-role.cust-id    EQ ipId    AND 
              cust-role.class-code EQ 'ImaginClient' NO-LOCK NO-ERROR. 

   RETURN (AVAIL cust-role).

END FUNCTION. /* isClient  */

/* получение даты последнего изменения по карточке клиента */
FUNCTION GetLastHistDate RETURNS DATE (INPUT ipName AS CHAR,
                                       INPUT ipId   AS CHAR,
                                       INPUT ipSince AS DATE).

   FIND LAST history WHERE history.file-name EQ ipName AND
                           history.field-ref EQ ipId  AND 
                          (history.modif-date GT ipSince OR ipSince EQ ?) NO-LOCK NO-ERROR.

   RETURN (IF AVAIL history THEN history.modif-date ELSE ipSince).

END FUNCTION. /* GetLastHistDate  */

/* проверка соотвествию установленному уровню риска */
FUNCTION IsNeedUpDate RETURNS LOG (INPUT  ipName  AS CHAR,
                                   INPUT  ipId    AS CHAR,
                                   INPUT  ipRisk  AS CHAR,
                                   INPUT  ipLDate AS DATE,
                                   INPUT  ipDate  AS DATE,
                                   OUTPUT opDate  AS DATE,
                                   OUTPUT opSigns AS CHAR).

   DEF VAR clLevelRisk  LIKE lLevelRisk  NO-UNDO.
   DEF VAR clType       AS CHAR          NO-UNDO.
   DEF VAR isNeed       AS LOG           INITIAL NO NO-UNDO.

   clType = (IF ipName EQ 'cust-corp' THEN 'Ю' ELSE IF ipName EQ 'banks' THEN 'Б' ELSE 'Ч').
   IF isClient(clType, ipId) THEN DO:
      opSigns     = GetXAttrValueEx(ipName, ipId, "ОГРН","").
      clLevelRisk = GetXAttrValueEx(ipName, ipId, "РискОтмыв",?).

      /* определение принадлежности к выбранной группе риска */
      IF (ipRisk EQ "Высокий"  AND clLevelRisk BEGINS "П")  OR
         (ipRisk EQ "Низкий"   AND clLevelRisk EQ "Низкий") OR
         (ipRisk EQ "Неуказан" AND ((clLevelRisk NE "Низкий" AND NOT clLevelRisk BEGINS "П") OR clLevelRisk EQ ?))
      THEN DO:

         /* проверка наличия открытых и не заблокированных счетов */
         FIND FIRST acct WHERE acct.cust-cat   EQ clType         AND
                               acct.cust-id    EQ INTEGER(ipId)  AND
                               acct.close-date EQ ?              AND
                               acct.acct-cat   EQ "b"            AND
                               (acct.bal-acct GE 40500) AND (acct.bal-acct LE 40899) AND
                               (acct.bal-acct NE 40818) AND (acct.bal-acct NE 40819) AND
                               NOT ({assigned acct.acct-status})
                         NO-LOCK NO-ERROR.

         IF AVAIL acct THEN isNeed = YES.
         ELSE /* если нет открытых незаблокированных счетов, то смотрим когда блокировались счета */
            FOR EACH acct WHERE acct.cust-cat   EQ clType        AND 
                                acct.cust-id    EQ INTEGER(ipId) AND
                                acct.close-date EQ ?             AND
                                acct.open-date  LT lBlockAcct
                          NO-LOCK:

               FIND LAST history WHERE history.file-name  EQ 'acct'                                      AND
                                       history.field-ref  EQ STRING(acct.acct) + ',' + STRING(acct.curr) AND
                                       LOOKUP ('acct-status',history.field-value) > 0
                                 NO-LOCK NO-ERROR.

               isNeed = (AVAIL history AND history.modif-date GE lBlockAcct).
            END. /* FOR EACH acct  */

            IF isNeed THEN DO:
               opDate = IF ipLDate GT ipDate THEN ipLDate
                                             ELSE GetLastHistDate(ipName, ipId, ipLDate).

               RETURN NOT (opDate GT ipDate).
            END.

      END. /* IF ipRisk EQ "Высокий"  AND clLevelRisk BEGINS "П"  OR  */
   END. /* IF isClient (clType, ipId) THEN */

   RETURN NO.
END FUNCTION. /* IsLevelRisk */
/*******************************************************************************************************/

ASSIGN 
   lLastUpdate = DATE (MONTH(TODAY), DAY (TODAY), YEAR(TODAY) - 1 )
   lBlockAcct  = DATE (MONTH(TODAY), DAY (TODAY), YEAR(TODAY) - 1 )
.

PAUSE 0.
/* форма ввода параметров поиска */
DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE WITH FRAME params:
   DISPLAY   lLevelRisk  SKIP
             lLastUpdate SKIP
      WITH FRAME params COLOR BRIGHT-WHITE.

   UPDATE
      lLevelRisk  HELP "Присвоенный клиенту уровень риска"
      lLastUpdate HELP "Дата последнего обновления анкет, до которой анкеты считаются не обновленными"
      lBlockAcct  HELP "Дата блокировки счетов, Клиенты со счетами заблокированными ранее не попадают в выборку"
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

         ON "F1" OF lBlockAcct IN FRAME params   DO:
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

{setdest.i}

PUT UNFORMAT "   Дата        ОГРН      Наименование клиента " SKIP
             "обновления" SKIP
             "  анкеты  " SKIP
             "---------- ------------- -----------------------------------------------------------" SKIP.

CASE ipTypeCli:
   WHEN 'Ю' THEN DO:
      FOR EACH cust-corp WHERE cust-corp.last-date LT lLastUpdate NO-LOCK BY cust-corp.name-short :

         IF IsNeedUpDate("cust-corp", STRING(cust-corp.cust-id), lLevelRisk, 
                         cust-corp.last-date, lLastUpdate, clLastUpdate, cSigns)
         THEN DO:
            iCount = iCount + 1.
            PUT UNFORMAT STRING(clLastUpdate, "99/99/9999") ' ' STRING (cSigns,"x(13)") ' '
            ( /* IF cust-corp.name-short NE '' THEN cust-corp.name-short ELSE */ cust-corp.name-corp) SKIP.
         END. /* IF IsNeedUpDate("cust-corp"  */
      END. /* FOR EACH cust-corp */
   END. /* WHEN 'Ю'*/

   WHEN 'Б' THEN DO:
      FOR EACH banks WHERE banks.last-date LT lLastUpdate NO-LOCK BY banks.name:

         IF IsNeedUpDate("banks", STRING(banks.bank-id), lLevelRisk,
                         banks.last-date, lLastUpdate, clLastUpdate, cSigns)
         THEN DO:
            iCount = iCount + 1.
            PUT UNFORMAT STRING(clLastUpdate, "99/99/9999") ' ' STRING (cSigns,"x(13)") ' 'banks.name SKIP.
         END. /* IF IsNeedUpDate("banks" */
      END. /* FOR EACH cust-corp */
   END. /* WHEN 'Б'*/

   WHEN 'Ч' THEN DO:
      FOR EACH person WHERE person.last-date LT lLastUpdate NO-LOCK BY person.name-last:

         IF IsNeedUpDate("person", STRING(person.person-id), lLevelRisk,
                         person.last-date, lLastUpdate, clLastUpdate, cSigns)
         THEN DO:
            iCount = iCount + 1.
            PUT UNFORMAT STRING(clLastUpdate, "99/99/9999") '  ' person.name-last  ' ' person.first-names SKIP.
         END. /*  IF IsNeedUpDate("person",   */
      END. /* FOR EACH cust-corp */
   END. /* WHEN 'Ч'*/

END. /*CASE*/	

PUT UNFORMAT "----------  ------------------------------------------------------------------------" SKIP 
             "ВСЕГО:      " STRING (iCount, ">>>,>>9") SKIP.

{preview.i} 
