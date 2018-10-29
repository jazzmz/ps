/*
               Банковская интегрированная система БИСквит
    Copyright: 
     Filename: pir-auto-vip.p
      Comment: 
   Parameters: 
         Uses: Globals.I History.Def CEI.Def
      Used by: -
      Created: 25/03/2009 Templar
     Modified: 07/09/2011 SStepanov добавил NO-LOCK поскольку имели падение планировщика с записью в логе Lock wait timeout of 1800 seconds expired (8812) 
*/



{globals.i new}
{basefunc.def}

{intrface.get instrum}
{intrface.get strng}
{intrface.get re}
{intrface.get tmess}
{intrface.get xclass}
{intrface.get cntxt}






DEFINE VAR i		as INT		no-undo.
DEFINE VAR fname	as CHAR		no-undo.


DEFINE TEMP-TABLE zapros NO-UNDO
	FIELD f AS CHAR   /* Файл */
	FIELD n AS CHAR    /*номер карты*/
	FIELD d1 AS DATE FORMAT "99/99/9999"  /*дата 1*/
	FIELD d2 AS DATE FORMAT "99/99/9999"  /*дата 2*/

.


/*--------------------------------------- Main ------------------------------------------------------------------*/



ASSIGN
	fname = "/home/bis/quit41d/imp-exp/pcard/vip/in/zapros.tmp"
.

INPUT FROM VALUE(fname).
	REPEAT:   
		CREATE zapros.
		IMPORT DELIMITER "," zapros.
	END.





FOR EACH zapros:
	FIND FIRST loan
	  WHERE loan.contract = "card"
	    AND loan.doc-num = zapros.n
	  NO-LOCK NO-ERROR. /* SStepanov добавил NO-LOCK поскольку имели падение планировщика с записью в логе Lock wait timeout of 1800 seconds expired (8812) */
	IF AVAIL loan THEN zapros.n = loan.cont-code.	
END.


FOR EACH zapros:
	RUN pir-card-rep.p ("/home/bis/quit41d/imp-exp/pcard/vip/out/" + zapros.f,zapros.n,zapros.d1,zapros.d2). 
END.



OS-DELETE VALUE(fname).

