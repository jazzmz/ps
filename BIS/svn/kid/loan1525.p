/*По заявке 1525.
отчет о выданых за заданный период траншах по договорам ПК
Автор: Красков А.С.
Заказчик: Василькова Т.В.

*/

{bislogin.i}
{globals.i}
{getdates.i}

{lshpr.pro}           /* Инструменты для расчета параметров договора */

DEF VAR months AS CHAR NO-UNDO 
        INITIAL "январь,февраль,март,апрель,май,июнь,июль,август,сентябрь,октябрь,ноябрь,декабрь".

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */

DEF VAR Itog_razdel AS Decimal No-UNDO.
DEF VAR Itog_razdelRate AS Decimal No-UNDO.


DEFINE BUFFER Loan for loan. 
DEFINE BUFFER bLoan for loan.

DEF temp-table tt NO-UNDO
    FIELD cont-code like loan.cont-code
    FIELD open-date like loan.open-date
    FIELD amt AS DECIMAL
    FIELD rate like comm-rate.rate-comm
    INDEX cont-code cont-code
    .

DEFINE VAR oTransh AS TLoan   NO-UNDO.
DEFINE VAR oTpl    AS TTpl   NO-UNDO.
DEFINE VAR oClient AS TClient NO-UNDO.
DEFINE VAR oTable  AS TTable  NO-UNDO.
def var count as int INIT 1 NO-UNDO.
def var totalamt as dec INIT 0 NO-UNDO.
DEFINE VAR cLoan as CHAR NO-UNDO.

PROCEDURE UpdateAlign:
DEFINE INPUT PARAMETER Align AS CHARACTER NO-UNDO.
def var i as int init 1 NO-UNDO.

   do i = 1 to 9:
      oTable:setalign(i,oTable:currRow,Align).
   end.
END PROCEDURE.


PROCEDURE PushTempTable2TTable:

def var maxRate as dec INIT 0 NO-UNDO.
def var firstline as logical init yes NO-UNDO.
        
           oTable:AddRow().
           oTable:AddCell(count).
           oTable:AddCell("Кредитный договор " + cLoan).
           oTable:AddCell(" ").
           oTable:AddCell(" ").
           oTable:AddCell(" ").
           oTable:AddCell(" ").
           oTable:AddCell(" ").
           oTable:AddCell(" ").
           oTable:AddCell(" ").
	   RUN UpdateAlign("Center").
           oTable:setColspan(2,oTable:currRow,2).


        find first tt NO-LOCK NO-ERROR.
        maxRate = tt.rate.
	count = count + 1.
	totalamt = 0.
        FOR EACH tt NO-LOCK:
           if maxRate < tt.rate then maxRate = tt.rate.
           totalamt = totalamt + tt.amt.
           oTable:AddRow().
           oTable:AddCell(" ").
           oTable:AddCell(tt.cont-code).
           if firstline then 
                do:
                   oTable:AddCell(oClient:name-short).
                   if loan.currency = "" then oTable:AddCell("810"). else oTable:AddCell(loan.currency).
                   if loan.cust-cat = "Ч" then oTable:AddCell("фл"). else oTable:AddCell("Юр").
                   find last loan-acct where loan-acct.contract  = loan.contract 
                                         and loan-acct.cont-code = loan.cont-code
                                         and loan-acct.acct-type = "Кредит"
                                         and loan-acct.since     <= end-date  
                                         NO-LOCK NO-ERROR.
                   if not available (loan-acct) then message "Не найден ссудный счет по договору " loan.cont-code SKIP "на дату " end-date VIEW-AS ALERT-BOX.
                   oTable:AddCell(loan-acct.acct).
                   firstline = no.
                end.
             else
                do:
                   oTable:AddCell(" ").
                   oTable:AddCell(" ").
                   oTable:AddCell(" ").
                   oTable:AddCell(" ").
                end.
        
           oTable:AddCell(tt.open-date).
           oTable:AddCell(TRIM(STRING(tt.amt,"->>,>>>,>>>,>>9.99"))).
           oTable:AddCell(tt.rate).
           oTable:AddCell(" ").
           
        end.

           oTable:AddRow().
           oTable:AddCell(" ").
           oTable:AddCell("Итого: ").
           oTable:AddCell(" ").
           oTable:AddCell(" ").
           oTable:AddCell(" ").
           oTable:AddCell(" ").
           oTable:AddCell(" ").
           oTable:AddCell(TRIM(STRING(totalamt,"->>,>>>,>>>,>>9.99"))).
           oTable:AddCell(" ").
           oTable:AddCell(MaxRate).
           itog_razdel = itog_razdel + totalamt.
           itog_razdelRate =  itog_razdelRate + MaxRate.
END PROCEDURE.



Procedure ProcessingLoan:

DEF VAR balance AS decimal NO-UNDO.
DEF VAR dT1 AS decimal NO-UNDO.
DEF VAR dT2 AS decimal NO-UNDO.
    totalamt = 0.

    oTransh = new TLoan(RECID(loan)).
    oClient = oTransh:GetOwner().

    for each bLoan where bLoan.cont-code begins loan.cont-code + " "
                      and bLoan.contract = loan.contract
                     and bloan.open-date >= beg-date
                     and bloan.open-date <= end-date
                     NO-LOCK:


                     /*нас интересует первая процентная ставка по договору, таким образом ожидается что дата условия = дате открытия транша, если на дату открытия транша нету условия - то это какой-то невообразимый косяк, поэтому ищем сразу в comm-rate*/                     

                     find first comm-rate where comm-rate.kau = bLoan.contract + "," + bLoan.cont-code
                                            and comm-rate.since = bLoan.open-date
                                         NO-LOCK NO-ERROR.

                     if NOT AVAILABLE (comm-rate) THEN
                        DO:
                           MESSAGE "Не найдена процентная ставка по траншу " bLoan.cont-code SKIP "на дату открытия транша " bLoan.open-date VIEW-AS ALERT-BOX.
                           RETURN.
                        END.

/*                     RUN STNDRT_PARAM(bLoan.contract, bLoan.cont-code, 0, bLoan.open-date, OUTPUT balance, OUTPUT dT1, OUTPUT dT2).*/ /*так не правильно, т.к. возвращает значение за минусом погашения, если он было в этот день. что тоже непонятно странно...*/
                     balance = 0.

                     FOR EACH loan-int WHERE loan-int.contract = bloan.contract
                                         and loan-int.cont-code = bloan.cont-code
                                         and loan-int.mdate = bloan.open-date
            	                         and loan-int.id-d = 0
                                         and loan-int.id-k = 3
					 NO-LOCK.
		         balance = balance + loan-int.amt-rub.
                     END. 

                     CREATE tt.
                     ASSIGN
                           tt.cont-code = bLoan.cont-code
                           tt.open-date = bLoan.open-date
                           tt.amt       = balance
                           tt.rate      = rate-comm.

                     totalamt = totalamt + balance.


    end.

 

    if totalamt > 0 then RUN PushTempTable2TTable. /*здесь было > 500, но по заявке 2255 исправил на 0*/
  EMPTY TEMP-TABLE tt.  
  DELETE OBJECT oTransh NO-ERROR.
  DELETE OBJECT oClient NO-ERROR.


END PROCEDURE.


Procedure FindAllLoan:
DEFINE INPUT PARAMETER currency as CHARACTER. 
        itog_razdel = 0.
        itog_razdelRate = 0.
        oTable:AddRow().
        oTable:AddCell(" "). 
        CASE  currency:
           WHEN "" THEN oTable:AddCell("РАЗДЕЛ 1 (рубли)"). 
           WHEN "840" THEN oTable:AddCell("РАЗДЕЛ 2 (доллары)"). 
           WHEN "978" THEN oTable:AddCell("РАЗДЕЛ 3 (евро)"). 
        END CASE.
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
	RUN UpdateAlign("Center").
        oTable:setColspan(2,oTable:currRow,2).

        for each loan where loan.contract = "Кредит"
                        and loan.cont-code begins "ПК"
                        and loan.class-code = "l_agr_with_diff"
                        and loan.currency = currency
                        and (loan.close-date >= beg-date or loan.close-date = ?)
                        NO-LOCK:
        
                              /* Бегущая строка - индикатор работы процесса */
		             {move-bar.i
		                vLnCountInt
		                vLnTotalInt
		             }
		             vLnCountInt = vLnCountInt + 1.
                             
                             cLoan = loan.cont-code.
                             RUN ProcessingLoan.
                        end.

        oTable:AddRow().
        oTable:AddCell(" "). 
        CASE  currency:
           WHEN "" THEN oTable:AddCell("ИТОГО ПО РАЗДЕЛУ 1: "). 
           WHEN "840" THEN oTable:AddCell("ИТОГО ПО РАЗДЕЛУ 2: "). 
           WHEN "978" THEN oTable:AddCell("ИТОГО ПО РАЗДЕЛУ 3: "). 
        END CASE.
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(TRIM(STRING(itog_razdel,"->>,>>>,>>>,>>9.99"))).
        oTable:AddCell(" ").
        oTable:AddCell(TRIM(STRING(itog_razdelRate,"->>,>>>,>>>,>>9.99"))).
/*	RUN UpdateAlign("Center").*/
        oTable:setColspan(2,oTable:currRow,2).

       if currency <> "978" then do:
        oTable:AddRow().
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
        oTable:AddCell(" "). 
      end.


END PROCEDURE.




oTable = new TTable(10).
oTable:AddRow().
oTable:AddCell("1"). 
oTable:AddCell("2"). 
oTable:AddCell("3"). 
oTable:AddCell("4"). 
oTable:AddCell("5"). 
oTable:AddCell("6"). 
oTable:AddCell("7"). 
oTable:AddCell("8"). 
oTable:AddCell("9"). 
oTable:AddCell("10"). 

{init-bar.i "Обработка договоров"}

for each loan where loan.contract = "Кредит"
                and loan.cont-code begins "ПК"
                and loan.class-code = "l_agr_with_diff"
                and (loan.close-date >= beg-date or loan.close-date = ?)
                NO-LOCK:
		    vLnTotalInt = vLnTotalInt + 1.                            
                end.                  

RUN FindAllLoan("").  /*прошлись по рублям*/

RUN FindAllLoan("840"). /*прошлись по долларам*/

Run FindAllLoan("978"). /*прошлись по евро*/

oTpl = new TTpl("loan1525.tpl").

oTpl:addAnchorValue("Month",ENTRY(MONTH(end-date),months)).
oTpl:addAnchorValue("year",YEAR(end-date)).
oTpl:addAnchorValue("Table1",oTable).




{setdest.i}
oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.


