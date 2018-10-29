USING Progress.Lang.*.

CLASS TTable2 IMPLEMENTS ITplElement,ITable2:


{set-prop.i &aa="currRow"    &cc="INT64" &init="0"}
{set-prop.i &aa="currCell"   &cc="INT64" &init="0"}
{set-prop.i &aa="drawObject" &cc="CLASS OBJECT"}

{set-prop.i &aa="colCount"      &cc="INT64" &init="0"}
{set-prop.i &aa="rowCount"      &cc="INT64" &init="0"}
{set-prop.i &aa="colsWidth"     &cc="TAArray"}
{set-prop.i &aa="colsWidthAuto" &cc="TAArray"}
{set-prop.i &aa="cashColWidth"  &cc="CHAR"  &init="''"}

{set-prop.i &aa="currRecord"    &cc="TAArray"  &perms="PRIVATE"}
{set-prop.i &aa="oProperty"     &cc="TAArray"  &perms="PRIVATE"}
{set-prop.i &aa="currRowPos"    &cc="INT"      &perms="PRIVATE" &init="1"}
{set-prop.i &aa="dDiff"         &cc="INT"      &perms="PRIVATE" &init="0"}

{ttable.def}


CONSTRUCTOR TTable2():
 initObject().
END CONSTRUCTOR.

CONSTRUCTOR TTable2(INPUT i AS INT):
  initObject().
END CONSTRUCTOR.    

METHOD PRIVATE VOID initObject():
  setDraw(NEW TSDraw()).
  colsWidth     = NEW TAArray().
  colsWidthAuto = NEW TAArray().
  currRecord    = NEW TAArray().  
  oProperty     = NEW TAArray().
END METHOD.

DEF PUBLIC PROPERTY colsWidthList AS CHAR
 GET:
  RETURN colsWidth:toList().
 END GET.
 SET (INPUT cList AS CHAR):
     DEF VAR i AS INT NO-UNDO.

     DO i = 1 TO NUM-ENTRIES(cList):
         colsWidth:setH(i,ENTRY(i,cList)).
     END.
 END SET.


DEF PUBLIC PROPERTY colsHeaderList AS CHAR
 GET:
    DEF VAR cRes AS CHAR INIT "" NO-UNDO.

    FOR EACH ttable WHERE y-beg = 0 NO-LOCK BREAK BY x-beg:
      cRes = cRes + ttable.val + ",".
    END.

   RETURN TRIM(cRes,",").
 END GET.
 SET (INPUT cList AS CHAR):
     DEF VAR i   AS INT   NO-UNDO.
     DEF VAR av  AS INT64 NO-UNDO.


     DO i = 1 TO NUM-ENTRIES(cList):
         CREATE tTable.

         ASSIGN
            x-beg = INT(i)
            y-beg = 0
            type  = "CHARACTER"
            val   = ENTRY(i,cList)
         .           

        av = INT64(colsWidthAuto:get(i)).
        av = (IF av = ? THEN 0 ELSE av).

        colsWidthAuto:setH(i,MAXIMUM(av,LENGTH(val))).
     END.

   dDiff    = 1.
   rowCount = rowCount + 1.

END SET.

DEF PUBLIC PROPERTY headerArray AS TAArray
 GET:
    DEF VAR oRes AS TAArray NO-UNDO.

    FOR EACH ttable WHERE y-beg = 0 NO-LOCK BREAK BY x-beg:
      oRes:setH(x-beg,val).
    END.

   RETURN oRes.
 END GET.

 SET (INPUT oList AS TAArray):
     DEF VAR i    AS INT   NO-UNDO.
     DEF VAR av   AS INT64 NO-UNDO.

     DEF VAR key1 AS CHAR NO-UNDO.
     DEF VAR val1 AS CHAR NO-UNDO.

     {foreach oList key1 val1}

        CREATE tTable.

         ASSIGN
            x-beg = INT(key1)
            y-beg = 0
            type  = "CHARACTER"
            val   = val1
         .           

        av = INT64(colsWidthAuto:get(key1)).
        av = (IF av = ? THEN 0 ELSE av).

        colsWidthAuto:setH(i,MAXIMUM(av,LENGTH(val))).

     {endforeach oList}     


   dDiff    = 1.
   rowCount = rowCount + 1.

END SET.






METHOD PUBLIC HANDLE getTable():
  RETURN BUFFER tTable:HANDLE.
END METHOD.

METHOD PUBLIC TTable2 addRow():

ASSIGN
  currRow  = currRow  + 1
  currCell = 0
  rowCount = rowCount + 1
 .
RETURN THIS-OBJECT.
END METHOD.

METHOD PRIVATE CHAR clearCellValue(INPUT cValue AS CHAR):
  DEF VAR content   AS CHAR      NO-UNDO.


   content  = IF cValue = ? THEN "" ELSE cValue.
   content  = REPLACE(content,CHR(10)," ").
   content  = REPLACE(content,CHR(13)," ").

 RETURN content.
END METHOD.


METHOD PROTECTED TTable2 addCell(INPUT cValue AS CHARACTER,cType AS CHARACTER):

 DEF VAR av        AS INT64     NO-UNDO.


 currCell = currCell + 1.


CREATE tTable.
ASSIGN
   x-beg  = currCell
   y-beg  = currRow  
   type   = cType
   val    = clearCellValue(cValue).
 .

   colCount = MAXIMUM(colCount,currCell).   

   av = INT64(colsWidthAuto:get(currCell)).
   av = IF av = ? THEN 0 ELSE av.

   colsWidthAuto:setH(currCell,MAXIMUM(av,LENGTH(val))).

RETURN THIS-OBJECT.
END METHOD.

METHOD PUBLIC TTable2 addCell(INPUT cValue AS CHAR):
 addCell(STRING(cValue),"CHARACTER").
 RETURN THIS-OBJECT.
END METHOD.

METHOD PUBLIC TTable2 addCell(INPUT cValue AS DEC):
 addCell(STRING(cValue),"DECIMAL").
RETURN THIS-OBJECT.
END METHOD.

METHOD PUBLIC TTable2 addCell(INPUT cValue AS DATE):
 addCell(STRING(cValue),"DATE").
RETURN THIS-OBJECT.
END METHOD.

METHOD PUBLIC TTable2 addCell(INPUT cValue AS INT64):
 addCell(STRING(cValue),"INT64").
RETURN THIS-OBJECT.
END METHOD.

METHOD PUBLIC TTable2 addCell(INPUT cValue AS INT):
 addCell(STRING(cValue),"INT").
RETURN THIS-OBJECT.
END METHOD.

METHOD PUBLIC TTable2 addCell(INPUT cValue AS LOG):
 addCell(STRING(cValue),"LOG").
RETURN THIS-OBJECT.
END METHOD.

METHOD PUBLIC TTable2 setDraw(INPUT cObject AS CLASS OBJECT):
 drawObject = cObject. 
 RETURN THIS-OBJECT.
END METHOD.

METHOD PUBLIC TTable2 setColWidth(INPUT iCol AS INT64,INPUT width AS INT64):
 colsWidth:setH(iCol,width).
 RETURN THIS-OBJECT.
END METHOD.

METHOD PUBLIC TTable2 setColWidth(INPUT width AS INT64): 
 RETURN setColWidth(currCell,width).
END METHOD.

METHOD PUBLIC TAArray getColsWidth():
 RETURN colsWidth.
END METHOD.

METHOD PUBLIC TAArray getColsWidthAuto():
 RETURN colsWidthAuto.
END METHOD.

METHOD PUBLIC INT64 getColWidth(INPUT iCol AS INT):
  DEF VAR manColWidth AS INT64 NO-UNDO.
  manColWidth = INT64(getColsWidth():get(iCol)).

  RETURN (IF manColWidth <> ? THEN manColWidth ELSE getColsWidthAuto():get(iCol)).
END METHOD.

METHOD PUBLIC TTable2 rewind():
   currRowPos = 1 - dDiff.   
END METHOD.

/**
 * Возвращает содержимое строки в виде списка.
 **/
METHOD PUBLIC TAArray next():
   currRecord:empty().
   FOR EACH ttable WHERE y-beg = currRowPos NO-LOCK BY y-beg BY x-beg:
      currRecord:setH(x-beg,val).
   END.   
   currRowPos = currRowPos + 1.
   RETURN currRecord.
END METHOD.

METHOD PUBLIC TAArray next(OUTPUT iCurrRow AS INT64):
   currRecord:empty().
   iCurrRow   = currRowPos.
   FOR EACH ttable WHERE y-beg = currRowPos NO-LOCK BY y-beg BY x-beg:
      currRecord:setH(x-beg,val).
   END.   
   currRowPos = currRowPos + 1.
   RETURN currRecord.
END METHOD.


METHOD PUBLIC LOG valid():
    RETURN (IF currRowPos + dDiff > rowCount THEN TRUE ELSE FALSE).    
END METHOD.

METHOD PROTECTED VOID cashColWidth():
   DEF VAR key1   AS CHAR NO-UNDO.
   DEF VAR value1 AS CHAR NO-UNDO.
   
  {foreach colsWidthAuto key1 value1}
    cashColWidth = cashColWidth + (IF colsWidth:get(key1) <> ? THEN colsWidth:get(key1) ELSE colsWidthAuto:get(key1)) + ",".
  {endforeach colsWidthAuto}
  
  {foreach colsWidth key1 value1}
    cashColWidth = cashColWidth + (IF colsWidth:get(key1) <> ? THEN colsWidth:get(key1) ELSE colsWidthAuto:get(key1)) + ",".
  {endforeach colsWidth}
  
END METHOD.    

METHOD PUBLIC VOID show():   
  cashColWidth().     
  CAST(drawObject,ITableDraw):setParent(THIS-OBJECT).
  CAST(drawObject,ITableDraw):show().
END METHOD.


METHOD PUBLIC VOID setPropertyByStr(INPUT cPropertyName AS CHARACTER,INPUT cPropertyValue AS CHARACTER):
        CASE cPropertyName:
                WHEN "colsWidthList"    THEN colsWidthList   = cPropertyValue.
                WHEN "colsHeaderList"   THEN colsHeaderList  = cPropertyValue.
                OTHERWISE DO:
                      oProperty:setH(cPropertyName,cPropertyValue).
                END.
        END CASE.
END METHOD.


METHOD PUBLIC CHAR getProperty(INPUT cProperty AS CHAR):
  RETURN oProperty:get(cProperty).
END METHOD.

METHOD PUBLIC VOID setIsInTpl(INPUT cProp AS LOGICAL):

END METHOD.

METHOD PUBLIC TTable2 fillCells(INPUT iCellCount AS INT,INPUT cValue AS CHAR):
   DEF VAR i AS INT NO-UNDO.
   DO i = 1 TO iCellCount:
       THIS-OBJECT:addCell(cValue).
   END.
 RETURN THIS-OBJECT.
END METHOD.

/**
 * @var cFileName Путь к XML файлу с XML данными
 * Выгружает данные в XML файл.
 **/
METHOD PUBLIC VOID dump(INPUT cFileName AS CHAR):
 TEMP-TABLE ttable:WRITE-XML("file",cFileName,TRUE,?,?,NO,NO).
END METHOD.

/**
 * @var cFileName Путь к XML файлу с данными
 * @return LOG
 * Загружает данные из XML файла.
 **/
METHOD PUBLIC LOG load(INPUT cFileName AS CHAR):
    TEMP-TABLE ttable:READ-XML("file",cFileName,"EMPTY",?,?,?,?).
    RETURN TRUE.
END METHOD.         

METHOD PUBLIC INT64 getColCount():
  RETURN colCount.
END METHOD.

METHOD PUBLIC INT64 getRowCount():
  RETURN rowCount.
END METHOD.

METHOD PUBLIC VOID SAVE-TO(INPUT cFileName AS CHAR):
  OUTPUT TO VALUE(cFileName).	    /* Перенаправляем поток в файл */
          THIS-OBJECT:show().
  OUTPUT CLOSE.
END METHOD.

/**
 * @var cFileName Путь к файлу CSV
 * @var cDELIMITER Разделитель в строке
 * @return TTable
 * Загружает в TTable содержимое файла с разделителями 
**/
METHOD PUBLIC TTable2 LoadFromCSV(INPUT cFileName AS CHAR,INPUT cDELIMITER AS CHAR):
  def var cSTR     as char no-undo. 
  DEF VAR key1     AS CHAR NO-UNDO.
  DEF VAR val1     AS CHAR NO-UNDO.
  DEF VAR oAArray  AS TAArray   NO-UNDO.

  INPUT FROM value(cFileName).
    repeat:
	IMPORT DELIMITER "~n" cSTR.
        THIS-OBJECT:addRow().
        oAArray = NEW TAArray().
        oAArray:loadSplittedList(cSTR,cDELIMITER,TRUE).
        {foreach oAArray key1 val1}
	  THIS-OBJECT:addCell(val1).
        {endforeach oAArray}
        DELETE OBJECT oAArray.
    end.

  RETURN THIS-OBJECT.
END METHOD.

DESTRUCTOR TTable2():
 DELETE OBJECT colsWidthAuto.
 DELETE OBJECT colsWidth.
 DELETE OBJECT currRecord.
 DELETE OBJECT oProperty.
 DELETE OBJECT drawObject.
END DESTRUCTOR.

END CLASS.