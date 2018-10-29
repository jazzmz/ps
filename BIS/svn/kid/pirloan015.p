{pirsavelog.p}

/**
 * ����� �ᯮ�殮��� �� ��業⠬ �� �।��� ������ࠬ.
 * ���ଠ�� � ��業�� ������ �� ��ࠬ��஢. �������
 * ������ ���� �����⠭ �� ���� ����.
 * ���� �.�., 16.02.2006 8:55
 */
 
 /** �������� ��।������ */
{globals.i}
/** ������⥪� �㭪権 */
{ulib.i}
/** ��७�� ��ப �� ᫮��� */
{wordwrap.def}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{get-bankname.i}

/** ������ ��६����� */
DEF VAR tmpStr AS CHAR NO-UNDO.
/** ���� ����஢�� �㭪権 �� ���㫥� u*lib.i */
DEF VAR traceOnOff AS LOGICAL INITIAL false NO-UNDO.
/** ��� ���� */
DEF VAR repDate AS DATE FORMAT "99/99/9999" LABEL "��� ����" NO-UNDO.
/** ����� */
DEF VAR i AS INTEGER.
DEF VAR j AS INTEGER.
/** �⮣���� �㬬� %% */
DEF VAR totalSumma%% AS DECIMAL NO-UNDO.

DEF VAR bosLoan AS CHAR.
DEF VAR execUser AS CHAR.

PAUSE 0.
/** ������ ���� � ������� �� ���짮��⥫� ;) */
repDate = TODAY.
DISPLAY repDate WITH FRAME fSetDate OVERLAY CENTERED SIDE-LABELS.
SET repDate WITH FRAME fSetDate.
HIDE FRAME fSetDate.	

DEFINE TEMP-TABLE tt-report
	FIELD balAcct%% AS CHAR
	FIELD clientName AS CHAR EXTENT 3
	FIELD loanInfo AS CHAR
	FIELD grRisk AS CHAR
	FIELD summa%% AS DECIMAL
	FIELD currency AS CHAR
	INDEX main balAcct%% ASCENDING currency ASCENDING.
	
/** ���⠥� ��砫쭨��� */
bosLoan = FGetSetting("PIRboss","PIRbosloan","").
/** ���⠥� �ᯮ���⥫� */
FIND FIRST _user WHERE _user._userid = userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN
	execUser = _user._user-name.
ELSE
	execUser = "-".

FOR EACH tmprecid 
			NO-LOCK,
    FIRST loan WHERE 
    	RECID(loan) = tmprecid.id 
    	NO-LOCK
  :
  	CREATE tt-report.
  	tt-report.balAcct%% = (IF loan.gr-riska = 1 THEN "47427" ELSE "91604") /*SUBSTRING(loan-acct.acct,1,5)*/.
  	tt-report.clientName[1] = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", traceOnOff).
  	{wordwrap.i &s=tt-report.clientName &l=30 &n=3}
  	tt-report.loanInfo = loan.cont-code + " �� "
  		+ GetLoanInfo_ULL(loan.contract, loan.cont-code, "open_date", traceOnOff).
  	tt-report.grRisk = STRING(loan.gr-riska).
  	tt-report.summa%% = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 4, repDate, traceOnOff).
  	tt-report.currency = (IF loan.currency = "" THEN "810" ELSE loan.currency).
END.

{setdest.i}

PUT UNFORMATTED 
		SPACE(70) "� �����⠬��� 3" SKIP
		SPACE(70) cBankName SKIP(2)
		SPACE(70) '���: ' repDate FORMAT "99/99/9999" SKIP(1)
		SPACE(35) '� � � � � � � � � � � �' SKIP(1)
		SPACE(4) '� ᮮ⢥��⢨� � ���������� ����� ���ᨨ �39-� �� 26.06.98�. "� ���浪� ���᫥���' SKIP
		      '��業⮢ �� ������, �易��� � �ਢ��祭��� � ࠧ��饭��� �������� �।��' SKIP
		      '�������, � ��ࠦ���� 㪠������ ����権 �� ��⠬ ��壠���᪮�� ���" ���� ���' SKIP
		      '���᫨�� ��業�� �� ������������� �� ᫥���騬 �।�⠬:' SKIP(2).

FOR EACH tt-report BREAK BY balAcct%% BY tt-report.currency :
	IF FIRST-OF(balAcct%%) THEN 
		DO:
			PUT UNFORMATTED "��業�� �� �����ᮢ��� ���� " tt-report.balAcct%% SKIP(1).
		END.
	IF FIRST-OF(tt-report.currency) THEN
		DO:
			PUT UNFORMATTED "�� �।�⠬ � ����� " tt-report.currency ":" SKIP(1).
			i = 0.
			totalSumma%% = 0.
			PUT UNFORMATTED 
				'������������������������������������������������������������������������������������Ŀ' SKIP
				"�� �/� �����騪                        �������� � ��             ��㬬� %%       �����" SKIP
				'������������������������������������������������������������������������������������Ĵ' SKIP.
		END.
	i = i + 1.
	totalSumma%% = totalSumma%% + tt-report.summa%%.
	PUT UNFORMATTED
		"�" i FORMAT ">>>>>>"
		"�" tt-report.clientName[1] FORMAT "x(31)"
		"�" tt-report.loanInfo FORMAT "x(25)"
		"�" tt-report.summa%% FORMAT "->>>,>>>,>>9.99"
		"�" tt-report.currency FORMAT "XXX" 
		"�"	SKIP.
	DO j = 2 TO 3 :
		IF tt-report.clientName[j] <> "" THEN
			PUT UNFORMATTED
				"�" SPACE(6)
				"�" tt-report.clientName[j] FORMAT "x(31)"
				"�" SPACE(25)
				"�" SPACE(15)
				"�" SPACE(3)
				"�"	SKIP.
	END.
	IF LAST-OF(tt-report.currency) THEN
		DO:
			PUT UNFORMATTED 
				'������������������������������������������������������������������������������������Ĵ' SKIP
				"�" SPACE(6)
				"�" SPACE(31)
				"�" SPACE(25)
				"�" totalSumma%% FORMAT "->>>,>>>,>>9.99"
				"�" SPACE(3)
				"�"	SKIP
				"��������������������������������������������������������������������������������������"
			  SKIP(1).
			totalSumma%% = 0.
		END.
END.

PUT UNFORMATTED
	SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(3)
	SPACE(4) '�ᯮ���⥫�: ' execUser SKIP(3)
	SPACE(4) '�⬥⪠ �����⠬��� 3:' SKIP.

{preview.i}