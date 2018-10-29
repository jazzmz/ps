/*Ведомость по заявке #792
запускается из браузера документов ЧВ
Заказчик: Балан С.
Автор: Красков А.
*/

{globals.i}
{tmprecid.def}
{ulib.i}
{getdate.i}
{dpsproc.def}
{sh-defs.i}
{intrface.get instrum}
{intrface.get count}


DEF INPUT PARAMETER cur AS CHAR NO-UNDO.

DEF VAR monthss AS CHAR NO-UNDO 
	INITIAL "ЯНВАРЬ,ФЕВРАЛЬ,МАРТ,АПРЕЛЬ,МАЙ,ИЮНЬ,ИЮЛЬ,АВГУСТ,СЕНТЯБРЬ,ОКТЯБРЬ,НОЯБРЬ,ДЕКАБРЬ".


DEF VAR oTpl AS TTpl NO-UNDO.
DEF VAR oTable AS TTable NO-UNDO.
def var oAcct as TAcct NO-UNDO.

def var lastdate as date NO-UNDO.

def var cName as CHAR NO-UNDO.
def var cAcct As CHAR NO-UNDO.
def var cLoan as CHAR NO-UNDO.
def var i as Int NO-UNDO.



def var dBegDate AS DATE NO-UNDO.
def var dEndDate AS DATE NO-UNDO.
def var dat_start AS DATE NO-UNDO.
def var date_start AS DATE NO-UNDO.
def var d as date NO-UNDO.
def var period-beg-date as date NO-UNDO.

def var rate as decimal NO-UNDO.
def var summ_proc as decimal NO-UNDO.
def var ostatok as decimal NO-UNDO.
def var prevbalance as decimal NO-UNDO.
def var nextbalance as decimal NO-UNDO.
def var tempProc as decimal NO-UNDO.
def var tempsummProc as decimal NO-UNDO.
def var tempsummProcEkv as decimal NO-UNDO.
def var balance as decimal NO-UNDO.


def var basa as integer NO-UNDO.


def var itog as decimal NO-UNDO.

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */
def buffer bfOp for op.
def buffer bfOp-entry for op-entry.

oTable = new  TTable(12).


def var cur_year as integer NO-UNDO.




cur_year = YEAR(end-date).
if TRUNCATE(cur_year / 4,0) = cur_year / 4 then
	basa = 366.
else
	basa = 365.
for each tmprecid.
for each op where RECID(op) = tmprecid.id  NO-LOCK,
    first op-entry where op-entry.op = op.op and op-entry.acct-db begins "70606" and (/*op-entry.acct-cr begins "47426" or*/ op-entry.acct-cr begins "47411") and CAN-DO(cur,op-entry.currency).
    vLnTotalInt = vLnTotalInt + 1.
end.
end.

for each tmprecid.
for each op where RECID(op) = tmprecid.id NO-LOCK,
    first op-entry where op-entry.op = op.op and op-entry.acct-db begins "70606" and (/*op-entry.acct-cr begins "47426" or */op-entry.acct-cr begins "47411") and CAN-DO(cur,op-entry.currency).

         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }


    find first loan-acct where loan-acct.acct = op-entry.acct-cr NO-LOCK NO-ERROR.
    if AVAILABLE(loan-acct) then 
       do:
          find first loan where (loan.cont-code = loan-acct.cont-code) and (loan.contract = loan-acct.contract) /* and can-do("Сро*,ДВ*",loan.cont-type)*/ NO-LOCK NO-ERROR.
          if AVAILABLE(loan) then 
             do:
              
              if month(end-date) <> 12 then lastdate = DATE(MONTH(op.op-date) + 1,01,YEAR(op.op-date)) - 1. else lastdate = DATE(12,31,YEAR(op.op-date)).

/*              message DATE(MONTH(op.op-date) + 1,01,YEAR(op.op-date)) - 1 VIEW-AS ALERT-BOX.*/
              dEndDate = MAXIMUM (op.op-date,lastdate).




                if loan.cust-cat = "Ч" then 
                   do:
                     find first person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.
                     cName = person.name-last + " " + person.first-names.
                     cAcct = loan.cont-code.

			 /*------------ определении даты начисления процентов ------------*/
               
			    FIND LAST loan-cond WHERE
			              loan-cond.contract  EQ loan.contract
			          AND loan-cond.cont-code EQ loan.cont-code
			          AND loan-cond.since     LE dEndDate
			    NO-LOCK NO-ERROR.

			    IF AVAIL loan-cond THEN DO:
			       /*вычисляем СРАЗУ реальную дату начисления %%*/

/*			       RUN DateOfCharge IN h_dpspc ((Date(Month(op.op-date),01,YEAR(op.op-date))), RECID(loan-cond), OUTPUT dat_start).

			       message dat_start VIEW-AS ALERT-BOX.
			       find last kau-entry where kau-entry.acct = op-entry.acct-cr and kau-entry.op-date <= dat_start and kau-entry.debit = yes NO-LOCK NO-ERROR.
                               if available (kau-entry) then 
				  do:
				     find last bfop where kau-entry.op = bfop.op and kau-entry.op-date = bfop.op-date and bfop.contract-date = dat_start NO-LOCK NO-ERROR.
				     if available bfop then 
					do:
        			             find last kau-entry where kau-entry.acct = op-entry.acct-cr and kau-entry.op-date <= dat_start and kau-entry.debit = no NO-LOCK NO-ERROR.
  				             if available (kau-entry) then 
						do:
  	 	 		                find last bfop where kau-entry.op = bfop.op and kau-entry.op-date = bfop.op-date NO-LOCK NO-ERROR.
						if available (kau-entry) then 
						dat_start = bfop.contract-date.
						end.
					end.                                              
 		  	          end. */
/* переделем поиск даты начисление на следующий метод: ищем последнюю проводку по счету на который начисляются проценты, и берем с неё плановую дату */

find last bfop-entry where bfop-entry.acct-cr = op-entry.acct-cr 
		       and bfop-entry.op-date < op-entry.op-date 
		       and ((bfop-entry.kau-cr <> "" and bfop-entry.kau-cr <> ?)
		       or (bfop-entry.kau-db <> "" and bfop-entry.kau-db <> ?))	
			NO-LOCK NO-ERROR.

					if available bfop-entry then 
					   do:
						find last bfop where bfop.op = bfop-entry.op NO-LOCK NO-ERROR.
						dat_start = bfop.contract-date.
					   end.
					else
						dat_start = DATE(MONTH(op.op-date),01,YEAR(op.op-date)).




			    
/*			       IF dat_start NE ? THEN DO:
			          /*если есть проблемы с выходными (в эту дату нельзя начислять) */

			          IF NOT chk_date(RECID(loan-cond), dat_start) THEN DO:
			             REPEAT i = 0 TO 30:
			                IF chk_date(RECID(loan-cond), dat_start + i ) THEN
			                LEAVE.
			                HIDE MESSAGE NO-PAUSE .
			             END.
			             dat_start = dat_start + i.
			          END.
			       END.           */

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
                    if op-entry.currency = "" then 
		     summ_proc = op-entry.amt-rub.	
		   else
		     summ_proc = op-entry.amt-cur.	

                     ostatok = oAcct:GetLastPos2Date(dEndDate).
/*                     if cur <> "" then ostatok = CurToCur("УЧЕТНЫЙ", "", op-entry.currency, op.op-date, ostatok).*/
                                                    
                   if rate = 0 then rate = 365 * (summ_proc)/(ostatok * (dEndDate - dBegDate + 1)).
                   /* Получили переменную Rate*/

/*Для двух вкладов ставка устанавливается индивидуально, т.к. по ним ставка зависит от ставки рефенансирования ЦБ,
 и установленна индивидуально на процедуре расчета, в дальнейшем нужно убрать данную строку и заменить на более корректный поиск ставки */
/*                  if loan.cont-code = "42307810400000735978" or loan.cont-code = "42307810700000735979" then rate = 0.08.*/

         	   delete object oAcct.    

end.                                                                                
               	/* Здесь ищем было ли движение по счету за период от dBegdate до dEndDate */
		       date_start = dBegDate.

                               	       oAcct = new TAcct(cAcct). 

         	   if oAcct:HasMove(dBegdate,dEndDate - 1,"*") then
                      do:
                       tempsummProc = 0.
                       prevbalance = oAcct:GetLastPos2Date(dBegDate - 1).
/*                       if cur <> "" then prevbalance = CurToCur("УЧЕТНЫЙ", "", op-entry.currency, op.op-date, prevbalance).*/

                       do d = dBegDate to dEndDate :
			      nextbalance = oAcct:GetLastPos2Date(d).

/*                              if cur <> "" then nextbalance = CurToCur("УЧЕТНЫЙ", "", op-entry.currency, op.op-date, nextbalance).*/

			      if nextbalance <> prevbalance then
				 do:


 		                    tempProc = (prevbalance * (d - date_start + 1) * rate) / basa.
 		                    tempsummProc = tempsummProc + tempProc.
                                    oTable:addRow().                                              	
 			            oTable:addCell(loan.cont-code).                    /*Номер вклада*/
                		    oTable:addCell(cName).                             /*Клиент*/
			            oTable:addCell(date_start).                          /*Дата С*/
		                    oTable:addCell(d).                          /*Дата ПО*/
		                    oTable:addCell(d - date_start + 1).           /*Количество дней*/
		                    oTable:addCell(prevbalance).  /*Остаток на счете*/
		                    oTable:addCell(TRIM(STRING(round(rate * 100,2),">>>,>>>,>>>,>>9.99"))).                                /*Ставка*/
		                   if tempProc > 0 then oTable:addCell(TRIM(STRING(round(tempProc,2),">>>,>>>,>>>,>>9.99"))). 
				                   else oTable:addCell(TRIM(STRING(round(tempsummProc,2),">>>,>>>,>>>,>>9.99"))).                   /*Начислено%*/
/*	  	                    oTable:addCell(TRIM(STRING(round(tempsummProc,2),">>>,>>>,>>>,>>9.99"))).                    /*Итого%*/ */
                                  if d <> dENDdate then 
				   do:
	  	                    oTable:addCell(" ").                    /*Итого%*/ 
	  	                    oTable:addCell(" ").                    /*Итого%эквивалент*/ 
	  	                    oTable:addCell(" ").                  /*Счет по дебету*/
	    	                    oTable:addCell(" ").                  /*Счет по кредиту*/          
				   end.
				  else 
				   DO:
	  	                    oTable:addCell(TRIM(STRING(round(tempsummProc,2),">>>,>>>,>>>,>>9.99"))).                    /*Итого%*/ 
	  	                   if cur <> "" THEN oTable:addCell(TRIM(STRING(round(op-entry.amt-rub,2),">>>,>>>,>>>,>>9.99"))).                    /*Итого%эквивалент*/ 
							      else oTable:addCell("0.00").                    /*Итого%эквивалент*/ 
	  	                    oTable:addCell(op-entry.acct-db).                  /*Счет по дебету*/
	    	                    oTable:addCell(op-entry.acct-cr).                  /*Счет по кредиту*/          
				   end.
                                                  
 		                    prevbalance = nextbalance.
 		                    date_start = d + 1.

				 end.
                           END.
			
                      end.

                /*потом выводим итог по клиенту  */


                if date_start <= dEndDate then 
		do:
                   oTable:addRow().
                   oTable:addCell(loan.cont-code).                    /*Номер вклада*/
                   oTable:addCell(cName).                             /*Клиент*/
                   oTable:addCell(date_start).                          /*Дата С*/
                   oTable:addCell(dEndDate).                          /*Дата ПО*/
                   oTable:addCell(dEndDate - date_start + 1).           /*Количество дней*/
                   oTable:addCell(ostatok).  /*Остаток на счете*/
                   oTable:addCell(TRIM(STRING(round(rate * 100,2),">>>,>>>,>>>,>>9.99"))).                                /*Ставка*/
                   if summ_proc - tempsummProc > 0 then oTable:addCell(TRIM(STRING(round(summ_proc - tempsummProc,2),">>>,>>>,>>>,>>9.99"))).                  /*Начислено%*/
                                                   else oTable:addCell(TRIM(STRING(round(op-entry.amt-rub,2),">>>,>>>,>>>,>>9.99"))).                  /*Начислено%*/
                   if cur = "" then  oTable:addCell(TRIM(STRING(round(op-entry.amt-rub,2),">>>,>>>,>>>,>>9.99"))).
                   else oTable:addCell(TRIM(STRING(round(op-entry.amt-cur,2),">>>,>>>,>>>,>>9.99"))).                  /*Итого%*/ 
                   if cur <> "" THEN oTable:addCell(TRIM(STRING(round(op-entry.amt-rub,2),">>>,>>>,>>>,>>9.99"))).                    /*Итого%эквивалент*/ 
 	 	 	        else oTable:addCell("0.00").                    /*Итого%эквивалент*/ 
                   oTable:addCell(op-entry.acct-db).                  /*Счет по дебету*/
                   oTable:addCell(op-entry.acct-cr).                  /*Счет по кредиту*/
		   tempsummProc = 0.          
                   if cur <> "" THEN tempsummProcEKV = tempsummProcEKV + op-entry.amt-rub.
		
		end.
                if cur = "" then  
		   itog = itog + op-entry.amt-rub.                                                    
		else
		   itog = itog + op-entry.amt-cur.                                                    

                DELETE OBJECT oAcct.                    
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
                oTable:addCell(TRIM(STRING(round(tempsummProcEKV,2),">>>,>>>,>>>,>>9.99"))).                  /*Итого%екв*/
                oTable:addCell(" ").                  /*Счет по дебету*/
                oTable:addCell(" ").                  /*Счет по кредиту*/


/*message "gfgs" VIEW-AS ALERT-BOX.  */

oTpl = new TTpl("pir-chv-raspnachproc.tpl").

oTpl:addAnchorValue("Month",ENTRY(MONTH(end-date),monthss)).
oTpl:addAnchorValue("date",end-date).
oTpl:addAnchorValue("YEAR",YEAR(end-date)).

oTpl:addAnchorValue("TABLE1",oTable).

&IF DEFINED(arch2)<>0 &THEN
{pir-out2arch.i}
&ENDIF


{setdest.i}
oTpl:show().
{preview.i}

{send2arch.i}


DELETE OBJECT oTable.
DELETE OBJECT oTpl.
{intrface.del}