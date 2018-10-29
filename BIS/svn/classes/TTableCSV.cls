CLASS TTableCSV INHERITS TTable:
/*************************************************************
 * Класс таблица для импорта файлов из форма CSV				*
 * текст, разделенный запятыми								*
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
			 * Заполняем таблицу данными из CSV		   *
			 ******************************************/
	 DEF VAR iColsCount AS INTEGER.
	 DEF VAR i AS INTEGER.

    iColsCount = NUM-ENTRIES(cStr,splitter).

    IF iCurrRow = 1 THEN createTable(iColsCount).	/* На первом шаге мы узнали сколько столбцов в строке и можем создать таблицу */

    addRow().

    DO i = 1 TO iColsCount:
		/* По всем столбцам в строке */
		addCell(ENTRY(i,cStr,splitter)).
    END.

END METHOD.

METHOD PUBLIC VOID LOAD():
			/****************************************
			 *								             *
			 * Метод загружает CVS файла в таблицу  *
			 *									      *
			 *****************************************/
  DEF VAR cString AS CHARACTER INITIAL "".
 
        INPUT FROM VALUE(cFileName) BINARY NO-CONVERT.
	REPEAT WHILE LASTKEY <> -2:
		/* По всему файлу */
		READKEY.
		IF LASTKEY <> 10 THEN cString = cString + CHR(LASTKEY,"ibm866",encoding).
									     ELSE
										 DO:
											/* Нашли конец строки */
											iCurrRow = iCurrRow + 1.
											fillTableRecord(cString).		/* Добавим запись в таблицу */
											cString = "".					/* Очистим строку */
										 END.  /* Конец ЕСЛИ конец строки */
		
	END. /* Конец REPEAT */
END METHOD.

METHOD PUBLIC OVERRIDE VOID SAVE-TO(INPUT cFileName AS CHARACTER):

   DEF VAR i AS INTEGER INITIAL 0.    /* Счетчик текущего столбца */

        OUTPUT TO VALUE(cFileName).	    /* Перенаправляем поток в файл */

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
    PUT UNFORMATTED SKIP.    /* Терминатор обязателен, иначе последняя строка таблицы будет без него */
    OUTPUT CLOSE.				           /* Закрываем поток */

END METHOD.

END CLASS.