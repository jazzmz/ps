/**********************************
 * Врапер для импорта XML в УТ !!! *
**********************************/
DEFINE INPUT PARAMETER cFileName AS CHARACTER.
DEFINE NEW SHARED VARIABLE hTTable AS HANDLE.
CREATE TEMP-TABLE hTTable.
hTTable:READ-XML("FILE",cFileName,"EMPTY",?,?,?,?).
RETURN STRING(hTTable).