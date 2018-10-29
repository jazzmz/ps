/*************************************************************
 *                                                           *                                      
 *                                                           *
 * Процедура формирует распоряжение на списание процентов    *     
 * отнесенных на доходы будующих периодов                    *
 *                                                           *
 * запускается из браузера документов                        *
 *************************************************************
 * Автор: Красков А.С.                                       *
 * Дата создания: 05.09.2012                                 *
 * заявка №1009                                              *
 *************************************************************/

using Progress.Lang.*.
{globals.i}
               
{tmprecid.def}

{t-otch.i new}

{intrface.get loan}
{intrface.get cust}

{ulib.i}

{pir-getsumbyoper.i}
{get-bankname.i}

{wordwrap.def}


DEF VAR dat-per   AS DATE   NO-UNDO.        /* Дата	на 39-П */ 
def var date-rasp as DATE   NO-UNDO.


def var i          as integer NO-UNDO.

DEF VAR oTpl       AS TTpl   NO-UNDO.
DEF VAR oTable     AS TTable NO-UNDO.
DEF VAR acct_c     AS CHAR NO-UNDO.
DEF VAR acct_proc  AS CHAR NO-UNDO.
DEF vAR cName      AS CHAR NO-UNDO.
DEF VAR dNachProc  AS DECIMAL NO-UNDO.

DEF VAR dOplProc   AS DECIMAL NO-UNDO.

DEF VAR dSpisProc  AS DECIMAL NO-UNDO.
DEF VAR dPerepProc AS DECIMAL NO-UNDO.

def var dSpisProc480 as DECIMAL NO-UNDO.

def var dT1 as dec NO-UNDO.
def var dT2 as dec NO-UNDO.

DEF VAR proc-name AS CHARACTER NO-UNDO.

def var SummaStr as char extent 2 no-undo.

def var maintext as char extent 11 no-undo.

maintext[1] = "В связи с поступлением денежных средств в размере #dOplProc# (#dOplProc_prop#), перечисленных в счет оплаты процентов с #beg-date# по #end-date# по Кредитному договору № #cont-code# от #DateSogl#, подписаному между " + cBankName + " и #cName#, произвести списание суммы превышения в размере #dSpisProc# (#dSpisProc_prop#) со счета #acct_c# " + CHR(34) + "Доходы будущих периодов" + CHR(34) + ".".



for each tmprecid NO-LOCK,
	first loan where RECID(loan) = tmprecid.id NO-LOCK.

        {getdate.i &DateLabel="Введите дату распоряжения"}
        date-rasp = end-date.
        {getdates.i}

	if loan.since <> end-date then 
	  do:
	     message "Договор " Loan.cont-code "не пересчитан на дату" end-date VIEW-AS ALERT-BOX.
	     RETURN.
	  end.

	find last loan-acct where loan-acct.contract = loan.contract
			      and loan-acct.cont-code = loan.cont-code
			      and loan-acct.acct-type = "КредБудПроц"
			      and loan-acct.since <= end-date NO-LOCK.

      	if not available loan-acct then 
		do:
		   message "Не найден счет с ролью КредБудПроц для договора " loan.cont-code VIEW-AS ALERT-BOX.
		   RETURN.
		end. 
        acct_c = loan-acct.acct.

	find last loan-acct where loan-acct.contract = loan.contract
			      and loan-acct.cont-code = loan.cont-code
			      and loan-acct.acct-type = "КредПроц"
			      and loan-acct.since <= end-date NO-LOCK.

      	if not available loan-acct then 
		do:
		   message "Не найден счет с ролью КредПроц для договора " loan.cont-code VIEW-AS ALERT-BOX.
		   RETURN.
		end. 

        acct_proc = loan-acct.acct.

        cName = getPirClName(loan.cust-cat,loan.cust-id).

	oTpl = new TTpl("pirloan1009.tpl").
	oTable = new TTable(6).
	oTable:addRow().
	oTable:addCell("").
	oTable:addCell("С").
	oTable:addCell("По").
	oTable:addCell("").
	oTable:addCell("").
	oTable:addCell("").

   {empty otch1}

   {ch_dat_p.i}


 {get_meth.i 'NachProc' 'nach-pp'}

   run VALUE(proc-name + ".p") (loan.contract,
                 loan.cont-code,
                 beg-date,
                 end-date,
                 dat-per,
	         ?,
                 1).


        FOR EACH otch1,
	 FIRST loan-par WHERE TRIM(loan-par.name) EQ TRIM(ENTRY(1,otch1.comment)) 
		              AND CAN-DO("4",STRING(loan-par.amt-id)) NO-LOCK:

               oTable:addRow().
	       oTable:addCell(otch1.bal-sum).
	       oTable:addCell(otch1.beg-date).
	       oTable:addCell(otch1.end-date).
	       oTable:addCell(otch1.ndays).
	       oTable:addCell(STRING(otch1.rat1) + "%").
	       oTable:addCell(otch1.summ_pr).

               ACCUMULATE otch1.summ_pr (TOTAL).

	END.

   dNachProc  = (ACCUM TOTAL otch1.summ_pr).

/*   dOplProc = getSumByOperNum(loan.cont-code,9,beg-date,end-date).
   if end-date = loan.since then /*если договор пересчитан на дату равную периоду распоряжения (а по другому быть не может) то операции по оплате процентов в дате end-date не созданы :( поэтому придется искать отдельно проводки*/
     do:                            
        for each op-entry where op-entry.op-date = end-date
			    and op-entry.acct-cr = acct_proc
			    and op-entry.kau-cr = loan.contract + "," + loan.cont-code + ",10"
			    NO-LOCK NO-ERROR.
	    dOplProc = dOplProc + op-entry.amt-rub.
	end.	
     end.
         */

   dOplProc = 0.

        for each op-entry where op-entry.op-date >= beg-date
			    and	op-entry.op-date <= end-date
			    and op-entry.acct-cr = acct_proc
			    and op-entry.kau-cr = loan.contract + "," + loan.cont-code + ",10"
			    NO-LOCK.
	    dOplProc = dOplProc + op-entry.amt-rub.
	end.

   


/*   dPerepProc = ABS(GetCredLoanParamValue_ULL(loan.cont-code,352,end-date,FALSE)).*/

   RUN STNDRT_PARAM(loan.contract, loan.cont-code, 352, end-date, OUTPUT dPerepProc, OUTPUT dT1, OUTPUT dT2).
   dSpisProc480 = 0.
   FOR EACH loan-int WHERE loan-int.contract = loan.contract
		       and loan-int.cont-code = loan.cont-code
		       and loan-int.id-d = 352
		       and loan-int.id-k = 6
		       and loan-int.mdate >= beg-date
		       and loan-int.mdate <= end-date
		       NO-LOCK.

                       dSpisProc480 = dSpisProc480 + loan-int.amt-rub.

   END.
	

/*   RUN STNDRT_PARAM(loan.contract, loan.cont-code, 352, end-date, OUTPUT dSpisProc480, OUTPUT dT1, OUTPUT dT2).*/
   dPerepProc = ABS(dPerepProc) + dSpisProc480.

   dSpisProc = dNachProc - dOplProc.

   if dSpisProc < 0 then dSpisProc = 0.
      else
	  do:
	     if dSpisProc > dPerepProc then dSpisProc = dPerepProc.
	  end.      	

     Run x-amtstr.p(dOplProc, loan.currency, false, true, output SummaStr[1], output SummaStr[2]).

     maintext[1] = REPLACE(maintext[1],"#dOplProc#",TRIM(STRING(dOplProc,">>>,>>>,>>>,>>9.99"))).
     maintext[1] = REPLACE(maintext[1],"#dOplProc_prop#",SummaStr[1] + " " + SummaStr[2]).
     maintext[1] = REPLACE(maintext[1],"#beg-date#",STRING(beg-date)).
     maintext[1] = REPLACE(maintext[1],"#end-date#",STRING(end-date)).
     maintext[1] = REPLACE(maintext[1],"#cont-code#",loan.cont-code).
     maintext[1] = REPLACE(maintext[1],"#DateSogl#",getMainLoanAttr("Кредит",loan.cont-code,"%ДатаСогл")).
     maintext[1] = REPLACE(maintext[1],"#cName#",cName).

     Run x-amtstr.p(dSpisProc, loan.currency, false, true, output SummaStr[1], output SummaStr[2]).

     maintext[1] = REPLACE(maintext[1],"#dSpisProc#",TRIM(STRING(dSpisProc,">>>,>>>,>>>,>>9.99"))).
     maintext[1] = REPLACE(maintext[1],"#dSpisProc_prop#",SummaStr[1] + " " + SummaStr[2]).
     maintext[1] = REPLACE(maintext[1],"#acct_c#",acct_c).


    

    {wordwrap.i &s=MainText &l=88 &n=11}

		DO i = 2 TO 11:
			if MainText[i] <> "" then do:
				maintext[1] = maintext[1] + CHR(10) + maintext[i].
			end.
		END.

    oTpl:addAnchorValue("maintext1",maintext[1]).
    oTpl:addAnchorValue("DATE",date-rasp).
    oTpl:addAnchorValue("BEG-DATE",beg-date).
    oTpl:addAnchorValue("END-DATE",end-date).
    oTpl:addAnchorValue("dNachProc",TRIM(STRING(dNachProc,">>>,>>>,>>>,>>9.99"))).
    oTpl:addAnchorValue("dPerepProc",TRIM(STRING(dPerepProc,">>>,>>>,>>>,>>9.99"))).
    oTpl:addAnchorValue("dItog",TRIM(STRING(dOplProc,">>>,>>>,>>>,>>9.99"))).
    oTpl:addAnchorValue("TABLE",oTable).

{setdest.i}
   oTpl:show().
{preview.i}

DELETE OBJECT oTpl.


end.
	
