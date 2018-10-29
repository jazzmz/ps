{pirsavelog.p}

/* ------------------------------------------------------
     File: $RCSfile: pirloan031.p,v $ $Revision: 1.4 $ $Date: 2011-02-15 14:45:58 $
     Copyright: ��� �� "�p������������"
     ���������: 
     ��稭�: 
     �� ������: ��ନ��� ������ ��� �ᯮ�殮��� �� ��������� ��業⭮� �⠢��.
     ��� ࠡ�⠥�: 
     ��ࠬ����: 
     ���� ����᪠: ��㧥� �।���� ������஢.
     ����: $Author: kraskov $ 
     ���������: $Log: not supported by cvs2svn $
     ���������: Revision 1.3  2010/12/28 13:02:08  borisov
     ���������: U Maslova ne rabotaet CVS
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
DEF VAR loaninfo AS CHAR NO-UNDO. /** ����� � ��� ������� */
DEF VAR client AS CHAR NO-UNDO. /** ������������ ������ */

DEF VAR bankname AS CHAR NO-UNDO. /** ������������ ����� */

DEF VAR str AS CHAR EXTENT 15 NO-UNDO. /** ����� �ᯮ�殮��� */

DEF VAR i AS INTEGER NO-UNDO. /* ����� */

DEF VAR bosLoan AS CHAR NO-UNDO. /* ��砫쭨� �।�⭮�� �⤥�� */
DEF VAR execUser AS CHAR NO-UNDO. /* �ᯮ���⥫� */
DEF VAR bosD2 AS CHAR NO-UNDO. /* ��砫쭨� �2 */
DEF VAR bosKazna AS CHAR NO-UNDO. /* ��砫쭨� �����祩�⢠ */

DEF VAR contNum AS CHAR LABEL "���.ᮣ�. �����" FORMAT "x(10)" NO-UNDO.
DEF VAR contDate AS DATE LABEL "����" FORMAT "99/99/9999" NO-UNDO.

DEF VAR newRate AS DECIMAL LABEL "�⠢�� %" FORMAT ">9.99999" NO-UNDO.
DEF VAR newRateStr AS CHAR EXTENT 2 NO-UNDO.
DEF VAR newRateDate AS DATE LABEL "� ����" FORMAT "99/99/9999" NO-UNDO.

DEF VAR end-date AS DATE LABEL "��� ����" FORMAT "99/99/9999" NO-UNDO.

DEF FRAME editFrame 
	contNum contDate SKIP 
	newRate newRateDate SKIP
	end-date LABEL "��� �ᯮ�殮���" SKIP
	WITH SIZE 60 BY 6 SIDE-LABELS CENTERED OVERLAY TITLE "������ �����".



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


/** ��� ��ࢮ�� ��࠭���� �।�⭮�� ������� ������... */
FOR FIRST tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK
	:
				
		DISPLAY contNum contDate newRate newRateDate end-date WITH FRAME editFrame.
		
		SET contNum contDate newRate newRateDate end-date WITH FRAME editFrame.
		
		RUN x-amtstr.p(ABS(newRate), "", false, false, output newRateStr[1], output newRateStr[2]).
		/*newRateStr[1] = newRateStr[1] + ' ' + newRateStr[2].*/
		substr(newRateStr[1],1,1) = caps(substr(newRateStr[1],1,1)).

		/** ����ࠥ� ��� ����室���� ���ଠ�� */
		
		/** ����� � ��� �������, ������������ ������ */
		loaninfo = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name,open_date", false).
		client = ENTRY(1, loaninfo).
		loaninfo = loan.cont-code + " �� " + ENTRY(2,loaninfo) + "�.".

		/******************************************
		 * ����: ��᫮� �. �. (Maslov D. A.)
		 * ��� (Event): #607
		 ******************************************/
			loaninfo = getMainLoanAttr("�।��",loan.cont-code,"%cont-code �� %��⠑���").
		/*** ����� #607 ***/

		str[1] = "#tab��⠭����� � " + STRING(newRateDate, "99.99.9999") + " ��業��� �⠢�� �� ���짮����� �।�⮬ � ࠧ��� "
		         + STRING(newRate) + "% (" + newRateStr[1] + "楫�� " + newRateStr[2]  
		         + "���� ��業⮢) ������� �� �।�⭮�� �������� �" + loaninfo
		         + ", �����祭���� ����� " + client + " � " + bankname + "."
		         + "#cr#tab�ਫ������ ���㬥���: �������⥫쭮� ᮣ��襭�� �" + contNum + " �� " + STRING(contDate, "99.99.9999") 
		         + " � �������� �" + loaninfo + " (�����).".
						
		/** ����⢥��� ��७�� �� ᫮��� */
		{wordwrap.i &s=str &l=75 &n=15}
					

		/** ��।��塞 ��⮪ �뢮�� � �⠭����� 䠩�. ������ �ᯮ�殮��� � �⤥��� 䠩� */
		{setdest.i}
		
		/** �뢮� � ��⮪ */
		PUT UNFORMATTED 
												SPACE(50) "�⢥ত��" SKIP
												SPACE(50) ENTRY(1, bosD2) SKIP
												SPACE(50) ENTRY(2, bosD2) SKIP(2)
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

		PUT UNFORMATTED "" SKIP(3) 
		SPACE(4) ENTRY(1,bosKazna) SPACE(50 - LENGTH(ENTRY(1,bosKazna))) ENTRY(2,bosKazna) SKIP(3)
		SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(3)
		SPACE(4) '�ᯮ���⥫�: ' execUser SKIP.
		
		
		/** �����뢠�� �ᯮ�殮��� �� ��࠭� */
		{preview.i}
END.
