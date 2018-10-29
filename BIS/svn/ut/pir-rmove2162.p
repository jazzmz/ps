/*************************************************************
 * Процедура меняет привязки в договорах согласно перечню.   *
 *
 *  При этом следует имет ввиду:
 *   1. К договору может быть привязан один и тот же счет, но 
 * в разные моменты времени;
 *   2. Овердрафты могу быть привязаны к портфелю и счета
 * должны наследоваться с портфеля.
 **************************************************************
 * Автор : Маслов Д. А. Maslov D. A.
 * Заявка: #2162
 * Дата  : 08.12.13
 **************************************************************/

{bislogin.i}
{globals.i}
DEF INPUT PARAM cFileName AS CHAR NO-UNDO.

DEF VAR oTable AS TTable2 NO-UNDO.
DEF VAR line   AS CHAR    INIT "" NO-UNDO.
DEF TEMP-TABLE ttTable LIKE loan-acct.

oTable = NEW TTable2().


PROCEDURE doMove:
DEF INPUT PARAM cStr   AS LONGCHAR    NO-UNDO.
DEF INPUT PARAM oTable AS TTable2 NO-UNDO.
DEF VAR oA     AS TAArray NO-UNDO.
DEF VAR key1   AS CHAR NO-UNDO.
DEF VAR val1   AS CHAR NO-UNDO.

DEF BUFFER bufLoanAcct FOR loan-acct.


oA = NEW TAArray().
 oA:loadListInLines(cStr,"|").
 {foreach oA key1 val1}

 oTable:addRow()
       :addCell(">" + key1)
       :addCell(val1)
       :addCell("")
       :addCell("")
       :addCell("").

   FOR EACH loan-acct WHERE CAN-DO(key1,loan-acct.acct) NO-LOCK,
      FIRST loan OF loan-acct WHERE close-date EQ ? AND
      CAN-DO("ПК-001/07,ПК-001/11,ПК-001/12,ПК-003/12,ПК-004/08,ПК-005/11,ПК-006/10,ПК-008/09,ПК-008/12,ПК-016/12,ПК-025/05,ПК-043/04,ПК-100/04,ПК-143/04,!ПК*,*",loan.cont-code) NO-LOCK BY since DESC:

      CREATE ttTAble.
      BUFFER-COPY loan-acct TO ttTable.
      ASSIGN
       ttTable.acct = val1
       ttTable.since = 01/09/2013
      .

      IF NOT CAN-FIND(bufLoanAcct WHERE 
        bufLoanAcct.contract  = loan-acct.contract 
    AND bufLoanAcct.cont-code = loan-acct.cont-code 
    AND bufLoanAcct.acct-type = loan-acct.acct-type
    AND bufLoanAcct.since     = 01/09/2013) THEN DO:
      oTable:addRow()
      :addCell(loan-acct.cont-code)
      :addCell(loan-acct.acct-type)
      :addCell(loan-acct.acct)
      :addCell(loan-acct.since)
      :addCell(val1).
       CREATE bufLoanAcct.
       BUFFER-COPY ttTable TO bufLoanAcct.
      END.
      EMPTY TEMP-TABLE ttTable.
   END.
 {endforeach oA}
 DELETE OBJECT oA.


END PROCEDURE.

INPUT FROM VALUE(cFileName).
REPEAT:

 READKEY.

   CASE LASTKEY:
    WHEN -2 THEN LEAVE.      
    WHEN 13 THEN DO:
      IF line <> "" THEN DO:
        RUN doMove(line,oTable).
        line = "".
      END.
    END.
    OTHERWISE DO:
      line = line + CHR(LASTKEY).
    END.
 END.
END. /*REPEAT*/

{setdest.i}
oTable:show().
{preview.i}
DELETE OBJECT oTable.