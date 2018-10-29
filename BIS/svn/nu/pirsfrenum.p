{pirsavelog.p}

/**

	��楤�� ��㯯����� ��������� ����஢ ��⮢-䠪���.
	���� �.�., 07.02.2007 12:19
	
	����᪠���� �� ����⥪� ��⮢-䠪���
	
*/

{globals.i}

{tmprecid.def} /** ������� �ᯮ�짮����� ������쭮� �६����� ⠡���� �뤥������ � ��㧥� ����ᥩ */

DEF INPUT PARAM iParam AS CHAR.
DEF VAR start-doc-num AS INT LABEL "���� �����".
DEF VAR tmpStr AS CHAR.
DEF VAR i AS INTEGER.
DEF VAR inFormat AS CHAR.
DEF BUFFER inLoan FOR loan. /** �ਭ��� ���-䠪���� */
DEF BUFFER existsLoan FOR loan.

pause 0.

inFormat = ENTRY(1, iParam).

/** �뢮��� ��� */
DISPLAY start-doc-num SKIP
		WITH FRAME doc-num-frame SIDE-LABELS CENTERED OVERLAY.
		
/** ������஢���� ���祭�� � �ଥ */
SET start-doc-num WITH FRAME doc-num-frame.

i = start-doc-num.


/*
FOR EACH tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) = tmprecid.id
*/
FOR EACH loan WHERE loan.contract = "sf-out" AND CAN-FIND(tmprecid WHERE tmprecid.id = RECID(loan))
		BY loan.conf-date BY loan.doc-num
	:
		
		/** �஢��塞, �� ����� �� �����-���� �� �����, ����� ��⠥��� ��᢮��� */
		DO WHILE CAN-FIND (FIRST existsLoan WHERE 
				YEAR(existsLoan.conf-date) = YEAR(loan.conf-date) 
				AND
				existsLoan.contract = "sf-out"
				AND 
				existsLoan.doc-num = STRING(i, inFormat))
		:
			/** ��६ ᫥���騩 �� ���浪� */
			i = i + 1.
		END.

		IF GetXAttrValueEx("loan", loan.contract + "," + loan.cont-code, "PIRNoRenum", "���") = "���" THEN
			DO:
			 	/** ������ ���-䠪���� (�ਭ���), ����� ᮧ���� � ������ ᯨᠭ�� �����ᨨ �� ������ࠬ.
			 	    �����᭮ 914-� �� ����� � ���� ������ ᮮ⢥��⢮���� �� �뤠��� � ������ ������ */
			 	FOR EACH inLoan WHERE 
			 			inLoan.contract = "sf-in" 
			 			AND 
			 			inLoan.conf-date = loan.conf-date
			 			AND
			 			inLoan.doc-num = loan.doc-num
			 		:
			 			inLoan.doc-num = STRING(i, inFormat).
			 	END.
			 	loan.doc-num = STRING(i, inFormat).
				i = i + 1.
			END.
		
END.

HIDE FRAME doc-num-frame.
