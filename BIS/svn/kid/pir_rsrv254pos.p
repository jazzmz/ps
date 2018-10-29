{pirsavelog.p}

/*
   ��ᯮ�殮��� �� १�ࢠ� 232-�
   ���� �.�. 10.01.2006 10:19

   �᫮�����, �� ��㧥� ��࠭� ⮫쪮 "�ࠢ����" ���㬥���, �.�. �,
   ����� ������ �⮡ࠦ����� � �����饬 �ᯮ�殮���.

Modified: 20.05.2009 Borisov - ��������� ������� ���ᯥ祭��
*/

{globals.i} /* �������塞 �������� ����ன��*/

{ulib.i}    /* ������⥪� �㭪権 ��� ࠡ��� � ��⠬� */
{intrface.get rsrv}
{intrface.get i254}
{intrface.get instrum}
{intrface.get loan}
{intrface.get xclass}   /* �㭪樨 ࠡ��� � ����奬�� */
{intrface.get count}

{lshpr.pro}           /* �����㬥��� ��� ���� ��ࠬ��஢ ������� */

{pir-gp.i}


/* ============================================== */
DEF VAR oTable AS TTable       NO-UNDO.
DEF VAR oTpl     AS TTpl           NO-UNDO.
DEF VAR oDoc   AS TDocument NO-UNDO.

oTpl = new TTpl("pir_rsrv254pos.tpl").


DEF INPUT PARAM inParam    AS CHARACTER.
DEF VAR acct_rsrv          AS CHARACTER NO-UNDO. /* ��� १�ࢠ: ��।���� � ��࠭�� ��� � �⮩ ��६����� */
DEF VAR acct_main_no       AS CHARACTER NO-UNDO. /* ��������ᮢ� ���, ����� �������� � ���� �⮫��� */
DEF VAR acct_main_cur      AS CHARACTER NO-UNDO.
DEF VAR acct_main_pos      AS DECIMAL   NO-UNDO. /* ������ �� ���� */
DEF VAR acct_main_pos_rur  AS DECIMAL   NO-UNDO.
DEF VAR acct_rsrv_calc_pos AS DECIMAL   NO-UNDO.
DEF VAR acct_rsrv_real_pos AS DECIMAL   NO-UNDO.

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* ���稪 ������஢ */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* ��饥 ������⢮ ������஢ */

def var main_acct_type as CHARACTER NO-UNDO.
def var rsrv_accts as CHAR INIT "45515*,45715*,45818*" NO-UNDO.

/* �㬬� ����樨 */
DEF VAR amt_create  AS DECIMAL   NO-UNDO.
DEF VAR amt_delete  AS DECIMAL   NO-UNDO.

DEF VAR client_name AS CHARACTER NO-UNDO.
DEF VAR loaninf     AS CHARACTER NO-UNDO.
DEF VAR grrisk      AS INTEGER   NO-UNDO.
DEF VAR prrisk      AS DECIMAL   NO-UNDO.
DEF VAR obesp       AS DECIMAL   NO-UNDO.
DEF VAR o2          AS DECIMAL   NO-UNDO. /* obesp usl dog - ne isp */
DEF VAR ob-cat      AS CHARACTER NO-UNDO.
DEF VAR iob-cat     AS DECIMAL   NO-UNDO.
DEF VAR loannum     AS CHARACTER NO-UNDO.
DEF VAR vSurr       AS CHARACTER NO-UNDO. /* ���ண�� ��易⥫��⢠ */


def var dt1 as dec no-undo.
def var dt2 as dec no-undo.

def var KursUSD as dec no-undo.
def var KursEUR as dec no-undo.
def var useridp  as char no-undo.

/* �⮣��� ���祭�� */
DEF VAR total_pos         AS DECIMAL NO-UNDO.
DEF VAR total_pos_rur     AS DECIMAL NO-UNDO.
DEF VAR total_pos_usd     AS DECIMAL NO-UNDO.
DEF VAR total_pos_eur     AS DECIMAL NO-UNDO.
DEF VAR total_calc_rsrv   AS DECIMAL NO-UNDO.
DEF VAR total_real_rsrv   AS DECIMAL NO-UNDO.
DEF VAR total_create_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_delete_rsrv AS DECIMAL NO-UNDO.

DEF VAR traceOn           AS LOGICAL INITIAL false NO-UNDO. /* �뢮� �訡�� �� �࠭ */
DEF VAR tmpStr    AS CHARACTER NO-UNDO. /* �६����� ��� ࠡ��� */
DEF VAR PIRbos    AS CHARACTER NO-UNDO. /* �������� � ������ */
DEF VAR PIRbosFIO AS CHARACTER NO-UNDO.
DEF VAR userPost  AS CHARACTER NO-UNDO.

DEF BUFFER bfrLA  FOR loan-acct.
def buffer bfropentry for op-entry.

def temp-table tTemp NO-UNDO
           field reserv_acct like loan-acct.acct
         field balanse_acct like loan-acct.acct
         INDEX reserv_acct IS PRIMARY reserv_acct.



def var TempTransh AS DEC NO-UNDO.
def var TempRSRV AS DEC NO-UNDO.
def var temp as dec no-undo.
def var td1 as dec no-undo.

def var par as INTEGER no-undo.

def var rezbase as char no-undo.

def var oAcct as TAcct no-undo.
def var oFunc as tfunc no-undo.
DEF VAR DATE-rasp AS DATE NO-UNDO. /* ��� �ᯮ�殮��� */
/* ������ �뤥������ � ��㧥� ���㬥�⮢ */

{tmprecid.def}

def var tempacct_main_pos_rur as dec NO-UNDO.

Procedure CalcPos.
def var summ as dec no-undo.

def var cPos as char no-undo.
def buffer bfLoan for loan.
cPos = ENTRY(1,loan-acct.cont-code," ").
tempacct_main_pos_rur = 0.
for each bfloan where can-do("loan_trans_diff,l_agr_with_diff",bfloan.class-code) 
		and bfloan.contract = "�।��" 
		and (bfloan.close-date >= op.op-date or bfloan.close-date = ?)  NO-LOCK,
    LAST term-obl WHERE term-obl.contract EQ "�।��" 
		     AND term-obl.cont-code EQ bfloan.cont-code 	
		     AND term-obl.idnt EQ 128 
		     AND term-obl.lnk-cont-code eq cPos
	   	     AND term-obl.end-date <= op.op-date 
		     AND (term-obl.sop-date GE op.op-date OR term-obl.sop-date EQ ?) NO-LOCK. 
/*�뫮 
/*RUN STNDRT_PARAM(bfloan.contract, bfloan.cont-code,  par, op.op-date, OUTPUT summ , OUTPUT dT1, OUTPUT dT2).

*/


           if bfloan.currency = '840' then DO:
	      summ = round(summ * kursUSD,2).                        
	   end.

           if bfloan.currency = '978' then DO:
	      summ = round(summ * kursEUR,2).                        
	   end.



tempacct_main_pos_rur = tempacct_main_pos_rur + summ.                                                           */

 /**/
 /*�⠫�*/

summ = getRsrvBase(bfloan.cont-code,op.op-date,rezbase).

           if bfloan.currency = '840' then DO:
	      summ = round(summ * kursUSD,2).                        
	   end.

           if bfloan.currency = '978' then DO:
	      summ = round(summ * kursEUR,2).                        
	   end.


tempacct_main_pos_rur = tempacct_main_pos_rur + summ.
  /**/


end.


END PROCEDURE.


/**** ��᫮� ���㧪� � ��娢 ***/
&IF DEFINED(arch2)<>0 &THEN
&GLOBAL-DEFINE wsd 1
{pir-out2arch.i}
 curr-user-inspector = FGetSetting("PirEArch","RepInspCredit",?). /* #3718 */
&ENDIF


{init-bar.i "��ࠡ�⪠ ���㬥�⮢"}

for each tmprecid NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.
end.



/** �஢�ઠ �室�饣� ��ࠬ��� =================================================== */
IF NUM-ENTRIES(inParam) <> 2 
THEN DO:
   MESSAGE "�������筮� ���-�� ��ࠬ��஢. ������ ���� <���_���㬥��>,<���_�㪮����⥫�_��_PIRBoss>" 
      VIEW-AS ALERT-BOX.
   RETURN.
END.

PIRbos      =  ENTRY(1, FGetSetting("PIRboss", ENTRY(2, inParam), "")).
PIRbosFIO = ENTRY(2, FGetSetting("PIRboss", ENTRY(2, inParam), "")).




/** ���������� **/

/* �� ��ࢮ� ����樨 ������ ���� ���� */
DATE-rasp = gend-date.

oTable = new TTable(16).
oFunc = new tfunc().
/* ��� ��� ���㬥�⮢, ��࠭��� � ��o㧥� �믮��塞... =========================== */
FOR EACH tmprecid NO-LOCK, 
first op where RECID(op) = tmprecid.id.

         /* ������ ��ப� - �������� ࠡ��� ����� */
         {move-bar.i              	
            vLnCountInt
            vLnTotalInt
          }


            FIND FIRST instr-rate WHERE instr-rate.instr-cat EQ 'currency' 
                                                                  AND instr-rate.instr-code EQ STRING(840)
                                                                  AND instr-rate.rate-type EQ '����' 
                                                                  AND instr-rate.since = op.op-date
                                                    NO-LOCK NO-ERROR.


            IF AVAILABLE(instr-rate) THEN kursusd =  instr-rate.rate-instr. ELSE MESSAGE "�� ������ ���� USD!!!" VIEW-AS ALERT-BOX.


            FIND FIRST instr-rate WHERE instr-rate.instr-cat EQ 'currency' 
                                                                  AND instr-rate.instr-code EQ STRING(978)
                                                                  AND instr-rate.rate-type EQ '����' 
                                                                  AND instr-rate.since = op.op-date 
                                                    NO-LOCK NO-ERROR.

            IF AVAILABLE(instr-rate) THEN kursEUR =  instr-rate.rate-instr. ELSE MESSAGE "�� ������ ���� EUR!!!" VIEW-AS ALERT-BOX.



 oDoc = new TDocument(tmprecid.id).
   ASSIGN
      amt_create = 0
      amt_delete = 0
   .
   /* ������ ��� १�ࢠ � �஢����. �� ���� �� ������, ���� �� �।��� � ��稭����� � 4 
      ����⭮ ��࠭�� ���祭�� �㬬� �஢���� � ᮮ⢥�������� ��६�����  */
   IF oDoc:acct-db BEGINS "4" THEN
      ASSIGN
         acct_rsrv =  oDoc:acct-db
         amt_delete = oDoc:sum
      .
   IF oDoc:acct-cr BEGINS "4" THEN
      ASSIGN
         acct_rsrv = oDoc:acct-cr
         amt_create = oDoc:sum
      .

   /* �᫨ ��-⠪� �� �� ������, �� �� �।��� ���, ��稭��騩�� �� 4 �� ������,
      �뤠�� ᮮ�饭�� � ��室�� �� ��楤��� */
   IF acct_rsrv = ""
   THEN DO:
      MESSAGE "� �஢���� ���㬥�� " + oDoc:doc-num + " ��� ��� १�ࢠ, ��稭��饣��� �� 4!" VIEW-AS ALERT-BOX.
      RETURN.
   END.

/* �� ���� � ���㬥�� ��।��塞 ����� ��� � ��ࠬ��� १�ࢠ. ᤥ���� �����, �ਤ㬠� ��� ᤥ���� ���� - ��।���� */

find first tTemp where reserv_acct = acct_rsrv NO-LOCK NO-ERROR.
                if NOT AVAILABLE(tTemp) then
                 do:

   /*��� ������让 "������" ��� ���. ����� �ਤ㬠� ��� ��।����� - ��।���� */

   if can-do(rsrv_accts,acct_rsrv) then do:
      find last loan-acct where loan-acct.contract = "���" and loan-acct.acct = acct_rsrv and loan-acct.since <= op.op-date and CAN-DO("!������1*,*",loan-acct.cont-code) NO-LOCK NO-ERROR.
      if available (loan-acct) then 
         do:
            acct_main_no = "".                                   
            client_name = "".
            loaninf = "".
           find last comm-rate where comm-rate.commission begins "%���" 
                                  and comm-rate.kau = "���," + ENTRY(1,loan-acct.cont-code," ") 
                                 and comm-rate.since <= op.op-date NO-LOCK NO-ERROR.

            if available(comm-rate) then
              do:

                 prrisk = comm-rate.rate-comm.

                 if ENTRY(1,loan-acct.cont-code," ") = '������1' then loaninf = '���1'.
                 if ENTRY(1,loan-acct.cont-code," ") = '������2' then loaninf = '���2'.
                 if ENTRY(1,loan-acct.cont-code," ") = '������4' then loaninf = '���3'.
                 if ENTRY(1,loan-acct.cont-code," ") = '������5' then loaninf = '���4'.
                 if ENTRY(1,loan-acct.cont-code," ") = '������3' then loaninf = '���5'.
                 if ENTRY(1,loan-acct.cont-code," ") = '������6' then loaninf = '���6'.

                 if loaninf <> "���1" then 
	   	    do:	
 			acct_main_no = "45815(17)".
	   	        par = 7. 	
			rezbase = "baddebt".
	   	        RUN calcpos.
                        acct_main_pos_rur = tempacct_main_pos_rur.
		    end.	
                 else
                   do:
                       if loan-acct.acct-type = "�।���" then 
			 do:
			    acct_main_no = "45509 (45708)".
/*			    par = 0. 	*/

   	 	 	    rezbase = "debt".

	                    RUN calcpos.

	                    acct_main_pos_rur = tempacct_main_pos_rur.



	                 end.
                       else 
			do:
			   acct_main_no = "45708".
/*			   par = 0.*/
	 	 	   rezbase = "debt".
			   RUN calcpos.
                           acct_main_pos_rur = tempacct_main_pos_rur.

			end.
                   end.
                  

              end.
              else MESSAGE "�� ������ �����樥�� १�ࢨ஢���� ��� " ENTRY(1,loan-acct.cont-code," ") VIEW-AS ALERT-BOX.
                        amt_delete = 0.
			amt_create = 0.
		     for each bfropentry where bfropentry.op-date = op.op-date and (bfropentry.acct-db = acct_rsrv or bfropentry.acct-cr = acct_rsrv) NO-LOCK.
			   IF bfropentry.acct-db BEGINS "4" THEN
			      ASSIGN
			         amt_delete = amt_delete + bfropentry.amt-rub.
			      
			   IF bfropentry.acct-cr BEGINS "4" THEN
			      ASSIGN
			         amt_create = amt_create + bfropentry.amt-rub.
			      
		      end.
                   oAcct = new TAcct(acct_rsrv).
   
                   acct_rsrv_calc_pos = oAcct:getLastPos2date(op.op-date).
                     acct_rsrv_real_pos = oAcct:getLastPos2date(op.op-date) - amt_create + amt_delete.                                     
                   delete object oAcct.

                                   create ttemp.
                      assign 
                            reserv_acct = acct_rsrv
                            balanse_acct = acct_main_no.    
         end.
       else /*�᫨ ��� �� �ਢ易� � ���� � ����� ������� �� ������㤠�쭮� �᭮�� */ 
            DO:


/*��� ������訥 ��।���� ��-�� ⮣� �� ᭠砫� �뫮 ᪠���� ��㯯�஢��� �� �஢���� �� �������� � ���� �����,
 � ⥯��� ᪠���� ��।����� �� � �⮡� ������ ��ப� ᮮ⢥�⢮���� �஢����.  */
		  do:
                      /* ������ �������� ������ */
                      client_name = GetAcctClientName_UAL(acct_rsrv, traceOn).
                      /* ������ ���ଠ�� � ������� */
                      loannum = oDoc:getLnkLoanNum().   

                      IF NOT {assigned client_name} THEN  client_name = GetLoanInfo_ULL("�।��",loannum, "client_short_name", false).
                      /*loaninf = getMainLoanAttr("�।��",loannum,"������� � %cont-code �� %��⠑���").*/
		      loaninf = loannum.

                      find first loan-acct where loan-acct.contract = "�।��" 
                                             and loan-acct.cont-code = loannum 
                                             and loan-acct.acct = acct_rsrv NO-LOCK NO-ERROR.

                      if not available (loan-acct) then MESSAGE "�� ������� �ਢ離� ��� � ��������! " loannum acct_rsrv VIEW-AS ALERT-BOX.
/*                      message loannum view-as alert-box.*/
                      main_acct_type = "".
                      if loan-acct.acct-type = "�।���" then 
			do:
			   main_acct_type = "�।��".   	
			   RUN STNDRT_PARAM("�।��", loannum,  0, op.op-date, OUTPUT tempacct_main_pos_rur , OUTPUT dT1, OUTPUT dT2).
                           acct_main_pos = tempacct_main_pos_rur.
			   RUN STNDRT_PARAM("�।��", loannum,  2, op.op-date, OUTPUT tempacct_main_pos_rur , OUTPUT dT1, OUTPUT dT2).
                           acct_main_pos = acct_main_pos + tempacct_main_pos_rur.
			   RUN STNDRT_PARAM("�।��", loannum,  21, op.op-date, OUTPUT acct_rsrv_calc_pos , OUTPUT dT1, OUTPUT dT2).
                           acct_rsrv_calc_pos = ABS(acct_rsrv_calc_pos).
			end.
                      if loan-acct.acct-type = "�।���1" then 
			do:
			   main_acct_type = "�।��". 
			   RUN STNDRT_PARAM("�।��", loannum,  7, op.op-date, OUTPUT tempacct_main_pos_rur , OUTPUT dT1, OUTPUT dT2).
                           acct_main_pos = tempacct_main_pos_rur.
			   RUN STNDRT_PARAM("�।��", loannum,  2, op.op-date, OUTPUT tempacct_main_pos_rur , OUTPUT dT1, OUTPUT dT2).
                           acct_main_pos = acct_main_pos + tempacct_main_pos_rur.
			   RUN STNDRT_PARAM("�।��", loannum,  46, op.op-date, OUTPUT acct_rsrv_calc_pos , OUTPUT dT1, OUTPUT dT2).
                           acct_rsrv_calc_pos = ABS(acct_rsrv_calc_pos).
			end.


                      find last loan-acct where loan-acct.contract = "�।��" 
                                             and loan-acct.cont-code begins loannum 
                                             and loan-acct.acct-type = main_acct_type NO-LOCK NO-ERROR.
        
                      if not available (loan-acct) then MESSAGE "�� ������� �ਢ離� ��� c ஫��  " + main_acct_type + " ��� �������: " + loannum  VIEW-AS ALERT-BOX.

                      acct_main_no = loan-acct.acct.
                      acct_main_cur = getMainLoanAttr("�।��",loannum,"%currency").


                      acct_main_pos_rur = CurToCur ("�������", acct_main_cur, "", DATE-rasp, acct_main_pos).


                      /* ��।���� ��業��� �⠢�� � ��㯯� �᪠ */
/*                      prrisk = GetCommRate_ULL("%���", (if acct_main_cur = "810" then "" else acct_main_cur), 0, acct_main_no, 0, DATE-rasp, false) * 100.*/
                      prrisk = DEC(ENTRY(1,ofunc:getKRez(ENTRY(1,loannum," "),op.op-date))).
	              amt_delete = 0.
                      amt_create = 0.

			   IF oDoc:acct-db BEGINS "4" THEN
			      ASSIGN
			         amt_delete = amt_delete + oDoc:sum.
			      
			   IF oDoc:acct-cr BEGINS "4" THEN
			      ASSIGN
			         amt_create = amt_create + oDoc:sum.
			      
/*		      end.*/


                      /* ������ ����� १��. �� ᠬ�� ����, �� ������ �믮������ ��楤��� �� 䠪��᪨ 㦥 
                         ��ନ஢���� १�� */
/*                      acct_rsrv_calc_pos = ABS(GetAcctPosValue_UAL(acct_rsrv, "810", oDoc:op-date, traceOn)).*/

                      /* ������ ��ନ஢���� १��. ��᪮��� �ᯮ�殮��� �ନ����� �� 䠪��, �.�. �� �஢�����, �
                         �㬬� ��ନ஢������ १�ࢠ = ���⮪ �� ��� १�ࢠ +- �㬬� �஢���� */
                      acct_rsrv_real_pos = acct_rsrv_calc_pos - amt_create + amt_delete.

                             
                 END.        


/*����� ��������� ����� ����।����� ��ਠ�� ��� ������ �᫨ �㤥� ���� */
          /*       do:
                      /* ������ �������� ������ */
                      client_name = GetAcctClientName_UAL(acct_rsrv, traceOn).

                      /* ������ ���ଠ�� � ������� */
                      loannum = oDoc:getLnkLoanNum().   
                      if NUM-ENTRIES(loannum," ") <> 1 then 
                      do: 
                         loaninf = loannum.
                         loannum = ENTRY(1,loannum," ").
                      end.

                      IF NOT {assigned client_name} THEN  client_name = GetLoanInfo_ULL("�।��",loannum, "client_short_name", false).
                      loaninf = getMainLoanAttr("�।��",loannum,"������� � %cont-code �� %��⠑���").

                      find first loan-acct where loan-acct.contract = "�।��" 
                                             and loan-acct.cont-code = loannum 
                                             and loan-acct.acct = acct_rsrv NO-LOCK NO-ERROR.

                      if not available (loan-acct) then MESSAGE "�� ������� �ਢ離� ��� � ��������! " loannum acct_rsrv VIEW-AS ALERT-BOX.
        
                      main_acct_type = "".
                      if loan-acct.acct-type = "�।���" then main_acct_type = "�।��".
                      if loan-acct.acct-type = "�।���1" then main_acct_type = "�।��". 

                      find last loan-acct where loan-acct.contract = "�।��" 
                                             and loan-acct.cont-code begins loannum 
                                             and loan-acct.acct-type = main_acct_type NO-LOCK NO-ERROR.
        
                      if not available (loan-acct) then MESSAGE "�� ������� �ਢ離� ��� c ஫��  " + main_acct_type + " ��� �������: " + loannum  VIEW-AS ALERT-BOX.

                      acct_main_no = loan-acct.acct.
                      acct_main_cur = getMainLoanAttr("�।��",loannum,"%currency").
                      oAcct = new TAcct (acct_main_no).
                      acct_main_pos = oAcct:getLastPos2Date(op.op-date).

/*ABS(GetAcctPosValue_UAL(acct_main_no, acct_main_cur, oDoc:op-date, traceOn)).*/

                      acct_main_pos_rur = CurToCur ("�������", acct_main_cur, "", DATE-rasp, acct_main_pos).


                      /* ��।���� ��業��� �⠢�� � ��㯯� �᪠ */
                      prrisk = GetCommRate_ULL("%���", (if acct_main_cur = "810" then "" else acct_main_cur), 0, acct_main_no, 0, DATE-rasp, false) * 100.
                      prrisk = DEC(ENTRY(1,ofunc:getKRez(loannum,op.op-date))).
	              amt_delete = 0.
                      amt_create = 0.
		     for each bfropentry where bfropentry.op-date = op.op-date and (bfropentry.acct-db = acct_rsrv or bfropentry.acct-cr = acct_rsrv) NO-LOCK.
			   IF bfropentry.acct-db BEGINS "4" THEN
			      ASSIGN
			         amt_delete = amt_delete + bfropentry.amt-rub.
			      
			   IF bfropentry.acct-cr BEGINS "4" THEN
			      ASSIGN
			         amt_create = amt_create + bfropentry.amt-rub.
			      
		      end.


                      /* ������ ����� १��. �� ᠬ�� ����, �� ������ �믮������ ��楤��� �� 䠪��᪨ 㦥 
                         ��ନ஢���� १�� */
                      acct_rsrv_calc_pos = ABS(GetAcctPosValue_UAL(acct_rsrv, "810", oDoc:op-date, traceOn)).

                      /* ������ ��ନ஢���� १��. ��᪮��� �ᯮ�殮��� �ନ����� �� 䠪��, �.�. �� �஢�����, �
                         �㬬� ��ନ஢������ १�ࢠ = ���⮪ �� ��� १�ࢠ +- �㬬� �஢���� */
                      acct_rsrv_real_pos = acct_rsrv_calc_pos - amt_create + amt_delete.


                 END.        */
                
           END.     
   end.






   /* ����������� �⮣��� �㬬� */
   total_pos = total_pos + acct_main_pos_rur.
   total_pos_rur = total_pos_rur + acct_main_pos.

   ASSIGN
      total_calc_rsrv = total_calc_rsrv + acct_rsrv_calc_pos
      total_real_rsrv = total_real_rsrv + acct_rsrv_real_pos
      total_create_rsrv = total_create_rsrv + amt_create
      total_delete_rsrv = total_delete_rsrv + amt_delete
   .




                                    
/* �᭮���� ⥫� ⠡���� */
  if loaninf <> "" then
     do:
	oTable:addRow().
	oTable:addCell(acct_main_no + " " +  client_name + " " + loaninf).
	oTable:addCell(TRIM(STRING(round(acct_main_pos_rur,2),">>>,>>>,>>>,>>9.99"))).
	oTable:addCell(prrisk).
	oTable:addCell(TRIM(STRING(round(acct_rsrv_calc_pos,2),">>>,>>>,>>>,>>9.99"))).
	oTable:addCell(TRIM(STRING(round(acct_rsrv_real_pos,2),">>>,>>>,>>>,>>9.99"))).
	oTable:addCell(TRIM(STRING(round(amt_create,2),">>>,>>>,>>>,>>9.99"))).
	oTable:addCell(TRIM(STRING(round(amt_delete,2),">>>,>>>,>>>,>>9.99"))).
	
	oTable:addCell(oDoc:acct-db).
	oTable:addCell(oDoc:acct-cr).
    end.
end.
DELETE OBJECT oDoc.

vLnCountInt = vLnCountInt + 1.
useridp = op.user-id.

END.

/*��� 3212 ��砫�*/
FIND FIRST _user WHERE _user._userid = useridp NO-LOCK NO-ERROR.
IF AVAIL _user THEN do:
	useridp = ENTRY(1,_user._user-name," ") + " " + 
		substring(ENTRY(2,_user._user-name," "),1,1) + "." + substring(ENTRY(3,_user._user-name," "),1,1) + ".".
end.
/*��� 3212 �����*/

/* �⮣� */
oTable:addRow().
oTable:addCell("�����:").
oTable:addCell(TRIM(STRING(round(total_pos,2),">>>,>>>,>>>,>>9.99"))).
oTable:addCell("").
oTable:addCell(TRIM(STRING(round(total_calc_rsrv,2),">>>,>>>,>>>,>>9.99"))).
oTable:addCell(TRIM(STRING(round(total_real_rsrv,2),">>>,>>>,>>>,>>9.99"))).
oTable:addCell(TRIM(STRING(round(total_create_rsrv,2),">>>,>>>,>>>,>>9.99"))).
oTable:addCell(TRIM(STRING(round(total_delete_rsrv,2),">>>,>>>,>>>,>>9.99"))).
oTable:addCell("").
oTable:addCell("").




/*oTable:setBorder(1,oTable:height,1,0,1,1).
oTable:setBorder(1,oTable:height - 1,1,0,1,1).
oTable:setAlign(1,oTable:height - 2,"center").*/

oTpl:addAnchorValue("TABLE",oTable).
oTpl:addAnchorValue("date-rasp",date-rasp).
oTpl:addAnchorValue("useridp",useridp).

{setdest.i &cols=220} /* �뢮� � preview */
        oTpl:show().
{preview.i}
DELETE OBJECT oTpl.
/*DELETE OBJECT oTable.    */
DELETE OBJECT ofunc.


{send2arch.i}


{intrface.del}