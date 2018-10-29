/** 
	����� ᢮����� �ᯮ�殮��� �� �������� ������ࠬ 
	���� �.�.
	19.05.2006 9:24
*/

/**
	pirdps114.p - �ନ஢���� �ᯮ�殮��� � ���᫥��� ��業⮢
	�� �������� � ������ ������ � ���᫥���� ��業⮢ � �裡 �
	����砭��� �ப�.
*/

DEF INPUT PARAM iParam AS CHAR.

{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

/** ��� �ᯮ�殮��� */
DEF VAR docDate AS DATE LABEL "��� �ᯮ�殮���".
/** ��ਮ� ���� ��業⮢ */
DEF VAR periodBegin AS DATE  NO-UNDO.
DEF VAR periodEnd AS DATE  NO-UNDO.
/** ���� �����ਮ��� */
DEF VAR subperBegin AS DATE NO-UNDO.
DEF VAR subperEnd AS DATE NO-UNDO.
DEF VAR subperDays AS INTEGER NO-UNDO.

/** ����� ������⭮�� ��� */
DEF VAR dpsAcct AS CHAR NO-UNDO.
/** ����� ��� ��� %% */
DEF VAR PrAcct AS CHAR NO-UNDO.
/** ����� ��� �� ��室�� ����� �� �믫��� %% */
DEF VAR outcomeacct AS CHAR NO-UNDO.

/** ������� �� �������� */
DEF VAR comm AS DECIMAL NO-UNDO.
DEF VAR newComm AS DECIMAL NO-UNDO.
/** ���⮪ �� ���� */
DEF VAR amount AS DECIMAL NO-UNDO.
DEF VAR newAmount AS DECIMAL NO-UNDO.
/** �㬬� ��業⮢ �� ��ਮ� */
DEF VAR persAmount AS DECIMAL NO-UNDO.
/** ���� �㬬� ��業⮢ */
DEF VAR totalPersAmount AS DECIMAL NO-UNDO.
DEF VAR totalPersAmountStr AS CHAR EXTENT 2 NO-UNDO.
/** ����� */
DEF VAR iDate AS DATE NO-UNDO.
DEF VAR i AS INTEGER NO-UNDO.
DEF VAR j AS INTEGER INITIAL 0 NO-UNDO.
/** ���-�� ���� � ������쭮� ��ਮ�� */
DEF VAR globDays AS INTEGER INITIAL 365 NO-UNDO.
/** ������ ��業⮢ */
DEF VAR persTable AS CHAR NO-UNDO.
/** ����� SKIP */
DEF VAR cr AS CHAR NO-UNDO.
cr = CHR(10).
/** �६����� */
DEF VAR tmpStr AS CHAR EXTENT 10 NO-UNDO.

/** �믫�� � ���� �ப� */
/*DEF VAR payOutFlag AS LOGICAL INITIAL FALSE.*/

/** ��७�� ��ப */
{wordwrap.def}

/** �������� ��।������ */
{globals.i}

/** ������⥪� �㭪権 ࠡ��� � ������ࠬ� */
{ulib.i}

def var cur_year as integer NO-UNDO.
/** ��� */
DEF VAR pirbosdps AS CHAR NO-UNDO.
pirbosdps = FGetSetting("PIRboss","PIRbosdps","").
DEF VAR pirboskzn AS CHAR NO-UNDO.
pirboskzn = FGetSetting("PIRboss", "PIRbosKazna","").

DEF VAR fioSpecDPS AS CHAR NO-UNDO. /** ���樠���� �⤥�� ��� */
fioSpecDPS = ENTRY(1, iParam).

/***********************************************/
/*** ����� #1327                                   ***/

{intrface.get count}

DEF VAR oSysClass1	    AS TSysClass NO-UNDO.
DEF VAR curr-user-id        AS CHARACTER NO-UNDO.
DEF VAR curr-user-inspector AS CHARACTER NO-UNDO.

curr-user-id = USERID("bisquit").
curr-user-inspector = '02050MEM'.
DEF VAR oEra    AS TEra                        NO-UNDO.
DEF VAR oConfig AS TAArray                     NO-UNDO.
DEF VAR taxon   AS CHAR    INIT "fin ved acct" NO-UNDO.

{pir-c2346u.i}

/**************************************************/

{getdate.i}
ASSIGN docDate = end-date.
{getdates.i}
{get-bankname.i}
{setdest.i}

/** 
	����� ⠡���� 
*/
		
/** ��ନ�㥬 �ᯮ�殮��� */
		
PUT UNFORMATTED SPACE(70) "� �����⠬��� 3" SKIP
SPACE(70) cBankName SKIP(2)
SPACE(70) '���: ' docDate FORMAT "99/99/9999" SKIP(4)
SPACE(45) '� � � � � � � � � � � �' SKIP(3).

persTable = "                 ��������� ������� ��������� ��  " +  MONTH_NAMES[MONTH(end-date)] + ' ' + STRING(YEAR(end-date)) + ' �.'  +  cr
	+ "�����������������������������������������������������������������������������������������������������������������������Ŀ" + cr
	+ "� ���⮪          �   ������ ��ਮ�  � ���-�� � �⠢�� � ���᫥��        �       ���         �       ���         �" + cr
	+ "� �� ���         ���������������������Ĵ ����   �        � ��業⮢        �     �� ������      �     �� �।���     �" + cr
	+ "�                  �     �    �    ��    �        �        �                  �                    �                    �" + cr
	+ "�����������������������������������������������������������������������������������������������������������������������Ĵ" + cr.


/** 
	����� ⥪�⮢�� 
*/

tmpStr[1] = '� ᮮ⢥��⢨� � ���������� ����� ���ᨨ �39-� �� 26.06.1998�. ���᫨�� ' +
		'��業�� �� ���⮪ �� ���� ������᪮�� ������ ᮣ��᭮ ��������:'.

/** 
	�뢮� 蠯�� ⥪�⮢�� 
*/

{wordwrap.i &s=tmpStr &n=10 &l=120}
		
tmpStr[1] = '   ' + tmpStr[1].
DO i = 1 TO 10 :
	IF tmpStr[i] <> "" THEN
		PUT UNFORMATTED tmpStr[i] SKIP.
END.
PUT UNFORMATTED "" SKIP(1).



/** ���� ��࠭��� ������஢ */
FOR EACH tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK
	:
		ASSIGN
			totalPersAmount = 0.
			periodBegin = beg-date.	
		IF (periodBegin <= loan.open-date) THEN periodBegin = loan.open-date + 1.
		periodEnd = end-date.
		IF(periodEnd > loan.end-date) THEN periodEnd = loan.end-date.
		
		cur_year = YEAR(periodEnd).
		if TRUNCATE(cur_year / 4,0) = cur_year / 4 then
			globDays = 366.
		else
			globDays = 365.
			
			
		/*
		payOutFlag = FALSE.
		IF(periodEnd = loan.end-date) THEN payOutFlag = TRUE.
		*/
		
		
		/** ���� ������⭮�� ��� */
		dpsAcct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "�����", periodBegin - 1, false).
		
		/** ���� ��� �� ����� %% */
		prAcct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "����", periodBegin - 1, false).
		
		/** ���� ���⭮�� �� ����� %% */
		outcomeacct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "������", periodBegin - 1, false).
		
		
		/** ��業⭠� �⠢�� */
		comm = GetLoanCommission_ULL(loan.contract, loan.cont-code, "%���", periodBegin - 1, false).
		/** ���⮪ ������ */
		amount = ABS(GetAcctPosValue_UAL(dpsAcct, loan.currency, periodBegin - 1, false)).
		/** �����ਮ� ࠢ�� �ᥬ� ��ਮ�� */
		ASSIGN 
			subperBegin = periodBegin
			subperEnd = periodEnd.
		
		/** 
			������塞 � ⠡���� ���ଠ�� � �������
		*/
		persTable = persTable + 	
				"���� �" + GetLoanAcct_ULL(loan.contract, loan.cont-code, "�����", periodEnd - 1, false) + "                                                                                             �" + cr +
				"�" + STRING(GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", FALSE),"x(119)") + "�" + cr + 
				"����. �" + STRING(loan.cont-code, "x(11)") + " �� " + STRING(loan.open-date,"99/99/9999") +
				"                                                                                        �" + cr +
				"�����������������������������������������������������������������������������������������������������������������������Ĵ" + cr.             
		
		/** 
			�᭮���� 横� �ନ஢���� ⠡���� ���᫥��� ��業⮢.
			�஡����� �� ������� ���, � ��।��塞, ���������� �� ��業⭠� �⠢�� ��� ���⮪.
			�᫨ ��������� �뫨 � 㪠����� ����, � ࠧ������ ��騩 ��ਮ� �� �����ਮ��.
		*/
		DO iDate = periodBegin TO periodEnd - 1 :
 	 	        dpsAcct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "�����", iDate, false).
			newAmount = ABS(GetAcctPosValue_UAL(dpsAcct, loan.currency, iDate, false)).
			newComm = GetLoanCommission_ULL(loan.contract, loan.cont-code, "%���", iDate, false).
			IF (newAmount <> amount) OR (newComm <> comm) OR (DAY(iDate + 1) = 1) THEN DO:
				
				
				/*FIND FIRST op-entry  WHERE 	op-entry.acct-cr = prAcct AND op-entry.op-date = iDate NO-LOCK NO-ERROR .
				IF AVAIL op-entry THEN
				DO:
					outcomeacct = op-entry.acct-db .
				END.*/
				
				
				subperEnd = iDate.
				subperDays = subperEnd - subperBegin + 1.
				persAmount = ROUND(amount * comm / globDays * subperDays,2).
				persTable = persTable + 
					"�" + STRING(amount,">>>,>>>,>>>,>>9.99") +
					"�" + STRING(subperBegin,"99/99/9999") +
					"�" + STRING(subperEnd, "99/99/9999") +
					"�" + STRING(subperDays, ">>>>>>>>") +
					"�" + STRING(comm * 100,">>>>9.99") +
					"�" + STRING(persAmount,">>>,>>>,>>>,>>9.99") +
					"�" + STRING(outcomeacct) +
					"�" + STRING(pracct) +

					"�" + cr.
				totalPersAmount = totalPersAmount + persAmount.
				amount = newAmount.
				comm = newComm.
				subperBegin = iDate + 1.
				subperEnd = periodEnd.
			END.
		END.
		
		/** ��ࠡ�⠥� ��᫥���� �����ਮ� */
		subperDays = subperEnd - subperBegin + 1.
		persAmount = ROUND(amount * comm / globDays * subperDays,2).
		persTable = persTable + 
			"�" + STRING(amount,">>>,>>>,>>>,>>9.99") +
			"�" + STRING(subperBegin,"99/99/9999") +
			"�" + STRING(subperEnd, "99/99/9999") +
			"�" + STRING(subperDays, ">>>>>>>>") +
			"�" + STRING(comm * 100,">>>>9.99") +
			"�" + STRING(persAmount,">>>,>>>,>>>,>>9.99") +
			"�" + STRING(outcomeacct) +
			"�" + STRING(pracct) +			
			"�" + cr.
		totalPersAmount = totalPersAmount + persAmount.
		
		/** 
			�⮣� ⠡���� �� ����
		*/
		persTable = persTable + "�����������������������������������������������������������������������������������������������������������������������Ĵ" + cr
			 	                  + "��⮣� �� �/���� " + dpsAcct + "                                                                " + STRING(totalPersAmount,">>>,>>>,>>>,>>9.99") + "�" + cr +
			                    	"�����������������������������������������������������������������������������������������������������������������������Ĵ" + cr.             

		
		/** 
			������塞 ⥪�⮢�� ��� ⥪�饣� ������� 
		*/
		
		Run x-amtstr.p(totalPersAmount, loan.currency, true, true, 
				output totalPersAmountStr[1], 
				output totalPersAmountStr[2]).
	  totalPersAmountStr[1] = totalPersAmountStr[1] + ' ' + totalPersAmountStr[2].
		Substr(totalPersAmountStr[1],1,1) = Caps(Substr(totalPersAmountStr[1],1,1)).
		
		j = j + 1.
		tmpStr[1] = STRING(j) + ") " + GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", FALSE) + 
			" �� �������� ������᪮�� ������ �" + loan.cont-code + 
			" �� " + STRING(loan.open-date, "99/99/9999") + " � ࠧ��� " + STRING(ROUND(totalPersAmount,2)) + " (" +
			totalPersAmountStr[1] + ").".
		
		
		/** 
			�뢮��� ⥪�⮢�� �� �������� 
		
		{wordwrap.i &s=tmpStr &n=10 &l=80}
		
		DO i = 1 TO 10 :
			IF tmpStr[i] <> "" THEN
				PUT UNFORMATTED tmpStr[i] SKIP.
		END.
		PUT UNFORMATTED "" SKIP(1).

		*/
		
END.

persTable = persTable + "�������������������������������������������������������������������������������������������������������������������������" + cr.



/** 
	�뢮� ⠡���� ���� ��業⮢ 
*/

PUT UNFORMATTED "" SKIP(3) persTable SKIP(4).
		
PUT UNFORMATTED ENTRY(1,pirbosdps) SPACE(80 - LENGTH(ENTRY(1,pirbosdps))) ENTRY(2,pirbosdps) SKIP(1).
				
PUT UNFORMATTED ENTRY(1,pirboskzn) SPACE(80 - LENGTH(ENTRY(1,pirboskzn))) ENTRY(2,pirboskzn) SKIP(1).

if fioSpecDPS <> "" then
				PUT UNFORMATTED '����騩 ᯥ樠���� ������⭮�� �⤥��: ' SPACE(80 - LENGTH('����騩 ᯥ樠���� ������⭮�� �⤥��: ')) fioSpecDPS SKIP.
		

{preview.i}

/***********************************************/
/***  ����� #1327                           ***/

oConfig = new TAArray().
oConfig:setH("taxon",taxon).
oConfig:setH("opdate",TEra:getDate(docDate)). /* # 2798 */
oConfig:setH("num",iCurrOut).
oConfig:setH("expn",iCurrOut).
oConfig:setH("author",USERID("bisquit")).
oConfig:setH("inspector",curr-user-inspector).
oConfig:setH("fext","txt").
oEra = new TEra(TRUE).
 oEra:askAndSave(oConfig,"_spool.tmp").
DELETE OBJECT oEra.
DELETE OBJECT oConfig.















