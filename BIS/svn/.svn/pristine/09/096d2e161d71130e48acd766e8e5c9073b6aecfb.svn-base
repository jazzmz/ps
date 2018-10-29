      display
&if defined(nodate) eq 0 &then
        stmt.op-date
&endif
        stmt.doc-num
        GetCBDocType1(stmt.doc-type) @ stmt.doc-type
        sacctcur
        string (stmt.amt-cur,"{&in-format}") + " " @ {&this}-rub
        detarr[1].
      down.  
        
      display
    /*    formstr("","(" + trim(string(stmt.amt-rub,"{&in-format}")),22) + ")" @ {&this}-rub
*/
        detarr[2] @ detarr[1].
      down. 

      if hdetail>2 then 
         do idet=3 to hdetail:
            if trim(detarr[idet]) = ""  then next.
            disp
               detarr[idet] @ detarr[1].
            down. 
         end.
