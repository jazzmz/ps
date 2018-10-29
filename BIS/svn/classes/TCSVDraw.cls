USING Progress.Lang.*.
CLASS TCSVDraw IMPLEMENTS ITableDraw:

{set-prop.i &aa="p" &cc="TTable2"}
{set-prop.i &aa="splitter" &cc="CHAR" &init="\";\""}



CONSTRUCTOR TCSVDraw():

END CONSTRUCTOR.

CONSTRUCTOR TCSVDraw(INPUT cSp AS CHAR):
 splitter = cSp.
END CONSTRUCTOR.

METHOD PUBLIC VOID setParent(INPUT p AS TTable2):
	THIS-OBJECT:p = CAST(p,TTable2).
END METHOD.

METHOD PUBLIC VOID show():

DEF VAR oRow          AS TAArray    NO-UNDO.
DEF VAR key1          AS CHAR       NO-UNDO.
DEF VAR val1          AS CHAR       NO-UNDO.


IF NOT (THIS-OBJECT:p:getColCount() > 0 AND THIS-OBJECT:p:getRowCount() > 0) THEN RETURN.


THIS-OBJECT:p:rewind().

DO WHILE NOT THIS-OBJECT:p:valid():
  oRow = THIS-OBJECT:p:next(). 

    {foreach oRow key1 val1}
      PUT UNFORMATTED val1 (IF INT64(key1) <> THIS-OBJECT:p:getColCount() THEN splitter ELSE "").
    {endforeach oRow}
      
      PUT UNFORMATTED SKIP.

END. /*  DO WHILE */

END METHOD.

END CLASS.