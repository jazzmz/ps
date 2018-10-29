{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: REE_FIL.P
      Comment: Реестр по филиалам
   Parameters:
         Uses:
      Used by:
      Created: 24.08.2004 12:49 SAP     
     Modified: 25.08.2004 12:31 SAP      
     Modified: 
*/
{globals.i}
DEFINE INPUT PARAMETER in-data-id LIKE DataBlock.Data-Id NO-UNDO.
DEFINE OUTPUT PARAMETER oKolFil    AS   INTEGER           NO-UNDO.

DEF VAR vFile-bnk AS CHAR INIT "fil.txt" NO-UNDO.
DEF VAR vBank-regn AS CHAR INIT ""       NO-UNDO.
DEF VAR vBank     AS CHAR                NO-UNDO.
DEF STREAM bnk.

find user-proc where user-proc.procedure = "pirree_elec".
if avail user-proc then
vFile-bnk = GetXattrValueEx("user-proc",string(user-proc.public-number),"Дир","") + "/" + vFile-bnk.
else vFile-bnk = vFile-bnk.

DEFINE STREAM bnk.
{justasec}
DEFINE VARIABLE cBankName AS CHAR NO-UNDO.
cBankName = FGetSetting("БанкПолное", "", "").


OUTPUT STREAM bnk TO VALUE (vFile-bnk) CONVERT TARGET "1251".
vBank-Regn = "".
DO WHILE YES:
     /* Ищем следующий филиал */
     FIND FIRST dataLine WHERE
              dataLine.data-ID EQ in-data-id
          AND dataLine.Sym4    GT vBank-Regn
        NO-LOCK NO-ERROR.
     IF NOT AVAIL (dataLine) THEN LEAVE.
     /* Находим по коду банк и филиал */
      vBank-Regn = dataLine.Sym4.
      FOR FIRST banks-code WHERE
                banks-code.bank-code-type EQ "REGN"
            AND banks-code.bank-code      EQ vBank-Regn
	 NO-LOCK,
	   FIRST banks OF banks-code
         NO-LOCK,
           FIRST branch OF banks WHERE
	        (branch.branch-type EQ "10"
              OR branch.branch-type EQ "11")
         NO-LOCK:
	 /* Количество подразделений */
	 oKolFil = oKolFil + 1.
	 
	    PUT STREAM bnk UNFORMATTED ENTRY (NUM-ENTRIES (vBank-regn,"/"),vBank-regn,"/") + "^" + 
                                       /*banks.NAME +  "^"*/                                                                  
				       cBankName + "^" + 
                                       /*banks.law-address */
					"121099,Москва г,,,,Новинский б-р,3,,1,"
					+ "~n".
       
    END.
END.
OUTPUT STREAM bnk CLOSE.




   



