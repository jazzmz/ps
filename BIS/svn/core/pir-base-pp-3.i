/**
 * �������, ���� �.�., 18/05/2010 
 * ��������� �����⬠ 2-3
 * ����� �� ।���஢���� ���㬥��, ᮧ������� �� �᭮����� �࠭���樨 ��
 *
*/

/* message iStat iFlSal iFlDate iChkMaxSts iCodOper view-as alert-box. */

IF CAN-DO("!View,!ChgSts,!Undo,!Signs,*", iCodOper)
   AND
   (GetXattrValueEx("op", string(op.op), "�࠭���","") NE "")
   AND 
   getThisUserXAttrValue('pirCanEditPCTransOp') <> "��"
THEN DO:
	oMsg = "�� �� ����� �ࠢ� �������� ���㬥��, ᮧ����� �� �᭮����� �࠭���樨 ��!".
    RETURN.	
END.