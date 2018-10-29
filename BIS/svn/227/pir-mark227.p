/***************************************
 *                                     *
 * Процедура маркирования документов   *
 * по 227-ФЗ.                          *
 *                                     *
 ***************************************
 *                                     *
 * Автор: Маслов Д. А. Maslov D. A.    *
 * Заявка:                             *
 * Дата создания: 04.09.12             *
 *                                     *
 ***************************************/
{globals.i}

{intrface.get xclass}

DEF INPUT PARAM in-Data-Id LIKE DataBlock.Data-Id NO-UNDO.
DEF INPUT PARAM cParam                    AS CHAR NO-UNDO.


DEF TEMP-TABLE tblOpEntry NO-UNDO LIKE op-entry.



/**
 * Вовращает вид операции. 
 * @param HANDLE hOp Указатель на буффер документа;
 * @result CHAR
 **/
FUNCTION getOperType RETURNS TAArray (INPUT hOp AS HANDLE):

  DEF VAR iRes        AS CHAR INIT ? NO-UNDO.
  DEF VAR oResult     AS TAArray     NO-UNDO.
  DEF VAR currOper    AS CHAR        NO-UNDO.
  DEF VAR findObj     AS TAArray     NO-UNDO.

  DEF VAR cQuery      AS CHAR        NO-UNDO.
  DEF VAR hQuery      AS HANDLE      NO-UNDO.

  DEF VAR key1        AS CHAR        NO-UNDO.
  DEF VAR val1        AS CHAR        NO-UNDO.

  DEF BUFFER op-entry FOR op-entry.

  oResult = NEW TAArray().

       EMPTY TEMP-TABLE tblOpEntry.

       FOR EACH op-entry WHERE op-entry.op EQ hOp::op NO-LOCK:
          CREATE tblOpEntry.
          BUFFER-COPY op-entry TO tblOpEntry. 
       END.
  


   /**
    * По всем включенным кодам
    * классификатора у которых 
    * код транзакции совпадает
    * с кодом документа.
    **/  
   FOR EACH code WHERE code.class EQ "PirOperTypes" 
                                  AND LOGICAL(code.misc[1]) 
                                  AND CAN-DO(code.misc[2],hOp::op-kind) 
                              NO-LOCK:

      IF code.misc[5] NE "" THEN DO:
             findObj = NEW TAArray().
             findObj:loadSplittedList(code.misc[5],"|",FALSE).

              cQuery = "FOR EACH tblOpEntry WHERE ".
                {foreach findObj key1 val1}
                  cQuery = cQuery + "CAN-DO(" + QUOTER(val1) + "," + key1 + ") AND ".
                {endforeach findObj}
                  cQuery = SUBSTR(cQuery,1,LENGTH(cQuery) - 4).
             DELETE OBJECT findObj.

           CREATE QUERY hQuery.
           hQuery:SET-BUFFERS(BUFFER tblOpEntry:HANDLE).
           hQuery:QUERY-PREPARE(cQuery).
           hQuery:QUERY-OPEN().

           IF hQuery:GET-FIRST() THEN DO:
              IF CAN-DO((IF code.misc[6] <> "" THEN code.misc[6] ELSE "*"),hOp::details) THEN oResult:push(code.code).
           END.

           hQuery:QUERY-CLOSE().
           DELETE OBJECT hQuery.
   
      END. ELSE DO:

       FIND FIRST tblOpEntry WHERE ( 
                                     (CAN-DO(code.misc[3],tblOpEntry.acct-db) OR (code.misc[3] = "?" AND tblOpEntry.acct-db EQ ?))
                               AND   (CAN-DO(code.misc[4],tblOpEntry.acct-cr)  OR (code.misc[3] = "?" AND tblOpEntry.acct-db EQ ?))
                                   )
                             NO-LOCK NO-ERROR.
                                   
             IF AVAILABLE(tblOpEntry) THEN DO:               
              IF CAN-DO((IF code.misc[6] <> "" THEN code.misc[6] ELSE "*"),hOp::details) THEN oResult:push(code.code).
             END.
     END.
   END.

 RETURN oResult. 
END FUNCTION.

DEF VAR currOper   AS CHAR                 NO-UNDO.
DEF VAR currDate   AS DATE                 NO-UNDO.

DEF VAR dBegDate   AS DATE INIT 01/10/2012 NO-UNDO.
DEF VAR dEndDate   AS DATE INIT 01/10/2012 NO-UNDO.

DEF VAR timeBeg    AS INT                  NO-UNDO.
DEF VAR timeEnd    AS INT                  NO-UNDO.


DEF VAR isLnk      AS LOG  INIT NO         NO-UNDO.
DEF VAR typeOper   AS TAArray              NO-UNDO.
DEF VAR isExclude  AS LOG                  NO-UNDO.
DEF VAR oDoc       AS TDocument            NO-UNDO.

DEF VAR oConfig    AS TAArray              NO-UNDO.
DEF VAR paramList  AS CHAR                 NO-UNDO.

DEF VAR hOp        AS HANDLE               NO-UNDO.

DEF VAR vLnTotalInt AS INT                 NO-UNDO.
DEF VAR vLnCountInt AS INT                 NO-UNDO.



ASSIGN
  dBegDate = gbeg-date
  dEndDate = gend-date
 .


oConfig = NEW TAArray().

oConfig:loadSplittedList(cParam,"|",FALSE).

paramList = oConfig:get("oper").

   {init-bar.i "Маркируем дни ..."}
   vLnTotalInt = dEndDate - dBegDate.


    FOR EACH op WHERE op.op-date GE dBegDate AND op.op-date LE dEndDate 
                   AND CAN-DO("b,o",acct-cat) 
                   AND op.op-status GT "А" NO-LOCK BREAK BY op.op-date:
 
         IF FIRST-OF(op.op-date) THEN DO:
           timeBeg = TIME.
         END.

         hOp = BUFFER op:HANDLE.


        isExclude = LOGICAL(getXAttrValueEx('op',STRING(op.op),'pirF227exc','NO')).
        currOper  = getXAttrValueEx("op",STRING(op.op),"PirF227Oper",?).
 
       /***
        * Если операция уже
        * промаркирована, то пропускаем
        * ее. Иначе производим маркирование.
        ****/


        IF NOT isExclude AND (currOper = ? OR LOGICAL(oConfig:get("force"))) THEN DO:
           typeOper = getOperType(BUFFER op:HANDLE).
            UpdateSigns("op",STRING(op.op),"PirF227Oper",typeOper:toList(),NO).
           DELETE OBJECT typeOper.
        END. 

       IF LAST-OF(op.op-date) THEN DO:
         timeEnd = TIME.
         {move-bar.i vLnCountInt vLnTotalInt}
         vLnCountInt = vLnCountInt + 1.
       END.


   END.

DELETE OBJECT oConfig.
{intrface.del}
RETURN "".
