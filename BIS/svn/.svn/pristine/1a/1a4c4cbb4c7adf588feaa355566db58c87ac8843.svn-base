{globals.i}
{joinview.def op}

DEF INPUT PARAM iLevel AS INT64 NO-UNDO.

&GLOBAL-DEFINE DefTmpObj YES


{tmpobj.def}

FIND FIRST T-obj NO-LOCK.
RUN browseld.p (
   "op",
   "op" ,
   STRING(T-obj.rec),
   "doc-num" + CHR(1) + "details",
   iLevel).
