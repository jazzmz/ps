/*************************************************************
 *                                                           *                                      
 *                                                           *
 * Процедура формирует распоряжение на перенос переплаты     *     
 * комиссии за неиспользованый лимит кредитной линии         *
 *                                                           *
 *                                                           *
 *************************************************************
 * Автор: Красков А.С.                                       *
 * Дата создания: 04.09.2012                                 *
 * заявка №1010                                              *
 *************************************************************/

using Progress.Lang.*.
{tmprecid.def}
{globals.i}
{getdate.i}
{ulib.i}
{wordwrap.def}
{t-otch.i new}
{intrface.get loan}
{lshpr.pro}           /* Инструменты для расчета параметров договора */

DEF VAR oTpl AS TTpl NO-UNDO.
DEF VAR oTAcct AS TAcct NO-UNDO.
DEF VAR oTable1 AS TTable NO-UNDO.
def var rPog as DEC NO-UNDO.
DEF VAR dat-per AS DATE NO-UNDO.	/* Дата перехода на 39-П */

def var dT1 as dec NO-UNDO.
def var dT2 as dec NO-UNDO.

def var i as integer no-undo.

DEF VAR cName AS CHAR NO-UNDO.
DEF VAR cIO AS CHAR NO-UNDO.
DEF VAR cOpName AS CHAR NO-UNDO.
DEF VAR STAVKAOUT AS Char NO-UNDO.
DEF VAR cSummProp AS CHAR NO-UNDO.
DEF VAR cSummProp_Kopp AS CHAR NO-UNDO.
DEF VAR dStartdate AS Date NO-UNDO.
DEF VAR idate AS Date NO-UNDO.
def var acct_c As CHAR NO-UNDO.
def var acct_D As CHAR NO-UNDO.

def var periodBase AS Integer NO-UNDO.

DEF VAR dPeriodbegin AS Date NO-UNDO.
DEF VAR dPeriodEnd   AS Date NO-UNDO.
DEF VAR dEndDate     AS Date NO-UNDO.
DEF VAR dBegDate     AS Date NO-UNDO.
def var bBegdateset as logical init no NO-UNDO.
def var bTrim as logical init yes NO-UNDO.
DEFINE VARIABLE stinstr AS CHARACTER            NO-UNDO.
DEFINE VARIABLE digit   AS INTEGER    EXTENT 12 NO-UNDO.
DEFINE VARIABLE sti     AS INTEGER              NO-UNDO.


DEF VAR prevbalance AS Decimal NO-UNDO.
DEF VAR procent AS Decimal Init 0  NO-UNDO.
DEF VAR stavka AS Decimal NO-UNDO.
DEF VAR SummItog AS Decimal Init 0 NO-UNDO.

DEF VAR idates As Integer Init 0 NO-UNDO.
def var proc-name as CHAR NO-UNDO.

def var maintext as char extent 11 no-undo.

{get-bankname.i}

maintext[1] = "         В связи с поступлением денежных средств в размере #rPog# (#rPogProp#), " + 
 	      "перечисленных в счет оплаты комиссии за неиспользованный лимит за период с #BEG-DATE# " +
 	      "по #END-DATE# по Кредитному договору №#cont-code# от #Datasogl#, подписаному между " + cBankName + " и #cName#, " +
	      "произвести учет суммы превышения в размере #dItog# (#dItogProp#) на счете #cAcct# " + CHR(34) + "Доходы будущих периодов" + CHR(34) + ".".
	                                                                                         
def buffer bfracct for acct. 

oTpl = new TTpl("pirloan1010.tpl").
       
oTable1 = new TTable(6).

oTpl:addAnchorValue("DATE",end-date).
                                                    
FOR EACH tmprecid,
   FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK:
         do:

           find first loan-acct where loan-acct.cont-code = loan.cont-code and (loan-acct.acct-type eq "КредБудПроц") NO-LOCK NO-ERROR.
           IF NOT AVAILABLE (loan-acct) then MESSAGE "К договору не привязан счет с ролью КредБудПроц!!!" VIEW-AS ALERT-BOX.

           acct_c = loan-acct.acct.

           find first loan-acct where loan-acct.cont-code = loan.cont-code and (loan-acct.acct-type eq "КредШт2%") NO-LOCK NO-ERROR.
           IF NOT AVAILABLE (loan-acct) then MESSAGE "К договору не привязан счет с ролью КредШт2%!!!" VIEW-AS ALERT-BOX.
           acct_d = loan-acct.acct.

	   find first loan-acct where loan-acct.cont-code = loan.cont-code and (loan-acct.acct-type eq "КредН" OR loan-acct.acct-type eq "КредЛин") NO-LOCK NO-ERROR.
           find first acct where acct.acct = loan-acct.acct NO-LOCK NO-ERROR.
           oTAcct = new TAcct(loan-acct.acct).
           IF NOT AVAILABLE (loan-acct) then MESSAGE "К договору не привязан счет с ролью КредН или КредЛин!!!" VIEW-AS ALERT-BOX.
           if loan.cust-cat eq "Ч" then 
           do:
               FIND FIRST person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.
               cName = person.name-last + " " + person.first-names.
               cOpName = "Комиссия за сумму неиспользованного лимита задолженности".
           end.
           if loan.cust-cat eq "Ю" then 
           do:

              FIND FIRST cust-corp where cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.

              cName = cust-corp.name-short.
              cOpName = "Комиссия за поддержание лимита задолженности".
           end.
           if loan.cust-cat eq "Б" then 
           do:
              FIND FIRST banks where banks.bank-id = loan.cust-id NO-LOCK NO-ERROR.
              cName = banks.short-name.

           end.
     
         end.
           dPeriodBegin = FirstMonDate(end-date).
           dPeriodEnd   = LastMonDate(end-date).
           dPeriodEnd   = end-date.

           dPeriodEnd = IF LastMonDate(end-date) <= loan.end-date THEN LastMonDate(end-date) ELSE loan.end-date.
                                   
           stavka = GetLoanCommission_ULL(loan.contract,loan.cont-code,"НеиспК",end-date,TRUE).
           STAVKAOUT = string(stavka * 100).
           STAVKAOUT = STAVKAOUT + "%".



{getdates.i}

periodBase = (IF TRUNCATE(YEAR(end-date) / 4,0) = YEAR(end-date) / 4 THEN 366 ELSE 365).

dPeriodbegin = beg-date.
dperiodend   = end-date.
dstartdate   = dPeriodbegin.
dBegDate     = dstartdate.

if loan-acct.acct-type = "КредН" then do:

   {empty otch1}

   {ch_dat_p.i}

 {get_meth.i 'NachProc' 'nach-pp'}


   run VALUE(proc-name + ".p")(loan.contract,
                 loan.cont-code,
                 dPeriodbegin,
                 dperiodend,
                 dat-per,
	         ?,
                 1).


         
	 find FIRST loan-par WHERE CAN-DO("20",STRING(loan-par.amt-id)) NO-LOCK NO-ERROR.
	 find first otch1 where TRIM(loan-par.name) EQ TRIM(ENTRY(1,otch1.comment)) NO-LOCK NO-ERROR.

         dBegDate = otch1.beg-date.

        FOR EACH otch1,
	 FIRST loan-par WHERE TRIM(loan-par.name) EQ TRIM(ENTRY(1,otch1.comment)) 
		              AND CAN-DO("20",STRING(loan-par.amt-id)) NO-LOCK:
		   if otch1.summ_pr <> 0 then do:
                     if (bBegdateset = no) then DO: 
bBegdateset =  yes.
dBegDate = otch1.beg-date.
END.
                     oTable1:AddRow().
                     oTable1:AddCell(otch1.bal-sum).
                     oTable1:AddCell(otch1.beg-date).
                     oTable1:AddCell(otch1.end-date).
                     oTable1:AddCell(otch1.ndays).
                     oTable1:AddCell(STAVKAOUT).
                     oTable1:AddCell(otch1.summ_pr).
                     summitog = summitog + round(otch1.summ_pr,2).     
		     dendDate = otch1.end-date.
		   end.
        end.

END.
ELSE
DO:
           prevbalance = oTAcct:getLastPos2Date(dPeriodbegin - 1).
           idates = 0.

	   dstartdate = dPeriodbegin.
           do idate = dPeriodbegin to dperiodend:

               idates = idates + 1.


               if prevbalance <> oTAcct:getLastPos2Date(idate) then    
                  do:     



                    if (prevbalance = 0) and (bBegdateset = no) then dBegDate = dstartdate + 1.

                    if prevbalance <> 0 then do:
		     bBegdateset = yes.
		     if dstartdate = dPeriodbegin then do: 
			dstartdate = dstartdate.
			
                        procent = (prevbalance * stavka * (idate - dstartdate + 1)) / periodbase.
			end.
		     else	
		        do:
                          procent = (prevbalance * stavka * (idate - dstartdate + 1)) / periodbase.
                        end.

if procent <>0 then do:
                     oTable1:AddRow().
                     oTable1:AddCell(prevbalance).
  	 	     oTable1:AddCell(dstartdate).

 		     if dstartdate = dPeriodbegin then 
			do:                    
			   oTable1:AddCell(idate).
                           oTable1:AddCell(idate - dstartdate + 1).
			   dstartdate = dstartdate + 1.
			   btrim = no.                          
			end.
		     else
			do:
	                   oTable1:AddCell(idate ).
                           oTable1:AddCell(idate - dstartdate + 1).
			end.
                     oTable1:AddCell(STAVKAOUT).
                     oTable1:AddCell(procent).
                     dstartdate = idate + 1.
end.
                     summitog = summitog + round(procent,2).     
                     procent = 0.
                     idates = 0.                                           
		     dEndDate = idate.
                    end.
                    prevbalance = oTAcct:getLastPos2Date(idate).
                    if btrim then dstartdate = idate + 1. 
                    btrim = yes.
                 end.

               if oTAcct:getLastPos2Date(idate) = 0 then 
                  do:
                     dstartdate = idate + 1.
                     idates = 0.
                  end.

          end. 
          if prevbalance <>0 then do:
          idates = dPeriodEnd - dstartdate + 1.
          procent = (prevbalance * stavka * (idates)) / periodbase.
          summitog = summitog + round(procent,2).
          if procent <> 0 then do:
             oTable1:AddRow().
             oTable1:AddCell(prevbalance).
             oTable1:AddCell(dstartdate).
             oTable1:AddCell(idate - 1).
             oTable1:AddCell(idates).
             oTable1:AddCell(STAVKAOUT).
             oTable1:AddCell(procent).
	     end.
             dEndDate = idate - 1.
          end.
          prevbalance = oTAcct:getLastPos2Date(idate).    
end.

          rPog = 0.

          /*Здесь считаем средства полученые в оплату комиссии за период с beg-date по end-date*/
          for each loan-int where loan-int.cont-code = loan.cont-code
			      and loan-int.contract = loan.contract
		              and loan-int.mdate >= beg-Date                                                	
		              and loan-int.mdate <= end-Date 
	                      and ((loan-int.id-d = 5) /* НАЧ=5 И СП=92 ЭТО ОПЕРАЦИЯ 377 */
		              and (loan-int.id-k = 92)) NO-lock.
          rPog = rPog + loan-int.amt-rub.
          end.

	  /*посчитали закинули в rPog*/

           RUN x-amtstr.p(rPog,acct.currency,TRUE,TRUE, OUTPUT cSummProp, OUTPUT cSummProp_Kopp).
 
           maintext[1] = REPLACE(maintext[1],"#rPog#",STRING(rPog)).
           maintext[1] = REPLACE(maintext[1],"#rPogProp#",cSummProp + " " + cSummProp_Kopp).

           RUN x-amtstr.p(rPog - summitog,acct.currency,TRUE,TRUE, OUTPUT cSummProp, OUTPUT cSummProp_Kopp).

           maintext[1] = REPLACE(maintext[1],"#dItog#",STRING((rPog - summitog))).
           maintext[1] = REPLACE(maintext[1],"#dItogProp#",cSummProp + " " + cSummProp_Kopp).
           maintext[1] = REPLACE(maintext[1],"#BEG-DATE#",STRING(beg-date)).
           maintext[1] = REPLACE(maintext[1],"#END-DATE#",STRING(end-date)).
           maintext[1] = REPLACE(maintext[1],"#cont-code#",loan.cont-code).
           maintext[1] = REPLACE(maintext[1],"#cName#",cName).
           maintext[1] = REPLACE(maintext[1],"#cAcct#",acct_c).
           maintext[1] = REPLACE(maintext[1],"#Datasogl#",(getMainLoanAttr("Кредит",loan.cont-code,"%ДатаСогл"))).


    {wordwrap.i &s=MainText &l=88 &n=11}

		DO i = 2 TO 11:
			if MainText[i] <> "" then do:
				maintext[1] = maintext[1] + CHR(10) + maintext[i].
			end.
		END.

    oTpl:addAnchorValue("maintext1",maintext[1]).

	RUN STNDRT_PARAM(loan.contract, loan.cont-code, 352, end-date, OUTPUT rPog, OUTPUT dT1, OUTPUT dT2).

          oTpl:addAnchorValue("Beg-date",beg-date).
          oTpl:addAnchorValue("end-date",end-date).
          oTpl:addAnchorValue("dNachProc",TRIM(STRING(summitog,">>>,>>>,>>>,>>9.99"))).
          oTpl:addAnchorValue("dOplProc",TRIM(STRING(rPog,">>>,>>>,>>>,>>9.99"))).
          oTpl:addAnchorValue("dItog",TRIM(STRING(summitog,">>>,>>>,>>>,>>9.99"))).

                                                    

                   
          oTpl:addAnchorValue("TABLE",oTable1).

          procent = 0.
          idates = 0.
          summitog = 0.
end.                                                                    


{setdest.i}
oTpl:show().
{preview.i}

DELETE OBJECT oTAcct.
DELETE OBJECT oTable1.
DELETE OBJECT oTpl.
