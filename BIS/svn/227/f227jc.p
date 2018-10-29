{joincalc.def op}
{intrface.get xclass}
{intrface.get db2l}

FOR EACH op WHERE op.op EQ INT64(DataLine.Sym4) NO-LOCK:
CREATE t-obj.
T-obj.rec = op.op.
END.

{intrface.del}
RETURN "".
