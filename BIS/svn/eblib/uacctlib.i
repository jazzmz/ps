/*
		Udgin Account Library (UAL).
		
		������⥪� �㭪権 ��� ࠡ��� � ��⠬�.
		
		���� �.�., 10.01.2006 12:24
		
		���ᠭ�� �㭪権 �믮����� � ���樨 �몠 Pascal (��� ����� ����� ����⭮ �������� ��᫨ :-(  )
		
		�� �㭪樨 �������஢���� �� ��㯯��.
			1) ����祭�� ���ଠ樨 �� ����(��)
*/

/* 

		1 ����� �㭪権. 
		�।�����祭� ��� ����祭�� ���ଠ樨 � ���
		
		���᮪:
			
			GetAcctPosValue_UAL(Acct_Number:CHAR, Currency_OUT:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			===================================================================================
			|	�����頥� ���祭�� ���⪠ �� ���� �� ���� �� ��楯�஢���� ���㬥�⠬.
			
			GetAcctClientName_UAL(Acct_Number:CHAR, ShowErrorMsg:LOGICAL): CHAR
			====================================================================
			| �����頥� �������� ������, �᫨ ��� ������᪨�.
*/

FUNCTION GetAcctPosValue_UAL RETURNS DECIMAL (
		INPUT inAcct AS CHAR,
		INPUT inCur  AS CHAR,
		INPUT inDate AS DATE,
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
				/*
				outErrorStr = "�������� ���⮪ �� ���� " + inAcct + " � ����� " + acctCur + " �� ���� " 
					+ STRING(inDate,"99/99/9999") + " ࠢ�� " + STRING(acctPos,"->>>,>>>,>>>,>>>,>>9.99") + CHR(10).
				*/
				FOR EACH bfrOpEntry WHERE
					bfrOpEntry.op-DATE GE lstSince
					AND
					bfrOpEntry.op-DATE LE inDate
					AND
					bfrOpEntry.acct-db = inAcct
					:
							IF bfrAcct.side = "�" THEN 
								IF acctCur = "810" THEN
									acctPos = acctPos + bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos + bfrOpEntry.amt-cur.
							ELSE
								IF acctCur = "810" THEN
									acctPos = acctPos - bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos - bfrOpEntry.amt-cur.
				END.
				FOR EACH bfrOpEntry WHERE
					bfrOpEntry.op-DATE GE lstSince
					AND
					bfrOpEntry.op-DATE LE inDate
					AND
				  bfrOpEntry.acct-cr = inAcct
					:
							IF bfrAcct.side = "�" THEN 
								IF acctCur = "810" THEN
									acctPos = acctPos - bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos - bfrOpEntry.amt-cur.
							ELSE
								IF acctCur = "810" THEN
									acctPos = acctPos + bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos + bfrOpEntry.amt-cur.
				END.
			END.
		ELSE
			outErrorStr = "C�� " + inAcct + " �� ������!" + CHR(10).  
		
		/* �뤠�� �訡�� �� �࠭ */
		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� uacctlib.i:GetAcctPosValue_UAL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		outValue = acctPos.
		RETURN outValue.

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
							outValue = bfrCustCorp.cust-stat + " " + bfrCustCorp.name-corp.
					END.
				IF bfrAcct.cust-cat = "�" THEN
					DO:
						FIND FIRST bfrPerson WHERE
							bfrPerson.person-id = bfrAcct.cust-id
							NO-LOCK NO-ERROR.
						IF AVAIL bfrPerson THEN
							outValue = bfrPerson.name-LAST + " " + bfrPerson.first-names.
					END.	
			END.
		ELSE
			outErrorStr = "C�� " + inAcct + " �� ������!" + CHR(10).  
			
		/* �뤠�� �訡�� �� �࠭ */
		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� uacctlib.i:GetAcctClientName_UAL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.
	  /* ����� �㭪樨 GetAcctClientName_UAL */
END FUNCTION.
