{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: REE_ELEC.P
      Comment: Формирование всех файлов реестров в электронном виде
   Parameters:
         Uses:
      Used by:
      Created: 25.08.2004 11:00 SAP     
     Modified: 25.08.2004 12:33 SAP      
     Modified: 25.08.2004 13:02 SAP      
     Modified: 
*/

{globals.i}
DEFINE INPUT PARAMETER in-data-id LIKE DataBlock.Data-Id NO-UNDO.

DEF VAR vRegNum AS CHAR NO-UNDO.
DEF VAR vKolFil AS INT  NO-UNDO.
DEF VAR vKolInv AS INT  NO-UNDO.
DEF VAR vKolDep AS INT  NO-UNDO.
DEF VAR vKolCrd AS INT  NO-UNDO.
DEF VAR vFile-bnk AS CHAR INIT "ctr.txt" NO-UNDO.
DEF VAR vSummDep AS DEC NO-UNDO.
DEF VAR vSummCrd AS DEC NO-UNDO.
DEF VAR in-data-date AS DATE NO-UNDO.

find user-proc where user-proc.procedure = "pirree_elec".
if avail user-proc then
vFile-bnk = GetXattrValueEx("user-proc",string(user-proc.public-number),"Дир","") + "/" + vFile-bnk.
else vFile-bnk = vFile-bnk.

{justasec}

{pirree_dps.i}
RUN pirree_bnk.p (INPUT in-data-id,OUTPUT vRegNum).

RUN pirree_fil.p (INPUT in-data-id, 
               OUTPUT vKolFil).

RUN pirree_inv.p (INPUT in-data-id, 
               INPUT table ttRee, 
               OUTPUT vKolInv).

RUN pirree_dep.p (INPUT in-data-id, 
               INPUT table ttRee,
               INPUT table ttReeLoan, 
               OUTPUT vKolDep).

RUN pirree_crd.p (INPUT in-data-id, 
               INPUT table ttRee,
               INPUT table ttReeLoan,
               OUTPUT vKolCrd).

in-data-date = DataBlock.end-date .
RUN pirree_rates.p (INPUT in-data-date).



DEF STREAM bnk.
OUTPUT STREAM bnk TO VALUE (vFile-bnk) CONVERT TARGET "1251".

PUT STREAM bnk UNFORMATTED vRegNum + "~n" +
                           STRING(DataBlock.end-date,"99.99.9999") + "~n" +
                           STRING(vKolFil) + "~n" + 
                           STRING(vKolInv) + "~n" +
                           STRING(vKolDep) + "~n" + 
                           STRING(vKolCrd).
/*подитоги по валютам*/
FOR EACH ttReeLoan BREAK BY  ttReeLoan.Curr:
    IF ttReeLoan.Symbol = "д" THEN vSummDep = vSummDep + ttReeLoan.SumInCurr.
    IF ttReeLoan.Symbol = "к" THEN vSummCrd = vSummCrd + ttReeLoan.SumInCurr.
    IF FIRST-OF(Curr) THEN PUT STREAM bnk UNFORMATTED "~n".
    IF LAST-OF(Curr) THEN DO:
        PUT STREAM bnk UNFORMATTED ttReeLoan.Curr + "^" +
                                   TRIM(STRING(vSummDep, ">>>>>>>>>>>>>>>>>9.99")) + "^" + 
                                   TRIM(STRING(vSummCrd, ">>>>>>>>>>>>>>>>>9.99")).
        ASSIGN vSummDep = 0
               vSummCrd = 0.
    END.
END.
OUTPUT STREAM bnk CLOSE.






