{intrface.get loan}
{pir-gp.i}
DEF INPUT PARAM loanNum  AS CHARACTER NO-UNDO.
DEF INPUT PARAM dParam   AS INT  NO-UNDO.
DEF INPUT PARAM dDate    AS DATE NO-UNDO.
DEF OUTPUT PARAM dResult AS DECIMAL NO-UNDO.

dResult = getParam(loanNum,dParam,dDate).
{intrface.del}