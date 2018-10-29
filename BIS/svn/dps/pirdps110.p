{pirsavelog.p}

/**
 * ��ᯮ�殮��� � �����⨨ ��楢��� ���.
 * ����᪠���� �� ��㧥� ��������� ������஢
 * ���� �.�., 11.08.2006 9:39
 */
 
DEF INPUT PARAM iParam AS CHAR.

{globals.i}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

DEF VAR docDate AS DATE.
docDate = TODAY.

DEF VAR account AS CHAR.
DEF VAR balAcct AS CHAR.
DEF VAR valStr AS CHAR.
DEF VAR val AS CHAR.
DEF VAR loanInfo AS CHAR.
DEF VAR client AS CHAR.
DEF VAR openDate AS CHAR.
DEF VAR closeDate AS DATE.
DEF VAR str AS CHAR EXTENT 5.
DEF VAR i AS INTEGER.

/** ��� */
DEF VAR pirbosdps AS CHAR.
pirbosdps = FGetSetting("PIRboss","PIRbosdps","").
DEF VAR pirboskzn AS CHAR.
pirboskzn = FGetSetting("PIRboss", "PIRbosKazna","").

DEF VAR fioSpecDPS AS CHAR. /** ���樠���� �⤥�� ��� */
fioSpecDPS = ENTRY(1, iParam).

{ulib.i}
{get-bankname.i}

{wordwrap.def}
 
 
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
		closeDate = loan.end-date.
		
		pause 0.
		
		DISPLAY 
			"�������            :" loanInfo FORMAT "x(30)" SKIP
			"��� �ᯮ�殮���  :" docDate SKIP
			"��� �������      :" closeDate SKIP
		WITH FRAME frmGetDate OVERLAY CENTERED ROW 8 NO-LABELS
		TITLE COLOR BRIGTH-WHITE "[ ������ ]".

		UPDATE 
			docDate
			closeDate
		WITH FRAME frmGetDate.
		HIDE FRAME frmGetDate.
		

		{setdest.i}

		str[1] = '� �裡 � �������������� ���쭥�襣� �ᯮ�짮����� ��⮢ (����砭�� �ப� ' +
		          '������஢, �஫������) ��� ��᫥����� ����権 ������� �������� ��� ' +
		         account + ' �����稪 ' + client + ' ��⮩ ' + STRING(closeDate, "99/99/9999") + ".".		
		{wordwrap.i &s=str &l=80 &n=5}
		
		/** ��ନ�㥬 �ᯮ�殮��� */
		PUT UNFORMATTED SPACE(50) "� ��ࠢ����� ������ ��⮢ � ॣ���ࠨ�" SKIP
		SPACE(50) cBankName SKIP(2)
		SPACE(50) '���: ' STRING(docDate, "99/99/9999") SKIP(4)
		SPACE(25) '� � � � � � � � � � � �' SKIP(3)
		SPACE(4) str[1] SKIP.
		
		DO i = 2 TO 5:
			IF str[i] <> "" THEN PUT UNFORMATTED str[i] SKIP.
		END.
		
		/*
		SPACE(4) '���� �� �����ᮢ�� ��� � ' balAcct ' ������ ��楢�� ��� � ' valStr ' �� �������� ������᪮��' SKIP 
						'������ � ' loanInfo ' (�����稪 - ' client ') ��⮩ ' openDate '.' SKIP(3).
		*/
		
		/** ������� */
		PUT UNFORMATTED ENTRY(1,pirbosdps) SPACE(80 - LENGTH(ENTRY(1,pirbosdps))) ENTRY(2,pirbosdps) SKIP(1).
				
		PUT UNFORMATTED ENTRY(1,pirboskzn) SPACE(80 - LENGTH(ENTRY(1,pirboskzn))) ENTRY(2,pirboskzn) SKIP(1).

		if fioSpecDPS <> "" then
				PUT UNFORMATTED '����騩 ᯥ樠���� ������⭮�� �⤥��: ' SPACE(80 - LENGTH('����騩 ᯥ樠���� ������⭮�� �⤥��: ')) fioSpecDPS SKIP.
		
		{preview.i}

END.

 