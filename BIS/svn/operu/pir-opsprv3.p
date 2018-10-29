/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: ��� �� "�P��������������"
     Filename: pir-pko.p
      Comment: ���� ��� ���ৠ��
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
DEFINE VAR d1	as int  no-undo.
DEFINE VAR d2	as int  no-undo.
DEFINE VAR m1	as int  no-undo.
DEFINE VAR m2	as int  no-undo.
DEFINE VAR y1	as int  no-undo.
DEFINE VAR y2	as int  no-undo.

DEFINE VAR ost_acct	as decimal  no-undo.
DEFINE VAR tek-pos 	AS DECIMAL NO-UNDO.
DEFINE VAR tek-db 	AS DECIMAL NO-UNDO.
DEFINE VAR tek-cr	AS DECIMAL NO-UNDO.

DEFINE VAR date1		as date  no-undo.
DEFINE VAR date2		as date  no-undo.
DEFINE VAR date2prv		as date  no-undo.


DEFINE VAR v_racct	as char  no-undo.
DEFINE VAR v_currency 	as char  no-undo.

DEFINE VAR v_kart1	as char  no-undo.
DEFINE VAR v_kart2	as char  no-undo.
DEFINE VAR client_nm	as char  no-undo.
DEFINE var summaStr as char extent 2 no-undo.
DEFINE var summastr2 as char  no-undo.
DEFINE VAR search_k1 as char no-undo.
DEFINE VAR search_k2 as char no-undo.
DEFINE BUFFER accct FOR acct.


/*-------------------------------------- Main ------------------------------------------------------------------*/

{sh-defs.i}
{getdates.i}
{tmprecid.def}




FOR EACH tmprecid NO-LOCK,
FIRST acct WHERE RECID(acct) = tmprecid.id  NO-LOCK: 

 IF AVAIL acct THEN 
	DO:
	v_racct = acct.acct.
	v_currency = acct.currency.	
	client_id = acct.cust-id.

 	FIND FIRST cust-corp WHERE  cust-corp.cust-id = client_id  no-lock no-error.     
		if AVAIL cust-corp THEN 
			DO:	
			client_nm =  cust-corp.name-short.
 		
			END.

		i = 1.		
		date1 = beg-date. d1 = DAY(date1).	m1 = MONTH(date1).	y1 = YEAR(date1).	

/* message y1 m1 d1. pause.*/

		IF m1 = 12  THEN 
			DO:	d2 = 1.	m2 = 1. 	y2 = y1 + 1.	END.
			ELSE
			DO:	d2 = 1.	m2 = m1 + 1. 	y2 = y1.	END.
			END.

			date2 = date(m2,d2,y2).
			date2prv= date2 - 1 .
			



{setdest.i}


		PUT UNFORMATTED '     ' + cBankName + ' ᮮ�頥�, �� ������ �������� �।�� �� '  SKIP.
		PUT UNFORMATTED '���  ' v_racct  ' '  client_nm  SKIP.
		PUT UNFORMATTED '�� ��ਮ� � ' beg-date ' �� ' end-date ' ��⠢���: ' SKIP(1).
	
		PUT UNFORMATTED "����������������������������������������������������������������������͸" SKIP
						"� �� �� ������,���������� �� �����㳎����� �� �।��    ���⮪     �" SKIP.
		

		DO WHILE date1 < end-date:
			RUN acct-pos IN h_base (v_racct, v_currency, date1, date2prv, ?).

			IF v_currency = "" 
			THEN 
			  ASSIGN tek-pos = sh-bal tek-db = sh-db tek-cr = sh-cr. 
			ELSE 
			  ASSIGN tek-pos = sh-val tek-db = sh-vdb tek-cr = sh-vcr.
					
 			PUT UNFORMATTED	 "����������������������������������������������������������������������͵" SKIP.
			PUT UNFORMATTED  '�  ' STRING(i,"99") '   � ' STRING(m1,"99") ',' y1 ' � ' STRING (tek-db,"->>>,>>>,>>9.99") ' � ' STRING(tek-cr,"->>>,>>>,>>9.99") ' � '   STRING(ABS(tek-pos),"->>>,>>>,>>9.99")   '�' SKIP.
			

			i = i + 1.
			date1 = date2. d1 = DAY(date1).	m1 = MONTH(date1).	y1 = YEAR(date1).	

			IF m1 = 12  then	
				do:	d2 = 1.	m2 =  1. 	y2 = y1 + 1. end.
			else	
				do:	d2 = 1.	m2 = m1 + 1. 	y2 = y1. end.

			date2 = date (m2,d2,y2) .
			date2prv= date2 - 1 .
		
		END.	

		PUT UNFORMATTED "������������������������������������������������������������������������" SKIP(1).			

 
END.

{preview.i}
