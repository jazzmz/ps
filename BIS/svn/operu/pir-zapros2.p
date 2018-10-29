{globals.i}
{intrface.get tmess}
{tmprecid.def}

/*****************************
 * 
 * По заявке #707
 * Выводит таблицу №2 для отправки в ЦБ
 * Необходимо обработать в Excell
 *****************************
 * Автор: Маслов Д. А.
 * Дата создания: 26.05.11
 * Заявка: #707
 *****************************/

DEF VAR oSysClass AS TSysClass     NO-UNDO.
DEF VAR oTable AS TTableCSV        NO-UNDO.
DEF VAR oTpl AS TTpl               NO-UNDO.

DEF VAR oDocument AS TPaymentOrder NO-UNDO.
DEF VAR oBank AS TBank             NO-UNDO.
DEF VAR oClient AS TClient         NO-UNDO.

DEF VAR oAcct AS TAcct             NO-UNDO.

DEF VAR cDet AS CHARACTER          NO-UNDO.
DEF VAR i AS INTEGER INITIAL 1     NO-UNDO.

DEF VAR name-ben AS CHARACTER      NO-UNDO.
DEF VAR acct-ben AS CHARACTER      NO-UNDO.

DEF VAR cInterestAcct AS CHARACTER NO-UNDO.
DEF VAR cOtherAcct    AS CHARACTER NO-UNDO.

DEF VAR isWhoPay   AS LOG    NO-UNDO.


oSysClass = new TSysClass().

RUN Fill-SysMes IN h_tmess  ("","","3","Что проверяем?|Откуда пришли,Куда ушли").

IF pick-value = "1" THEN DO:
 isWhoPay = TRUE.
END.
ELSE DO:
 isWhoPay = FALSE.
END.

oTpl = new TTpl('pir-zapros2.tpl').
oTable = new TTableCSV(10).

FOR EACH tmprecid,
  FIRST op WHERE tmprecid.id = RECID(op),
     FIRST op-entry OF op BY op-entry.acct-cr:	

	oDocument = new TPaymentOrder(tmprecid.id).
	oBank = oDocument:getBankBen().

	name-ben = oDocument:name-ben.
	acct-ben = oDocument:acct-rcpt.

	 cInterestAcct = IF isWhoPay THEN acct-cr ELSE acct-db.

	 oClient = new TClient(cInterestAcct).

	 cOtherAcct = /*acct-cr*/ oDocument:acct-send.

	IF oBank EQ ? THEN
	  DO:
		oBank = new TBank("044585491").
		oAcct = new TAcct(cOtherAcct).
		name-ben = oAcct:name-short.
		acct-ben = cOtherAcct.
	  END.

		oTable:addRow().
			oTable:addCell(i).
			oTable:addCell(cInterestAcct).
			oTable:addCell(oClient:clinn).
			oTable:addCell(oDocument:DocDate).
			oTable:addCell(ROUND(op-entry.amt-rub / 1000,2)).
			oTable:addCell(IF isWhoPay THEN oDocument:acct-send ELSE oDocument:acct-rec).
			oTable:addCell(IF isWhoPay THEN oDocument:inn-send ELSE oDocument:inn-rec).
			oTable:addCell((IF oDocument:name-send EQ "" OR oDocument:name-send EQ ? THEN oBank:bank-name ELSE oDocument:name-send)).
			oTable:addCell(oBank:bank-name).
			oTable:addCell(oSysClass:REPLACE_ASCII(oDocument:details,10," ")).

    DELETE OBJECT oBank.
	DELETE OBJECT oDocument.
	DELETE OBJECT oClient.
	i = i + 1.

END.  /* По всем выбранным */

oTable:SAVE-TO("/home2/bis/quit41d/imp-exp/users/admmda/tab2-1.txt").
oTpl:addAnchorValue("TABLE",oTable).

{setdest.i}
  oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
{intrface.del}