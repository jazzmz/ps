{pirsavelog.p}

/*
	Š PŒˆ‚…‘’€‘—…’
  áâ âª¨ ­  ¯« áâ¨ª¥ ¯® ¢ «îâ ¬
  
  ¯ à ¬¥âàë ¯à¨¬¥à:
  ®àï¤®ª‚ «îâ=810; «‘ç¥â =42301,40817,40820,42601 

*/

{globals.i}
{sh-defs.i}
{get-bankname.i}
def input parameter inline as char no-undo.
/* 
inline = "®àï¤®ª‚ «îâ=810,840,978; «‘ç¥â =40817".
*/

def var i as integer no-undo.
def var sumval as dec no-undo.
def var j as integer no-undo.
def var tentry as char no-undo.
def var pcur as char no-undo.
def var bline as char no-undo.
def var cur as char no-undo.
def var iCount as integer init 0 no-undo.

/* à §¡®à áâà®ª¨ ¯ à ¬¥âà®¢ */
do i = 1 to num-entries(inline,";").
 tentry = entry(i,inline,";").
 case entry(1,tentry,"="):
    when "®àï¤®ª‚ «îâ" then pcur = entry(2,tentry,"=").
    when " «‘ç¥â "     then bline = entry(2,tentry,"=").
 end.
end.

if pcur = "" or bline = "" then do: 
	message "è¨¡ª  ¢ ¯¥à¥¤ ¢ ¥¬ëå ¯ à ¬¥âà å!!!" view-as alert-box.
	return.
end.

{getdate.i}

{setdest.i}

Put unformatted cBankName skip(2).
Put unformatted "     áâ âª¨ ­  ¯« áâ¨ª®¢ëå áç¥â å ¯® á®áâ®ï­¨î ­  " end-date skip.
PUT unformatted "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" skip.
Put unformatted "³            ‚€‹’€                ³Š‹-‚³‘’€’Š ‚ ‚€‹’… ‘—…’€³" skip.
PUT unformatted "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.

do j = 1 to num-entries(pcur).
 cur = entry (j,pcur).
 sumval = 0.
 iCount = 0.
 if cur = "810" then cur = "".
  do i = 1 to num-entries(bline).

    For each acct where acct.bal-acct = integer(entry(i,bline)) and
    substring (acct.acct,6,3) = entry (j,pcur) and substring(acct.acct,14,3) = "050" 
    and acct.close-date = ? and acct.open-date <= end-date no-lock:
       run acct-pos in h_base (acct.acct, acct.currency, end-date, end-date, "û").
       if acct.currency = "" or acct.currency = ? then do: 
       			sumval = sumval + abs(sh-bal).
						iCount = iCount + 1.
			 end.      
       else do:
       			sumval= sumval + abs(sh-val).
						iCount = iCount + 1.
       end.
    end.
  end.

		find first currency where currency.currency = cur no-lock.

    put unformatted "³" string(entry (j,pcur),"x(3)") space
    								string(currency.name-currenc,("x(30)")) "³"
										string(iCount,">>>>>9") "³"    								
										string(sumval,">>>,>>>,>>>,>>>,>>9.99") "³" skip.
end.
put unformatted "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip.

{signatur.i  &user-only = yes}
{preview.i}

