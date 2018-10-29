/*************************************************************
 *                                                           *                                      
 *                                                           *
 * Процедура формирует распоряжение по начислению дисконта   *     
 *  по собственным векселям                                  *
 *                                                           *
 *                                                           *
 *************************************************************
 * Автор: Красков А.С.                                       *
 * Дата создания: 13.11.2010                                 *
 * заявка №519                                               *
 *************************************************************/

using Progress.Lang.*.
{tmprecid.def}
{globals.i}
{getdate.i}
{ulib.i}    /* Библиотека функций для работы со счетами */
/* переменные для объектов используемых классов*/

DEF VAR oTpl AS TTpl NO-UNDO.
DEF VAR oTacct AS TAcct NO-UNDO.
DEF VAR oTable1 AS TTable NO-UNDO.
DEF VAR oSysClass AS TSysClass NO-UNDO.

DEF BUFFER bLoan FOR Loan.
DEF BUFFER bLoan-int FOR loan-int.
DEF BUFFER bLoan-acct FOR loan-acct.
DEF BUFFER bOp FOR op.
DEF BUFFER bOp-entry FOR op-entry.
DEF BUFFER bAcct FOR acct.
DEF BUFFER bBanks for banks.

DEF VAR traceOn AS LOGICAL INITIAL false NO-UNDO.

DEF VAR dCurrDate AS Date NO-UNDO.
DEF VAR dbeg AS DATE NO-UNDO.
DEF VAR dend AS DATE NO-UNDO.
DEF VAR Name AS Char NO-UNDO.
DEF VAR ItogRub AS Decimal NO-UNDO.
DEF VAR LastBANK AS CHAR INITIAL "" NO-UNDO.

DEF VAR tmpStr AS CHAR NO-UNDO.

oTpl = new TTpl("pir-raspdiscont525.tpl").
oTable1 = new TTable(8).
oSysClass = new TSysClass().

dCurrDate=end-date.
for each tmprecid,
    first  bloan where RECID(bloan) EQ tmprecid.id and bloan.cont-type begins "Векс". /* смотрим все выделенные договора, и отметаем тем которые не относятся к типу "ВексУчт" */
	    if bloan.cust-cat = "Б" then 
		do:
		  find first bBanks where bbanks.bank-id = bloan.cust-id. /* ищем название банка-эмитента */
		  name = bbanks.short-name.
		  if name = ? then message bloan.cust-id view-as alert-box.
		end.
	    if bloan.cust-cat = "Ю" then
		do:
		  find first cust-corp where cust-corp.cust-id = bloan.cust-id NO-LOCK NO-ERROR. 
		  name = cust-corp.name-short.	
		  if name = ? then message bloan.cust-id view-as alert-box.
		end.	 

	    for each bloan-int where bloan-int.cont-code = bloan.cont-code. /*проверяем связанные операции по типу договора "кредит" и направлением платежа 361 */
	        if available(bloan-int) then
			do:
		       	    for each bloan-acct where bloan-acct.cont-code = bloan.cont-code and bloan-acct.acct begins "525". /*смотрим все счета начинающиеся с 525*/
        	            find first bacct where bloan-acct.acct = bacct.acct /*and bacct.details begins "Векс"*/ no-error.
		            if available(bacct) then
				do:		
				    find first bop where bop.op = bloan-int.op no-error.
			            find first bop-entry where bop.op = bop-entry.op and bop-entry.acct-cr = bacct.acct no-lock no-error.
			            if available(bop) and available(bop-entry) then
			              do:
	
			                 dbeg = MAX(FirstMonDate(dCurrDate),Date(oSysClass:str2Date(GetLoanInfo_ULL(bloan.contract,bloan.cont-code,"open_date",false),"%dd.%mm.%yyyy")) + 1).             
			                 dend = MIN(Date(bloan-int.mdate),dCurrDate).
					 dend = dCurrDate.
					 dend = 12/31/11.
			                 if bloan-int.mdate >= dbeg and bloan-int.mdate<=dend then 
		        	           do:
	        		
				              oTable1:addRow().
					      if lastBANK = name then 
						do:						
						   oTable1:addCell(" ").
						   oTable1:setBorder(1,oTable1:height,1,0,0,1).
						end.
					      else	
				                do:
						   oTable1:addCell(name).
						   oTable1:setBorder(1,oTable1:height,1,1,1,1).
						   lastBank = name.
						end.

				              oTable1:addCell(bAcct.details).
	 			              oTable1:addCell(dbeg).
	        			      oTable1:addCell(dend).
	        			      oTable1:addCell(dend - dbeg + 1).
				              oTable1:addCell(bop-entry.amt-cur).
	        			      oTable1:addCell(bop-entry.acct-db).
				              oTable1:addCell(bop-entry.acct-cr).	           
				              itogRub = ItogRub + bop-entry.amt-cur.

	 		                   end.   
			              end.
				end.
		        end.
		    end.
	end.
end.



oTable1:addRow().
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(ItogRub).
oTable1:addCell(" ").
oTable1:addCell(" ").


oTpl:addAnchorValue("TABLE1",oTable1).
oTpl:addAnchorValue("DATE",dCurrDate).
    
{setdest.i}
  oTpl:show().
{preview.i}

DELETE OBJECT oTable1.
DELETE OBJECT oTpl.
DELETE OBJECT oSysclass.