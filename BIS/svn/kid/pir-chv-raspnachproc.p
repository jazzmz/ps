{globals.i}
{tmprecid.def}
{ulib.i}
{getdate.i}
{dpsproc.def}

DEF VAR monthss AS CHAR NO-UNDO 
	INITIAL "январь,февраль,март,апрель,май,июнь,июль,август,сентябрь,октябрь,ноябрь,декабрь".


DEF VAR oTpl AS TTpl.
DEF VAR oTable AS TTable.
def var oAcct as TAcct.


def var cName as CHAR.
def var cAcct As CHAR.

def var i as Int.



def var dBegDate AS DATE.
def var dEndDate AS DATE.
def var dat_start AS DATE.
def var date_start AS DATE.
def var d as date.
def var period-beg-date as date.

def var rate as decimal.
def var summ_proc as decimal.
def var ostatok as decimal.
def var prevbalance as decimal.
def var nextbalance as decimal.
def var tempProc as decimal.
def var balance as decimal.


def var basa as integer.


def var itog as decimal.

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */


oTable = new  TTable(11).


def var cur_year as integer.

cur_year = YEAR(end-date).
if TRUNCATE(cur_year / 4,0) = cur_year / 4 then
	basa = 366.
else
	basa = 365.

for each op where op.op-date = end-date NO-LOCK,
    first op-entry where op-entry.op = op.op and op-entry.acct-db begins "70606" and (/*op-entry.acct-cr begins "47426" or*/ op-entry.acct-cr begins "47411") and currency = "".
    vLnTotalInt = vLnTotalInt + 1.
end.
/*    message vLnTotalInt VIEW-AS ALERT-BOX.*/

for each op where op.op-date = end-date NO-LOCK,
    first op-entry where op-entry.op = op.op and op-entry.acct-db begins "70606" and (/*op-entry.acct-cr begins "47426" or */op-entry.acct-cr begins "47411") and currency = "".

         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }


    find first loan-acct where loan-acct.acct = op-entry.acct-cr NO-LOCK NO-ERROR.
    if AVAILABLE(loan-acct) then 
       do:
          find first loan where (loan.cont-code = loan-acct.cont-code) and (loan.contract = loan-acct.contract) and can-do("Сро*",loan.cont-type) NO-LOCK NO-ERROR.
          if AVAILABLE(loan) then 
             do:

              dEndDate = op.op-date.

/*		if loan.cont-code = "42304810000001736078" then message loan.cont-code VIEW-AS ALERT-BOX.*/
                if loan.cust-cat = "Ч" then 
                   do:
                     find first person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.
                     cName = person.name-last + " " + person.first-names.
                     cAcct = loan.cont-code.


			 /*------------ определении даты начисления процентов ------------*/

			    FIND LAST loan-cond WHERE
			              loan-cond.contract  EQ loan.contract
			          AND loan-cond.cont-code EQ loan.cont-code
			          AND loan-cond.since     LE end-date
			    NO-LOCK NO-ERROR.

			    IF AVAIL loan-cond THEN DO:
			       /*вычисляем СРАЗУ реальную дату начисления %%*/
			       RUN DateOfCharge IN h_dpspc ((Date(Month(op.op-date) - 1,Month(op.op-date),YEAR(op.op-date))), RECID(loan-cond), OUTPUT dat_start).
			       IF dat_start NE ? THEN DO:
			          /*если есть проблемы с выходными (в эту дату нельзя начислять) */
			          IF NOT chk_date(recid(loan-cond), dat_start) THEN DO:
			             REPEAT i = 0 TO 30:
			                IF chk_date(RECID(loan-cond), dat_start + i ) THEN
			                LEAVE.
			                HIDE MESSAGE NO-PAUSE .
			             END.
			             dat_start = dat_start + i.
			          END.
			       END.
			       IF dat_start NE ? THEN DO:
			          date_start = dat_start + 1 . 
			       END.
			    END.
			   
                          if date_start < dEndDate then do:
                             dBegDate = MAX(loan.open-date + 1,date_start,DATE(MONTH(op.op-date),01,YEAR(op.op-date))).
                           end.
			   else
                             dBegDate = MAX(loan.open-date + 1,DATE(MONTH(op.op-date),01,YEAR(op.op-date))).
			
   			 /*---------------------------------------------------------------*/

   			  
                   end.



             	       oAcct = new TAcct(cAcct).

      	           /* Здесь определям ставку по договору*/
      	           rate = 0.
                   Rate = GetDpsCommission_ULL(Loan.cont-code, "commission", denddate, false).
		     summ_proc = op-entry.amt-rub.	

                     ostatok = oAcct:GetLastPos2Date(dEndDate).

                   if rate = 0 then rate = 365 * (summ_proc)/(ostatok * (dEndDate - dBegDate + 1)).
                   /* Получили переменную Rate*/


         	       

         	/* Здесь ищем было ли движение по счету за период от dBegdate до dEndDate */
		       date_start = dBegDate.

         	   if oAcct:HasMove(dBegdate,dEndDate,"*") then
                      do:
	
                       prevbalance = oAcct:GetLastPos2Date(dBegDate).
                       do d = dBegDate to dEndDate :
			      nextbalance = oAcct:GetLastPos2Date(d).
			      if nextbalance <> prevbalance then
				 do:
/*     			             message loan.cont-code VIEW-AS ALERT-BOX.*/
 		                    tempProc = (prevbalance * (d - date_start) * rate) / basa.
 		                    summ_proc = summ_proc - tempProc.
                                    oTable:addRow().
 			            oTable:addCell(loan.cont-code).                    /*Номер вклада*/
                		    oTable:addCell(cName).                             /*Клиент*/
			            oTable:addCell(date_start).                          /*Дата С*/
		                    oTable:addCell(d - 1).                          /*Дата ПО*/
		                    oTable:addCell(d - date_start).           /*Количество дней*/
		                    oTable:addCell(prevbalance).  /*Остаток на счете*/
		                    oTable:addCell(round(rate * 100,2)).                              /*Ставка*/
		                    oTable:addCell(round(tempProc,2)).                  /*Начислено%*/
	  	                    oTable:addCell(round(summ_proc,2)).                  /*Итого%*/ 
	  	                    oTable:addCell(" ").                  /*Счет по дебету*/
	    	                    oTable:addCell(" ").                  /*Счет по кредиту*/          
 		                    prevbalance = nextbalance.
 		                    date_start = d.

				 end.
                           END.
			
                      end.

                /*потом выводим итог по клиенту  */
                       DELETE OBJECT oAcct.

                oTable:addRow().
                oTable:addCell(loan.cont-code).                    /*Номер вклада*/
                oTable:addCell(cName).                             /*Клиент*/
                oTable:addCell(date_start).                          /*Дата С*/
                oTable:addCell(dEndDate).                          /*Дата ПО*/
                oTable:addCell(dEndDate - date_start + 1).           /*Количество дней*/
                oTable:addCell(ostatok).  /*Остаток на счете*/
                oTable:addCell(round(rate * 100,2)).                              /*Ставка*/
                oTable:addCell(round(summ_proc,2)).                  /*Начислено%*/
                oTable:addCell(op-entry.amt-rub).                  /*Итого%*/ 
                oTable:addCell(op-entry.acct-db).                  /*Счет по дебету*/
                oTable:addCell(op-entry.acct-cr).                  /*Счет по кредиту*/          
		itog = itog + op-entry.amt-rub.                                                    
            end.
       end.

           vLnCountInt = vLnCountInt + 1.

end.

                oTable:addRow().
                oTable:addCell(" ").                    /*Номер вклада*/
                oTable:addCell(" ").                             /*Клиент*/
                oTable:addCell(" ").                          /*Дата С*/
                oTable:addCell(" ").                          /*Дата ПО*/
                oTable:addCell(" ").           /*Количество дней*/
                oTable:addCell(" ").  /*Остаток на счете*/
                oTable:addCell(" ").                              /*Ставка*/
                oTable:addCell(" ").                  /*Начислено%*/
                oTable:addCell(Itog).                  /*Итого%*/ 
                oTable:addCell(" ").                  /*Счет по дебету*/
                oTable:addCell(" ").                  /*Счет по кредиту*/



oTpl = new TTpl("pir-chv-raspnachproc.tpl").

oTpl:addAnchorValue("Month",ENTRY(MONTH(end-date),monthss)).
oTpl:addAnchorValue("date",end-date).
oTpl:addAnchorValue("TABLE1",oTable).

{setdest.i}
oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.