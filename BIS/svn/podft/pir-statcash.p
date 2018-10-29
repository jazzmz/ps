/***** ================================================================= *****/
/*** 	����� � ��ୠ��� ��� �� �뤠�� ������� �� ���� (�����䨪��� PirStatCash)
	����� � ��ࠬ��஬:
	0 - ���� �� ��࠭��� ��� �� ����
	1 - ���� ����樮���⮬ ��� � ��᫥���饩 ������ �ᥣ� ��ୠ��
	2 - ।���஢���� ��� (�⢥ত����/�����) ���㤭���� �����
	3 - ०�� ��� ।���஢���� �10-1 
	4 - ०�� ��� ।���஢���� ���
	5 - ᮧ����� ��� �� ���㬥��� (������ ���)
	6 - ०�� �⢥ত���� ��� 童���� �ࠢ�����
	���� ����᪠                                                      ***/
/***** ================================================================= *****/



{intrface.get tmess} 
{globals.i}
{pir-statcash.i}


/***** ================================================================= *****/
/*** 	          ������� ���������, ���������� � ��.                      ***/
/***** ================================================================= *****/


DEF INPUT PARAMETER vCode as CHAR.

DEF VAR cOpDate AS DATE NO-UNDO.
DEF VAR cAcct   AS CHAR format "x(20)" NO-UNDO.
DEF VAR cSum    AS DEC /*INT*/  NO-UNDO.
DEF VAR cDetls  AS CHAR format "x(20)" NO-UNDO.
DEF VAR cOnlnInitr AS CHAR INIT "" NO-UNDO.
DEF VAR newcOpDate AS DATE NO-UNDO.

DEF VAR strOpDate	AS CHAR INIT "" NO-UNDO.
DEF VAR CdCode		AS CHAR INIT "" NO-UNDO.
DEF VAR CdName		AS CHAR INIT "" NO-UNDO.
DEF VAR CdVal 		AS CHAR INIT "" NO-UNDO.
DEF VAR ResStCash 	AS INT  INIT 0  NO-UNDO.


cOpDate = gend-date .


/***** ================================================================= *****/
/*** 	   ������ � ����������   0  -   ���� �� �����䨪���� ���     ***/
/***** ================================================================= *****/

IF vcode = "0" THEN 
DO:

	FORM
	   cOpDate
	      FORMAT "99/99/9999"
	      LABEL  "���"  
	      HELP   "��� ��࠭��� ���"

	WITH FRAME fSet0 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ������� ���� ������� ������ ]".


	ON F1 OF cOpDate DO:
	   RUN calend.p.
	   IF    (   LASTKEY EQ 13 
	          OR LASTKEY EQ 10) 
	      AND pick-value NE ?
	   THEN FRAME-VALUE = pick-value.
	   RETURN NO-APPLY.
	END.
	
	PAUSE 0.
	
	UPDATE
	   cOpDate
        WITH FRAME fSet0.
	
        HIDE FRAME fSet0 NO-PAUSE.
        
	IF NOT (   KEYFUNC(LASTKEY) EQ "GO" 
	        OR KEYFUNC(LASTKEY) EQ "RETURN") 
	THEN LEAVE.
	
	strOpDate = CreateStrOpDtStCash(cOpDate) .

	RUN VALUE( STRING("pir-statcash-prnt.p") )( INPUT STRING(strOpDate) )  NO-ERROR.

END. /* IF vcode = "0" */ 





/***** ================================================================= *****/
/*** 	   ������ � ����������   1  -   ०�� ����� ��� ����樮����      ***/
/***** ================================================================= *****/

IF vcode = "1" THEN 
DO:
	
	FORM
	   cOpDate
		FORMAT "99/99/9999"	LABEL  "��� ��"	HELP   "��� ��࠭��� ���"
	   cAcct	
		FORMAT "X(20)"		LABEL  "���"		HELP   "������ ����� ��� F1 - ��㧥� ��⮢)"
	   cSum
		FORMAT ">>>>>>>>9" 	LABEL  "�㬬�"		HELP   "�㬬�"
	   cDetls
		FORMAT "X(40)"		LABEL  "��� ��室�"	HELP   "������ ��� ��室�"


	WITH FRAME fSet1 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ������� ������ ������ ]".


  /*** ��� �� ***/
	ON F1 OF cOpDate DO:
	   RUN calend.p.
	   IF    (   LASTKEY EQ 13 
	          OR LASTKEY EQ 10) 
	      AND pick-value NE ?
	   THEN FRAME-VALUE = pick-value.
	   RETURN NO-APPLY.
	END.

  /*** ��� ***/ 
	ON "F1" OF cAcct IN FRAME fSet1
	DO:
	   DO TRANSACTION:
	      RUN browseld.p ("acct",
                      "RetRcp" + CHR(1) + "RetFld",
                      STRING(cAcct:HANDLE IN FRAME fSet1) + CHR(1) + "acct",
                      ?,
                      "5").
	   END.
	END.
	
	ON "LEAVE" OF cAcct IN FRAME fSet1
	DO:
	   ASSIGN
	      cAcct 
	   .
	END.

  /*** �㬬� ***/ 
	ON LEAVE OF cSum IN FRAME fSet1
	DO:
	   ASSIGN
	      cSum 
	   .
  	END.
	
  /*** ��� ��室� ***/
	ON F1 OF cDetls DO:
	  /* RUN currbrw.p */
	   IF    (   LASTKEY EQ 13 
	          OR LASTKEY EQ 10) 
	      AND pick-value NE ?
	   THEN FRAME-VALUE = pick-value.
	   RETURN NO-APPLY.
	END.


	ON "ENTER" OF FRAME fSet1 ANYWHERE 
	DO:
	    APPLY "TAB" TO SELF. 
	END.


	ON "GO" OF FRAME fSet1 ANYWHERE 
	DO:
	   ASSIGN
	      cOpDate 
	      cAcct
	      cSum
	      cDetls
	   .
	

	   IF NOT CAN-FIND(FIRST acct WHERE acct.acct EQ cAcct ) THEN
	   DO:
	      RUN Fill-SysMes ("", "", "-1", 
                       "��� " + STRING(cAcct ) + " �� �������.").
	      APPLY "Entry" TO cAcct  IN FRAME fSet1.
	      RETURN NO-APPLY.
	   END.

	   IF (cSum = 0 OR  cSum = ?) THEN
	   DO:
	      RUN Fill-SysMes ("", "", "-1", 
                       "�㬬� ����୮ ������!").
	      APPLY "Entry" TO cSum  IN FRAME fSet1.
	      RETURN NO-APPLY.
	   END.

	   IF (cDetls = ? OR cDetls = "") THEN
	   DO:
	      RUN Fill-SysMes ("", "", "-1", 
                       "��� ���� ����୮ �����!").
	      APPLY "Entry" TO cDetls  IN FRAME fSet1.
	      RETURN NO-APPLY.
	   END.

	END.  
/*
	MESSAGE "vcode = 1 ; cSum = " cSum "cAcct = " cAcct "cOpDate = " cOpDate "cDetls  = " cDetls VIEW-AS ALERT-BOX.
*/
  /*** ���堫������� ***/ 		
	DO TRANSACTION
	  ON ERROR  UNDO, RETRY 
	  ON ENDKEY UNDO, RETURN 
	  WITH FRAME fSet1 :

	   PAUSE 0.

	   UPDATE 
	      cOpDate
	      cAcct 
	      cSum
	      cDetls
	   .

	   strOpDate = CreateStrOpDtStCash(cOpDate) .
	   CdCode    = CreateCdCodeStCash(cAcct,strOpDate) .
	   CdName    = CreateCdNameStCash(cAcct,STRING(cSum),cDetls,cOnlnInitr) .
	   CdVal     = CreateCdValStCash("�� ����஫�஢���","","") .

	   ResStCash = CreateReqstStCash(strOpDate, CdCode, CdName, CdVal ) .

	   IF ResStCash = 1 THEN
	   DO:	
		MESSAGE "����� ��������" VIEW-AS ALERT-BOX.
		 /* ����� ��楤��� ���� �����䨪��� ��� */
           	 /* MESSAGE "������ ������ "  strOpDate VIEW-AS ALERT-BOX. */
	   	RUN VALUE( STRING("pir-statcash-prnt.p") )( INPUT STRING(strOpDate) )  NO-ERROR.
	   END.	
 
	END.  /*** �ਥ堫� ***/
	
	HIDE FRAME fSet1 NO-PAUSE.

  
END. /* IF vcode = "1" */ 





/***** ================================================================= *****/
/*** 	   ������ � ����������   2  -   ०�� ��� ।���஢���� �����     ***/
/*** 	                         3  -   ०�� ��� ।���஢���� �10-1     ***/
/*** 	                         4  -   ०�� ��� ।���஢���� ���    ***/
/*** 	                         6  -   ०�� ��� ।���஢���� ���    ***/
/***** ================================================================= *****/

IF vcode = "2" OR vcode = "3" OR vcode = "4" OR vcode = "6" THEN 
DO:

	FORM
	   cOpDate
	      FORMAT "99/99/9999"
	      LABEL  "���"  
	      HELP   "��� ��࠭��� ���"

	WITH FRAME fSet2 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ������� ���� ������� ������ ]".


	ON F1 OF cOpDate DO:
	   RUN calend.p.
	   IF    (   LASTKEY EQ 13 
	          OR LASTKEY EQ 10) 
	      AND pick-value NE ?
	   THEN FRAME-VALUE = pick-value.
	   RETURN NO-APPLY.
	END.
	
	PAUSE 0.
	
	UPDATE
	   cOpDate
        WITH FRAME fSet2.
	
        HIDE FRAME fSet2 NO-PAUSE.
        
	IF NOT (   KEYFUNC(LASTKEY) EQ "GO" 
	        OR KEYFUNC(LASTKEY) EQ "RETURN") 
	THEN LEAVE.
	
	strOpDate = CreateStrOpDtStCash(cOpDate) .

		 /* MESSAGE "������ ������ �������������� ����� pir-statcash-podft.p " strOpDate VIEW-AS ALERT-BOX. */
	IF vcode = "2" THEN
        	RUN VALUE( STRING("pir-statcash-podft.p") )( INPUT STRING(strOpDate) )  NO-ERROR.

		 /* MESSAGE "������ ������ �������������� �10-1 pir-statcash-u101.p " strOpDate VIEW-AS ALERT-BOX. */
	IF vcode = "3" THEN
        	RUN VALUE( STRING("pir-statcash-u101.p")  )( INPUT STRING(strOpDate) )  NO-ERROR.

		 /* MESSAGE "������ ������ �������������� ������ ����� pir-statcash-ed.p " strOpDate VIEW-AS ALERT-BOX. */
	IF vcode = "4" THEN
        	RUN VALUE( STRING("pir-statcash-ed.p")  )( INPUT STRING(strOpDate) )  NO-ERROR.
		 /* MESSAGE "������ ������ ����������� ������� ��������� pir-statcash-edruk.p " strOpDate VIEW-AS ALERT-BOX. */
	IF vcode = "6" THEN
        	RUN VALUE( STRING("pir-statcash-edruk.p")  )( INPUT STRING(strOpDate) )  NO-ERROR.



	 /* MESSAGE "������ ������ " strOpDate VIEW-AS ALERT-BOX. */
	RUN VALUE( STRING("pir-statcash-prnt.p") )( INPUT STRING(strOpDate) )  NO-ERROR.

END. /* IF vcode = "2" OR vcode = "3" OR vcode = "4" OR vcode = "6" */ 





/***** ================================================================= *****/
/*** 	   ������ � ����������   5  -   ᮧ����� ��� �� ���㬥���      ***/
/***** ================================================================= *****/

IF vcode = "5" THEN 
DO:

  MESSAGE "������ ��� � ��ୠ�� ��� �� �뤠�� ������� �१ ����� ?" 
	VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mChange AS LOG.

  IF mChange = ? OR mChange = NO THEN 
  DO:
	MESSAGE "��� �� ��������! ��室��!" VIEW-AS ALERT-BOX.
	RETURN .
  END.

	/* ����ࠥ� ����� �� ���㬥��� */ 

  {tmprecid.def}
  FOR FIRST tmprecid NO-LOCK,
  FIRST op WHERE RECID(op) = tmprecid.id 
  NO-LOCK:

    cAcct = "" . 

    FOR EACH op-entry OF op NO-LOCK:

	IF op-entry.currency = "" THEN
	  cSum = cSum + op-entry.amt-rub . 
	ELSE 
	  cSum = cSum + op-entry.amt-cur . 

	IF cAcct = "" THEN 
	  cAcct = op-entry.acct-db  .
	ELSE 
	DO: 
	  IF cAcct <> op-entry.acct-db  THEN
		DO: 
		  MESSAGE "��� �� ��������! � �஢����� ࠧ�� ���! ��室��!" VIEW-AS ALERT-BOX.
		  RETURN.
		END.
	END.
    END.

    cOpDate = op.op-date .
    cDetls  = TRIM(REPLACE(op.details,",",""))    .

  END.
  {empty tmprecid}

	/* �� ࠧ�訫 ������ ������ ��� */ 
  RUN browseld.p ("code",
		"class" + CHR(1) +
		"parent",  /* ���� ��� �।��⠭����. */
	        "PirSightOP" + CHR(1) + 
		"Visa9OnlnInit",   /* ���᮪ ���祭�� �����. */
	        ?,  /* ���� ��� �����஢��. */
	        "5" /* ��ப� �⮡ࠦ���� �३��. */
		).
  FOR FIRST tmprecid ,
  FIRST code
	WHERE tmprecid.id = recid(code)
  NO-LOCK:
	cOnlnInitr = code.name .
  END.
/*
  MESSAGE "vcode = 5 ; cSum = " cSum " cAcct = " cAcct " cOpDate = " cOpDate " cDetls  = " cDetls " cOnlnInitr= " cOnlnInitr VIEW-AS ALERT-BOX.
*/
  IF cOnlnInitr = "" THEN
  DO:
	MESSAGE "��� �� ��������! ��室��!" VIEW-AS ALERT-BOX.
	RETURN .
  END.

  IF ( cSum - TRUNCATE(cSum,0) ) > 0 THEN
    cSum = cSum + 1 .

  strOpDate = CreateStrOpDtStCash(cOpDate) .
  CdCode    = CreateCdCodeStCash(cAcct,strOpDate) .
  CdName    = CreateCdNameStCash(cAcct,STRING(cSum),cDetls,cOnlnInitr) .
  CdVal     = CreateCdValStCash("�� ����஫�஢���","","") .

  ResStCash = CreateReqstStCash(strOpDate, CdCode, CdName, CdVal ) .

  IF ResStCash = 1 THEN
	DO:
	  MESSAGE "����� ��������" VIEW-AS ALERT-BOX.
		/* ���뫠���� 㢥�������� � ��������� ��� */ 
	  RUN pir-statcash-mail.p (INPUT CdCode)  NO-ERROR.
	END.
 
END. /* IF vcode = "5" */ 




/***** ================================================================= *****/
/*** 	   ������ � ����������   7  -   ०�� ��� ।���஢���� �����     ***/
/***** ================================================================= *****/

IF vcode = "7"  THEN 
DO:

	FORM
	   cOpDate
	   FORMAT "99/99/9999"	LABEL  "��� ��ୠ�� ��� (���筨�)"  HELP   "��� ��ୠ�� ��� (���筨�)"
	   newcOpDate
	   FORMAT "99/99/9999"	LABEL  "� ����� ���� �����㥬"		 HELP   "� ����� ���� �����㥬"
	WITH FRAME fSet7 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ������� � ����� ���� �������� ? ]".


	ON F1 OF newcOpDate DO:
	   RUN calend.p.
	   IF    (   LASTKEY EQ 13 
	          OR LASTKEY EQ 10) 
	      AND pick-value NE ?
	   THEN FRAME-VALUE = pick-value.
	   RETURN NO-APPLY.
	END.

	PAUSE 0.
	
	UPDATE
	   cOpDate
	   newcOpDate
        WITH FRAME fSet7.
	
        HIDE FRAME fSet7 NO-PAUSE.
        
	IF NOT (   KEYFUNC(LASTKEY) EQ "GO" 
	        OR KEYFUNC(LASTKEY) EQ "RETURN") 
	THEN LEAVE.


		 /* MESSAGE "������ ��������� ����������� pir-statcash-copy.p " VIEW-AS ALERT-BOX. */
	IF vcode = "7" THEN
        	RUN VALUE( STRING("pir-statcash-copy.p") )( INPUT CreateStrOpDtStCash(cOpDate) + "," + CreateStrOpDtStCash(newcOpDate) ) )  NO-ERROR.

END. /* IF vcode = "7" */ 



{preview.i}
