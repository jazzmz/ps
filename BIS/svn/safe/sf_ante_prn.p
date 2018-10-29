{pirsavelog.p}

/**	
 * ����� ॥��� ����� ������� �१ ����� �� ����⨪��� ���
 * ���� �.�.
 * 04.07.2006 15:59
 */
 
 DEFINE INPUT PARAMETER iParam AS CHAR NO-UNDO.
 
 /**
  * �ணࠬ�� ����砥� � ����⢥ ��ࠬ��� ���� ����� �࠭���権. 
  * ��ࠡ��뢠��, ��࠭�� � ��㧥� ���㬥���, �⡨�� �, �� ᮧ�����
  * 㪠����묨 �࠭����ﬨ. 
  */	
 
/** �������� ��।������ */
{globals.i} 

/** ������⥪� ࠡ��� � ������ࠬ�, ��⠬ � ��. */
{ulib.i} 

/** ��७�� ��ப */
{wordwrap.def}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

/** ��ப� ���� */
DEFINE TEMP-TABLE tt-report
	FIELD clientNameStr AS CHAR
	FIELD clientName AS CHAR EXTENT 5
	FIELD loanNo AS CHAR
	FIELD currency AS CHAR
	FIELD summa AS DECIMAL
	INDEX client clientNameStr ASCENDING.

DEF VAR i AS INTEGER.
DEF VAR repDate AS DATE.
DEF VAR monthList AS CHAR EXTENT 12.
ASSIGN 
	monthList[1] = "ﭢ���"
	monthList[2] = "䥢ࠫ�"
	monthList[3] = "����"
	monthList[4] = "��५�"
	monthList[5] = "���"
	monthList[6] = "���"
	monthList[7] = "���"
	monthList[8] = "������"
	monthList[9] = "ᥭ����"
	monthList[10] = "������"
	monthList[11] = "�����"
	monthList[12] = "�������".
	
/** ��� �ᯮ�殮��� */
repDate = TODAY.
FOR FIRST tmprecid NO-LOCK,
	  FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK
:
	repDate = op.op-date.
END.

/** 
 * ��� ��� �뤥������ ����ᥩ, �⡨ࠥ� ���㬥��� ᮧ����� �࠭����ﬨ 
 * �� ��ࠬ��� iParam � � ����ᯮ����樥� 20202* - 408*.
 */
FOR EACH tmprecid NO-LOCK,
    FIRST op WHERE 
    	RECID(op) = tmprecid.id 
    	AND
    	CAN-DO(iParam, op.op-kind)
    	NO-LOCK,
    FIRST op-entry OF op NO-LOCK
:
		/** �᫨ ����ᯮ������ ��⮢ ᮮ⢥����� 20202* - 408*, � */
		IF op-entry.acct-db BEGINS "20202" AND op-entry.acct-cr BEGINS "408" THEN DO:
			/** ������ ������� */
			FIND FIRST loan-acct WHERE 
				loan-acct.acct = op-entry.acct-cr
				AND
				loan-acct.contract = "�����"
				AND
				loan-acct.acct-type = "������䏫���"
				NO-LOCK NO-ERROR.
			IF AVAIL loan-acct THEN DO:
				FIND FIRST loan WHERE
					loan.contract = loan-acct.contract
					AND
					loan.cont-code = loan-acct.cont-code
					NO-LOCK NO-ERROR.
				IF AVAIL loan THEN DO:
						CREATE tt-report.
						ASSIGN
							tt-report.loanNo = GetXAttrValueEx("loan", loan.contract + "," + loan.cont-code, "SafePlastLNum","")
							tt-report.summa = (IF op-entry.currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur)
							tt-report.currency = op-entry.currency
							tt-report.clientName[1] = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", FALSE)
							tt-report.clientNameStr = tt-report.clientName[1].
						/** ���-����� ����⢨� �� �ଠ�஢���� */
						{wordwrap.i &s=tt-report.clientName &l=20 &n=5}
				END.
			END.
		END.    
END.

/** �뢮� ���� � preview */

{get-bankname.i}

{setdest.i}

/** ����� */
/*PUT UNFORMATTED SPACE(70) "� ��ࠢ����� ����⨪���� ����" SKIP
                SPACE(70) cBankName SKIP(3)
                SPACE(35) '������������' SKIP
                SPACE(20) '� �������� �������������� �������� �������' SKIP
                SPACE(18) '�� ������ ����� ����� ����������� ����� ������' SKIP 
                SPACE(32) '"' STRING(DAY(repDate),"99") '" ' monthList[MONTH(repDate)] ' ' STRING(YEAR(repDate)) ' �.' SKIP(3).
*/
/** ��������� */
PUT UNFORMATTED 
	 	"������������������������������������������������������������������Ŀ" SKIP
		"��.�.�.              ������      ��           ��㬬�              �" SKIP
		"�                    �����������  ����         �                   �" SKIP
	 	"������������������������������������������������������������������Ĵ" SKIP.

/** ���� */
FOR EACH tt-report :
	PUT UNFORMATTED
	 "�" tt-report.clientName[1] FORMAT "x(20)"
	 "�" tt-report.currency FORMAT "x(12)"
	 "�" tt-report.loanNo FORMAT "x(12)"
   "�" tt-report.summa FORMAT "->>>,>>>,>>>,>>9.99"
   "�" SKIP.
  DO i = 2 TO 5 :
  	IF tt-report.clientName[i] <> "" THEN
			PUT UNFORMATTED
	 			"�" tt-report.clientName[i] FORMAT "x(20)"
		 		"�" SPACE(12)
		 		"�" SPACE(12)
   			"�" SPACE(19)
   			"�" SKIP.
  END.
	PUT UNFORMATTED
	 	"������������������������������������������������������������������Ĵ" SKIP.

END.
/** �⮣� */
	PUT UNFORMATTED
		"��������������������������������������������������������������������" SKIP.

/** ������ */
/*
PUT UNFORMATTED
	SPACE(5) '���. �।ᥤ�⥫� �ࠢ����� ��砫쭨� �' SKIP(1)
	SPACE(5) '_________________/___________________/' SKIP(3)
	SPACE(5) '�⢥��⢥��� ���㤭�� (�ᯮ���⥫�) �⤥��' SKIP(1)
	SPACE(5) '_________________/___________________/' SKIP.
*/	
{preview.i}
 