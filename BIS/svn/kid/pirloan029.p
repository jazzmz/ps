{pirsavelog.p}

/* ------------------------------------------------------
     File: $RCSfile: pirloan029.p,v $ $Revision: 1.7 $ $Date: 2011-02-15 14:45:58 $
     Copyright: ��� �� "�p������������"
     ���������: 
     ��稭�: 
     �� ������: ��ନ��� ������ ��� �ᯮ�殮��� �� ���� ���.ᮣ��襭��. � �������� 
                 �����⥫��⢠/������ � ���������� �㬬�.
     ��� ࠡ�⠥�: 
     ��ࠬ����: {1|2},{��|���} 
                ��� [1] - ⨯ ������� ���ᯥ祭�� (1 - �����⥫��⢮, 2 - �����)
                    [2] - �뢮���� �� � ⥪�� ��������� �㬬�.
     ���� ����᪠: ��㧥� �।���� ������஢.
     ����: $Author: kraskov $ 
     ���������: $Log: not supported by cvs2svn $
     ���������: Revision 1.6  2010/12/28 13:02:08  borisov
     ���������: U Maslova ne rabotaet CVS
     ���������:
     ���������: Revision 1.4  2010/09/30 08:57:59  Buryagin
     ���������: Fix: added a amount value into the combo-box widget for the list of warranties.
     ���������:
     ���������: Revision 1.3  2008/05/21 13:31:39  Buryagin
     ���������: *** empty log message ***
     ���������:
     ���������: Revision 1.2  2007/10/18 07:42:23  anisimov
     ���������: no message
     ���������:
     ���������: Revision 1.1  2007/09/21 12:28:22  buryagin
     ���������: *** empty log message ***
     ���������:
------------------------------------------------------ */


{globals.i} /** ��।������ ��������� ��ࠬ��஢, ����஥� � �.�. */
{ulib.i} /* �������� ᢮� ������⥪� �㭪権 */
{wordwrap.def} /** ��।������ �⨫��� ��७�� �� ᫮��� */

/* ������ �����䨪��஢ ����ᥩ, ��࠭��� � �����-���� ��㧥� */
{tmprecid.def}

{get-bankname.i}


pause 0.

DEF INPUT PARAM iParam AS CHAR.
DEF VAR oblTypeIdx AS INTEGER NO-UNDO. /** ������ � ���ᨢ� oblType */
DEF VAR amount AS DECIMAL NO-UNDO. /** �㬬� ���ᯥ祭�� */
DEF VAR amount-str AS CHAR EXTENT 2 NO-UNDO. /** �㬬� �ய���� */
DEF VAR terminfo AS CHAR NO-UNDO. /** ����� � ��� ���ᯥ祭�� */
DEF VAR loaninfo AS CHAR NO-UNDO. /** ����� � ��� ������� */
DEF VAR client AS CHAR NO-UNDO. /** ������������ ������ */
DEF VAR guarantor AS CHAR NO-UNDO. /** ������������ �����⥫� */

DEF VAR bankname AS CHAR NO-UNDO. /** ������������ ����� */

DEF VAR str AS CHAR EXTENT 15 NO-UNDO. /** ����� �ᯮ�殮��� */

DEF VAR i AS INTEGER NO-UNDO. /* ����� */

DEF VAR bosLoan AS CHAR NO-UNDO. /* ��砫쭨� �।�⭮�� �⤥�� */
DEF VAR execUser AS CHAR NO-UNDO. /* �ᯮ���⥫� */

DEF VAR srgt AS CHAR NO-UNDO. /** ���祭�� ���� signs.surrogate */

DEF VAR contNum AS CHAR LABEL "���.ᮣ�. �����" FORMAT "x(10)" NO-UNDO.
DEF VAR contDate AS DATE LABEL "����" FORMAT "99/99/9999" NO-UNDO.

DEF VAR oblNum AS CHAR LABEL "����� ���ᯥ祭��" FORMAT "x(20)"
	VIEW-AS COMBO-BOX LIST-ITEM-PAIRS "","" INNER-LINES 5
.

DEF VAR end-date AS DATE LABEL "��� ����" FORMAT "99/99/9999" NO-UNDO.

DEF FRAME editFrame 
	contNum contDate SKIP 
	oblNum SKIP 
	end-date LABEL "��� �ᯮ�殮���" SKIP
	amount LABEL "�㬬� ���������" FORMAT "->>>,>>>,>>>,>>9.99"
	WITH SIZE 60 BY 6 SIDE-LABELS CENTERED OVERLAY TITLE "������ �����".


/** � �⮬ ���ᨢ� �࠭���� �������� ⨯�� ���ᯥ祭�� � த�⥫쭮� ������. ������ �ᯮ��㥬��� �����
    �������� � ��ࠬ��� iParam �����饩 �㭪樨 */
DEF VAR oblType AS CHAR EXTENT 2 INITIAL ["�����⥫��⢠", "������"] NO-UNDO.

/***** � � � � � � � � � � *****/

/** �����६ ��ࠬ��� ��楤��� */
oblTypeIdx = INT(ENTRY(1, iParam)) NO-ERROR.
IF ERROR-STATUS:ERROR OR oblTypeIdx > EXTENT(oblType) OR oblTypeIdx < 1 THEN DO:
	MESSAGE "�訡�� ������� ��ࠬ��� ��楤���! ���祭�� ������ ���� 楫� �᫮� �� 1 �� " + STRING(EXTENT(oblType)) + "."
	     VIEW-AS ALERT-BOX.
	RETURN.
END.


/** ���⠥� ��砫쭨��� */
bosLoan = FGetSetting("PIRboss","PIRbosloan","").
/** ���⠥� �ᯮ���⥫� */
FIND FIRST _user WHERE _user._userid = userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN
	execUser = _user._user-name.
ELSE
	execUser = "-".

/** ������������ ����� �� ����஥筮�� ��ࠬ��� */
bankname = cBankName.


/** ��� ��ࢮ�� ��࠭���� �।�⭮�� ������� ������... */
FOR FIRST tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK
	:
		/** �㦭�, �⮡� ���짮��⥫� ����� ���� � ��ࠫ �� �।��������� ��� ᯨ᪠ �� ������� ���ᯥ祭��
		    �� ���஬� ��� ����室��� �ᯥ���� �ᯮ�殮��� */
		FOR EACH term-obl WHERE 
				term-obl.contract = loan.contract
				AND
				term-obl.cont-code = loan.cont-code
				AND
				term-obl.idnt = 5 
				NO-LOCK
			:
				srgt = term-obl.contract + "," + term-obl.cont-code + "," + STRING(term-obl.idnt) 
							+ "," + STRING(term-obl.end-date) + "," + STRING(term-obl.nn).
				oblNum:ADD-LAST(GetXAttrValueEx("term-obl", srgt, "��������", "�/�") + " - " + STRING(term-obl.amt-rub), STRING(RECID(term-obl))) IN FRAME editFrame.
		END.
				
		DISPLAY contNum contDate oblNum end-date amount WITH FRAME editFrame.
		
		
		/** �᫨ 2-�� ��ࠬ��� = ��, � ���짮��⥫� ������ ����� �㬬� */
		IF ENTRY(2, iParam) = "��" THEN 
			DO:
				SET contNum contDate oblNum end-date amount WITH FRAME editFrame.
				RUN x-amtstr.p(ABS(amount), loan.currency, true, true, output amount-str[1], output amount-str[2]).
							amount-str[1] = amount-str[1] + ' ' + amount-str[2].
				substr(amount-str[1],1,1) = caps(substr(amount-str[1],1,1)).
			END.
		ELSE
			SET contNum contDate oblNum end-date WITH FRAME editFrame.
		
		FIND FIRST term-obl WHERE RECID(term-obl) = INT(oblNum:SCREEN-VALUE) 
				NO-LOCK.
		
		/** ����ࠥ� ��� ����室���� ���ଠ�� */
		
		/** ����� � ��� ���ᯥ祭�� */
		srgt = term-obl.contract + "," + term-obl.cont-code + "," + STRING(term-obl.idnt) 
					+ "," + STRING(term-obl.end-date) + "," + STRING(term-obl.nn).
		terminfo = GetXAttrValueEx("term-obl", srgt, "��������", "�/�") + " �� " + STRING(term-obl.fop-date, "99.99.9999").
		
		/** ����� � ��� �������, ������������ ������, ������������ �����⥫� */
		loaninfo = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name,open_date,guarantor_name(" + STRING(RECID(term-obl)) + ")", true).
		client = ENTRY(1, loaninfo).
		guarantor = ENTRY(3, loaninfo).

		loaninfo = loan.cont-code + " �� " + ENTRY(2,loaninfo).

		/******************************************
		 * ����: ��᫮� �. �. (Maslov D. A.)
		 * ��� (Event): #607
		 ******************************************/
			loaninfo = getMainLoanAttr("�।��",loan.cont-code,"%cont-code �� %��⠑���").
		/*** ����� #607 ***/

		str[1] = "#tab���� �ਭ��� �������⥫쭮� ᮣ��襭�� �" + contNum + " �� " + STRING(contDate, "99.99.9999") 
										+ " � �������� " + oblType[oblTypeIdx] + " �" + terminfo
										+ ', �����祭���� ����� ' + bankname + ' � ' + guarantor 
										+ ", ��� ���쭥�襣� ���". 

		IF ENTRY(2, iParam) = "��" THEN 
			DO:
				str[1] = str[1] + " � " + (IF amount >= 0 THEN "㢥�����" ELSE "㬥�����") + " �㬬� " + oblType[oblTypeIdx] 
				         + " �� " + STRING(ABS(amount)) + " (" + amount-str[1] + ") ��⮩ " + STRING(end-date, "99.99.9999") + "�".
			END.
		
		str[1] = str[1] + "." + CHR(10)
						 + "#cr#tab�ਫ������ ���㬥���: �������⥫쭮� ᮣ��襭�� �" + contNum + " �� " 
						 + STRING(contDate, "99.99.9999") + " � �������� " + oblType[oblTypeIdx] + " �" + terminfo + " (�����).".
						
		/** ����⢥��� ��७�� �� ᫮��� */
		{wordwrap.i &s=str &l=75 &n=15}
					

		/** ��।��塞 ��⮪ �뢮�� � �⠭����� 䠩�. ������ �ᯮ�殮��� � �⤥��� 䠩� */
		{setdest.i}
		
		/** �뢮� � ��⮪ */
		PUT UNFORMATTED 
	  						SPACE(50) "� �����⠬��� 3" SKIP
								SPACE(50) bankname SKIP(2)
	     	        SPACE(50) "���: " STRING(end-date, "99/99/9999") SKIP(4)
	     		      SPACE(20) "� � � � � � � � � � � �" SKIP(2).
		DO i = 1 TO 15:
			IF str[i] <> "" THEN DO:
				str[i] = REPLACE(str[i], "#tab",CHR(9)).
				str[i] = REPLACE(str[i], "#cr", CHR(10)).
				PUT UNFORMATTED str[i] SKIP.
			END.
		END.

		PUT UNFORMATTED "" SKIP(3) SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(3)
		SPACE(4) '�ᯮ���⥫�: ' execUser SKIP.
		
		
		/** �����뢠�� �ᯮ�殮��� �� �࠭� */
		{preview.i}
END.

