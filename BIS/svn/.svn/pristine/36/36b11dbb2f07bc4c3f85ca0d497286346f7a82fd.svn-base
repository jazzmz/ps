/*************************************************************
 *                                                           *                                      
 *                                                           *
 * Процедура формирует распоряжение по формированию резерва  *     
 *  по средствам, размещенным на корреспондентских счетах    *
 *  для выборки по счетам                                    *
 *                                                           *
 *************************************************************
 * Автор: Красков А.С.                                       *
 * Дата создания: 01.11.2010                                 *
 * заявка №490                                               *
 *************************************************************/

using Progress.Lang.*.
{tmprecid.def}
{globals.i}
{ulib.i}
{intrface.get instrum}
{getdate.i}

/* переменные для объектов используемых классов*/
DEF VAR oTpl     AS TTpl   NO-UNDO.
DEF VAR oTacct   AS TAcct  NO-UNDO.
DEF VAR oTable1  AS TTable NO-UNDO.
DEF VAR oTKurs   AS TKurs  NO-UNDO.


DEF BUFFER bAcct FOR Acct.
DEF BUFFER bcomm-rate FOR  comm-rate .

DEF VAR PosRur  AS Decimal NO-UNDO.
DEF VAR PosVal  AS Decimal NO-UNDO.
DEF VAR ItogRub AS Decimal NO-UNDO.

DEF VAR dCurrDate AS Date NO-UNDO.

DEF VAR traceOn AS LOGICAL INITIAL false NO-UNDO.

DEF VAR tmpStr AS CHARACTER NO-UNDO.

DEF VAR acct_cur AS CHAR    NO-UNDO.
DEF VAR grrisk   AS Decimal NO-UNDO.
DEF VAR prrisk   AS INTEGER NO-UNDO.

DEF VAR kursEur AS Decimal NO-UNDO.
DEF VAR kursUsd AS Decimal NO-UNDO.
DEF VAR kursGbp AS Decimal NO-UNDO.

DEF VAR Kurs    AS Decimal NO-UNDO.

oTpl = new TTpl("pir-rasprezerv.tpl").
oTable1 = new TTable(9).
oTKurs = new TKurs().

dCurrDate=end-date.

ItogRub = 0.

kursEur = oTKurs:getCBRKurs(978,dCurrDate).
kursUSD = oTKurs:getCBRKurs(840,dCurrDate).
kursGbp = oTKurs:getCBRKurs(826,dCurrDate).	

kurs = 1.
for each tmprecid,
	first bAcct where RECID(bAcct) EQ tmprecid.id and (bAcct.acct begins "30110" or bAcct.acct begins "30114" or bAcct.acct begins "30402") and bAcct.cust-cat eq 'Б' and bAcct.close-date = ? NO-LOCK.

        oTacct = new Tacct(bAcct.acct).

        acct_cur = bAcct.currency.
        posVal = oTacct:getLastPos2Date(dCurrDate) NO-ERROR.
 
/*
        tmpStr = GetXAttrValueEx("acct",bAcct.acct + "," + (if acct_cur="810" then "" else acct_cur),"pers-reserve","") NO-ERROR.
        IF tmpStr <> "" THEN prrisk = DECIMAL(tmpStr).
        tmpStr = GetXAttrValueEx("acct",bAcct.acct + "," + (if acct_cur="810" then "" else acct_cur),"ГрРиска","") NO-ERROR.
        IF tmpStr <> "" THEN grrisk = integer(substring(tmpStr,1,1)).
*/

        FIND LAST bcomm-rate 
           WHERE bcomm-rate.commission begins "%Рез"
           AND   bcomm-rate.since <= dCurrDate
           AND   bcomm-rate.acct EQ bAcct.acct  AND   bcomm-rate.currency EQ bAcct.currency
           AND   bcomm-rate.kau EQ '' 
        NO-LOCK NO-ERROR.
        
        IF AVAILABLE(bcomm-rate) THEN
           prrisk = bcomm-rate.rate-comm .
        ELSE prrisk = 0 .
         
        IF prrisk = 0 THEN grrisk = 1.
        IF prrisk >= 1 AND prrisk <= 20 THEN grrisk = 2.
        IF prrisk > 20 AND prrisk <= 50 THEN grrisk = 3.
        IF prrisk > 50 AND prrisk < 100 THEN grrisk = 4.
        IF prrisk = 100 THEN grrisk = 5. 

        IF acct_cur="810" OR acct_cur="" THEN 
           do.
                acct_cur = "RUB".
                kurs = 1.
           end.
        IF acct_cur="840" THEN 
           do.
                acct_cur = "USD".
                kurs = kursusd.    
           End.
        IF acct_cur="978"  THEN 
           do.
                acct_cur = "EUR".
                kurs = kurseur.
           end.
        IF acct_cur="826"  THEN 
           do.
                acct_cur = "GBP".
                kurs = kursGbp.
           end.

		posRur = posVal * kurs.
        ItogRub = ItogRub + posRur.
     
        oTable1:addRow().
        oTable1:addCell(bAcct.acct).
        oTable1:addCell(bAcct.details).
        oTable1:addCell(acct_cur).
        oTable1:addCell(posVal).
        oTable1:addCell(kurs).
        oTable1:addCell(round(posRur,2)).
        oTable1:addCell(grrisk).
        oTable1:addCell(prrisk).
        oTable1:addCell(posRur * prrisk / 100 ). 

        DELETE OBJECT oTacct.
end.

oTable1:addRow().
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(round(ItogRub,2)).
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" "). 


oTpl:addAnchorValue("TABLE1",oTable1).
oTpl:addAnchorValue("DATE",dCurrDate).

{setdest.i}
  oTpl:show().
{preview.i}

DELETE OBJECT oTable1.
DELETE OBJECT oTpl.
DELETE OBJECT oTKurs.