/*
               Банковская интегрированная система БИСквит
    Copyright: ОАО КБ "ПPОМИНВЕСТРАСЧЕТ"
     Filename: pir-pko.p
      Comment: Отчет по картотекам 1 & 2
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
MESSAGE "Введите дату" UPDATE date2 .


/**
 * По заявке #1289
 * Остаток должен быть на утро.
 **/
posDate = date2 - 1.


/***********
Функционал для работы из браузера клиентов


FOR EACH tmprecid NO-LOCK,
FIRST cust-corp WHERE RECID(cust-corp) = tmprecid.id NO-LOCK: 

 IF AVAIL cust-corp THEN 
	DO:

	client_id = cust-corp.cust-id.
	client_nm = cust-corp.cust-stat + ' ' + cust-corp.name-short.
	ost_acct = 0.


 	FIND FIRST acct WHERE  acct.cust-id = client_id AND acct.cust-cat EQ "Ю"  AND  acct.contract EQ "Расчет" 	AND ( acct.close-date = ? OR acct.close-date GE date2 ) no-lock no-error.     
		if AVAIL acct THEN 
			DO:	
				v_racct = acct.acct.
				v_currency = acct.currency.	
 				RUN acct-pos IN h_base (acct.acct, acct.currency, posDate, posDate, ?).
				ost_acct = sh-bal . 

			END.

 	FIND FIRST acct WHERE  acct.cust-id = client_id AND acct.cust-cat EQ "Ю"  AND  acct.contract EQ "Карт1" no-lock no-error.     
		if AVAIL acct THEN 
			DO:	
				v_kart1 = acct.acct .
 				RUN acct-pos IN h_base (acct.acct, acct.currency, posDate, posDate, ?).
				ost_kart1 = sh-bal . 
			END.

 	FIND FIRST acct WHERE  acct.cust-id = client_id AND acct.cust-cat EQ "Ю"  AND  acct.contract EQ "Карт2" no-lock no-error.     
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


	IF client_cat = 'Ю' THEN 
		FIND FIRST cust-corp WHERE  cust-corp.cust-id = client_id  no-lock no-error.     
			if AVAIL cust-corp THEN client_nm = cust-corp.name-short.

        
	IF client_cat = 'Ч' THEN 
		FIND FIRST person WHERE  person.person-id = client_id  no-lock no-error.     
			if AVAIL person THEN client_nm = person.first-names + ' '  + person.name-last.



 	FIND FIRST accct WHERE  accct.cust-id = client_id AND accct.cust-cat EQ "Ю"  AND  accct.contract EQ "Карт1" /*AND SUBSTR(accct.acct,15) EQ SUBSTR(v_racct,15) */ no-lock no-error.     
		if AVAIL accct THEN 
			DO:	
				v_kart1 = accct.acct .
 				RUN acct-pos IN h_base (accct.acct, accct.currency, posDate, posDate, ?).
				ost_kart1 = sh-bal . 
			END.


 	FIND FIRST accct WHERE  accct.cust-id = client_id AND accct.cust-cat EQ "Ю"  AND  accct.contract EQ "Карт2" /*AND SUBSTR(accct.acct,15) EQ SUBSTR(v_racct,15)*/ no-lock no-error.     
		if AVAIL accct THEN 
			DO:	
				v_kart2 = accct.acct .
 				RUN acct-pos IN h_base (accct.acct, accct.currency, posDate, posDate, ?).
				ost_kart2 = sh-bal . 
			END.





		/* Сумма прописью */
		RUN x-amtstr.p(ost_acct,v_currency,TRUE,TRUE,OUTPUT summaStr[1],OUTPUT summaStr[2]).
		/** Сливаем целые и дробные единицы в одну переменную */
		summaStr[1] = summaStr[1] + ' ' + summaStr[2].
		/** Первая буква должна быть заглавной */
		SUBSTRING(summaStr[1],1,1) = CAPS(SUBSTRING(summaStr[1],1,1)).
		


	IF ost_kart2 = 0 THEN 
	DO:
		PUT UNFORMATTED '     ' + cBankName + ' сообщает, что по счету ' + v_racct   SKIP.
		PUT UNFORMATTED  client_nm + ' по состоянию на ' date2  ' года ' SKIP.
		PUT UNFORMATTED 'Задолженность по расчетным документам, не оплаченным в срок по счету 90902; '  SKIP.
		PUT UNFORMATTED '(Очередь неисполненных в срок распоряжений) отсутствует; '  SKIP.
	END.
	ELSE  
	DO:
		PUT UNFORMATTED '     ' + cBankName + ' сообщает, что по счету  ' + v_racct   SKIP.
		PUT UNFORMATTED  client_nm + ' по состоянию на ' date2  ' года ' SKIP.
		PUT UNFORMATTED  'остаток по счету ' v_kart2 ' (Очередь неисполненных в срок распоряжений) ' SKIP. 
		PUT UNFORMATTED  'составляет ' STRING(ABS(ost_kart2),"->>>,>>>,>>9.99") ' рублей; '  SKIP.

	END.

	IF ost_kart1 = 0 THEN 
	DO:
		PUT UNFORMATTED 'задолженность по счету 90901 (Очередь распоряжений, ожидающих акцепта;' SKIP.	
		PUT UNFORMATTED 'Очередь распоряжений, ожидающих разрешения на проведение операций) отсутствует.  ' SKIP.	

	END.
	ELSE  
	DO:
		PUT UNFORMATTED 'остаток по счету ' v_kart1 '(Очередь распоряжений, ожидающих акцепта;' SKIP.
		PUT UNFORMATTED 'Очередь распоряжений, ожидающих разрешения на проведение операций) составляет ' STRING(ABS(ost_kart1),"->>>,>>>,>>9.99") ' рублей. '  SKIP.

	END.

		PUT UNFORMATTED   SKIP.
		PUT UNFORMATTED '     Остаток денежных средств по счету  ' + v_racct   SKIP.
		PUT UNFORMATTED  client_nm + ' на ' date2  ' года составляет ' TRIM(STRING(ABS(ost_acct),"->>>,>>>,>>9.99")) ' '  SKIP.
		IF ost_acct <> 0 THEN 	PUT UNFORMATTED  '( ' SUBSTRING(summaStr[1],7) ' )  '  SKIP.
					ELSE 	PUT UNFORMATTED  '( ' summaStr[1] ' ).  '  SKIP. 
		



  END.
END.

{preview.i}
