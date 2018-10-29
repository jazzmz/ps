FUNCTION isBankNerezCheck RETURNS LOGICAL(INPUT iRecOp AS RECID):
	
	/*************************************
	 * �㪭�� �஢���� ���� ��     *
	 * �����⥫�� �������� �।��      *
	 * ���� ��१�����.                  *
	 * �᫨ �����⥫� ���� ��१�����,  *
	 * � �஢������ �㬬� ���㬥�� �  *
	 * ����稥 ���� � ������������     *
         * �����⥫�.                       *
	 *************************************
	 *                                   *
	 * ����: ��᫮� �. �. Maslov D. A.  *
	 * ���: #638                      *
	 * ��� ᮧ�����: 18.02.11           *
	 *                                   *
	 *************************************/

	DEF VAR oDocument AS TPaymentOrder.

	DEF VAR cName AS CHARACTER.
	DEF VAR cBankNerList AS CHARACTER.
	DEF VAR dSumEdge AS DECIMAL.

	DEF VAR lRes AS LOGICAL.
	DEF VAR cStr1 AS CHARACTER.
	DEF VAR cError AS CHARACTER.
 
	

	oDocument = new TPaymentOrder(iRecOp).

	/*************************************************
	 * ����砥� ���� �஢�ન ��⮢            *
	 * �� ��. �᫨ ⠪��� ���, � �᪫�砥�     *
	 * �� ���㬥��� �� �஢�ન.                    *
	 ************************************************/
	cBankNerList = FGetSetting("PirChkOp","PirBankNerList","!*").
	dSumEdge = DECIMAL(FGetSetting("PirChkOp","PirBankNerEdge","0")).


	IF  oDocument:direct EQ "out" AND CAN-DO(cBankNerList,oDocument:acct-rec) AND oDocument:sum >= dSumEdge THEN 
	    DO:

		/****************************************
		 *			       		*
		 * ���� ���� ��१����⮬ �         *
		 * �㬬� ���㬥�� �����,		*
		 * ���࠭�筮�.				*
		 *                                      *
                 ****************************************/

		cName = oDocument:name-send.

/*****************************************************************************************
 *                                                                                       *
 * ����砫쭮 �।���������� �ᯮ�짮�����						 *
 * ॣ��୮�� ��ࠦ����.								 *
 * IF NOT ereg(cName,'^.*[/]{2}.*[/]{2}$',OUTPUT cStr1,INPUT-OUTPUT cError) THEN	 *
 * �� ����஫�� �� �訡�� � ����.							 *
 * �ந��ନ஢�� ���뤮�� � ������� �� CAN-DO .					 *
 *                                                                                       *
******************************************************************************************/

		IF NOT CAN-DO('*//*//*',cName) THEN
			DO:

   			  MESSAGE COLOR WHITE/RED "������������ ������������ �����������! " SKIP
						  "�������� �" + oDocument:doc-num + " . �� �㬬�: " + STRING(oDocument:sum) SKIP
			                           VIEW-AS ALERT-BOX TITLE "[������ #638]".
				RETURN FALSE.
			END.			
	    END.	/* END oDocument:direct = "out" */

        DELETE OBJECT oDocument.
	RETURN TRUE.
END FUNCTION.
