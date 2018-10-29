{pirsavelog.p}

/**
		��ନ஢���� ���⭮� ��� �ᯮ�殮��� �� ��७�� ��㤭�� ������������ � ������ ��楢��� ��� �� ��㣮� ��楢�� ���
		� ࠬ��� ������ �।�⭮�� ������� � �裡 � �஫����樥�.
		
		���� �.�., 03.03.2007 14:28
		
*/

/***** � � � � � � � � � � � *****/

{globals.i}
{ulib.i} /** ������⥪� �㭪権 ��� ࠡ��� � �।��묨 ������ࠬ� */
{wordwrap.def} /** ��।������ �⨫��� ��७�� �� ᫮��� */
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{get-bankname.i}

DEF VAR oldaccount AS CHAR NO-UNDO. /** ����� "��ண�" ��㤭��� ���  */
DEF VAR newaccount AS CHAR NO-UNDO. /** ����� "��ண�" ��㤭��� ���  */

DEF VAR amount AS DECIMAL NO-UNDO. /** �㬬� ����� */
DEF VAR amount-str AS CHAR EXTENT 2 NO-UNDO. /** �㬬� �ய���� */
DEF VAR loaninfo AS CHAR NO-UNDO. /** ����� � ��� ������� */
DEF VAR client AS CHAR NO-UNDO. /** ������������ ������ */

DEF VAR bankname AS CHAR NO-UNDO. /** ������������ ����� */

DEF VAR str AS CHAR EXTENT 10 NO-UNDO. /** ����� �ᯮ�殮��� */

DEF VAR i AS INTEGER NO-UNDO. /* ����� */
                     
DEF VAR end-date AS DATE NO-UNDO. /** ��� �ᯮ�殮��� */
DEF VAR opDate AS DATE NO-UNDO. /** ��� ����樨 ��७�� �।�� */

DEF VAR bosD2 AS CHAR NO-UNDO. /* ��砫쭨� �2 */
DEF VAR bosLoan AS CHAR NO-UNDO. /* ��砫쭨� �।�⭮�� �⤥�� */
DEF VAR bosKazna AS CHAR NO-UNDO. /* ��砫쭨� �����祩�⢠ */
DEF VAR execUser AS CHAR NO-UNDO . /* �ᯮ���⥫� */

def var summ as dec 
	     LABEL "�㬬�"
		
        NO-UNDO.

/** �᭮����� */
DEF VAR evidence AS CHAR 
	LABEL "����� �᭮�����"
	VIEW-AS 
	EDITOR SIZE 48 BY 7.


/***** � � � � � � � � � � *****/

/** ���⠥� ��砫쭨��� */
bosLoan = FGetSetting("PIRboss","PIRbosloan","").
bosD2 = FGetSetting("PIRboss","PIRbosD2","").
bosKazna = FGetSetting("PIRboss","PIRbosKazna","").

/** ���⠥� �ᯮ���⥫� */
FIND FIRST _user WHERE _user._userid = userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN
	execUser = _user._user-name.
ELSE
	execUser = "-".

/** ������������ ����� �� ����஥筮�� ��ࠬ��� */
bankname = cBankName.

/** ����訢��� ���� �ᯮ�殮��� � ���� ����樨 */
/** ����� ⥪�� �᭮����� */
pause 0.
end-date = TODAY. opDate = TODAY.
UPDATE end-date LABEL "��� �ᯮ�殮���" opDate LABEL "��� ��७��" SKIP evidence SKIP summ FORMAT ">>>,>>>,>>>,>>9.99"  WITH FRAME frmTmp CENTERED SIDE-LABELS OVERLAY.

/** ��⮪ �뢮�� � preview */
{setdest.i &cols=90}

FOR FIRST tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK
	:
		/** ����� � ��� �������, ������������ ������ */
		loaninfo = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name,open_date", false).
		client = ENTRY(1, loaninfo).

		/******************************************
		 * ����: ��᫮� �. �. (Maslov D. A.)
		 * ��� (Event): #607
		 ******************************************/
			loaninfo = getMainLoanAttr("�।��",loan.cont-code,"%cont-code �� %��⠑���").
		/*** ����� #607 ***/
		
		/** ��� ������� */
		newaccount = GetLoanAcct_ULL(loan.contract, loan.cont-code, "�।��", end-date, false).
		/** �।����������, �� �ᯮ�殮��� �ନ����� � ���� �ਢ離� ������ ��� */
		oldaccount = GetLoanAcct_ULL(loan.contract, loan.cont-code, "�।��", end-date - 1, false).
		
		/** ���⮪ ��㤭�� ������������ ��ࠬ� � �ய���� */
		amount = GetAcctPosValue_UAL(oldaccount, loan.currency, end-date, false).

		if summ > amount then do:
		message "���⮪ �� ���: " amount VIEW-AS ALERT-BOX.
                end.
		if summ <> 0 and summ <= amount then amount = summ.

		RUN x-amtstr.p(amount, loan.currency, true, true, output amount-str[1], output amount-str[2]).
		amount-str[1] = amount-str[1] + ' ' + amount-str[2].
		substr(amount-str[1],1,1) = caps(substr(amount-str[1],1,1)).

		/** �᭮���� ⥪�� �ᯮ�殮��� */
		str[1] = "#tab� �裡 �த������ �� " + STRING(loan.end-date, "99/99/9999") + " ���. �ப� ������ �।��, "
						+ "�뤠����� �� �।�⭮�� �������� �" + loaninfo + " (����騪 - " + client 
						+ "), ���� ��७��� � ��� �" + oldaccount + " �� ��� �" + newaccount
						+ " �㬬� � ࠧ��� " + STRING(amount) + " (" + amount-str[1] + ") ��⮩ " + STRING(opDate, "99/99/9999") 
						+ "�.".
						
		/** ��७�� �� ᫮��� */
		{wordwrap.i &s=str &l=75 &n=10}
					
		/** �뢮� � ��⮪ */
		PUT UNFORMATTED 
												SPACE(50) "�⢥ত��" SKIP
												SPACE(50) ENTRY(1, bosD2) SKIP
												SPACE(50) ENTRY(2, bosD2) SKIP(2)
												SPACE(50) "� �����⠬��� 3" SKIP
												SPACE(50) bankname SKIP(2)
				                SPACE(50) "���: " STRING(end-date, "99/99/9999") SKIP(4)
				                SPACE(20) "� � � � � � � � � � � �" SKIP(2).
				
		DO i = 1 TO 10:
							IF str[i] <> "" THEN DO:
								str[i] = REPLACE(str[i], "#tab",CHR(9)).
								str[i] = REPLACE(str[i], "#cr", CHR(10)).
								PUT UNFORMATTED str[i] SKIP.
							END.
		END.
				
		PUT UNFORMATTED "" SKIP(3) "�᭮�����: " evidence "(�����)" SKIP(4) 
						SPACE(4) ENTRY(1,bosKazna) SPACE(50 - LENGTH(ENTRY(1,bosKazna))) ENTRY(2,bosKazna) SKIP(3)
						SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(3)
						SPACE(4) '�ᯮ���⥫�: ' execUser SKIP.
		
END.


/** �뢮� �� �࠭ */
{preview.i}
