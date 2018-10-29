{pirsavelog.p}

/**
		��ନ஢���� �ᯮ�殮��� �� ��७�� �।�� � ������ ������⭮�� ��� �� ��㣮� � ࠬ��� ������
		������⭮�� ������� � �裡 � �த������ �ப� ����砭�� (�஫����樥�).
		
		���� �.�., 12.03.2007 9:16
		
		����᪠���� �� ��㧥� ������஢ ��.
		
		��楤�� �ॡ��, �⮡� �� ������ ����᪠ ��� ����砭�� ������� 㦥 �뫠 
		������� �����, � ���� �������� ��� �ਢ易�.
		
		��楤�� ����訢��� ���� �ᯮ�殮���. �।����������, �� ���� �������� ��� �ਢ易� 
		� �⮩ ����. ���� �������� ��� ��楤�� ��� �� ���� ࠢ��� ��� �ᯮ�殮��� �� ����ᮬ ���� ����.
*/

{globals.i}
{wordwrap.def}
{intrface.get xclass}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

DEF VAR docDate AS DATE LABEL "��� �ᯮ�殮���" FORMAT "99/99/9999". /** ��� �ᯮ�殮��� */
DEF VAR transDate AS DATE LABEL "��� ��ॢ��� �।��" FORMAT "99/99/9999". /** ��� ��७�� �।�� */

DEF VAR client AS CHAR. /** ��� ������ */
DEF VAR oldacct AS CHAR. /** ���� �������� ��� */
DEF VAR newacct AS CHAR. /** ���� �������� ��� */
DEF VAR amount AS DECIMAL. /** ��७�ᨬ�� �㬬� */
DEF VAR amountStr AS CHAR EXTENT 2. /** ��� �� �ய���� */
DEF VAR loanInfo AS CHAR. /** ����� � ��� ������� */
DEF VAR condInfo AS CHAR. /** ����� � ��� ���.ᮣ��襭�� */
DEF VAR tmpStr AS CHAR EXTENT 10. /** ��� �६����� �㦤 */
DEF VAR bankName AS CHAR. /** ������������ ��襣� ����� */
DEF VAR i AS INTEGER. /** ����� */


/** ������������ ��襣� ����� �� ����஥筮�� ��ࠬ��� */
{get-bankname.i}
bankName = cBankName.

/** ��� */
DEF VAR pirbosdps AS CHAR  NO-UNDO.
pirbosdps = FGetSetting("PIRboss","PIRbosdps","").
DEF VAR pirboskzn AS CHAR  NO-UNDO.
pirboskzn = FGetSetting("PIRboss", "PIRbosKazna","").

{ulib.i}

pause 0.
/** ����訢��� ���� */
docDate = TODAY.
transDate = TODAY.
UPDATE docDate SKIP transDate WITH FRAME editFrame CENTERED SIDE-LABELS OVERLAY.

{setdest.i}
 
/** ���� ��࠭���� ������� */
FOR FIRST tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK,
		LAST loan-cond WHERE 
			loan-cond.contract = loan.contract 
			AND 
			loan-cond.cont-code = loan.cont-code
			AND
			loan-cond.since LE docDate NO-LOCK
	:
		/** ���쬥� ���� ������ ������� � ������������ ������ */
		loanInfo = GetLoanInfo_ULL(loan.contract, loan.cont-code, "open_date,client_short_name", false).
		client = ENTRY(2, loanInfo).
		loanInfo = loan.cont-code + " �� " + ENTRY(1, loanInfo).
		
		/** ���쬥� ४������ ���.ᮣ��襭�� */
		condInfo = GetXAttrValueEx("loan-cond", loan.contract + "," + loan.cont-code + "," + STRING(loan-cond.since), "PIRNumber", "�/�")
				 + " �� " + STRING(loan-cond.since, "99/99/9999").
				
		/** ���쬥� ��� */
		oldAcct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "loan-dps-t", transDate - 1, false).
		newAcct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "loan-dps-t", transDate, false).
		
		/** �㬬� ��ࠬ� � �ய���� */
		amount = ABS(GetAcctPosValue_UAL(oldAcct, loan.currency, transDate, false)).
		Run x-amtstr.p(amount, loan.currency, true, true, 
				output amountStr[1], 
				output amountStr[2]).
	  amountStr[1] = amountStr[1] + ' ' + amountStr[2].
		Substr(amountStr[1],1,1) = Caps(Substr(amountStr[1],1,1)).
		
		/** � tmpStr ��࠭�� �᭮���� ⥪�� �ᯮ�殮��� */
		tmpStr[1] = "#tab� �裡 � �த������ �� " + STRING(loan.end-date, "99/99/9999") + " ���. �ப� ������ ������,"
						+ " ࠧ��饭���� �� �������� ������᪮�� ������ �" + loanInfo + " �. (�����稪 - " + client + ")"
						+ " ���� ��ॢ��� � ������⭮�� ��� �" + oldacct + " �� �������� ��� �" + newAcct
						+ " �㬬� ������ � ࠧ��� " + STRING(amount) + " (" + amountStr[1] + ") ��⮩ " 
						+ STRING(transDate, "99/99/9999") + " �. " + CHR(10)
						+ "#cr#cr�ਫ������ ���㬥���: �������⥫쭮� ᮣ��襭�� � " + condInfo + " � �������� ������᪮�� ������ �" 
						+ loanInfo + " �. (�����)".
						
		{wordwrap.i &s=tmpStr &l=80 &n=10}

		/** ��ନ�㥬 �ᯮ�殮��� */
		PUT UNFORMATTED SPACE(50) "� �����⠬��� 3" SKIP
		SPACE(50) bankName SKIP(2)
		SPACE(50) '���: ' STRING(docDate, "99/99/9999") SKIP(4)
		SPACE(25) '� � � � � � � � � � � �' SKIP(3).
		
		DO i = 1 TO 10:
							IF tmpstr[i] <> "" THEN DO:
								tmpstr[i] = REPLACE(tmpstr[i], "#tab",CHR(9)).
								tmpstr[i] = REPLACE(tmpstr[i], "#cr", CHR(10)).
								PUT UNFORMATTED tmpstr[i] SKIP.
							END.
		END.
		
		PUT "" SKIP(3).
		
		/** ������� */
		PUT UNFORMATTED ENTRY(1,pirbosdps) SPACE(80 - LENGTH(ENTRY(1,pirbosdps))) ENTRY(2,pirbosdps) SKIP(1).
				
		PUT UNFORMATTED ENTRY(1,pirboskzn) SPACE(80 - LENGTH(ENTRY(1,pirboskzn))) ENTRY(2,pirboskzn) SKIP.
						
		
END.
 
{preview.i}