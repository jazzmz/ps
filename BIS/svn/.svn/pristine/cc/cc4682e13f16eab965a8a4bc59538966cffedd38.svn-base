/*Распоряжение по завявке №1842
Автор: Никитина Ю.А.           
Заказчик: Агабекян В.В.
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
def var proc_oplat as decimal INIT 0 NO-UNDO.
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
DEF BUFFER bLoan-Int FOR loan-int.
DEF VAR mUpd as LOGICAL NO-UNDO.

{getdates.i}
{setdest.i &cols=220} /* Вывод в preview */
oTpl = new TTpl("pirloan1842_1.tpl").
oTable = new TTable(10).

FOR EACH tmprecid,
    FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK,
    FIRST op-entry OF op NO-LOCK:
    /* Найдем информацию о договоре */

    ASSIGN
        acct_rsrv = op-entry.acct-db.

    if acct_rsrv begins "9" then bal_unbal = "внебалансовых". else bal_unbal = "балансовых".
    FIND LAST bfrLA WHERE bfrLA.acct = acct_rsrv AND bfrLA.contract EQ "Кредит" NO-LOCK NO-ERROR.
    IF AVAIL bfrLA THEN DO:     
		FIND LAST loan WHERE loan.contract  = bfrLA.contract 
        		AND loan.cont-code = bfrLA.cont-code
			NO-LOCK NO-ERROR.   
		IF AVAIL loan THEN DO:                                       

		        /* Смотрим дату пересчета договора. И говорим пользователю, если договор не пересчитать на один день вперед, чтобы появились нужные параметры учета процентов */
		        if loan.since <= op.op-date then do:
				message "Пересчитайте договор на дату " (op.op-date + 1) ". ~n Без пересчета возможно будут неправильные цифры в распоряжении. ~n Все равно печатать?"		 
				   VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mUpd.
				IF mUpd EQ ? or mUpd eq NO THEN
                                RETURN.
			end.

			client_name = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", false).
                        loaninf = getMainLoanAttr("Кредит",loan.cont-code,"%cont-code от %ДатаСогл").
			dbeg = beg-date.
			dend = end-date.
			
			{get_meth.i 'NachProc' 'nach-pp'}
                        {empty otch1}                         
                        {ch_dat_p.i}
			
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

			if countOtch > 1 then do:
				{wordwrap.i &s=str &l=25 &n=31}
        	        end.
                        i = 0.
         		FOR EACH otch1,
				FIRST loan-par WHERE TRIM(loan-par.name) EQ TRIM(ENTRY(1,otch1.comment)) 
			   		         AND CAN-DO("8",STRING(loan-par.amt-id)) NO-LOCK:
				i = i + 1.
                                /* message dbeg dend VIEW-AS ALERT-BOX.*/
                                oTable:addRow().
                                if i = 1 then do:
					counter = counter + 1.
					oTable:addCell(counter). 
                                end.	
				else do:
				        oTable:addCell(" ").                      	
/*  						if i <> countOtch then*/ 
					oTable:setBorder(1,oTable:height,1,0,0,1).
				end.

                                IF i = 1 then oTable:addCell(client_name + " " + loaninf).
                                ELSE oTable:addCell(" ").

				if i <> 1 then oTable:setBorder(2,oTable:height,1,0,0,1).
                                oTable:addCell(STRING(otch1.bal-sum,">>>,>>>,>>>,>>9.99")).
                                oTable:addCell(otch1.beg-date).
                                oTable:addCell(otch1.end-date).
                                oTable:addCell(STRING(otch1.summ_pr,">>>,>>>,>>>,>>9.99")).
				total_summ = total_summ + otch1.summ_pr.
                                oTable:addCell(STRING(otch1.rat1) + "%").
                                oTable:addCell(if loan.currency eq "" then "810" else loan.currency).
				if i = 1 then do:
					oTable:addCell(op-entry.acct-db).
					oTable:addCell(op-entry.acct-cr).
				end.
				else do:
 				       oTable:addCell(" ").
				       oTable:addCell(" ").
				       oTable:setBorder(9,oTable:height,1,0,0,1).
	                               oTable:setBorder(10,oTable:height,1,0,1,1).	
				end.


			END.

                        /* Проверяем наличие оплаченных процентов, но не факт, что это проценты за этот месяц */
			for each loan-int where loan-int.cont-code = loan.cont-code
			    	        	and loan-int.contract = loan.contract
  			 		        and loan-int.mdate >= dbeg 
			  		        and loan-int.mdate <= dend 
						and ((loan-int.id-d = 26) and (loan-int.id-k = 8)) /* НАЧ=26 И СП=8 ЭТО ОПЕРАЦИЯ 126 */
						NO-LOCK :
				/* Если есть такая же операция на параметре 280, то значит это оплата процентов за предыдущий месяц */
        			find first bloan-int where bloan-int.cont-code = loan.cont-code
        			    	        	and bloan-int.contract = loan.contract
          			 		        and bloan-int.mdate = loan-int.mdate 
							and bloan-int.amt-rub = loan-int.amt-rub
        						and ((bloan-int.id-d = 8) and (bloan-int.id-k = 229)) /* НАЧ=8 И СП=229 ЭТО ОПЕРАЦИЯ 280 */
        						NO-LOCK NO-ERROR.
        			if not avail bloan-int then proc_oplat = proc_oplat + loan-int.amt-rub.
			end.
/*   dNachProc = (ACCUM TOTAL otch1.summ_pr).      */
		END. /* Если найден договор */
   END.  /* Конец если найден loan-acct */
   oTpl:addAnchorValue("Date",op.op-date).
END. /* Конец по всем документам */

oTpl:addAnchorValue("TABLE1",oTable).
oTpl:addAnchorValue("BAL/UNBAL",bal_unbal).
oTpl:addAnchorValue("total_summ",STRING(total_summ,">>>,>>>,>>>,>>9.99")).
oTpl:addAnchorValue("proc_oplat",STRING(proc_oplat,">>>,>>>,>>>,>>9.99")).
oTpl:addAnchorValue("itogo",STRING(total_summ - proc_oplat,">>>,>>>,>>>,>>9.99")).

{setdest.i}
    oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
DELETE OBJECT oSysClass.