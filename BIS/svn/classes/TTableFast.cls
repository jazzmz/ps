CLASS TTableFast IMPLEMENTS ITplElement:
/**********************************************
 * ��� ��� �뢮�� ⠡���� � ࠧ��� �ଠ��    *
***********************************************/
DEF PROTECTED VAR hTBuffer AS HANDLE.

DEF PRIVATE VAR iCurrField AS INTEGER INITIAL 1.


DEF PRIVATE VAR itabWidth AS INTEGER INITIAL 0 LABEL "��ਭ� ⠡����, ��� ��� ࠧ����⥫��".
DEF PRIVATE VAR ccolsHeaderList AS CHARACTER INITIAL "" LABEL "��������� �⮫�殢 �१ �������".
DEF PRIVATE VAR crowsHeaderList AS CHARACTER INITIAL "" LABEL "��������� ��ப �१ �������".



DEF PROTECTED VAR icolWidthByDef AS INTEGER INITIAL 1 LABEL "��ਭ� �⮫�� ��-㬮�砭��".

DEF PROTECTED VAR isInTpl AS LOGICAL INITIAL false LABEL "����뢠�� �ᯮ������ �� ��������� � 蠡��������".

DEF PROTECTED VAR aColsWidth AS INTEGER EXTENT LABEL "���ᨢ � �ਭ�� �⮫�殢. �������� ��� ���ᨬ��쭮� �� ����� ���祭�� ����".

DEF PRIVATE VAR aColsName AS CHARACTER EXTENT LABEL "������������ �⮫�殢".

DEF PROTECTED VAR iRow0Width AS INTEGER INITIAL 0  LABEL "��ਭ� ��������� ��ப".

{set-prop.i &aa="inTableHandle" &bb="hTTable" &cc="HANDLE" permv="PROTECTED" perms="PROTECTED"}

{set-prop.i &aa="colsCount" &bb="iColsCount" &cc="INTEGER" &perms="PRIVATE"}	/* ��⠭�������� ������⢮ �⮫�殢 ⠡���� */
{set-prop.i &aa="InnerBorder" &bb="linnerBorder" &cc="LOGICAL" &init = "true"}		/* ����७��� ࠬ��: ��, ���				*/
{set-prop.i &aa="colsWidthList" &bb="ccolsWidthList" &cc="CHARACTER"}			/* ��ਭ� �⮫�殢 �१ �������*/
{set-prop.i &aa="colsAlignList" &bb="ccolsAlignLis" &cc="CHARACTER"}			/* ��ࠢ������� � �祩��� �� �ਭ�, �१ ������� */
{set-prop.i &aa="height" &bb="itabHeight" &cc="INTEGER" &perms="PROTECTED"}	/* ���� ⠡���� */
{set-prop.i &aa="wordwrap" &bb="lisWW" &cc="LOGICAL" &init = "true"}				/* ��������� �� ᫮��� */

/* ���᮪ � ������� ���������� */
DEFINE PROPERTY colsHeaderList AS CHARACTER
	GET:
		RETURN ccolsHeaderList.
	END GET.

	SET (INPUT cProp AS CHARACTER):
		DEFINE VARIABLE i AS INTEGER.		

		 DO i = 1 TO  NUM-ENTRIES(cProp):
					aColsWidth[i] = MAXIMUM(aColsWidth[i],LENGTH(ENTRY(i,cProp))).
		 END.

		ccolsHeaderList = cProp.
	END SET.

/* ���᮪ � ������� ���������� ��ப */
DEFINE PROPERTY rowsHeaderList AS CHARACTER
	GET:
		RETURN crowsHeaderList.
	END GET.

	SET (INPUT cProp AS CHARACTER):
		DEF VAR i AS INTEGER.
		DO i = 1 TO NUM-ENTRIES(cProp):
			iRow0Width = MAXIMUM(iRow0Width,LENGTH(ENTRY(i,cProp))).
		END.
		crowsHeaderList = cProp.
	END SET.




/* ��ਭ� ⠡���� */
DEFINE PROPERTY width AS INTEGER
	GET:	
		DEFINE VARIABLE i AS INTEGER.
		DEFINE VARIABLE tmpWidth AS INTEGER.

		DO i = 1 TO ColsCount:
			tmpWidth = tmpWidth + getColWidth(i).
		END.
		RETURN tmpWidth.
	END GET.
       PRIVATE SET (INPUT cProp AS INTEGER):
		itabWidth = cProp.
	END SET.

/* ���� ⠡���� */




METHOD PUBLIC VOID setIsInTpl(INPUT cProp AS LOGICAL):
	IsInTpl = cProp.
END METHOD.

CONSTRUCTOR TTableFast():
END CONSTRUCTOR.
CONSTRUCTOR TTableFast(INPUT iCols AS INTEGER):
createTable(iCols).
END CONSTRUCTOR.

METHOD PROTECTED VOID createTable(INPUT iCols AS INTEGER):
		/*********************************************************************
		 *												       *
		 * 1. ������塞 ����७��� ᢮��⢠ ��-㬮�砭��.	       *
		 * 2. ������� ����७��� ⠡����;					       *
		 * ������� ⠡����. ��� �� ᮧ����� ����室���	               *
		 * ������⢮ �⮫�殢.							               *
		 *												       *
		 *********************************************************************/
		DEFINE VARIABLE i AS INTEGER.

		 ColsCount = iCols.
		
		 EXTENT(aColsWidth) = ColsCount.		/* ������ ������⢮ �⮫�殢 ��� ���ᨢ� �ਭ� */
		 EXTENT(aColsName) = ColsCount.       		/* ������ ����७��� ������������ �⮫�殢            */

		 DO i = 1 TO ColsCount:
			aColsWidth[i] = icolWidthByDef.		/* ������塞 ���祭��� ��-㬮�砭�� */
			aColsName[i] = "field" + STRING(i).	/* �᫨ ���� �� �����७�, � �⮫��� �������� field<�����> */
	 	 END.

  	         CREATE TEMP-TABLE hTTable.

		DO i = 1 TO ColsCount:
			hTTable:ADD-NEW-FIELD(getColName(i),"CHARACTER").
        	END.
	   hTTable:TEMP-TABLE-PREPARE("hTTable").
	   hTBuffer = hTTable:DEFAULT-BUFFER-HANDLE.

END METHOD.


METHOD PROTECTED CHARACTER getColName(INPUT i AS INTEGER):
						/**********************************************************
						 * 										      *
						 * �����頥� ����७�� ������������ �⮫��    *
						 *										       *
						***********************************************************/
		RETURN aColsName[i].

END METHOD.

METHOD PROTECTED CHARACTER getColHeader(INPUT i AS INTEGER):
					/*********************************************************
					 * 										    *
					 * �����頥� ��������� �⮫�� � ����஬ i	    *
					 *										    *
					 *********************************************************/

	IF i <=  NUM-ENTRIES(colsHeaderList) THEN
		DO:
			IF ENTRY(i,colsHeaderList) <> "" THEN RETURN ENTRY(i,colsHeaderList).
		END.
   RETURN "".
END METHOD.

METHOD PROTECTED CHARACTER getRowHeader(INPUT i AS INTEGER):
					/*********************************************************
					 * 										    *
					 * �����頥� ��������� �⮫�� � ����஬ i	    *
					 *										    *
					 *********************************************************/

	IF i <=  NUM-ENTRIES(rowsHeaderList) THEN
		DO:
			IF ENTRY(i,rowsHeaderList) <> "" THEN RETURN ENTRY(i,rowsHeaderList).
		END.
   RETURN "".
END METHOD.

METHOD PROTECTED CHARACTER getColAlign(INPUT i AS INTEGER):
					/**************************************************************
					 * 										            *
					 * �����頥� ��ࠢ������� � �⮫�� � ����஬ i	    *
					 *										            *
					 *************************************************************/

	IF i <=  NUM-ENTRIES(colsAlignList) THEN
		DO:
			IF ENTRY(i,colsAlignList) <> "" THEN RETURN ENTRY(i,colsAlignList).
		END.
   RETURN "".
END METHOD.

METHOD PROTECTED INTEGER getColWidth(INPUT i AS INTEGER):
					/*********************************************************
					 * 										    *
					 * �����頥� �ਭ� �⮫�� � ����஬ i	    *
					 *										    *
					 *********************************************************/
IF i <=  NUM-ENTRIES(colsWidthList) THEN
    DO:
	        IF ENTRY(i,colsWidthList) <> ""  THEN RETURN INTEGER(ENTRY(i,colsWidthList)).
    END.
  RETURN aColsWidth[i].
END METHOD.

METHOD PUBLIC VOID addRow():
				     /*******************************************
				      *								     *
				      * �������� ��ப� � ⠡���	     *
				      *								     *
				      *******************************************/
	hTBuffer:BUFFER-CREATE().
	iCurrField = 1.
	height = height + 1.

END METHOD.


METHOD PUBLIC VOID addCell(INPUT cValue AS CHARACTER):
				    /**********************************************
				     *									 *
				     * �������� �祩�� � ��ப� ⠡����     *
				     *									 *
				     ***********************************************/
	IF cValue EQ ? THEN cValue = "".

	hTBuffer:BUFFER-FIELD(getColName(iCurrField)):BUFFER-VALUE = cValue.
	aColsWidth[iCurrField] = MAXIMUM(LENGTH(cValue),aColsWidth[iCurrField]).
	iCurrField = iCurrField + 1.
END METHOD.

METHOD PUBLIC VOID addCell(INPUT dValue AS DECIMAL):
				    /**********************************************
				     *									 		    *
				     * �������� �祩�� � ��ப� ⠡����     		    *
				     *									 		    *
				     ***********************************************/
	addCell(STRING(dValue)).
END METHOD.

METHOD PUBLIC VOID addCell(INPUT iValue AS INTEGER):
				    /**********************************************
				     *									 		    *
				     * �������� �祩�� � ��ப� ⠡����     		    *
				     *									 		    *
				     ***********************************************/
	addCell(STRING(iValue)).
END METHOD.

METHOD PUBLIC VOID addCell(INPUT daValue AS DATE):
				    /**********************************************
				     *									 		    *
				     * �������� �祩�� � ��ப� ⠡����     		    *
				     *									 		    *
				     ***********************************************/
addCell(STRING(daValue)).
END METHOD.

METHOD PROTECTED VOID showInnerLine():
				/***************************************************
				 *									    *
				 * ����� ����७�� ��ப� ⠡����		    *
				 *									    *
				 ***************************************************/
	DEF VAR iLength AS INTEGER.
	iLength = width + ColsCount + iRow0Width.
	IF iRow0Width = 0 THEN iLength = iLength - 1.
	PUT UNFORMATTED "�" FILL("-",iLength) "�" SKIP.
END METHOD.

METHOD PROTECTED VOID showOuterLine(INPUT lPutSkip AS LOGICAL):
				/***************************************************
				 *									    			    *
				 * ����� ������ ��ப� ⠡����		    		    *
				 *									    			    *
				 ***************************************************/
	DEF VAR iLength AS INTEGER.
	iLength = width + ColsCount + iRow0Width.
	IF iRow0Width = 0 THEN iLength = iLength - 1.

	PUT UNFORMATTED "�" FILL("�",iLength) "�".
	IF lPutSkip THEN PUT UNFORMATTED SKIP.
END METHOD.

METHOD PRIVATE VOID showRow(INPUT iRow AS INTEGER):
				/***************************************************
				 *									    *
				 * ��⮤ ���� �� ��࠭� ��ப� ⠡����     *
				 *									    *
				 ****************************************************/
	DEF VAR i AS INTEGER.
	DEF VAR j AS INTEGER.

	DEF VAR maxHeight AS INTEGER INITIAL 1.
	DEF VAR oCharacter AS TCharacter.

	/* 
		�������� ��� ��ਠ�� �ᮢ����:
		1. ������� ���� ��७���� �� ᫮���;
		2. �� ᫮��� �� ��७�ᨬ, � ���� ���� ��१���, ���� �����ࠥ� �ਭ�
			��� ��ࢮ�� ���� ������ �뢮�� ��⮨� �� ���� 蠣��
				1.  �� ��ࢮ� 蠣� ��।��塞 ���ᨬ����� �� ���� �ࠧ�;
				2. �� ��஬ 蠣� �뢮��� �����筮 ��ப�.
			��� ��ண� ���� ������ ��⮨� ⮫쪮 �� ��ண� 蠣�.
	*/
	IF wordwrap THEN
		DO:
			/* ��।��塞 ����� �ࠧ� */
			DO i = 1 TO ColsCount:
				oCharacter = new TCharacter(hTBuffer:BUFFER-FIELD(getColName(i)):BUFFER-VALUE).
				   oCharacter:align = getColAlign(i).
		  	           oCharacter:width = getColWidth(i).
				   maxHeight = MAXIMUM(maxHeight,oCharacter:height).
				DELETE OBJECT oCharacter.				
			END.
		END.

	DO j = 1 TO maxHeight:
		/* �� �ᥬ ��ப�� �ࠧ� */
		/* ��砫� ����� */
			PUT UNFORMATTED "�".
			/* ����� ��㥬 ��������� ��ப */
			IF iRow0Width <> 0 THEN
			  DO:
				oCharacter = new TCharacter(getRowHeader(iRow + 1)).
				      oCharacter:align = "center".
				      oCharacter:width = iRow0Width.
				      oCharacter:show(j).			   
			        DELETE OBJECT oCharacter.
				IF  i <> ColsCount  	THEN PUT UNFORMATTED "|".
			  END.
		 
		DO i = 1 TO  ColsCount: 
			oCharacter = new TCharacter(hTBuffer:BUFFER-FIELD(getColName(i)):BUFFER-VALUE).
			      oCharacter:align = getColAlign(i).
			      oCharacter:width = getColWidth(i).
			      oCharacter:show(j).			   
			     DELETE OBJECT oCharacter.

		    	IF InnerBorder THEN 
						DO:
							IF  i <> ColsCount  	THEN PUT UNFORMATTED "|".
						END.
						ELSE IF i <> ColsCount THEN PUT UNFORMATTED " ".
		END. /* ����� �� �⮫�栬 */
	 PUT UNFORMATTED "�" SKIP.
	  PUT UNFORMATTED SKIP.
        END. /* ����� �� ��ப�� �ࠧ, � ���� ����� ��ப� */

END METHOD.

METHOD PUBLIC VOID show():
			/********************************************
			 *								 *
			 * ����� ⠡����					 *
			 *								 *
			 ********************************************/
   DEFINE VARIABLE hQuery AS HANDLE.
   DEFINE VARIABLE i AS INTEGER.
   DEFINE VARIABLE iRowAI AS INTEGER INITIAL 1 LABEL "���稪 �뢮����� ��ப".
   DEFINE VARIABLE oCharacter AS TCharacter.

/******************* ������ ���������   ***********************/
showOuterLine(true).
IF colsHeaderList <> "" THEN
 DO:
   PUT UNFORMATTED "�".
   IF iRow0Width <> 0 THEN 
		DO:
		      oCharacter = new TCharacter(getRowHeader(1)).
		      oCharacter:align = "center".
		     oCharacter:width = iRow0Width.
		     oCharacter:show().
	        DELETE OBJECT oCharacter.
		 PUT UNFORMATTED "�".
		END.
   DO i = 1 TO ColsCount:
	oCharacter = new TCharacter(getColHeader(i)).
	 oCharacter:align = "LEFT".
	 oCharacter:width = getColWidth(i).
         oCharacter:show().
        DELETE OBJECT oCharacter.
	PUT UNFORMATTED "�".
   END.
PUT UNFORMATTED SKIP.
showOuterLine(true).
END.

/*************************  ������ �������� �����		******************************/
  /* �뢮��� �� ��࠭ ⠡���� */
   CREATE QUERY hQuery.
   hQuery:SET-BUFFERS(hTBuffer).
   hQuery:QUERY-PREPARE("FOR EACH hTTable").

   hQuery:QUERY-OPEN().

	        hQuery:GET-FIRST(NO-LOCK).

		REPEAT WHILE NOT hQuery:QUERY-OFF-END:
		IF InnerBorder AND iRowAI <> 1 THEN showInnerLine().		/* �� ��ࢠ� ����� */
		         showRow(iRowAI).
		hQuery:GET-NEXT(NO-LOCK).
		iRowAI = iRowAI + 1.
		END. /* �� �ᥬ ��ப�� ⠡���� */
	     hQuery:QUERY-CLOSE().
	showOuterLine(NOT isInTpl).
DELETE OBJECT hQuery.
END METHOD.

METHOD PUBLIC VOID setPropertyByStr(INPUT cPropertyName AS CHARACTER,INPUT cPropertyValue AS CHARACTER):
	CASE cPropertyName:
		WHEN "colsHeaderList" THEN colsHeaderList = cPropertyValue.
		WHEN "colsWidthList"	  THEN colsWidthList = cPropertyValue.
		WHEN "colsAlignList"	  THEN colsAlignList = cPropertyValue.
		WHEN "InnerBorder"	  THEN InnerBorder = LOGICAL(cPropertyValue).
		WHEN "wordwrap"		  THEN wordwrap = LOGICAL(cPropertyValue).
		WHEN "rowsHeaderList"  THEN rowsHeaderList = cPropertyValue.
	END CASE.
END METHOD.
METHOD PUBLIC CHAR getProperty(INPUT cPropertyName AS CHAR):
return "".
END METHOD.

METHOD PUBLIC LOGICAL COPY-TO(INPUT-OUTPUT hHandle AS HANDLE,INPUT cTableName AS CHARACTER):
						/*************************************************
						 *									                         *
						 * ��⮤ ������� ����७��� ᮤ�ন��� 			 *
						 * � Dynamic TEMP-TABLE �� 㪠��⥫� hHandle	 *
						 *												 *
						 *************************************************/

			DEF VAR hQuery AS HANDLE.
			DEF VAR hTTable AS HANDLE.

	/* ������� ⠡���� �� 㪠��⥫� � �筮 ⠪�� �� ��।�������, ��� � ����७���� �।�⠢����� */
	CREATE TEMP-TABLE hHandle.
	hHandle:CREATE-LIKE(inTableHandle).
	hHandle:TEMP-TABLE-PREPARE(cTableName).

	hTTable = inTableHandle.

   CREATE QUERY hQuery.
   hQuery:SET-BUFFERS(hTTable:DEFAULT-BUFFER-HANDLE).
   hQuery:QUERY-PREPARE("FOR EACH hTTable").
    hQuery:QUERY-OPEN().       
    hQuery:GET-FIRST().
       REPEAT WHILE NOT hQuery:QUERY-OFF-END:         
          hHandle:DEFAULT-BUFFER-HANDLE:BUFFER-CREATE().
          hHandle:DEFAULT-BUFFER-HANDLE:BUFFER-COPY(hTTable:DEFAULT-BUFFER-HANDLE).
          hQuery:GET-NEXT().
       END.

     hTTable = ?.
END METHOD.

METHOD PUBLIC VOID SAVE-TO(INPUT cFileName AS CHARACTER):
					/**************************************************
					 *												   *
					 * ��⮤ ��࠭�� ⠡���� � 㪠����� 䠩�		   *
					 * ��८�।������ � ������ ��᫥������		   *
					 *												   *
					 **************************************************/

END METHOD.

DESTRUCTOR PUBLIC TTableFast():
/* EMPTY TEMP-TABLE hTTable. */
 DELETE OBJECT hTTable.
END DESTRUCTOR.

END CLASS.