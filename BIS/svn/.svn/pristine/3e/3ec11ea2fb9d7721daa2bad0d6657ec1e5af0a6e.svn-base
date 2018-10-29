/*************************************************************
 *                                                           *                                      
 *                                                           *
 * Процедура формирует распоряжение на погашение комиссии    *     
 * за неиспользованый лимит кредитной линии                  *
 * юрлица.                                                   *
 *                                                           *
 *************************************************************
 * Автор: Красков А.С.                                       *
 * Дата создания: 01.12.2010                                 *
 * заявка №547                                               *
 *************************************************************/

using Progress.Lang.*.
{tmprecid.def}
{globals.i}
{getdate.i}
{ulib.i}

DEF VAR oTpl    AS TTpl   NO-UNDO.
DEF VAR oTAcct  AS TAcct  NO-UNDO.
DEF VAR oTable1 AS TTable NO-UNDO.
def var periodbase as int no-undo.

DEF VAR cName          AS CHAR      	  NO-UNDO.
DEF VAR cIO            AS CHAR      	  NO-UNDO.
DEF VAR cOpName        AS CHAR      	  NO-UNDO.
DEF VAR STAVKAOUT      AS Char      	  NO-UNDO.
DEF VAR cSummProp      AS CHAR      	  NO-UNDO.
DEF VAR cSummProp_Kopp AS CHAR      	  NO-UNDO.
DEF VAR dPeriodbegin   AS Date	    	  NO-UNDO.
DEF VAR dPeriodEnd     AS Date	    	  NO-UNDO.
DEF VAR dStartdate     AS Date      	  NO-UNDO.
DEF VAR idate 	       AS Date	          NO-UNDO.
DEF VAR dEndDate       AS Date            NO-UNDO.
DEF VAR dBegDate       AS Date            NO-UNDO.
def var bBegdateset    as logical init no NO-UNDO.

DEF VAR prevbalance    AS Decimal	  NO-UNDO.
DEF VAR procent        AS Decimal Init 0  NO-UNDO.
DEF VAR stavka 	       AS Decimal	  NO-UNDO.
DEF VAR SummItog       AS Decimal Init 0  NO-UNDO.

DEF VAR idates As Integer Init 0 NO-UNDO.

Periodbase = (IF TRUNCATE(YEAR(end-date) / 4,0) = YEAR(end-date) / 4 THEN 366 ELSE 365).

oTpl = new TTpl("pir-raspkom.tpl").
       
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

           find first loan-acct where loan-acct.cont-code = loan.cont-code and (loan-acct.acct-type eq "КредН" OR loan-acct.acct-type eq "КредЛин") NO-LOCK NO-ERROR.
           find first acct where acct.acct = loan-acct.acct NO-LOCK NO-ERROR.
           oTAcct = new TAcct(loan-acct.acct).
           IF NOT AVAILABLE (loan-acct) then MESSAGE "К договору не привязан счет с ролью КредН или КредЛин!!!" VIEW-AS ALERT-BOX.
           if loan.cust-cat eq "Ч" then 
           do:
  
               FIND FIRST person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.
               FIND LAST loan-int where loan-int.cont-code = loan.cont-code and loan-int.id-k = 97.
               FIND FIRST op-entry where op-entry.op = loan-int.op.
               cName = person.name-last.
               cIO = person.first-names.
               cOpName = "Комиссия за сумму неиспользованного лимита задолженности".
           end.
           if loan.cust-cat eq "Ю" then 
           do:

              FIND FIRST cust-corp where cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.
              FIND LAST loan-int where loan-int.cont-code = loan.cont-code and loan-int.id-k = 97.
              FIND FIRST op-entry where op-entry.op = loan-int.op.

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

           if acct.currency = "810" or acct.currency = "" or acct.currency = ? then 
             do:
                oTpl:addAnchorValue("VAL","руб.").
                oTpl:addAnchorValue("VAL_CENT","копеек").
                oTpl:addAnchorValue("CUR","810").
             end.
           if acct.currency = "840" then 
             do:
                oTpl:addAnchorValue("VAL","USD").
                oTpl:addAnchorValue("VAL_CENT","центов").
                oTpl:addAnchorValue("CUR","840").
             end.
           if acct.currency = "978" then 
             do:
                oTpl:addAnchorValue("VAL","Евро").
                oTpl:addAnchorValue("VAL_CENT","евроцентов").
                oTpl:addAnchorValue("CUR","978").
             end.
                        
           stavka = GetLoanCommission_ULL(loan.contract,loan.cont-code,"НеиспК",end-date,TRUE).
           STAVKAOUT = string(stavka * 100).
           STAVKAOUT = STAVKAOUT + "%".

           dstartdate = dPeriodbegin.
	   dBegDate = dstartdate.
           prevbalance = oTAcct:getLastPos2Date(dPeriodbegin - 1).
           idates = 0.

           do idate = dPeriodbegin to dperiodend:

               idates = idates + 1.
               if prevbalance <> oTAcct:getLastPos2Date(idate) then    
                  do:     
                    if prevbalance = 0 then dBegDate = dstartdate + 1.

                    if prevbalance <> 0 then do:
		     procent = (prevbalance * stavka * (idate - dstartdate + 1)) / Periodbase.
                     oTable1:AddRow().
                     oTable1:AddCell(prevbalance).
                     oTable1:AddCell(dstartdate).
                     oTable1:AddCell(idate).
                     oTable1:AddCell(idate - dstartdate + 1).
                     oTable1:AddCell(STAVKAOUT).
                     oTable1:AddCell(procent).
                     summitog = summitog + round(procent,2).     
                     procent = 0.
                     idates = 0.                                           
		     dEndDate = idate.
                    end.
                    prevbalance = oTAcct:getLastPos2Date(idate).
                    dstartdate = idate + 1.
                 end.
               if oTAcct:getLastPos2Date(idate) = 0 then 
                  do:
                     dstartdate = idate + 1.
                     idates = 0.
                  end.

          end. 
          if prevbalance <>0 then do:
          idates = dPeriodEnd - dstartdate + 1.
          procent = (prevbalance * stavka * (idates)) / Periodbase.
          summitog =summitog + round(procent,2).
          oTable1:AddRow().
          oTable1:AddCell(prevbalance).
          oTable1:AddCell(dstartdate).
          oTable1:AddCell(idate - 1).
          oTable1:AddCell(idates).
          oTable1:AddCell(STAVKAOUT).
          oTable1:AddCell(procent).
          dEndDate = idate - 1.
          end.
          prevbalance = oTAcct:getLastPos2Date(idate).


          RUN x-amtstr.p(summitog,acct.currency,FALSE,FALSE, OUTPUT cSummProp, OUTPUT cSummProp_Kopp).

          oTpl:addAnchorValue("LOAN_START",(getMainLoanAttr("Кредит",loan.cont-code,"%ДатаСогл"))).
          oTpl:addAnchorValue("SUMM_PROP",TRIM(cSummProp)).
          oTpl:addAnchorValue("SUMM_PROP_CENT",TRIM(cSummProp_Kopp)).
          oTpl:addAnchorValue("Summa1",round(Summitog,2)).
          oTpl:addAnchorValue("ACCT",op-entry.acct-cr).
          oTpl:addAnchorValue("CONT_NAME",cName).
          oTpl:addAnchorValue("IO",cIO).
          oTpl:addAnchorValue("CORR_ACCT",op-entry.acct-db).
          oTpl:addAnchorValue("LOAN",loan.cont-code).
/*          oTpl:addAnchorValue("OP_TYPE",cOpName).         */
          oTpl:addAnchorValue("PeriodBegin",dPeriodBegin).
          oTpl:addAnchorValue("PeriodEnd",dPeriodEnd).
          oTpl:addAnchorValue("DATE",end-date).
          oTpl:addAnchorValue("Summa2",round(Summitog,2)).
       
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
