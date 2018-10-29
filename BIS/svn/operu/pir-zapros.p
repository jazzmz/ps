/*********************************************
 * ����� ���⠭���� �� �����᭥���.        *
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
oTpl = new TTpl("pir-zapros.tpl"). /* ������砥� 蠡��� */

oDocument = new TDocument(tmprecid.id).	/* ����稫� ���ଠ�� �� ���㬥��� */
oBank = oDocument:getBankBen().

bankAddress = oBank:law-address.
bankMailIndex = oBank:mail-index.

/* 
�᫨ ����� �⭮����� � ��᪢�, � ������ �� �뢮���.
����� ���� �� ��ᬮ���� ॣ��� ��襣� ����� � ������
�� ����� �ਭ������騥 �⮬� ॣ����. ��� �� ᤥ���� ���� �� ����
*/
IF CAN-DO("0445*,0446*",oBank:bic) THEN bankMailIndex = "".		

IF INDEX(bankAddress,"⥫.") > 0 THEN
   DO:
       /* � ���� ����� 㪠��� ⥫�䮭 */
	bankPhone = TRIM(SUBSTR(bankAddress,INDEX(bankAddress,"⥫.") + 4)).     
	SUBSTR(bankAddress,INDEX(bankAddress,"⥫.") - 2,LENGTH(bankAddress)) = "".
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
END. /* �� �ᥬ �뤥����� ���㬥�⠬ */
{preview.i}
