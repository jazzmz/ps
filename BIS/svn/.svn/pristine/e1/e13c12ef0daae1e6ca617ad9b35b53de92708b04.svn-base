def var cacct like acct.acct init "*" format "x(25)" no-undo .
def var filt as logical .
def var sec-cod1 like acct.currency format "xxxx" init "*".
def var q  as int extent 12 initial [1,1,1,4,4,4,7,7,7,10,10,10] no-undo.
def var h  as int extent 12 initial [1,1,1,1,1,1,7,7,7,7,7,7] no-undo.
def var menu-c as char extent 6 no-undo.
def var dat1 as date no-undo .
{ pick-val.i }

pause 0.
if end-date eq ? then do:
   end-date = fGetLastClsDate(?,"d").
end.

beg-date = TODAY - INTEGER(iParmStr).
end-date = TODAY - INTEGER(iParmStr).
cacct = "*".
sec-cod1 = "*".

if cacct eq "*" then filt = yes .
else filt = no.
