/*********
 */

{globals.i}
{tmprecid.def}

DEF VAR currDate AS DATE NO-UNDO.
{getdate.i}
currDate = end-date.
DISABLE TRIGGERS FOR LOAD OF op.
FOR EACH tmprecid,
  FIRST op WHERE RECID(op) EQ tmprecid.id:
  op.doc-date = currDate.
END.