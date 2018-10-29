{globals.i}
{intrface.get instrum}
DEF INPUT  PARAM opLst       AS CHAR NO-UNDO.
DEF INPUT  PARAM cur-op-date AS date NO-UNDO.
DEF OUTPUT PARAM lResult     AS LOG  INIT TRUE NO-UNDO.


DEF VAR mChOpDate   AS LOG INIT true NO-UNDO.
DEF VAR ChVDate     AS LOG INIT true NO-UNDO.
DEF VAR mChDDate    AS LOG INIT true NO-UNDO.
DEF VAR ChIDate     AS LOG INIT true NO-UNDO.
DEF VAR mChContDate AS LOG INIT true NO-UNDO.
DEF VAR mChDocDate  AS LOG INIT true NO-UNDO.
DEF VAR mChSpDate   AS LOG INIT true NO-UNDO.
DEF VAR flager      AS INT64         NO-UNDO.
DEF VAR i           AS INT           NO-UNDO.
DEF VAR currOp      AS INT64         NO-UNDO.

DEF buffer op FOR op.

tt:
DO TRANSACTION ON ERROR UNDO, RETURN:

DO i = 1 TO NUM-ENTRIES(opLst,","):
  currOp = INT64(ENTRY(i,opLst)).
  FIND FIRST op WHERE op EQ currOp EXCLUSIVE-LOCK.

      RUN CheckOpRight IN h_base(RECID(op),?,"ChgDt") NO-ERROR.

                      IF ERROR-STATUS:ERROR THEN DO:
		                MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                                lResult = FALSE.
                                UNDO tt, RETURN.
		      END.
    {chdat(op.i
     &open-undo = "do: lResult = FALSE. UNDO tt. END. "
     &kau-undo  = "do: lResult = FALSE. UNDO tt. END. "
     &undo      = "do: lResult = FALSE. UNDO tt. END. "
     &del-undo  = "DO: lResult = FALSE. undo tt. END."
    }
RELEASE op.
END. /* DO */
END.
