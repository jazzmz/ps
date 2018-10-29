/*Распоряжение по завявке №900
Автор: Красков А.С.           
Заказчик: Бажинова О.Ю.
Процедура формирует распоряжение по начисленнию процентов по кредитным договорам, запускается из браузера документов */

{date.fun}
{intrface.get date}

{globals.i} /* Подключяем глобалные настройки*/
{ulib.i}    /* Библиотека функций для работы со счетами */
{tmprecid.def}
{sh-defs.i}
{wordwrap.def}

{t-otch.i new}

 
DEF VAR oTable    AS TTable    NO-UNDO.
DEF VAR oSysClass AS TSysClass NO-UNDO.
def var str as char EXTENT 31 NO-UNDO.
def var countOtch as integer NO-UNDO.
def var i as integer NO-UNDO.

def var total_summ as decimal INIT 0 NO-UNDO.

DEF VAR dat-per AS DATE NO-UNDO.	/* Дата перехода на 39-П */




oSysClass = new TSysClass().

DEF BUFFER bOpEntry FOR op-entry.
DEF BUFFER bTerm-Obl FOR Term-Obl.

DEF VAR oTpl AS TTpl NO-UNDO.

DEF VAR traceOn     AS LOGICAL INITIAL false NO-UNDO. /* Вывод ошибок на экран */
DEF VAR client_name AS CHARACTER INITIAL ""  NO-UNDO.
DEF VAR acct_rsrv   AS CHARACTER INITIAL ""  NO-UNDO.
DEF VAR comType     AS CHARACTER	     NO-UNDO.

def var loaninf as CHAR NO-UNDO.

DEF VAR dbeg  AS DATE NO-UNDO.
DEF VAR dend  AS DATE NO-UNDO.
DEF VAR dMbeg AS DATE NO-UNDO.
DEF VAR dMend AS DATE NO-UNDO.

def var bal_unbal as CHAR NO-UNDO.

DEF VAR proc-name     AS CHARACTER NO-UNDO.

def var counter as INT INIT 0 NO-UNDO.

DEF BUFFER bfrLA FOR loan-acct.

{setdest.i &cols=220} /* Вывод в preview */
oTpl = new TTpl("pirloan900_1.tpl").
oTable = new TTable(10).

    FOR EACH tmprecid,
     FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK,
        FIRST op-entry OF op NO-LOCK:
         /* Найдем информацию о договоре */

/*   IF op-entry.acct-db BEGINS "4" THEN */
      ASSIGN
         acct_rsrv = op-entry.acct-db
      .
/*   IF op-entry.acct-cr BEGINS "4" THEN
      ASSIGN
         acct_rsrv = op-entry.acct-cr
     .*/


if acct_rsrv begins "9" then bal_unbal = "внебалансовых". else bal_unbal = "балансовых".

      FIND LAST bfrLA WHERE bfrLA.acct = acct_rsrv AND bfrLA.contract EQ "Кредит" NO-LOCK NO-ERROR.
    
       IF AVAIL bfrLA THEN 
            DO:     
                   FIND LAST loan WHERE loan.contract  = bfrLA.contract 
                                                                AND loan.cont-code = bfrLA.cont-code
                                                                NO-LOCK NO-ERROR.   
                      IF AVAIL loan THEN 
                            DO:                                       


                                       FIND FIRST bOpEntry WHERE bOpEntry.op-date<op-entry.op-date AND bOpEntry.acct-db = acct_rsrv AND MONTH(bOpEntry.op-date) = MONTH(op-entry.op-date) NO-LOCK NO-ERROR.           

                                        /* Проверяем наличие начисления наращенных % или оплату процентов */

					  find last loan-int
						where loan-int.cont-code = loan.cont-code
				    	          and loan-int.contract = loan.contract
  			 		          and loan-int.mdate >= loan.open-date 
			  		          and loan-int.mdate < op-entry.op-date 
						  and (((loan-int.id-d = 6) and (loan-int.id-k = 4)) /* НАЧ=6 И СП=4 ЭТО ОПЕРАЦИЯ 9 */
						  or ((loan-int.id-d = 32) and (loan-int.id-k = 4)))
						NO-LOCK NO-ERROR.


                                        IF AVAILABLE(loan-int) THEN dbeg = loan-int.mdate + 1.
                                                               ELSE 
                                         dbeg = MAX(FirstMonDate(op.op-date),Date(oSysClass:str2Date(GetLoanInfo_ULL(loan.contract,loan.cont-code,"open_date",false),"%dd.%mm.%yyyy")) + 1).

                                         find last loan-acct where loan-acct.contract = loan.contract 
							       and loan-acct.acct-type = "Кредит" 
							       and loan-acct.since <= dend 
							       and loan-acct.cont-code = loan.cont-code	NO-LOCK NO-ERROR.



                                            dend = MIN(oSysClass:str2Date(GetLoanInfo_ULL(loan.contract,loan.cont-code,"end_date",false),"%dd.%mm.%yyyy"),LastMonDate(op.op-date)).

                                            FIND LAST bTerm-Obl WHERE bTerm-Obl.cont-code=loan.cont-code and bTerm-Obl.amt-rub <> 0 NO-LOCK NO-ERROR.
				            client_name = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", false).
                          	            loaninf = getMainLoanAttr("Кредит",loan.cont-code,"%cont-code от %ДатаСогл").



                                            counter = counter + 1.


					    {get_meth.i 'NachProc' 'nach-pp'}

					    {empty otch1}                         
                                            {ch_dat_p.i}
                                        /*    message dbeg dend VIEW-AS ALERT-BOX.   */


					    run VALUE(proc-name + ".p") (loan.contract,
									 loan.cont-code,
							                 dbeg,
							                 dend,
							                 dat-per,                               		
								         ?,
							                 1).


                                            countOtch = 0.

				 	    for each otch1 NO-LOCK:
                                                countOtch = countOtch + 1.
					    end.
                                            str[1] = client_name + " " + loaninf.

					    if countOtch > 1 then 
						do:

						{wordwrap.i &s=str &l=25 &n=31}

					        end.
                                                 i = 0.

					      FOR EACH otch1,
						 FIRST loan-par WHERE TRIM(loan-par.name) EQ TRIM(ENTRY(1,otch1.comment)) 
			   		         AND CAN-DO("4",STRING(loan-par.amt-id)) NO-LOCK:
                                                   i = i + 1.

/*               					    message dbeg dend VIEW-AS ALERT-BOX.*/

                                            oTable:addRow().
                                            if i = 1 then 
			                     do:
						oTable:addCell(counter). 

					     end.	
					     else 
 					    do:
  					        oTable:addCell(" ").                      	
/*  						if i <> countOtch then*/ oTable:setBorder(1,oTable:height,1,0,0,1).
					    end.
                                            oTable:addCell(str[i]).
					    if i <> 1 then oTable:setBorder(2,oTable:height,1,0,0,1).
                                            oTable:addCell(STRING(otch1.bal-sum,">>>,>>>,>>>,>>9.99")).
                                            oTable:addCell(otch1.beg-date).
                                            oTable:addCell(otch1.end-date).
                                            oTable:addCell(otch1.summ_pr).
					    total_summ = total_summ + otch1.summ_pr.
                                            oTable:addCell(STRING(otch1.rat1) + "%").
                                            oTable:addCell(loan.currency
).
                                            if i = 1 then 
					    do:
					       oTable:addCell(op-entry.acct-db).
		                               oTable:addCell(op-entry.acct-cr).
					    end.
					    else 
					    do:
 					       oTable:addCell(" ").
					       oTable:addCell(" ").
					       oTable:setBorder(9,oTable:height,1,0,0,1).
	                                       oTable:setBorder(10,oTable:height,1,0,1,1).	
					    end.


 	   					END.

/*   dNachProc = (ACCUM TOTAL otch1.summ_pr).      */





                          END. /* Если найден договор */
              END.  /* Конец если найден loan-acct */
   oTpl:addAnchorValue("Date",op.op-date).
END. /* Конец по всем документам */

oTable:addRow().
oTable:addCell(" "). 
oTable:addCell(" "). 
oTable:addCell(" "). 
oTable:addCell(" "). 
oTable:addCell(" "). 
oTable:addCell(total_summ). 
oTable:addCell(" "). 
oTable:addCell(" "). 
oTable:addCell(" "). 
oTable:addCell(" "). 



oTpl:addAnchorValue("TABLE1",oTable).
oTpl:addAnchorValue("BAL/UNBAL",bal_unbal).

{setdest.i}
    oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
DELETE OBJECT oSysClass.