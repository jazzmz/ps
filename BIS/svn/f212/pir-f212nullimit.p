{globals.i}
{tmprecid.def}
&SCOPED-DEFINE kassType Касса

DEF VAR oTpl           AS TTpl  		NO-UNDO.
DEF VAR oAcct          AS TAcct 		NO-UNDO.
DEF VAR dfirstMove     AS DATE  		NO-UNDO.
DEF VAR lisInfInReport AS LOGICAL INITIAL FALSE NO-UNDO.

DEF VAR hQuery AS HANDLE    NO-UNDO.
DEF VAR cQuery AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE tmp-table NO-UNDO
                  FIELD name-short AS CHARACTER
                  FIELD acct AS CHARACTER
                  .

/********** Переменные для интерфейса *********/

DEF VAR dBeg AS DATE      NO-UNDO.
DEF VAR dEnd AS DATE      NO-UNDO.

/***********************************
 * Иногда требуется формировать    *
 * сообщение от произвольной даты. *
 ***********************************
 *				   *
 ***********************************/
DEF VAR dCurrDate AS DATE NO-UNDO.

DEF VAR cNum AS CHARACTER NO-UNDO.
DEF VAR cSort AS CHARACTER INITIAL "DECIMAL(acct)" VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS "По счету","DECIMAL(acct)","По названию","name-short" NO-UNDO.

DEF BUTTON btnOk.
DEF BUTTON btnCancel.

/********* Конец переменных интерфейса *********/

DEF FRAME frmMain
         "С :" dBeg AT 5 FORMAT "99/99/9999" NO-LABEL SKIP
         "По:" dEnd AT 5 FORMAT "99/99/9999" NO-LABEL SKIP
         "Номер:" cNum AT 7 FORMAT "x(3)" NO-LABEL SKIP
         "Сообщение от:" dCurrDate FORMAT "99/99/9999" NO-LABEL SKIP
         cSort NO-LABEL SKIP
         btnOk LABEL "Выполнить" btnCancel LABEL "Отмена"
         WITH TITLE "[ НУЛЕВОЙ ЛИМИТ ]" CENTERED
.
dCurrDate:SCREEN-VALUE = STRING(TODAY).

ENABLE ALL WITH FRAME frmMain.
ON CHOOSE OF btnOk
   DO:
     cNum = cNum:SCREEN-VALUE.
    dBeg = DATE(dBeg:SCREEN-VALUE).
    dEnd = DATE(dEnd:SCREEN-VALUE).
    dCurrDate = DATE(dCurrDate:SCREEN-VALUE).

                /* Нажата кнопка OK */

    FOR EACH tmprecid:        
      FIND FIRST cust-corp WHERE tmprecid.id = RECID(cust-corp) NO-LOCK.

      FOR EACH acct WHERE acct.cust-cat="Ю" AND acct.cust-id=cust-corp.cust-id AND  acct.acct MATCHES '40...810*'  AND (acct.close-date >DATE("01/01/" + STRING(YEAR(dBeg))) OR acct.close-date EQ ?) NO-LOCK:
                        /* См. заявку #314
                            Логика следующая:
                            Смотрим все рублевые счета клиента;
                            Находим первый счет по которому есть движения с кассой;
                            Добавляем его в таблицу, то есть будем выводить его на экран;
                            Иначе он наc не интересует
                        */

                    oAcct = new TAcct(acct.acct).
/*  
  Находим первое движение по кассе с начала года.
*/
                
                    dfirstMove = oAcct:getFirstMoveByDate(DATE("01/01/" + STRING(YEAR(dBeg))),dEnd,"20202*").
                    /* Если это движение лежит в интересуемом интервале */

                        IF  dfirstMove NE ? AND (dBeg<=dfirstMove AND dfirstMove<= dEnd) THEN
                                DO:

                                     CREATE tmp-table.
                                        ASSIGN
                                                 tmp-table.name-short=cust-corp.name-short
                                                 tmp-table.acct=acct.acct
                                          .                                        
                                        LEAVE.
                                END.

                DELETE OBJECT oAcct.                   


       END. /* По отобранным счетам */
  END. /* По отобранным организациям */



END.

ON VALUE-CHANGED OF cSort
    DO:
           ASSIGN cSort.
    END.

ON CHOOSE OF btnCancel
   DO:
               /* Нажата кнопка ОТМЕНА */

   END.

WAIT-FOR CHOOSE OF btnOk,btnCancel.

{setdest.i}
/********* ВЫВОДИМ ИНФОРМАЦИЮ НА ЭКРАН *********/
CREATE QUERY hQuery.
hQuery:SET-BUFFERS(BUFFER tmp-table:HANDLE).
cQuery = REPLACE("FOR EACH tmp-table BY #cSort#","#cSort#",cSort).

hQuery:QUERY-PREPARE(cQuery).
hQuery:QUERY-OPEN().

hQuery:GET-NEXT().


REPEAT WHILE NOT hQuery:QUERY-OFF-END:


                           oTpl = new TTpl("pir-f212nullimit.tpl").

                            oTpl:addAnchorValue("НАЗВАНИЕ",tmp-table.name-short).
                            oTpl:addAnchorValue("СЧЕТ",tmp-table.acct).
                            oTpl:addAnchorValue("НОМЕР",cNum).
                            oTpl:addAnchorValue("ДАТА",dCurrDate).
                            oTpl:addAnchorValue("ГОД",STRING(YEAR(TODAY))).
                            oTpl:show().    
                            DELETE OBJECT oTpl.
                             lisInfInReport = TRUE.
                            PAGE.

  hQuery:GET-NEXT().
END. /* Конец REPEAT */
hQuery:QUERY-CLOSE().
DELETE OBJECT hQuery.

IF NOT lisInfInReport THEN PUT UNFORMATTED "**** ДАННЫХ НЕТ ****" SKIP.
{preview.i}