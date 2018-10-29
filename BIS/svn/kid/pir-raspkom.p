/*************************************************************
 *                                                           *                                      
 *                                                           *
 * ��楤�� �ନ��� �ᯮ�殮��� �� ����襭�� �����ᨨ    *     
 * �� ���ᯮ�짮���� ����� �।�⭮� �����                  *
 * �૨�.                                                   *
 *                                                           *
 *************************************************************
 * ����: ��᪮� �.�.                                       *
 * ��� ᮧ�����: 01.12.2010                                 *
 * ��� �547                                               *
 *************************************************************/

using Progress.Lang.*.
{tmprecid.def}
{globals.i}
{getdate.i}
{ulib.i}
{t-otch.i new}
{intrface.get loan}
{lshpr.pro}           /* �����㬥��� ��� ���� ��ࠬ��஢ ������� */

def var dt1     as dec  NO-UNDO.
def var temp    as dec  NO-UNDO.
DEF VAR oTpl    AS TTpl NO-UNDO.
DEF VAR oTAcct  AS TAcct NO-UNDO.
DEF VAR oTable1 AS TTable.

def var periodbase as int no-undo.

DEF VAR dat-per AS DATE NO-UNDO.	/* ��� ���室� �� 39-� */

DEF VAR cName     AS CHAR NO-UNDO.
DEF VAR cIO       AS CHAR NO-UNDO.
DEF VAR cOpName   AS CHAR NO-UNDO.
DEF VAR STAVKAOUT AS Char NO-UNDO.
DEF VAR cSummProp AS CHAR NO-UNDO.

DEF VAR cSummProp_Kopp AS CHAR NO-UNDO.
DEF VAR dPeriodbegin   AS Date NO-UNDO.
DEF VAR dPeriodEnd     AS Date NO-UNDO.
DEF VAR dEndDate       AS Date NO-UNDO.
DEF VAR dBegDate       AS Date NO-UNDO.

def var bBegdateset as logical init no  NO-UNDO.
def var bTrim       as logical init yes NO-UNDO.

DEFINE VARIABLE stinstr AS CHARACTER            NO-UNDO.
DEFINE VARIABLE digit   AS INTEGER    EXTENT 12 NO-UNDO.
DEFINE VARIABLE sti     AS INTEGER              NO-UNDO.


DEF VAR idate      AS Date NO-UNDO. 
DEF VAR dStartDate AS Date NO-UNDO.

DEF VAR prevbalance AS Decimal        NO-UNDO.
DEF VAR procent     AS Decimal Init 0 NO-UNDO.
DEF VAR stavka      AS Decimal        NO-UNDO.
DEF VAR SummItog    AS Decimal Init 0 NO-UNDO.

DEF VAR idates     As Integer Init 0 NO-UNDO.
def var proc-name  as CHAR NO-UNDO.


oTpl = new TTpl("pir-raspkom.tpl").
       
oTable1 = new TTable(6).

/* ᮧ����� ��������� ⠡���� */

oTable1:AddRow().
oTable1:AddCell("����������������").
oTable1:AddCell("������").
oTable1:AddCell("�����").
oTable1:AddCell("���-��").
oTable1:AddCell("������").
oTable1:AddCell("����������").

oTable1:AddRow().
oTable1:AddCell("�����").
oTable1:setBorder(1,oTable1:height,1,0,1,1).
oTable1:AddCell("�������").
oTable1:setBorder(2,oTable1:height,1,0,1,1).
oTable1:AddCell("�������").
oTable1:setBorder(3,oTable1:height,1,0,1,1).
oTable1:AddCell("����").
oTable1:setBorder(4,oTable1:height,1,0,1,1).
oTable1:AddCell(" ").
oTable1:setBorder(5,oTable1:height,1,0,1,1).
oTable1:AddCell(" ").
oTable1:setBorder(6,oTable1:height,1,0,1,1).

/* ����� ᮧ����� ��������� ⠡���� */

FOR EACH tmprecid,
   FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK:
         do:
           find first loan-int where loan-int.op = op.op NO-LOCK NO-ERROR.
	   IF NOT AVAILABLE (loan-int) then MESSAGE "�஢���� �� �ਢ易��� � ��������!!!" VIEW-AS ALERT-BOX.           
           find first loan where loan.cont-code = loan-int.cont-code NO-LOCK NO-ERROR.

           find first loan-acct where loan-acct.cont-code = loan.cont-code and (loan-acct.acct-type eq "�।�" OR loan-acct.acct-type eq "�।���") NO-LOCK NO-ERROR.
           find first acct where acct.acct = loan-acct.acct NO-LOCK NO-ERROR.

           IF NOT AVAILABLE (loan-acct) then MESSAGE "� �������� �� �ਢ易� ��� � ஫�� �।� ��� �।���!!!" VIEW-AS ALERT-BOX.
           oTAcct = new TAcct(loan-acct.acct).
           if loan.cust-cat eq "�" then 
           do:         
              FIND FIRST person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.
               cName = person.name-last.
               cIO = person.first-names.
               cOpName = "������� �� �㬬� ���ᯮ�짮������� ����� ������������".
               FIND LAST loan-int where loan-int.op = op.op and loan-int.cont-code = loan.cont-code and loan-int.id-k = 92 NO-LOCK NO-ERROR.
               if not available(loan-int) then message "���ࠢ��쭠� �ਢ離� � ��������" view-as alert-box.
               FIND FIRST op-entry where op-entry.op = loan-int.op.
/*               if op.op-kind <> "rub_10+" and op.op-kind <> "val_10+" then next.*/
           end.
           if loan.cust-cat eq "�" then 
           do:
	      FIND FIRST cust-corp where cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.
              cName = cust-corp.name-short.
              cIO = "". 
              cOpName = "������� �� �����ঠ��� ����� ������������".
/*  	      message loan.cont-code op.op VIEW-AS ALERT-BOX.*/
              FIND LAST loan-int where loan-int.op = op.op NO-LOCK NO-ERROR.
              if not Available(loan-int) then next.
              FIND FIRST op-entry where op-entry.op = loan-int.op.


           end.
           if loan.cust-cat eq "�" then 
           do:
              FIND FIRST banks where banks.bank-id = loan.cust-id NO-LOCK NO-ERROR.
              cName = banks.short-name.
              cIO = "". 
           end.
     
         end.
           dPeriodBegin = FirstMonDate(end-date).

	   /****************************************
	    * � ��砥 �᫨ ������� ����稢�����,  *
            * ࠭�� ����砭�� �����, � ��⠥�  *
            * �� ���� ����砭�� �������.          *
            ****************************************
            * ����: ��᫮� �. �. Maslov D. A.     *
            * ���: #761                         *
            * ��� ᮧ�����: 23.09.11 15:02        *
            *****************************************/
           dPeriodEnd = IF LastMonDate(end-date) <= loan.end-date THEN LastMonDate(end-date) ELSE loan.end-date.
                      
           stavka = GetLoanCommission_ULL(loan.contract,loan.cont-code,"���ᯊ",end-date,TRUE).
           STAVKAOUT = string(stavka * 100).
           STAVKAOUT = STAVKAOUT + "%".

oTpl:addAnchorValue("DATE",end-date).

{getdates.i}
dPeriodbegin = beg-date.
dperiodend = end-date.
           dstartdate = dPeriodbegin.
	   dBegDate = dstartdate.
Periodbase = (IF TRUNCATE(YEAR(end-date) / 4,0) = YEAR(end-date) / 4 THEN 366 ELSE 365).
if loan-acct.acct-type = "�।�" then do:

    RUN STNDRT_PARAM(loan.contract, loan.cont-code,  92, op-entry.op-date - 1, OUTPUT Temp , OUTPUT dT1, OUTPUT dT1).


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
			
                        procent = (prevbalance * stavka * (idate - dstartdate + 1)) / Periodbase.
/*			message dstartdate dPeriodbegin idate VIEW-AS ALERT-BOX.*/
			end.
		     else	
		        do:
                          procent = (prevbalance * stavka * (idate - dstartdate + 1)) / Periodbase.
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
          if idates > 0 then do:
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
          end.
          prevbalance = oTAcct:getLastPos2Date(idate).    
end.
           FIND LAST loan-int where loan-int.op = op.op NO-LOCK NO-ERROR.

          RUN x-amtstr.p(round(loan-int.amt-rub,2),acct.currency,FALSE,FALSE, OUTPUT cSummProp, OUTPUT cSummProp_Kopp).

          if acct.currency = "810" or acct.currency = "" or acct.currency = ? then 
             do:
                oTpl:addAnchorValue("VAL","��.").
                oTpl:addAnchorValue("VAL_CENT","������").
                oTpl:addAnchorValue("CUR","810").
             end.
           if acct.currency = "840" then 
             do:
		DO sti = 1 TO 12:
		   digit[sti] = INTEGER(SUBSTRING(stinstr, 13 - sti, 1)).
		END.
                
               if digit[1] = 1 and digit[2] <> 1 then oTpl:addAnchorValue("VAL","������ ���").
	       else if digit[2] = 1 or digit[1] > 4 or digit[1] = 0 then oTpl:addAnchorValue("VAL","�����஢ ���").
                else oTpl:addAnchorValue("VAL","������ ���").

                oTpl:addAnchorValue("VAL","������� ���").
                oTpl:addAnchorValue("VAL_CENT","業⮢").
                oTpl:addAnchorValue("CUR","840").
             end.
           if acct.currency = "978" then 
             do:
                oTpl:addAnchorValue("VAL","���").
                oTpl:addAnchorValue("VAL_CENT","���業⮢").
                oTpl:addAnchorValue("CUR","978").
             end.

          oTpl:addAnchorValue("LOAN_START",(getMainLoanAttr("�।��",loan.cont-code,"%��⠑���"))).
          oTpl:addAnchorValue("SUMM_PROP",TRIM(cSummProp)).
          oTpl:addAnchorValue("SUMM_PROP_CENT",TRIM(cSummProp_Kopp)).

	  /*******************
           * ��᫮� �. �. Maslov D. A.
           * �� ���: #709
           * ��������� �ଠ� ��᫥ ����⮩ ������ ���� ��� �����.
	   * ���ਬ��: 192.1 ������ �⮡ࠦ����� ��� 192.10
           *******************/

          if  loan-int.amt-rub - Summitog > 0 then DO:
	      oTpl:addAnchorValue("SledPer",TRIM(STRING(round(loan-int.amt-rub - Summitog,2),">>>,>>>,>>>,>>9.99"))).
          end.
          else oTpl:addAnchorValue("SledPer","0.00").



          oTpl:addAnchorValue("Summa1",TRIM(STRING(round(loan-int.amt-rub,2),">>>,>>>,>>>,>>9.99"))).
          oTpl:addAnchorValue("ACCT",op-entry.acct-cr).
          oTpl:addAnchorValue("CONT_NAME",cName).
          oTpl:addAnchorValue("IO",cIO).
          oTpl:addAnchorValue("CORR_ACCT",op-entry.acct-db).
          oTpl:addAnchorValue("LOAN",loan.cont-code).


          oTpl:addAnchorValue("PeriodEnd",dEndDate).
          oTpl:addAnchorValue("PeriodBegin",dBegDate).
          
          oTpl:addAnchorValue("Summa2",TRIM(STRING(round(Summitog,2),">>>,>>>,>>>,>>9.99"))).
          oTpl:addAnchorValue("Summa4",TRIM(STRING(round(Summitog,2),">>>,>>>,>>>,>>9.99"))).

	  oTpl:addAnchorValue("rPog",round(temp,2)).       
          oTpl:addAnchorValue("Summa3",TRIM(STRING(round(Summitog - temp,2),">>>,>>>,>>>,>>9.99"))).
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
