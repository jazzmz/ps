/*****************************************
 *				         *
 * ����� ���४�஢�� �易����        *
 * ���㬥�⮢                            *
 *                                       *
 *****************************************
 *                                       *
 * ����: ��᫮� �. �. Maslov D. A.      *
 * ���: #726                          *
 * ��� ᮧ�����:                        *
 *                                       *
 * ����஢ �.�. �� ��� #4379 ᤥ���  *
 * �᪫�祭�� �� ���४� PirLinkCanEdit  *
 * �� ���㬥��, �ਢ� ���ਪ� ��᫮�� *
 * ���� "!!!" � �ࠢ���� ���᪮�� �몠. *
 ****************************************/ 

if not logical(GetXAttrValueEx("op",string(op.op),"PirLinkCanEdit","no")) then do:
	if can-do("!Ann,!View,!ChgSts,!Undo,!Signs,*", iCodOper) AND CAN-DO(FGetSetting("PirChkOp","PirLnkTr","!*"),op.op-kind) then do:
		oMsg = "�訡�� #726! \n ���㬥�� �易���! \n ��������� ����饭�!".
		return.	
	end.
end.