/**
 * �������, �ନ��� �.�., 28/12/2010 
 * �����஢�� ����⨪����� �㭪樮����
 *
*/

/** ᯨ᮪ �࠭���権, १���� ࠡ��� ������ ����室��� ������� ।���஢��� */
DEF VAR PirBlockTrans AS CHAR NO-UNDO.

PirBlockTrans = FGetSetting("PirBlockTrans","","").

 /*message iStat iFlSal iFlDate iChkMaxSts iCodOper view-as alert-box.*/ 

IF CAN-DO("!View,!ChgSts,!Undo,!Signs,*", iCodOper)
   AND
   CAN-DO(pirBlockTrans, op.op-kind)
   
THEN DO:
	oMsg = "�� �� ����� �ࠢ� �������� ���㬥��, ᮧ����� ��⮬�⨧�஢���� �㭪樮�����!".
    RETURN.	
END.