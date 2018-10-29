/* ------------------------------------------------------
     File: $RCSfile: pir-chkop-6.i,v $ $Revision: 1.8 $ $Date: 2010-08-17 12:06:01 $
     Copyright: ��� �� "�p������������"
     ���������: 
     ��稭�: 
     �� ������: ����� ����஫� �� ����䨪�樨 ���㬥��
     ��� ࠡ�⠥�: �. ���㬥���� - ������ 1
     ��ࠬ����:
     ���� ����᪠: ��६���� ��।������� � pir-chkop-6.def 
     ����: $Author: Buryagin $ 
     ���������: $Log: not supported by cvs2svn $
     ���������: Revision 1.7  2010/04/07 09:06:27  Buryagin
     ���������: Fix for 'poluprovodok'
     ���������:
     ���������: Revision 1.6  2009/12/30 13:49:28  Buryagin
     ���������: Reading the field datablock.comment added to the first "IF" expression.
     ���������:
     ���������: Revision 1.5  2009/12/17 13:45:12  Buryagin
     ���������: Check #6 (PODFT) Upgrade for v2.0
     ���������:
     ���������: Revision 1.4  2009/11/18 06:33:56  Buryagin
     ���������: Added the the accounts changing check.
     ���������:
     ���������: Revision 1.1  2009/07/24 10:29:40  Buryagin
     ���������: New version of the PODFT's control.
     ���������:
------------------------------------------------------ */

/** 
 * �᫨ �⤥� ����� 㦥 ��砫 �ନ஢���� ����� ������
 * � 
 * �᫨ �� ���㬥�� ��� ���.४�����, ࠧ���饣� ।���஢����
 * � 
 * �஢�ਬ �� �᪫�祭��
 *
 **/

podft_class = FGetSetting("PirPODFTClass", "", "").
podft_sum1 = DEC(FGetSetting("PirPODFTSum1", "", "600000")).
podft_sum1_check = FGetSetting("PirPODFTCkS1", "", "").

IF (GetXattrValueEx("op", string(op.op), "PIRcheckPODFT","") <> "��")
   AND
   (CAN-FIND(FIRST datablock WHERE 
   			 datablock.dataclass-id = podft_class
   			 AND
   			 datablock.beg-date = datablock.end-date
   			 AND
   			 datablock.beg-date = op-entry.op-date
   			 AND
   			 TRIM(datablock.comment) = ""
   			 NO-LOCK)
   )
THEN DO:

	/**
	 * �᫨ ����ᯮ������ ���㬥�� ������� ��� �᪫�祭��
	 * � ।���஢��� ��� �����,
	 * ���� ।���஢��� ����� �� �� ����� �᫮����.
	 * ��祬, �᫨ � ����� ���४�஢�� ����ᯮ������ ���������, �
	 * �ணࠬ�� ������ �஢���� ��� ����� ����ᯮ������, ⠪ � �����.
	 * �᫨ ��� �� ���� �� ��� ��������� � �᪫�祭���, � ������ ��������� �������⨬�. 
	 **/

	podft_new_acct_db = op-entry.acct-db.
	podft_new_acct_cr = op-entry.acct-cr.
	
	/** ����஢���� */
	if podft_new_acct_db = ? then do:
		find first podft-op-entry where 
			podft-op-entry.op = op-entry.op and podft-op-entry.acct-db <> ? no-lock no-error.
		if avail podft-op-entry then podft_new_acct_db = podft-op-entry.acct-db.
	end.
	if podft_new_acct_cr = ? then do:
		find first podft-op-entry where 
			podft-op-entry.op = op-entry.op and podft-op-entry.acct-cr <> ? no-lock no-error.
		if avail podft-op-entry then podft_new_acct_cr = podft-op-entry.acct-cr.
	end.
	
	podft_old_acct_db = podft_new_acct_db.
	podft_old_acct_cr = podft_new_acct_cr.
	
	IF 'op-entry' EQ iParam THEN 
	DO:
		FIND LAST history WHERE history.file-name  EQ 'op-entry' AND 
								history.field-ref  EQ STRING(op.op) + ',' + STRING(op-entry.op-entry) AND 
				 				history.modif-date EQ TODAY AND
				 				history.modif-time GE (TIME - 10)
				 				NO-LOCK NO-ERROR.
		IF AVAIL history AND LOOKUP ('acct-db',history.field-value) > 0 and podft_old_acct_db <> ? THEN DO:
			podft_old_acct_db = ENTRY(LOOKUP ('acct-db',history.field-value) + 1, history.field-value).
		END.
		IF AVAIL history AND LOOKUP ('acct-cr',history.field-value) > 0 and podft_old_acct_cr <> ? THEN DO:
			podft_old_acct_cr = ENTRY(LOOKUP ('acct-cr',history.field-value) + 1, history.field-value).
		END.
		
		
	END.
	
	IF (
	   		(? = FirstIndicateCandoIn_ULL("PirPODFTEntr", 
	                            podft_new_acct_db + "," + podft_new_acct_cr + "," + op.op-kind,
	                            op-entry.op-date,
	                            "��", ""))
	   		OR
	   		(? = FirstIndicateCandoIn_ULL("PirPODFTEntr", 
	                            podft_old_acct_db + "," + podft_old_acct_cr + "," + op.op-kind,
	                            op-entry.op-date,
	                            "��", ""))
	   )
	   AND                        
   	   (op-entry.op-status >= '�')
	THEN DO:
	   &IF DEFINED(CLOSEDAY) &THEN 
	   podft_need = true.
	   &ELSE
	   MESSAGE COLOR WHITE/RED
	   				" ����樮��� ���� " op-entry.op-date " 㦥 ���� ��� ����஫� �⤥��� �����." skip  
		    		" ���㬥�� �������� �������� ��� ��⨢�����⢨� ��������樨 !!!" skip
		    		" ���쭥��� ࠡ�� � ��� ���������� !!!" skip
		    		" ������� � ���㤭��� ����� !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "�訡�� ���㬥��".
		RETURN.
		&ENDIF
	END.
	
	/**
	 * �᫨ �㬬� ���㬥�� ����� ��� ࠢ�� 600 000 �㡫�� (��������)
	 * � �뤠�� ᮮ�饭�� � ����頥� ।���஢���
	 */
	IF (op-entry.amt-rub >= podft_sum1) 
	   AND
	   (  
	      CAN-DO(podft_sum1_check, podft_new_acct_db) 
	      OR
	      CAN-DO(podft_sum1_check, podft_new_acct_cr)
	   )
	   AND 
	   (op-entry.op-status >= '�') THEN DO:
	   &IF DEFINED(CLOSEDAY) &THEN 
	   podft_need = true.
	   &ELSE
	   MESSAGE COLOR WHITE/RED
	   				" �㬬� ���㬥�� ����� ��� ࠢ��" TRIM(STRING(podft_sum1, ">>>,>>>,>>9.99")) "�㡫��." skip  
		    		" ���㬥�� �������� �������� ��� ��⨢�����⢨� ��������樨 !!!" skip
		    		" ���쭥��� ࠡ�� � ��� ���������� !!!" skip
		    		" ������� � ���㤭��� ����� !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "�訡�� ���㬥��".
		RETURN.
		&ENDIF
	END.
	
	IF (GetXattrValueEx("op", string(op.op), "��������㬥��","") <> "")
	   OR
	   (GetXattrValueEx("op", string(op.op), "��������","") <> "")
	THEN DO:
	   &IF DEFINED(CLOSEDAY) &THEN 
	   podft_need = true.
	   &ELSE
	   MESSAGE COLOR WHITE/RED 
		    		" ���㬥�� �஬�ન஢�� �⤥��� ����� ��� ������⥫��!!!" skip
		    		" ���쭥��� ࠡ�� � ��� ���������� !!!" skip
		    		" ������� � ���㤭��� ����� !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "�訡�� ���㬥��".
		RETURN.
		&ENDIF
	END.
	  
END.

