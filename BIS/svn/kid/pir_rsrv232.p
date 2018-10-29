{pirsavelog.p}

/* 
                ��ᯮ�殮��� �� १�ࢠ� 232-�
                ���� �.�. 10.01.2006 10:19
                
                �᫮�����, �� ��㧥� ��࠭� ⮫쪮 "�ࠢ����" ���㬥���, �.�. �,
                ����� ������ �⮡ࠦ����� � �����饬 �ᯮ�殮���.
*/

/* �������塞 �������� ����ன��*/
{globals.i}

/* ������⥪� �㭪権 ��� ࠡ��� � ��⠬� */
{ulib.i}
{get-bankname.i}


{intrface.get instrum}
{intrface.get count}
{tmprecid.def}


{getdate.i}

/* �뢮� � preview */


/** ����������� **/

DEF INPUT PARAM inParam AS CHAR.
/* ��� १�ࢠ: ��।���� � ��࠭�� ��� � �⮩ ��६����� */
DEF VAR acct_rsrv AS CHAR NO-UNDO.
/* ��������ᮢ� ���, ����� �������� � ���� �⮫��� */
DEF VAR acct_main_no  AS CHAR NO-UNDO.
DEF VAR acct_main_cur AS CHAR NO-UNDO.
/* ������ �� ���� */
DEF VAR acct_main_pos AS DECIMAL NO-UNDO.
DEF VAR acct_main_pos_rur AS DECIMAL NO-UNDO.
DEF VAR acct_rsrv_calc_pos AS DECIMAL NO-UNDO.
DEF VAR acct_rsrv_real_pos AS DECIMAL NO-UNDO.

/* �㬬� ����樨 */
DEF VAR amt_create AS DECIMAL NO-UNDO.
DEF VAR amt_delete AS DECIMAL NO-UNDO.

DEF VAR client_name AS CHAR NO-UNDO.
DEF VAR loaninf AS CHAR NO-UNDO.
DEF VAR grrisk AS CHARACTER NO-UNDO.

DEF VAR prrisk AS CHARACTER NO-UNDO.
DEF VAR prrisk2 AS DECIMAL NO-UNDO.

/* �⮣��� ���祭�� */
DEF VAR total_pos_rur AS DECIMAL NO-UNDO.
DEF VAR total_pos_usd AS DECIMAL NO-UNDO.
DEF VAR total_pos_eur AS DECIMAL NO-UNDO.
DEF VAR total_calc_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_real_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_create_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_delete_rsrv AS DECIMAL NO-UNDO.
/* �뢮� �訡�� �� �࠭ */
DEF VAR traceOn AS LOGICAL INITIAL false NO-UNDO.
/* �६����� ��� ࠡ��� */
DEF VAR tmpStr AS CHAR NO-UNDO.
/* �������� � ������ */
DEF VAR PIRbos AS CHAR NO-UNDO.
DEF VAR PIRbosFIO AS CHAR NO-UNDO.
DEF VAR userPost AS CHAR NO-UNDO.
DEF VAR PIRtarget AS CHAR NO-UNDO.
DEF VAR PIRispl AS CHAR NO-UNDO.

def var ofunc as tfunc.

DEF VAR oTable AS TTable    NO-UNDO.
DEF VAR oAcct   AS TAcct    NO-UNDO.

DEF VAR total_pos_in_rur AS DECIMAL INITIAL 0 NO-UNDO.
DEF VAR oTpl AS TTpl NO-UNDO.

&IF DEFINED(arch2)<>0 &THEN
{pir-out2arch.i}
curr-user-inspector = FGetSetting("PirEArch","RepInspCredit",?). /* #3718 */
&ENDIF

/*{tpl.create}*/

oTpl = new TTpl("pir_rsrv232.tpl").

oTable = new TTable(12).

oTable:decFormat = "->>>,>>>,>>9.99".
/*
oTable:breakonRows = 34.
oTable:lastpageRows = 3.
*/

ofunc = new tfunc().
DEF BUFFER bfrLoanAcct1 FOR loan-acct.

/** �஢�ઠ �室�饣� ��ࠬ��� */
IF NUM-ENTRIES(inParam) < 2 THEN DO:
  MESSAGE "�������筮� ���-�� ��ࠬ��஢. ������ ���� <���_���㬥��>,<���_�㪮����⥫�_��_PIRBoss>,<�_�����⠬���>,<�ᯮ���⥫�>" 
          VIEW-AS ALERT-BOX.
  RETURN.
END.

PIRbos = ENTRY(1,FGetSetting("PIRboss",ENTRY(2, inParam),"")).
PIRbosFIO = ENTRY(2,FGetSetting("PIRboss",ENTRY(2, inParam),"")).


/*18/06/09 Ermilov V.N. */
ASSIGN PIRtarget = "" PIRispl = "" .


IF NUM-ENTRIES(inParam) = 4 THEN 
DO:
        PIRtarget = ENTRY(3, inParam).
        PIRispl = ENTRY(4, inParam).
END.

/* ��� �ᯮ�殮��� */
DEF VAR DATE-rasp AS DATE.
{tmprecid.def}

/** ���������� **/

/* �� ��ࢮ� ����樨 ������ ���� ���� */
DATE-rasp = gend-date.
  
  oTpl:addAnchorValue("PIRtarget",PIRtarget).
  oTpl:addAnchorValue("BANK",cBankName).
  oTpl:addAnchorValue("date-rasp",STRING(DATE-rasp,"99/99/9999")).


/* ��� ��� ���㬥�⮢, ��࠭��� � ��o㧥� �믮��塞... */
FOR EACH tmprecid 
         NO-LOCK,
   FIRST op WHERE 
         RECID(op) EQ tmprecid.id 
         NO-LOCK, 
   FIRST op-entry OF op
         NO-LOCK
: 
        
        ASSIGN amt_create = 0 amt_delete = 0.
        /* ������ ��� १�ࢠ � �஢����. �� ���� �� ������, ���� �� �।��� � ��稭����� � 4 
           ����⭮ ��࠭�� ���祭�� �㬬� �஢���� � ᮮ⢥�������� ��६����� 
        */
        IF op-entry.acct-db BEGINS "4" THEN         ASSIGN acct_rsrv = op-entry.acct-db  amt_delete = amt-rub.
        IF op-entry.acct-cr BEGINS "4" THEN 	    ASSIGN acct_rsrv = op-entry.acct-cr  amt_create = amt-rub.

        /* �᫨ ��-⠪� �� �� ������, �� �� �।��� ���, ��稭��騩�� �� 4 �� ������, 
           �뤠�� ᮮ�饭�� � ��室�� �� ��楤��� */

        IF acct_rsrv = "" THEN 
                DO:
                        MESSAGE "� �஢���� ���㬥�� " + op.doc-num + " ��� ��� १�ࢠ, ��稭��饣��� �� 4!" VIEW-AS ALERT-BOX.
                        RETURN.
                END.
        /* �����᭮ ॠ����樨 १�ࢨ஢���� 232-� � ��������, ����� ��� ������ ���� �ਢ易� 
                 � ��������ᮢ��� ���� �१ �������⥫��� ��� � ����� 80. �஢�ਬ ����⢮����� ������ �裡 */
        FIND FIRST links WHERE
                links.link-id = 80
                AND
                ENTRY(1, links.target-id) = acct_rsrv
                NO-LOCK NO-ERROR.

        IF AVAIL links THEN 
                /* �᫨ ��� �������, � ��࠭�� ����� � ������ ��������ᮢ��� ��� */
                DO:
                        acct_main_no = ENTRY(1,links.source-id).
                        acct_main_cur = ENTRY(2,links.source-id).
                        IF acct_main_cur = "" THEN acct_main_cur = "810".
                END.
        ELSE
                /* ���� 
                   ��⠥��� ���� "������" ��� �१ ������� ��� 
                   �뤠�� ᮮ�饭�� �� �訡�� � �����蠥� ࠡ��� ��楤��� */
                DO:
                        
                        FIND FIRST bfrLoanAcct1 WHERE 
                                bfrLoanAcct1.acct = acct_rsrv
                                AND
                                bfrLoanAcct1.contract = "�।��"
                        NO-LOCK NO-ERROR.

                        IF AVAIL bfrLoanAcct1 THEN DO:
                                /** �᫨ ��� �ਢ易� � ��������, � �㦭� �஠������஢��� ��� ஫�.
                                    ������ ᮮ⢥�⢨� ஫�� ��� १�ࢠ � "��������"
                                    
                                    �।����� ....... �।��%,�।��%�
                                    �।����  ....... �।�,�।�� 
                                */
                                
                                IF bfrLoanAcct1.acct-type = "�।�����" THEN DO:
                                        acct_main_no = GetLoanAcct_ULL(bfrLoanAcct1.contract,
                                                                       bfrLoanAcct1.cont-code,
                                                                       "�।��%",
                                                                       op.op-date,
                                                                       false).
                                END.                                        
                                IF bfrLoanAcct1.acct-type = "�।����" THEN DO:

                                	
                                        acct_main_no = GetLoanAcct_ULL(bfrLoanAcct1.contract,
                                                                       bfrLoanAcct1.cont-code,
                                                                       "�।�",
                                                                       op.op-date,
                                                                       false).

                                END.                                        
                                acct_main_cur = SUBSTR(acct_main_no, 6, 3).

                        END. ELSE DO:

                                MESSAGE "��� १�ࢠ " + acct_rsrv + " �� �ਢ易� �� �१ ���.���, �� �१ ������� � '��������' ����!" VIEW-AS ALERT-BOX.
                                RETURN.

                        END.

                END.
        

         /*****************************************************
          * ��室�� ���⮪ �� ���� ���� ���᫥��� 	      *
          * १�ࢠ � �㡫��.				      *
          *****************************************************
          * ��� ᮧ�����:				      *
          * ����:   ��᫮� �. �.          		      *
          * ���: #784				      *
          *****************************************************/
         
	 oAcct = new TAcct(acct_main_no).
	         acct_main_pos        =  oAcct:getLastPos2Date(op.op-date,"�").
              if acct_main_cur <> "810" THEN  acct_main_pos_rur = CurToCur ("�������", acct_main_cur, "", op.op-date, acct_main_pos).
              else   acct_main_pos_rur = acct_main_pos.

              
/*		 acct_main_pos_rur     =  oAcct:getLastPos2Date(op.op-date,"�",810).*/

	 DELETE OBJECT oAcct.
	 
        
         /* ������ ����� १��. �� ᠬ�� ����, �� ������ �믮������ ��楤��� �� 䠪��᪨ 㦥 
            ��ନ஢���� १��
         */
         acct_rsrv_calc_pos = ABS(GetAcctPosValue_UAL(acct_rsrv, "810", op.op-DATE, traceOn)).
         
         /* ������ ��ନ஢���� १��. ��᪮��� �ᯮ�殮��� �ନ����� �� 䠪��, �.�. �� �஢�����, �
                   �㬬� ��ନ஢������ १�ࢠ = ���⮪ �� ��� १�ࢠ +- �㬬� �஢���� 
         */
         acct_rsrv_real_pos = acct_rsrv_calc_pos - amt_create + amt_delete.
         
         /* ����������� �⮣��� �㬬� */
         IF acct_main_cur = "810" THEN
           total_pos_rur = total_pos_rur + acct_main_pos.
         IF acct_main_cur = "840" THEN
           total_pos_usd = total_pos_usd + acct_main_pos.
         /* ����� ᪮� �����������  */
         IF acct_main_cur = "978" THEN
           total_pos_eur = total_pos_eur + acct_main_pos.

         ASSIGN  
           total_calc_rsrv = total_calc_rsrv + acct_rsrv_calc_pos
           total_real_rsrv = total_real_rsrv + acct_rsrv_real_pos
           total_create_rsrv = total_create_rsrv + amt_create
           total_delete_rsrv = total_delete_rsrv + amt_delete.
         
         /* ������ �������� ������ */
         client_name = GetAcctClientName_UAL(acct_rsrv, traceOn).
         
         /* ������ ���ଠ�� � ������� */
         FIND FIRST loan-acct WHERE
                         loan-acct.acct = acct_rsrv
                         AND
                         CAN-DO("�।��,���", loan-acct.contract) 
                         NO-LOCK NO-ERROR.
         IF AVAIL loan-acct THEN
           DO:
             FIND FIRST loan WHERE
               loan.contract = loan-acct.contract
               AND
               loan.cont-code = loan-acct.cont-code
               NO-LOCK NO-ERROR.
             IF AVAIL loan THEN
               DO:
                        IF client_name = "" THEN 
                          client_name = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", false).
                        loaninf = (IF loan.contract = "���" THEN loan.doc-num ELSE loan.cont-code) + " �� ". 


                                   FIND FIRST signs WHERE  
                                                                        signs.code = "��⠑���"
                                                                        AND 
                                                                        signs.file-name = "loan"
                                                                        AND 
                                                                        signs.surrogate = "�।��," + loan.cont-code
                                                                        NO-LOCK NO-ERROR.
                                         IF AVAIL signs THEN
                                           DO:
                                                         loaninf = loaninf + signs.code-value.
                                                 END.
                                         ELSE
                                                  DO:
                                                   loaninf = loaninf + STRING(loan.open-DATE,"99/99/9999").
                                                 END.
               END.
           END.
   ELSE 
                  loaninf = "�� ��।����".

        

/*          grrisk = GetLoanInfo_ULL(loan.contract,loan.cont-code,"gr_riska",false).
          prrisk = GetLoanInfo_ULL(loan.contract,loan.cont-code,"risk",false).*/
          grrisk = "".
          grrisk = ofunc:getKRez(loan.cont-code,op-entry.op-date).

if acct_main_pos_rur < 0 then acct_main_pos_rur = 0.

total_pos_in_rur = total_pos_in_rur + acct_main_pos_rur.

oTable:addRow().
oTable:addCell(acct_main_no + " " + client_name + " " + loaninf).
oTable:addCell(acct_main_pos).
oTable:addCell(acct_main_cur).
oTable:addCell(acct_main_pos_rur).
oTable:addCell(Entry(2,grrisk)).
oTable:addCell(Entry(1,grrisk)).
oTable:addCell(acct_rsrv_calc_pos).
oTable:addCell(acct_rsrv_real_pos).
oTable:addCell(amt_create).
oTable:addCell(amt_delete).

oTable:addCell(op-entry.acct-db).
oTable:addCell(op-entry.acct-cr).

END.


/* �⮣� */
oTable:addRow().
oTable:addCell("�����:").
oTable:addCell(total_pos_rur).
oTable:addCell("810").
oTable:addCell(total_pos_in_rur).
oTable:addCell("").
oTable:addCell("").
oTable:addCell(total_calc_rsrv).
oTable:addCell(total_real_rsrv).
oTable:addCell(total_create_rsrv).
oTable:addCell(total_delete_rsrv).
oTable:addCell("").
oTable:addCell("").

oTable:addRow().
oTable:addCell("").
oTable:addCell(total_pos_usd).
oTable:addCell("840").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").

oTable:addRow().
oTable:addCell("").
oTable:addCell(total_pos_eur).
oTable:addCell("978").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").

oTable:setAlign(1,oTable:height - 2,"center").


/* ������ � ������� */


IF PIRispl = "" 
THEN DO:

        FIND FIRST _user WHERE _user._userid EQ userid NO-LOCK NO-ERROR.
        IF AVAIL _user THEN DO:
                userPost = GetXAttrValueEx("_user", _user._userid, "���������", "").	        
		oTpl:addAnchorValue("USER_POST",userPost).
	        oTpl:addAnchorValue("USER_NAME",_user._user-name).
        END.
        ELSE
	        oTpl:addAnchorValue("USER_POST","�ᯮ���⥫�:").
END.
ELSE         IF PIRispl <> '0' THEN do:
	        oTpl:addAnchorValue("USER_POST","�ᯮ���⥫�:").
	        oTpl:addAnchorValue("USER_NAME",_user._user-name).
		end.

oTpl:addAnchorValue("Table1",oTable).
oTpl:addAnchorValue("date-rasp",DATE-rasp).

{setdest.i &cols=275 &custom = " IF YES THEN 0 ELSE "}
oTpl:show().
{preview.i}

{send2arch.i}

{tpl.delete}

{intrface.del}