      display
&if defined(nodate) eq 0 &then
         stmt.op-date 
&endif
         stmt.doc-num
         GetCBDocType1(stmt.doc-type) @ stmt.doc-type
         stmt.bank-code 
         sacctcur
         stmt.amt-rub @ sh-{&this}
         detarr[1].
      down. 
      
      if hdetail > 1 then
         do idet = 2 to hdetail:
            if trim (detarr[idet]) eq "" then next.
             display

&if defined(nodate) eq 0 &then
             "" @ stmt.op-date 
&endif
             "" @ stmt.doc-num
             "" @ stmt.doc-type
             "" @ stmt.bank-code
             "" @ sacctcur
             "" @ sh-db
             "" @ sh-cr 
             detarr[idet] @ detarr[1].
           down.           
         end.
         
 