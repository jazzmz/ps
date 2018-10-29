/*Процедура для поиска налоговой преммии по ОС
заявка 957 */
{globals.i}

{tmprecid.def}

{sh-defs.i}

def var oTable as TTable.
DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */
DEF VAR count AS INTEGER INIT 0 NO-UNDO.
def var ddate as date NO-UNDO.
DEF VAR mRoleSfx     AS CHAR    NO-UNDO INIT "-нал-амор". /*на счетах с таким хвостом роли начислена амортизация*/

DEF VAR mRoleSfx2    AS CHAR    NO-UNDO INIT "-нал-учет". /*на счетах с таких хвостом роли начислена "первоначальная стоимоть ОС"*/

DEF VAR dBegDate as Date NO-UNDO. /*дата начала периода в котором ищем изменения первоначальной стоимости*/

def var dIzmStoimost as Decimal NO-UNDO.
def var mPremia as Decimal NO-UNDO.
def var mPremia10 as Decimal NO-UNDO INIT 0.
def var mPremia30 as Decimal NO-UNDO INIT 0.
def buffer bfrloan-acct for loan-acct.

def var tempdate as date no-undo. 

def temp-table tPremia NO-UNDO
	field since as date
	field Premia as dec
	INDEX since IS PRIMARY since
	INDEX Premia Premia.




oTable = new TTable(7).

oTable:colsWidthList="4,10,12,12,13,13,13".

oTable:addRow().
oTable:addCell("").
oTable:addCell("Номер карточки ОС").
oTable:addCell("Дата").
oTable:addCell("Первоначальная стоимость").
oTable:addCell("Модернизация").
oTable:addCell("Премия 10%").
oTable:addCell("Премия 30%").
oTable:SetAlign(1,1,"Center").
oTable:SetAlign(2,1,"Center").
oTable:SetAlign(3,1,"Center").
oTable:SetAlign(4,1,"Center").
oTable:SetAlign(5,1,"Center").
oTable:SetAlign(6,1,"Center").
oTable:SetAlign(7,1,"Center").




{getdate.i}
ddate = end-date.
{init-bar.i "Обработка договоров"}

for each tmprecid, first loan where RECID(loan) EQ tmprecid.id NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.
end.


for each tmprecid, first loan where RECID(loan) EQ tmprecid.id NO-LOCK
BY loan.cont-code :

         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }




		   FOR EACH  loan-acct      WHERE
		             loan-acct.contract  = loan.contract
		         AND loan-acct.cont-code = loan.cont-code
		         AND loan-acct.acct-type = loan.contract + mRoleSfx
		         AND loan-acct.since    <= dDate
		         NO-LOCK,
                         LAST  acct           WHERE
                               acct.acct           = loan-acct.acct
                           AND acct.currency       = loan-acct.currency
                         NO-LOCK:


		        FOR EACH op-entry       WHERE
	        	         (op-entry.acct-db    = loan-acct.acct               AND
		                  op-entry.op-date   >= loan-acct.since             AND
		                  op-entry.op-date   <= dDate                       AND
	        	          acct.side           = "А"
		                 )
	        	      OR (op-entry.acct-cr    = loan-acct.acct            AND
	                	  op-entry.op-date   >= loan-acct.since           AND
		                  op-entry.op-date   <= dDate                       AND
		                  acct.side           = "П"
		                 )   
		            NO-LOCK,
 
		            FIRST op OF op-entry WHERE 
		               (op.op-kind begins '5002n0')
		            or (op.op-kind begins '5001b+')
		            or (op.op-kind begins '7012b2t')
               
		            NO-LOCK:
                                       DO: 

					       CREATE tPremia.
					       ASSIGN 

						      tPremia.Premia = op-entry.amt-rub
                                                      tPremia.since = op.op-date.
	
                                       END.
                                         
		        END. /*for each op-entry*/        


                   find last bfrloan-acct WHERE 
		             bfrloan-acct.contract  = loan.contract
		         AND bfrloan-acct.cont-code = loan.cont-code
		         AND bfrloan-acct.acct-type = loan.contract + mRoleSfx2
		         AND bfrloan-acct.since    <= dDate
		         NO-LOCK NO-ERROR.

		   if available (loan-acct) then do:

		     for each tpremia:       /*если была премия, значит было изменение первоначальной стоимости, значит смотрим все изменения за прошлый и текущий месяц*/

		         if Month(tpremia.since) > 1 then dbegDate = DATE(MONTH(tpremia.since) - 1,01,YEAR(tpremia.since)). /*считаем что премию нельзя начислить за ОС полученое в прошлом году*/
                          dIzmStoimost = 0.
		         for each op-entry where 
			          op-entry.acct-db = bfrloan-acct.acct
			      and op-entry.currency = bfrloan-acct.currency
			      and op-entry.op-date >= dBegDate
	                      and op-entry.op-date <= tpremia.since
			      NO-LOCK:
                                      dIzmStoimost = dIzmStoimost + op-entry.amt-rub. /*считаем все изменения первоначальной стоимости за период*/
				      tempDate = op-entry.op-date.
			      end.

                              RUN acct-pos IN h_base (bfrloan-acct.acct,
                              bfrloan-acct.currency,
                              dbegDate,
                              dbegDate,
                              ?).


                         mPremia = tpremia.Premia.


                         if loan.cont-code = "3/14/156" and dDate >= 12/31/2011 then  /*небольшой костыль для ОС по которому неправильно списали премию и потом переделали в конце года*/
                	    do:

       	                     mPremia = mPremia +  17467.00.
		
 	                    end.
                           mPremia10 = 0.
                           mPremia30 = 0.
                          IF ABS(mPremia - (dIzmStoimost / 10)) < 1 THEN mPremia10 = mPremia .
                          IF ABS(mPremia - (30 * dIzmStoimost / 100)) < 1 THEN mPremia30 =  mPremia .        
                        count = count + 1.

			oTable:addRow().
			oTable:addCell(count).
			oTable:addCell(loan.cont-code).
			oTable:addCell(tempDate).
			if sh-in-bal = 0 then do: oTable:addCell(TRIM(STRING(dIzmStoimost,">>>,>>>,>>>,>>9.99"))).
					          oTable:addCell("0.00").
 				         end. else
					      do: oTable:addCell(TRIM(STRING(sh-in-bal,">>>,>>>,>>>,>>9.99"))).
					          oTable:addCell(TRIM(STRING(dIzmStoimost,">>>,>>>,>>>,>>9.99"))).	
					      end.	
			oTable:addCell(TRIM(STRING(mPremia10,">>>,>>>,>>>,>>9.99"))).
			oTable:addCell(TRIM(STRING(mPremia30,">>>,>>>,>>>,>>9.99"))).


		     end.

                     end.    
EMPTY TEMP-TABLE tpremia.

                end.


 vLnCountInt = vLnCountInt + 1.


END.


{setdest.i}
oTable:show().
{preview.i}

DELETE OBJECT oTable.
