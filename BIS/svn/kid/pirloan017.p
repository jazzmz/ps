{pirsavelog.p}

/** 
	pirloan017.p
	��ନ஢���� �ᯮ�殮��� �� ���� �㬬� ����祭��� ������������ �� �।���.
	���� �.�., 10.01.2007 10:51
	
	��楤�� ����᪠���� �� ��㧥� ������஢.
	1 ��ਠ��: �� ��࠭���� �������� �ணࠬ�� ��ᬠ�ਢ���:
		�) ��䨪 ����襭�� ��㤭�� ������������;
		�) �㬬�, ����᫥���� � ��� ����襭�� �㤭�� ������������.
		
	2 ��ਠ��: �� ��࠭���� �������� �ணࠬ�� ��ᬠ�ਢ���:
		���祭�� ��ࠬ��� 13, ���⠭���� �� ���� <���_�ᯮ�殮���> + 1 ����
		
*/

/***** � � � � � � � � � � � *****/

{globals.i}

{ulib.i} /** ������⥪� �㭪権 ��� ࠡ��� � �।��묨 ������ࠬ� */

{wordwrap.def} /** ��।������ �⨫��� ��७�� �� ᫮��� */

{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{get-bankname.i}

DEF VAR account AS CHAR. /** ����� ��� ��� ��� ����祭���� �।�� */
DEF VAR amount AS DECIMAL. /** �㬬� ����祭���� �।�� */
DEF VAR amount-str AS CHAR EXTENT 2. /** �㬬� �ய���� */
DEF VAR loaninfo AS CHAR. /** ����� � ��� ������� */
DEF VAR client AS CHAR. /** ������������ ������ */

DEF VAR bankname AS CHAR. /** ������������ ����� */

DEF VAR str AS CHAR EXTENT 10. /** ����� �ᯮ�殮��� */

DEF VAR i AS INTEGER. /* ����� */

DEF VAR bosLoan AS CHAR. /* ��砫쭨� �।�⭮�� �⤥�� */
DEF VAR execUser AS CHAR. /* �ᯮ���⥫� */

/***** � � � � � � � � � � *****/

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

/** ����訢��� ���� �ᯮ�殮��� - beg-date = end-date = ���������_��� */
{getdate.i} 
/** ��⮪ �뢮�� � preview */
{setdest.i}


/** ��� ������� ��࠭���� �������... */
FOR EACH tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK
	:
		/** ������� ������ ���� �����⠭ �� ���� �ᯮ�殮��� + 1 ���� */
		IF loan.since GT end-date THEN 
			DO:
		        /*
				/** ������ �㬬� ����祭���� �।��, �ᯮ���� 2-�� ��ਠ�� �� ��襯ਢ�������� ���ᠭ�� */
				amount = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 13, end-date + 1, false).

				/****************************
				 * Modified by Maslov D. A. *
				 * Event: #542              *
                                 ****************************/

				amount = amount + GetLoanParamValue_ULL(loan.contract, loan.cont-code, 7, end-date + 1, false).
                                                         */

				/*** End Event #542 ***/

				find last term-obl WHERE term-obl.cont-code EQ loan.cont-code 
						     AND term-obl.contract EQ '�।��' 
						     AND term-obl.idnt EQ 3
						     AND term-obl.end-date = end-date 
						     NO-LOCK.
				if available term-obl then amount = term-obl.amt-rub.


				IF amount > 0 THEN 
					DO:
						/** �롨ࠥ� ���ଠ�� */
						account = GetLoanAcct_ULL(loan.contract, loan.cont-code, "�।��", end-date, false).
						loaninfo = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name,open_date", false).
						client = ENTRY(1, loaninfo).
		/******************************************
		 * ����: ��᫮� �. �. (Maslov D. A.)
		 * ��� (Event): #607
		 ******************************************/
			loanInfo = getMainLoanAttr("�।��",loan.cont-code,"%cont-code �� %��⠑���").
		/*** ����� #607 ***/
						
						/** �㬬� �ய���� */
						RUN x-amtstr.p(amount, loan.currency, true, true, output amount-str[1], output amount-str[2]).
						amount-str[1] = amount-str[1] + ' ' + amount-str[2].
						substr(amount-str[1],1,1) = caps(substr(amount-str[1],1,1)).
				
						str[1] = "���� ����� �� ��� �" + account + " �㬬� ������襭��� � �ப ������������ �� �।��� � ࠧ��� " +
									STRING(amount) + " (" + amount-str[1] + ") �� �।�⭮�� �������� �" + loaninfo + ", �����祭���� ����� " +
									cBankName + ' � ' + client + ".".
							
						/** ����⢥��� ��७�� �� ᫮��� */
						{wordwrap.i &s=str &l=75 &n=10}
				
						/** �뢮� � ��⮪ */
						PUT UNFORMATTED 
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
				
						PUT UNFORMATTED "" SKIP(3) 
						SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(3)
						SPACE(4) '�ᯮ���⥫�: ' execUser SKIP.
				
						PUT UNFORMATTED CHR(12).
						
					END.
				
				/** ����� �뢮�� � ��⮪ */
				
 
			
			END. 
		ELSE 
			MESSAGE "������� " + loan.cont-code + 
							" ������ ���� �����⠭ �� ���� �������, 祬 " + STRING(end-date,"99/99/9999")
							VIEW-AS ALERT-BOX.
		
END.	

/** �뢮� �� ��࠭ */
{preview.i}
