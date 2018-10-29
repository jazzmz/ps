{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: REE_INV.P
      Comment: Реестр по вкладчикам
   Parameters:
         Uses:
      Used by:
      Created: 24.08.2004 12:49 SAP     
     Modified: 24.08.2004 15:08 SAP      
     Modified: 25.08.2004 12:31 SAP      
     Modified: 
*/
{globals.i}
{pirree_dps.def}

DEFINE INPUT  PARAMETER in-data-id LIKE DataBlock.Data-Id NO-UNDO.
DEFINE INPUT  PARAMETER TABLE      FOR  ttRee             .
DEFINE OUTPUT PARAMETER oKolInv    AS   INTEGER           NO-UNDO.

DEF VAR vFile-bnk AS CHAR INIT "inv.txt" NO-UNDO.
DEF VAR vBank-regn AS CHAR INIT ""       NO-UNDO.
DEF VAR vBank     AS CHAR                NO-UNDO.
DEF VAR vFam as int no-undo.

find user-proc where user-proc.procedure = "pirree_elec".
if avail user-proc then
vFile-bnk = GetXattrValueEx("user-proc",string(user-proc.public-number),"Дир","") + "/" + vFile-bnk.
else vFile-bnk = vFile-bnk.

DEF STREAM bnk.
{justasec}
OUTPUT STREAM bnk TO VALUE (vFile-bnk) CONVERT TARGET "1251".
FOR EACH ttRee BY id:
    oKolInv =  oKolInv + 1.
    vFam = NUM-ENTRIES(FIO,"").
    PUT STREAM bnk UNFORMATTED
        /* string(id) */ 
	string(int(SysNum)) + "^" +         /*Номер ПП*/
        entry(1,FIO,"") + "^" +        /*Фамилия*/
	entry(2,FIO,"") + "^" +
	(if vFam=3 then entry(3,FIO,"") else "") + "^" +
        AdressReq + "^" +  /*адрес*/
        AdressPos + "^" +  /*почтовый адрес*/ 
        Email  "^" + /* электронный адрес */
        DocTypeCode + "^" + /*код документа*/
        DocNum + /*"^" + /*серия и номер*/
                 "^" + */ /*дата выдачи*/
        " " + KemVidano + "~n". 
END.
OUTPUT STREAM bnk CLOSE.




   



