/****************************************
 *				        *
 * ����஫� �� ����� ।���஢����    *
 * ���㬥�⮢ ���㦥���� � �����஭�� * 
 * ��娢.                               *
 *                                      *
 ****************************************
 *                                      *
 * ����: ��᫮� �. �. Maslov D. A.     *
 * ���: #700                         *
 * ��� ᮧ�����:                       *
 *                                      *
 ****************************************/ 


IF CAN-DO("!View,!ChgSts,!Undo,!Signs,*", iCodOper)
   AND INT64(GetXattrValueEx("op", string(op.op), "PirA2346U","0"))>1000 
THEN DO:
	oMsg = "������ #700! \n ���㬥�� ���㦥� � �����஭�� ��娢! \n ��������� ����饭�!!!".
    RETURN.	
END.