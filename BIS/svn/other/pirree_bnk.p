{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: REE_BNK.P
      Comment: Реестр по банку
   Parameters:
         Uses:
      Used by:
      Created: 24.08.2004 12:49 SAP     
     Modified: 25.08.2004 12:31 SAP      
     Modified: 
*/
{globals.i}
{bank-id.i}

DEFINE INPUT  PARAMETER in-data-id LIKE DataBlock.Data-Id NO-UNDO.
DEFINE OUTPUT PARAMETER oRegNum    AS   CHARACTER         NO-UNDO.

DEFINE VARIABLE vFile-bnk AS CHARACTER INITIAL "bnk.txt" NO-UNDO.
DEFINE VARIABLE vBank     AS CHARACTER NO-UNDO.


find user-proc where user-proc.procedure = "pirree_elec".
if avail user-proc then 
vFile-bnk = GetXattrValueEx("user-proc",string(user-proc.public-number),"Дир","") + "/" + vFile-bnk.
else vFile-bnk = vFile-bnk.
DEFINE STREAM bnk.
{justasec}

vBank  = FGetSetting( "БанкПолное", "", "" ).
/*vBank  =  "Коммерческий банк промышленно-инвестиционных расчетов " + chr(34) + "Пpоминвестрасчет" + chr(34) + "(общество с ограниченной ответственностью)" .*/
OUTPUT STREAM bnk TO VALUE ( vFile-bnk ) CONVERT TARGET "1251".
PUT STREAM bnk UNFORMATTED vBank + "^" + bank-regn.
OUTPUT STREAM bnk CLOSE.

oRegNum = bank-regn.



