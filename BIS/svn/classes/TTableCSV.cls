CLASS TTableCSV INHERITS TTable:
/*************************************************************
 * ����� ⠡��� ��� ������ 䠩��� �� �ଠ CSV				*
 * ⥪��, ࠧ������� �����묨								*
 *************************************************************/
DEF PRIVATE VAR iCurrRow AS INTEGER INITIAL 0.

{set-prop.i &aa="filename" &bb="cFileName" &cc="CHARACTER"}
{set-prop.i &aa="splitter"    &bb="cSplitter"     &cc="CHARACTER" &init='";"'}
{set-prop.i &aa="encoding" &bb="cEncoding" &cc="CHARACTER" &init='"ibm866"'}

CONSTRUCTOR TTableCSV(INPUT cFN AS CHARACTER):
	SUPER().
	cFileName = cFN.
END CONSTRUCTOR.

CONSTRUCTOR TTableCSV(INPUT iCols AS INTEGER):
	SUPER(iCols).
END CONSTRUCTOR.

METHOD PROTECTED VOID fillTableRecord(INPUT cStr AS CHARACTER):
			/******************************************
			 * ������塞 ⠡���� ����묨 �� CSV		   *
			 ******************************************/
	 DEF VAR iColsCount AS INTEGER.
	 DEF VAR i AS INTEGER.

    iColsCount = NUM-ENTRIES(cStr,splitter).

    IF iCurrRow = 1 THEN createTable(iColsCount).	/* �� ��ࢮ� 蠣� �� 㧭��� ᪮�쪮 �⮫�殢 � ��ப� � ����� ᮧ���� ⠡���� */

    addRow().

    DO i = 1 TO iColsCount:
		/* �� �ᥬ �⮫�栬 � ��ப� */
		addCell(ENTRY(i,cStr,splitter)).
    END.

END METHOD.

METHOD PUBLIC VOID LOAD():
			/****************************************
			 *								             *
			 * ��⮤ ����㦠�� CVS 䠩�� � ⠡����  *
			 *									      *
			 *****************************************/
  DEF VAR cString AS CHARACTER INITIAL "".
 
        INPUT FROM VALUE(cFileName) BINARY NO-CONVERT.
	REPEAT WHILE LASTKEY <> -2:
		/* �� �ᥬ� 䠩�� */
		READKEY.
		IF LASTKEY <> 10 THEN cString = cString + CHR(LASTKEY,"ibm866",encoding).
									     ELSE
										 DO:
											/* ��諨 ����� ��ப� */
											iCurrRow = iCurrRow + 1.
											fillTableRecord(cString).		/* ������� ������ � ⠡���� */
											cString = "".					/* ���⨬ ��ப� */
										 END.  /* ����� ���� ����� ��ப� */
		
	END. /* ����� REPEAT */
END METHOD.

METHOD PUBLIC OVERRIDE VOID SAVE-TO(INPUT cFileName AS CHARACTER):

   DEF VAR i AS INTEGER INITIAL 0.    /* ���稪 ⥪�饣� �⮫�� */

        OUTPUT TO VALUE(cFileName).	    /* ��७��ࠢ�塞 ��⮪ � 䠩� */

		FOR EACH ttCellBuffer NO-LOCK BY ttCellBuffer.y-beg BY ttCellBuffer.x-beg:
                                    i = i + 1.
                                    CAST(ttCellBuffer.TableCell,TCharacter):show().
                                    PUT UNFORMATTED splitter.

                                    IF i + 1 > ColsCount THEN
                                        DO:
                                            PUT UNFORMATTED SKIP.
                                            i = 0.
                                        END.

		END.
    PUT UNFORMATTED SKIP.    /* ��ନ���� ��易⥫��, ���� ��᫥���� ��ப� ⠡���� �㤥� ��� ���� */
    OUTPUT CLOSE.				           /* ����뢠�� ��⮪ */

END METHOD.

END CLASS.