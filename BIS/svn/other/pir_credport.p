{pirsavelog.p}

/** 
		��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007

		<��_������_��楤��> : ��ନ��� ���� "��������� �������� � ������� �����.
		
		<����> : ���� �.�., <�६�_ᮧ����� [F7]> : 18.06.2007 9:33
		
		<���_����᪠����> : ����᪠���� �� ��㧥� �।���� ������஢
		<��ࠬ���� ����᪠>
		<���_ࠡ�⠥�> : ��ࠡ��뢠�� ��࠭�� � ��㧥� �������. ����訢��� � ���짮��⥫� 
		                 ����, �� ���ﭨ� �� ������ �������� ���祭�� ��ࠬ��஢ ������஢. �� ������ 
		                 ����᪠ ��楤���, ������� ������ ���� ���⠭� �� ���� �ନ஢���� ����.
		                 ���砫� ��楤�� ��� ��� ��࠭��� � ��㧥� ������஢ �������� ����� 
		                 �६����� ⠡���� (��). �� �� �������� �믮�����
		                 ���஢�� � ��㯯�஢�� ������ �� �ନ஢���� �⮣����� ����.
		<�ᮡ������_ॠ����樨>
		
		��������: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>)
		          <���ᠭ�� ���������>

		��������: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>)
		          <���ᠭ�� ���������>

*/

/** �������� ��।������ */
{globals.i}

/** �ᯮ��㥬 ���ଠ�� �� ��㧥� �१ TEMP-TABLE tmprecid */
{tmprecid.def}

/** ��� ��楄�ન */
{ulib.i}

/** �㤥� ��७���� �� ᫮��� */
{wordwrap.def}

/** ����������� ���������� � ������ ������� */

/** ��।������ �������� �६����� ⠡����, � ������ �㤥� ��࠭��� ����� ��� ��᫥���饣� �� �뢮��. */
DEF TEMP-TABLE ttReportLine NO-UNDO
	FIELD id AS INTEGER /* �����䨪��� */
	FIELD part AS INTEGER /* ࠧ��� ���� */
	FIELD subPart AS CHAR /* ���ࠧ���: ����窠 ��� �����.��� ���� ������ */
	FIELD clientCat AS CHAR /* ��⥣��� ������ */
	FIELD clientID AS INTEGER /* �����䨪��� ������ */
	FIELD clientName AS CHAR EXTENT 4 /* ������������ ������ */
	FIELD loanNumber AS CHAR /* ����� ������� */
	FIELD loanCurrency AS CHAR /* ����� ������� */
	FIELD loanOpenDate AS DATE /* ��� ������ ������� */
	FIELD loanEndDate AS DATE /* ��� ����砭�� ������� */
	FIELD loanAmount AS DECIMAL /* ���⮪ ������������ */
	FIELD rate AS DECIMAL /* ��業⭠� �⠢�� �� �㬬� */
	FIELD rateOutOrder AS CHAR /* ���冷� �믫��� ��業⮢ */
	FIELD guarantyInfo AS CHAR EXTENT 4 /* ���ଠ�� � ��࠭��� */
	INDEX id IS UNIQUE id
	INDEX main loanCurrency clientCat part subPart.

/** ����� */
DEF VAR i AS INTEGER NO-UNDO.

DEF VAR tmpStr AS CHAR NO-UNDO.

DEF VAR repDate AS DATE NO-UNDO.

DEF VAR total AS DECIMAL NO-UNDO.
DEF VAR partTotal AS DECIMAL NO-UNDO.
DEF VAR subPartTotal AS DECIMAL NO-UNDO.

/** ������������ ࠧ����� */
DEF VAR partName AS CHAR EXTENT 3 INITIAL ["������� ����������� �����", "������� ���������� ���", "(�� ��।����)"]	 NO-UNDO.


/** ���������� */

/** ����訢��� � ���짮��⥫� ���� ���� */
{getdate.i}
repDate = end-date.

/** ���������� �६����� ⠡���� */
i = 1.
FOR EACH tmprecid NO-LOCK,
    FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK,
    LAST loan-cond WHERE loan-cond.contract = loan.contract 
                         AND 
                         loan-cond.cont-code = loan.cont-code 
                         AND
                         loan-cond.since LE repDate
                         NO-LOCK                         
  :
  	CREATE ttReportLine.
  	ttReportLine.id = i. i = i + 1.
  	/** �ਪ� � ���� ࠧ���, 䨧��� - �� ��ன, �� ��⠫�� - � ��⨩ */
  	IF loan.cust-cat = "�" THEN ttReportLine.part = 1.
  	ELSE IF loan.cust-cat = "�" THEN ttReportLine.part = 2.
  	ELSE ttReportLine.part = 3.
  	
  	
  	ttReportLine.clientCat = loan.cust-cat.
  	ttReportLine.clientID = loan.cust-id.
  	tmpStr = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name,open_date,end_date", false).
  	ttReportLine.clientName[1] = ENTRY(1, tmpStr).
  	ttReportLine.loanNumber = loan.cont-code.
  	ttReportLine.loanOpenDate = DATE(ENTRY(2, tmpStr)).
  	ttReportLine.loanEndDate = DATE(ENTRY(3, tmpStr)).
  	ttReportLine.loanAmount = ABS(GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, repDate, false)) 
  				+ ABS(GetLoanParamValue_ULL(loan.contract, loan.cont-code, 7, repDate, false)).
  	ttReportLine.loanCurrency = (IF loan.currency = "" THEN "810" ELSE loan.currency).
  	ttReportLine.rate = GetLoanCommissionEx_ULL(loan.contract, loan.cont-code, "%�।", repDate, false, tmpStr).

  	/** ���ࠧ��� ����� ������ ��� ⨯� ���祭��: ����祭� - �᫨ ��� ����砭�� ���. ����� ���� ����,
  	    ����� � ��� �ப� ����砭�� ������� - �᫨ ������� ����稢����� � ���饬 */
  	IF repDate > ttReportLine.loanEndDate THEN 
  		ttReportLine.subPart = " ����窠".
  	ELSE
  		ttReportLine.subPart = STRING(YEAR(ttReportLine.loanEndDate)) + "." + STRING(MONTH(ttReportLine.loanEndDate), "99").
  	
  	ttReportLine.rateOutOrder = loan-cond.int-period.
  	
  	/** ���ଠ�� � �����⥫��⢥ */
		FOR EACH term-obl WHERE
			term-obl.contract = loan.contract
			AND
			term-obl.cont-code = loan.cont-code
			AND
			term-obl.idnt = 5 
			NO-LOCK
			:
			tmpStr = loan.contract + "," + loan.cont-code + "," + STRING(term-obl.idnt) + "," + 
				STRING(term-obl.end-date) + "," + STRING(term-obl.nn).
			
			/** 
			 * ��ଠ� ���祭�� � ����� ���ᨢ� backLoans: 
			 * <�������� ���� ���ᯥ祭��>,<����� ���. ���ᯥ祭��> 
			 */
			
			FIND FIRST code WHERE code.class = "��������" 
				AND code.code = GetXAttrValueEx("term-obl",tmpStr,"��������","") NO-LOCK NO-ERROR.
			IF AVAIL code THEN DO:
						ttReportLine.guarantyInfo[1] = code.name + ",".
			END.
			
			ttReportLine.guarantyInfo[1] = ttReportLine.guarantyInfo[1] + "�" + GetXAttrValueEx("term-obl",tmpStr,"��������","") + " �� " 
				+ GetXAttrValueEx("term-obl",tmpStr,"��⠏���","") + " (".
			
			ttReportLine.guarantyInfo[1] = ttReportLine.guarantyInfo[1] + STRING(term-obl.amt) + ")".
		END.
  	
  	
END.


/** �ନ஢���� ���� */
/** ����������� ������ ������ */
{setdest.i}

FOR EACH ttReportLine NO-LOCK BREAK BY ttReportLine.loanCurrency 
																		BY ttReportLine.part
																		BY ttReportLine.subPart
	:
		IF FIRST-OF(ttReportLine.loanCurrency) THEN 
			PUT UNFORMATTED "" SKIP(1) "��������� �������� � (" ttReportLine.loanCurrency ")" SKIP
			                "(�� ���ﭨ� �� " STRING(repDate, "99.99.9999") ")" SKIP(1)
			                "���������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
			                "�����騪             �� � ��� �������             ����⮪           ����      �%     ����盧���ᯥ祭��                             �" SKIP
			                "�                    �                              �������������     �������  ��⠢����믫 �                                        �" SKIP
			                "�                    �                              ��� �।���        ��।��   �      ���� �                                        �" SKIP
			                "���������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
			
		
		IF FIRST-OF(ttReportLine.subPart) THEN DO:
			IF FIRST-OF(ttReportLine.part) THEN
				PUT UNFORMATTED 
					"�" STRING(STRING(ttReportLine.part) + ". " + partName[ttReportLine.part],"x(135)") "�" SKIP
					"���������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
			ELSE		
				PUT UNFORMATTED 
					"���������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP.
		END.

		/** ��७�ᨬ �� ᫮��� */
		{wordwrap.i &s=ttReportLine.clientName &l=20 &n=4}
		{wordwrap.i &s=ttReportLine.guarantyInfo &l=40 &n=4}
			
		PUT UNFORMATTED 
			"�" ttReportLine.clientName[1] FORMAT "x(20)" "�"
			STRING(ttReportLine.loanNumber + " �� " + STRING(ttReportLine.loanOpenDate,"99.99.9999"), "x(30)") "�"
			STRING(ttReportLine.loanAmount, ">>>,>>>,>>>,>>9.99") "�"
			STRING(ttReportLine.loanEndDate, "99.99.9999") "�"
			STRING(ttReportLine.rate, ">>9.99") "�"
			STRING(ttReportLine.rateOutOrder, "x(5)") "�"
			STRING(ttReportLine.guarantyInfo[1], "x(40)") "�" 
			SKIP.
			
		/** �뢮� �������⥫��� ��ப, �᫨ �㦭� */
		DO i = 2 TO 4 :
		
			IF ttReportLine.clientName[i] <> "" OR ttReportLine.guarantyInfo[i] <> "" THEN DO:
				
				PUT UNFORMATTED 
					"�" ttReportLine.clientName[i] FORMAT "x(20)" "�"
					SPACE(30) "�"
					SPACE(18) "�"
					SPACE(10) "�"
					SPACE(6)  "�"
					SPACE(5)  "�"
					STRING(ttReportLine.guarantyInfo[i], "x(40)") "�"
					SKIP.
				
			END.
		
		END.

		/** �⮣� ���ࠧ���� */
		subPartTotal = subPartTotal + ttReportLine.loanAmount.
		
		IF LAST-OF(ttReportLine.subPart) THEN DO:
			PUT UNFORMATTED "�����������������������������������������������������������������������������������������������������������������������������������������" SKIP
											"�" STRING("�⮣�: " + TRIM(ttReportLine.subPart), "x(20)") "�"
			                SPACE(30) "�"
			                STRING(subPartTotal, ">>>,>>>,>>>,>>9.99") "�" SKIP.
			subPartTotal = 0.
		END.

		/** �⮣� ࠧ���� */
		partTotal = partTotal + ttReportLine.loanAmount.

		IF LAST-OF(ttReportLine.part) THEN DO:
			PUT UNFORMATTED "�" STRING("�⮣� �� ࠧ���� " + STRING(ttReportLine.part) + ":", "x(20)") "�"
			                SPACE(30) "�"
			                STRING(partTotal, ">>>,>>>,>>>,>>9.99") "�" SKIP.
			IF NOT LAST-OF(ttReportLine.loanCurrency) THEN DO:
				PUT UNFORMATTED "���������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP.
			END.
			partTotal = 0.
		END.	

		/** �⮣� ����䥫� */
		total = total + ttReportLine.loanAmount.
		
		IF LAST-OF(ttReportLine.loanCurrency) THEN DO:
			PUT UNFORMATTED "�" STRING("�⮣� �� ����䥫� � " + STRING(ttReportLine.loanCurrency) + ":", "x(20)") "�"
			                SPACE(30) "�"
			                STRING(total, ">>>,>>>,>>>,>>9.99") "�" SKIP
			                "������������������������������������������������������������������������" SKIP(1).
			total = 0.
		END.	

END.

/** ����� � PREVIEW */
{preview.i}