/*********************************
 * ����� �ࠢ�� ���㬥�⮢ �� ���
 * � ⥫� ���㬥�� ��祣� �����
 * �ࠢ���.
 **********************************
 *
 * ����: ��᫮� �. �.
 * ���: #692
 * ��� ᮧ�����:
 *********************************/

IF LOGICAL(FGetSetting("PirChkop","DenyEditAuto","TRUE")) THEN DO:
 IF op.user-id EQ "MCI" OR op.user-id EQ "BNK-CL" THEN DO:

	   MESSAGE COLOR WHITE/RED "������! ������ ������� �� ����������� " + op.user-id + "!!!" 
	   VIEW-AS ALERT-BOX ERROR TITLE "�訡�� ���㬥�� #692".
	   RETURN NO-APPLY.

 END. /* IF user-id */
END. /* IF FGetSetting */
