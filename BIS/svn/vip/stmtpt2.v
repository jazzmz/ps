def var inrub as char format "x(25)" no-undo.

if sh-in-bal > 0 then
   inrub = string(  sh-in-bal, "{&in-format} „").
else if sh-bal < 0 then
   inrub = string(- sh-in-bal, "{&in-format} Š").
else
   inrub = string(  sh-in-bal, "{&in-format}  ").
