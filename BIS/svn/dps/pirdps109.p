{pirsavelog.p}
/**
 * ��ᯮ�殮��� �� ����⨨ ��楢��� ���.
 * ����᪠���� �� ��㧥� ��������� ������஢
 * ���� �.�., 16.06.2006 10:19
 */
 
DEF INPUT PARAM iParam AS CHAR.

{globals.i}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

DEF VAR docDate AS DATE NO-UNDO.
{getdate.i}
docDate = end-date.

DEF VAR account AS CHAR NO-UNDO.
DEF VAR balAcct AS CHAR NO-UNDO.
DEF VAR valStr AS CHAR NO-UNDO.
DEF VAR val AS CHAR NO-UNDO.
DEF VAR loanInfo AS CHAR NO-UNDO.
DEF VAR client AS CHAR NO-UNDO.
DEF VAR openDate AS CHAR NO-UNDO.

/** ��� */
DEF VAR pirbosdps AS CHAR NO-UNDO.
pirbosdps = FGetSetting("PIRboss","PIRbosdps","").
DEF VAR pirboskzn AS CHAR NO-UNDO.
pirboskzn = FGetSetting("PIRboss", "PIRbosKazna","").

DEF VAR fioSpecDPS AS CHAR NO-UNDO. /** ���樠���� �⤥�� ��� */
fioSpecDPS = ENTRY(1, iParam).

{ulib.i}

{get-bankname.i}

{setdest.i}

/** ���� ��࠭���� ��� */
FOR FIRST tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK
	:
		account = GetLoanAcct_ULL(loan.contract, loan.cont-code, "�����", docDate, FALSE).
		balAcct = SUBSTRING(account,1,5).
		val = SUBSTRING(account,6,3).
		IF (val = "810") THEN
			valStr = "�㡫��".
		IF (val = "840") THEN
			valStr = "������� ���".
		IF (val = "978") THEN
			valStr = "����".
		loanInfo = loan.cont-code + " �� " + STRING(loan.open-date, "99/99/9999").
		client = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", FALSE).
		openDate = STRING(loan.open-date, "99/99/9999").
		
		/** ��ନ�㥬 �ᯮ�殮��� */
		PUT UNFORMATTED SPACE(50) "� ��ࠢ����� ������ ��⮢ � ॣ���ࠨ�" SKIP
		SPACE(50) cBankName SKIP(2)
		SPACE(50) '���: ' STRING(docDate, "99/99/9999") SKIP(4)
		SPACE(25) '� � � � � � � � � � � �' SKIP(3)
		SPACE(4) '���� �� �����ᮢ�� ��� � ' balAcct ' ������ ��楢�� ��� � ' valStr ' �� �������� ������᪮��' SKIP 
						'������ � ' loanInfo ' (�����稪 - ' client ') ��⮩ ' openDate '.' SKIP(3).
		
		
		/** ������� */
		PUT UNFORMATTED ENTRY(1,pirbosdps) SPACE(80 - LENGTH(ENTRY(1,pirbosdps))) ENTRY(2,pirbosdps) SKIP(1).
				
		PUT UNFORMATTED ENTRY(1,pirboskzn) SPACE(80 - LENGTH(ENTRY(1,pirboskzn))) ENTRY(2,pirboskzn) SKIP(1).

		if fioSpecDPS <> "" then
				PUT UNFORMATTED '����騩 ᯥ樠���� ������⭮�� �⤥��: ' SPACE(80 - LENGTH('����騩 ᯥ樠���� ������⭮�� �⤥��: ')) fioSpecDPS SKIP.
END.

{preview.i}
 