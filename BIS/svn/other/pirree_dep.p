{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: REE_DEP.P
      Comment: Реестр по вкладам
   Parameters:
         Uses:
      Used by:
      Created: 24.08.2004 12:49 SAP     
     Modified: 24.08.2004 15:08 SAP      
     Modified: 24.08.2004 16:30 SAP      
     Modified: 25.08.2004 12:32 SAP      
     Modified: 
*/
{globals.i}
{pirree_dps.def}
DEFINE INPUT PARAMETER in-data-id LIKE DataBlock.Data-Id NO-UNDO.
DEFINE INPUT  PARAMETER TABLE      FOR  ttRee             .
DEFINE INPUT  PARAMETER TABLE      FOR  ttReeLoan         .
DEFINE OUTPUT PARAMETER oKolDep    AS   INTEGER           NO-UNDO.

DEF VAR vFile-bnk AS CHAR INIT "dep.txt" NO-UNDO.
DEF VAR vBank-regn AS CHAR INIT ""       NO-UNDO.
DEF VAR vBank     AS CHAR                NO-UNDO.

find user-proc where user-proc.procedure = "pirree_elec".
if avail user-proc then
vFile-bnk = GetXattrValueEx("user-proc",string(user-proc.public-number),"Дир","") + "/" + vFile-bnk.
else vFile-bnk = vFile-bnk.

DEF STREAM bnk.
{justasec}
OUTPUT STREAM bnk TO VALUE (vFile-bnk) CONVERT TARGET "1251".
FOR EACH ttRee ,
    EACH ttReeLoan WHERE ttReeLoan.SysNum = ttRee.SysNum
                   AND   ttReeLoan.Symbol = "д" BY id:
    oKolDep =  oKolDep + 1.
    PUT STREAM bnk UNFORMATTED
        /* string(ttRee.id)*/
	string(int(ttRee.SysNum)) + "^" +         /*Номер ПП*/
        ttReeLoan.BankRegNum + "^" + 
        ttReeLoan.ContNum + "^" + 
        STRING(date(ttReeLoan.ContDate),"99.99.9999") + "^" + 
        ttReeLoan.AcctNum + "^" + 
        trim(STRING(DEC(ttReeLoan.SumInCurr),">>>>>>>>>>>>9.99")) + "~n".
END.
OUTPUT STREAM bnk CLOSE.




   



