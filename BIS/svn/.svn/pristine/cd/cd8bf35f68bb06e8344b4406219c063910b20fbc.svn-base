def var ii as INT64 no-undo.
def var mPutLog as LOGICAL no-undo INIT NO.
{get-bankname.i}
for each BR:
   IF BR.branch-id NE DataBlock.branch-id THEN  
   DO:
      mPutLog = YES.
      LEAVE.
   END.   
end.                                                  

if mPutLog then 
do:
   put unformatted {2} "--------- {1}  ”ˆ‹ˆ€‹€Œ : ---------" skip.
   for each BR:
      put unformatted {2} cBankName " ‡€ " BR.per skip.
   end.                                                  
   put unformatted {2} fill("-", length("{1}") + 34) skip(1).
end.
