/**
 * ��� �� "�P��������������", 2010
 *
 * ����, � ����㯫���� �।�� �� ��� ��.
 *
 * ��窠 ����᪠: �� - ����樨 - ����樮��� ��� - ���㬥��� ��� - Ctrl+G
 */
 
{globals.i}

{ulib.i}

/** ��� ࠡ��� � ���ᠬ� */
{intrface.get instrum}

DEF INPUT PARAM iParam AS CHAR.

DEF TEMP-TABLE ttRep NO-UNDO
	FIELD id AS INT
	FIELD clientName AS CHAR
	FIELD docNum AS CHAR
	FIELD acctin AS CHAR
	FIELD amtin AS DEC
	FIELD acctpc AS CHAR
	FIELD loanpc AS CHAR
	FIELD amtpc AS DEC
	FIELD currate AS DEC
	FIELD currate-spec AS DEC
	FIELD overs AS CHAR
	FIELD amtovers AS DEC
	INDEX idx id
	.
	
DEF VAR opDate AS DATE NO-UNDO.
DEF VAR opStatusMask AS CHAR NO-UNDO.
DEF VAR acctinMask AS CHAR NO-UNDO.
DEF VAR opKindMask AS CHAR NO-UNDO.
DEF VAR opEntryCardStatusMask AS CHAR NO-UNDO.
DEF VAR acctfromMask AS CHAR NO-UNDO.
DEF VAR paramList AS CHAR NO-UNDO.
DEF VAR i AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.
DEF VAR paramId AS INT NO-UNDO.
DEF VAR tmpStr AS CHAR NO-UNDO.

DEF VAR rateCbUsd AS DECIMAL NO-UNDO.
DEF VAR rateCbEur AS DECIMAL NO-UNDO.
DEF VAR rateBuyUsd AS DECIMAL NO-UNDO.
DEF VAR rateBuyEur AS DECIMAL NO-UNDO.
DEF VAR rateSalUsd AS DECIMAL NO-UNDO.
DEF VAR rateSalEur AS DECIMAL NO-UNDO.
DEF VAR rateUsdByEur AS DECIMAL NO-UNDO.
DEF VAR rateEurByUsd AS DECIMAL NO-UNDO.

opDate = DATE(GetParamByName_ULL(iParam, "op-date", "99/99/9999", ";")) NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
	{getdate.i}
	opDate = end-date.
END.

acctinMask = GetParamByName_ULL(iParam, "acct-in-mask", "", ";").
acctfromMask = GetParamByName_ULL(iParam, "acct-from-mask", "", ";").
opKindMask = GetParamByName_ULL(iParam, "op-kind-mask", "", ";").
opEntryCardStatusMask = GetParamByName_ULL(iParam, "op-entry-card-status-mask", "", ";").
opStatusMask = GetParamByName_ULL(iParam, "op-status-mask", "*", ";").
paramList = GetParamByName_ULL(iParam, "param-list", "*", ";").


DEF BUFFER bfrOverAcct FOR loan-acct.
DEF BUFFER bfrOver FOR loan.
DEF BUFFER bfrTechOverAcct FOR loan-acct.
DEF BUFFER bfrTechOver FOR loan.
DEF BUFFER bfrAcctIn FOR loan-acct.
DEF BUFFER bfrAcctPc FOR loan-acct.
DEF BUFFER bfrOpEntry FOR op-entry.
	
i = 1.
FOR EACH op-entry WHERE op-entry.op-date = opDate
		AND CAN-DO(acctinMask, op-entry.acct-cr)
		NO-LOCK,
	FIRST op WHERE op.op = op-entry.op 
		AND CAN-DO(opKindMask, op.op-kind)
		AND CAN-DO(opStatusMask, op.op-status)
		NO-LOCK,
	FIRST bfrAcctIn WHERE bfrAcctIn.contract BEGINS "card-"
		AND	bfrAcctIn.acct = op-entry.acct-cr 
		NO-LOCK,
	FIRST loan WHERE loan.contract = bfrAcctIn.contract
		AND loan.cont-code = bfrAcctIn.cont-code
		NO-LOCK
	:
		/** ����� �஢���� �� �⭮襭�� � ����ᨭ������ 業��� ������� ���� ��।���� */
		tmpStr = GetXAttrValueEx("op-entry", STRING(op-entry.op) + "," + STRING(op-entry.op-entry), "CardStatus", "").
		IF NOT CAN-DO(opEntryCardStatusMask, tmpStr) THEN NEXT.
		
		/** �।�⢠ ������ �ਤ� � ��।������� ��⮢ */
		FIND FIRST bfrOpEntry WHERE bfrOpEntry.op = op-entry.op
			AND bfrOpEntry.acct-db <> ?
			AND bfrOpEntry.op-entry <= op-entry.op-entry
			AND CAN-DO(acctfromMask, bfrOpEntry.acct-db)
			NO-LOCK NO-ERROR.
		IF NOT AVAIL bfrOpEntry THEN NEXT.
		
		CREATE ttRep.
		ttRep.id = i.
		ttRep.clientName = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", false).
		ttRep.docNum = op.doc-num.
		ttRep.acctin = op-entry.acct-cr.
		ttRep.amtin = (IF op-entry.currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur).
		ttRep.loanpc = loan.cont-code.
		
		/** 
		 * �᫨ �।�⢠ ����㯨�� �� ���, ����� �� ���� "�᭮���"
		 */
		IF loan.currency <> bfrAcctIn.currency THEN DO:
			FIND LAST bfrAcctPc WHERE bfrAcctPc.contract = loan.contract
				AND bfrAcctPc.cont-code = loan.cont-code
				AND bfrAcctPc.acct-type = "SCS@" + loan.currency
				AND bfrAcctPc.since <= opDate
				NO-LOCK NO-ERROR.
			IF AVAIL bfrAcctPc THEN DO:
				ttRep.acctpc = bfrAcctPc.acct.

				/** 810 -> 840(978) */
				IF bfrAcctIn.currency = "" THEN DO:
					ttRep.currate = FindRateTime("�������", bfrAcctPc.currency, "0000", opDate, TIME, ?).
					ttRep.currate-spec = ROUND(ttRep.currate * (1 + 0.005), 4).
					ttRep.amtpc = ROUND(ttRep.amtin / ttRep.currate-spec, 2).
				END.
				
				/** 840(978) -> 810 */
				IF bfrAcctPc.currency = "" THEN DO:
					ttRep.currate = FindRateTime("�������", bfrAcctIn.currency, "0000", opDate, TIME, ?).
					ttRep.currate-spec = ROUND(ttRep.currate * (1 - 0.005), 4).
					ttRep.amtpc = ROUND(ttRep.amtin * ttRep.currate-spec, 2).
				END.
				
				/** 840(978) -> 978(840) */
				IF bfrAcctIn.currency <> "" AND bfrAcctPc.currency <> "" THEN DO:
					ttRep.currate = FindRateTime("�������", bfrAcctIn.currency, "0000", opDate, TIME, ?).
					ttRep.currate-spec = ROUND(ttRep.currate * (1 - 0.005), 4).
					ttRep.currate = FindRateTime("�������", bfrAcctPc.currency, "0000", opDate, TIME, ?).
					ttRep.currate-spec = ROUND(ttRep.currate-spec / ROUND(ttRep.currate * (1 + 0.005), 4), 4).
					ttRep.amtpc = ROUND(ttRep.amtin * ttRep.currate-spec, 2).
				END.

			END.
		END. ELSE DO:
			ttRep.acctpc = ttRep.acctin.
		END.
		
		/** ���� ������襭���� �孨�᪮�� ������� � ������ */
		FOR EACH bfrTechOverAcct WHERE
				bfrTechOverAcct.contract = "�।��" AND
				bfrTechOverAcct.cont-code BEGINS "��" AND
				bfrTechOverAcct.acct-type = "�।����" AND
				bfrTechOverAcct.acct = ttRep.acctpc
				NO-LOCK, 
			FIRST bfrTechOver WHERE
				bfrTechOver.contract = bfrTechOverAcct.contract AND
				bfrTechOver.cont-code = bfrTechOverAcct.cont-code AND
				bfrTechOver.close-date = ? 
				NO-LOCK
			:
				ttRep.overs = bfrTechOver.cont-code.
				
				/** �㬬� ������������ �� ��.�������� */
				ttRep.amtovers = 0.
				DO j = 1 TO NUM-ENTRIES(paramList) :
					/** ��������㥬 ��� ��ࠬ��� � ���� � �᫨ �� "��", � �㬬��㥬 */
					paramId = INT(ENTRY(j, paramList)) NO-ERROR.
					IF NOT ERROR-STATUS:ERROR THEN DO: 
						ttRep.amtovers = ttRep.amtovers +
							GetLoanParamValue_ULL(bfrTechOver.contract,
							bfrTechOver.cont-code, paramId, opDate, false).
					END.
				END.
		END.
		
		/** ���� ������襭���� ������� � ������ */
		FOR EACH bfrOverAcct WHERE
				bfrOverAcct.contract = "�।��" AND
				bfrOverAcct.cont-code BEGINS "��" AND
				bfrOverAcct.acct-type = "�।����" AND
				bfrOverAcct.acct = ttRep.acctpc
				NO-LOCK, 
			FIRST bfrOver WHERE
				bfrOver.contract = bfrOverAcct.contract AND
				bfrOver.cont-code = bfrOverAcct.cont-code AND
				bfrOver.close-date = ? 
				NO-LOCK
			:
				DO j = 1 TO NUM-ENTRIES(paramList) :
					/** ��������㥬 ��� ��ࠬ��� � ���� � �᫨ �� "��", � �㬬��㥬 */
					paramId = INT(ENTRY(j, paramList)) NO-ERROR.
					IF NOT ERROR-STATUS:ERROR THEN DO: 
						ttRep.amtovers = ttRep.amtovers +
							GetLoanParamValue_ULL(bfrOver.contract,
							bfrOver.cont-code, paramId, opDate, false).
					END.
				END.
				ttRep.overs = TRIM(ttRep.overs + " " + bfrOver.cont-code).
		END.

		i = i + 1.
END.

rateCbUsd = FindRateTime("�������", "840", "0000", opDate, TIME, ?).
rateSalUsd = ROUND(rateCbUsd * (1 + 0.005), 4).
rateBuyUsd = ROUND(rateCbUsd * (1 - 0.005), 4).
rateCbEur = FindRateTime("�������", "978", "0000", opDate, TIME, ?).
rateSalEur = ROUND(rateCbEur * (1 + 0.005), 4).
rateBuyEur = ROUND(rateCbEur * (1 - 0.005), 4).
rateUsdByEur = ROUND(rateCbUsd / rateCbEur, 4).
rateEurByUsd = ROUND(rateCbEur / rateCbUsd, 4).

{setdest.i}

PUT UNFORMATTED
SPACE(20) "����� �� ���������� ���.������� �� ����� �� �� " STRING(opDate) SKIP(1).

PUT UNFORMATTED
"����: " STRING(TODAY, "99/99/9999") ", �����: " STRING(TIME, "HH:MM:SS") SKIP
SPACE(70) " ����       ��      ������� ������� �����.��" SKIP
SPACE(70) " USD        " STRING(rateCbUsd,">9.9999") " " 
						 STRING(rateBuyUsd, ">9.9999") " " 
						 STRING(rateSalUsd, ">9.9999") " "
						 STRING(rateUsdByEur, ">9.9999") SKIP
SPACE(70) " EUR        " STRING(rateCbEur,">9.9999") " " 
						 STRING(rateBuyEur, ">9.9999") " " 
						 STRING(rateSalEur, ">9.9999") " "
						 STRING(rateEurByUsd, ">9.9999") SKIP(1).


PUT UNFORMATTED
		"N �/�" " "
		"�����" FORMAT "x(6)" " "
		"���������" FORMAT "x(30)" " "
		"����� �����" FORMAT "x(20)" " "
		"����� ����������" FORMAT "x(14)" " "
		"����� ����� ��" FORMAT "x(20)" " "
		"������� ��" FORMAT "x(15)" " "
		"����� ���������" FORMAT "x(14)" " "
		"���������" FORMAT "x(40)" " "
		"�������.����." FORMAT "x(14)" " " SKIP.

i = 1.
FOR EACH ttRep NO-LOCK:
	PUT UNFORMATTED 
		STRING(i, ">>>>9") " "
	 	ttRep.docNum FORMAT "x(6)" " "
	 	ttRep.clientName FORMAT "x(30)" " "
	 	ttRep.acctin FORMAT "x(20)" " "
	 	ttRep.amtin FORMAT ">>>,>>>,>>9.99" " "
	 	ttRep.acctpc FORMAT "x(20)" " "
	 	ttRep.loanpc FORMAT "x(15)" " "
	 	ttRep.amtpc FORMAT ">>>,>>>,>>9.99" " "
	 	ttRep.overs FORMAT "x(40)" " "
	 	ttRep.amtovers FORMAT ">>>,>>>,>>9.99" " "
	 	SKIP.
	 	i = i + 1.
END.

PUT UNFORMATTED " " SKIP
"���⠢�⥫�: " + GetUserInfo_ULL(USER, "fio", false) SKIP.

{preview.i}
  