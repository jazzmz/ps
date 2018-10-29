/*
		Udgin Loan Library (ULL).
		
		������⥪� �㭪権 ��� ࠡ��� � �।��묨 � �������묨 ������ࠬ�.
		
		���� �.�., 27.12.2005 11:04
		
		���������: ���� �.�., 16.02.2006 11:52 - ���� ��楤��� 2 ࠧ����
		
		���ᠭ�� �㭪権 �믮����� � ���樨 �몠 Pascal (��� ����� ����� ����⭮ �������� ��᫨ :-(  )
		
		�� �㭪樨 �������஢���� �� ��㯯��.
			1) ����祭�� ���ଠ樨 �� �।�⭮��(�) ��������(��)
			2) ����祭�� ���ଠ樨 �� �।��� � �������� ������ࠬ, � ����ᨬ��� �� ⨯� �������, 
			   ��।�������� � ��楤���
*/

/* 

		1 ����� �㭪権. 
		�।�����祭� ��� ����祭�� ���ଠ樨 � �।�⭮� �������
		
		���᮪:
			
			GetCredLoanParamValue_ULL(Loan_Number:CHAR, Param_Code:INTEGER, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			===================================================================================
			|	�����頥� ���祭�� �㡠������᪮�� ��ࠬ��� ������� �� ����.
			|	�᫨ ������� ����� �祭��/�����, � ��楤�� ��ᬠ�ਢ��� ������, � ���祭�� ����訢������ ��ࠬ���
			|	�㬬�������.
			
			GetCredLoanCommission_ULL(Loan_Number:CHAR, Commission_Code:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			=====================================================================================
			| �����頥� ���祭�� �������� ��業⭮� �⠢�� �� �������� �� ����.
			
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

			
		2 ����� �㭪権	� 16.02.2006 11:43
		
		���᮪:
			
			GetLoanParamValue_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Param_Code:INTEGER, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			===================================================================================
			|	�����頥� ���祭�� �㡠������᪮�� ��ࠬ��� ������� �� ����.
			|	�᫨ ������� ����� �祭��/�����, � ��楤�� ��ᬠ�ਢ��� ������, � ���祭�� ����訢������ ��ࠬ���
			|	�㬬�������.
			
			GetLoanCommission_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Commission_Code:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			=====================================================================================
			| �����頥� ���祭�� �������� ��業⭮� �⠢�� �� �������� �� ����.
			
			GetDpsCommission_ULL(Loan_Number:CHAR, Commission_Type:CHAR, MinSumma:DECIMAL, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			=====================================================================================
			| �����頥� ���祭�� �������� ��業⭮� �⠢�� �� �������� �� ����
			| 
			| Commission_Type
			|	�������� ���祭��									���ᠭ��
			| -------------------									---------------------
			| "commission"												���祭�� �᭮���� �⠢��
			| "pen-commi"													���祭�� ���䭮� �⠢��
			
			GetLoanAcct_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Account_Role:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): CHAR
			=========================================================================
			| �����頥� ����� �������饣� �� ���� ��� � �������� ஫�� �� ����⥪� ��⮢ �।�⭮�� ������� 

			GetLoanInfo_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Info_Name:CHAR, ShowErrorMsg:LOGICAL): CHAR
			=========================================================================
			| �����頥� ���ଠ�� �� �।�⭮�� ��������:
			|
			| ���祭�� 							�����頥�� 
			| Info_Name							१����
			| -------------					----------------
			|	client_name						������������ ������
			|	open_date							��� ������(ॣ����樨) �������

			

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
				IF bfrLoan.since LT inDate THEN
					DO:
						outErrorStr = outErrorStr + "������� " + bfrLoan.cont-code 
								+ " �����⠭ �� ���� �������, 祬 ��� " + STRING(inDate,"99/99/9999") 
								+ ". ��ࠬ���� ������� �� ���뢠���� � ����!" + CHR(10).
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
						ELSE
							outErrorStr = outErrorStr + "���祭�� ��ࠬ��� " + STRING(inParam) + " ������� " + bfrLoan.cont-code + " �� ���� " + STRING(inDate,"99/99/9999") + " �� ��।�����!" + CHR(10).
					END.
				
		/* EACH bfrLoan */ 
		END.

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� uloanlib.i:GetCredLoanParamValue_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
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
				outErrorStr = "*** �㭪�� uloanlib.i:GetCredLoanCommission_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
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
				outErrorStr = "*** �㭪�� uloanlib.i:GetCredLoanAcct_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
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
				outErrorStr = "*** �㭪�� uloanlib.i:GetCredLoanInfo_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		outValue = "".
		RETURN outValue.

		/* ����� �㭪樨 GetCredLoanInfo_ULL */		
END FUNCTION.

/** 2 ����� �㭪権 � 16.02.2006 11:44 */

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
				NO-LOCK
			:
				IF bfrLoan.since LT inDate THEN
					DO:
						outErrorStr = outErrorStr + "������� " + bfrLoan.cont-code 
								+ " �����⠭ �� ���� �������, 祬 ��� " + STRING(inDate,"99/99/9999") 
								+ ". ��ࠬ���� ������� �� ���뢠���� � ����!" + CHR(10).
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
							DO:
							outValue = outValue + balance.
							tmpDate = bfrLoanVar.since.
							END.
						ELSE
							DO:
							outErrorStr = outErrorStr + "���祭�� ��ࠬ��� " + STRING(inParam) + " ������� " + bfrLoan.cont-code + " �� ���� " + STRING(inDate,"99/99/9999") + " �� ��।�����!" + CHR(10).
							tmpDate = bfrLoan.open-date.
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
							
					END.
				
		/* EACH bfrLoan */ 
		END.

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� uloanlib.i:GetCredLoanParamValue_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.

		/* ����� �㭪樨 GetCredLoanParamValue_ULL */		
END FUNCTION.

FUNCTION GetLoanCommission_ULL RETURNS DECIMAL (
		INPUT inLoanType AS CHAR,
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
				bfrCommRate.kau = inLoanType + "," + inLoan
				AND
				bfrCommRate.since LE inDate
				NO-LOCK NO-ERROR.
		IF AVAIL bfrCommRate THEN
			outValue = bfrCommRate.rate-comm / 100.
		ELSE
			outErrorStr = "���祭�� �����ᨨ " + inComm + " �� ���� " + STRING(inDate,"99/99/9999") + " �� �������!".

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� uloanlib.i:GetCredLoanCommission_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.

		/* ����� �㭪樨 GetCredLoanCommission_ULL */
END FUNCTION.

FUNCTION GetDpsCommission_ULL RETURN DECIMAL (
		INPUT inLoan AS CHAR,
		INPUT inTypeComm AS CHAR,
		INPUT inBalance AS DECIMAL,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).
		
		/* ��।������ ����७��� ��६����� */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DECIMAL.
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
					FIND LAST bfrCommRate WHERE
						bfrCommRate.commission = bfrSigns.code-value
						AND
						bfrCommRate.currency = bfrLoan.currency
						AND
						bfrCommRate.since LE bfrLoan.open-DATE
						AND
						bfrCommRate.min-value LE ABS(inBalance)
						AND
						bfrCommRate.period LE (bfrLoan.end-date - bfrLoan.open-date)
						AND
						(
							bfrCommRate.acct = "0"
							OR
							bfrCommRate.acct = bfrLoanAcct.acct
						)
						/*USE-INDEX comm-rate*/
						NO-LOCK NO-ERROR.
					IF AVAIL bfrCommRate THEN
						outValue = bfrCommRate.rate-comm / 100.
				END.
			END.
		END.
		RETURN outValue.
END FUNCTION.


FUNCTION GetLoanAcct_ULL RETURNS CHAR (
		INPUT inLoanType AS CHAR,
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
				bfrLoanAcct.contract = inLoanType
				AND
				bfrLoanAcct.cont-code = inLoan
				AND
				CAN-DO(inRole, bfrLoanAcct.acct-type)
				AND
				bfrLoanAcct.since LE inDate
				NO-LOCK NO-ERROR.
		IF AVAIL bfrLoanAcct THEN
			outValue = bfrLoanAcct.acct.
		ELSE
			outErrorStr = "� ����⥪� ��⮢ ������� " + inLoan + " ��� � ஫�� " 
					+ inRole + " �� ������ �� ���� " + STRING(inDate,"99/99/9999") + "!".

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� uloanlib.i:GetCredLoanAcct_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.
				
		/* ����� �㭪樨 GetCredLoanAcct_ULL */
END FUNCTION.

FUNCTION GetLoanInfo_ULL RETURNS CHAR (
		INPUT inLoanType AS CHAR,
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
			bfrLoan.contract = inLoanType
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
							bfrSigns.surrogate = bfrLoan.contract + "," + bfrLoan.cont-code
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
				outErrorStr = "*** �㭪�� uloanlib.i:GetCredLoanInfo_ULL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		outValue = "".
		RETURN outValue.

		/* ����� �㭪樨 GetCredLoanInfo_ULL */		
END FUNCTION.

			
