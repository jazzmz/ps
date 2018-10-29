{pirsavelog.p}

DEFINE INPUT PARAMETER in-op-date   LIKE op.op-date NO-UNDO.
DEFINE INPUT PARAMETER in-rec-kind  AS   RECID      NO-UNDO.

def var in-beg-date as date no-undo.
def var in-end-date as date no-undo.
{globals.i}


{getdates.i}

assign in-beg-date = beg-date
       in-end-date = end-date.


run pir_vedpr11d.p(in-beg-date,in-end-date).
