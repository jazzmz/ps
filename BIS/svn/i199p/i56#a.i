for each op-entry
   where op-entry.acct-cat  eq cur-cat
     and op-entry.op-status >= gop-status
     /* добавил Кунташев в связи с переносом документов в следующий день */
     and (if DataBlock.Branch-id = "00002" then op-entry.op-date >= DataBlock.end-date
          else op-entry.op-date   <= DataBlock.end-date)
     and op-entry.op-date   >= DataBlock.beg-date
     and op-entry.prev-year eq fl
     and not (op-entry.currency gt "" and op-entry.amt-cur eq 0)
     
  
  {&and} no-lock,
   first op
   where op.op eq op-entry.op 
   /* добавил Кунташев в связи с переносом документов в следующий день */
         and (if DataBlock.Branch-id = "00002" then DataBlock.end-date eq op.doc-date
                                            else DataBlock.end-date eq op.op-date)
         no-lock
   break by op-entry.user-id by op-entry.op by op-entry.op-entry

   with frame fopp:

   {i56#.ii}
   {op-cash.i}
   if not isCash then next.

   if     adb ne ? 
      and acr ne ? 
      and (bra-db = branch.branch-id or bra-cr = branch.branch-id) 
   then do:
      {i56#.cr}
   end.
end. /* конец сбора информации */

/* считаем количество документов - не работает */
for each xentry 
   break by xentry.op:
   xentry.num = if first-of(xentry.op) 
                then 1 
                else 0.
end.
