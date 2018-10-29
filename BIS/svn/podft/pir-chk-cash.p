{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (C) 2012
     Filename: pir-chk-cash.p
      Comment: ����஫� ��室��� ������� ����権 ��� �����
		����⠥� � ࠬ��� ��堭����� ����஢���� ��� (��楤��� ����஫� �� ᬥ�� ����ᮢ)
		� ����䨪��� "��楤��늮���" ��� "�஢�ઠ9"
   Parameters: ��ࠬ���� ��� ��楤��� �஢�ન ���㬥�� � ��楤��� ��ࠢ�� ���쬠
         Uses:
      Created: Sitov S.A., 26.04.2012
	Basis: # 946
     Modified: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>) 
               <���ᠭ�� ���������>                                           
*/
/* ========================================================================= */



{globals.i}
{pir-statcash.i}

DEFINE PARAMETER BUFFER bop FOR op.  
DEFINE BUFFER dop FOR op.  
DEFINE BUFFER dop-entry FOR op-entry. 
 
DEFINE INPUT  PARAMETER iParam  AS CHARACTER NO-UNDO. 

DEFINE OUTPUT PARAMETER oResult AS LOGICAL NO-UNDO INIT YES.    /* YES - ����� ��楤�� ����஫� �ய���� ���㬥�� */


DEFINE VAR oFl		  AS LOGICAL NO-UNDO INIT NO. /* ����� �뤠���� */
DEFINE VAR oFlSymb	  AS LOGICAL NO-UNDO INIT NO. /* ࠧ�� ���ᮢ� ᨬ���� */
DEFINE VAR oSumR	  AS DECIMAL INIT 0  NO-UNDO.
DEFINE VAR oSumV	  AS DECIMAL INIT 0  NO-UNDO.
DEFINE VAR oCur		  AS CHAR    INIT "" NO-UNDO.
DEFINE VAR oAcctDb	  AS CHAR    INIT "" NO-UNDO.
DEFINE VAR oAcctCr	  AS CHAR    INIT "" NO-UNDO.
DEFINE VAR oSymb	  AS CHAR    INIT "" NO-UNDO.
DEFINE VAR tmpOpTransaction   AS INT INIT 0 NO-UNDO.

DEFINE VAR KltrMaxSum AS CHARACTER NO-UNDO.
DEFINE VAR KltrMail   AS CHARACTER NO-UNDO.
DEFINE VAR ParMaxSum AS CHARACTER NO-UNDO.
DEFINE VAR ParMail   AS CHARACTER NO-UNDO.




/* =========================   ����������   ================================= */


KltrMaxSum =  ENTRY(1,iParam,";") .
KltrMail   =  ENTRY(2,iParam,";") .


IF KltrMaxSum = "" OR KltrMail = "" THEN
   MESSAGE "����୮ ������ ��ࠬ���� ��楤��� ����஫� ���㬥�⮢!" VIEW-AS ALERT-BOX.


  /* ��।��塞 �� �����䨪��ࠬ ������� ���祭��: 
	ParMaxSum - ����ᬠ�쭠� �㬬� 
	ParMail - ��६���� ��ࠢ�� ���쬠  */

FIND FIRST code WHERE code.class = "PirSightOP"
	AND code.code = KltrMaxSum
NO-LOCK NO-ERROR.
IF AVAIL code THEN ParMaxSum = code.val.

FIND FIRST code WHERE code.class = "PirSightOP"
	AND code.code = KltrMail
NO-LOCK NO-ERROR.
IF AVAIL code THEN ParMail = code.val.



	/* ������������ �������� */

FOR EACH op-entry OF bop 
	WHERE op-entry.acct-cr BEGINS "20202"
		AND
	      op-entry.acct-db BEGINS "4"
NO-LOCK:

/*message "op-entry " view-as alert-box. */

    IF NOT LOGICAL(FGetSetting("PirChkOpVis","Vs9AllChecks","YES")) THEN 
	LEAVE.

    IF op-entry.op-transaction = tmpOpTransaction THEN LEAVE.
    tmpOpTransaction = op-entry.op-transaction .

	/* �஢�ઠ �� �����⨬���� ���㬥��  */ 	
    IF op-entry.acct-db NE "" AND op-entry.acct-cr BEGINS "20202" THEN 
	DO:
	RUN ChkVerOp(INPUT bop.op-date, INPUT bop.op, INPUT bop.op-transaction,
		    OUTPUT oFl, OUTPUT oFlSymb, OUTPUT oSumR, OUTPUT oSumV, OUTPUT oCur, OUTPUT oAcctDb, OUTPUT oAcctCr, OUTPUT oSymb).
	END.

/*MESSAGE " oFl = "  oFl  VIEW-AS ALERT-BOX.*/

    /* �᫨ � १���� �஢�ન �� �����⨬���� oFl = yes , � ���� ��� �믮����� ᫥���騥 �஢�ન 
	����, �ࠧ� ����頥� �஢����� ���㬥�� � ��ࠢ�塞 ���쬮 */
    IF oFl = YES THEN
	DO:

		/* �஢�ઠ �� �㬬� */ 	
	    IF op-entry.acct-db NE "" AND op-entry.acct-cr BEGINS "20202" THEN 
		DO:
		RUN ChkCashPODFTMaxSum(INPUT oCur, INPUT oSumR, INPUT oSumV, INPUT ParMaxSum, OUTPUT oResult).
		END.

/*message "ChkCashPODFTMaxSum " oResult view-as alert-box.*/
		/* �஢�ઠ �� �᪫�祭�� �� ��ୠ�� ��� */ 
	    IF oResult EQ NO  THEN 
		DO:
		RUN ChkCashPODFTStat(INPUT bop.op-date, INPUT oCur, INPUT oAcctDb, INPUT oSumR, INPUT oSumV, OUTPUT oResult).
		END.

/*message "ChkCashPODFTStat " oResult view-as alert-box.*/
		/* �஢�ઠ �� �᪫�祭�� (�뤠� �।�� ...) */ 
	    IF oResult EQ NO  AND oFlSymb = YES THEN 
		DO:
	        RUN ChkCashPODFTIskl(INPUT oAcctDb, INPUT oAcctCr, INPUT oSymb, INPUT bop.details, OUTPUT oResult).
		END.
/*message "ChkCashPODFTIskl " oResult view-as alert-box.*/
	END.
    ELSE 
	oResult = NO .
/*
MESSAGE 
  " Total oResult = " oResult 
VIEW-AS ALERT-BOX.
*/
	/* �᫨ � �⮣� oResult = NO, � ���뫠���� 㢥�������� �� �ࠡ��뢠��� ��楤��� ����஫� */ 
    IF oResult EQ NO  THEN 
	DO:
	RUN VALUE( STRING(ENTRY(1,ParMail,";")) )(INPUT STRING(ENTRY(2,ParMail,";") + ";" + ENTRY(3,ParMail,";") + ";" + ENTRY(4,ParMail,";") + ";" + STRING(bop.op) + ";" + STRING(bop.op-transaction)  ))  NO-ERROR.
	END.

END.



/* =========================   ���������   ================================= */

PROCEDURE ChkVerOp:
   DEFINE INPUT PARAMETER  iOpOpDate	  AS DATE      NO-UNDO.
   DEFINE INPUT PARAMETER  iOpOp	  AS INTEGER   NO-UNDO.
   DEFINE INPUT PARAMETER  iOpTranz	  AS INTEGER   NO-UNDO.
   DEFINE OUTPUT PARAMETER oFl		  AS LOGICAL NO-UNDO INIT NO. /* ����� �뤠���� */
   DEFINE OUTPUT PARAMETER oFlSymb	  AS LOGICAL NO-UNDO INIT NO. /* ࠧ�� ���ᮢ� ᨬ���� */
   DEFINE OUTPUT PARAMETER oSumR	  AS DECIMAL INIT 0  NO-UNDO.
   DEFINE OUTPUT PARAMETER oSumV	  AS DECIMAL INIT 0  NO-UNDO.
   DEFINE OUTPUT PARAMETER oCur		  AS CHAR    INIT "_" NO-UNDO.
   DEFINE OUTPUT PARAMETER oAcctDb	  AS CHAR    INIT "" NO-UNDO.
   DEFINE OUTPUT PARAMETER oAcctCr	  AS CHAR    INIT "" NO-UNDO.
   DEFINE OUTPUT PARAMETER oSymb	  AS CHAR    INIT "" NO-UNDO.


   DEF VAR cnt  AS INT INIT 0 NO-UNDO.

oSymb = "" .

   FIND FIRST dop 
	WHERE dop.op EQ iOpOP
	AND dop.op-transaction EQ iOpTranz
   NO-LOCK NO-ERROR.
	 
   FOR EACH dop-entry OF dop 
	WHERE dop-entry.acct-db BEGINS "4"
	AND   dop-entry.acct-cr BEGINS "20202"
   NO-LOCK:

	cnt = cnt + 1 .
 /*message " - count = " cnt " " dop-entry.symbol " " dop-entry.amt-rub VIEW-AS ALERT-BOX. */

	IF cnt = 1 THEN 
	DO:
 /*message "1 oFlSymb = " oFlSymb  "  oSymb= " oSymb "  " dop-entry.symbol VIEW-AS ALERT-BOX.*/
	   oSumR = dop-entry.amt-rub  .
	   oSumV = dop-entry.amt-cur  .
	   oCur  = dop-entry.currency .
	   oAcctDb = dop-entry.acct-db .
	   oAcctCr = dop-entry.acct-cr .
	   oSymb = dop-entry.symbol .
/*message "1end oFlSymb = " oFlSymb  "  oSymb= " oSymb "  " dop-entry.symbol VIEW-AS ALERT-BOX.*/
	END.

	IF cnt > 1 
	   AND oCur = dop-entry.currency 
	   AND oAcctDb = dop-entry.acct-db 
	   AND oAcctCr = dop-entry.acct-cr
	THEN
	DO:
/*message "bol 1 oFlSymb = " oFlSymb  "  oSymb= " oSymb "  " dop-entry.symbol VIEW-AS ALERT-BOX.*/
	   oFl = yes .	
	   oSumR = oSumR + dop-entry.amt-rub  .
	   oSumV = oSumV + dop-entry.amt-cur  .

	   IF oSymb = dop-entry.symbol  THEN
		   oFlSymb = yes .	
	   ELSE 
		   oFlSymb = no .	

/*message "bol 1end oFlSymb = " oFlSymb  "  oSymb= " oSymb "  " dop-entry.symbol VIEW-AS ALERT-BOX.*/
	END.

   END.

   IF cnt = 1 THEN 
   DO:
      oFl = yes .	
      oFlSymb = yes .	
   END.
/*
MESSAGE "END_ChkVerOp " 
  "oFl	 " oFl	
  "oSumR " oSumR	
  "oSumV " oSumV	
  "oCur	 " oCur	
  "oAcctDb " oAcctDb	
  "oAcctCr " oAcctCr	
  "oFlSymb " oFlSymb 
VIEW-AS ALERT-BOX.
*/
END PROCEDURE.



PROCEDURE ChkCashPODFTMaxSum:
   DEFINE INPUT PARAMETER  iOpEntrCur     AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  iOpEntrAmtrub  AS DECIMAL   NO-UNDO.
   DEFINE INPUT PARAMETER  iOpEntrAmtcur  AS DECIMAL   NO-UNDO.
   DEFINE INPUT PARAMETER  pParam         AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oResult   AS LOGICAL NO-UNDO INIT YES.

   DEF VAR MaxSumRUB AS DEC NO-UNDO.
   DEF VAR MaxSumUSD AS DEC NO-UNDO.
   DEF VAR MaxSumEUR AS DEC NO-UNDO.

   MaxSumRUB = DEC(ENTRY(1,pParam,";")) .
   MaxSumUSD = DEC(ENTRY(2,pParam,";")) .
   MaxSumEUR = DEC(ENTRY(3,pParam,";")) . 
   
   
   IF MaxSumRUB = ? OR MaxSumUSD = ? OR MaxSumEUR = ?  THEN
     DO:
   	MESSAGE "�� ������ ����� ��� �������� !!!" VIEW-AS ALERT-BOX.
   	RETURN.
     END.

   CASE iOpEntrCur:
      WHEN "" THEN DO:
	IF (iOpEntrAmtrub ) > MaxSumRUB THEN oResult = NO .
      END.	
      WHEN "840" THEN DO:
	IF (iOpEntrAmtcur ) > MaxSumUSD THEN oResult = NO .
      END.
      WHEN "978" THEN DO:
	IF (iOpEntrAmtcur ) > MaxSumEUR THEN oResult = NO .
      END.
   END CASE.    
/*
 MESSAGE "END_ChkCashPODFTMaxSum = " oResult VIEW-AS ALERT-BOX.
*/
END PROCEDURE.


PROCEDURE ChkCashPODFTStat:
   DEFINE INPUT PARAMETER  iOpDate        AS DATE      NO-UNDO.
   DEFINE INPUT PARAMETER  iOpEntrCur     AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  iAcctDb  	  AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  iOpEntrAmtrub  AS DECIMAL   NO-UNDO.
   DEFINE INPUT PARAMETER  iOpEntrAmtcur  AS DECIMAL   NO-UNDO.
   DEFINE OUTPUT PARAMETER oResult   AS LOGICAL NO-UNDO INIT NO.

   DEF VAR pOpDate AS CHAR  NO-UNDO.
   DEF VAR pCdCode AS CHAR  NO-UNDO.
   DEF VAR begCdCode AS CHAR  NO-UNDO.
   DEF VAR pKlID AS CHAR NO-UNDO.
   DEF VAR pCurr AS CHAR NO-UNDO.
   DEF VAR pSum  AS DEC  NO-UNDO.

   DEF BUFFER pbcode  FOR code.

   pOpDate = CreateStrOpDtStCash(iOpDate) .
   pCdCode = CreateCdCodeStCash(iAcctDb, pOpDate) .
   begCdCode = ENTRY(1,pCdCode,"_") + "_" + ENTRY(2,pCdCode,"_") + "_" 
	   + ENTRY(3,pCdCode,"_") + "_" + ENTRY(4,pCdCode,"_") + "_"   
	   + ENTRY(5,pCdCode,"_") .

   FIND FIRST acct WHERE acct.acct = iAcctDb NO-LOCK NO-ERROR.

   IF AVAIL(acct) THEN
     DO:
	pKlID = STRING(acct.cust-id) .
	IF iOpEntrCur = "" THEN 
	  DO:
	    pCurr = "810" .
	    pSum = iOpEntrAmtrub .
	  END.
	ELSE 
	  DO:
	    pCurr = iOpEntrCur .
	    pSum = iOpEntrAmtCur .
	  END.
     END.

   FOR EACH pbcode 
	WHERE pbcode.class  EQ 'PirStatCash' 
	AND pbcode.parent EQ pOpDate  
	AND pbcode.code   BEGINS begCdCode 
   NO-LOCK:

	IF AVAIL(pbcode) THEN
	  DO:                   
		IF      ENTRY(1,pbcode.name,";") = iAcctDb 
		   AND  DEC(ENTRY(2,pbcode.name,";")) >= pSum   
		   AND  ENTRY(2,pbcode.description[1],";") = "ACT"
		   AND  ( 
			  ( ENTRY(1,pbcode.val,";") = "����������" AND  ENTRY(1,pbcode.description[1],";") = "1" )
			  OR
			  ( ENTRY(1,pbcode.description[1],";") = "1" AND  ENTRY(4,pbcode.name,";") = "RUK" )
			)		
		THEN
		DO:
		  /* ���塞 ����� ��� � ��ୠ�� ��� */
		   FOR FIRST code 
			WHERE code.class  EQ 'PirStatCash' 
			AND code.parent EQ pOpDate
			AND code.code   BEGINS pbcode.code
		   EXCLUSIVE-LOCK:
			code.val = EditCdValStCash("��������","") .
			code.name = EditCdNameStCash(code.name,"KAS","","") .		
			code.description[1] = "0;NOACT;" + ENTRY(3,code.description[1],";") + ";" . /* �ਧ���, �� 㦥 ����� �뤠���� � �� ��� 㦥 ����⨢��� */
		   END.

		   oResult = YES .
	
		END.
	  END.

   END.
/*
 MESSAGE "END_ChkCashPODFTStat = " oResult VIEW-AS ALERT-BOX. 
*/
END PROCEDURE.


PROCEDURE ChkCashPODFTIskl:
   DEFINE INPUT PARAMETER  iAcctDb     AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  iAcctCr     AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  iOpEntrSymb AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  iOpDetails  AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oResult   AS LOGICAL NO-UNDO INIT YES.


	/*  ����, ��� �।�⢠ � ��� */
   IF iAcctDb BEGINS "202" AND iAcctCr BEGINS "20202" THEN
	DO:
	LEAVE.
	END.


/*** ����४�஢��� �� �襭��, �ਭ�⮬� �� ᮢ�頭�� 12/05/12 ***/
	/*  �뤠� ������� ��אַ �१ ����� */
   IF (iAcctDb BEGINS "423") AND (NOT(iAcctDb BEGINS "42301")) AND (iAcctCr BEGINS "20202") THEN
	DO:
	LEAVE.
	END.


	/* �뤠� �।���� �।�� �१ ����� - ��।�-�� �� ���.ᨬ���� */
	/* 54 - �뤠� ������ � �।�⮢ */
   IF iOpEntrSymb = "54" 
      AND iAcctCr BEGINS "20202" 
      AND CAN-DO("40817,40820,42301,42601",SUBSTRING(iAcctDB,1,5) )
      AND iOpDetails MATCHES "*�।��*"
   THEN
	DO:
	LEAVE.
	END.


	/* �᫨ �஢���� �� ������ �� ��� ���� �� �᪫�祭��,
	� ��室�� � �ਧ����� oResult = NO - �.�. �������� ��� ����஫� � ���뫠���� ���쬮 */ 
   oResult = NO .

/*
 message "END_ChkCashPODFTIskl = " oResult view-as alert-box. 
*/

END PROCEDURE.
