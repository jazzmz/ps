{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (C) 2011
     Filename: pirree_rates.p
      Comment: ��楤�� ���㦠�� ����� ��� �ணࠬ�� ASV (� �㦭�� �ଠ�).
   Parameters: 
       Launch: �� ��楤��� pirree_elec.p ���㧪� ॥��� � ���஭��� ����
         Uses:
      Created: Sitov S.A., 05.04.2012
	Basis: ��� # 906 (����� �� ���襢�� �.�.)
     Modified: 
*/
/* ========================================================================= */



{globals.i}


DEFINE INPUT PARAMETER in-data-date AS DATE NO-UNDO.
DEFINE VARIABLE vFile-rates AS CHARACTER INITIAL "rates.csv" NO-UNDO.
DEFINE STREAM rates .


find user-proc where user-proc.procedure = "pirree_elec".
if avail user-proc then 
vFile-rates = GetXattrValueEx("user-proc",string(user-proc.public-number),"���","") + "/" + vFile-rates.
else vFile-rates = vFile-rates.


OUTPUT STREAM rates TO VALUE ( vFile-rates ) CONVERT TARGET "1251".


FOR EACH instr-rate WHERE instr-rate.instr-cat = 'currency'
    AND instr-rate.rate-type = "����"
    AND instr-rate.since = in-data-date
    AND CAN-DO("840,826,978",instr-rate.instr-code)
NO-LOCK:

  IF AVAIL(instr-rate) THEN
    DO:

	CASE instr-rate.instr-code:
	  WHEN "840" THEN DO: 
	    PUT STREAM rates UNFORM 
		"1;    " CHR(34) "������ ���" CHR(34) ";                "
		STRING(instr-rate.rate-instr,"99.9999")	";   0; 0;  840"
	    SKIP.
	  END.
	  WHEN "978" THEN DO: 
	    PUT STREAM rates UNFORM 
		"1;    " CHR(34) "����" CHR(34) ";                      "
		STRING(instr-rate.rate-instr,"99.9999")	";   0; 0;  978"
	    SKIP.
	  END.
	  WHEN "826" THEN DO: 
	    PUT STREAM rates UNFORM 
		"1;    " CHR(34) "����. ��� ��૨����" CHR(34) ";     "
		STRING(instr-rate.rate-instr,"99.9999")	";   0; 0;  826"
	    SKIP.
	  END.
	END CASE.

    END. /* end_if */

END. /* end_for_each */


OUTPUT STREAM rates CLOSE.
