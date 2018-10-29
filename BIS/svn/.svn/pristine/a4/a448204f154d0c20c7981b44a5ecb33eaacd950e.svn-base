using Progress.Lang.*.

{globals.i}

{tmprecid.def}
{getdate.i}
{ulib.i}
{lshpr.pro}           /* Инструменты для расчета параметров договора */


def var d1 as int.
DEF VAR oTpl   AS TTpl   NO-UNDO.
def var oTable AS TTable NO-UNDO.
def var oFunc  AS tfunc  NO-UNDO.

def var dT1 as dec NO-UNDO.
def var dT2 as dec NO-UNDO.

def buffer bfrMainLoan for Loan.
def buffer bfrTranshLoan for Loan.
def temp-table bfrTmpRecId like TmpRecId.


def var int-end-date as date NO-UNDO.
def var int-open-date as date NO-UNDO.
def var tempdate as date NO-UNDO.
def var transh_amount as dec NO-UNDO.
def var client_name as char no-undo.
def var kredit_acct as char no-undo.
def var transh_prrez as char no-undo.
def var transh_amt as dec no-undo.
def var transh_nachisl as dec no-undo.
def var transh_nachislTEMP as dec no-undo.
def var transh_rezerv as dec no-undo.
def var transh_virpr as dec no-undo. 
def var ddate as date NO-UNDO.
def var KursUSD as dec no-undo.
def var KursEUR as dec no-undo.

def var TotalSummTransh_amount as dec NO-UNDO.
def var TotalSummtransh_nachisl as dec NO-UNDO.
def var TotalSummtransh_rezerv as dec NO-UNDO.
def var TotalSummtransh_virpr as dec NO-UNDO.

def var LoanTotalSummTransh_amount as dec NO-UNDO.
def var LoanTotalSummtransh_nachisl as dec NO-UNDO.
def var LoanTotalSummtransh_rezerv as dec NO-UNDO.
def var LoanTotalSummtransh_virpr as dec NO-UNDO.

def var temp as char no-undo.

def input parameter otchtype as int.

def var FIO AS CHAR.

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */

d1 = TIME.


PROCEDURE PIR_LOAN_PERCENT_AMT_DATE_VIRT. /* не является препарсерной, испоьзуется препарсерными процедурами PIR_LOAN_PERCENT_NEW, PIR_LOAN_PERCENT_DATE */
   DEFINE INPUT  PARAMETER iContract        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iContCode        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iBegDate         AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iEndDate			AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iNeedMon			AS LOGICAL	NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Result    	AS DECIMAL		NO-UNDO.


   DEF VAR begDate AS DATE NO-UNDO.
   DEF VAR endDate AS DATE NO-UNDO.
   DEF VAR balance AS DECIMAL NO-UNDO.
   DEF VAR newBalance AS DECIMAL NO-UNDO.
   DEF VAR rate AS DECIMAL NO-UNDO.
   DEF VAR newRate AS DECIMAL NO-UNDO.
   DEF VAR summa AS DECIMAL NO-UNDO.
   DEF VAR totalSumma AS DECIMAL NO-UNDO.
   DEF VAR period AS INTEGER NO-UNDO.
   DEF VAR iDate AS DATE NO-UNDO.
   DEF VAR periodBegin AS DATE NO-UNDO.
   DEF VAR periodEnd AS DATE NO-UNDO.
   DEF VAR periodBase AS INTEGER NO-UNDO.
   DEF VAR PredSumma AS DEC.
   
   DEF VAR mainLoan AS CHARACTER NO-UNDO.
   
   begDate = iBegDate.
   endDate = iEndDate.

   /** База расчета процентов 365/366 */
   
   FIND FIRST loan WHERE loan.contract = iContract
                     and loan.cont-code = iContCode
                     NO-LOCK NO-ERROR.
                     

   /*изменения в старой функции: */

      mainLoan = GetMainLoan_ULL(loan.contract, loan.cont-code, false).

/* проверяем было ли погашение процентов в текущем дне (суть проблемы:
для поиска погашения процентов ищем автоматические операции которые создаются при пересчете на следующий день */


/* проверяем было ли погашение процентов за расчетный период */
   mainLoan = ENTRY(1,loan.cont-code," "). 


  find last loan-int
	where loan-int.cont-code = iContCode
				   /* ENTRY(2, mainLoan) */
	  and loan-int.contract = loan.contract
	  and loan-int.mdate >= begDate 
	  and loan-int.mdate <= endDate 

	  and (((loan-int.id-d = 6) /* НАЧ=6 И СП=4 ЭТО ОПЕРАЦИЯ 9 */
	  and (loan-int.id-k = 4))
	  or ((loan-int.id-d = 35) /* НАЧ=35 И СП=33 ЭТО ОПЕРАЦИЯ 79 */
	  and (loan-int.id-k = 33)))

	NO-LOCK NO-ERROR.


   if AVAILABLE(loan-int) then do:
     begDate = loan-int.mdate + 1. /* учитываем что добавляем 1 день для расчета */
   end.

/* проверяем была ли смена категории качества */
   def var startCQ AS DEC.
   def var endCQ AS DEC.
   DEF BUFFER bcomm-rate for comm-rate.
   DEF BUFFER bloan-acct for loan-acct.
   DEF BUFFER bterm-obl for term-obl.
   def var bPOS as LOGICAL.
   find last bterm-obl WHERE bterm-obl.cont-code EQ ENTRY(2, mainLoan) AND bterm-obl.contract EQ 'Кредит' AND bterm-obl.idnt EQ 128 NO-LOCK NO-ERROR.
   if AVAILABLE (bterm-obl) then do:
      if bterm-obl.end-date >=iBegdate and bterm-obl.end-date <= iEndDate then do:
         iBegDate = bterm-obl.end-date + 1.
         begdate = bterm-obl.end-date + 1.
         bPos = true.
      end.
      if bterm-obl.sop-date >=iBegDate and bterm-obl.sop-date <= iEndDate then do:
	iBegDate = bterm-obl.sop-date + 1. 
	begdate = bterm-obl.sop-date + 1.
        bPos = true.
      end.

   end. /*AVAILABLE (term-obl)*/

   find first bcomm-rate
	where bcomm-rate.commission begins "%Рез"
	  and bcomm-rate.kau = "Кредит," + mainLoan
	  and bcomm-rate.since >= iBegDate /* SSV #747 iBegDate begDate сдвигается, если было погашение  */
	  and bcomm-rate.since <= endDate
	NO-LOCK NO-ERROR.
   

   if AVAILABLE(bcomm-rate) then do:
      startCQ = bcomm-rate.rate-comm.
      find last bcomm-rate
	where bcomm-rate.commission begins "%Рез"
	  and bcomm-rate.kau = "Кредит," + mainLoan
	  and bcomm-rate.since >= iBegDate /* SSV #747 iBegDate begDate сдвигается, если было погашение  */
	  and bcomm-rate.since <= endDate
	NO-LOCK NO-ERROR.
      endCQ = bcomm-rate.rate-comm.
      if (startCQ <> endCQ) OR bPOS then do:

        find /* last */ first bcomm-rate
	  where bcomm-rate.rate-comm = /* startCQ */ endCQ
            and bcomm-rate.commission begins "%Рез"
   	    and bcomm-rate.kau = "Кредит," + mainLoan
	    and bcomm-rate.since >= iBegDate /* SSV #747 iBegDate begDate сдвигается, если было погашение */
 	    and bcomm-rate.since <= endDate
	  NO-LOCK NO-ERROR.

        begdate = bcomm-rate.since + 1.
        ibegdate = begdate.
        DEF VAR role AS CHAR NO-UNDO.
        role = if startCQ > 50
	  then "КредТ"
	  else "КредТВ".
        find first bloan-acct
	  where bloan-acct.cont-code = mainLoan
	    and bloan-acct.contract  = loan.contract
	    and bloan-acct.acct-type = role
	    NO-LOCK NO-ERROR.
        if available (bloan-acct) then do:
   	  DEF VAR oAcct AS TAcct NO-UNDO.
          oAcct = new tAcct(bloan-acct.acct).
          PredSumma = oAcct:getlastpos2date(enddate).
          delete object oAcct.
        end.
      end. /* if startCQ <> endCQ then do: */
   end. /* if AVAILABLE(bcomm-rate) then do: */

   periodBegin = MAX(begDate, loan.open-date). /* SSV было + 1  */
/*   out_Date    = periodBegin.*/

   /** В случаях когда дата окончания транша попадает на выходной день,
       дата окончания периода расчета процентов должна быть следующим рабочим днем.
       Здесь, вместо выражения 
   periodEnd = MIN(endDate, loan.end-date).
       выполним простое приcвоение
   */
   periodEnd = endDate. 
   
   /** Значения "до" периода */ 

tempdate = periodbegin.
   
   RUN STNDRT_PARAM(loan.contract, loan.cont-code, 0, (periodBegin - 1), OUTPUT balance, OUTPUT dT1, OUTPUT dT2).
/*             if bfrmainloan.currency = '978' then DO:
	      newbalance = balance * kursEur.
	   end.
           if bfrmainloan.currency = '840' then DO:
	      newbalance = balance * kursUsd.
	   end.         */                                          


/*        message loan.cont-code periodBegin periodEnd balance  VIEW-AS ALERT-BOX.*/


   rate = GetLoanCommission_ULL("КРедит", ENTRY(1, mainLoan," "), "%Кред", periodBegin, false).
   /** Побежали по дням */
   DO iDate = periodBegin TO periodEnd :
	
     RUN STNDRT_PARAM(loan.contract, loan.cont-code, 0, idate, OUTPUT newbalance, OUTPUT dT1, OUTPUT dT2).
/*             if bfrmainloan.currency = '978' then DO:
	      newbalance = newbalance * kursEur.
	   end.
           if bfrmainloan.currency = '840' then DO:
	      newbalance = newbalance * kursUsd.
	   end.                                              
                                                                                                        */
     newRate = GetLoanCommission_ULL("КРедит", ENTRY(1, mainLoan," "), "%Кред", iDate + 1, false).
     
     /**    ЕСЛИ:
     	1) изменился остаток
     	2) изменилась процентная ставка
     	3) последний день месяца
 		4) последний день расчетного периода,
 			ТО:
 		"создаем" подпериод, расчитываем значения, аккумулируем общую сумму,
 		новые значения становятся текущими!
 	*/
     IF    balance 	   <> newBalance
	OR rate            <> newRate 
	OR (DAY(iDate + 1) = 1 AND iDate < periodEnd) 
        OR iDate 	   = periodEnd THEN
       DO:
	     periodEnd = iDate.
	     periodBase = (IF TRUNCATE(YEAR(iDate) / 4,0) = YEAR(iDate) / 4 THEN 366 ELSE 365).
             period = periodEnd - periodBegin + 1.

/*	     summa = round(balance * rate / periodBase * period, 2).*/
	     summa = (balance * rate / periodBase * period).
		 totalSumma = totalSumma + summa.

		 /* В случае если суммадолга уменьшилась значит все проценты погашены, обнуляем все проценты которые начитали до этого!   */
/*		 IF newBalance < balance
			THEN
				ASSIGN
					totalSumma = 0
				.*/
		 

                 periodBegin = periodEnd + 1.
		 periodEnd = MIN(endDate, loan.end-date).
		 balance = newBalance.
		 rate = newRate.         
       END.
   END. 
   
   out_Result = totalSumma.
   
END PROCEDURE. /* "PIR_LOAN_PERCENT_AMT_DATE_VIRT" */







PROCEDURE Rach.

           RUN STNDRT_PARAM(bfrtranshloan.contract, bfrtranshloan.cont-code,  0, end-date, OUTPUT transh_amount , OUTPUT dT1, OUTPUT dT2).
           if transh_amount > 0 then do:


           RUN PIR_LOAN_PERCENT_AMT_DATE_VIRT(bfrtranshloan.contract, bfrtranshloan.cont-code, bfrtranshloan.open-date , End-date, NO , OUTPUT transh_nachisl).


              transh_rezerv = ROUND((transh_nachisl * DEC(entry(1,temp)) * 100),2).
	      transh_amount = round((transh_amount),2).
	      transh_nachisl = round((transh_nachisl),2).
              transh_rezerv = ROUND((transh_nachisl * DEC(entry(1,temp)) / 100 ),2).
	      transh_virpr = transh_nachisl - transh_rezerv.


           if bfrmainloan.currency = '978' then DO:
	      transh_amount = round((transh_amount * kursEur),2).
	      transh_nachisl = round((transh_nachisl * kursEur),2). 
              transh_rezerv = ROUND((transh_nachisl * DEC(entry(1,temp)) / 100),2).
	      transh_virpr = transh_nachisl - transh_rezerv.
	   end.

           if bfrmainloan.currency = '840' then DO:
	      transh_amount = round((transh_amount * kursUSD),2).                        
	      transh_nachisl = round((transh_nachisl * kursUSD),2).  
              transh_rezerv = ROUND((transh_nachisl * DEC(entry(1,temp)) / 100),2).
	      transh_virpr = transh_nachisl - transh_rezerv.
	   end.
	      if transh_virpr < 0 then message bfrtranshloan.cont-code transh_virpr transh_rezerv transh_nachisl temp VIEW-AS ALERT-BOX.

		 oTable:AddRow().
		 oTable:AddCell(bfrtranshloan.cont-code).
		 oTable:AddCell(bfrtranshloan.currency).
		 oTable:AddCell(FIO).
		 oTable:AddCell(kredit_acct).   /* oTable:AddCell(tempdate).*/
		 oTable:AddCell(DEC(entry(1,temp))).
		 oTable:AddCell(TRIM(STRING(round(transh_amount,2),">>>,>>>,>>>,>>9.99"))).
		 oTable:AddCell(TRIM(STRING(round(transh_nachisl,2),">>>,>>>,>>>,>>9.99"))).
		 oTable:AddCell(TRIM(STRING(round(transh_rezerv,2),">>>,>>>,>>>,>>9.99"))).
		 oTable:AddCell(TRIM(STRING(round(transh_virpr,2),">>>,>>>,>>>,>>9.99"))).
 		 oTable:AddCell(bfrtranshloan.end-date).

		 LoanTotalSummTransh_amount = LoanTotalSummTransh_amount + transh_amount.
		 LoanTotalSummtransh_nachisl = LoanTotalSummtransh_nachisl + transh_nachisl.
		 LoanTotalSummtransh_rezerv = LoanTotalSummtransh_rezerv + transh_rezerv.
		 LoanTotalSummtransh_virpr = LoanTotalSummtransh_virpr + transh_virpr.



	end.

END PROCEDURE.



oFunc = new tfunc().

dDate = end-date.


if otchtype = 1 then oTpl = new TTpl('pirvir12-1.tpl').
else
oTpl = new TTpl('pirvir12-2.tpl').
	                        	

oTable = new TTable(10).




if not can-find (first tmprecid)
then do:
    message "Нет ни одного выбранного договора!"
    view-as alert-box.
    return.
end.

            FIND FIRST instr-rate WHERE instr-rate.instr-cat EQ 'currency' 
                                                                  AND instr-rate.instr-code EQ STRING(840)
                                                                  AND instr-rate.rate-type EQ 'Учетный' 
                                                                  AND instr-rate.since = dDate 
                                                    NO-LOCK NO-ERROR.


            IF AVAILABLE(instr-rate) THEN kursusd =  instr-rate.rate-instr. ELSE MESSAGE "Не найден курс USD!!!" VIEW-AS ALERT-BOX.


            FIND FIRST instr-rate WHERE instr-rate.instr-cat EQ 'currency' 
                                                                  AND instr-rate.instr-code EQ STRING(978)
                                                                  AND instr-rate.rate-type EQ 'Учетный' 
                                                                  AND instr-rate.since = dDate 
                                                    NO-LOCK NO-ERROR.

            IF AVAILABLE(instr-rate) THEN kursEUR =  instr-rate.rate-instr. ELSE MESSAGE "Не найден курс EUR!!!" VIEW-AS ALERT-BOX.


{init-bar.i "Обработка договоров"}

for each tmprecid, first loan where RECID(loan) EQ tmprecid.id and CAN-DO('l_agr_with_diff,l_agr_with_per',Loan.class-code) NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.

    CREATE bfrTmpRecid.
    buffer-copy tmprecid to bfrtmprecid.
 
end.



int-end-date = end-date + 30.
int-open-date = end-date - 45.


FOR EACH bfrtmprecid,
    first bfrMainLoan where RECID(bfrmainloan) EQ bfrtmprecid.id and bfrMainLoan.contract = "Кредит" and bfrMainLoan.close-date = ? and bfrMainLoan.open-date <= end-date and CAN-DO('l_agr_with_diff,l_agr_with_per',bfrMainLoan.class-code) NO-LOCK.
    temp = oFunc:getKRez(bfrmainloan.cont-code,end-date).
/*    message temp end-date VIEW-AS ALERT-BOX.*/
/*    message bfrMainLoan.Cont-code VIEW-AS ALERT-BOX.*/

         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }


    find last loan-acct where loan-acct.contract = bfrmainloan.contract and loan-acct.cont-code = bfrmainloan.cont-code and loan-acct.since <= end-date and loan-acct.acct-type = "КРЕДИТ" NO-LOCK NO-ERROR.
                                                                                                                                                                                      
    if not available (loan-acct) then message "Не найден ссудный счет к договору: " bfrmainloan.cont-code VIEW-AS ALERT-BOX.
    else kredit_acct = loan-acct.acct.

    find first person where person.person-id = bfrmainloan.cust-id NO-LOCK NO-ERROR.

    if available person then FIO = person.name-last + " " + first-names. else FIO = " ".

       LoanTotalSummTransh_amount  =  0.
       LoanTotalSummtransh_nachisl =  0.
       LoanTotalSummtransh_rezerv  =  0.
       LoanTotalSummtransh_virpr   =  0.


    if otchtype = 1 and DEC(entry(1,temp)) <= 50 then do: /*1,2,3 группы риска */
       for each bfrTranshLoan where bfrTranshLoan.contract = bfrmainLoan.contract 
		                and bfrtranshloan.cont-code begins bfrmainloan.cont-code 
                                and CAN-DO('loan_trans_ov,loan_trans_diff',bfrTranshLoan.class-code) 
				and bfrtranshloan.open-date >= int-open-date 
				and bfrtranshloan.open-date <= end-date 
				and (bfrtranshloan.close-date = ? or bfrtranshloan.close-date >= end-date) NO-LOCK. 
	RUN rach.
       end.
    end.

    if otchtype = 2 and DEC(entry(1,temp)) <=  20 then do: /*1,2 группы риска */
       for each bfrTranshLoan where bfrTranshLoan.contract = bfrmainLoan.contract 
		                and bfrtranshloan.cont-code begins bfrmainloan.cont-code 
                                and CAN-DO('loan_trans_ov,loan_trans_diff',bfrTranshLoan.class-code) 
				and bfrtranshloan.open-date >= int-open-date 
				and bfrtranshloan.open-date <= end-date 
/*				and (bfrtranshloan.open-date + 45) <= int-end-date */
				and bfrtranshloan.end-date <= int-end-date 
				and (bfrtranshloan.close-date = ? or bfrtranshloan.close-date >= end-date) NO-LOCK. 

/*            message bfrtranshloan.Cont-code VIEW-AS ALERT-BOX.*/
	RUN rach.
       end.
    end.


       if LoanTotalSummTransh_amount <> 0 then  do:

           TotalSummTransh_amount  =  TotalSummTransh_amount + LoanTotalSummTransh_amount.
           TotalSummtransh_nachisl =  TotalSummtransh_nachisl + LoanTotalSummtransh_nachisl.
           TotalSummtransh_rezerv  =  TotalSummtransh_rezerv + LoanTotalSummtransh_rezerv.
           TotalSummtransh_virpr   =  TotalSummtransh_virpr + LoanTotalSummtransh_virpr.


  	   oTable:AddRow().
	   oTable:AddCell(bfrMainloan.cont-code).
	   oTable:AddCell(" ").
	   oTable:AddCell(" ").
	   oTable:AddCell(" ").
	   oTable:AddCell(" ").                       
	   oTable:AddCell(TRIM(STRING(round(LoanTotalSummTransh_amount,2),">>>,>>>,>>>,>>9.99"))).
	   oTable:AddCell(TRIM(STRING(round(LoanTotalSummtransh_nachisl,2),">>>,>>>,>>>,>>9.99"))).
	   oTable:AddCell(TRIM(STRING(round(LoanTotalSummtransh_rezerv,2),">>>,>>>,>>>,>>9.99"))).
	   oTable:AddCell(TRIM(STRING(round(LoanTotalSummtransh_virpr,2),">>>,>>>,>>>,>>9.99"))).
	   oTable:AddCell("  ").


       end.



 vLnCountInt = vLnCountInt + 1.

end.

   	   oTable:AddRow().
	   oTable:AddCell("Итог:").
	   oTable:AddCell(" ").
	   oTable:AddCell(" ").
	   oTable:AddCell(" ").
	   oTable:AddCell(" ").
	   oTable:AddCell(TRIM(STRING(round(TotalSummTransh_amount,2),">>>,>>>,>>>,>>9.99"))).
	   oTable:AddCell(TRIM(STRING(round(TotalSummtransh_nachisl,2),">>>,>>>,>>>,>>9.99"))).
	   oTable:AddCell(TRIM(STRING(round(TotalSummtransh_rezerv,2),">>>,>>>,>>>,>>9.99"))).
	   oTable:AddCell(TRIM(STRING(round(TotalSummtransh_virpr,2),">>>,>>>,>>>,>>9.99"))).
	   oTable:AddCell("  ").        

oTpl:addAnchorValue("TABLE1",oTable).
oTpl:addAnchorValue("Date",end-date).

MESSAGE d1 - TIME VIEW-AS ALERT-BOX.
{setdest.i &cols=140}

oTpl:show().

{preview.i}


DELETE OBJECT oFunc.
DELETE OBJECT oTable.
DELETE OBJECT oTpl.