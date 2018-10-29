{pirsavelog.p}

/*
	Š PŒˆ‚…‘’€‘—…’
	¥ç âì à ¡®ç¥£® ¯« ­  áç¥â®¢.

  16.11.2006 10:32
*/

{globals.i}


def var b1name as char extent 10.
def var b2name as char extent 10.
def var mCount as integer init 2.
def var mCont as integer init 2.
def var vLast as logical.
def var vLastCode as logical.
def var sig as integer.
def var itog as integer no-undo.
def var FirstDate as c no-undo.
def var fd as date no-undo.
def var i as integer no-undo.
def var cat-line as char no-undo.
def buffer bcode for code.

def var incat as c no-undo.
def var bal-cat as l extent 8 no-undo.
def var tc as c no-undo.

def var cat-all as char init "b,o,d,f,t,u,x,n".

def var cl as char no-undo.
def var in-end-date     like DataBlock.End-Date        no-undo.

{pir_wpp.i}
{getdate.i}
   in-end-date = end-date.
{setdest.i}
{wordwrap.def}

put unformatted "                                                              “ ’ ‚ …  † „ € " skip(2).
put unformatted "                                                         ‡ ¬.à¥¤á¥¤ â¥«ï à ¢«¥­¨ï" skip(2).
put unformatted "                                                         _____________ ˜«®£¨­  ….ƒ." skip (2).
put unformatted "                                                         _____ _____________ "  string(year(today)) "£." skip(2).
put unformatted "                           €   — ˆ ‰    ‹ €    ‘ — … ’  ‚" skip (2).
put unformatted "                              ¯® á®áâ®ï­¨î ­  "  string(end-date,"99/99/9999") "£." skip(2).
put unformatted "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" skip.
put unformatted "³ ®¬¥à áç¥â  ³          ¨¬¥­®¢ ­¨¥ à §¤¥«®¢ ¨ áç¥â®¢         ³à¨§­ ª³ „ â  ®âªàëâ¨ï ³" skip.
put unformatted "³    1 (2)    ³                     ¡ « ­á                     ³ áç¥â  ³     áç¥â      ³" skip.
put unformatted "³   ¯®àï¤ª    ³                                                ³  €,  ³               ³" skip.
put unformatted "ÃÄÄÄÄÄÂÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.
put unformatted "³  1  ³   2   ³                       3                        ³   4   ³       5       ³" skip.

do i = 1 to num-entries(incat). 
  if entry(i,incat) <> "d" then cat-line = entry(i,incat) + "-acct1".
    else cat-line = entry(i,incat) + "-sect".
  find first bcode where bcode.class = "acct-cat" and bcode.code = substring(cat-line,1,1) no-lock.
  put unformatted "ÃÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.
  put unformatted "³               " string(bcode.name,"x(62)") "         ³" skip.                        
  put unformatted "ÃÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.
                  

  for each code where code.class = cat-line and code.parent = cat-line break by code.code:
   /* ¨é¥¬ ª« áá */
    cl = substring(cat-line,1,1).
    if cl <> "d" then cl = cl + "post". /* ­ §¢ ­¨¥ ª« áá  */
      else cl = cl + "pos".
    find last datablock where datablock.dataclass-id = cl and
               ((datablock.end-date = in-end-date or
               datablock.beg-date = in-end-date) or            
               (end-date >= datablock.beg-date and end-date <= datablock.end-date)) 
               no-lock no-error.

    if not avail(datablock) then do: /* ­¥ ­ è«¨ :( */
       put unformatted  "¥ à áç¨â ­ ª« áá ¤ ­­ëå " cl " ­  "  string(end-date,"99/99/9999") skip.
       next.
    end.

    sig = 0.	
    find first dataline where dataline.data-id = datablock.data-id and 
		   	dataline.sym1 = code.code no-lock no-error.
         if avail dataline then do:
          	sig=1.
          	put unformatted "+1" skip.
         end.

    for each bal-acct where bal-acct.bal-acct1 = code.code  by bal-acct.bal-acct:
      find first acct where acct.bal-acct = bal-acct.bal-acct /* and acct.open-date <= end-date and 
       (acct.close-date > end-date OR acct.close-date = ?) */   no-lock no-error. 
    end.
      if sig = 0 and not avail (dataline)then next.
         mCount = 2.
         b1name[1] = code.name.
	       {wordwrap.i
		       &s = b1name 
		       &l = 46
           &n = 10}
       put unformatted "³"space string (code.code,"x(3)") space "³" space(7) "³ " string(b1name[1],"x(46)") " ³       ³               ³" skip.
       DO WHILE (b1name[mCount] NE ""):
           PUT UNFORMATTED "³     ³       ³ " string(b1name[mCount],"x(46)") " ³       ³               ³" skip.
          mCount = mCount + 1.
       END.
  
  for each bal-acct where bal-acct.bal-acct1 = code.code by bal-acct.acct-cat by bal-acct.bal-acct:
    fd = 01.01.9999.
    for each acct where acct.bal-acct = bal-acct.bal-acct and acct.open-date <= end-date and 
     (acct.close-date > end-date OR acct.close-date = ?) no-lock on error undo, next:
      if acct.open-date < fd then fd = acct.open-date.
    end. 
    if fd < 01.01.3000 then firstdate = string (fd,"99/99/9999").
        else next. 
         itog = itog + 1.
         mCont = 2.
         b2name[1] = bal-acct.name-bal-acc.
        
	       {wordwrap.i
		         &s =b2name 
                 &l = 46
                 &n = 10}                                                                                        
         put unformatted "³     ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.
         put unformatted "³     ³ " string(bal-acct.bal-acct,"99999") 
	  		  " ³ " string (b2name[1],"x(46)") " ³   " string(bal-acct.side,"x(2)") "  ³   " firstdate "  ³" skip. 
         DO WHILE (b2name[mCont] NE ""):
            PUT UNFORMATTED "³     ³       ³ " string(b2name[mCont],"x(46)") " ³       ³               ³" skip.
            mCont = mCont + 1.
         END.
    end.	
		    put unformatted "ÃÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.

 end.

end.
        put unformatted "ÀÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip (3).

put unformatted space(5) "‚á¥£® áç¥â®¢:" string (itog,">>>>>>9") skip(3).
put unformatted space(10) FGetSetting("„®«¦­ãå","","") space(4)
		"_______________" space(5)
		FGetSetting("”ˆãå","","") skip.

{preview.i}