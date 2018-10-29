/*********************************************
 * Запрос постановки на невыясненные.        *
 *********************************************/
{tmprecid.def}
{wordwrap.def}

DEF VAR oTpl      AS TTpl      		NO-UNDO.
DEF VAR oDocument AS TDocument 		NO-UNDO.
DEF VAR oBank     AS TBank     		NO-UNDO.
DEF VAR vNameSend AS CHARACTER EXTENT 3 NO-UNDO.

DEF VAR bankAddress   AS CHARACTER 	      NO-UNDO.
DEF VAR bankPhone     AS CHARACTER 	      NO-UNDO.
DEF VAR bankMailIndex AS CHARACTER INITIAL "" NO-UNDO.

{setdest.i}

FOR EACH tmprecid:
oTpl = new TTpl("pir-zapros.tpl"). /* Подключаем шаблон */

oDocument = new TDocument(tmprecid.id).	/* Получили информацию по документу */
oBank = oDocument:getBankBen().

bankAddress = oBank:law-address.
bankMailIndex = oBank:mail-index.

/* 
Если Банки относятся к Москве, то индекс не выводим.
Вообще надо бы посмотреть регион нашего банка и глушить
все банки принадлежащие этому региону. Как это сделать пока не знаю
*/
IF CAN-DO("0445*,0446*",oBank:bic) THEN bankMailIndex = "".		

IF INDEX(bankAddress,"тел.") > 0 THEN
   DO:
       /* В адресе банка указан телефон */
	bankPhone = TRIM(SUBSTR(bankAddress,INDEX(bankAddress,"тел.") + 4)).     
	SUBSTR(bankAddress,INDEX(bankAddress,"тел.") - 2,LENGTH(bankAddress)) = "".
   END.
vNameSend = oDocument:name-ben.
{wordwrap.i
   &s=VNameSend
   &n=3
   &l=61
}

oTpl:addAnchorValue("NUM",oDocument:doc-num).
oTpl:addAnchorValue("SUM",STRING(oDocument:sum,">>>,>>>,>>>,>>9.99")).
oTpl:addAnchorValue("DOCDATE",oDocument:DocDate).
oTpl:addAnchorValue("BANKBIC",oBank:bic).
oTpl:addAnchorValue("BANKNAME",oBank:bank-name).
oTpl:addAnchorValue("ADDRESS",bankAddress).
oTpl:addAnchorValue("BANKTOWN",bankMailIndex + "," + oBank:town-type + " " + oBank:town).
oTpl:addAnchorValue("PHONE",bankPhone).
oTpl:addAnchorValue("ACCT",oDocument:acct-rcpt).

oTpl:addAnchorValue("PAYEER1",vNameSend[1]).
oTpl:addAnchorValue("PAYEER2",vNameSend[2]).
oTpl:addAnchorValue("PAYEER3",vNameSend[3]).
oTpl:show().
DELETE OBJECT oDocument.
DELETE OBJECT oTpl.
PAGE.
END. /* По всем выделенным документам */
{preview.i}
