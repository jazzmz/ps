{pirsavelog.p}
/** 
 * ��ᯮ�殮��� �� ����᫥��� ��業⮢ �� ������ �� 
 * ��� ���⨪���� �����
 * ����᪠���� �� ��㧥� ���㬥�⮢ ����樮����� ���
 * ����室��� ����� ���㬥��, �஢���� ���ண� ᮤ�ন� ᫥�. ����ᯮ������
 * 42x0x - 40817 (�����). ����� � ������� ������ ��� ��室���� � ���.४-�� ��� �� �।���.
 * ��� ����⨪���� �����, �� ����� ��ॢ������ �।�⢠, ⮦� ������ �� ���.४-�.
 * ���� �.�., 15.06.2006 14:36
 */
 
{globals.i}
{intrface.get xclass}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

DEF VAR docDate AS DATE NO-UNDO.
DEF VAR dopSoglNum AS CHAR NO-UNDO.
DEF VAR SoglNum AS CHAR NO-UNDO.
DEF VAR client AS CHAR NO-UNDO.
DEF VAR amount AS DECIMAL NO-UNDO.
DEF VAR amountStr AS CHAR EXTENT 2 NO-UNDO.
DEF VAR loanInfo AS CHAR NO-UNDO.
DEF VAR plastNum AS CHAR NO-UNDO.
DEF VAR plastAcct AS CHAR NO-UNDO.
DEF VAR tmpStr AS CHAR NO-UNDO.

/** ��� */
DEF VAR pirbosdps AS CHAR NO-UNDO.
pirbosdps = FGetSetting("PIRboss","PIRbosdps","").
DEF VAR pirboskzn AS CHAR NO-UNDO.
pirboskzn = FGetSetting("PIRboss", "PIRbosKazna","").

{ulib.i}
{getdates.i}

{get-bankname.i}

{setdest.i}


/** ���� ��࠭���� ��� */
FOR FIRST tmprecid NO-LOCK,
		FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK,
		FIRST op-entry OF op NO-LOCK
	:
		
		docDate = op.op-date.
		
		dopSoglNum = GetXAttrValueEx("acct", op-entry.acct-cr + "," + op-entry.currency, "PirDopSoglNum", "").
		SoglNum = GetXAttrValueEx("acct", op-entry.acct-cr + "," + op-entry.currency, "�ਬ3", "").
		plastAcct = GetXAttrValueEx("acct", op-entry.acct-cr + "," + op-entry.currency, "PirPlastAcct", "").
		client = GetAcctClientName_UAL(op-entry.acct-cr, FALSE).
		amount = IF op-entry.currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur.
		
		Run x-amtstr.p(amount, op-entry.currency, true, true, 
				output amountStr[1], 
				output amountStr[2]).
	  amountStr[1] = amountStr[1] + ' ' + amountStr[2].
		Substr(amountStr[1],1,1) = Caps(Substr(amountStr[1],1,1)).
		
		/* ��ࢠ� �㪢� �� ������� ����⨪���� ����� ��।���� �� ⨯ */
		tmpStr = SUBSTRING(GetXAttrValueEx("acct", plastAcct + "," + op-entry.currency, "DogPlast", ""),1,1).
		FIND FIRST code WHERE
			code.class = "SafePlastType"
			AND
			code.code = tmpStr
			NO-LOCK NO-ERROR.
		IF AVAIL code THEN plastNum = code.name.
		
		FIND FIRST loan-acct WHERE
			loan-acct.acct = op-entry.acct-db
			AND
			loan-acct.acct-type = 'loan-dps-t'
			NO-LOCK NO-ERROR.

		IF AVAIL loan-acct THEN DO:
			FIND FIRST loan WHERE loan.contract = loan-acct.contract AND loan.cont-code = loan-acct.cont-code NO-LOCK NO-ERROR.
			IF AVAIL loan THEN DO:
				loanInfo = loan.cont-code + " �� " + STRING(loan.open-date, "99/99/9999"). 
			END.
		END.
			
		/** ��ନ�㥬 �ᯮ�殮��� */
		PUT UNFORMATTED SPACE(50) "� �����⠬��� 3" SKIP
		SPACE(50) cBankName SKIP(2)
		SPACE(50) '���: ' STRING(docDate, "99/99/9999") SKIP(4)
		SPACE(25) '� � � � � � � � � � � �' SKIP(3)
		SPACE(4) '� ᮮ⢥��⢨� � �������⥫�� ᮣ��襭��� � ' dopSoglNum ' � �������� ������᪮�� ' SKIP 
		'��� ' (IF op-entry.currency = "" THEN "" ELSE "� �����࠭��� ����� ") ' � ' SoglNum ' ��ॢ��� ������� (' client ') ������� ' SKIP
		'�।�⢠ � �㬬� ' amount '/' (IF op-entry.currency = "" THEN "810" ELSE op-entry.currency) ' (' amountStr[1] ')' SKIP
		'(���᫥��� ��業�� �� ��ਮ� c ' beg-date FORMAT "99/99/9999" ' �� ' end-date FORMAT "99/99/9999" ' �� �������� ������᪮�� ������ ' SKIP 
		'� ' loanInfo ') � ��� � ' op-entry.acct-cr ' �� ��� ' SKIP
		plastAcct ' ��� ��������� ����⨪���� ����� ' plastNum '.' SKIP(3).
		
		/** ������� */
		PUT UNFORMATTED ENTRY(1,pirbosdps) SPACE(80 - LENGTH(ENTRY(1,pirbosdps))) ENTRY(2,pirbosdps) SKIP(1).
				
		PUT UNFORMATTED ENTRY(1,pirboskzn) SPACE(80 - LENGTH(ENTRY(1,pirboskzn))) ENTRY(2,pirboskzn) SKIP.
 
	
END.

 
{preview.i}