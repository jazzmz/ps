/**
 * �������, ���� �.�., 18/11/2009 
 * ��������� �����⬠ 2-2
 * ����� �⪠� ��㯮�����祭���� ���㤭���
 *
*/

usersCanRollback = getThisUserXAttrValue('pirCanRollbackUsers').
pirRollbackStat = FGetSetting("PirRollbackStat","","").

/** message iStat iFlSal iFlDate iChkMaxSts iCodOper view-as alert-box. */

IF CAN-DO("!Signs,!View,!Copy,*", iCodOper)
   AND
   CAN-DO(pirRollbackStat, op.op-status)
   AND 
   op.user-inspector <> USERID('bisquit') 
   AND 
   NOT CAN-DO(usersCanRollback, op.user-inspector)
THEN DO:
	oMsg = "�� �� ����� �ࠢ� ������ ������ ������ � ����� ���㬥�⮬! �� �� ���� ��� ����஫�஬, � ���짮��⥫�-����஫�� ��� � ��襬 ᯨ᪥ \"����頥�� ���\".".
    RETURN.	
END.