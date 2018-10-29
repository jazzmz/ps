/* 
		�㭪樨 ��� ࠡ��� � ����� ������ �������.
		�����ন������ ����� �������: 41d.
		����: ���� �.�.
		
		�������ਨ:
			1) �� ���ᠭ�� �㭪権 ���� � ���樨 �몠 PASCAL (�� �� ��� �� ����� ;)
			2) ��, �� ����祭� ᨬ����� "*" (������) ���� �� ॠ��������.
		
		�����:
		
		���᮪:
			
			GetParamByName_ULL(aParam:CHAR, aName:CHAR, aDef:CHAR, aDelim:CHAR): CHAR
			========================================================================
			| �����頥� ���祭�� ��ࠬ��� �� ��ப� ��।�������� �ଠ�
			
			LoopReplace_ULL(source-string:CHAR, from-string:CHAR, to-string:CHAR): CHAR
			===========================================================================
			| ������ ��� ������ � ��ப�

			StrToWin_ULL(Str:CHAR): CHAR
			============================
			| �����頥� ��ப� � ����஢�� WIN1251	
			
			FirstIndicateCandoIn_ULL(code:CHAR, list:CHAR, since:DATE, start:CHAR, wait:CHAR): CHAR
			==============================================================================
			| Find First Indicate with Internal Can-do search
			| �����頥� ��ࢮ� �����襥�� ���祭��, ᮮ⢥����饥 ��᪥ wait �� indicate 
			| �ᯮ������ ����७�� can-do - �� �����, �� ���਩ � indicate ����� 
			| ���� ��᪮� 
			| list - ᯨ᮪ ���ਥ� indicate �१ �������
			|        ����� ������� ᯨ᪠ �஢������ �� ����७���� can-do
			| wait - ��������� ���祭��     
			| �᫨ �� �������, � �㭪�� ��୥� "?"
			
			GetUserInfo_ULL(code:CHAR, param:CHAR, showErrorMsg:LOGICAL): CHAR
			==================================================================
			| �����頥� ��ப� �ଠ� <val1>,<val2>,...,<valN>
			| ��� ४����⮢ param �ଠ� <par1>,<par2>,...,<parN>
			| 
			| 
		
			FIOShort_ULL(fio:CHAR, showErrorMsg:LOGICAL): CHAR
			==================================================
			| �८�ࠧ�� ������ ���� �������� � ������ �.�.
			
		1 ����� �㭪権. 
		�।�����祭� ��� ����祭�� ���ଠ樨 � ���
		
		���᮪:
			
			GetAcctPosValue_UAL(Acct_Number:CHAR, Currency_OUT:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			===================================================================================
			|	�����頥� ���祭�� ���⪠ �� ���� �� ���� �� ��楯�஢���� ���㬥�⠬.
			
			GetAcctClientName_UAL(Acct_Number:CHAR, ShowErrorMsg:LOGICAL): CHAR
			====================================================================
			| �����頥� �������� ������, �᫨ ��� ������᪨�.
			
			GetAcctClientID_ULL(Acct_Number:CHAR, ShowErrorMsg:LOGICAL): CHAR
			=================================================================
			| �����頥� �����䨪��� ������ � �ଠ� <���>,<ID>
			| ��� ��� - {�,�,�,�}
			
			GetClientInfo_ULL(Client_ID:CHAR, Info:CHAR, ShowErrorMsg:LOGICAL): CHAR
			========================================================================
			| �����頥� ����� �� �������
			| Client_ID - ��ப� �ଠ� <���>,<ID>
			| Info - ��ப� �ଠ� <param,param,param,...>
			|        ��� param - ���� �� ���祭��
			|            {name,inn,bank-code:{bic;���-9;...},ident:{��ᯮ��,...},addr:{�������,...},country}
*/

/*
		2 ����� �㭪権 (����������). 
	 	�।�����祭� ��� ����祭�� ���ଠ樨 � �।�⭮� �������
		
		���᮪:
			
			GetCredLoanParamValue_ULL(Loan_Number:CHAR, Param_Code:INTEGER, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			===================================================================================
			|	�����頥� ���祭�� �㡠������᪮�� ��ࠬ��� ������� �� ����. 
			|	�᫨ ������� ����� �祭��/�����, � ��楤�� ��ᬠ�ਢ��� ������, � ���祭�� ����訢������ ��ࠬ���
			|	�㬬�������.
			
			GetCredLoanCommission_ULL(Loan_Number:CHAR, Commission_Code:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			=====================================================================================
			| �����頥� ���祭�� �������� ��業⭮� �⠢�� �� �������� �� ���� ⮫쪮 � %.
			| ���祭�� ��業⭮� ����稭� 㦥 �������� �� 100.
			
			GetCredLoanAcct_ULL(Loan_Number:CHAR, Account_Role:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): CHAR
			=========================================================================
			| �����頥� ����� �������饣� �� ���� ��� � �������� ஫�� �� ����⥪� ��⮢ �।�⭮�� ������� 

			GetCredLoanInfo_ULL(Loan_Number:CHAR, Info_Name:CHAR, ShowErrorMsg:LOGICAL): CHAR
			=========================================================================
			| �����頥� ���ଠ�� �� �।�⭮�� ��������:
			|
			| ���祭�� 							�����頥�� 
			| Info_Name							१����
			| -------------					----------------
			|	client_name						������������ ������
			|	open_date							��� ������(ॣ����樨) �������

			
		3 ����� �㭪権	� 16.02.2006 11:43
*/

/*		
LOAN �।�����祭� ��� ����祭�� ���ଠ樨 �� �।��� � �������� ������ࠬ. 
		���᮪:
			
			GetLoanParamValue_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Param_Code:INTEGER, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			===================================================================================
			|	�����頥� ���祭�� �㡠������᪮�� ��ࠬ��� ������� �� ����.
			|	�᫨ ������� ����� �祭��/�����, � ��楤�� ��ᬠ�ਢ��� ������, � ���祭�� ����訢������ ��ࠬ���
			|	�㬬�������.
			
			GetLoanCommissionEx_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Commission_Code:CHAR, Date:DATE, ShowErrorMsg:LOGICAL, out Commission_Type:CHAR): DECIMAL
			=====================================================================================
			| �����頥� ���祭�� �������� ��業⭮� �⠢�� �� �������� �� ���� � ⮬ ����, � ����� �� �࠭���� � ���� ������.
			| Commission_Type �����頥� ⨯ ���祭�� - {%|=}

			GetLoanCommission_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Commission_Code:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			=====================================================================================
			| �����頥� ���祭�� �������� ��業⭮� �⠢�� �� �������� �� ����.
			| ������ GetLoanCommissionEx_ULL - ��࠭�� ��� �����প� "�����" ��楤��.
			| ���祭�� ��業⭮� ����稭� 㦥 �������� �� 100.
			
			GetLoanAcct_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Account_Role:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): CHAR
			=========================================================================
			| �����頥� ����� �������饣� �� ���� ��� � �������� ஫�� �� ����⥪� ��⮢ �।�⭮�� ������� 

			GetLoanInfo_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Info_Name:CHAR, ShowErrorMsg:LOGICAL): CHAR
			=========================================================================
			| �����頥� ���ଠ�� �� �।�⭮�� ��������:
			| ��ଠ� Info_Name <���祭��>[,<���祭��>[,<���祭��>[,...]]]
			| ���祭�� 							�����頥�� 
			| Info_Name							१����
			| -------------					----------------
			|	client_name						������������ ������
			| client_short_name					��⪮� ������������ ������
			| client_country				�������� ��� ��࠭� ������
			| client_address				���� ������
			|	open_date							��� ������(ॣ����樨) �������
			| end_date							��� ����砭�� ������� (�����頥� ? - �᫨ ���)
			| risk									��業� �᪠
			| gr_riska							��㯯� �᪠
			| guarantor_name(RECID)	������������ �����⥫� �� n-��� ������� ���ᯥ祭��, n - RECID ����� term-obl
			
			GetMainLoan_ULL(Loan_Type:CHAR, Loan_Number:CHAR, ShowErrorMsg:LOGICAL):CHAR
			=========================================================================
			| �����頥� ����� �墠�뢠�饣� �������, �᫨ ��।���� � �㭪�� ������� ����
			| �祭��� ��� �।�⭮� ������, ���� �����頥� ᠬ ᥡ�. 
			| ��ଠ� �����頥���� ���祭��: <���_�������>,<�����_�������>,��� ���_������� - "�।��","�����" � �.�.
			
			GetLoanLimit_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Date:DATE, ShowErrorMsg:LOGICAL):DECIMAL
			=================================================================================
			| �����頥� �㬬� ����� �뤠�/������������ �� ��������.
			
			GetLoanNextDatePercentPayOut_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Date:DATE, ShowErrorMsg:LOGICAL):DATE
			=================================================================================
			| �����頥� ���� �믫��� ��業⮢, ᫥������ �� ��⮩ ��ࠬ��� Date.
*/

/*

DPS	�।�����祭� ��� ����祭�� ���ଠ樨 � ������� ��⭮�� ������ 
		
		���᮪:
		
			GetDpsCurrentPercent_ULL(Loan_Number:CHAR, Date:CHAR, ShowErrorMsg:LOGICAL): DECIMAL
			=======================================================================
			| �����頥� �㬬� ⥪��� ��業⮢ �� ���� � ������ �� ��᫥����� ���᫥���

			GetDpsCommission_ULL(Loan_Number:CHAR, Commission_Type:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			=====================================================================================
			| �����頥� ���祭�� �������� ��業⭮� �⠢�� �� �������� �� ����
			| 
			| Commission_Type
			|	�������� ���祭��									���ᠭ��
			| -------------------									---------------------
			| "commission"												���祭�� �᭮���� �⠢��
			| "pen-commi"													���祭�� ���䭮� �⠢��
			
			GetDpsNextDatePercentPayOut_ULL(Loan_Number:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): DATE
			===============================================================================
			| �����頥� ���� �믫��� ��業⮢, ᫥������ �� ��⮩ ��ࠬ��� Date.
			
COMM �।�����祭� ��� ࠡ��� � ������ﬨ, �� ����騬� �⭮襭�� � ������ࠬ 

		���᮪:
			
			GetCommRateEx_ULL(CommissionName: CHAR, Currency: CHAR, MinSumma: DECIMAL, Acct: CHAR, 
											Period: INTEGER, Date: DATE, ShowErrorMsg: LOGICAL,
											out Commission_Type:CHAR ): DECIMAL
			=================================================================================================
			| �����頥� ���祭�� �������� �����ᨨ �� ����, �.�. 15% �㭪�� ��୥� ��� 15.0
			| Commission_Type �����頥� ⨯ ���祭�� - {%|=}


			GetCommRate_ULL(CommissionName: CHAR, Currency: CHAR, MinSumma: DECIMAL, Acct: CHAR, 
											Period: INTEGER, Date: DATE, ShowErrorMsg: LOGICAL): DECIMAL
			=================================================================================================
			| �����頥� ���祭�� �������� �����ᨨ �� ����, 㦥 ���������� �� 100, �.�. 15% �㭪�� ��୥� ��� 0.15
			
			
			GetSumRate_ULL(CommissionName: CHAR, Currency: CHAR, MinSumma: DECIMAL, Acct: CHAR, 
											Period: INTEGER, Date: DATE, ShowErrorMsg: LOGICAL): DECIMAL
			=================================================================================================
			| ����頥� ���⠭��� ���祭�� �����ᨨ � �㬬� �� ���� � �.�.											


*/


&IF DEFINED(ulib_i)=0
&THEN
  &GLOBAL-DEFINE ulib_i


/** �����㦠�� �㭪樨 ��� ࠡ��� � ��⠬�. */
{intrface.get date}
/** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get xclass}
{intrface.get cust}
{intrface.get dps}
{intrface.get dpspr}


DEF VAR MONTH_NAMES AS CHAR EXTENT 12 INIT ["������","���ࠫ�","����","��५�","���","���","���","������","�������","������","�����","�������"] NO-UNDO.

/** �।��।������, �⮡� � ᠬ�� ������⥪� ����� �뫮 �ᯮ�짮���� �㭪樨 */
FUNCTION GetDpsCommission_ULL RETURN DECIMAL (INPUT inLoan AS CHAR,	INPUT inTypeComm AS CHAR,	INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL) FORWARD.


FUNCTION isTemplate RETURNS LOGICAL(INPUT checkSTR AS CHAR) FORWARD.     /* ������� ��������� ������ checkSTR ���� �� 蠡����� */




/** ��������� */



FUNCTION GetParamByName_ULL RETURNS CHAR (INPUT aParam AS CHAR, INPUT aName AS CHAR, INPUT aDef AS CHAR, INPUT aDelim AS CHAR).
/** �室: aParam - ��ப� � ���ன ������ ��ࠬ����
 **       aName - �᪮�� ��ࠬ���
 **       aDef - ���祭�� �� 㬮�砭��
 **       aDelim - ࠧ����⥫� ��ࠬ��஢
 ** ��室: ���祭�� ��ࠬ��� ⨯� CHAR, ���� ���祭�� �� 㬮�砭��, 
 **        �᫨ ��ࠬ��� ���������
*/

  DEF VAR iii AS INTEGER NO-UNDO.

  DO iii = 1 TO NUM-ENTRIES(aParam, aDelim):
    IF TRIM(ENTRY(1, ENTRY(iii, aParam, aDelim), "=")) = aName THEN RETURN TRIM(ENTRY(2, ENTRY(iii, aParam, aDelim), "=")).
  END.
  RETURN aDef.
END FUNCTION.



FUNCTION LoopReplace_ULL RETURNS CHAR (INPUT source-string AS CHAR, INPUT from-string AS CHAR, INPUT to-string AS CHAR).
/** �室: source-string - ��ப� � ���ன ������ �����ப� from-string
 **       from-string - �᪮��� ��� ������ ��ப�
 **       to-string - ��������� ��ப�
 ** ��室: ��ப�, � ���ன �� �����ப� from-string �������� �� to-string
 **        � �⫨稥 �� REPLACE � ��砥 �᫨ ��।��� ������ ᮧ���� ����� �����ப� from-string,
 **        � ��� ����� ��ࠡ��뢠����.
*/
	
	DEF VAR outValue AS CHAR.
	
	outValue = source-string.
	DO WHILE INDEX(outValue, from-string) > 0:
		outValue = REPLACE(outValue, from-string, to-string).
	END.
	
	RETURN outValue.
	
END FUNCTION.


FUNCTION StrToWin_ULL RETURNS CHARACTER (INPUT arg1 AS CHARACTER).
/* �室: arg1:��ப�
** ��室: ��ப� � ����஢�� windows-1251
*/
	RETURN CODEPAGE-CONVERT(arg1,"1251",SESSION:CHARSET).
END FUNCTION.


FUNCTION FirstIndicateCandoIn_ULL RETURNS char (
        input code as char,
        input val as char,
        input d as date,
        input wait as char,
        input start as char).

   def buffer bfrDatablock for datablock.
   def buffer bfrDataline for dataline.
   def var result as char init "" no-undo.


   
   find first bfrDatablock where bfrDatablock.dataclass-id = code
                                 and
                                 bfrDatablock.beg-date <= d
                                 no-lock no-error.
   if avail bfrDatablock then do:
     for each bfrDataline of bfrDatablock
         where
               bfrDataline.sym1 = start
               and
               can-do(bfrDataline.sym2, entry(INT(bfrDataline.sym4), val))
         :

		 /** ������� - � ��⮬ ���� */
         if bfrDataline.txt = "" then
           result = FirstIndicateCandoIn_ULL(code, val, d, wait, bfrDataline.sym3).
         else
           result = bfrDataline.txt.
           
         /** १���� = �᫨ ���祭�� ᮢ������ � �������� */
         if can-do(wait, result) then return result.
 
     end.
   end.

END FUNCTION.         


FUNCTION GetUserInfo_ULL RETURNS CHAR (INPUT arg1 AS CHAR,
									   INPUT arg2 AS CHAR,
									   INPUT arg3 AS LOGICAL).

	def buffer bfrUser for _user.
	
	def var i as integer no-undo.
	def var result as char no-undo.
	
	find first bfrUser where bfrUser._userid = arg1 no-lock no-error.
	if avail bfrUser then do:
		do i = 1 to num-entries(arg2):
			if result > "" then result = result + ",".
			if entry(i, arg2) = "fio" then do:
				result = result + bfrUser._user-name.
			end.
		end.
	end.
	
	RETURN result.

END FUNCTION.									   

FUNCTION FIOShort_ULL RETURNS CHAR (INPUT arg1 AS CHAR,
                                    INPUT arg2 AS LOGICAL).
    def var result as char no-undo.
	
	result = entry(1, arg1, " ") + " ".
	if num-entries(arg1, " ") = 2 then do:
		result = result + entry(2, arg1, " ").
	end. else do:
		result = result + SUBSTR(ENTRY(2, arg1, " "), 1, 1) + "." +
				SUBSTR(ENTRY(3, arg1, " "), 1, 1) + ".".
	end.
	RETURN result.
				
END FUNCTION.                                    

FUNCTION GetAcctPosValueEx_UAL RETURNS DECIMAL (
		INPUT inAcct AS CHAR,
		INPUT inCur  AS CHAR,
		INPUT inDate AS DATE,
		INPUT inStatus AS CHAR,
		INPUT inShowErrorMsg AS LOGICAL ).
		
		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DECIMAL.
		DEFINE VAR acctCur AS CHAR.
		DEFINE VAR acctPos AS DECIMAL.
		DEFINE VAR lstSince AS DATE.
		
		DEFINE BUFFER bfrAcct FOR acct.
		DEFINE BUFFER bfrAcctPos FOR acct-pos.
		DEFINE BUFFER bfrAcctCur FOR acct-cur.
		DEFINE BUFFER bfrOpEntry FOR op-entry.
		
		/* ��।���� ��� ������ */
		/* acctCur = SUBSTRING(inAcct, 6, 3). */
		IF inCur = "" THEN inCur = "810".
		acctCur = inCur.
		
		/* �஢�ઠ: ������� �� ���? */
		FIND FIRST bfrAcct WHERE
			bfrAcct.acct = inAcct
			NO-LOCK NO-ERROR.
		IF AVAIL bfrAcct THEN
			DO:
				/* ���樠�����㥬 */
				lstSince = bfrAcct.open-DATE.

				/* ������ ���⮪ �� ���� �� ��᫥���� ������� ���� */
				IF acctCur = "810" THEN
					DO:
						FIND LAST bfrAcctPos WHERE
							bfrAcctPos.acct = inAcct
							AND
							bfrAcctPos.since LE inDate
							NO-LOCK NO-ERROR.
						IF AVAIL bfrAcctPos THEN
							ASSIGN 
								acctPos = bfrAcctPos.balance
								lstSince = bfrAcctPos.since + 1.
					END.
				ELSE
					DO:
						FIND LAST bfrAcctCur WHERE
							bfrAcctCur.acct = inAcct
							AND
							bfrAcctCur.since LE inDate
							NO-LOCK NO-ERROR.
						IF AVAIL bfrAcctCur THEN
							ASSIGN 
								acctPos = bfrAcctCur.balance
								lstSince = bfrAcctCur.since + 1.
					END.
				
				outErrorStr = "�������� ���⮪ �� ���� " + inAcct + " � ����� " + acctCur + " �� ���� " 
					+ STRING(inDate,"99/99/9999") + " ࠢ�� " + STRING(acctPos,"->>>,>>>,>>>,>>>,>>9.99") + CHR(10).
				
				FOR EACH bfrOpEntry WHERE
					bfrOpEntry.op-DATE GE lstSince
					AND
					bfrOpEntry.op-DATE LE inDate
					AND
					bfrOpEntry.acct-db = inAcct
					AND 
					bfrOpEntry.op-status GE inStatus
					NO-LOCK
					:
							IF bfrAcct.side = "�" THEN 
								IF acctCur = "810" THEN
									acctPos = acctPos + bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos + bfrOpEntry.amt-cur.
							ELSE
								IF acctCur = "810" THEN
									acctPos = acctPos + bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos + bfrOpEntry.amt-cur.
				END.

				outErrorStr = outErrorStr + "��������� �㬬� �஢���� � ����ᮬ �� ���� '" + inStatus + "' �� ������ �� ���� � ���������� ���� " + inAcct + " � ����� " + acctCur + " �� ���� " 
					+ STRING(inDate,"99/99/9999") + " �������� ���⮪ �� ���祭�� " + STRING(acctPos,"->>>,>>>,>>>,>>>,>>9.99") + CHR(10).

				FOR EACH bfrOpEntry WHERE
					bfrOpEntry.op-DATE GE lstSince
					AND
					bfrOpEntry.op-DATE LE inDate
					AND
				  bfrOpEntry.acct-cr = inAcct
					AND 
					bfrOpEntry.op-status GE inStatus
				  NO-LOCK
					:
							IF bfrAcct.side = "�" THEN 
								IF acctCur = "810" THEN
									acctPos = acctPos - bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos - bfrOpEntry.amt-cur.
							ELSE
								IF acctCur = "810" THEN
									acctPos = acctPos - bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos - bfrOpEntry.amt-cur.
				END.

				outErrorStr = outErrorStr + "��������� �㬬� �஢���� � ����ᮬ �� ���� '" + inStatus + "' �� �।��� �� ���� � ���������� ���� " + inAcct + " � ����� " + acctCur + " �� ���� " 
					+ STRING(inDate,"99/99/9999") + " �������� ���⮪ �� ���祭�� " + STRING(acctPos,"->>>,>>>,>>>,>>>,>>9.99") + CHR(10).

			END.
		ELSE
			outErrorStr = "C�� " + inAcct + " �� ������!" + CHR(10).  
		
		/* �뤠�� �訡�� �� ��࠭ */
		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetAcctPosValueEx_UAL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		outValue = acctPos.
		RETURN outValue.


		/** ����� �㭪樨 GetAcctPosValueEx_UAL */
END FUNCTION.

FUNCTION GetAcctPosValue_UAL RETURNS DECIMAL (
		INPUT inAcct AS CHAR,
		INPUT inCur  AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL ).
		
		RETURN GetAcctPosValueEx_UAL(inAcct, inCur, inDate, CHR(251), inShowErrorMsg).
		
		/* ����� �㭪樨 GetAcctPosValue_UAL */		
END FUNCTION.

FUNCTION GetAcctClientName_UAL RETURNS CHAR (
		INPUT inAcct AS CHAR,
		INPUT inShowErrorMsg AS LOGICAL ).
		
		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS CHAR.

		DEF BUFFER bfrAcct FOR acct.
		DEF BUFFER bfrCustCorp FOR cust-corp.
		DEF BUFFER bfrPerson FOR person.
		DEF BUFFER bfrBanks FOR banks.
		
		/* ������ ��� */
		FIND FIRST bfrAcct WHERE	
			bfrAcct.acct = inAcct
			NO-LOCK NO-ERROR.
		IF AVAIL bfrAcct THEN
			DO:
				IF bfrAcct.cust-cat = "�" THEN
					DO:
						FIND FIRST bfrCustCorp WHERE
							bfrCustCorp.cust-id = bfrAcct.cust-id
							NO-LOCK NO-ERROR.
						IF AVAIL bfrCustCorp THEN
							/** outValue = bfrCustCorp.cust-stat + " " + bfrCustCorp.name-corp. */
							outValue = bfrCustCorp.name-short.
					END.
				IF bfrAcct.cust-cat = "�" THEN
					DO:
						FIND FIRST bfrPerson WHERE
							bfrPerson.person-id = bfrAcct.cust-id
							NO-LOCK NO-ERROR.
						IF AVAIL bfrPerson THEN
							outValue = bfrPerson.name-LAST + " " + bfrPerson.first-names.
					END.
				IF bfrAcct.cust-cat = "�" THEN
					DO:
						FIND FIRST bfrBanks WHERE
							bfrBanks.bank-id = bfrAcct.cust-id
							NO-LOCK NO-ERROR.
						IF AVAIL bfrBanks THEN
							outValue = outValue + bfrBanks.name.
					END.
			END.
		ELSE
			outErrorStr = "C�� " + inAcct + " �� ������!" + CHR(10).  
			
		/* �뤠�� �訡�� �� ��࠭ */
		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetAcctClientName_UAL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.
	  /* ����� �㭪樨 GetAcctClientName_UAL */
END FUNCTION.

FUNCTION GetAcctClientID_ULL RETURNS CHAR (
		INPUT inAcct AS CHAR,
		INPUT inShowErrorMsg AS LOGICAL ).
		
		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS CHAR.

		DEF BUFFER bfrAcct FOR acct.

		/* ������ ��� */
		FIND FIRST bfrAcct WHERE	
			bfrAcct.acct = inAcct
			NO-LOCK NO-ERROR.
		IF AVAIL bfrAcct THEN
			DO:
				outValue = bfrAcct.cust-cat + "," + (IF bfrAcct.cust-id <> ? THEN STRING(bfrAcct.cust-id) ELSE "0").
			END.
		ELSE
			outErrorStr = "C�� " + inAcct + " �� ������!" + CHR(10).  
			
		/* �뤠�� �訡�� �� ��࠭ */
		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetAcctClientID_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.
	  /* ����� �㭪樨 GetAcctClientName_UAL */
END FUNCTION.


FUNCTION GetClientInfo_ULL RETURNS CHAR (
		INPUT inClientId AS CHAR,
		INPUT inInfo AS CHAR,
		INPUT inShowErrorMsg AS LOGICAL ).
		
		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR NO-UNDO.
		DEFINE VAR outValue AS CHAR NO-UNDO.
		DEFINE VAR outValue2 AS CHAR NO-UNDO.
		DEFINE VAR i AS INTEGER NO-UNDO.
		DEFINE VAR j AS INTEGER NO-UNDO.
		DEFINE VAR tmp AS CHAR NO-UNDO.

		DEF BUFFER bfrCustCorp FOR cust-corp.
		DEF BUFFER bfrPerson FOR person.
		DEF BUFFER bfrBanks FOR banks.
		DEF BUFFER bfrBanksCode FOR banks-code.
		DEF BUFFER bfrCustIdent FOR cust-ident.
		
			DO:
				IF ENTRY(1, inClientID) = "�" THEN
					DO:
						FIND FIRST bfrCustCorp WHERE
							bfrCustCorp.cust-id = INT(ENTRY(2, inClientID))
							NO-LOCK NO-ERROR.
						IF AVAIL bfrCustCorp THEN DO:
							DO i = 1 TO NUM-ENTRIES(inInfo):
								IF outValue <> "" THEN outValue = outValue + ",".
								IF ENTRY(i, inInfo) = "name" THEN
									/** outValue = outValue + bfrCustCorp.cust-stat + " " + bfrCustCorp.name-corp. */
									outValue = outValue + bfrCustCorp.name-short.
								IF ENTRY(i, inInfo) = "fullname" THEN
								    outValue = outValue + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "FullName", "").
								IF ENTRY(i, inInfo) = "inn" THEN 
									outValue = outValue + bfrCustCorp.inn.
								IF ENTRY(i, inInfo) = "country" THEN 
									outValue = outValue + bfrCustCorp.country-id.

								IF (ENTRY(i, inInfo) BEGINS "addr") 
								   AND
								   (NUM-ENTRIES(ENTRY(i, inInfo), ":") = 2) 
								THEN DO:
								    outErrorStr = "debug: " + ENTRY(i, inInfo) + " ... num-entries = " + string(NUM-ENTRIES(ENTRY(2, ENTRY(i, inInfo), ":"), ";")) + CHR(10).
									DO j = 1 TO NUM-ENTRIES(ENTRY(2, ENTRY(i, inInfo), ":"), ";") :
										FIND LAST bfrCustIdent WHERE 
												   bfrCustIdent.cust-code-type = ENTRY(j, ENTRY(2, ENTRY(i, inInfo), ":"), ";") AND
												   bfrCustIdent.cust-cat = ENTRY(1, inClientID) AND
												   bfrCustIdent.cust-id = bfrCustCorp.cust-id
												   NO-LOCK NO-ERROR.
									    IF outValue2 <> "" THEN outValue2 = outValue2 + ";". 
										if AVAIL bfrCustIdent then 
											DO:
												outValue2 = outValue2 + bfrCustIdent.issue.
											END.				
										else
										    outErrorStr = outErrorStr + "�����.��筮�� " + ENTRY(j, ENTRY(2, ENTRY(i, inInfo), ":"), ";") + " �� ������!" + CHR(10).  
									END.
									outValue = outValue + outValue2.
								END. ELSE 
									outErrorStr = outErrorStr + "'addr' ����� ���ࠢ���� �ଠ�! ������ ���� 'ident:<code>;<code>;...'" + CHR(10).
									
							END.
						END. ELSE 
							outErrorStr = "������ " + inClientId + " �� ������!" + CHR(10).  
					END.
				IF ENTRY(1, inClientID) = "�" THEN
					DO:
						FIND FIRST bfrPerson WHERE
							bfrPerson.person-id = INT(ENTRY(2, inClientID))
							NO-LOCK NO-ERROR.
						IF AVAIL bfrPerson THEN DO:
							DO i = 1 TO NUM-ENTRIES(inInfo):
								IF outValue <> "" THEN outValue = outValue + ",".
								IF ENTRY(i, inInfo) = "name" THEN
									outValue = bfrPerson.name-last + " " + bfrPerson.first-names.
								IF ENTRY(i, inInfo) = "inn" THEN 
									outValue = outValue + bfrPerson.inn.
								IF ENTRY(i, inInfo) = "country" THEN 
									outValue = outValue + bfrPerson.country-id.
								IF (ENTRY(i, inInfo) BEGINS "ident") 
								   AND
								   (NUM-ENTRIES(ENTRY(i, inInfo), ":") = 2) 
								THEN DO:
								    outErrorStr = "debug: " + ENTRY(i, inInfo) + " ... num-entries = " + string(NUM-ENTRIES(ENTRY(2, ENTRY(i, inInfo), ":"), ";")) + CHR(10).
									DO j = 1 TO NUM-ENTRIES(ENTRY(2, ENTRY(i, inInfo), ":"), ";") :
										FIND LAST bfrCustIdent WHERE 
												   bfrCustIdent.cust-code-type = ENTRY(j, ENTRY(2, ENTRY(i, inInfo), ":"), ";") AND
												   bfrCustIdent.cust-cat = ENTRY(1, inClientID) AND
												   bfrCustIdent.cust-id = bfrPerson.person-id
												   NO-LOCK NO-ERROR.
									    IF outValue2 <> "" THEN outValue2 = outValue2 + ";". 
										if AVAIL bfrCustIdent then 
											DO:
												tmp = GetXAttrValueEx("cust-ident", 
														          bfrCustIdent.cust-code-type + "," 
														          + bfrCustIdent.cust-code + ","  
																  + STRING(bfrCustIdent.cust-type-num),
																  "���ࠧ�", "").  
												outValue2 = outValue2 + GetCodeName("�������", bfrCustIdent.cust-code-type) + ": " + 
														bfrCustIdent.cust-code + ". �뤠�: " + 
														REPLACE(REPLACE(bfrCustIdent.issue, CHR(10), ""), CHR(13), "") +
														" " + tmp +	" " + STRING(bfrCustIdent.open-date, "99.99.9999").
											END.				
										else
										    outErrorStr = outErrorStr + "�����.��筮�� " + ENTRY(j, ENTRY(2, ENTRY(i, inInfo), ":"), ";") + " �� ������!" + CHR(10).  
									END.
									outValue = outValue + outValue2.
								END. ELSE 
									outErrorStr = outErrorStr + "'ident' ����� ���ࠢ���� �ଠ�! ������ ���� 'ident:<code>;<code>;...'" + CHR(10).
									
								IF (ENTRY(i, inInfo) BEGINS "addr") 
								   AND
								   (NUM-ENTRIES(ENTRY(i, inInfo), ":") = 2) 
								THEN DO:
								    outErrorStr = "debug: " + ENTRY(i, inInfo) + " ... num-entries = " + string(NUM-ENTRIES(ENTRY(2, ENTRY(i, inInfo), ":"), ";")) + CHR(10).
									DO j = 1 TO NUM-ENTRIES(ENTRY(2, ENTRY(i, inInfo), ":"), ";") :
										FIND LAST bfrCustIdent WHERE 
												   bfrCustIdent.cust-code-type = ENTRY(j, ENTRY(2, ENTRY(i, inInfo), ":"), ";") AND
												   bfrCustIdent.cust-cat = ENTRY(1, inClientID) AND
												   bfrCustIdent.cust-id = bfrPerson.person-id
												   NO-LOCK NO-ERROR.
									    IF outValue2 <> "" THEN outValue2 = outValue2 + ";". 
										if AVAIL bfrCustIdent then 
											DO:
												outValue2 = outValue2 + bfrCustIdent.issue.
											END.				
										else
										    outErrorStr = outErrorStr + "�����.��筮�� " + ENTRY(j, ENTRY(2, ENTRY(i, inInfo), ":"), ";") + " �� ������!" + CHR(10).  
									END.
									outValue = outValue + outValue2.
								END. ELSE 
									outErrorStr = outErrorStr + "'addr' ����� ���ࠢ���� �ଠ�! ������ ���� 'ident:<code>;<code>;...'" + CHR(10).

							END.
						END. ELSE 
							outErrorStr = "������ " + inClientId + " �� ������!" + CHR(10).  
					END.
				IF ENTRY(1, inClientID) = "�" THEN
					DO:
						FIND FIRST bfrBanks WHERE
							bfrBanks.bank-id = INT(ENTRY(2, inClientID))
							NO-LOCK NO-ERROR.
						IF AVAIL bfrBanks THEN DO:
							DO i = 1 TO NUM-ENTRIES(inInfo):
								IF outValue <> "" THEN outValue = outValue + ",".
								IF ENTRY(i, inInfo) = "name" THEN
									outValue = outValue + bfrBanks.name.
								IF ENTRY(i, inInfo) = "inn" THEN 
									outValue = outValue + bfrBanks.inn.
								IF ENTRY(i, inInfo) = "country" THEN 
									outValue = outValue + bfrBanks.country-id.
								IF (ENTRY(i, inInfo) BEGINS "bank-code") 
								   AND
								   (NUM-ENTRIES(ENTRY(i, inInfo), ":") = 2) 
								THEN DO:
								    outErrorStr = "debug: " + ENTRY(i, inInfo) + " ... num-entries = " + string(NUM-ENTRIES(ENTRY(2, ENTRY(i, inInfo), ":"), ";")) + CHR(10).
									DO j = 1 TO NUM-ENTRIES(ENTRY(2, ENTRY(i, inInfo), ":"), ";") :
										FIND FIRST bfrBanksCode WHERE 
												   bfrBanksCode.bank-id = bfrBanks.bank-id AND
												   bfrBanksCode.bank-code-type = ENTRY(j, ENTRY(2, ENTRY(i, inInfo), ":"), ";")
												   NO-LOCK NO-ERROR.
									    IF outValue2 <> "" THEN outValue2 = outValue2 + ";". 
										if AVAIL bfrBanksCode then 
											outValue2 = outValue2 + bfrBanksCode.bank-code.
										else
										    outErrorStr = outErrorStr + "��� ����� " + ENTRY(j, ENTRY(2, ENTRY(i, inInfo), ":"), ";") + " �� ������!" + CHR(10).  
									END.
									outValue = outValue + outValue2.
								END. ELSE 
									outErrorStr = outErrorStr + "'bank-code' ����� ���ࠢ���� �ଠ�! ������ ���� 'bank-code:<code>;<code>;...'" + CHR(10).
							END.
						END. ELSE 
							outErrorStr = "������ " + inClientId + " �� ������!" + CHR(10).  
							
					END.
			END.
			
		/* �뤠�� �訡�� �� ��࠭ */
		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetClientInfo_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.
	  /* ����� �㭪樨 GetClientInfo_ULL */
END FUNCTION.


/* 

			

*/


FUNCTION GetCredLoanParamValue_ULL RETURNS DECIMAL (
		INPUT inLoan AS CHAR,
		INPUT inParam AS INTEGER,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL ).
		
		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DECIMAL.
		DEFINE BUFFER bfrLoan FOR loan.
		DEFINE BUFFER bfrLoanVar FOR loan-Var.
		
		/* ��������� */
		/** 
		 * ���祭�� ࠧ����� ��ࠬ��஢ �࠭���� � ࠧ����� ⠡����. ���, ���ਬ��, ⥪�饥 ���祭�� 
		 * ��ࠬ��� 4 �࠭���� � �����।�⢥��� � ⠡��� loan � ���� interest[1], � � ⠡���� loan-var 
		 * �������� ������ � ����襭�� ��業⮢. ��㣨� ���祭�� �࠭���� � ⠡��� loan-var
		 */
		
		FOR EACH bfrLoan WHERE
				bfrLoan.contract = "�।��"
				AND
				(
					bfrLoan.cont-code = inLoan
					OR
					bfrLoan.cont-code begins inLoan + " "
				)
				AND
				bfrLoan.open-date LE inDate
				NO-LOCK
			:
				IF (bfrLoan.since LT inDate) AND inShowErrorMsg THEN
					DO:
						outErrorStr = outErrorStr + bfrLoan.cont-code 
								+ " �����⠭ ࠭�� " + STRING(inDate,"99/99/9999") 
								+ " - �� ���뢠����!" + CHR(10).
						NEXT.
					END.
				IF inParam = 4 THEN
					DO:
						outValue = loan.interest[1].
					END.
				ELSE 
					DO:
						FIND LAST bfrLoanVar WHERE 
							bfrLoanVar.contract = bfrLoan.contract
							AND
							bfrLoanVar.cont-code = bfrLoan.cont-code
							AND
							bfrLoanVar.since LE inDate
							AND
							bfrLoanVar.amt-id = inParam
							NO-LOCK NO-ERROR.
				
						IF AVAIL bfrLoanVar THEN
							outValue = outValue + balance.
						ELSE IF inShowErrorMsg
							THEN outErrorStr = outErrorStr + "���祭�� ��ࠬ��� " + STRING(inParam) + " ������� " + bfrLoan.cont-code + " �� ���� " + STRING(inDate,"99/99/9999") + " �� ��।�����!" + CHR(10).
					END.
				
		/* EACH bfrLoan */ 
		END.

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetCredLoanParamValue_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.

		/* ����� �㭪樨 GetCredLoanParamValue_ULL */		
END FUNCTION.

FUNCTION GetCredLoanCommission_ULL RETURNS DECIMAL (
		INPUT inLoan AS CHAR,
		INPUT inComm AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).
		
		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DECIMAL.
		DEFINE BUFFER bfrCommRate FOR comm-rate.
		
		/* ��������� */
		FIND LAST bfrCommRate WHERE 
				bfrCommRate.commission = inComm
				AND
				bfrCommRate.kau = "�।��," + inLoan
				AND
				bfrCommRate.since LE inDate
				NO-LOCK NO-ERROR.
		IF AVAIL bfrCommRate THEN
			outValue = bfrCommRate.rate-comm / 100.
		ELSE
			outErrorStr = "���祭�� �����ᨨ " + inComm + " �� ���� " + STRING(inDate,"99/99/9999") + " �� �������!".

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetCredLoanCommission_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.

		/* ����� �㭪樨 GetCredLoanCommission_ULL */
END FUNCTION.

FUNCTION GetCredLoanAcct_ULL RETURNS CHAR (
		INPUT inLoan AS CHAR,
		INPUT inRole AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).
		
		/* ���।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS CHAR.
		DEFINE BUFFER bfrLoanAcct FOR loan-acct.

		/* ��������� */
		FIND LAST bfrLoanAcct WHERE
				bfrLoanAcct.contract = "�।��"
				AND
				bfrLoanAcct.cont-code = inLoan
				AND
				bfrLoanAcct.acct-type = inRole
				AND
				bfrLoanAcct.since LE inDate
				NO-LOCK NO-ERROR.
		IF AVAIL bfrLoanAcct THEN
			outValue = bfrLoanAcct.acct.
		ELSE
			outErrorStr = "� ����⥪� ��⮢ �।�⭮�� ������� " + inLoan + " ��� � ஫�� " 
					+ inRole + " �� ������ �� ���� " + STRING(inDate,"99/99/9999") + "!".

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetCredLoanAcct_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.
				
		/* ����� �㭪樨 GetCredLoanAcct_ULL */
END FUNCTION.

FUNCTION GetCredLoanInfo_ULL RETURNS CHAR (
		INPUT inLoan AS CHAR,
		INPUT inName AS CHAR,
		INPUT inShowErrorMsg AS LOGICAL).

		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS CHAR.
		DEFINE BUFFER bfrLoan FOR loan.
		DEFINE BUFFER bfrCustCorp FOR cust-corp.
		DEFINE BUFFER bfrSigns FOR signs.
		DEFINE BUFFER bfrPerson FOR person.
		/* ��������� */
		
		FIND FIRST bfrLoan WHERE 
			bfrLoan.contract = "�।��"
			AND
			bfrLoan.cont-code = inLoan
			NO-LOCK NO-ERROR.
		IF AVAIL bfrLoan THEN
			DO:
				/* ��� ������ ������� */
				IF inName = "open_date" THEN
					DO:
						/* ��� ������ � ��⥬� ����� ���� ��४��� ��⮩ ॣ����樨, 
						   ���祭�� ���ன �࠭���� � ���.४����� �������.
						*/
						FIND FIRST bfrSigns WHERE
							bfrSigns.code = "��⠑���"
							AND
							bfrSigns.file-name = "loan"
							AND
							bfrSigns.surrogate = "�।��," + bfrLoan.cont-code
							NO-LOCK NO-ERROR.
						IF AVAIL bfrSigns THEN
							RETURN bfrSigns.code-value.
						
						/* �᫨ ���.४����� ���, � */
						RETURN STRING(bfrLoan.open-date, "99/99/9999").
					END.
				/* ������������ ������ */
				IF inName = "client_name" THEN
					DO:
						IF bfrLoan.cust-cat = "�" THEN
							DO:
								FIND FIRST bfrCustCorp WHERE bfrCustCorp.cust-id = bfrLoan.cust-id NO-LOCK NO-ERROR.
								IF AVAIL bfrCustCorp THEN	
									RETURN TRIM(bfrCustCorp.cust-stat + " " + bfrCustCorp.name-corp).
							END.
						IF bfrLoan.cust-cat = "�" THEN
							DO:
								FIND FIRST bfrPerson WHERE bfrPerson.person-id = bfrLoan.cust-id NO-LOCK NO-ERROR.
								IF AVAIL bfrPerson THEN
									RETURN bfrPerson.name-last + " " + bfrPerson.first-names.
							END.
					END.
			END.
		ELSE
			outErrorStr = outErrorStr + "������� " + inLoan + " �� ������ � ��!" + CHR(10).

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetCredLoanInfo_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		outValue = "".
		RETURN outValue.

		/* ����� �㭪樨 GetCredLoanInfo_ULL */		
END FUNCTION.

/** 3 ����� �㭪権 � 16.02.2006 11:44 */

FUNCTION GetLoanParamValue_ULL RETURNS DECIMAL (
		INPUT inLoanType AS CHAR,
		INPUT inLoan AS CHAR,
		INPUT inParam AS INTEGER,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL ).
		
		/* ��।������ ����७��� ��६����� */
		DEFINE VAR tmpDate AS DATE.
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DECIMAL.
		DEFINE BUFFER bfrLoan FOR loan.
		DEFINE BUFFER bfrLoanVar FOR loan-Var.
		DEFINE BUFFER bfrLoanInt FOR loan-int.
		
		/* ��������� */
		/** 
		 * ���祭�� ࠧ����� ��ࠬ��஢ �࠭���� � ࠧ����� ⠡����. ���, ���ਬ��, ⥪�饥 ���祭�� 
		 * ��ࠬ��� 4 �࠭���� � �����।�⢥��� � ⠡��� loan � ���� interest[1], � � ⠡���� loan-var 
		 * �������� ������ � ����襭�� ��業⮢. ��㣨� ���祭�� �࠭���� � ⠡��� loan-var
		 */
		
		FOR EACH bfrLoan WHERE
				bfrLoan.contract = inLoanType
				AND
				(
					bfrLoan.cont-code = inLoan
					OR
					bfrLoan.cont-code begins inLoan + " "
				)
				AND
				bfrLoan.open-date LE inDate
				AND (
					bfrLoan.close-date = ?
					OR
					bfrLoan.close-date GE inDate
					)
				NO-LOCK
			:
				IF (bfrLoan.since LT inDate) THEN
					DO:
						IF inShowErrorMsg THEN 
							outErrorStr = outErrorStr + bfrLoan.cont-code 
								+ " �����⠭ ࠭�� " + STRING(inDate,"99/99/9999") 
								+ " - �� ���뢠����!" + CHR(10).
						NEXT.
					END.
				IF inParam = 4 THEN
					DO:
						outValue = loan.interest[1].
					END.
					
				FIND LAST bfrLoanVar WHERE 
							bfrLoanVar.contract = bfrLoan.contract
							AND
							bfrLoanVar.cont-code = bfrLoan.cont-code
							AND
							bfrLoanVar.since LE inDate
							AND
							bfrLoanVar.amt-id = inParam
							NO-LOCK NO-ERROR.
				
				IF AVAIL bfrLoanVar THEN 
							DO:
								IF inShowErrorMsg THEN 
									outErrorStr = outErrorStr + "���祭�� ��ࠬ��� " + STRING(inParam) + " ������� " + bfrLoan.cont-code + " �� ���� " + STRING(inDate,"99/99/9999") + " " + STRING(balance) + "." + CHR(10).
								outValue = outValue + balance.
								tmpDate = bfrLoanVar.since.
							END.
				ELSE
							DO:
								IF inShowErrorMsg THEN 
									outErrorStr = outErrorStr + "���祭�� ��ࠬ��� " + STRING(inParam) + " ������� " + bfrLoan.cont-code + " �� ���� " + STRING(inDate,"99/99/9999") + " �� ��।�����!" + CHR(10).
								tmpDate = bfrLoan.open-date - 1.
							END.
						
						FOR EACH bfrLoanInt WHERE 
							bfrLoanInt.contract = bfrLoan.contract
							AND
							bfrLoanInt.cont-code = bfrLoan.cont-code
							AND
							bfrLoanInt.mdate GT tmpDate
							AND
							bfrLoanInt.mdate LE inDate
							AND
							bfrLoanInt.id-k = inParam
							NO-LOCK
							:
							outValue = outValue - amt-rub.
						END.

						FOR EACH bfrLoanInt WHERE 
							bfrLoanInt.contract = bfrLoan.contract
							AND
							bfrLoanInt.cont-code = bfrLoan.cont-code
							AND
							bfrLoanInt.mdate GT tmpDate
							AND
							bfrLoanInt.mdate LE inDate
							AND
							bfrLoanInt.id-d = inParam
							NO-LOCK
							:
							outValue = outValue + amt-rub.
						END.
							
		/* EACH bfrLoan */ 
		END.

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetLoanParamValue_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.

		/* ����� �㭪樨 GetLoanParamValue_ULL */		
END FUNCTION.

FUNCTION GetLoanCommissionEx_ULL RETURNS DECIMAL (
		INPUT inLoanType AS CHAR,
		INPUT inLoan AS CHAR,
		INPUT inComm AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL,
		OUTPUT outValueType AS CHAR).
		
		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR NO-UNDO.
		DEFINE VAR outValue AS DECIMAL NO-UNDO.
		DEFINE BUFFER bfrCommRate FOR comm-rate.
		
		/* ��������� */
		FIND LAST bfrCommRate WHERE 
				bfrCommRate.commission = inComm
				AND
				bfrCommRate.kau = inLoanType + "," + inLoan
				AND
				bfrCommRate.since LE inDate
				NO-LOCK NO-ERROR.
		IF AVAIL bfrCommRate THEN
			ASSIGN
				outValue = bfrCommRate.rate-comm
				outValueType = (if bfrCommRate.rate-fixed then "=" else "%").
		ELSE
			outErrorStr = "���祭�� �����ᨨ " + inComm + " �� ���� " + STRING(inDate,"99/99/9999") + " �� �������!".

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetLoanCommissionEx_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.

		/* ����� �㭪樨 GetLoanCommissionEx_ULL */
END FUNCTION.

FUNCTION GetLoanCommission_ULL RETURNS DECIMAL (
		INPUT inLoanType AS CHAR,
		INPUT inLoan AS CHAR,
		INPUT inComm AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).
		
		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outValue AS DECIMAL.
		DEFINE VAR outValueType AS CHAR.
		
		outValue = GetLoanCommissionEx_ULL(inLoanType, inLoan, inComm, inDate, inShowErrorMsg, outValueType) / 100.
		
		RETURN outValue.

		/* ����� �㭪樨 GetLoanCommission_ULL */
END FUNCTION.

FUNCTION isTemplate RETURNS LOGICAL (INPUT checkSTR AS CHAR).

     /****************************************************************************************************
       *									         *
       *   �㭪�� �஢���� ���室�� �� 㪠������ ��ப� ��� ��।������ 蠡����.       *
       *   �� ���� �஢���� ����稥 � ��ப� ᨬ����� *,!, � .			         *
       *									         *
       *************************************************************************************************** */

         IF ( INDEX(checkSTR,"*") NE 0 OR INDEX(checkSTR,"!") NE 0 OR INDEX(checkSTR,".") NE 0 OR INDEX(checkSTR,",") NE 0) THEN 
		    RETURN TRUE.
		 ELSE
		    RETURN FALSE.

END.

FUNCTION GetLoanAcct_ULL RETURNS CHAR(
		INPUT inLoanType AS CHAR,
		INPUT inLoan AS CHAR,
		INPUT inRole AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).

/*

  ����: ��᫮� �. �.
  �ਬ�砭��:
     ��।����� � 楫�� �᪮७�� ࠡ��� ��楤���.
     ��஡����� �� ��ਠ��.
           1� ��ਠ�� �믮������ ᫨誮� ��������.
           2�� ��ਠ�� ���뢠�� �믮������ �� 411 蠣�.
           3�� ��ਠ�� ��� � �����, �� ࠡ�⠥� �����筮 ����� 
            � �த� ��� ��� �訡��.

*/
		
		/* ���।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS CHAR.
		DEFINE BUFFER bfrLoanAcct FOR loan-acct.


/* ****************************************************************************************************************************************************
1� ��ਠ�� � �ᯮ�짮������ �������᪮�� ���� 
		DEFINE VARIABLE query1 AS CHARACTER.
		DEFINE VARIABLE bfrLoanAcct AS HANDLE NO-UNDO.

		CREATE BUFFER bfrLoanAcct FOR TABLE "loan-acct".

		DEFINE VARIABLE hField AS HANDLE NO-UNDO.

		query1 = "WHERE <cond1> AND <cond2> AND since LE " + QUOTER(inDate).

		IF isTemplate(inLoan) THEN
				            query1 = REPLACE(query1,"<cond1>","CAN-DO(" + QUOTER(inLoan) + ",cont-code)").
			  	    ELSE
				            query1 = REPLACE(query1,"<cond1>","contract = " + QUOTER(inLoanType)).

		IF isTemplate(inRole) THEN 
				           query1 = REPLACE(query1,"<cond2>","CAN-DO(" + QUOTER(inRole) + ",acct-type)").
				     ELSE
				           query1 = REPLACE(query1,"<cond2>","acct-type=" + QUOTER(inRole)).

		bfrLoanAcct:FIND-LAST(query1,NO-LOCK) NO-ERROR.

		IF bfrLoanAcct:AVAILABLE THEN
		     DO:
				hField = bfrLoanAcct:BUFFER-FIELD("acct").
				outValue = hField:STRING-VALUE.
		     END.
*******************************************************************************************************************************************************/

/* *****************************************************************************************************************************************************
2�� ��ਠ�� � �ᯮ�짮������ �������᪮�� �����
		DEFINE BUFFER bfrLoanAcct FOR loan-acct.

		/* ��।��塞 �������᪨� ���� */
		DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
		CREATE QUERY hQuery.

		/* ����뢠�� ��� ⠡���� � ���ன �㤥� ࠡ���� */
		hQuery:SET-BUFFERS(BUFFER bfrLoanAcct:HANDLE).

		/* ��ନ�㥬 ����� � �� �� �᭮�� ⮣� � ����� ���� ��।��� inLoan � inRole */
		DEFINE VARIABLE query1 AS CHARACTER.
		query1="FOR EACH bfrLoanAcct WHERE <cond1> AND <cond2> AND bfrLoanAcct.since LE " + QUOTER(inDate).

		IF isTemplate(inLoan) THEN
				            query1 = REPLACE(query1,"<cond1>","CAN-DO(" + QUOTER(inLoan) + ",bfrLoanAcct.cont-code)").
			  	    ELSE
				            query1 = REPLACE(query1,"<cond1>","bfrLoanAcct.contract = " + QUOTER(inLoanType)).

		IF isTemplate(inRole) THEN 
				           query1 = REPLACE(query1,"<cond2>","CAN-DO(" + QUOTER(inRole) + ",bfrLoanAcct.acct-type)").
				     ELSE
				           query1 = REPLACE(query1,"<cond2>","bfrLoanAcct.acct-type=" + QUOTER(inRole)).					
				        					
		/* �����⠢������ ����� */
		hQuery:QUERY-PREPARE(query1).

		/* ���뢠�� ����� */
		hQuery:QUERY-OPEN().

		IF hQuery:NUM-RESULTS NE 0 THEN
			DO:
	  		/* ����砥� ⥪���� ������ */
			hQuery:GET-LAST(NO-LOCK).	
			outValue = bfrLoanAcct.acct.
			END.
		ELSE
			outErrorStr = "� ����⥪� ��⮢ ������� " + inLoan + " ��� � ஫�� " 
					+ inRole + " �� ������ �� ���� " + STRING(inDate,"99/99/9999") + "!".

		hQuery:QUERY-CLOSE().
********************************************************************************************************************************************************/

/* 3�� ��ਠ�� �����, �� ࠡ���騩 */

		IF NOT isTemplate(inLoan) AND NOT isTemplate(inRole) THEN
		    DO:
			/* ��� ��।����� ��ࠬ��� ᪫��� ���祭�� */
			FIND LAST bfrLoanAcct WHERE
				bfrLoanAcct.contract = inLoanType
				AND
				bfrLoanAcct.cont-code = inLoan
				AND
				bfrLoanAcct.acct-type = inRole
				AND
				bfrLoanAcct.since LE inDate
				NO-LOCK NO-ERROR.
		    END.
		    ELSE
		        DO:
			/* ���� ��ࠬ��� ᪫��, ��ன 蠡��� */
			IF isTemplate(inLoan) AND NOT isTemplate(inRole) THEN
                                                    DO:
			          FIND LAST bfrLoanAcct WHERE
				  bfrLoanAcct.contract = inLoanType
				  AND
				  CAN-DO(inLoan, bfrLoanAcct.cont-code)
				  AND
				  bfrLoanAcct.acct-type = inRole
				  AND
				  bfrLoanAcct.since LE inDate
				  NO-LOCK NO-ERROR.
		                   END.
		                   ELSE
			         DO:
			            IF NOT isTemplate(inLoan) AND isTemplate(inRole) THEN
				 DO:
				        /* ���� ��ࠬ��� 蠡���, ��ன ᪫�� */
			                        FIND LAST bfrLoanAcct WHERE
				                 bfrLoanAcct.contract = inLoanType
				                   AND
					   bfrLoanAcct.cont-code = inLoan
					   AND
					CAN-DO(inRole,bfrLoanAcct.acct-type)
					   AND
					bfrLoanAcct.since LE inDate
					NO-LOCK NO-ERROR.
				 END.
				    ELSE
				            DO:
					/* ��� ��ࠬ��� 蠡���� */
  			                                 FIND LAST bfrLoanAcct WHERE
				                 bfrLoanAcct.contract = inLoanType
				                   AND
					CAN-DO(inLoan, bfrLoanAcct.cont-code)
					   AND
					CAN-DO(inRole,bfrLoanAcct.acct-type)
					   AND
					bfrLoanAcct.since LE inDate
					NO-LOCK NO-ERROR.					   
				            END.
		                          END.
			END.

		IF AVAIL bfrLoanAcct THEN
			outValue = bfrLoanAcct.acct.
		ELSE
			outErrorStr = "� ����⥪� ��⮢ ������� " + inLoan + " ��� � ஫�� " 
					+ inRole + " �� ������ �� ���� " + STRING(inDate,"99/99/9999") + "!".

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetLoanAcct_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr 
				              + CHR(10) + "is inLoan a mask? = " + STRING(isTemplate(inLoan)) 
				              + CHR(10) + "is inRole a mask? = " + STRING(isTemplate(inRole)).
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.
				
		/* ����� �㭪樨 GetLoanAcct_ULL */
END FUNCTION.

FUNCTION GetLoanInfo_ULL RETURNS CHAR (
		INPUT inLoanType AS CHAR,
		INPUT inLoan AS CHAR,
		INPUT inName AS CHAR,
		INPUT inShowErrorMsg AS LOGICAL).

		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS CHAR.
		DEFINE VAR tmp AS CHAR.
		DEFINE VAR i AS INTEGER.
		DEFINE VAR n AS INTEGER. /** ���浪��� ����� ������� ���ᯥ祭��. �������� � ��ࠬ��� inName */
		DEFINE BUFFER bfrLoan FOR loan.
		DEFINE BUFFER bfrCustCorp FOR cust-corp.
		DEFINE BUFFER bfrSigns FOR signs.
		DEFINE BUFFER bfrPerson FOR person.
		DEFINE BUFFER bfrBanks FOR banks.
		DEFINE BUFFER bfrTermObl FOR term-obl.
		/* ��������� */
		
		FIND FIRST bfrLoan WHERE 
			bfrLoan.contract = inLoanType
			AND
			bfrLoan.cont-code = inLoan
			NO-LOCK NO-ERROR.
		IF AVAIL bfrLoan THEN
			DO:
				DO i = 1 TO NUM-ENTRIES(inName) :
				IF outValue <> "" THEN outValue = outValue + ",".
				/* ��� ������ ������� */
				IF ENTRY(i,inName) = "open_date" THEN
					DO:
						/* ��� ������ � ��⥬� ����� ���� ��४��� ��⮩ ॣ����樨, 
						   ���祭�� ���ன �࠭���� � ���.४����� �������.
						*/
						FIND FIRST bfrSigns WHERE
							bfrSigns.code = "��⠑���"
							AND
							bfrSigns.file-name = "loan"
							AND
							bfrSigns.surrogate = bfrLoan.contract + "," + bfrLoan.cont-code
							NO-LOCK NO-ERROR.
						IF AVAIL bfrSigns THEN
							outValue = outValue + bfrSigns.code-value.
						ELSE
							/* �᫨ ���.४����� ���, � */
							outValue = outValue + STRING(bfrLoan.open-date, "99/99/9999").
					END.
				/** ��� ����砭�� ������� */
				IF ENTRY(i,inName) = "end_date" THEN
					DO:
						outValue = outValue + STRING(bfrLoan.end-date,"99/99/9999").
					END.
				/* ������������ ������ */
				IF ENTRY(i,inName) BEGINS "client" THEN
					DO:
						IF bfrLoan.cust-cat = "�" THEN
							DO:
								FIND FIRST bfrCustCorp WHERE bfrCustCorp.cust-id = bfrLoan.cust-id NO-LOCK NO-ERROR.
								IF AVAIL bfrCustCorp THEN	DO:
									IF ENTRY(i,inName) = "client_name" THEN 
										/** outValue = outValue + TRIM(bfrCustCorp.cust-stat + " " + bfrCustCorp.name-corp). */
										outValue = outValue + bfrCustCorp.name-short.
									IF ENTRY(i,inName) = "client_fullname" THEN
									    outValue = outValue + GetXAttrValueEx("cust-corp", STRING(bfrCustCorp.cust-id), "FullName", "").
									IF ENTRY(i,inName) = "client_short_name" THEN
										outValue = outValue + TRIM(bfrCustCorp.name-short).
									IF ENTRY(i,inName) = "client_country" THEN 
									  outValue = outValue + bfrCustCorp.country-id.
									IF ENTRY(i,inName) = "client_address" THEN 
									  outValue = outValue + LoopReplace_ULL(bfrCustCorp.addr-of-low[1],",,",",").
								END.
							END.
						IF bfrLoan.cust-cat = "�" THEN
							DO:
								FIND FIRST bfrPerson WHERE bfrPerson.person-id = bfrLoan.cust-id NO-LOCK NO-ERROR.
								IF AVAIL bfrPerson THEN DO:
									IF CAN-DO("client_name,client_short_name", ENTRY(i,inName)) THEN
										outValue = outValue + bfrPerson.name-last + " " + bfrPerson.first-names.
									IF ENTRY(i,inName) = "client_country" THEN
										outValue = outValue + bfrPerson.country-id.
									IF ENTRY(i,inName) = "client_address" THEN
									  outValue = LoopReplace_ULL(outValue + address[1] + " " + address[2],",,",",").
								END.
							END.
						IF bfrLoan.cust-cat = "�" THEN
							DO:
								FIND FIRST bfrBanks WHERE bfrBanks.bank-id = bfrLoan.cust-id NO-LOCK NO-ERROR.
								IF AVAIL bfrBanks THEN DO:
									IF ENTRY(i,inName) = "client_name" THEN
										outValue = outValue + bfrBanks.name.
									IF ENTRY(i,inName) = "client_country" THEN
										outValue = outValue + bfrBanks.country-id.
									IF ENTRY(i, inName) = "client_address" THEN 
									  outValue = outValue + LoopReplace_ULL(bfrBanks.law-address, ",,", ",").
								END.
								ELSE outErrorStr = outErrorStr + "���� � ����� '" + STRING(bfrLoan.cust-id) 
													+ "' �� ������!" + CHR(10).
							END.
					END.
				IF ENTRY(i,inName) = "risk" THEN
					DO:
						outValue = outValue + STRING(bfrLoan.risk).
					END.
				IF ENTRY(i,inName) = "gr_riska" THEN
					DO:
						outValue = outValue + STRING(bfrLoan.gr-riska).
					END.
				/** ������������ �����⥫� �� n-��� ������� ���ᯥ祭�� */
				IF ENTRY(i, inName) BEGINS "guarantor_name" THEN
					DO:
						tmp = ENTRY(i, inName).
						/** �஢��塞 ᨭ⠪��: ���_��ࠬ���(<n>) */
						IF NUM-ENTRIES(tmp, "(") = 2 AND NUM-ENTRIES(tmp, ")") = 2 THEN
							DO:
								/** ���쬥� ������ - ���浪��� ����� ������� ���ᯥ祭��, �஢���� ⨯ ������*/
								n = INT(ENTRY(1,ENTRY(2, tmp, "("), ")")) NO-ERROR.
								IF NOT ERROR-STATUS:ERROR THEN
									DO:
										/** ������ ���ᯥ祭�� � ���浪��� ����஬ n */
										FIND FIRST bfrTermObl WHERE RECID(bfrTermObl) = n
												NO-LOCK NO-ERROR.
										IF AVAIL bfrTermObl THEN 
											DO:
												IF bfrTermObl.symbol = "�" THEN DO:
													FIND FIRST bfrPerson WHERE bfrPerson.person-id = bfrTermObl.fop NO-LOCK NO-ERROR.
													IF AVAIL bfrPerson THEN DO:
														outValue = outValue + bfrPerson.name-last + " " + bfrPerson.first-names.
													END.
												END.
												IF bfrTermObl.symbol = "�" THEN DO:
													FIND FIRST bfrCustCorp WHERE bfrCustCorp.cust-id = bfrTermObl.fop NO-LOCK NO-ERROR.
													IF AVAIL bfrCustCorp THEN	DO:
														/* Buryagin commented at 30.09.2010 12:36
														outValue = outValue + TRIM(bfrCustCorp.cust-stat + " " + bfrCustCorp.name-corp).
														*/
														outValue = outValue + TRIM(bfrCustCorp.name-short).
													END.
												END.
												IF bfrTermObl.symbol = "�" THEN DO:
													FIND FIRST bfrBanks WHERE bfrBanks.bank-id = bfrTermObl.fop NO-LOCK NO-ERROR.
													IF AVAIL bfrBanks THEN DO:
														outValue = outValue + bfrBanks.name.
													END.
												END.
											END.
										ELSE
											outErrorStr = outErrorStr + "��� ������� '" + bfrLoan.contract + "." + bfrLoan.cont-code 
													+ "' ������� ���ᯥ祭�� � ���浪��� ����஬ '" + STRING(n) + "' �� ������!" + CHR(10).
									END.
								ELSE
									outErrorStr = outErrorStr + "������ � ��ࠬ��� '" + tmp + "' �� ���� 楫� �᫮�!" + CHR(10).								
							END.
						ELSE
							outErrorStr = outErrorStr + "���⠪�� ��ࠬ��� '" + tmp 
								+ "' ������! ������ ����: guarantor_name(n), ��� n - ���浪��� ����� ������� ���ᯥ祭��." + CHR(10).
					END.
					
				END. /* DO i = ... */
			END.
		ELSE
			outErrorStr = outErrorStr + "������� " + inLoan + " �� ������ � ��!" + CHR(10).

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetLoanInfo_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.

		/* ����� �㭪樨 GetLoanInfo_ULL */		
END FUNCTION.

FUNCTION GetMainLoan_ULL RETURN CHAR (
		INPUT inLoanType AS CHAR,
		INPUT inLoan AS CHAR,
		INPUT inShowErrorMsg AS LOGICAL).
		/** ��।������ �������� ��६����� */
		DEF VAR outValue AS CHAR.
		DEF VAR outErrorStr AS CHAR.
		DEF BUFFER bfrLoan FOR loan.
		/** ������ ��।���� ������� */
		FIND FIRST bfrLoan WHERE
			bfrLoan.contract = inLoanType
			AND
			bfrLoan.cont-code = inLoan
			NO-LOCK NO-ERROR.
		IF AVAIL bfrLoan THEN
			DO:
				IF NUM-ENTRIES(bfrLoan.cont-code," ") > 1 THEN
					outValue = bfrLoan.contract + "," + ENTRY(1,bfrLoan.cont-code," ").
				ELSE
					outValue = bfrLoan.contract + "," + bfrLoan.cont-code.
			END.
		ELSE
			outErrorStr = outErrorStr + "������� " + inLoanType + "," + inLoan + " �� ������!" + CHR(10).
			
		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetMainLoan_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.
END FUNCTION.

FUNCTION GetLoanLimit_ULL RETURN DECIMAL (
		INPUT inLoanType AS CHAR,
		INPUT inLoan AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).
		/** ��।������ ����७��� ��६����� */
		DEF VAR outErrorStr AS CHAR.
		DEF VAR outValue AS DECIMAL.
		DEF BUFFER bfrLoan FOR loan.
		DEF BUFFER bfrTermObl FOR term-obl.
		/** ������ ������� */
		FIND FIRST bfrLoan WHERE 
			bfrLoan.contract = inLoanType
			AND
			bfrLoan.cont-code = inLoan
			NO-LOCK NO-ERROR.
		IF AVAIL bfrLoan THEN 
			DO:
				/** ������ �����-� 䨣��, ����� ᮤ�ন� ���ଠ�� � ����� */
				FIND LAST bfrTermObl WHERE
					bfrTermObl.contract = bfrLoan.contract
					AND
					bfrTermObl.cont-code = bfrLoan.cont-code
					AND
					bfrTermObl.end-date LE inDate
					AND
					bfrTermObl.idnt = 2
					NO-LOCK NO-ERROR.
				IF AVAIL bfrTermObl THEN
					DO:
						outValue = bfrTermObl.amt.
					END.
				ELSE
					outErrorStr = outErrorStr + "�� ������� ������ � ⠡��� term-obl ��� ������� " + 
						bfrLoan.contract + "," + bfrLoan.cont-code + ", � ���ன �࠭���� ���ଠ�� � �����!" + CHR(10).
			END.
		ELSE
			outErrorStr = outErrorStr + "������� " + inLoanType + "," + inLoan + " �� ������!" + CHR(10).

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetMainLoan_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.
END FUNCTION.

FUNCTION GetLoanNextDatePercentPayOut_ULL RETURNS DATE (
		INPUT inLoanType AS CHAR,
		INPUT inLoan AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).

		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DATE.
		DEFINE BUFFER bfrLoan FOR loan.
		DEFINE BUFFER bfrLoanCond FOR loan-cond.
		DEF VAR tmpDate AS DATE.
		/** ������ �������, ��।���� � �㭪�� */
		FIND FIRST bfrLoan WHERE 
			bfrLoan.contract = inLoanType
			AND
			bfrLoan.cont-code = inLoan
			NO-LOCK NO-ERROR.
		IF AVAIL bfrLoan THEN
			DO:
				/** ������ �᫮��� �������, �������騥 �� ���� ��ࠬ��� inDate */
				FIND LAST bfrLoanCond WHERE 
					bfrLoanCond.contract = bfrLoan.contract
					AND
					bfrLoanCond.cont-code = bfrLoan.cont-code
					AND
					bfrLoanCond.since LE inDate
					NO-LOCK NO-ERROR.
				IF AVAIL bfrLoanCond THEN
					DO:
						CASE bfrLoanCond.int-period :
							WHEN "��[1]" OR WHEN "��[2]" OR WHEN "��[3]" OR WHEN "��[4]" OR WHEN "��[5]" OR WHEN "��[6]"
													 OR WHEN "��[7]" OR WHEN "��[8]" OR WHEN "��[9]" OR WHEN "��[10]" OR WHEN "��[11]" 
							THEN	
								DO:
									outValue = DATE(MONTH(bfrLoanCond.since),bfrLoanCond.int-date,YEAR(bfrLoanCond.since)).
									REPEAT WHILE outValue < inDate :
										outValue = GoMonth(outValue, INTEGER(ENTRY(1,ENTRY(2, bfrLoanCond.int-period, "["),"]"))).
									END.
								END.
							WHEN "��" THEN
								outValue = bfrLoan.end-date.
							/* ����� ����⠫, �⭮�⥫쭮 ���� ������ */
							WHEN "��" THEN 
								DO:
									outValue = DATE(MONTH(bfrLoanCond.since), 1, YEAR(bfrLoanCond.since)).
									/** outValue = GoMonth(outValue, bfrLoanCond.int-month - 1). */
									/** 
									  �������� ����.
									*/  
									REPEAT WHILE outValue < inDate 
										OR 
										(
											MONTH(bfrLoan.open-date) = MONTH(outValue) 
											AND
											YEAR(bfrLoan.open-date) = YEAR(outValue)
										):
										outValue = GoMonth(outValue, 3).
									IF bfrLoanCond.int-date = 31 THEN
										outValue = DATE(MONTH(outValue), RE_KDAYS(MONTH(outValue),YEAR(outValue)), YEAR(outValue)).
									ELSE
										outValue = DATE(MONTH(outValue), bfrLoanCond.int-date, YEAR(outValue)).
									END.
									/** ��뢠�� �����⥭��� �㭪�� �� pp-date.p */
									/** outValue = kvart_end(inDate).		*/
								END.
							WHEN "��" THEN 
								DO:
									/** ��뢠�� �����⥭��� �㭪�� �� pp-date.p */
									outValue = LastMonDate(inDate).		
								END.
							/** ����� ��������� ����⠫ */
							WHEN "�" THEN 
								DO:
									outValue = kvart_beg(inDate).
									
									/** MESSAGE "1 " outValue VIEW-AS ALERT-BOX. */
									
									outValue = GoMonth(outValue, bfrLoanCond.int-month - 1).
									
									/** MESSAGE "2 " outValue VIEW-AS ALERT-BOX. */
									
									IF bfrLoanCond.int-date = 31 THEN
										outValue = DATE(MONTH(outValue), RE_KDAYS(MONTH(outValue),YEAR(outValue)), YEAR(outValue)).
									ELSE
								    	outValue = DATE(MONTH(outValue), bfrLoanCond.int-date, YEAR(outValue)).
									/** 
									  �������� ����.
									*/
									
									/** MESSAGE "before while " outvalue VIEW-AS ALERT-BOX. */
									  
									REPEAT WHILE outValue < inDate 
										/*OR 
										(
											MONTH(bfrLoan.open-date) = MONTH(outValue) 
											AND
											YEAR(bfrLoan.open-date) = YEAR(outValue)
										)*/
										:
										outValue = GoMonth(outValue, 3).
										
										/** MESSAGE "into cycle outvalue= " outValue VIEW-AS ALERT-BOX. */ 
										
										/*
										IF bfrLoanCond.int-date = 31 THEN
											outValue = DATE(MONTH(outValue), RE_KDAYS(MONTH(outValue),YEAR(outValue)), YEAR(outValue))
										ELSE
									    	outValue = DATE(MONTH(outValue), bfrLoanCond.int-date, YEAR(outValue)).
									    */
									END.
								END.
							WHEN "�" THEN 
								DO:
									/*outValue = DATE(MONTH(inDate),bfrLoanCond.int-date,YEAR(inDate)).*/
									outValue = LastMonDate(inDate).
									IF DAY(inDate) > bfrLoanCond.int-date THEN
										outValue = GoMonth(outValue, 1).										
								END.
							OTHERWISE
								outErrorStr = outErrorStr + "��������� ⨯ ��ਮ�� �믫��� ��業⮢!" + CHR(10).
						END CASE.
						/** ������塞 � ��� ������⢮ ���� �� ���� "�஡��" */
						outValue = outValue + bfrLoanCond.delay.
						/** �᫨ ������� ������ ���������� ࠭�� */
						IF bfrLoan.end-date < outValue THEN outValue = bfrLoan.end-date.
					END.
				ELSE
					outErrorStr = outErrorStr + "�᫮��� ������� " + bfrLoan.contract + "," + bfrLoan.cont-code
						+ " �� �������!" + CHR(10).
			END.
		ELSE
			outErrorStr = outErrorStr + "������� ," + inLoan	+ " �� ������!" + CHR(10).


		/** �뢮� ����������� �訡�� */
		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetLoanNextDatePercentPayOut_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
		
		RETURN outValue.
		
END FUNCTION.



FUNCTION GetDpsCurrentPersent_ULL RETURNS DECIMAL (
		INPUT inLoan AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).

		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DECIMAL.
		DEFINE VAR lastNachDate AS DATE.
		/** ��� ��業⮢ */
		DEFINE VAR loanAcctInt AS CHAR.
		DEFINE VAR i AS DATE.
		DEFINE VAR mainPeriod AS INTEGER INITIAL 365.
		DEFINE VAR commRate AS DECIMAL.
		DEFINE VAR loanAcct AS CHAR.
		DEFINE VAR oldPos AS DECIMAL.
		DEFINE VAR newPos AS DECIMAL.
		DEF VAR beg-sub-period AS DATE.
		DEF VAR period AS INTEGER.
		DEFINE BUFFER bfrLoan FOR loan.
		DEFINE BUFFER bfrOp FOR op.
		DEFINE BUFFER bfrOpEntry FOR op-entry.
		/* ��������� */
		FIND FIRST bfrLoan WHERE
			bfrLoan.contract = "dps"
			AND
			bfrLoan.cont-code = inLoan
			NO-LOCK NO-ERROR.
		IF AVAIL bfrLoan THEN DO:
			IF (bfrLoan.end-date <> ?) AND (bfrLoan.end-date < inDate) THEN
				DO:
					outValue = 0.
					RETURN outValue.
				END.
			loanAcctInt = GetLoanAcct_ULL(bfrLoan.contract, bfrLoan.cont-code, "loan-dps-int", inDate, false).
			IF bfrLoan.cont-type = "��" THEN
				DO:
					lastNachDate = DATE(MONTH(inDate),1,YEAR(inDate)) - 1.
				END.
			ELSE
				DO:
					lastNachDate = bfrLoan.open-date.
					FOR LAST bfrOpEntry WHERE
						(
					  	(
					  		bfrOpEntry.acct-cr = loanAcctInt
					  		AND
					  		bfrOpEntry.kau-cr = bfrLoan.contract + "," + bfrLoan.cont-code + ",����"
					  	)
					  	OR 
					  	(
					  		bfrOpEntry.acct-db BEGINS "7"
					  		AND
					  		bfrOpEntry.kau-cr BEGINS bfrLoan.contract + "," + bfrLoan.cont-code + ","
					  	)
					  )
					  AND
					  bfrOpEntry.op-date LE inDate
					  AND
					  bfrOpEntry.op-date GE bfrLoan.open-date
					  NO-LOCK,
					FIRST bfrOp OF bfrOpEntry 
				    NO-LOCK
					:
						lastNachDate = bfrOp.contract-date.
					END.
				END.
			IF TRUNCATE(YEAR(lastNachDate + 1) / 4,0) = YEAR(lastNachDate + 1) / 4 THEN 
				mainPeriod = 366. ELSE mainPeriod = 365.
			loanAcct = GetLoanAcct_ULL(bfrLoan.contract, bfrLoan.cont-code, "loan-dps-t,loan-dps-p", lastNachDate, false).
			newPos = ABS(GetAcctPosValue_UAL(loanAcct, bfrLoan.currency, lastNachDate, false)).
			commRate = GetDpsCommission_ULL(bfrLoan.cont-code, "commission", lastNachDate, false).
			beg-sub-period = lastNachDate.
			/** R���� ���� */
			DO i = lastNachDate + 1 TO inDate - 1 :
				oldPos = newPos.
				newPos = ABS(GetAcctPosValue_UAL(loanAcct, bfrLoan.currency, i, false)).
				IF (newPos <> oldPos) OR (DAY(i + 1) = 1) THEN DO:
					IF TRUNCATE(YEAR(i) / 4,0) = (YEAR(i) / 4) THEN 
						mainPeriod = 366. ELSE mainPeriod = 365.
					period = i - beg-sub-period.
					outValue = outValue + oldPos * commRate * period / mainPeriod.
					beg-sub-period = i.
				END.
			END.	
			period = inDate - beg-sub-period.
			outValue = outValue + newPos * commRate * period / mainPeriod.
		END.
		RETURN outValue.
END FUNCTION.
			
FUNCTION GetDpsCommission_ULL RETURN DECIMAL (
		INPUT inLoan AS CHAR,
		INPUT inTypeComm AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).
		
		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR    NO-UNDO.
		DEFINE VAR outValue    AS DECIMAL NO-UNDO.
		DEF VAR localMinValue  AS DECIMAL NO-UNDO.
		
		DEFINE BUFFER bfrLoan FOR loan.
		DEFINE BUFFER bfrLoanAcct FOR loan-acct.
		DEFINE BUFFER bfrSigns FOR signs.
		DEFINE BUFFER bfrCommRate FOR comm-rate.
		
		
		/** ��������� */
		FIND FIRST bfrLoan WHERE
			bfrLoan.contract = "dps"
			AND
			bfrLoan.cont-code = inLoan
			NO-LOCK NO-ERROR.
		IF AVAIL bfrLoan THEN DO:
			FIND LAST bfrLoanAcct WHERE
				bfrLoanAcct.contract = bfrLoan.contract
				AND
				bfrLoanAcct.cont-code = bfrLoan.cont-code
				AND
				CAN-DO("loan-dps-t,loan-dps-p",bfrLoanAcct.acct-type)
				AND
				bfrLoanAcct.since LE inDate
				NO-LOCK NO-ERROR.
			IF AVAIL bfrLoanAcct THEN DO:
				FIND FIRST bfrSigns WHERE 
					bfrSigns.code = inTypeComm
					AND
					file-name = "op-template"
					AND
					surrogate BEGINS bfrLoan.op-kind
					NO-LOCK NO-ERROR.
				IF AVAIL bfrSigns THEN DO:
					localMinValue = ABS(
							GetAcctPosValueEx_UAL(bfrLoanAcct.acct, bfrLoan.currency, 
								(IF bfrLoan.cont-type = "��" THEN inDate ELSE bfrLoanAcct.since), "�", false)
							).
					IF localMinValue = 0 THEN 
						localMinValue = ABS(
							GetAcctPosValueEx_UAL(bfrLoanAcct.acct, bfrLoan.currency, 
								(IF bfrLoan.cont-type = "��" THEN inDate ELSE bfrLoanAcct.since + 1), "�", false)
							).
					IF localMinValue = 0 THEN 
						localMinValue = ABS(
							GetAcctPosValueEx_UAL(bfrLoanAcct.acct, bfrLoan.currency, 
								(IF bfrLoan.cont-type = "��" THEN inDate ELSE bfrLoanAcct.since + 2), "�", false)
							).
					IF localMinValue = 0 THEN 
						localMinValue = ABS(
							GetAcctPosValueEx_UAL(bfrLoanAcct.acct, bfrLoan.currency, 
								(IF bfrLoan.cont-type = "��" THEN inDate ELSE bfrLoanAcct.since + 3), "�", false)
							).		
							
					/** MESSAGE STRING(localMinValue) VIEW-AS ALERT-BOX. */
					FIND LAST bfrCommRate WHERE
						bfrCommRate.commission = bfrSigns.code-value
						AND
						bfrCommRate.currency = bfrLoan.currency
						
						AND
						bfrCommRate.min-value LE localMinValue
						AND
						(
							bfrCommRate.period = 0
							OR
							bfrCommRate.period LE (bfrLoan.end-date - bfrLoan.open-date)
						)
						AND
						(
							(
								bfrCommRate.acct = "0"
								AND 
								bfrCommRate.since <= bfrLoan.open-date
							)
							OR
							(
								bfrCommRate.acct = bfrLoanAcct.acct
								AND
								bfrCommRate.since <= inDate
							)
						)
						/*USE-INDEX comm-rate*/
						NO-LOCK NO-ERROR.
					IF AVAIL bfrCommRate THEN DO:
						outValue = bfrCommRate.rate-comm / 100. 
						END.
				END.
			END.
		END.
		RETURN outValue.
END FUNCTION.

FUNCTION GetDpsNextDatePercentPayOut_ULL RETURNS DATE (
		INPUT inLoan AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).

		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DATE.
		DEFINE BUFFER bfrLoan FOR loan.
		DEFINE BUFFER bfrLoanCond FOR loan-cond.
		DEF VAR tmpDate AS DATE.
		/** ������ �������, ��।���� � �㭪�� */
		FIND FIRST bfrLoan WHERE 
			bfrLoan.contract = "dps"
			AND
			bfrLoan.cont-code = inLoan
			NO-LOCK NO-ERROR.
		IF AVAIL bfrLoan THEN
			DO:
				/** ������ �᫮��� �������, �������騥 �� ���� ��ࠬ��� inDate */
				FIND LAST bfrLoanCond WHERE 
					bfrLoanCond.contract = bfrLoan.contract
					AND
					bfrLoanCond.cont-code = bfrLoan.cont-code
					AND
					bfrLoanCond.since LE inDate
					NO-LOCK NO-ERROR.
				IF AVAIL bfrLoanCond THEN
					DO:
						CASE bfrLoanCond.int-period :
							WHEN "��[1]" OR WHEN "��[2]" OR WHEN "��[3]" OR WHEN "��[4]" OR WHEN "��[5]" OR WHEN "��[6]"
													 OR WHEN "��[7]" OR WHEN "��[8]" OR WHEN "��[9]" OR WHEN "��[10]" OR WHEN "��[11]" 
							THEN	
								DO:
									outValue = DATE(MONTH(bfrLoanCond.since),bfrLoanCond.int-date,YEAR(bfrLoanCond.since)).
									REPEAT WHILE outValue < inDate :
										outValue = GoMonth(outValue, INTEGER(ENTRY(1,ENTRY(2, bfrLoanCond.int-period, "["),"]"))).
									END.
								END.
							WHEN "��" THEN
								outValue = bfrLoan.end-date.
							WHEN "��" THEN 
								DO:
									/** ��뢠�� �����⥭��� �㭪�� �� pp-date.p */
									outValue = kvart_end(inDate).		
								END.
							WHEN "��" THEN 
								DO:
									/** ��뢠�� �����⥭��� �㭪�� �� pp-date.p */
									outValue = LastMonDate(inDate).		
								END.
							WHEN "�" THEN 
								DO:
									outValue = kvart_beg(inDate).
									outValue = GoMonth(outValue, bfrLoanCond.int-month - 1).
									/** ��ନ�㥬 ���� ����� � ��⮬ ����� �� ��ࠧ�� ��᫥ ᤢ��� ���� */
									IF bfrLoanCond.int-date = 31 THEN
										outValue = DATE(MONTH(outValue), RE_KDAYS(MONTH(outValue),YEAR(outValue)), YEAR(outValue)).
									ELSE
										outValue = DATE(MONTH(outValue), bfrLoanCond.int-date, YEAR(outValue)).
									/** 
									  �������� ����.
									*/  
									REPEAT WHILE outValue < inDate 
										OR 
										(
											MONTH(bfrLoan.open-date) = MONTH(outValue) 
											AND
											YEAR(bfrLoan.open-date) = YEAR(outValue)
										):
										outValue = GoMonth(outValue, 3).
									  /** ���४�஢�� */
									  IF bfrLoanCond.int-date = 31 THEN
										  outValue = DATE(MONTH(outValue), RE_KDAYS(MONTH(outValue),YEAR(outValue)), YEAR(outValue)).
									  ELSE
										  outValue = DATE(MONTH(outValue), bfrLoanCond.int-date, YEAR(outValue)).
									END.

								END.
							WHEN "�" THEN 
								DO:
									outValue = DATE(MONTH(inDate),bfrLoanCond.int-date,YEAR(inDate)).
									/* �᫨ ��������� ��� 㦥 ��諠, � ������� ���� �� 1 ����� ���। */
									IF DAY(inDate) > DAY(outValue) THEN
										outValue = GoMonth(outValue, 1).
									/** �������� �� 1 ����� �᫨ ����� � ��� ���⭮� ���� ࠢ�� ������ � ���� ��砫� �᫮��� */
									IF (MONTH(outValue) = MONTH(bfrLoanCond.since)) AND (YEAR(outValue) = YEAR(bfrLoanCond.since)) THEN
										outValue = GoMonth(outValue, 1).
								END.
							OTHERWISE
								outErrorStr = outErrorStr + "��������� ⨯ ��ਮ�� �믫��� ��業⮢!" + CHR(10).
						END CASE.
						/** �᫨ ������� ������ ���������� ࠭�� */
						IF bfrLoan.end-date < outValue THEN outValue = bfrLoan.end-date.
					END.
				ELSE
					outErrorStr = outErrorStr + "�᫮��� ������� " + bfrLoan.contract + "," + bfrLoan.cont-code
						+ " �� �������!" + CHR(10).
			END.
		ELSE
			outErrorStr = outErrorStr + "������� dps," + inLoan	+ " �� ������!" + CHR(10).


		/** �뢮� ����������� �訡�� */
		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetDpsNextDatePercentPayOut_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
		
		RETURN outValue.
		
END FUNCTION.

FUNCTION GetCommRateEx_ULL RETURNS DECIMAL (
		INPUT inCommission AS CHAR,
		INPUT inCurrency AS CHAR,
		INPUT inMinSumma AS DECIMAL,
		INPUT inAcct AS CHAR,
		INPUT inPeriod AS INTEGER,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL,
		OUTPUT outValueType AS CHAR).

		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DECIMAL.
		DEFINE BUFFER bfrCommRate FOR comm-rate.

		FIND LAST bfrCommRate WHERE
			bfrCommRate.commission = inCommission
			AND
			bfrCommRate.currency = inCurrency
			AND
			bfrCommRate.since LE inDate
			AND
			bfrCommRate.min-value LE inMinSumma
			AND
			(
				bfrCommRate.period = 0
				OR
				bfrCommRate.period LE inPeriod
			)
			AND
			(
				bfrCommRate.acct = "0"
				OR
				bfrCommRate.acct = inAcct
			)
			/*USE-INDEX comm-rate
			�.�.�ନ��� - 19/01/2011
			��᫥ ��������� ⠡���� comm-rate � 65�� ���� �ᯮ�짮����� ������� ������ �⠫� ����⨬����!
			*/
			NO-LOCK NO-ERROR.
		IF AVAIL bfrCommRate THEN DO:
			outValue = bfrCommRate.rate-comm.
			outValueType = (if bfrCommRate.rate-fixed then "=" else "%").
			outErrorStr = outErrorStr + "��������� �⠢��: '" + bfrCommRate.commission + "," +  
					bfrCommRate.currency + "," + STRING(bfrCommRate.since) + "," + 
					STRING(bfrCommRate.min-value) + "," + STRING(bfrCommRate.period) + "," + 
					bfrCommRate.acct + "," + STRING(bfrCommRate.rate-comm) +  "," + STRING(outValue) + "," + outValueType + "'." + CHR(10).	
			END.
		ELSE
			outErrorStr = outErrorStr + "�⠢�� �����ᨨ '" + inCommission + "' �� �������!" + CHR(10).	
		
		/** �뢮� ����������� �訡�� */
		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetCommRateEx_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
		
		RETURN outValue.

END FUNCTION.


FUNCTION GetCommRate_ULL RETURNS DECIMAL (
		INPUT inCommission AS CHAR,
		INPUT inCurrency AS CHAR,
		INPUT inMinSumma AS DECIMAL,
		INPUT inAcct AS CHAR,
		INPUT inPeriod AS INTEGER,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).

		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outValue AS DECIMAL.
		DEFINE VAR outValueType AS CHAR.
		
		outValue = GetCommRateEx_ULL(inCommission, inCurrency, inMinSumma, inAcct, inPeriod, 
		                             inDate, inShowErrorMsg, outValueType) / 100.
		
		RETURN outValue.
		
END FUNCTION.


FUNCTION GetSumRate_ULL RETURNS DECIMAL (
		INPUT inCommission AS CHAR,
		INPUT inCurrency AS CHAR,
		INPUT inSumma AS DECIMAL,
		INPUT inAcct AS CHAR,
		INPUT inPeriod AS INTEGER,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).
		
		DEFINE VAR commRate AS DECIMAL.
		DEFINE VAR outValue AS DECIMAL.
		DEFINE VAR outValueType AS CHAR.
		
		outValue = GetCommRateEx_ULL(inCommission, inCurrency, inSumma, inAcct, inPeriod, 
		                             inDate, inShowErrorMsg, outValueType).
		                             
        IF outValueType = "=" THEN 
        	RETURN outValue.
        ELSE 
        	RETURN inSumma * (outValue / 100).
			
END FUNCTION. 

FUNCTION getLoanAttr RETURNS CHARACTER(INPUT inLoanType AS CHAR,
					   INPUT inLoan AS CHAR,
					   INPUT cFormat AS CHAR):

		   /*********************************************
		    * �㭪�� �����頥� ४������ 	        *
		    * ������� � �ଠ� cFormat.	        *
		    * ��������� ������ ���� � �ଠ�           *
		    * %��������			        *
		    *********************************************
		    *					        *
		    * ����: ��᫮� �. �.		        *
		    * ���: 11:02 20.01.2011		        *
		    * ���: #607 .			        *
		    *				  	        * 
		    *********************************************/

	DEF BUFFER bfrLoan FOR loan.
	DEF VAR cTemp AS CHARACTER NO-UNDO.  /*�� ��� #1310*/

	FIND FIRST bfrLoan WHERE bfrLoan.contract = inLoanType
						       AND bfrLoan.cont-code = inLoan 
						       NO-LOCK NO-ERROR.

	IF AVAILABLE(bfrLoan) THEN 
		DO:
			cFormat = REPLACE(cFormat,"%cont-code",bfrLoan.cont-code).

                        /*�� ��� #1310*/

                        cTemp = getXAttrValue("loan",inLoanType + "," + inLoan,"PirDate4Rasp").
                        if {assigned cTemp} then cFormat = REPLACE(cFormat,"%��⠑���",cTemp).

                        /*����� ��⠢�� �� ��� #1310*/

			cFormat = REPLACE(cFormat,"%��⠑���",getXAttrValue("loan",inLoanType + "," + inLoan,"��⠑���")).			
			cFormat = REPLACE(cFormat,"%�����",getXAttrValue("loan",inLoanType + "," + inLoan,"�����")).			
			cFormat = REPLACE(cFormat,"%��⠍��",STRING(bfrLoan.open-date, "99/99/9999")).
			cFormat = REPLACE(cFormat,"%��⠎�",STRING(bfrLoan.end-date, "99/99/9999")).
			cFormat = REPLACE(cFormat,"%currency",STRING(bfrLoan.currency)).
			cFormat = REPLACE(cFormat,"%cont-type",STRING(bfrLoan.cont-type)).
		END.

	RETURN cFormat.
END FUNCTION.

FUNCTION getMainLoanAttr RETURNS CHARACTER(INPUT inLoanType AS CHAR,
					   INPUT inLoan AS CHAR,
					   INPUT cFormat AS CHAR):

	IF NUM-ENTRIES(inLoan," ") > 1 THEN inLoan=ENTRY(1,inLoan," ").
	return getLoanAttr(inLoanType,inLoan,cFormat).
END FUNCTION.

/*******************************
 * �㭪�� �����頥� ��� ������
 * � �ଠ� �ਭ�⮬ � ���.
 * ��� "�����������"
 * ����� ���� ���஢��
 *******************************/

FUNCTION getPirClName RETURNS CHARACTER (INPUT cCust-cat AS CHARACTER,INPUT cCust-id AS INT64):
  DEF VAR clName AS CHARACTER.

IF cCust-cat EQ "�" THEN DO:
 RUN name_cl.p (loan.cust-cat,
                loan.cust-id,
                INPUT-OUTPUT clName).
END. /* IF */
ELSE DO:
 RUN GetCustNameFormatted IN h_cust(loan.cust-cat,
                loan.cust-id,
                OUTPUT clName).
END. /* ELSE */

  RETURN clName.

END FUNCTION.

FUNCTION getDpsRateComm RETURNS DECIMAL(INPUT hLoan AS HANDLE,
                                        INPUT dCurrDate AS DATE,
                                        INPUT lType AS LOGICAL):
    DEF VAR vCRateRID  AS ROWID             NO-UNDO.
    DEF VAR vCommRate  AS DECIMAL   INIT ?  NO-UNDO.
    DEF VAR vAcctStr   AS CHARACTER         NO-UNDO.
    DEF VAR oResult    AS INT NO-UNDO.
    DEF VAR oError     AS INT NO-UNDO.
    DEF VAR vKau       AS CHARACTER         NO-UNDO.

    DEF BUFFER bAcct FOR acct.

    vKau = hLoan::contract + "," + hLoan::cont-code + "," + "��₪��".

    RUN GetBaseAcct IN h_dps (hLoan::contract,
                              hLoan::cont-code,
                              dCurrDate,
                              OUTPUT vAcctStr).



{find-act.i
   &bact = bAcct
   &acct = "ENTRY(1, vAcctStr)"
   &curr = "ENTRY(2, vAcctStr)"
}



RUN Calc_CommRate_1DayEx IN h_dpspr(hLoan:ROWID,
                                    bAcct.acct,
                                    bAcct.currency,
                                    vKau,
                                    TODAY,
                                    lType,
                                    OUTPUT vCRateRID,
                                    OUTPUT vCommRate).
                                    
RETURN vCommRate.

END FUNCTION.
&ENDIF