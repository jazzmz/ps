{pirsavelog.p}

/* ------------------------------------------------------
     File: $RCSfile: pir_credgraph.p,v $ $Revision: 1.3 $ $Date: 2007-10-18 07:42:21 $
     Copyright: ��� �� "�p������������"
     ���������: 
     ��稭�: �� �� 23/03/2006 
     �� ������: ��ନ��� ��䨪 �����⮢ �।�⮢ �� ��ਮ�
     ��� ࠡ�⠥�: ��� ��� �뤥������ � ��㧥� ������஢ ᮡ�ࠥ��� ���ଠ��, �����
                   ��࠭���� � ���� �६����� ⠡����. �६���� ⠡���� ����� ��� "���� �� ������"
                   �१ ���� ttGraphMain.id - ttGraphPay.mainID. 
                   ������ ttGraphPay ���������� ����襩 ����� ���祭�ﬨ ⠡���� term-obl.
                   � term-obl �����, ᮮ⢥�����騥 ����� �᭮����� �����, � ���� idnt ����� 
                   ���祭�� "3", � ��業⮢ - "1". ��� ������ �࠭���� � term-obl.end-date.
                   ���������� ⠡���� ttGraphPay ����� �ᮡ�������. ��-�� "�८�ࠧ������"
                   ५�樮���� �奬� ������, �࠭����� � term-obl, � ��५�樮���� �奬� ⠡���� ttGraphPay
                   ��室���� �� ��ॡ�� ����ᥩ term-obl ��।����� �� �᫮��� ᮧ����� ��� ����䨪�樨 
                   ����ᥩ ttGraphPay. ��⠫�� �������ਨ �� ⥪��� �ணࠬ��.
                   ��᫥ 䠧� ᡮ� ���ଠ樨 
                   ��楤�� �ନ��� ����, ��ॡ��� ����� �६����� ⠡���.
     ��ࠬ����: 
     ���� ����᪠: ��㧥� �।���� ������஢.
     ����: $Author: anisimov $ 
     ���������: $Log: not supported by cvs2svn $
     ���������: Revision 1.2  2007/07/19 09:31:12  buryagin
     ���������: *** empty log message ***
     ���������:
------------------------------------------------------ */

/** �������� ����ன�� */
{globals.i}

/** ��� �����ન */
{ulib.i}

/** ��७�� �� ᫮��� */
{wordwrap.def}

/** ���ଠ�� �� ��㧥� */
{tmprecid.def}


/** ����������� */


/** ������� ⠡��� ���� */
DEFINE TEMP-TABLE ttGraphMain  NO-UNDO
	FIELD id AS INTEGER /** �����䨪��� */
	FIELD clientName AS CHAR EXTENT 3 /** ������������ ����騪� */
	FIELD loanNumber AS CHAR /** ����� ������� */
	FIELD loanOpenDate AS DATE /** ��� ������ ������� */
	.
	
/** �ᯮ����⥫쭠� ⠡��� ���� (���稭����� � ������� 1..n) */	
DEFINE TEMP-TABLE ttGraphPay  NO-UNDO
	FIELD mainID AS INTEGER /** ���譨� ���� */
	FIELD payDate AS DATE /** ��� ���⥦� */
	FIELD currency AS CHAR /** ����� */
	FIELD loanAmount AS DECIMAL /** �㬬� ���⥦� �� �᭮����� ����� */
	FIELD persAmount AS DECIMAL /** �㬬� ���⥦� �� ��業⠬ */
	.
	
DEF VAR currentID AS INTEGER NO-UNDO. /** ����� */
DEF VAR tmpStr AS CHAR NO-UNDO. /** ��� ��直� �㦤 */
DEF VAR tmpI AS INTEGER NO-UNDO. /** ��� ��直� �㦤 */
DEF VAR i AS INTEGER NO-UNDO. /** �����... �ਣ������ */


/** ��襭�� � �⮣��� ���宥, �� ����஥ */
DEF VAR total810 AS DECIMAL EXTENT 2 NO-UNDO.
DEF VAR total840 AS DECIMAL EXTENT 2 NO-UNDO.
DEF VAR total978 AS DECIMAL EXTENT 2 NO-UNDO.


/** ���������� */


/** ����� ��ਮ�� */
{getdates.i}

/** ���� �1: ᡮ� ���ଠ樨 */

currentID = 1.
total810 = 0.
total840 = 0.
total978 = 0.

FOR EACH tmprecid NO-LOCK,
    FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK
  :
  	CREATE ttGraphMain.
  	ttGraphMain.id = currentID.
  	/** ����稬 ������������ ������ � ���� ������ ������� */
  	tmpStr = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name,open_date", false).
  	ttGraphMain.clientName[1] = ENTRY(1, tmpStr).
  	
  	ttGraphMain.loanNumber = loan.cont-code.
  	ttGraphMain.loanOpenDate = DATE(ENTRY(2, tmpStr)).
  	
  	/** ������ ���⥦� */
  	FOR EACH term-obl WHERE term-obl.contract = loan.contract
  	                        AND 
  	                        term-obl.cont-code = loan.cont-code
  	                        AND (
  	                        	term-obl.idnt = 1
  	                        	OR
  	                        	term-obl.idnt = 3
  	                        )
  	                        AND
  	                     		term-obl.end-date GE beg-date
  	                     		AND
  	                     		term-obl.end-date LE end-date 
  	    USE-INDEX primary
  	    NO-LOCK
  		:
  			/** ���� � ttGraphPay ����� � ��⮩, ࠢ��� term-obl.end-date */
  			FIND FIRST ttGraphPay WHERE 
  						ttGraphPay.mainID = ttGraphMain.id 
  						AND
  						ttGraphPay.payDate = term-obl.end-date 
  						NO-LOCK NO-ERROR.
  						
  			IF NOT AVAIL ttGraphPay THEN 
  				DO:
  					CREATE ttGraphPay.
  					ttGraphPay.mainID = ttGraphMain.id.
  					ttGraphPay.payDate = term-obl.end-date.
  					ttGraphPay.currency = (IF loan.currency = "" THEN "810" ELSE loan.currency).
  				END.
				
				IF term-obl.idnt = 1 THEN DO: 
					ttGraphPay.persAmount = term-obl.amt-rub.
					IF ttGraphPay.currency = "810" THEN total810[2] = total810[2] + ttGraphPay.persAmount.
					IF ttGraphPay.currency = "840" THEN total840[2] = total840[2] + ttGraphPay.persAmount.
					IF ttGraphPay.currency = "978" THEN total978[2] = total978[2] + ttGraphPay.persAmount.
				END.
				IF term-obl.idnt = 3 THEN DO:
					ttGraphPay.loanAmount = term-obl.amt-rub. 
					IF ttGraphPay.currency = "810" THEN total810[1] = total810[1] + ttGraphPay.loanAmount.
					IF ttGraphPay.currency = "840" THEN total840[1] = total840[1] + ttGraphPay.loanAmount.
					IF ttGraphPay.currency = "978" THEN total978[1] = total978[1] + ttGraphPay.loanAmount.
				END.
  			
  	END.
  	
  	
  	/** ᫥���騩 */
  	currentID = currentID + 1.
  	
END.

/** ���� �2: �뢮� ���ଠ樨 */
{setdest.i}

PUT UNFORMATTED "������ ��������� ��������" SKIP
                "� ��ਮ� � " STRING(beg-date, "99.99.9999") " �� " STRING(end-date, "99.99.9999") SKIP(1).

PUT UNFORMATTED
	"�������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
	"������������� ����騪�                   ��।��� �������    ����      �����            � ����襭��              �" SKIP
	"�                                        ���������������������Ĵ���⥦�   �   �������������������������������������Ĵ" SKIP
	"�                                        ������     ����      �          �   ��᭮���� ����     ���業��          �" SKIP
	"�������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
	

FOR EACH ttGraphMain NO-LOCK
	:
		/** ������������ ������ �㦭� ��७��� �� ᫮��� */
		{wordwrap.i &s=ttGraphMain.clientName &l=40 &n=3}
		
		PUT UNFORMATTED 
			"�"
			ttGraphMain.clientName[1] FORMAT "x(40)" "�"
			ttGraphMain.loanNumber FORMAT "x(10)" "�"
			ttGraphMain.loanOpenDate FORMAT "99.99.9999" "�" 
			SPACE(10) "�"
			SPACE(3) "�"
			SPACE(18) "�"
			SPACE(18) "�"
			SKIP.
			
		/** ��������, �� ����� ��ப� ������������ �� �⯥�⠫� */
		tmpI = 2.
		
		FOR EACH ttGraphPay WHERE ttGraphPay.mainID = ttGraphMain.id NO-LOCK
			:
				PUT UNFORMATTED 
					"�".
					
				IF (tmpI > 1 AND tmpI <= 3) THEN 
					PUT UNFORMATTED STRING(ttGraphMain.clientName[tmpI], "x(40)") "�".
				ELSE 
					PUT UNFORMATTED SPACE(40) "�".
				
				PUT UNFORMATTED	
					SPACE(10) "�"
					SPACE(10) "�"
					ttGraphPay.payDate FORMAT "99.99.9999" "�" 
					ttGraphPay.currency FORMAT "xxx" "�"
					ttGraphPay.loanAmount FORMAT ">>>,>>>,>>>,>>9.99" "�"
					ttGraphPay.persAmount FORMAT ">>>,>>>,>>>,>>9.99" "�" 
					SKIP.	
					
				tmpI = tmpI + 1.
		END.
		
		/** �������� ��ப� clientName */
		DO i = tmpI TO 3 :
			IF ttGraphMain.clientName[i] <> "" THEN 
				PUT UNFORMATTED 
					"�"
					ttGraphMain.clientName[i] FORMAT "x(40)" "�"
					SPACE(10) "�"
					SPACE(10) "�" 
					SPACE(10) "�"
					SPACE(3)  "�"
					SPACE(18) "�"
					SPACE(18) "�"
					SKIP.
			
		END.
		
		PUT UNFORMATTED
			"�������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
			
END.

PUT UNFORMATTED
  "�                                        �          �          ��⮣�:    �810�" total810[1] FORMAT ">>>,>>>,>>>,>>9.99" "�" total810[2] FORMAT ">>>,>>>,>>>,>>9.99" "�" SKIP
  "�                                        �          �          �          �840�" total840[1] FORMAT ">>>,>>>,>>>,>>9.99" "�" total840[2] FORMAT ">>>,>>>,>>>,>>9.99" "�" SKIP
  "�                                        �          �          �          �978�" total978[1] FORMAT ">>>,>>>,>>>,>>9.99" "�" total978[2] FORMAT ">>>,>>>,>>>,>>9.99" "�" SKIP
  "���������������������������������������������������������������������������������������������������������������������" SKIP.
{preview.i}