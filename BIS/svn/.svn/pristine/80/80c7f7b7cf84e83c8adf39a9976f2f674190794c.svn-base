{pirsavelog.p}

DEFINE INPUT PARAMETER in-op-date   LIKE op.op-date NO-UNDO.
DEFINE INPUT PARAMETER in-rec-kind  AS   RECID      NO-UNDO.

def var in-beg-date as date no-undo.
def var in-end-date as date no-undo.
def var work-date as date no-undo.
def var mTip as character no-undo.
def var mVal as character no-undo.

{globals.i}

assign work-date = end-date . 


{getdates.i}


assign in-beg-date = beg-date
       in-end-date = end-date.

run messmenu.p(
    10,
    "[Валюта]",
    "",
    "Рубли," +
    "Доллары," +
    "Евро"
).

CASE integer(pick-value):
    WHEN 1 THEN mVal = "810". 
    WHEN 2 THEN mVal = "840".
    WHEN 3 THEN mVal = "978".
    OTHERWISE RETURN.
END CASE.
run messmenu.p(
    10,
    "[Тип договора]",
    "",
    "До востребования," +
    "Срочный"
).

CASE integer(pick-value):
    WHEN 1 THEN mTip = "Вост". 
    WHEN 2 THEN mTip = "fixed".
    OTHERWISE RETURN.
END CASE.


run pir_vedpr11r.p(work-date,in-beg-date,in-end-date,mVal,mTip).
