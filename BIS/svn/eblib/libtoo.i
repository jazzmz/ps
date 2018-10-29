/* 
	 ����

*/

/** �����㦠�� �㭪樨 ��� ࠡ��� � ��⠬�. */
{intrface.get date}

/** �।��।������, �⮡� � ᠬ�� ������⥪� ����� �뫮 �ᯮ�짮���� �㭪樨 */
FUNCTION GetDpsCommission_ULL RETURN DECIMAL (INPUT inLoan AS CHAR,	INPUT inTypeComm AS CHAR,	INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL) FORWARD.


/** ��������� */

FUNCTION StrToWin_ULL RETURNS CHARACTER (INPUT arg1 AS CHARACTER).
/* �室: arg1:��ப�
** ��室: ��ப� � ����஢�� windows-1251
*/
	RETURN CODEPAGE-CONVERT(arg1,"1251",SESSION:CHARSET).
END FUNCTION.

FUNCTION GetAcctPosValue_UAL2 RETURNS DECIMAL (
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
		DEFINE BUFFER bfrOp      FOR op.
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
					:
					 FIND FIRST bfrOp of bfrOpEntry no-lock no-error.
					 FIND FIRST tmprecid where RECID(bfrOp) eq tmprecid.id no-lock no-error.
					 IF avail tmprecid or bfrOpEntry.op-status GT "��" then 
					 DO:
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
				END.
				
				outErrorStr = outErrorStr + "��������� �㬬� �஢���� �� ������ �� ���� � ���������� ���� " + inAcct + " � ����� " + acctCur + " �� ���� " 
					+ STRING(inDate,"99/99/9999") + " �������� ���⮪ �� ���祭�� " + STRING(acctPos,"->>>,>>>,>>>,>>>,>>9.99") + CHR(10).

				FOR EACH bfrOpEntry WHERE
					bfrOpEntry.op-DATE GE lstSince
					AND
					bfrOpEntry.op-DATE LE inDate
					AND
				  bfrOpEntry.acct-cr = inAcct
				  :
					 FIND FIRST bfrOp of bfrOpEntry no-lock no-error.
					 FIND FIRST tmprecid where RECID(bfrOp) eq tmprecid.id no-lock no-error.
					 IF avail tmprecid or bfrOpEntry.op-status GT "��" then
					 DO:
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
				END.

				outErrorStr = outErrorStr + "��������� �㬬� �஢���� �� �।��� �� ���� � ���������� ���� " + inAcct + " � ����� " + acctCur + " �� ���� " 
					+ STRING(inDate,"99/99/9999") + " �������� ���⮪ �� ���祭�� " + STRING(acctPos,"->>>,>>>,>>>,>>>,>>9.99") + CHR(10).

			END.
		ELSE
			outErrorStr = "C�� " + inAcct + " �� ������!" + CHR(10).  
		
		/* �뤠�� �訡�� �� �࠭ */
		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** �㭪�� ulib.i:GetAcctPosValue_UAL ᮮ�頥� ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		outValue = acctPos.
		RETURN outValue.

		/* ����� �㭪樨 GetAcctPosValue_UAL2 */		
		END FUNCTION.
		
