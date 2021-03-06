CLASS TTableDBF INHERITS TTable:

DEFINE PROTECTED VARIABLE cEncoding AS CHARACTER INITIAL "ibm866" NO-UNDO.

DEFINE PROPERTY encoding AS CHARACTER
    GET:
 	 RETURN cEncoding.
    END GET.
  SET (INPUT cProp AS CHARACTER):
		cEncoding = cProp.
    END SET.
 
DEFINE PROTECTED VARIABLE cColLength AS CHARACTER INITIAL "" NO-UNDO.
DEFINE PROTECTED VARIABLE iRowLength AS INTEGER INITIAL 1 NO-UNDO.
DEFINE PROTECTED VARIABLE cFileName AS CHARACTER NO-UNDO.

DEF PRIVATE VAR cColName AS CHARACTER LABEL "������������ �⮫�殢 �१ �������" NO-UNDO.	/* ���檨� ᯮᮡ, 㦥 ��ன ࠧ */

METHOD PUBLIC INTEGER getFieldRight(INPUT iFieldNum AS INTEGER):
 DEF VAR i AS INTEGER NO-UNDO.
 DEF VAR iRes AS INTEGER INITIAL 0 .

    DO i = 1 TO iFieldNum:
      iRes = iRes + INTEGER(ENTRY(i,cColLength)). 
    END.
  RETURN i.
END METHOD.

METHOD PROTECTED VOID fillSetting(INPUT iRecNum AS INTEGER,INPUT aArr AS INTEGER EXTENT):
                        /********************************************
                         * �㭪�� ����� ���ᨢ ����             *
                         * � �������� ᢮��⢠ ����� � DBF.  *
                         ********************************************/
	DEF VAR i AS INTEGER NO-UNDO.
	DEF VAR tmpName AS CHARACTER INITIAL "" NO-UNDO.

        IF iRecNum <> -1 THEN
         DO:   
            /* ���ᨬ ���ᠭ�� ����� */     
            iRowLength = iRowLength + aArr[17].
            cColLength = cColLength + STRING(aArr[17]) + ",".
		DO i = 1 TO 11:
			tmpName = tmpName + STRING(CHR(aArr[i],"ibm866",encoding)).
		END.	    
		cColName = cColName + TRIM(tmpName) + ",".
          END.
          ELSE
             DO:
			/* ����� ��।��塞 ������⢮ ����ᥩ � ⠡��� 
			    ������ 5-8 (� ��⮬ ����� �� 1) ���塞 ���⠬� ���訩 �⠭������� ����訬, 
			    ����騩 ���訬.
			   11-12 ������⢮ ���⮢ ���������� ������� iRowLength.
			   ���檠� ⥬�, �� ��宦� �ਤ���� �� 10�� ��⥬� ���᫥���
			    �८�ࠧ��뢠�� � hex, ��⥬ �ନ஢��� �᫮ � ��⭠����窨
			    � ��⮬ ��������� ࠧ�冷�, � ��⥬ ��ॢ����� � �������� ��⥬� ���᫥���.
			 */
			   
			
	     END.
END METHOD.

CONSTRUCTOR TTableDBF(INPUT cFN AS CHARACTER):
	SUPER().
	cFileName = cFN.
END CONSTRUCTOR.

METHOD PUBLIC VOID LOAD():
			/*************************************************
			 * 												 *
			 * ��������� ⠡���� �� DBF					 *
			 *												 *
			 *************************************************/
&SCOPED-DEFINE iPirHeaderSize 32 	/* ������⢮ ���� � ���ᠭ�� ����� */

DEF VAR i   AS INTEGER INITIAL 0 NO-UNDO.  	/* ���稪 ���⠭��� ���⮢ �� ��������� */                          
DEF VAR iWn AS INTEGER           NO-UNDO.       /* ����� ���⠭���� ���� �⭮�⥫쭮 ��砫� ���ᠭ�� ᢮��� */

DEF VAR oSysClass AS TSysClass NO-UNDO.		/* ������砥� �㦥��� �㭪樨 */

DEF VAR aRecSetting AS INTEGER EXTENT {&iPirHeaderSize} NO-UNDO.   /* �६���� ���ᨢ  � ���ᠭ�� �����/DBF */
DEF VAR isFind13 AS LOGICAL INITIAL true NO-UNDO.  				 /* ��������� �⤥����� �� ⥫� 13 �����? */

/*
 �����᪨ ��ࠦ���� �������� �� 32 ����
 �� ������⢮ ����� � �����. 
��� ��� ��ࢮ� ���� ���� ���ᠭ�� ᠬ��� DBF
䠩��, � �� ���뢠�� ���. 
*/

DEF VAR iFieldCount AS INTEGER INITIAL -1 NO-UNDO. 

/* 
����� ��ப� � �����. 
��稭��� � �������, ⠪ ��� ��� ������ ��ப� 
㪠�뢠���� �ਧ��� 㤠����� � 1 ����. 
*/

/********************
������:
���⮨� �� 3� 蠣��:
 1. ��� ��।��塞 ������⢮ ����� � ⠡���;
 2. ��� ��।��塞 ᢮��⢠ ������� �� �����;
 3. ����砥� �����.
**********************/
oSysClass = new TSysClass().

/************ ��� 1, 2 ***********************/

/* ������ �������� DBF ����� */

INPUT FROM VALUE(cFileName) BINARY NO-CONVERT.

REPEAT WHILE LASTKEY <> -2:
  READKEY.
        IF LASTKEY  = 13 AND i >= 32 THEN
                                        DO:
                                                isFind13 = true.
						LEAVE.
                                        END.  /* ����� ��������� */
                                        ELSE
                                         DO:
                                       
                                          iWn = oSysClass:getRemainder(i,{&iPirHeaderSize},1).
                                          aRecSetting[iWn] = LASTKEY.

                                           IF iWn = {&iPirHeaderSize} THEN 
                                                DO:
						                          fillSetting(iFieldCount,aRecSetting).
                                                  iFieldCount = iFieldCount + 1.
                                                END.
                                          i = i + 1.
                                          END. /* �� ����� ��������� */
END. /* REPEAT �� �ᥬ� ��������� */

/********** ����� 蠣�� 1,2 **************/

createTable(iFieldCount).


/**************** ��� 3************************/


DEF VAR iCurrRow AS INTEGER INITIAL 0 LABEL "������ ��ப�" NO-UNDO.
DEF VAR iCurCol AS INTEGER INITIAL ? LABEL "����騩 �⮫���" NO-UNDO.
DEF VAR iCurrCharInField AS INTEGER LABEL "����� ���� �� ��砫� �����" NO-UNDO.
i = 0. /* ������⢮ ����, ���⠭��� �� ��砫� ⥫� */

DEF VAR cField AS CHARACTER INITIAL "" LABEL "����ন��� ����" NO-UNDO.



/* ������ ���� DBF ����� */
SUBSTRING(cColLength,LENGTH(cColLength),1) = "".

 REPEAT WHILE LASTKEY <> 26 AND LASTKEY <> -2:
  READKEY.

   iCurrCharInField = oSysClass:getRemainder(i,iRowLength ,0).  /* ����騩 ���� �⭮�⥫쭮 ��砫� ����� */
    
         /* ��� ���� �� 㪠��⥫� �� 㤠����� */
        IF iCurCol <> oSysClass:getLineSegment(iCurrCharInField,cColLength) AND iCurrCharInField <> 1 THEN
           DO:
	       /* ���� ����� �⮫�� �� ࠢ��, ��஬�. �� ���� �⮫��� �����稫�� */
                addCell(TRIM(cField)).
                cField = "".
           END.
           IF iCurrCharInField <> 0 THEN cField = cField + CHR(LASTKEY,'ibm866',cEncoding).
     
    IF iCurrCharInField = 0 AND LASTKEY <> 26 THEN
        DO:         
          addRow().
        END.  
	iCurCol = oSysClass:getLineSegment(iCurrCharInField,cColLength).
   i = i + 1. 
 END.

INPUT CLOSE.

DELETE OBJECT oSysClass.

END METHOD.

END CLASS.