/***********************************
 *
 * ����饭� �ࠢ��� ���㬥��� ��⮬�⨧�஢������
 * �㭪樮����.
 *
 ***********************************
 *
 * ����: ��᫮� �. �.
 * ���: #692
 * ��� ᮧ�����:
 *
 ************************************/
  IF CAN-DO(FGetSetting("PirBlockTrans","","!*"),op.op-kind) THEN DO:

   		                 MESSAGE COLOR WHITE/RED "����� �ࠢ��� ���㬥��� ��⮬�⨧�஢������ �㭪樮����!" SKIP
				 VIEW-AS ALERT-BOX TITLE "[������ #692]".



	RETURN NO-APPLY.
  END.
