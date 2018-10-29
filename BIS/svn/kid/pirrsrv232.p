{pirsavelog.p}

/* 
		��ᯮ�殮��� �� १�ࢠ� 232-�
		���� �.�. 10.01.2006 10:19
		
		�᫮�����, �� ��㧥� ��࠭� ⮫쪮 "�ࠢ����" ���㬥���, �.�. �,
		����� ������ �⮡ࠦ����� � �����饬 �ᯮ�殮���.
*/

/* �������塞 �������� ����ன��*/
{globals.i}
{intrface.get count}

/* ������⥪� �㭪権 ��� ࠡ��� � ��⠬� */
{ulib.i}

{getdate.i}

{tmprecid.def}

/* �뢮� � preview */
&IF DEFINED(arch2)<>0 &THEN
 &GLOBAL-DEFINE wsd 1
 {pir-out2arch.i} 
 if USERID("bisquit") begins "02" then 
 curr-user-inspector = FGetSetting("PirEArch","RepInspCredit",?). /* #3718 */
&ENDIF

/** ����������� **/

DEF INPUT PARAM inParam AS CHAR.
/* ��� १�ࢠ: ��।���� � ��࠭�� ��� � �⮩ ��६����� */
DEF VAR acct_rsrv AS CHAR NO-UNDO.
/* ��������ᮢ� ���, ����� �������� � ���� �⮫��� */
DEF VAR acct_main_no  AS CHAR NO-UNDO.
DEF VAR acct_main_cur AS CHAR NO-UNDO.
/* ������ �� ���� */
DEF VAR acct_main_pos      AS DECIMAL  NO-UNDO.
DEF VAR acct_main_pos_rur  AS DECIMAL  NO-UNDO.
DEF VAR acct_rsrv_calc_pos AS DECIMAL  NO-UNDO.
DEF VAR acct_rsrv_real_pos AS DECIMAL  NO-UNDO.

/* �㬬� ����樨 */
DEF VAR amt_create AS DECIMAL NO-UNDO.
DEF VAR amt_delete AS DECIMAL NO-UNDO.

DEF VAR client_name AS CHAR NO-UNDO.
DEF VAR loaninf AS CHAR     NO-UNDO.
DEF VAR grrisk AS CHARACTER init ? NO-UNDO.
DEF VAR prrisk AS DECIMAL   init 0 NO-UNDO.
DEF VAR prrisk2 AS DECIMAL  NO-UNDO.

/* �⮣��� ���祭�� */
DEF VAR total_pos_rur AS DECIMAL NO-UNDO.
DEF VAR total_pos_usd AS DECIMAL NO-UNDO.
DEF VAR total_pos_eur AS DECIMAL NO-UNDO.
DEF VAR total_calc_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_real_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_create_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_delete_rsrv AS DECIMAL NO-UNDO.
/* �뢮� �訡�� �� ��࠭ */
DEF VAR traceOn AS LOGICAL INITIAL false NO-UNDO.
/* �६����� ��� ࠡ��� */
DEF VAR tmpStr AS CHAR NO-UNDO.
/* �������� � ������ */
DEF VAR PIRbos AS CHAR    NO-UNDO.
DEF VAR PIRbosFIO AS CHAR NO-UNDO.
DEF VAR userPost AS CHAR  NO-UNDO.
DEF VAR PIRtarget AS CHAR NO-UNDO.
DEF VAR PIRispl AS CHAR   NO-UNDO.


DEF VAR oTable AS TTable NO-UNDO.
DEF VAR oTpl   AS TTpl   NO-UNDO.
DEF VAR ofunc  AS tfunc  NO-UNDO.

oTpl = new TTpl("pirrsrv232.tpl").
oTable = new TTable(12).
oTable:decFormat = "->>>,>>>,>>9.99".

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


/** ���������� **/

/* �� ��ࢮ� ����樨 ������ ���� ���� */
DATE-rasp = TODAY.
FOR FIRST tmprecid NO-LOCK,
		FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK
		:
		DATE-rasp = op.op-DATE.
END.

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
	IF op-entry.acct-db BEGINS "4" OR op-entry.acct-db BEGINS "6" OR op-entry.acct-db BEGINS "3" THEN ASSIGN acct_rsrv = op-entry.acct-db amt_delete = amt-rub.
	IF op-entry.acct-cr BEGINS "4" OR op-entry.acct-cr BEGINS "6" OR op-entry.acct-cr BEGINS "3" THEN ASSIGN acct_rsrv = op-entry.acct-cr amt_create = amt-rub.

	/* �᫨ ��-⠪� �� �� ������, �� �� �।��� ���, ��稭��騩�� �� 4 �� ������, 
	   �뤠�� ᮮ�饭�� � ��室�� �� ��楤��� */
	IF acct_rsrv = "" THEN 
		DO:
			MESSAGE "� �஢���� ���㬥�� " + op.doc-num + " ��� ��� १�ࢠ, ��稭��饣��� �� 4!" VIEW-AS ALERT-BOX.
			RETURN.
		END.
	/* �����᭮ ॠ����樨 १�ࢨ஢���� 232-� � ��������, ����� ��� ������ ���� �ਢ易� 
		 � ��������ᮢ��� ���� �१ �������⥫��� ��� � ����� 80. �஢�ਬ ����⢮����� ������ �裡 */

	FOR EACH links WHERE
		links.link-id = 80
		AND
		ENTRY(1, links.target-id) = acct_rsrv NO-LOCK,
        FIRST acct WHERE 
			acct.acct = ENTRY(1,links.source-id)
			AND
			(acct.close-date = ? OR acct.close-date>DATE-rasp)
		NO-LOCK:


	IF AVAIL links THEN 
		/* �᫨ ��� �������, � ��࠭�� ����� � ������ ��������ᮢ��� ��� */
		DO:
			acct_main_no = ENTRY(1,links.source-id).
			acct_main_cur = ENTRY(2,links.source-id).
			IF acct_main_cur = "" THEN acct_main_cur = "810".
			LEAVE.
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

			END. 
                        ELSE 
                        DO:

				MESSAGE "��� १�ࢠ " + acct_rsrv + " �� �ਢ易� �� �१ ���.���, �� �१ ������� � '��������' ����!" VIEW-AS ALERT-BOX.
				RETURN.

			END.

		END.
            END. /* ����� �� �ᥬ ��� */

	 /* ������ ���⮪ �� ��������ᮢ��� ���� �� ���� */
	 acct_main_pos     = ABS(GetAcctPosValue_UAL(acct_main_no, acct_main_cur, op.op-DATE, traceOn)).

	 /** ���� ᯮᮡ 
	 acct_main_pos_rur = ABS(GetAcctPosValue_UAL(acct_main_no, "810", op.op-DATE, traceOn)).
	 */
	 /** ���� ᯮᮡ */

	 IF acct_main_cur <> "" AND acct_main_cur <> "810"  THEN DO:
	 	/** find the rate */
		 FIND LAST instr-rate WHERE 
		 	instr-rate.instr-code = acct_main_cur AND
	 		instr-rate.rate-type = "�������" AND
		 	instr-rate.since <= op.op-date
		 	NO-LOCK NO-ERROR.
		 IF AVAIL instr-rate THEN DO:
		 	acct_main_pos_rur = acct_main_pos * rate-instr.
		 END. ELSE DO:
		 	MESSAGE "�� ������ ���� ��� ������ " + acct_main_cur + " �� ���� " + STRING(op.op-date) VIEW-AS ALERT-BOX.
		 	RETURN.
		 END.
	END. ELSE DO:
		acct_main_pos_rur = acct_main_pos.
	END.
	 	
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
	 /* ����� ᪮� ����������� 
	 IF acct_main_cur = "978" THEN
	   total_pos_eur = total_pos_eur + acct_main_pos.
	 */
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
	       	   client_name = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", false).
	       	 loaninf = (IF loan.contract = "���" THEN loan.doc-num ELSE loan.cont-code) + " �� ". 
				   /* prrisk = loan.risk. */
				   /*
				   prrisk2 = GetCommRate_ULL("%���", (if acct_main_cur="810" then "" else acct_main_cur), 0.00, acct_main_no, 0, op.op-date, traceOn).
				   prrisk = prrisk2 * 100.
				   */
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

	 /* ������ ��業��� �⠢��. ���᫨� �� ��� ��⭮� �� ������� ���⭮�� १�ࢠ �� �㡫��� ���⮪ 
	    ��������ᮢ��� ��� 
	 */	 
/*	 prrisk = ROUND(acct_rsrv_calc_pos / acct_main_pos_rur, 2) * 100. */
	 /* ������ ��業��� �⠢��. ��� �࠭���� � ���.४����� ��������ᮢ��� ��� */
	 
	 /*
	 tmpStr = GetXAttrValueEx("acct",acct_main_no + "," + (if acct_main_cur="810" then "" else acct_main_cur),"pers-reserve","").
	 IF tmpStr <> "" THEN
	 		prrisk = DECIMAL(tmpStr).
	 		
	 */

		/*** ��� #827 Sitov S.A. 			  ***/
		/*** ������� ��।������ ��.�⠢�� � ��㯯� �᪠ ***/
	 if avail loan and loan.contract = "���" then
	      DO:
	 	 prrisk = GetCommRate_ULL("%���", (if acct_main_cur = "810" then "" else acct_main_cur), 0, acct_rsrv, 0, end-date, false) * 100.

/*		   /* ��।���� ��㯯� �᪠ �� ��業⭮� �⠢�� � ����襬 � �ଠ� grrisk = "���⠢��,����᪠" */
		 IF prrisk = 0 THEN grrisk = STRING(prrisk) + ",1" .
		 IF prrisk >= 1 AND prrisk <= 20 THEN grrisk = STRING(prrisk) + ",2" .
		 IF prrisk > 20 AND prrisk <= 50 THEN grrisk = STRING(prrisk) + ",3" .
		 IF prrisk > 50 AND prrisk < 100 THEN grrisk = STRING(prrisk) + ",4" .
		 IF prrisk = 100 THEN grrisk = STRING(prrisk) + ",5".*/
	      END.
	 else
	if available loan then
		grrisk = ofunc:getKRez(loan.cont-code,op-entry.op-date).
	else do:
		prrisk = ROUND(acct_rsrv_calc_pos / acct_main_pos_rur, 2) * 100.
		if prrisk eq ? then prrisk = 100.
		find first acct where acct.acct eq acct_rsrv.
		if available acct then client_name = acct.details. else client_name = "".
		loaninf = "".
	end.

   /* ��।���� ��㯯� �᪠ �� ��業⭮� �⠢�� � ����襬 � �ଠ� grrisk = "���⠢��,����᪠" */

if grrisk = ? then do:
		 IF prrisk = 0 THEN grrisk = STRING(prrisk) + ",1" .
		 IF prrisk >= 1 AND prrisk <= 20 THEN grrisk = STRING(prrisk) + ",2" .
		 IF prrisk > 20 AND prrisk <= 50 THEN grrisk = STRING(prrisk) + ",3" .
		 IF prrisk > 50 AND prrisk < 100 THEN grrisk = STRING(prrisk) + ",4" .
		 IF prrisk = 100 THEN grrisk = STRING(prrisk) + ",5".
end.
	 if acct_main_pos_rur < 0 then acct_main_pos_rur = 0.

oTable:addRow().
oTable:addCell(client_name + " " + loaninf).
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
oTable:addCell("").
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


oTable:setBorder(1,oTable:height,1,0,1,1).
oTable:setBorder(1,oTable:height - 1,1,0,1,1).

oTable:setAlign(1,oTable:height - 2,"center").

oTpl:addAnchorValue("TABLE",oTable).
oTpl:addAnchorValue("date-rasp",date-rasp).


{setdest.i}
 oTpl:show().
{preview.i}

DELETE OBJECT oTpl.
{send2arch.i}