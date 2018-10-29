{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pirree_rates.p
      Comment: Процедура выгружает курсы для программы ASV (в нужном формате).
   Parameters: 
       Launch: Из процедуры pirree_elec.p выгрузки реестра в электронном виде
         Uses:
      Created: Sitov S.A., 05.04.2012
	Basis: Заявка # 906 (запрос от Маршевой Е.М.)
     Modified: 
*/
/* ========================================================================= */



{globals.i}


DEFINE INPUT PARAMETER in-data-date AS DATE NO-UNDO.
DEFINE VARIABLE vFile-rates AS CHARACTER INITIAL "rates.csv" NO-UNDO.
DEFINE STREAM rates .


find user-proc where user-proc.procedure = "pirree_elec".
if avail user-proc then 
vFile-rates = GetXattrValueEx("user-proc",string(user-proc.public-number),"Дир","") + "/" + vFile-rates.
else vFile-rates = vFile-rates.


OUTPUT STREAM rates TO VALUE ( vFile-rates ) CONVERT TARGET "1251".


FOR EACH instr-rate WHERE instr-rate.instr-cat = 'currency'
    AND instr-rate.rate-type = "Учетный"
    AND instr-rate.since = in-data-date
    AND CAN-DO("840,826,978",instr-rate.instr-code)
NO-LOCK:

  IF AVAIL(instr-rate) THEN
    DO:

	CASE instr-rate.instr-code:
	  WHEN "840" THEN DO: 
	    PUT STREAM rates UNFORM 
		"1;    " CHR(34) "Доллар США" CHR(34) ";                "
		STRING(instr-rate.rate-instr,"99.9999")	";   0; 0;  840"
	    SKIP.
	  END.
	  WHEN "978" THEN DO: 
	    PUT STREAM rates UNFORM 
		"1;    " CHR(34) "ЕВРО" CHR(34) ";                      "
		STRING(instr-rate.rate-instr,"99.9999")	";   0; 0;  978"
	    SKIP.
	  END.
	  WHEN "826" THEN DO: 
	    PUT STREAM rates UNFORM 
		"1;    " CHR(34) "Англ. фунт стерлингов" CHR(34) ";     "
		STRING(instr-rate.rate-instr,"99.9999")	";   0; 0;  826"
	    SKIP.
	  END.
	END CASE.

    END. /* end_if */

END. /* end_for_each */


OUTPUT STREAM rates CLOSE.
