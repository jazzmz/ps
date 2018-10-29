{pirsavelog.p}

/*
**	���� �.�.
**	06.12.2005 12:11
**	��楤�� �ନ஢���� �ᯮ�殮��� �� ����襭�� �᭮����� ����� �� �।�⭮�� ��������
*/

{globals.i}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{ulib.i}
{get-bankname.i}

def var ClientName as char no-undo.
def var Loan as char no-undo.
def var LoanDate as date no-undo.
def var PayAcct as char no-undo.
def var LoanAcct as char no-undo.
def var Amount as decimal no-undo.
def var AmtStr as char extent 2 no-undo.
def var StrEarlyPartic as char no-undo.
def var ExecFIO as char no-undo.
def var usersFIO as char no-undo.
def var PIRbosloan as char no-undo.
def var PIRbosloanFIO as char no-undo.
def var LoanCur as char no-undo.
PIRbosloan = ENTRY(1,FGetSetting("PIRboss","PIRbosloan","")).
PIRbosloanFIO = ENTRY(2,FGetSetting("PIRboss","PIRbosloan","")).

/* ========================================================================= */


/* ========================================================================= */

find first _user where _user._userid = userid no-lock no-error.
if avail _user then
	ExecFIO = _user._user-name.
else
	ExecFIO = "-".

/* ========================================================================= */


FOR FIRST tmprecid 
         NO-LOCK,
   FIRST op WHERE 
         RECID(op) EQ tmprecid.id 
         NO-LOCK, 
   FIRST op-entry OF op
         NO-LOCK
:
	/* �㬬� ����樨 */
	if op-entry.currency = "" then
		do:
			/* �㡫� */
			Amount = op-entry.amt-rub.
		end.
	else
		do:
			/* ����� */
			Amount = op-entry.amt-cur.
		end.
	/* �㬬� �ய���� */
	Run x-amtstr.p(Amount,op-entry.currency,true,true,output amtstr[1], output amtstr[2]).
  AmtStr[1] = AmtStr[1] + ' ' + AmtStr[2].
	Substr(AmtStr[1],1,1) = Caps(Substr(AmtStr[1],1,1)).
 	
	
	find first loan-acct where 
			loan-acct.acct = op-entry.acct-cr 
			and
			loan-acct.acct-type = "�।��"
			no-lock no-error.
	if avail loan-acct then
		do:
			/* ��㤭� ��� */
			LoanAcct = loan-acct.acct.
			LoanCur = SUBSTRING(LoanAcct,6,3).
			
			find first loan where
				loan.contract = loan-acct.contract 
				and 
				loan.cont-code = loan-acct.cont-code
			no-lock no-error.
			if avail loan then
				do:
					/* ����� ������� */
					Loan = loan.cont-code.
					
					/* ��� ������ */
					LoanDate = loan.open-date.
					find first signs where 
							signs.code = "��⠑���"
							and
							signs.file-name = "loan"
							and
							signs.surrogate = "�।��," + Loan
							no-lock no-error.
					if avail signs then
						LoanDate = DATE(signs.code-value).
							
					/* ����稬 �������� ������ */

					ClientName = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", false).

					/** Buryagin commented at 6/10/2010
					if loan.cust-cat = "�" then
						do:
							find first cust-corp where cust-corp.cust-id = loan.cust-id no-lock no-error.
							if avail cust-corp then
								do:
									ClientName = cust-corp.cust-stat + " " + cust-corp.name-corp.
									ClientName = cust-corp.name-short.
								end.
							else
								message "� ������� ��� ������!" view-as alert-box.
						end.
					if loan.cust-cat = "�" then
						do:
							find first person where person.person-id = loan.cust-id no-lock no-error.
							if avail person then
								do:
									ClientName = person.name-last + " " + person.first-names.
								end.
						end.
					����稫� �������� ������ */
					
				end.
			else
				message "��� �� �।��� �ਢ易� � ���������饬� ��������!" view-as alert-box.
		end.
	else
		message "��� �� �।��� �� �ਢ易� � �।�⭮�� �������� ��� �� ���� ��㤭� ��⮬!" view-as alert-box.
	
	PayAcct = op-entry.acct-db.
	
/* ======================================================================================================= */
{setdest.i}

put unformatted SPACE(50) "� �����⠬��� 3" SKIP
								SPACE(50) "� �����⠬��� 4" SKIP
								SPACE(50) cBankName SKIP(3)
								SPACE(50) op.op-date FORMAT "99/99/9999" SKIP(5)
			SPACE(25) "� � � � � � � � � � � �" SKIP(3)
			"            �ந�����  � � � � � � � � � �  �������� �।��:" SKIP(2)
			"        �������������������������������������������������������������������������������" SKIP
			"        �㬬�:               �" Amount format ">,>>>,>>>,>>>,>>9.99" SKIP
			"                             �(" AmtStr[1] ")" SKIP
			"        �������������������������������������������������������������������������������" SKIP
			"        �� ���:             �" LoanAcct format "x(20)" SKIP
			"        �������������������������������������������������������������������������������" SKIP
			"        ����騪:             �" ClientName SKIP
			"        �������������������������������������������������������������������������������" SKIP
			"        ����ᯮ������騩    �" PayAcct SKIP
			"        ���:                �" SKIP
			"        �������������������������������������������������������������������������������" SKIP
			"        �।��� �������:   �" getMainLoanAttr(loan.contract,loan,"� %cont-code �� %��⠑���")  SKIP
			"        �������������������������������������������������������������������������������" SKIP
			"        �����:              �" LoanCur SKIP
			"        �������������������������������������������������������������������������������" SKIP
			"        ��� ����樨:        �����襭�� �᭮����� ����� �� �।���" SKIP
			"        �������������������������������������������������������������������������������" SKIP(4)
			"       " PIRbosloan SPACE(70 - LENGTH(PIRbosloan)) PIRbosloanFIO SKIP(4)
			"        �ᯮ���⥫�: " ExecFIO SKIP(4)
			"        �⬥⪠ �����⠬��� ��� � ���⭮��:" SKIP.

{preview.i}
/* ======================================================================================================= */
END.

