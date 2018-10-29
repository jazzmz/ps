{pirsavelog.p}

DEFINE INPUT PARAMETER in-op-date   LIKE op.op-date NO-UNDO.
DEFINE INPUT PARAMETER in-rec-kind  AS   RECID      NO-UNDO.

{globals.i}

DEF VAR in-cont-code LIKE loan.cont-code NO-UNDO.


FORM
   in-cont-code
WITH FRAME enter-fr CENTERED ROW 4 OVERLAY.
ON F1 OF in-cont-code DO:
   RUN dpsdispc.p ("dps",?,"—",?,5).
   IF pick-value NE ? THEN
      DISPLAY pick-value @ in-cont-code
      WITH FRAME enter-fr.
END.

PAUSE 0.
DO TRANSACTION ON ENDKEY UNDO, LEAVE
   ON ERROR  UNDO, LEAVE:
   UPDATE in-cont-code
   WITH FRAME enter-fr.
END.
HIDE FRAME enter-fr.
IF CAN-FIND(FIRST loan WHERE loan.contract  EQ "DPS"
                         AND loan.cont-code EQ in-cont-code) THEN
run ved-pr10-op.p(in-cont-code) .
