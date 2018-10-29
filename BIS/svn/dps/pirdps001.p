{pirsavelog.p}

/*
**	���� �.�.
**	06.12.2005 12:11
**	��楤�� �ନ஢���� �ᯮ�殮��� �� ���᫥��� ��業⮢ �� �� 
*/

{globals.i}
{ulib.i}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{get-bankname.i}
def var ClientName as char no-undo.
def var Loan as char no-undo.
def var PrintLoan as char no-undo.
def var LoanDate as date no-undo.
def var PayAcct as char no-undo.
def var LoanAcct as char no-undo.
def var RateAcct as char no-undo.
def var LoanCur as char no-undo.
def var Amount as decimal no-undo.
def var AmountFuture as decimal no-undo.
def var AmtStr as char extent 2 no-undo.
def var ExecFIO as char no-undo.
def var usersFIO as char no-undo.
def var Rate as decimal no-undo.
def var PeriodBase as integer initial 365 no-undo. /* ���� ���᫥��� ��業⮢ 365/366 ���� � ���� */

def var Summa as decimal no-undo.
def var PrePaySumma as decimal no-undo.
def var TotalSumma as decimal initial 0 no-undo.

def var Balance as decimal no-undo.

def var Period as integer no-undo.
def var PeriodBegin as date no-undo.
def var PeriodEnd as date no-undo.

def var StrTable as char no-undo.
def var Appendix0 as char no-undo.
def var Appendix1 as char no-undo.
def var cr as char no-undo.
cr = CHR(10).

def var beg_date as date no-undo.
def var beg_date_2 as date no-undo.
def var end_date as date no-undo.

def buffer bfr-op-entry for op-entry.
def buffer bfr-op for op.
def var isCloseLoan as logical initial "no" no-undo.

def var PIRbosU5 as char no-undo.
def var PIRbosU5FIO as char no-undo.
def var PIRbosdps as char no-undo.
def var PIRbosdpsFIO as char no-undo.
def var PIRbosD6 as char no-undo.
def var PIRbosD6FIO as char no-undo.

PIRbosD6 = ENTRY(1,FGetSetting("PIRboss","PIRbosD6","")).
PIRbosD6FIO = ENTRY(2,FGetSetting("PIRboss","PIRbosD6","")).
PIRbosU5 = ENTRY(1,FGetSetting("PIRboss","PIRbosU5","")).
PIRbosU5FIO = ENTRY(2,FGetSetting("PIRboss","PIRbosU5","")).
PIRbosdps = ENTRY(1,FGetSetting("PIRboss","PIRbosdps","")).
PIRbosdpsFIO = ENTRY(2,FGetSetting("PIRboss","PIRbosdps","")).

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
	/* �஢���� ������ ���� �ਢ易�� �� �����⨪� */
	if op-entry.kau-cr begins "dps," then
		do:
		if NUM-ENTRIES(op-entry.kau-cr) = 3 then
			do:
			if ENTRY(3,op-entry.kau-cr) begins "����" or ENTRY(3,op-entry.kau-cr) begins "��₪�" then
				do:
					

/* �।���⥫쭮 ���᫨� ���� ��ਮ�� */
beg_date = DATE(
		MONTH(DATE(MONTH(op-entry.op-date),1,YEAR(op-entry.op-date)) - 1),
		1,
		YEAR(DATE(MONTH(op-entry.op-date),1,YEAR(op-entry.op-date)) - 1)
).
end_date = DATE(MONTH(op-entry.op-date),1,YEAR(op-entry.op-date)) - 1.

pause 0.

DISPLAY 
	"C  :" beg_date SKIP
	"�� :" end_date SKIP(1)
	isCloseLoan VIEW-AS TOGGLE-BOX LABEL "������ ������" SKIP
WITH FRAME frmGetDates OVERLAY CENTERED ROW 8 no-LABELS
TITLE COLOR BRIGTH-WHITE "[ ��ਮ� � ⨯ ����襭�� ]".

SET 
	beg_date
	end_date
	isCloseLoan
WITH FRAME frmGetDates.
HIDE FRAME frmGetDates.

def var cur_year as integer  NO-UNDO.
cur_year = YEAR(end_date).
if TRUNCATE(cur_year / 4,0) = cur_year / 4 then
	PeriodBase = 366.
else
	PeriodBase = 365.
	
	
	/* �㬬� ����樨
		 ��� ���� �����쪠� ������ઠ: �᫨ �� �����⨪� �� ������ ��₪�*, � ������ �஢���� ���� ⮫쪮 
		 �믫�⮩ ࠭�� ���᫥���� ��業⮢, ᫥����⥫쭮 �㦭� ���� �஢���� �� �믫�� �����᫥���� ��業⮢ */
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
	
	for each bfr-op WHERE
						bfr-op.op-transaction = op.op-transaction 
						and
						bfr-op.op <> op.op 
						no-lock,
					first bfr-op-entry of bfr-op no-lock
				:
					if bfr-op-entry.acct-db begins "7" and bfr-op-entry.acct-cr begins "42" 
					  and ENTRY(2,bfr-op-entry.kau-cr) = ENTRY(2,op-entry.kau-cr)
					then
						if bfr-op-entry.currency = "" then
							Amount = Amount + bfr-op-entry.amt-rub.
						else
							Amount = Amount + bfr-op-entry.amt-cur.
	end.
				
	
	
	/* �㬬� �ய���� */
	Run x-amtstr.p(Amount,op-entry.currency,true,true,output amtstr[1], output amtstr[2]).
  AmtStr[1] = AmtStr[1] + ' ' + AmtStr[2].
	Substr(AmtStr[1],1,1) = Caps(Substr(AmtStr[1],1,1)).
 	
	
					/*########################################### 																		������ ������� */
					find first loan where 
							loan.contract = "dps"
							and
							loan.cont-code = ENTRY(2,op-entry.kau-cr)
							no-lock no-error.
					if avail loan then
						do:
							PrintLoan = loan.cont-code.
							Loan = loan.cont-code.
							LoanDate = loan.open-date.
						end.						
					else
						do:
							message "�������, 㪠����� � �㡠����⨪�, �� ������!" view-as alert-box.
							return.
						end.
					
					/* ���४�஢�� ��砫쭮� ���� */
					beg_date = maximum(beg_date, loan.open-date).
					
					/*########################################## 										������ ������ � ��� ��������/��� */
					if loan.cust-cat = "�" then
						do:
							find first cust-corp where cust-corp.cust-id = loan.cust-id no-lock no-error.
							if avail cust-corp then
								do:
									ClientName = cust-corp.name-corp.
								end.
						end.
					if loan.cust-cat = "�" then
						do:
							find first person where person.person-id = loan.cust-id no-lock no-error.
							if avail person then
								do:
									ClientName = person.name-last + " " + person.first-names.
								end.
						end.
					
					/*########################################## 																������ ��� */
					PayAcct = op-entry.acct-db.
					LoanAcct = op-entry.acct-cr.
					/* ����� ������� �� �ய�ᠭ � �.�. �� ��������� ���� */
					find first signs where 
							signs.code = "DogPlast"
							and	
							signs.file-name = "acct"
							and
							signs.surrogate begins LoanAcct
							no-lock no-error.
					if avail signs then
						PrintLoan = signs.xattr-value.
						
					find last loan-acct where 
							loan-acct.contract = "dps"
							and
							loan-acct.cont-code = Loan
							and 
							loan-acct.acct-type = "loan-dps-out"
							no-lock no-error.
					if avail loan-acct then
						PayAcct = loan-acct.acct.
					else	
						do:
							message "� ����⥪� ��⮢ ������ �� ������ ��� ��� ����᫥���!" view-as alert-box.
							return.
						end.


					LoanCur = SUBSTRING(LoanAcct,6,3).
					
						
					/*##########################################					
					��। �믮������� ���쭥��� ����⢨�, �㦭� ������ ⠡���� ��業⮢ �� ��ਮ�, ���� 
					�⮣���� �㬬�, �⮡� ��⥬ �ࠢ���� �� � �㬬�� �� �஢����, ���� ��।�����, ����� �㬬� �㦭� 
					����� � ��� ᫥���饣� ��業⭮�� ��ਮ�� */
					
					/* ��࠭�� ���騩 ��㭮� ⠡���� � ��६����� */
					StrTable = "                 ������  ���������  �  " + STRING(beg_date,"99/99/9999") 
													+ "  ��  " + STRING(end_date, "99/99/9999") + cr
													+ "�����������������������������������������������������������������������������Ŀ" + cr
													+ "� ���⮪          �   ������ ��ਮ�  � ���-�� � �⠢�� � ���᫥��        �" + cr
													+ "� �� ���         ���������������������Ĵ ����   �        � ��業⮢        �" + cr
													+ "�                  �     �    �    ��    �        �        �                  �" + cr
													+ "�����������������������������������������������������������������������������Ĵ" + cr.

	
					/* ������ �室�騩 ���⮪ �� ��� �� ��ਮ� � �����ਮ�� ���᫥��� */
					if LoanCur = "810" then
						do:
									
									find last acct-pos where 
											acct-pos.acct = LoanAcct
											and
											acct-pos.since lt beg_date
											no-lock no-error.
									if avail acct-pos then
										do:
											Balance = acct-pos.balance.
										end.
									else
										do:
											Balance = 0.
										end.
									PeriodBegin = beg_date.
									PeriodEnd = end_date.

					/*##########################################                ��業⭠� �⠢�� �� ��������
					�᫮����� ⠪��, �� ��業⭠� �⠢�� �� �������� �� ���﫠�� � �祭�� ��ਮ��       
					������ �⠢�� ��� �.�. 蠡���� �࠭���樨 ������ ������
																																																	 */
					Rate = GetDpsCommission_ULL(Loan.cont-code, "commission", beg_date, false).
					/*Rate = 0.
					find first signs where
						signs.code = "commission"
						and
						file-name = "op-template"
						and
						surrogate begins Loan.op-kind
						no-lock no-error.
					if avail signs then
						do:
							find last comm-rate where 
								comm-rate.commission = signs.code-value
								and
								comm-rate.currency = op-entry.currency
								and
								comm-rate.since le beg_date
								and
								comm-rate.min-value le ABS(Balance)
								and
								comm-rate.period le (Loan.end-date - Loan.open-date)
								and
								(
									comm-rate.acct = "0"
									or
									comm-rate.acct = LoanAcct
								)
								/*use-index comm-rate*/
								no-lock no-error.
							if avail comm-rate then 
								do:
									Rate = comm-rate.rate-comm / 100.
								end.
						end.*/


									for each acct-pos where 
										acct-pos.acct = LoanAcct
										and
										acct-pos.since ge beg_date
										and
										acct-pos.since lt end_date
										no-lock:

					/*##########################################                ��業⭠� �⠢�� �� ��������
					�᫮����� ⠪��, �� ��業⭠� �⠢�� �� �������� �� ���﫠�� � �祭�� ��ਮ��       
					������ �⠢�� ��� �.�. 蠡���� �࠭���樨 ������ ������*/
					
					Rate = GetDpsCommission_ULL(Loan.cont-code, "commission", beg_date, false).	
					
					/*
					Rate = 0.
					find first signs where
						signs.code = "commission"
						and
						file-name = "op-template"
						and
						surrogate begins Loan.op-kind
						no-lock no-error.
					if avail signs then
						do:
							find last comm-rate where 
								comm-rate.commission = signs.code-value
								and
								comm-rate.currency = op-entry.currency
								and
								comm-rate.since le beg_date
								and
								comm-rate.min-value le ABS(Balance)
								and
								comm-rate.period le (Loan.end-date - Loan.open-date)
								and
								(
									comm-rate.acct = "0"
									or
									comm-rate.acct = LoanAcct
								)
								/*use-index comm-rate*/
								no-lock no-error.
							if avail comm-rate then 
								do:
									Rate = comm-rate.rate-comm / 100.
								end.
						end.*/
												if Balance = acct-pos.balance then next.
												PeriodEnd = acct-pos.since.
												Period = PeriodEnd - PeriodBegin + 1.
												Summa = Balance * Rate / PeriodBase * Period.
												TotalSumma = TotalSumma + round(Summa,2).
												StrTable = StrTable + "�" + STRING(ABS(Balance), ">>>,>>>,>>>,>>9.99")
													+ "�" + STRING(PeriodBegin,"99/99/9999") 
													+ "�" + STRING(PeriodEnd,"99/99/9999") 
													+ "�" + STRING(Period,">>>>>>>>")
													+ "�" + STRING(Rate * 100,">>>9.99%")
													+ "�" + STRING(ABS(Summa), ">>>,>>>,>>>,>>9.99") + "�" + cr.
												PeriodBegin = PeriodEnd + 1.
												PeriodEnd = end_date.
												Balance = acct-pos.balance.
									end. 
									
									
									Period = PeriodEnd - PeriodBegin + 1.
									Summa = Balance * Rate / PeriodBase * Period.
									TotalSumma = TotalSumma + round(Summa,2).
					/* 
						 �ਬ�砭�� 1.
						 
						 ������ �믮��塞 ���४�஢�� ���⠭���� ���祭�� ��業⮢ �� �㬬� �஢���� �� ��業⠬.
					   ���筮 ࠧ��� ��� �㬬 ��⠢��� �� 1 �� 3 ������, � ��������� ��� � १���� ����譮�� 
					   � ��䬥��᪮� ���᫥��� ��業⮢ �� ���� ��ਮ� � �� ����� �����ਮ� ���᫥��� � �⤥�쭮��.
					   ���ਬ��:
					   ����� � �஫���� 91 ����, �।�������, �� �� �६� �ந��諮 2 ���᫥��� ��業⮢ �� �㬬� 200.01 ��.
					   � ��᫥���� ��ਮ� ���᫥�� 100 �㡫��. �������⥫쭮 �� �஢����� �㬬� ��業⮢ ࠢ�� 500.02, � ��楤��
					   ���⠫� �� ����� �ப 500.03, �� �� 0.01 �㡫� �����.
					   
					   ��襭��: �������� ��楤�� ���४�஢��� �㬬� ��業⮢ � ���⭮� ⠡��� �� ��᫥���� ��ਮ� �� ࠧ����
					   ����� �㬬�� �� �஢����� � ��饩 ����⠭�� �㬬��.
					*/
        					
        					Summa = Summa - (IF Amount - ABS(TotalSumma) <= 0.03 THEN Amount - ABS(TotalSumma) ELSE 0).

									StrTable = StrTable + "�" + STRING(ABS(Balance), ">>>,>>>,>>>,>>9.99") 
										+ "�" + STRING(PeriodBegin,"99/99/9999") 
										+ "�" + STRING(PeriodEnd,"99/99/9999") 
										+ "�" + STRING(Period,">>>>>>>>")
										+ "�" + STRING(Rate * 100,">>>9.99%")
										+ "�" + STRING(ABS(Summa), ">>>,>>>,>>>,>>9.99") + "�" + cr.
								end.
					else	
								do:
									
									find last acct-cur where 
											acct-cur.acct = LoanAcct
											and
											acct-cur.since lt beg_date
											no-lock no-error.
									if avail acct-cur then
										do:
											Balance = acct-cur.balance.
										end.
									else
										do:
											Balance = 0.
										end.
									PeriodBegin = beg_date.
									PeriodEnd = end_date.

					/*##########################################                ��業⭠� �⠢�� �� ��������
					�᫮����� ⠪��, �� ��業⭠� �⠢�� �� �������� �� ���﫠�� � �祭�� ��ਮ��       
					������ �⠢�� ��� �.�. 蠡���� �࠭���樨 ������ ������
																																																	 */
					Rate = GetDpsCommission_ULL(Loan.cont-code, "commission", beg_date, false).
					
					/*Rate = 0.
					find first signs where
						signs.code = "commission"
						and
						file-name = "op-template"
						and
						surrogate begins Loan.op-kind
						no-lock no-error.
					if avail signs then
						do:
							find last comm-rate where 
								comm-rate.commission = signs.code-value
								and
								comm-rate.currency = op-entry.currency
								and
								comm-rate.since le beg_date
								and
								comm-rate.min-value le ABS(Balance)
								and
								comm-rate.period le (Loan.end-date - Loan.open-date)
								and
								(
									comm-rate.acct = "0"
									or
									comm-rate.acct = LoanAcct
								)
								/*use-index comm-rate*/
								no-lock no-error.
							if avail comm-rate then 
								do:
									Rate = comm-rate.rate-comm / 100.
								end.
						end.*/

									for each acct-cur where 
										acct-cur.acct = LoanAcct
										and
										acct-cur.since ge beg_date
										and
										acct-cur.since lt end_date
										no-lock:

					/*##########################################                ��業⭠� �⠢�� �� ��������
					�᫮����� ⠪��, �� ��業⭠� �⠢�� �� �������� �� ���﫠�� � �祭�� ��ਮ��       
					������ �⠢�� ��� �.�. 蠡���� �࠭���樨 ������ ������
																																																	 */
					Rate = GetDpsCommission_ULL(Loan.cont-code, "commission", beg_date, false).
					/*																																																	
					Rate = 0.
					find first signs where
						signs.code = "commission"
						and
						file-name = "op-template"
						and
						surrogate begins Loan.op-kind
						no-lock no-error.
					if avail signs then
						do:
							find last comm-rate where 
								comm-rate.commission = signs.code-value
								and
								comm-rate.currency = op-entry.currency
								and
								comm-rate.since le beg_date
								and
								comm-rate.min-value le ABS(Balance)
								and
								comm-rate.period le (Loan.end-date - Loan.open-date)
								and
								(
									comm-rate.acct = "0"
									or 
									comm-rate.acct = LoanAcct
								)					
								/*use-index comm-rate*/
								no-lock no-error.
							if avail comm-rate then 
								do:
									Rate = comm-rate.rate-comm / 100.
								end.
						end.*/
												if Balance = acct-cur.balance then next.
												PeriodEnd = acct-cur.since.
												Period = PeriodEnd - PeriodBegin + 1.
												Summa = Balance * Rate / PeriodBase * Period.
												TotalSumma = TotalSumma + round(Summa,2).
												StrTable = StrTable + "�" + STRING(ABS(Balance), ">>>,>>>,>>>,>>9.99")
													+ "�" + STRING(PeriodBegin,"99/99/9999") 
													+ "�" + STRING(PeriodEnd,"99/99/9999") 
													+ "�" + STRING(Period,">>>>>>>>")
													+ "�" + STRING(Rate * 100,">>>9.99%")
													+ "�" + STRING(ABS(Summa), ">>>,>>>,>>>,>>9.99") + "�" + cr.
												PeriodBegin = PeriodEnd + 1.
												PeriodEnd = end_date.
												Balance = acct-cur.balance.
									end. 
									Period = PeriodEnd - PeriodBegin + 1.
									Summa = Balance * Rate / PeriodBase * Period.
									TotalSumma = TotalSumma + round(Summa,2).
					/* 
						 �ਬ�砭�� 1.
						 
						 ������ �믮��塞 ���४�஢�� ���⠭���� ���祭�� ��業⮢ �� �㬬� �஢���� �� ��業⠬.
					   ���筮 ࠧ��� ��� �㬬 ��⠢��� �� 1 �� 3 ������, � ��������� ��� � १���� ����譮�� 
					   � ��䬥��᪮� ���᫥��� ��業⮢ �� ���� ��ਮ� � �� ����� �����ਮ� ���᫥��� � �⤥�쭮��.
					   ���ਬ��:
					   ����� � �஫���� 91 ����, �।�������, �� �� �६� �ந��諮 2 ���᫥��� ��業⮢ �� �㬬� 200.01 ��.
					   � ��᫥���� ��ਮ� ���᫥�� 100 �㡫��. �������⥫쭮 �� �஢����� �㬬� ��業⮢ ࠢ�� 500.02, � ��楤��
					   ���⠫� �� ����� �ப 500.03, �� �� 0.01 �㡫� �����.
					   
					   ��襭��: �������� ��楤�� ���४�஢��� �㬬� ��業⮢ � ���⭮� ⠡��� �� ��᫥���� ��ਮ� �� ࠧ����
					   ����� �㬬�� �� �஢����� � ��饩 ����⠭�� �㬬��.
					*/
        					Summa = Summa - (IF Amount - ABS(TotalSumma) <= 0.03 THEN Amount - ABS(TotalSumma) ELSE 0).
									
									StrTable = StrTable + "�" + STRING(ABS(Balance), ">>>,>>>,>>>,>>9.99")
										+ "�" + STRING(PeriodBegin,"99/99/9999") 
										+ "�" + STRING(PeriodEnd,"99/99/9999") 
										+ "�" + STRING(Period,">>>>>>>>")
										+ "�" + STRING(Rate * 100,">>>9.99%")
										+ "�" + STRING(ABS(Summa), ">>>,>>>,>>>,>>9.99") + "�" + cr.
								end.
					TotalSumma = TotalSumma - (IF Amount - ABS(TotalSumma) <= 0.03 THEN Amount - ABS(TotalSumma) ELSE 0).
					
					StrTable = StrTable + "�������������������������������������������������������������������������������" + cr
					 	                  + "                                        ���᫥�� ��業⮢:" + STRING(ABS(TotalSumma),">>>,>>>,>>>,>>9.99") + cr.
					if isCloseLoan then
						do:
							Appendix1 = "     � �裡  �   ����砭���  �ப�  ����⢨�  ������� ������᪮�� ������" + cr
												+ "N " + PrintLoan + "  ��  " + STRING(LoanDate,"99/99/9999") + "�.  �����⢨��   ������  ������ �" + cr
												+	"���᫥���� ��業⮢ �� ��� N " + PayAcct + " (" + ClientName + ")." + cr.
						end.
					else
						do:
							Appendix0 = " �" + cr + "��ॢ���    ���᫥���   ��業��     ��    ���    N " + PayAcct + cr + "(" + ClientName + ")".
						end.
					
				end.
			else
				do:
				message "��� �� �㡠����⨪� - �� �� ������ �� 㯫�� ���᫥���� ��業⮢!" view-as alert-box.
				return.
				end.
			end.
		else
			do:
			message "�������� �㡠������᪠� ���ଠ�� �� ����樨!" view-as alert-box.
			return.
			end.
		end.
	else
		do:
		message "�஢���� �� �ਢ易�� � ������⭮�� ��������!" view-as alert-box.
		return.
		end.
	
/* ======================================================================================================= */


{setdest.i}

put unformatted SPACE(50) "� �����⠬��� 3" SKIP(1)
								SPACE(50) cBankName SKIP(3)
								SPACE(50) "���: " op.op-date FORMAT "99/99/9999" SKIP(5)
			SPACE(25) "� � � � � � � � � � � �" SKIP(3)
			"     �   ᮮ⢥��⢨�   �   ����������  ����� ���ᨨ   N39-�   ��   26.06.98�." SKIP
			"���᫨��  ��業��  ��  ��ਮ�  �  " beg_date format "99/99/9999" "  �� " end_date format "99/99/9999" " ���. �� ��������" SKIP
			"������᪮��   ������   N " PrintLoan "  ��  " LoanDate "�.   (�����稪   - " SKIP
			ClientName ")   ��   ���    N " LoanAcct " � ࠧ��� " SKIP
			Amount format ">>>,>>>,>>9.99" "/" LoanCur " (" AmtStr[1] ") " Appendix0 "." SKIP(1)
			Appendix1 SKIP(3)
		  StrTable SKIP(7)
			PIRbosdps SPACE(70 - LENGTH(PIRbosdps)) PIRbosdpsFIO SKIP.
			/*
			�� ���졥 ���襢��: 26.12.2005 17:28 ��������஢�� ���� ��
			
			"�ᯮ���⥫�: " ExecFIO SKIP. */


{preview.i}
/* ======================================================================================================= */
END.

