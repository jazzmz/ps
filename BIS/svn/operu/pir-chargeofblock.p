
DEF VAR oDocCollect AS TDocCollect 	 NO-UNDO.
DEF VAR oAcct       AS TAcctBal    	 NO-UNDO.

DEF VAR i 	    AS INTEGER INITIAL 0 NO-UNDO.			/* Счетчик цикла */

DEF VAR cAcct        AS CHARACTER 	      LABEL "Клиентский счет" NO-UNDO.
DEF VAR dBlockSum    AS DECIMAL INITIAL 0     LABEL "Заблокировано"   NO-UNDO.
DEF VAR dArrestSum   AS DECIMAL INITIAL 0     LABEL "Арестовано"      NO-UNDO.
DEF VAR isFullBlock  AS LOGICAL INITIAL FALSE LABEL "Заблокирован ли счет полностью?" 	   NO-UNDO.
DEF VAR isFullArrest AS LOGICAL INITIAL FALSE LABEL "Установлена ли частичная блокировка?" NO-UNDO.
DEF VAR dAcctPos     AS DECIMAL INITIAL 0     LABEL "Остаток по счету" 			   NO-UNDO.

DEF VAR oTable       AS TTable    NO-UNDO.			/* Для вывода результата */
DEF VAR oTpl         AS TTpl      NO-UNDO.				/* Вывод будет через шаблонизатор */

DEF VAR oSysClass    AS TSysClass NO-UNDO.
DEF VAR oDTInput     AS TDTInput  NO-UNDO.

DEF VAR dCurrDate    AS DATE      NO-UNDO.

oDTInput = new TDTInput(3).
oDTInput:head = "Дата проверки?".
oDTInput:X = 210.
oDTInput:Y = 70.
oDTInput:show().
dCurrDate = oDTInput:beg-date.

IF oDTInput:isSet THEN
  DO:
    /* Надо почитать и переделать на событие */
oSysClass = new TSysClass().


oDocCollect = new TDocCollect().
oDocCollect:date-beg=dCurrDate.
oDocCollect:date-end=dCurrDate.
oDocCollect:acct-db="40*,42301*,42601".
oDocCollect:applyFilter().


{setdest.i}
oTpl = new TTpl("pir-chargeofblock.tpl").

oTable = new TTable(11).
DO i = 1 TO oDocCollect:DocCount:

cAcct = oDocCollect:getDocument(i):getOpEntry4Order(1):acct-db.
 oAcct = new TAcctBal(cAcct).										
    oAcct:dateState = dCurrDate.
    dBlockSum = oAcct:getBlockSum().								/* Получаем сумму блокировку */
    dArrestSum = oAcct:getArrestSum().							/* Получаем сумму ареста		 */
    isFullBlock = oAcct:isFullBlock().
    isFullArrest = oAcct:isFullArrest().
    dAcctPos = oAcct:getLastPos2Date(dCurrDate).
 DELETE OBJECT oAcct.

IF dBlockSum <> 0 OR dArrestSum <> 0 OR isFullBlock OR isFullArrest THEN
  DO:

    oTable:addRow().
	oTable:addCell(oDocCollect:getDocument(i):doc-num).
	oTable:addCell(cAcct).
	oTable:addCell(STRING(dAcctPos)).
	oTable:addCell(STRING(oDocCollect:getDocument(i):sum)).
	oTable:addCell(oSysClass:REPLACE_ASCII(oDocCollect:getDocument(i):details,10,"")).
	oTable:addCell(STRING(oDocCollect:getDocument(i):order-pay)).
	oTable:addCell(STRING(dBlockSum)).
	oTable:addCell(STRING(dArrestSum)).
	oTable:addCell(STRING(isFullBlock)).
	oTable:addCell(STRING(isFullArrest)).
	oTable:addCell(oDocCollect:getDocument(i):acct-rcpt).

  END.

END.

oTpl:addAnchorValue("DATEREPORT",STRING(dCurrDate)).
oTpl:addAnchorValue("TABLE1",oTable).
oTpl:addAnchorValue("DOCCOUNT",STRING(oDocCollect:DocCount)).
oTpl:show().

DELETE OBJECT oTable.
DELETE OBJECT oTpl.

DELETE OBJECT oDocCollect.
DELETE OBJECT oSysClass.
{preview.i}
END.
DELETE OBJECT oDTInput.