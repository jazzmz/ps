/** 
	��।���� �� pirloan019.p
	��ନ஢���� �ᯮ�殮��� �� ������(��।���� �� 㢥��祭��) ����� �뤠�/������������.
	���� �.�., 12.01.2007 12:18
	
	��楤�� ����᪠���� �� ��㧥� ������஢.

	26.09.11 ��������ᮢ� ��� - �᫨ ��� �� �࠭�, � �஡㥬 ����� � �墠�뢠�饣� �������
*/

/* ������ ��।������� ᯨ᮪ ����ᮢ �� ����� �㤥� ������ "�������� �������" ��� ��⠫��� "�।�⭮�� ��������"*/
DEF INPUT PARAM ip_over_class-code AS CHAR. 

/***** � � � � � � � � � � � *****/

{globals.i}

{ulib.i} /** ������⥪� �㭪権 ��� ࠡ��� � �।��묨 ������ࠬ� */

{wordwrap.def} /** ��।������ �⨫��� ��७�� �� ᫮��� */

{get-bankname.i}


{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

DEF VAR account AS CHAR NO-UNDO. /** ����� ��� ��� ��� ����� */
DEF VAR amount AS DECIMAL NO-UNDO. /** �㬬� ����祭���� �।�� */
DEF VAR amount-str AS CHAR EXTENT 2 NO-UNDO. /** �㬬� �ய���� */
DEF VAR loaninfo AS CHAR NO-UNDO. /** ����� � ��� ������� */
DEF VAR client AS CHAR NO-UNDO. /** ������������ ������ */

DEF VAR bankname AS CHAR NO-UNDO. /** ������������ ����� */

DEF VAR str AS CHAR EXTENT 10 NO-UNDO. /** ����� �ᯮ�殮��� */

DEF VAR i AS INTEGER NO-UNDO. /* ����� */

DEF VAR bosLoan AS CHAR NO-UNDO. /* ��砫쭨� �।�⭮�� �⤥�� */
DEF VAR bosD2 AS CHAR NO-UNDO. /* ��砫쭨� �2 */
DEF VAR execUser AS CHAR NO-UNDO. /* �ᯮ���⥫� */

/** �᭮����� */
DEF VAR evidence1 AS CHAR EXTENT 10  NO-UNDO.
DEF VAR evidence AS CHAR 
	LABEL "����� �᭮�����"
	VIEW-AS 
	EDITOR SIZE 48 BY 7 NO-UNDO.


/***** � � � � � � � � � � *****/

/** ���⠥� ��砫쭨��� */
bosLoan = FGetSetting("PIRboss","PIRbosloan","").
bosD2 = FGetSetting("PIRboss","PIRbosD2","").
/** ���⠥� �ᯮ���⥫� */
FIND FIRST _user WHERE _user._userid = userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN
	execUser = _user._user-name.
ELSE
	execUser = "-".

/** ������������ ����� �� ����஥筮�� ��ࠬ��� */
bankname = cBankName.

/** ����訢��� ���� �ᯮ�殮��� - beg-date = end-date = ���������_��� */
{getdate.i} 

/** ����� ⥪�� �᭮����� */
SET evidence WITH FRAME frmTmp CENTERED.

/** ��⮪ �뢮�� � preview */
{setdest.i}


/** ��� ������� ��࠭���� �������... */
FOR EACH tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK
	:
		/** ������� ������ ���� �����⠭ �� ���� �ᯮ�殮��� + 1 ���� */
		IF TRUE THEN 
			DO:
		

/* message (loan.contract, loan.cont-code, end-date, false)
GetLoanLimit_ULL(loan.contract, loan.cont-code, end-date - 1, false). */
				/** ���쬥� ����� �뤠�/������������ */
				amount = GetLoanLimit_ULL(loan.contract, loan.cont-code, end-date, false)
									- GetLoanLimit_ULL(loan.contract, loan.cont-code, end-date - 1, false).

				IF amount > 0 THEN 
					DO:
						DEF VAR cLoanName AS CHAR NO-UNDO.
						cLoanName = (IF CAN-DO(ip_over_class-code, loan.class-code)
							THEN "�������� �������"
							ELSE "�।�⭮�� ��������").

						/** �롨ࠥ� ���ଠ�� */
						account = GetLoanAcct_ULL(loan.contract, loan.cont-code, "�।���,�।�", end-date, false).
						IF account = "" OR account = ? /* �᫨ ��� �� �࠭�, � �஡㥬 ����� � �墠�뢠�饣� ������� */
						  THEN account = GetLoanAcct_ULL(loan.contract, SUBSTR(loan.cont-code, 1, 9), "�।���,�।�", end-date, false).
						
						loaninfo = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name,open_date", false).

						client = ENTRY(1, loaninfo).

						/******************************************
						 * ����: ��᫮� �. �. (Maslov D. A.)
						 * ��� (Event): #607
						 ******************************************/
							loaninfo = getMainLoanAttr("�।��",loan.cont-code,"%cont-code �� %��⠑���").
						/*** ����� #607 ***/

						/** �㬬� �ய���� */
						RUN x-amtstr.p(amount, loan.currency, true, true, output amount-str[1], output amount-str[2]).
						amount-str[1] = amount-str[1] + ' ' + amount-str[2].
						substr(amount-str[1],1,1) = caps(substr(amount-str[1],1,1)).
				
						str[1] = /* "�������� ����� " + (IF account BEGINS "91316" THEN "�뤠�" ELSE "������������")
						         + ", ���뢠��� �� ��������ᮢ�� */

							 "����� �� ��������ᮢ�� ��� �" + account + ", ����⨥ ����� " + (IF account BEGINS "91316" THEN "�뤠�" ELSE "������������") + " � �㬬� "
						         + STRING(amount) + " (" + amount-str[1] + ") �� " + cLoanName + " �" + loaninfo 
						         + ', �����祭���� ����� ' + bankname + ' � ' + client + ".".
						
						/** ����⢥��� ��७�� �� ᫮��� */
						{wordwrap.i &s=str &l=75 &n=10}
						evidence1[1] = evidence.
				                {wordwrap.i &s=evidence1 &l=75 &n=10}
						/** �뢮� � ��⮪ */
						PUT UNFORMATTED 
												SPACE(50) "�⢥ত��" SKIP
												SPACE(50) ENTRY(1,bosD2) SKIP
												SPACE(50) ENTRY(2,bosD2) SKIP(2)
												SPACE(50) "� �����⠬��� 3" SKIP
												SPACE(50) bankname SKIP(2)
				                SPACE(50) "���: " STRING(end-date, "99/99/9999") SKIP(4)
				                SPACE(20) "� � � � � � � � � � � �" SKIP(2)
				                SPACE(4) str[1] SKIP.
				
						DO i = 2 TO 10:
							IF str[i] <> "" THEN DO:
								PUT UNFORMATTED str[i] SKIP.
							END.
						END.
				
						PUT UNFORMATTED "" SKIP(3) "�᭮�����:  " evidence1[1] skip. 
						DO i = 2 TO 10:
							IF evidence1[i] <> "" THEN DO:
								PUT UNFORMATTED evidence1[i] SKIP.
							END.
						END.
PUT UNFORMATTED                                 skip(2)
						SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(3)
						SPACE(4) '�ᯮ���⥫�: ' execUser SKIP.
				
						PUT UNFORMATTED CHR(12).
						
					END.
					ELSE
					 DO:
						PUT UNFORMATTED "�� ��।����� �㬬� ��������� ����� �뤠�. �஢���� �������� �� �᫮��� �� ��������� ����� �뤠�!" SKIP.
					 END.
				
				/** ����� �뢮�� � ��⮪ */
				
 
			
			END. 
		ELSE 
			MESSAGE "������� " + loan.cont-code + 
							" ������ ���� �����⠭ �� ���� �������, 祬 " + STRING(end-date,"99/99/9999")
							VIEW-AS ALERT-BOX.
		
END.	

/** �뢮� �� �࠭ */
{preview.i}
	