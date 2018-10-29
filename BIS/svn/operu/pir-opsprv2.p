/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: ��� �� "�P��������������"
     Filename: pir-pko.p
      Comment: ���� �� ����⥪�� 1 & 2
   Parameters: 
         Uses: Globals.I tmprecid.def SetDest.I Signatur.I Preview.I
      Used by: -
      Created: 20/10/2008 Templar
     Modified:
*/

{globals.i}

{get-bankname.i}

DEFINE VAR i	as int  no-undo.
DEFINE VAR client_id	as int  no-undo.

DEFINE VAR ost_kart1	as int  no-undo.
DEFINE VAR ost_kart2	as int  no-undo.

DEFINE VAR ost_acct	 	as decimal  no-undo.
DEFINE VAR vost_acct	as decimal  no-undo.

DEFINE VAR date1		as date  no-undo.

DEFINE VAR v_racct	as char  no-undo.
DEFINE VAR v_currency 	as char  no-undo.

DEFINE VAR v_kart1	as char  no-undo.
DEFINE VAR v_kart2	as char  no-undo.
DEFINE VAR client_nm	as char  no-undo.
DEFINE VAR client_cat	as char  no-undo.
DEFINE var summaStr as char extent 2 no-undo.
DEFINE var summastr2 as char  no-undo.
DEFINE VAR search_k1 as char no-undo.
DEFINE VAR search_k2 as char no-undo.

DEF VAR posDate AS DATE NO-UNDO.

DEFINE BUFFER accct FOR acct.


/*-------------------------------------- Main ------------------------------------------------------------------*/

{sh-defs.i}

{tmprecid.def}

DEFINE INPUT PARAM date2 AS DATE NO-UNDO.
MESSAGE "������ ����" UPDATE date2 .


/**
 * �� ��� #1289
 * ���⮪ ������ ���� �� ���.
 **/
posDate = date2 - 1.


/***********
�㭪樮��� ��� ࠡ��� �� ��㧥� �����⮢


FOR EACH tmprecid NO-LOCK,
FIRST cust-corp WHERE RECID(cust-corp) = tmprecid.id NO-LOCK: 

 IF AVAIL cust-corp THEN 
	DO:

	client_id = cust-corp.cust-id.
	client_nm = cust-corp.cust-stat + ' ' + cust-corp.name-short.
	ost_acct = 0.


 	FIND FIRST acct WHERE  acct.cust-id = client_id AND acct.cust-cat EQ "�"  AND  acct.contract EQ "�����" 	AND ( acct.close-date = ? OR acct.close-date GE date2 ) no-lock no-error.     
		if AVAIL acct THEN 
			DO:	
				v_racct = acct.acct.
				v_currency = acct.currency.	
 				RUN acct-pos IN h_base (acct.acct, acct.currency, posDate, posDate, ?).
				ost_acct = sh-bal . 

			END.

 	FIND FIRST acct WHERE  acct.cust-id = client_id AND acct.cust-cat EQ "�"  AND  acct.contract EQ "����1" no-lock no-error.     
		if AVAIL acct THEN 
			DO:	
				v_kart1 = acct.acct .
 				RUN acct-pos IN h_base (acct.acct, acct.currency, posDate, posDate, ?).
				ost_kart1 = sh-bal . 
			END.

 	FIND FIRST acct WHERE  acct.cust-id = client_id AND acct.cust-cat EQ "�"  AND  acct.contract EQ "����2" no-lock no-error.     
		if AVAIL acct THEN 
			DO:	
				v_kart2 = acct.acct .
 				RUN acct-pos IN h_base (acct.acct, acct.currency, posDate, posDate, ?).
				ost_kart2 = sh-bal . 
			END.
***************/

FOR EACH tmprecid NO-LOCK,
FIRST acct WHERE RECID(acct) = tmprecid.id  NO-LOCK: 

 IF AVAIL acct THEN 
	DO:
	v_racct = acct.acct.
	v_currency = acct.currency.	
	client_id = acct.cust-id.
	client_cat = acct.cust-cat.
	ost_acct = 0. 	vost_acct = 0.

	RUN acct-pos IN h_base (acct.acct, acct.currency, posDate, posDate, ?).

 IF v_currency EQ ''  THEN ost_acct = sh-bal. ELSE ost_acct = sh-val.

{setdest.i}


	IF client_cat = '�' THEN 
		FIND FIRST cust-corp WHERE  cust-corp.cust-id = client_id  no-lock no-error.     
			if AVAIL cust-corp THEN client_nm = cust-corp.name-short.

        
	IF client_cat = '�' THEN 
		FIND FIRST person WHERE  person.person-id = client_id  no-lock no-error.     
			if AVAIL person THEN client_nm = person.first-names + ' '  + person.name-last.



 	FIND FIRST accct WHERE  accct.cust-id = client_id AND accct.cust-cat EQ "�"  AND  accct.contract EQ "����1" /*AND SUBSTR(accct.acct,15) EQ SUBSTR(v_racct,15) */ no-lock no-error.     
		if AVAIL accct THEN 
			DO:	
				v_kart1 = accct.acct .
 				RUN acct-pos IN h_base (accct.acct, accct.currency, posDate, posDate, ?).
				ost_kart1 = sh-bal . 
			END.


 	FIND FIRST accct WHERE  accct.cust-id = client_id AND accct.cust-cat EQ "�"  AND  accct.contract EQ "����2" /*AND SUBSTR(accct.acct,15) EQ SUBSTR(v_racct,15)*/ no-lock no-error.     
		if AVAIL accct THEN 
			DO:	
				v_kart2 = accct.acct .
 				RUN acct-pos IN h_base (accct.acct, accct.currency, posDate, posDate, ?).
				ost_kart2 = sh-bal . 
			END.





		/* �㬬� �ய���� */
		RUN x-amtstr.p(ost_acct,v_currency,TRUE,TRUE,OUTPUT summaStr[1],OUTPUT summaStr[2]).
		/** ������� 楫� � �஡�� ������� � ���� ��६����� */
		summaStr[1] = summaStr[1] + ' ' + summaStr[2].
		/** ��ࢠ� �㪢� ������ ���� ��������� */
		SUBSTRING(summaStr[1],1,1) = CAPS(SUBSTRING(summaStr[1],1,1)).
		


	IF ost_kart2 = 0 THEN 
	DO:
		PUT UNFORMATTED '     ' + cBankName + ' ᮮ�頥�, �� �� ���� ' + v_racct   SKIP.
		PUT UNFORMATTED  client_nm + ' �� ���ﭨ� �� ' date2  ' ���� ' SKIP.
		PUT UNFORMATTED '������������� �� ����� ���㬥�⠬, �� ����祭�� � �ப �� ���� 90902; '  SKIP.
		PUT UNFORMATTED '(��।� ���ᯮ������� � �ப �ᯮ�殮���) ���������; '  SKIP.
	END.
	ELSE  
	DO:
		PUT UNFORMATTED '     ' + cBankName + ' ᮮ�頥�, �� �� ����  ' + v_racct   SKIP.
		PUT UNFORMATTED  client_nm + ' �� ���ﭨ� �� ' date2  ' ���� ' SKIP.
		PUT UNFORMATTED  '���⮪ �� ���� ' v_kart2 ' (��।� ���ᯮ������� � �ப �ᯮ�殮���) ' SKIP. 
		PUT UNFORMATTED  '��⠢��� ' STRING(ABS(ost_kart2),"->>>,>>>,>>9.99") ' �㡫��; '  SKIP.

	END.

	IF ost_kart1 = 0 THEN 
	DO:
		PUT UNFORMATTED '������������� �� ���� 90901 (��।� �ᯮ�殮���, �������� ��楯�;' SKIP.	
		PUT UNFORMATTED '��।� �ᯮ�殮���, �������� ࠧ�襭�� �� �஢������ ����権) ���������.  ' SKIP.	

	END.
	ELSE  
	DO:
		PUT UNFORMATTED '���⮪ �� ���� ' v_kart1 '(��।� �ᯮ�殮���, �������� ��楯�;' SKIP.
		PUT UNFORMATTED '��।� �ᯮ�殮���, �������� ࠧ�襭�� �� �஢������ ����権) ��⠢��� ' STRING(ABS(ost_kart1),"->>>,>>>,>>9.99") ' �㡫��. '  SKIP.

	END.

		PUT UNFORMATTED   SKIP.
		PUT UNFORMATTED '     ���⮪ �������� �।�� �� ����  ' + v_racct   SKIP.
		PUT UNFORMATTED  client_nm + ' �� ' date2  ' ���� ��⠢��� ' TRIM(STRING(ABS(ost_acct),"->>>,>>>,>>9.99")) ' '  SKIP.
		IF ost_acct <> 0 THEN 	PUT UNFORMATTED  '( ' SUBSTRING(summaStr[1],7) ' )  '  SKIP.
					ELSE 	PUT UNFORMATTED  '( ' summaStr[1] ' ).  '  SKIP. 
		



  END.
END.

{preview.i}
