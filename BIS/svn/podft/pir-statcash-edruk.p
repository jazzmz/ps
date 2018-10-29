
/***** ================================================================= *****/
/*** 	��楤�� ।���஢���� ��ୠ�� ��� �� �뤠�� ������� 
	�� ���� (�����䨪��� PirStatCash) 
	��� 童��� �ࠢ�����
	�室��� ��ࠬ��� - ��� ��.��� ��ୠ�� (�������� - ⨯ CHAR)
	����� - �� ��楤��� pir-statcash.p (� ��ࠬ��஬ 4)              ***/
/***** ================================================================= *****/
{globals.i}
{ulib.i}
{pir-statcash.i}


/***** ================================================================= *****/
/*** 	          ������� ���������, ���������� � ��.                      ***/
/***** ================================================================= *****/

DEF INPUT PARAM iOpDate AS CHAR.
/* MESSAGE "pir-statcash-edruk.p  INPUT PARAM iOpDate = "  iOpDate VIEW-AS ALERT-BOX. */

DEF VAR cCause  AS CHAR    NO-UNDO.
DEF VAR cKlName AS CHAR    NO-UNDO.

DEF VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.

DEF QUERY qItem FOR code.

DEF BROWSE brwItem QUERY qItem 

DISPLAY	
	(IF NUM-ENTRIES(code.name,";") >= 4 THEN ENTRY(4,code.name,";") ELSE "" ) FORMAT "x(5)" LABEL "���"
	GetClientInfo_ULL(ENTRY(3,code.code,"_") + "," + ENTRY(1,code.code,"_"), "name", false)  FORMAT "x(25)" LABEL "������"
	ENTRY(1,code.name,";") FORMAT "x(20)" LABEL "���"
	ENTRY(2,code.name,";") FORMAT "x(12)" LABEL "�㬬�"
	ENTRY(3,code.name,";") FORMAT "x(25)" LABEL "��� ����"
	ENTRY(1,code.val ,";") FORMAT "x(20)" LABEL "����� �����"
	(IF NUM-ENTRIES(code.val ,";") >= 3 THEN STRING(ENTRY(2,code.val ,";") + " " +  ENTRY(3,code.val ,";")) ELSE "" ) FORMAT "x(70)" LABEL "��稭�"
	ENTRY(5,code.name,";") FORMAT "x(10)" LABEL "����訫 ������ ������ �����"
	(IF NUM-ENTRIES(code.description[1],";") >= 3 THEN ENTRY(3,code.description[1],";") ELSE "" ) format "x(20)" LABEL "�⢥न� 童� �ࠢ�����"
WITH 10 DOWN WIDTH 73 NO-LABELS.


DEF BUTTON btn_approve	LABEL "���������".
DEF BUTTON btn_hist     LABEL "�����".
DEF BUTTON btn_histbrw  LABEL "��ୠ�".
DEF BUTTON btn_exit	LABEL "��室".


DEF FRAME frmPlan 
	brwItem at row 1 column 1 skip
	" " btn_approve SPACE(3) btn_histbrw HELP "F4 - ��室 �� ��ୠ��" btn_hist SPACE(10) btn_exit 
  WITH CENTERED OVERLAY SIZE 75 BY 18 TITLE STRING("��ୠ� ��� �� " + iOpDate).

DEF FRAME fCause 
 	"��� 童�� �ࠢ�����:"	cCause	FORMAT "X(40)" SKIP(1) 
 WITH CENTERED NO-LABELS TITLE "��������".



TERMINAL-SIMULATION = CURRENT-WINDOW.
ASSIGN CURRENT-WINDOW                = TERMINAL-SIMULATION 
       THIS-PROCEDURE:CURRENT-WINDOW = TERMINAL-SIMULATION.


ON ESC GO.


/***** ================================================================= *****/
/*** 	                                                                   ***/
/***** ================================================================= *****/

	/*** ������ ����� ***/

ON CHOOSE OF btn_exit IN FRAME frmPlan DO:
	LEAVE .
END.

	/*** ������ ��������� ***/
ON CHOOSE OF btn_approve IN FRAME frmPlan DO:

	FIND CURRENT code.

	IF ENTRY(1,code.val,";") = "����������" THEN
	  DO:
		MESSAGE "��� 㦥 �⢥ত���!" VIEW-AS ALERT-BOX.
		RETURN NO-APPLY.
	  END.

	IF ENTRY(1,code.val,";") = "��������" THEN
	  DO:
		MESSAGE "��� 㦥 �뤠����. ����� ����୮ �⢥न��!" VIEW-AS ALERT-BOX.
		RETURN NO-APPLY.
	  END.

	IF ENTRY(4,code.name,";") = "DEL" THEN
	  DO:
		MESSAGE "��� �뫠 �⬥祭� ��� 㤠������. �� ����� �⢥न��!" VIEW-AS ALERT-BOX.
		RETURN NO-APPLY.
	  END.


	IF ENTRY(1,code.val,";") <> "��������" AND ENTRY(1,code.val,";") <> "����������" AND ENTRY(4,code.name,";") <> "DEL" THEN
	  DO:


		IF ENTRY(1,code.val,";") <> "����������" THEN
		DO:
			MESSAGE "��������: ��� �� �뫠 �⢥ত��� �����! �� �筮 ��� �� �⢥न��?" 
			  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mChange AS LOG.
			IF mChange = ? OR mChange = NO THEN 
			DO:
				MESSAGE "��� �� �⢥�����! ��室��!" VIEW-AS ALERT-BOX.
				RETURN NO-APPLY.
		  	END.
		END.


			/*** ���� ��������� ***/
		cCause = "" .

		DISPLAY cCause WITH FRAME fCause.
		SET cCause WITH FRAME fCause.
		HIDE FRAME fCause.

		code.description[1] = "1;ACT;" + REPLACE(cCause,",","") + ";" . /* �ਧ���, �� ��� ����� �뤠���� � �� ��� ��⨢��� */
			/* �⠢�� �ਧ��� �ࠢ�� 童�� �ࠢ����� */
		code.name = EditCdNameStCash(code.name,"RUK","","") .		
		MESSAGE "��� �⢥ত���" VIEW-AS ALERT-BOX TITLE "�������".

	  END.

	BROWSE brwItem:REFRESH().

END.



	/*** ������ ������� ***/
ON CHOOSE OF btn_hist IN FRAME frmPlan DO:

	FIND CURRENT code.

	RUN VALUE( "pir-statcash-hist.p" )( INPUT STRING(code.class + "," + code.code) )  NO-ERROR.

	BROWSE brwItem:REFRESH().

END.


	/*** ������ ������ ***/
ON CHOOSE OF btn_histbrw IN FRAME frmPlan DO:

	FIND CURRENT code.

	RUN browseld.p 
		("history",
		"file-name" + CHR(1) +
		"field-ref" ,			/* ���� ��� �।��⠭����. */
	        "code" + CHR(1) + 
		"PirStatCash," + code.code ,	/* ���᮪ ���祭�� �����. */
	        ?,	/* ���� ��� �����஢��. */
	        "5"	/* ��ப� �⮡ࠦ���� �३��. */
		) .

	BROWSE brwItem:REFRESH().

END.



/***** ================================================================= *****/
/*** 	                                                                   ***/
/***** ================================================================= *****/

MAIN-BLOCK:
DO 	ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   	ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   	:

	OPEN QUERY qItem 
		FOR EACH code WHERE code.class = "PirStatCash"  
			      AND  code.parent = iOpDate  
		.

	ENABLE brwItem WITH FRAME frmPlan IN WINDOW TERMINAL-SIMULATION.

	ENABLE btn_approve with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
	ENABLE btn_hist    with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
	ENABLE btn_histbrw with frame frmPlan IN WINDOW TERMINAL-SIMULATION.
	ENABLE btn_exit	   with frame frmPlan IN WINDOW TERMINAL-SIMULATION.


	VIEW TERMINAL-SIMULATION.

	IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
   		WAIT-FOR /**CLOSE OF THIS-PROCEDURE*/
   	 		CHOOSE OF btn_exit  IN FRAME frmPlan
    		FOCUS brwItem.
   	END.

END. 

ON ESC END-ERROR.
