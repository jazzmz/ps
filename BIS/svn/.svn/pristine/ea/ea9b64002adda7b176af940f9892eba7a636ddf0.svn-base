
/*Отчет по ненадлежащим активам по ПК*/

{globals.i}
{tmprecid.def}
{getdate.i}

DEF VAR oTable AS TTable NO-UNDO.
DEF VAR oTpl AS TTpl NO-UNDO.
DEF VAR cName as CHAR NO-UNDO.	
DEF VAR iEndDate as DATE NO-UNDO.
DEF VAR dTranshNA AS DEC NO-UNDO.

DEF VAR dCurTransh AS DEC NO-UNDO.
DEF VAR dBegTransh AS DEC NO-UNDO.
def var totaldCurTransh AS DEC INIT 0 NO-UNDO.
def var totaldBegTransh AS DEC INIT 0 NO-UNDO.
def var totaldTranshNA AS DEC INIT 0 NO-UNDO.
def var totaldTranshCur AS DEC INIT 0 NO-UNDO.

DEF VAR showZero     AS LOG INIT TRUE NO-UNDO.

DEF BUFFER bloan for loan.

DEF VAR oSysClass AS TSysClass NO-UNDO.

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */

DEF TEMP-TABLE tRep NO-UNDO
         FIELD Name as CHAR
         FIELD cont-code like loan.cont-code
         FIELD open-date like loan.open-date
         FIELD cont-num   as  CHAR
         FIELD dBegTransh as dec
         FIELD dCurTransh as dec
         FIELD dTranshNA as DEC
         INDEX iDx IS PRIMARY cont-code open-date.
oTpl = new TTpl("pir-kid-na.tpl").
oSysClass = new TSysClass().
oTable = new TTable(6).
iEndDate = end-date.

PROCEDURE sAlign:
DEF INPUT PARAMETER Al as CHAR.
 oTable:setAlign(1,oTable:height,Al).
 oTable:setAlign(2,oTable:height,Al).
 oTable:setAlign(3,oTable:height,Al).
 oTable:setAlign(4,oTable:height,Al).
 oTable:setAlign(5,oTable:height,Al).
 oTable:setAlign(6,oTable:height,Al).


END PROCEDURE.

/* Делаем заголовок таблицы*/
               oTable:AddRow().
               oTable:AddCell("Заемщик").
               oTable:AddCell("Номер и дата").
               oTable:AddCell("Сумма транша (в рубл. экв.)").
   	       oTable:setColspan(3,1,2).
               oTable:AddCell("Сумма НА").
   	       oTable:setColspan(4,1,2).

               oTable:setAlign(1,oTable:height,"center").
               oTable:setAlign(2,oTable:height,"center").
               oTable:setAlign(3,oTable:height,"center").
               oTable:setAlign(4,oTable:height,"center").


   	      

               oTable:AddRow().
               oTable:AddCell("   ").
               oTable:AddCell("   ").
               oTable:AddCell("Первоначальная").
               oTable:AddCell("На дату составления отчета").
               oTable:AddCell("Первоначальная").
               oTable:AddCell("На дату составления отчета").
               RUN sAlign("center").

               oTable:AddRow().
               oTable:AddCell(1).
               oTable:AddCell(2).
               oTable:AddCell(3).
               oTable:AddCell(4).
               oTable:AddCell(5).
               oTable:AddCell(6).
       	       RUN sAlign("center").

               oTable:colsWidthList="25,25,16,15,16,15".

FOR EACH tmprecid,
    first loan where RECID(loan) = tmprecid.id and loan.class-code = "l_agr_with_diff" NO-LOCK:

    vLnTotalInt = vLnTotalInt + 1.

END.


  MESSAGE "Подавлять нулевые?" VIEW-AS ALERT-BOX BUTTONS YES-NO SET showZero.
  showZero = NOT showZero.


FOR EACH tmprecid,
    first loan where RECID(loan) = tmprecid.id and loan.class-code = "l_agr_with_diff" NO-LOCK:

         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }



    find first person where person.person-id = loan.cust-id NO-LOCK.

    cName = person.name-last + " " + person.first-names.

    FOR EACH bloan where bloan.class-code <> "l_agr_with_diff" 
                     and bloan.contract = loan.contract
                     and bloan.cont-code begins loan.cont-code NO-LOCK.

         find last loan-var of bloan where (loan-var.amt-id EQ 0 OR loan-var.amt-id = 7)
/*                                        and loan-var.balance <> 0 */
                                        and loan-var.since <= iEndDate
                                        NO-LOCK NO-ERROR.
         IF AVAILABLE loan-var THEN  /*если нашли лоан-вар неравный 0, то это и будет остаток по траншу на дату*/
            DO:
               if loan-var.balance > 0 then
               DO:

               dCurTransh = loan-var.balance.

               if loan.currency  <> "" then dCurTransh = dcurTransh * oSysClass:getCBRKurs(INT(loan.currency),loan.open-date).

               find first loan-var of bloan where (loan-var.amt-id EQ 0)
                                               and loan-var.since >= bloan.open-date
                                              NO-LOCK NO-ERROR.
               if available loan-var then dBegTransh = loan-var.balance.

               if loan.currency  <> "" then dBegTransh = dBegTransh * oSysClass:getCBRKurs(INT(loan.currency),loan.open-date).  

               if bloan.close-date <> ? then message bloan.cont-code view-as alert-box.
               find first loan-acct where loan-acct.contract  = bloan.contract
                                      and loan-acct.cont-code = bloan.cont-code
                                      and loan-acct.acct-type = "КредРасч"
                                           NO-LOCK NO-ERROR.
               dTranshNA = 0.

               FOR EACH op-entry WHERE op-entry.op-date = bloan.open-date
                                   and op-entry.acct-db = loan-acct.acct
                                   and op-entry.acct-cr begins '70601' 
/*                                   and op-entry.user-id not begins '02050'*/
                                   NO-LOCK.

                              if CAN-DO ("!02050*,*",op-entry.user-id) THEN
                               dTranshNA = dTranshNA + op-entry.amt-rub.                               


               END.

               find first loan-var of bloan where (loan-var.amt-id EQ 0)                         /*Ищем сумму транша на момент открытия*/
                                              and loan-var.balance <> 0 
                                              and loan-var.since = bloan.open-date
                                              NO-LOCK NO-ERROR.

               if dBegTransh < dTranshNA THEN  dTranshNA = dBegTransh.

               FIND FIRST tRep where tRep.cont-code begins loan.cont-code and tRep.open-date = bloan.open-date NO-LOCK NO-ERROR.
               IF AVAILABLE tRep THEN
                   DO:

                      ASSIGN 
                            tRep.cont-num = tRep.cont-num + ", " + bloan.cont-code + " " + STRING(bloan.open-date)
                            tRep.dBegTransh = tRep.dBegTransh + dBegTransh
                            tRep.dCurTransh = tRep.dCurTransh + dCurTransh.

                   END.
               ELSE
                   DO:
                      CREATE tRep.
                      ASSIGN
                            tRep.Name       = cName
                            tRep.cont-code  = bloan.cont-code
                            tRep.open-date  = bloan.open-date
                            tRep.cont-num   = bloan.cont-code + " " + STRING(bloan.open-date)
                            tRep.dBegTransh = dBegTransh
                            tRep.dCurTransh = dcurTransh
                            tRep.dTranshNA  = dTranshNA.
                   END.
                IF showZero OR tRep.dTranshNA > 0 THEN cName = " ".
               END.
            END.
    END.

    vLnCountInt = vLnCountInt + 1.    

END.

FOR EACH tRep:
      IF showZero OR tRep.dTranshNA > 0 THEN DO:
               oTable:AddRow().
               oTable:AddCell(tRep.Name).
               if tRep.Name = "" then oTable:setBorder(1,oTable:height,1,0,0,1).
               oTable:AddCell(tRep.cont-num).
               oTable:AddCell(TRIM(STRING(tRep.dBegTransh,"->>>,>>>,>>>,>>9.99"))).
               oTable:AddCell(TRIM(STRING(tRep.dcurTransh,"->>>,>>>,>>>,>>9.99"))).
               oTable:AddCell(TRIM(STRING(tRep.dTranshNA,"->>>,>>>,>>>,>>9.99"))).
               oTable:AddCell(TRIM(STRING(ROUND(tRep.dTranshNA * (tRep.dcurTransh / tRep.dBegTransh),2),"->>>,>>>,>>>,>>9.99"))).
       	       RUN sAlign("left").

       	       ASSIGN
               totaldCurTransh = totaldCurTransh + tRep.dcurTransh
               totaldBegTransh = totaldBegTransh + tRep.dBegTransh
	       totaldTranshNA = totaldTranshNA + tRep.dTranshNA
	       totaldTranshCur = totaldTranshCur + ROUND(tRep.dTranshNA * (tRep.dcurTransh / tRep.dBegTransh),2).
    END.

END.

               oTable:AddRow().
               oTable:AddCell("ИТОГО:").
               oTable:AddCell("").
               oTable:AddCell(TRIM(STRING(totaldBegTransh,"->>>,>>>,>>>,>>9.99"))).
               oTable:AddCell(TRIM(STRING(totaldCurTransh,"->>>,>>>,>>>,>>9.99"))).
               oTable:AddCell(TRIM(STRING(totaldTranshNA,"->>>,>>>,>>>,>>9.99"))).
               oTable:AddCell(TRIM(STRING(totaldTranshCur,"->>>,>>>,>>>,>>9.99"))).


oTpl:addAnchorValue("date",iEndDate).
oTpl:addAnchorValue("Table",oTable).

{setdest.i}

oTpl:show().

{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
DELETE OBJECT oSysClass.



