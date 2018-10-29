/**********************************************
 * Отчет.
 * Не могу выразить словами для чего он нужен *
 **********************************************
 *                                            *
 * 06.12.11                                   *
 * Отвечает на вопрос: У кого есть картотека  *
 * и у кого есть деньги на расчетном счет.    *
 *                                            *
 * Автор: Маслов Д. А.
 * Заявка:
 * Дата создания:
 **********************************************/
 
DEF VAR dTotal       AS DECIMAL INITIAL 0 		     NO-UNDO.
DEF VAR dBalPos      AS DECIMAL INITIAL 0 LABEL "Остаток"    NO-UNDO.
DEF VAR dKartPos     AS DECIMAL INITIAL 0 LABEL "КартБлок"   NO-UNDO.
DEF VAR dArrest      AS DECIMAL INITIAL 0 LABEL "Арест"      NO-UNDO.
DEF VAR dBlock       AS DECIMAL INITIAL 0 LABEL "Блокировка" NO-UNDO.
DEF VAR isFullBlock  AS LOGICAL INITIAL FALSE LABEL "Счет заблокирован полностью?" NO-UNDO.
DEF VAR isFullArrest AS LOGICAL INITIAL FALSE LABEL "Счет полностью арестован?"    NO-UNDO.

DEF VAR diffTime AS INTEGER NO-UNDO.
DEF VAR currDate AS DATE    NO-UNDO.
currDate = TODAY.

DEF VAR oTable AS TTable NO-UNDO.

DEF VAR oAcct  AS TAcctBal NO-UNDO.
DEF VAR oAcct1 AS TAcct    NO-UNDO.
DEF VAR oTpl   AS TTpl     NO-UNDO.

DEFINE BUFFER bfrAcct FOR acct.

oTpl = new TTpl("pir-getBlockList.tpl").
oTable = new TTable(8).
oTable:addRow().
oTable:addCell("Название").
oTable:addCell("Счет").
oTable:addCell("Остаток баланс").
oTable:addCell("Остаток внебаланс").
oTable:addCell("Блокировано").
oTable:addCell("Арестовано").
oTable:addCell("Полный блок").
oTable:addCell("Полный арест").

diffTime = TIME.
FOR EACH acct WHERE (acct.close-date>currDate OR acct.close-date=?) 
		    AND acct.acct  MATCHES '90901*' AND cust-cat="Ю" NO-LOCK,
FIRST cust-corp OF acct NO-LOCK, 
	EACH   bfrAcct WHERE bfrAcct.cust-cat="Ю" 
	       AND bfrAcct.cust-id=cust-corp.cust-id 
	       AND bfrAcct.acct MATCHES '40...810............' 
	       AND (acct.close-date>currDate OR acct.close-date=?) 
	NO-LOCK BREAK BY  cust-corp.cust-id:

 oAcct1 = new TAcct(acct.acct).
   dKartPos = oAcct1:getLastPos2Date(currDate).
 DELETE OBJECT oAcct1.
      

    oAcct = new TAcctBal(bfrAcct.acct).
      dBalPos      = oAcct:getLastPos2Date(currDate).
      dArrest      = oAcct:getArrestSum().
      dBlock       = oAcct:getBlockSum().
      isFullBlock  = oAcct:isFullBlock().
      isFullArrest = oAcct:isFullArrest().
    DELETE OBJECT oAcct.


      IF (dBalPos <> 0 AND dKartPos <> 0) THEN
        DO:
	  oTable:addRow().
	  oTable:addCell(cust-corp.name-short).
	  oTable:addCell(bfrAcct.acct).
	  oTable:addCell(dBalPos).
          oTable:addCell(dKartPos).
          oTable:addCell(ABS(dBlock)).
	  oTable:addCell(ABS(dArrest)).
	  IF isFullBlock THEN oTable:addCell(CHR(251)). ELSE oTable:addCell("-").
	  IF isFullArrest THEN oTable:addCell(CHR(251)). ELSE oTable:addCell("-").
        END.
     dArrest = 0.
     dBlock  = 0.
     END.

diffTime = TIME - diffTime.
oTpl:addAnchorValue("TABLE1",oTable).
{setdest.i}
oTpl:show().
{preview.i}
DELETE OBJECT oTable.
DELETE OBJECT oTpl.