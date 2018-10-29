/*************************************************************
 *                                                           *                                      
 *                                                           *
 * Процедура формирует распоряжение на погашение комиссии    *     
 * за неиспользованый лимит кредитной линии                  *
 * юрлица с конвертацией.                                    *
 *                                                           *
 *************************************************************
 * Автор: Красков А.С.                                       *
 * Дата создания: 09.04.2012                                 *
 * заявка №900                                               *
 *************************************************************/

using Progress.Lang.*.
{tmprecid.def}
{globals.i}
{getdate.i}
{ulib.i}
{t-otch.i new}
{intrface.get loan}
{lshpr.pro}           /* Инструменты для расчета параметров договора */

DEF VAR oTpl AS TTpl NO-UNDO.
DEF VAR oTAcct AS TAcct NO-UNDO.
DEF VAR oTable1 AS TTable NO-UNDO.
def var rPog as DEC NO-UNDO.
DEF VAR dat-per AS DATE NO-UNDO.	/* Дата перехода на 39-П */

def var dt1     as dec  NO-UNDO.


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

DEF VAR evidence AS CHAR
	LABEL "Текст основания"
	VIEW-AS 
	EDITOR SIZE 48 BY 7 NO-UNDO.

DEF VAR raspDate AS DATE
	LABEL "Дата распоряжения" NO-UNDO.

def var acct_conv as CHAR FORMAT "x(20)"
        LABEL "Счет для конвертации" NO-UNDO.

def buffer bfracct for acct. 

oTpl = new TTpl("pirloan900.tpl").
       
oTable1 = new TTable(6).

/* создание заголовка таблицы */

oTable1:AddRow().
oTable1:AddCell("НЕИСПОЛЬЗОВАННЫЙ").
oTable1:AddCell("НАЧАЛО").
oTable1:AddCell("КОНЕЦ").
oTable1:AddCell("КОЛ-ВО").
oTable1:AddCell("СТАВКА").
oTable1:AddCell("НАЧИСЛЕННО").

oTable1:AddRow().
oTable1:AddCell("ЛИМИТ").
oTable1:setBorder(1,oTable1:height,1,0,1,1).
oTable1:AddCell("ПЕРИОДА").
oTable1:setBorder(2,oTable1:height,1,0,1,1).
oTable1:AddCell("ПЕРИОДА").
oTable1:setBorder(3,oTable1:height,1,0,1,1).
oTable1:AddCell("ДНЕЙ").
oTable1:setBorder(4,oTable1:height,1,0,1,1).
oTable1:AddCell(" ").
oTable1:setBorder(5,oTable1:height,1,0,1,1).
oTable1:AddCell(" ").
oTable1:setBorder(6,oTable1:height,1,0,1,1).

/* конец создания заголовка таблицы */

FOR EACH tmprecid,
   FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK:
         do:

           find first loan-acct where loan-acct.cont-code = loan.cont-code and (loan-acct.acct-type eq "КредРасч") NO-LOCK NO-ERROR.
           IF NOT AVAILABLE (loan-acct) then MESSAGE "К договору не привязан счет с ролью КредРасч!!!" VIEW-AS ALERT-BOX.


           acct_c = loan-acct.acct.

           acct_conv = "".
	   find first bfracct where bfracct.cust-id = loan.cust-id 
	                     and bfracct.currency = "" 
		             and can-do("Расчет,Текущ",bfracct.contract)
			     and (bfracct.close-date >= end-date or bfracct.close-date = ?)
			     and (bfracct.open-date <= end-date)
		             NO-LOCK NO-ERROR. 
           IF NOT AVAILABLE (bfracct) then MESSAGE "Не найден счет для конвертации!" VIEW-AS ALERT-BOX.

           acct_conv = bfracct.acct.
           raspDate = end-date.	
	   UPDATE  raspDate evidence acct_conv WITH FRAME frmTmp CENTERED SIDE-LABELS OVERLAY.


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
/*               message "gf" VIEW-AS ALERT-BOX.*/
/*               FIND LAST loan-int where loan-int.cont-code = loan.cont-code and loan-int.id-k = 97.
               message "gf1" VIEW-AS ALERT-BOX.
               FIND FIRST op-entry where op-entry.op = loan-int.op.
               message "gf2" VIEW-AS ALERT-BOX.                    */
               cName = person.name-last.
               cIO = person.first-names.
               cOpName = "Комиссия за сумму неиспользованного лимита задолженности".
           end.
           if loan.cust-cat eq "Ю" then 
           do:

              FIND FIRST cust-corp where cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.
/*              FIND LAST loan-int where loan-int.cont-code = loan.cont-code and loan-int.id-k = 97.
              FIND FIRST op-entry where op-entry.op = loan-int.op.*/

              cName = cust-corp.name-short.
              cIO = "". 
              cOpName = "Комиссия за поддержание лимита задолженности".
           end.
           if loan.cust-cat eq "Б" then 
           do:
              FIND FIRST banks where banks.bank-id = loan.cust-id NO-LOCK NO-ERROR.
              cName = banks.short-name.
              cIO = "". 
           end.
     
         end.
           dPeriodBegin = FirstMonDate(end-date).
           dPeriodEnd = LastMonDate(end-date).
           dPeriodEnd = end-date.

           dPeriodEnd = IF LastMonDate(end-date) <= loan.end-date THEN LastMonDate(end-date) ELSE loan.end-date.
                                   
           stavka = GetLoanCommission_ULL(loan.contract,loan.cont-code,"НеиспК",end-date,TRUE).
           STAVKAOUT = string(stavka * 100).
           STAVKAOUT = STAVKAOUT + "%".

oTpl:addAnchorValue("DATE",end-date).

{getdates.i}
dPeriodbegin = beg-date.
dperiodend = end-date.
           dstartdate = dPeriodbegin.
	   dBegDate = dstartdate.

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
/*           message dPeriodbegin VIEW-AS ALERT-BOX.*/
	   dstartdate = dPeriodbegin.
           do idate = dPeriodbegin to dperiodend:

               idates = idates + 1.
/*                   message idate oTAcct:getLastPos2Date(idate) VIEW-AS ALERT-BOX.*/

               if prevbalance <> oTAcct:getLastPos2Date(idate) then    
                  do:     



                    if (prevbalance = 0) and (bBegdateset = no) then dBegDate = dstartdate + 1.

                    if prevbalance <> 0 then do:
		     bBegdateset = yes.
		     if dstartdate = dPeriodbegin then do: 
			dstartdate = dstartdate.
			
                        procent = (prevbalance * stavka * (idate - dstartdate + 1)) / 366.
/*			message dstartdate dPeriodbegin idate VIEW-AS ALERT-BOX.*/
			end.
		     else	
		        do:
                          procent = (prevbalance * stavka * (idate - dstartdate + 1)) / 366.
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
/*                           message idate VIEW-As ALERT-BOX.*/
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
          procent = (prevbalance * stavka * (idates)) / 366.
          summitog =summitog + round(procent,2).
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

	  if loan-acct.acct-type = "КредН" then RUN STNDRT_PARAM(loan.contract, loan.cont-code,  92, dperiodend, OUTPUT rPog , OUTPUT dT1, OUTPUT dT1).

          RUN x-amtstr.p(summitog + rPog,acct.currency,FALSE,FALSE, OUTPUT cSummProp, OUTPUT cSummProp_Kopp).
 
          if acct.currency = "810" or acct.currency = "" or acct.currency = ? then 
             do:
                oTpl:addAnchorValue("VAL","руб.").
                oTpl:addAnchorValue("VAL_CENT","копеек").
                oTpl:addAnchorValue("CUR","810").
             end.
           if acct.currency = "840" then 
             do:
		DO sti = 1 TO 12:
		   digit[sti] = INTEGER(SUBSTRING(stinstr, 13 - sti, 1)).
		END.
                
               if digit[1] = 1 and digit[2] <> 1 then oTpl:addAnchorValue("VAL","доллар США").
	       else if digit[2] = 1 or digit[1] > 4 or digit[1] = 0 then oTpl:addAnchorValue("VAL","долларов США").
                else oTpl:addAnchorValue("VAL","доллара США").

                oTpl:addAnchorValue("VAL","доллары США").
                oTpl:addAnchorValue("VAL_CENT","центов").
                oTpl:addAnchorValue("CUR","840").
             end.
           if acct.currency = "978" then 
             do:
                oTpl:addAnchorValue("VAL","Евро").
                oTpl:addAnchorValue("VAL_CENT","евроцентов").
                oTpl:addAnchorValue("CUR","978").
             end.


      	  if loan-acct.acct-type = "КредН" then oTpl:addAnchorValue("VID_ZAD","задолженности").                              
      	  if loan-acct.acct-type = "КредЛин" then oTpl:addAnchorValue("VID_ZAD","выдачи").                                                                           

          oTpl:addAnchorValue("LOAN_START",(getMainLoanAttr("Кредит",loan.cont-code,"%ДатаСогл"))).
          oTpl:addAnchorValue("SUMM_PROP",TRIM(cSummProp)).
          oTpl:addAnchorValue("SUMM_PROP_CENT",TRIM(cSummProp_Kopp)).
          oTpl:addAnchorValue("Summa1",TRIM(STRING(round(Summitog + rPog,2),">>>,>>>,>>>,>>9.99"))).

          oTpl:addAnchorValue("Summa3",TRIM(STRING(round(Summitog,2),">>>,>>>,>>>,>>9.99"))).

          oTpl:addAnchorValue("CONVACCT",acct_conv).                              
          oTpl:addAnchorValue("ACCT",acct_d).
          oTpl:addAnchorValue("CONT_NAME",cName).
          oTpl:addAnchorValue("IO",cIO).
          oTpl:addAnchorValue("CORR_ACCT",acct_c).
          oTpl:addAnchorValue("LOAN",loan.cont-code).
/*          oTpl:addAnchorValue("OP_TYPE",cOpName).         */
          oTpl:addAnchorValue("PeriodBegin",dPeriodBegin).
          oTpl:addAnchorValue("PeriodEnd",dPeriodEnd).
/*          oTpl:addAnchorValue("DATE",raspDate).*/
                                                    

          oTpl:addAnchorValue("rPog",TRIM(STRING(round(ABS(rPog),2),">>>,>>>,>>>,>>9.99"))).

          oTpl:addAnchorValue("Summa2",TRIM(STRING(round(Summitog + rPog,2),">>>,>>>,>>>,>>9.99"))).
                    oTpl:addAnchorValue("OSNOVANIE",evidence).
                   
          oTpl:addAnchorValue("TABLE1",oTable1).

          procent = 0.
          idates = 0.
          summitog = 0.
end.                                                                    

oTpl:addAnchorValue("ISPOPLNITEL",GetUserInfo_ULL(USERID, "fio", false)).

{setdest.i}
oTpl:show().
{preview.i}

DELETE OBJECT oTAcct.
DELETE OBJECT oTable1.
DELETE OBJECT oTpl.
