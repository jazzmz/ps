/* ------------------------------------------------------
     File: $RCSfile: pirloanrep3.p,v $ $Revision: 1.2 $ $Date: 2008-11-18 08:16:41 $
     Copyright: ��� �� "�p������������"
     ���������: 
     ��稭�: ��襭�� �� 15.01.2008 13:13:19
     �� ������: �������� ���� � ���ﭨ� ��㤭�� ������������
     ��� ࠡ�⠥�: 
     ��ࠬ����: 
     ���� ����᪠: ��㧥� �।���� ������஢
     ����: $Author: ermilov $ 
     ���������: $Log: not supported by cvs2svn $
     ���������: Revision 1.1  2008/01/15 10:19:46  Buryagin
     ���������: no message
     ���������:
------------------------------------------------------ */

{globals.i}
{ulib.i}
{intrface.get instrum}

DEF VAR tmpStr AS CHAR NO-UNDO.
DEF VAR i AS INTEGER INIT 1 NO-UNDO.
DEF VAR CtrlSum AS DECIMAL INIT 0 NO-UNDO.
DEF VAR Sum AS DECIMAL EXTENT 30 INIT 0 NO-UNDO. 

{getdate.i}
{setdest.i}

/** ���᫥��� �㬬� ����⪮� ��⮢, 㤮����⢮����� ��᪥ � ����� */
FUNCTION getAcctPosSumBy RETURNS DECIMAL (INPUT inAcctMask AS CHAR, INPUT inCurrencyMask AS CHAR, INPUT inSideMask AS CHAR, INPUT inDate AS DATE).
	DEF BUFFER bfrAcct FOR acct.
	DEF VAR s AS DECIMAL.
	/** �롮ઠ */
	FOR EACH bfrAcct WHERE 
		bfrAcct.open-date LE inDate
		AND (
					bfrAcct.close-date GE inDate
					OR 
					bfrAcct.close-date EQ ?
				)
		AND
		CAN-DO(inAcctMask, bfrAcct.acct)
		AND
		CAN-DO(inCurrencyMask, bfrAcct.currency)
		AND 
		CAN-DO(inSideMask, bfrAcct.side)
		NO-LOCK
			:
		s = s + GetAcctPosValue_UAL(bfrAcct.acct, bfrAcct.currency, inDate, false).
	END.
	RETURN s.
END FUNCTION.

FUNCTION getLoanAcctPosSumBy RETURNS DECIMAL (INPUT inAcctMask AS CHAR,
INPUT inAccttypeMask AS CHAR,INPUT inLoanClassMask AS CHAR,
INPUT inDate AS DATE).
	FOR EACH loan-acct WHERE CAN-DO(inAcctMask, loan-acct.acct) 
	AND CAN-DO(inAccttypeMask,loan-acct.acct-type) 
	AND loan-acct.contract EQ '�।��' NO-LOCK , EACH loan OF loan-acct NO-LOCK BREAK BY loan-acct.acct:
	 IF CAN-DO(inLoanClassMask,loan.class-code) THEN 
	 ACCUM GetAcctPosValue_UAL(loan-acct.acct, "" , inDate, false) (TOTAL) .
	END.
	
	RETURN ACCUM TOTAL  GetAcctPosValue_UAL(loan-acct.acct, "" , inDate, false). 
END FUNCTION.



tmpStr = "!440*,!459*,44*,45*,46*,478*".

/************************   main ****************************************/

ASSIGN
Sum[1]  = getAcctPosSumBy(tmpStr, "", "�", end-date) 
Sum[2]  = getAcctPosSumBy(tmpStr, "840", "�", end-date)
Sum[3]  = getAcctPosSumBy(tmpStr, "978", "�", end-date)
Sum[4]  = ABS(getAcctPosSumBy("458*", "", "�", end-date))
Sum[5]  = ABS(getAcctPosSumBy("458*", "840", "�", end-date))
Sum[6]  = ABS(getAcctPosSumBy("458*", "978", "�", end-date))
Sum[7]  = ABS(getAcctPosSumBy("459*", "", "�", end-date))
Sum[8]  = ABS(getAcctPosSumBy("459*", "840", "�", end-date))
Sum[9]  = ABS(getAcctPosSumBy("459*", "978", "�", end-date))
Sum[10] = ABS(getAcctPosSumBy("47427*", "", "*", end-date))
Sum[11] = ABS(getAcctPosSumBy("47427*", "840", "*", end-date))
Sum[12] = ABS(getAcctPosSumBy("47427*", "978", "*", end-date))
Sum[13] = ABS(getAcctPosSumBy("91316*,91317*,91315*", "", "*", end-date))
Sum[14] = ABS(getAcctPosSumBy("91316*,91317*,91315*", "840", "*", end-date))
Sum[15] = ABS(getAcctPosSumBy("91316*,91317*,91315*", "978", "*", end-date))
Sum[16] = ABS(getAcctPosSumBy("91604*", "840", "*", end-date))
Sum[17] = ABS(getAcctPosSumBy("91604*", "978", "*", end-date))
Sum[18] = ABS(getAcctPosSumBy("91414*", "840", "*", end-date))
Sum[19] = ABS(getAcctPosSumBy("91414*", "978", "*", end-date))
Sum[20] = ABS(getAcctPosSumBy("91312*", "840", "*", end-date))
Sum[21] = ABS(getAcctPosSumBy("91312*", "978", "*", end-date))
Sum[22] = ABS(getAcctPosSumBy("91311*", "840", "*", end-date))
Sum[23] = ABS(getAcctPosSumBy("91311*", "978", "*", end-date))
Sum[24] = ABS(getAcctPosSumBy("47425*", "", "*", end-date))
Sum[25] = ABS(getLoanAcctPosSumBy("47425*","�।�����","*",end-date))
Sum[26] = ABS(getLoanAcctPosSumBy("47425*","�।����","*",end-date))
Sum[27] = Sum[24] - Sum[25] - Sum[26]
.

DO i=1 TO 23 :
Sum[30] = Sum[30] + Sum[i] .
END.

PUT UNFORMATTED "����� � ��������� ������� �������������" SKIP
                "�� " STRING(end-date, "99.99.9999") SKIP(2)
"����: " FindRateSimple("����","840",end-date) " ��/$" SKIP
"      " FindRateSimple("����","978",end-date) " ��/���" SKIP(2)
                "�������������" SKIP
                "  	                   " Sum[1] FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
		"         � ⮬ �᫥:	   " SKIP
		"		 ��.���   "
		getAcctPosSumBy("!440*,!455*,!457*,!45815*,!45817*,!459*,44*,45*,46*,478*", "", "�", end-date)
		FORMAT ">>>,>>>,>>>,>>9.99" SKIP
		"		䨧.���   "
		getAcctPosSumBy("455*,457*,45815*,45817*", "", "�", end-date)
		FORMAT ">>>,>>>,>>>,>>9.99" SKIP
               	"	 � ⮬ �.����⨪   " ABS(getLoanAcctPosSumBy("45509*,45708*,45815*,45817*","*","l_agr_with_per",end-date)) FORMAT ">>>,>>>,>>>,>>9.99" SKIP
                "       	           " Sum[2] FORMAT ">>>,>>>,>>>,>>9.99" " (840)" SKIP
		"               	   " Sum[3] FORMAT ">>>,>>>,>>>,>>9.99" " (978)" SKIP
								"---------------------------------------------------------------------" SKIP(1)
		"������� ������" SKIP
		"�����.�������������     " Sum[4] FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
		"(��� 458*)		   " Sum[5] FORMAT ">>>,>>>,>>>,>>9.99" " (840)" SKIP
		"        	           " Sum[6] FORMAT ">>>,>>>,>>>,>>9.99" " (978)" SKIP
								"---------------------------------------------------------------------" SKIP(1)
		"����祭�� ��業��     " Sum[7] FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
		"(��� 459*) 		   " Sum[8] FORMAT ">>>,>>>,>>>,>>9.99" " (840)" SKIP
		"       	           " Sum[9] FORMAT ">>>,>>>,>>>,>>9.99" " (978)" SKIP
								"---------------------------------------------------------------------" SKIP(1)
		"���饭�� ��業��	   " Sum[10] FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
		"(��� 47427*)   	   " Sum[11] FORMAT ">>>,>>>,>>>,>>9.99" " (840)" SKIP
		"     		           " Sum[12] FORMAT ">>>,>>>,>>>,>>9.99" " (978)" SKIP

								"=====================================================================" SKIP(1)
								"���������" SKIP
		"�⮣� (�㡫�)		   " Sum[13] FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
		"         � ⮬ �᫥:	   " SKIP
		"         91316 	   " ABS(getAcctPosSumBy("91316*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP
		"         91317 	   " ABS(getAcctPosSumBy("91317*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP
		"         91315   	   " ABS(getAcctPosSumBy("91315*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP(1)
		"�⮣� (����.���)	   " Sum[14] FORMAT ">>>,>>>,>>>,>>9.99" " (840)" SKIP
		"         � ⮬ �᫥:" SKIP
		"         91316 	   " ABS(getAcctPosSumBy("91316*", "840", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP
		"         91317 	   " ABS(getAcctPosSumBy("91317*", "840", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP
		"         91315   	   " ABS(getAcctPosSumBy("91315*", "840", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP(1)
		"�⮣� (���)		   " Sum[15] FORMAT ">>>,>>>,>>>,>>9.99" " (978)" SKIP
		"         � ⮬ �᫥:	" SKIP
		"         91316   	   " ABS(getAcctPosSumBy("91316*", "978", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP
		"         91317  	   " ABS(getAcctPosSumBy("91317*", "978", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP
		"         91315  	   " ABS(getAcctPosSumBy("91315*", "978", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP
		"---------------------------------------------------------------------" SKIP(1)
		"         91604    	   " ABS(getAcctPosSumBy("91604*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
		"                   	   " Sum[16] FORMAT ">>>,>>>,>>>,>>9.99" " (840)" SKIP
		"                	   " Sum[17] FORMAT ">>>,>>>,>>>,>>9.99" " (978)" SKIP
		"---------------------------------------------------------------------" SKIP(1)
		"         91414  	   " ABS(getAcctPosSumBy("91414*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
		"                 	   " Sum[18] FORMAT ">>>,>>>,>>>,>>9.99" " (840)" SKIP
		"                	   " Sum[19] FORMAT ">>>,>>>,>>>,>>9.99" " (978)" SKIP
		"---------------------------------------------------------------------" SKIP(1)
		"         91312  	   " ABS(getAcctPosSumBy("91312*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
		"              		   " Sum[20] FORMAT ">>>,>>>,>>>,>>9.99" " (840)" SKIP
		"                	   " Sum[21] FORMAT ">>>,>>>,>>>,>>9.99" " (978)" SKIP
		"---------------------------------------------------------------------" SKIP(1)
		"         91311  	   " ABS(getAcctPosSumBy("91311*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
		"              		   " Sum[22] FORMAT ">>>,>>>,>>>,>>9.99" " (840)" SKIP
		"                 	   " Sum[23] FORMAT ">>>,>>>,>>>,>>9.99" " (978)" SKIP
		"=====================================================================" SKIP(1)
		"�������" SKIP
                "1)�� ��㤭�� ���������.   " ABS(getAcctPosSumBy(tmpStr, "", "�", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP(1)
		"2)�� ��⠬ 47425  	   " Sum[24] FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
		"         � ⮬ �᫥:	" SKIP
                " - ����� + ��࠭⨨	   " Sum[25] FORMAT ">>>,>>>,>>>,>>9.99" SKIP
                " - ���饭�� ��業��	   " Sum[26] FORMAT ">>>,>>>,>>>,>>9.99" SKIP 
                " - ��祥  	           " Sum[27] /* ABS(getLoanAcctPosSumBy("47425*","!�।�����,!�।����,*","*",end-date)) */ FORMAT ">>>,>>>,>>>,>>9.99" SKIP(1)
		"3)�� ����祭�� %%	   " ABS(getAcctPosSumBy("45918*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
		"=====================================================================" SKIP
		"����������� �����:	   " (Sum[30] / 1000000) FORMAT ">>>,>>>,>>>,>>9.99" SKIP
                "=====================================================================" SKIP
								.
{intrface.del}
{preview.i}