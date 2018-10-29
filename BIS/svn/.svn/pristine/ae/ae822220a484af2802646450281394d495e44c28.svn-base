{pirsavelog.p}

/*

 P‚…‘’€‘—…’

22/02/06  ‚λ£ΰγ§ª  ¤ ­­λε ―® Ά­¥΅ « ­αγ ¤«ο δ®ΰ¬λ F1100 ”‘”
          
[vk]

*/

def var i as int no-undo.
def var r  as char. /* ΰ §¤¥«¨β¥«μ ζ¥«®© ¨ ¤ΰ®΅­®© η αβ¨ η¨α«  ―ΰ¨ Άλ£ΰγ§ª¥ */
def var rs as char. /* ΰ §¤¥«¨β¥«μ αβ®«΅ζ®Ά ¤«ο ¥ªα¥«ο  */
r = ",".
rs = "#".

FUNCTION CommaString RETURNS char (INPUT a AS dec).
	Return  (string(truncate(a,0),"->>>>>>>>>>>>>>9") + 
		r + string((a - truncate(a,0)) * 100, "99")) + rs.
END FUNCTION.

{branches.i}

{br-put.i "„€›… „‹ ”› F1100 ”‘”" }
{setdest.i}

MESSAGE "‚›‚„’ €…‚€ ‘’‹–‚?" 
         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mWop AS LOG.



put unformatted "„€›… „‹ ”› F1100 ”‘”" rs  skip(1).
put unformatted " " skip.

if mWop then do:
	put unformatted " " skip.
	put unformatted " /‘ " rs
			" " rs
			"            ‚ “‹•" rs 
			" “‹…‚›‰ ‚‚€‹…’" rs
			"               ‚‘…ƒ" rs skip.
	put unformatted "-----" rs
			" " rs 
			"--------------------" rs
			"--------------------" rs
			"--------------------" rs skip.
end.

  for each DataLine of DataBlock no-lock 
    break by DataLine.Sym1:
    find first bal-acct where bal-acct.bal-acct = integer(DataLine.Sym1).
      if avail bal-acct and bal-acct.side = "€" then do:
        put unformatted string(DataLine.Sym1,"99999") rs "€" rs space 
			CommaString (DataLine.Val[9] - DataLine.Val[8])  space
			CommaString (DataLine.Val[8])  space
			CommaString (DataLine.Val[9])  space
			skip. 
      end.
      if avail bal-acct and bal-acct.side = "" then do:
        put unformatted string(DataLine.Sym1,"99999") rs "" rs space 
			CommaString (DataLine.Val[12] - DataLine.Val[11])  space
			CommaString (DataLine.Val[11])  space
			CommaString (DataLine.Val[12])  space
			skip. 
      end.


  end.

{signatur.i &department = branch &user-only = yes}
{preview.i}

