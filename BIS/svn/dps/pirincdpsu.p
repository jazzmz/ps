/*������� �.�. 1.12.11:  ��������� �� ������ �� ��������.*/
{pirsavelog.p}

/**
 * ���饭�� ��業�� �� �������� ������ࠬ.
 * ���ଠ�� � ���饭��� ��業�� ������ �� ��ࠬ��஢. �������
 * ������ ���� �����⠭ �� ���� ����.
 * ���� �.�., 16.02.2006 11:37
 */
 
 /** �������� ��।������ */
{globals.i}
/** ������⥪� �㭪権 */
{ulib.i}
/** ��७�� ��ப �� ᫮��� */
{wordwrap.def}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

/** ������ ��६����� */
DEF VAR tmpStr AS CHAR NO-UNDO.
/** ���� ����஢�� �㭪権 �� ���㫥� u*lib.i */
DEF VAR traceOnOff AS LOGICAL INITIAL false NO-UNDO.
/** ��� ���� */
DEF VAR repDate AS DATE FORMAT "99/99/9999" LABEL "��� ����" NO-UNDO.
/** ����� */
DEF VAR i AS INTEGER NO-UNDO.
DEF VAR j AS INTEGER NO-UNDO.
/** �⮣���� �㬬� %% */
DEF VAR totalSumma%% AS DECIMAL NO-UNDO.
DEF VAR totalSumma%%1 AS DECIMAL NO-UNDO.
DEF VAR totalSumma%%d AS DECIMAL NO-UNDO.

PAUSE 0.
/** ������ ���� � ������� �� ���짮��⥫� ;) */
repDate = TODAY.
DISPLAY repDate WITH FRAME fSetDate OVERLAY CENTERED SIDE-LABELS.
SET repDate WITH FRAME fSetDate.
HIDE FRAME fSetDate.	

DEFINE TEMP-TABLE tt-report  NO-UNDO
	FIELD balAcct%% AS CHAR
	FIELD clientName AS CHAR EXTENT 3
	FIELD currency AS CHAR
	FIELD loanInfo AS CHAR EXTENT 3
	FIELD account AS CHAR
	FIELD summa%%1 AS DECIMAL
	FIELD rate AS DECIMAL
	FIELD summaDeposit AS DECIMAL
	FIELD summa%%d AS DECIMAL
	FIELD summa%% AS DECIMAL
	FIELD datePayOut AS DATE
	INDEX main balAcct%% ASCENDING currency ASCENDING.
	
FOR EACH tmprecid 
			NO-LOCK,
    FIRST loan WHERE 
    	RECID(loan) = tmprecid.id 
    	NO-LOCK,
    LAST loan-acct WHERE 
    	loan-acct.contract = loan.contract
    	AND
    	loan-acct.cont-code = loan.cont-code
    	AND
   		loan-acct.acct-type = "����"
    	AND
    	loan-acct.since LE repDate
    	NO-LOCK
  :
  	CREATE tt-report.
  	tt-report.balAcct%% = SUBSTRING(loan-acct.acct,1,5).
  	tt-report.clientName[1] = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", traceOnOff).
  	{wordwrap.i &s=tt-report.clientName &l=30 &n=3}
  	tt-report.loanInfo[1] = loan.cont-code + " �� "
  		+ GetLoanInfo_ULL(loan.contract, loan.cont-code, "open_date", traceOnOff).
  	{wordwrap.i &s=tt-report.loanInfo &l=25 &n=3}
		tt-report.account = GetLoanAcct_ULL(loan.contract, loan.cont-code, "�����", repDate, traceOnOff).
		tt-report.summa%%1 = ABS(
  		GetAcctPosValue_UAL(
  			loan-acct.acct, 
  			loan.currency, repDate, traceOnOff
  		)
  	).
		tt-report.rate = GetLoanCommission_ULL(loan.contract, loan.cont-code, "%���", repDate, traceOnOff).
		tt-report.summaDeposit = ABS(GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, repDate, traceOnOff)) 
					+ GetLoanParamValue_ULL(loan.contract, loan.cont-code, 2, repDate, traceOnOff).
  	tt-report.summa%%d = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 4, repDate, traceOnOff) 
  		+	GetLoanParamValue_ULL(loan.contract, loan.cont-code, 6, repDate, traceOnOff)
  		+ GetLoanParamValue_ULL(loan.contract, loan.cont-code, 32, repDate, traceOnOff)
  		.
  	tt-report.summa%% = tt-report.summa%%1 + tt-report.summa%%d.
  	tt-report.currency = (IF loan.currency = "" THEN "810" ELSE loan.currency).
  	tt-report.datePayOut = GetLoanNextDatePercentPayOut_ULL(loan.contract, loan.cont-code, repDate, traceOnOff).
END.

{setdest.i}

PUT UNFORMATTED "������ ��������� �� ���������" AT 35 SKIP
                "�� ���ﭨ� �� " AT 36 repDate FORMAT "99/99/9999" SKIP(1).

FOR EACH tt-report BREAK BY balAcct%% BY tt-report.currency :
	IF FIRST-OF(balAcct%%) THEN 
		DO:
			PUT UNFORMATTED "��業�� �� �����ᮢ��� ���� " tt-report.balAcct%% SKIP(1).
		END.
	IF FIRST-OF(tt-report.currency) THEN
		DO:
			PUT UNFORMATTED "�� ������⠬ � ����� " tt-report.currency ":" SKIP(1).
			i = 0.
			totalSumma%% = 0.
			PUT UNFORMATTED 
				"� �/� "
				"|�����稪                      "
				"|���" 
				"|������� � ��             "
				"|����� ���         "
				"|�㬬� %% �� 474"
				"|�⠢��"
				"|�㬬� ������   "
				"|�㬬� ���. %% "
				"|C㬬� ��� %%  "
				"|��� �믫���"
				SKIP
				FILL("-",171) SKIP.
		END.
	i = i + 1.
	totalSumma%% = totalSumma%% + tt-report.summa%%.
	totalSumma%%1 = totalSumma%%1 + tt-report.summa%%1.
	totalSumma%%d = totalSumma%%d + tt-report.summa%%d.
	PUT UNFORMATTED
		i FORMAT ">>>>>>"
		"|" tt-report.clientName[1] FORMAT "x(30)"
		"|" tt-report.currency FORMAT "XXX" 
		"|" tt-report.loanInfo[1] FORMAT "x(25)"
		"|" tt-report.account FORMAT "X(20)"
		"|" tt-report.summa%%1 FORMAT "->>>,>>>,>>9.99"
		"|" (tt-report.rate * 100) FORMAT ">>9.99"
		"|" tt-report.summaDeposit FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.summa%%d FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.summa%% FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.datePayOut FORMAT "99/99/9999"
		SKIP.
	DO j = 2 TO 3 :
		IF tt-report.clientName[j] <> "" OR tt-report.loanInfo[j] <> "" THEN
			PUT UNFORMATTED
				"      "
				"|" tt-report.clientName[j] FORMAT "x(30)"
				"|   "  
				"|" tt-report.loanInfo[j] FORMAT "x(25)"
				"|" SPACE(20)
				"|" SPACE(15)
				"|" SPACE(6)
				"|" SPACE(15)
				"|" SPACE(15)
				"|" SPACE(15)
				"|" SPACE(10)
				SKIP.
	END.
	IF LAST-OF(tt-report.currency) THEN
		DO:
			PUT UNFORMATTED 
			  FILL("-",171) SKIP
			  totalSumma%%1 FORMAT "->>>,>>>,>>9.99" AT 90
			  totalSumma%%d FORMAT "->>>,>>>,>>9.99" AT 129
			  totalSumma%% FORMAT "->>>,>>>,>>9.99" AT 145
			  SKIP(1).
			totalSumma%%1 = 0.
			totalSumma%%d = 0.
			totalSumma%% = 0.
		END.
END.

{preview.i}