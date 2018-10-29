/**
 *
 * PlayList - �����㬥�� ��� ��᫥����⥫쭮�� ����᪠ ��।�������� ����� �࠭���権. 
 * 
 * ��窠 ����᪠ - "�����" �⠭���⭠� �࠭����� � �� ���㫥 ��⥬�.
 * ���䨣���� � ����ன�� - 1) � ��ࠦ���� before �窨 ����᪠; 2) �����䨪���
 * � ������ ����᪠ playlist-� � "�����" ���, ����� �� before �窨 ����᪠ ����������
 * � �����䨪���. �� ������ ��᫥���饬 ����᪥ �� ����� ������ �� �����䨪���.
 * 
 * ���� �窨 ����᪠ � �����䨪��஬ (��ୠ���) �����⢫���� �� 
 * ��ࠬ���� "code" � ��ࠦ���� before �窨 ����᪠.
 *
 */

DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
DEFINE INPUT PARAMETER iOpRID     AS RECID NO-UNDO.

{globals.i}
{ulib.i}

DEF BUFFER bfrCurrentOpKind FOR op-kind.
DEF BUFFER bfrCode FOR code.

DEF VAR vOpRID AS RECID NO-UNDO.
DEF VAR vCodeFilter AS CHAR NO-UNDO.
DEF VAR vItemCount AS INT NO-UNDO.
DEF VAR vItemName AS CHAR NO-UNDO.
DEF VAR vItemVal AS CHAR NO-UNDO.
DEF VAR vCode AS CHAR NO-UNDO.
DEF VAR vMessAns AS LOGICAL NO-UNDO.
DEF VAR vOldCodeVal AS CHAR NO-UNDO.
DEF VAR i AS INT NO-UNDO.
DEF VAR startDate AS DATE NO-UNDO.
DEF VAR startTime AS INT NO-UNDO.
DEF VAR finishDate AS DATE NO-UNDO.
DEF VAR finishTime AS INT NO-UNDO.

DEFINE VARIABLE confirm_exit AS LOGICAL FORMAT "��/���" INIT yes NO-UNDO.
DEF VAR imes AS INT NO-UNDO.

DEF VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.


FIND FIRST bfrCurrentOpKind WHERE RECID(bfrCurrentOpKind) = iOpRID NO-LOCK.

/*******************************
 * �஢��塞 �믮�������       *
 * �� �࠭����� ��            *
 * ��ࠬ��� prevPL.           *
 * �।����������, �� � �⮬  *
 * ��ࠬ��� �㤥� ��������    *
 * �� �।��饣� 蠣�.        *
 *******************************
 *                             *
 * ���: 25.08.11              *
 * ����: ��᫮� �. �.         *
 * ���: #748                *
 *                             *
 *******************************/
FUNCTION isCanRun RETURNS LOGICAL(INPUT in-op-date AS DATE,INPUT bfrTr AS RECID):

DEF VAR cCurrDate AS CHARACTER NO-UNDO.
DEF VAR isCanRun  AS LOGICAL INITIAL TRUE NO-UNDO.
DEF VAR prevPL AS CHARACTER NO-UNDO. 		  /* �।��騩 �������� */
DEF BUFFER bfrCurrentOpKind FOR op-kind.

FIND FIRST bfrCurrentOpKind WHERE RECID(bfrCurrentOpKind) = bfrTr NO-LOCK.

cCurrDate = STRING(YEAR(in-op-date), "9999") + STRING(MONTH(in-op-date),"99") 
	+ STRING(DAY(in-op-date),"99").


prevPL = GetParamByName_ULL(bfrCurrentOpKind.before,"prevPL",?,";").


IF prevPL <> ? THEN DO:

	FIND FIRST bfrCode WHERE bfrCode.class = bfrCode.class
				 AND bfrCode.code = cCurrDate + prevPL
			     NO-LOCK NO-ERROR.

	IF NOT AVAILABLE(bfrCode) THEN DO:
		isCanRun = FALSE.
	  END.
          ELSE DO:
		  IF bfrCode.val <> "�믮�����" THEN DO:
			isCanRun = FALSE.
	  	  END.
	  END.
END.
 RETURN isCanRun.
END FUNCTION.

IF NOT isCanRun(in-op-date,iOpRID) THEN DO:
   		                 MESSAGE COLOR WHITE/RED "������ ��������! " SKIP
				 "��������� ���������� ���!"
				 VIEW-AS ALERT-BOX TITLE "[������ #748]".

	RETURN NO-APPLY.
END.

/** ------------------------------------------- */
DEF QUERY qItem FOR code.
DEF BROWSE brwItem QUERY qItem 
	DISPLAY	
		ENTRY(num-entries(code.code,"-"), code.code, "-") format "x(3)" LABEL "N"
		code.name format "x(39)" LABEL "������"
		code.val format "x(15)" LABEL "�����"
		code.misc[1] format "x(8)" LABEL "��"
		code.misc[2] format "x(19)" LABEL "����"
		code.misc[3] format "x(19)" LABEL "�����" 
		code.misc[4] format "x(8)" LABEL "(�⪠�) ��"
		code.misc[5] format "x(19)" LABEL "(�⪠�) ����"
		code.misc[6] format "x(19)" LABEL "(�⪠�) �����"
		code.misc[7] format "x(10)" LABEL "�࠭�.ID" 
	WITH 10 DOWN WIDTH 73 NO-LABELS.
	
DEF BUTTON btn_next LABEL "�믮�����".
DEF BUTTON btn_exit LABEL "��室".
DEF BUTTON btn_rollback LABEL "�⪠���".

DEF FRAME frmPlan 
	brwItem at row 1 column 1 skip
	" " btn_next btn_exit SPACE(40) btn_rollback
WITH CENTERED OVERLAY SIZE 75 BY 18 TITLE "��ୠ� ����権".

TERMINAL-SIMULATION = CURRENT-WINDOW.
ASSIGN CURRENT-WINDOW                = TERMINAL-SIMULATION 
       THIS-PROCEDURE:CURRENT-WINDOW = TERMINAL-SIMULATION.

/** ---------------------------------------------*/

on esc go.

on choose of btn_next in frame frmPlan do:

	FIND CURRENT code.
	
	if code.val = "�믮�����" then do:
		message "������ 㦥 �믮�����!" view-as alert-box.
		return no-apply.
	end. 
	else do:
		/********************************
		 *
		 * �� ��� #846.
		 * ���� ���뢠�� ���冷� 
		 * �믮������ �㭪⮢.
		 *
		 * ����: ��᫮� �. �. Maslov D. A.
		 * ���: #846
                 ********************************/
		FIND LAST bfrCode where 
			bfrCode.class = vCode 
			and bfrCode.parent = vCodeFilter
			and bfrCode.code begins entry(1, code.code, "-") 
			AND INT(ENTRY(2,bfrCode.code,"-")) < INT(ENTRY(2,code.code,"-"))
			AND bfrCode.val <> "�믮�����" no-lock no-error.
		if avail bfrCode and bfrCode.code <> code.code then do:
			message "����� ������� ��᫥����⥫쭮��� �믮������!" view-as alert-box.
			return no-apply.
		end.
	end.
	
	/** �஢��塞 ����������� ����᪠ ⥪�饩 �����. 
	    � ������ �㭪� ��ୠ�� � ���ᠭ�� 2 ������ ���� 㪠���� ��楤�� "���࠭�筨�" canrun-proc=...
	*/
	vItemVal = TRIM(GetParamByName_ULL(code.description[2], "canrun-proc", "", ";")).
	IF vItemVal <> "" THEN DO:
		ON esc endkey.
		RUN VALUE(vItemVal)(INPUT in-op-date, INPUT vItemName, INPUT code.misc[1]) NO-ERROR.
		ON esc go.

		IF ERROR-STATUS:ERROR THEN DO:
			MESSAGE "��� ࠧ�襭�� �� �믮������ ����� '" + code.name + "'!" VIEW-AS ALERT-BOX.
			RETURN NO-APPLY.
		END.		
	END.
	
	FIND FIRST bfrCode WHERE 
		bfrCode.class = vCode AND bfrCode.code = vCodeFilter NO-ERROR.
	
	/** � ������ �㭪� ��ୠ�� � ���ᠭ�� 2 ������ ���� 㪠���� �࠭����� op-kind=...*/
	vItemVal = TRIM(GetParamByName_ULL(code.description[2], "op-kind", "", ";")).
	FIND FIRST op-kind WHERE op-kind.op-kind = vItemVal NO-LOCK NO-ERROR.

	/***********************************************
         *                                             *
         * ����� �ந�������� �����                   *
         * ��.                                         *
         * ���� DO transaction ��⠭�������� LOCK      *
         * ���⮬� ���������� ����⨥ �࠭���樨.    *
         *                                             *
         * ���: #836                                *
         * ����: ��᫮� �. �.			       *
         *                                             *
         ***********************************************/
	IF AVAIL op-kind THEN DO /*transaction*/:
		vOpRID = RECID(op-kind).
		code.misc[1] = USERID("bisquit").
		code.misc[2] = STRING(TODAY, "99/99/9999") + " " + STRING(TIME, "HH:MM:SS").
		code.misc[3] = "".
		code.val = "�믮������...".
		bfrCode.val = code.val.
		BROWSE brwItem:REFRESH().
		
		ON esc endkey.
		
		startDate = TODAY. startTime = TIME.
				
		RUN VALUE(op-kind.proc + ".p")(INPUT in-op-date, INPUT vOpRID) NO-ERROR.
		
		finishDate = TODAY. finishTime = TIME.
		
		/** ������ op-transaction ������ �࠭���樨 */
		FIND LAST op-transaction WHERE
			op-transaction.op-kind = op-kind.op-kind AND
			op-transaction.user-id = USERID("bisquit") AND
			op-transaction.parent = 0 AND
			op-transaction.op-date = in-op-date AND
			op-transaction.beg-date >= startDate AND
			op-transaction.beg-time >= startTime AND
			op-transaction.end-date <= finishDate AND
			op-transaction.end-time <= finishTime AND
			op-undo = no
			NO-LOCK NO-ERROR.
			
		FIND CURRENT code. 
		
		IF AVAIL op-transaction THEN DO:
			code.misc[7] = STRING(op-transaction.op-transaction).
		END.			
		
		vItemVal = TRIM(GetParamByName_ULL(code.description[2], "check-proc", "", ";")).
		/** �࠭�����, ����� ����᪠���� ��� �믮������ ������ ����樨
		    �� �㦭� ��।��� � ��楤��� �஢�ન ����樨 
		*/
		vItemName = TRIM(GetParamByName_ULL(code.description[2], "op-kind", "", ";")).
		IF vItemVal <> "" THEN 
			RUN VALUE(vItemVal)(INPUT in-op-date, INPUT vItemName, INPUT code.misc[1], INPUT code.misc[7]) NO-ERROR.
		
		ON esc go.
				
		FIND CURRENT code.
		
		IF ERROR-STATUS:ERROR THEN DO: 
			code.misc[3] = STRING(TODAY, "99/99/9999") + " " + STRING(TIME, "HH:MM:SS").
			code.val = "�訡��".
			bfrCode.val = code.val.			
		END. ELSE DO:
			code.misc[3] = STRING(TODAY, "99/99/9999") + " " + STRING(TIME, "HH:MM:SS").
			code.val = "�믮�����".
			bfrCode.val = "".			
			BROWSE brwItem:SELECT-NEXT-ROW().
			FIND CURRENT code.
			if code.val = "�믮�����" then bfrCode.val = code.val.
		END.
	END. ELSE DO:
		MESSAGE "�࠭����� '" + vItemVal + "' �� �������!" view-as alert-box. 
	END.
	BROWSE brwItem:REFRESH().

end.

on choose of btn_rollback in frame frmPlan do:

	FIND CURRENT code.
	
	IF code.val <> "�믮�����" THEN DO:
		MESSAGE "������ �� �� �믮��﫠��!" VIEW-AS ALERT-BOX.
		RETURN NO-APPLY. 
	END. ELSE DO:
		find last bfrCode where 
			bfrCode.class = vCode 
			and bfrCode.parent = vCodeFilter
			and bfrCode.code begins entry(1, code.code, "-") 
			and bfrCode.val = "�믮�����" no-lock no-error.
		if avail bfrCode and bfrCode.code <> code.code then do:
			message "����� ������� ��᫥����⥫쭮��� �⪠⮢!" view-as alert-box.
			return no-apply.
		end.
	END.

	MESSAGE "�� ����⢨⥫쭮 ��� �������� ������ '" + code.name:SCREEN-VALUE IN BROWSE brwItem + "' ?" 
		VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
		TITLE "" UPDATE vMessAns.

	FIND FIRST bfrCode WHERE 
		bfrCode.class = vCode AND bfrCode.code = vCodeFilter NO-ERROR.
	
	IF vMessAns THEN DO TRANSACTION:
		code.misc[4] = USERID("bisquit").
		code.misc[5] = STRING(TODAY, "99/99/9999") + " " + STRING(TIME, "HH:MM:SS").
		code.misc[6] = "".
		code.val = "�⪠�뢠����...".
		vOldCodeVal = bfrCode.val.
		bfrCode.val = code.val.
		BROWSE brwItem:REFRESH().
		
		ON esc endkey.

		vItemVal = TRIM(GetParamByName_ULL(code.description[2], "rollback-proc", "", ";")).
		/** �࠭�����, ����� ����᪠���� ��� �믮������ ������ ����樨
		    �� �㦭� ��।��� � ��楤��� �⪠� ����樨 
		*/
		vItemName = TRIM(GetParamByName_ULL(code.description[2], "op-kind", "", ";")).
		IF vItemVal <> "" THEN DO:
			RUN VALUE(vItemVal)(INPUT in-op-date, INPUT vItemName, INPUT code.misc[1], INPUT code.misc[7]) NO-ERROR.
		END.

		ON esc go.
				
		FIND CURRENT code.
		
		IF ERROR-STATUS:ERROR THEN DO: 
			code.misc[6] = STRING(TODAY, "99/99/9999") + " " + STRING(TIME, "HH:MM:SS").
			code.val = "�믮�����".
			bfrCode.val = vOldCodeVal.
		END. ELSE DO:
			code.misc[6] = STRING(TODAY, "99/99/9999") + " " + STRING(TIME, "HH:MM:SS").
			code.val = "".
			bfrCode.val = "".			
			BROWSE brwItem:SELECT-PREV-ROW().
		END.
		BROWSE brwItem:REFRESH().

	END.
	
end.


on choose of btn_exit in frame frmPlan do:

  IF bfrCode.val <> "�믮�����" THEN
    DO:
  
	  DO imes = 1 TO 3:
		MESSAGE /*COLOR RED */
			"����� �� ����-����� �� ������E�� !!!!" SKIP(1)
			"���������� ������ �� �����襭�� ����-���� ????" SKIP(1)
			"(" imes "-� �।�०�����)" 
		VIEW-AS ALERT-BOX /*QUESTION*/ BUTTONS YES-NO TITLE "�������� !!!!" UPDATE confirm_exit .	
		IF confirm_exit = yes THEN LEAVE.
		IF (confirm_exit) = no AND (imes = 3) THEN LEAVE.
		confirm_exit= yes .
          END.  

	  IF confirm_exit = yes THEN RETURN NO-APPLY.

    END. /*END_IF*/

end.



/** ----------------------------------------------*/


vCodeFilter = STRING(YEAR(in-op-date), "9999") + STRING(MONTH(in-op-date),"99") 
	+ STRING(DAY(in-op-date),"99") + bfrCurrentOpKind.op-kind.

vCode  = GetParamByName_ULL(bfrCurrentOpKind.before, "code", "0", ";").



/** �᫨ �� ��諨 �� ������ �㭪� � ��ୠ��, � �� �㭪�� �㦭� ᮧ���� */
FIND FIRST bfrCode WHERE 
	bfrCode.class = vCode AND bfrCode.code = vCodeFilter NO-ERROR.
IF NOT AVAIL bfrCode THEN DO TRANSACTION:
	message "������ ���� ��ୠ� ����権" view-as alert-box.
	CREATE bfrCode.
	bfrCode.class = vCode.
	bfrCode.code = vCodeFilter.
	bfrCode.name = bfrCurrentOpKind.op-kind + " " + STRING(in-op-date, "99/99/9999").
	bfrCode.parent = bfrCode.class.
	
	vItemCount = INT(GetParamByName_ULL(bfrCurrentOpKind.before, "item-count", "0", ";")).
	DO i = 1 TO vItemCount :
		vItemName = "item" + STRING(i) + "-name".
		vItemVal = GetParamByName_ULL(bfrCurrentOpKind.before, vItemName, "��� �����", ";").
		CREATE bfrCode.
		bfrCode.class = vCode.
		bfrCode.code = vCodeFilter + "-" + STRING(i).

		bfrCode.name = vItemVal.
		bfrCode.parent = vCodeFilter.
		
		vItemName = "item" + STRING(i) + "-op-kind".
		vItemVal = GetParamByName_ULL(bfrCurrentOpKind.before, vItemName, "", ";").
		bfrCode.description[2] = "op-kind=" + vItemVal + ";".
		
		vItemName = "item" + STRING(i) + "-canrun-proc".
		vItemVal = GetParamByName_ULL(bfrCurrentOpKind.before, vItemName, "", ";").
		bfrCode.description[2] = bfrCode.description[2] + "canrun-proc=" + vItemVal + ";".

		vItemName = "item" + STRING(i) + "-check-proc".
		vItemVal = GetParamByName_ULL(bfrCurrentOpKind.before, vItemName, "", ";").
		bfrCode.description[2] = bfrCode.description[2] + "check-proc=" + vItemVal + ";".
		
		vItemName = "item" + STRING(i) + "-rollback-proc".
		vItemVal = GetParamByName_ULL(bfrCurrentOpKind.before, vItemName, "", ";").
		bfrCode.description[2] = bfrCode.description[2] + "rollback-proc=" + vItemVal + ";".
		
	END.
END. 

MAIN-BLOCK:
DO 	ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   	ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   	:
   	
		
	/** ᯨ᮪ ������஢ */

	/**********************************
         *				  *
         * �� ���: #844                *
         * ������� ���஢�� � �����.   *
	 *				  *
         **********************************/
	OPEN QUERY qItem FOR EACH code WHERE code.class = vCode AND code.parent begins vCodeFilter BY INT(ENTRY(2,code.code,"-")).

	ENABLE brwItem WITH FRAME frmPlan IN WINDOW TERMINAL-SIMULATION.

	enable btn_next with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
	enable btn_exit with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
	enable btn_rollback with frame frmPlan IN WINDOW TERMINAL-SIMULATION.

	VIEW TERMINAL-SIMULATION.


	IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
   		WAIT-FOR /**CLOSE OF THIS-PROCEDURE*/
   	 		CHOOSE OF btn_exit  IN FRAME frmPlan
    		FOCUS brwItem.
   	END.

END. 

ON esc endkey.


