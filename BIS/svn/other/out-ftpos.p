{pirsavelog.p}

/*

Š PŒˆ‚…‘’€‘—…’

22/02/06  ‚ë£àã§ª  ¤ ­­ëå ¯® áà®ç­ë¬ ®¯¥à æ¨ï¬ ¨ áç¥â ¬ ¤®¢¥à¨â¥«ì­®£® ã¯à ¢«¥­¨ï ¤«ï F1100 ”‘”
          
[vk]

*/

def var i as int no-undo.
def var r  as char. 
def var rs as char. 
r = ",". /* à §¤¥«¨â¥«ì æ¥«®© ¨ ¤à®¡­®© ç áâ¨ ç¨á«  ¯à¨ ¢ë£àã§ª¥ */
rs = "#". /* à §¤¥«¨â¥«ì áâ®«¡æ®¢ ¤«ï ¥ªá¥«ï  */

FUNCTION CommaString RETURNS char (INPUT a AS dec).
	Return  (string(truncate(a,0),"->>>>>>>>>>>>>>9") + 
		r + string((a - truncate(a,0)) * 100, "99")) + rs.
END FUNCTION.

{branches.i}

{br-put.i "„€›… „‹Ÿ ”Œ› F1100 ”‘”" }
{setdest.i}

MESSAGE "‚›‚„ˆ’œ €ˆŒ…‚€ˆŸ ‘’‹–‚?" 
         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mWop AS LOG.



put unformatted "„€›… „‹Ÿ ”Œ› F1100 ”‘”#" skip(1).
put unformatted " " skip.
put unformatted "€Š’ˆ‚›…#" skip.

if mWop then do:
	put unformatted " " skip.
	put unformatted " /‘ #             €Š’ˆ‚ #            €Š’ˆ‚ #               €Š’ˆ‚#" skip.
	put unformatted "-----# -------------------# -------------------# -------------------#" skip.
end.

  for each DataLine of DataBlock no-lock 
    break by DataLine.Sym1:
    find first bal-acct where bal-acct.bal-acct = integer(DataLine.Sym1).
      if avail bal-acct and bal-acct.side = "€" then do:

        put unformatted string(DataLine.Sym1,"99999") rs space 
			CommaString(DataLine.Val[9] - DataLine.Val[8]) space
			CommaString(DataLine.Val[8]) space
			CommaString(DataLine.Val[9]) space
			skip. 
      end.
  end.

put unformatted " " skip.
put unformatted "€‘‘ˆ‚›…#" skip.
if mWop then do:
	put unformatted " " skip.
	put unformatted " /‘ #            €‘‘ˆ‚ #           €‘‘ˆ‚ #              €‘‘ˆ‚#" skip.
	put unformatted "-----# -------------------# -------------------# -------------------#" skip.
end.

  for each DataLine of DataBlock no-lock 
    break by DataLine.Sym1:
    find first bal-acct where bal-acct.bal-acct = integer(DataLine.Sym1).
      if avail bal-acct and bal-acct.side = "" then do:

        put unformatted string(DataLine.Sym1,"99999") rs space 
			CommaString(DataLine.Val[12] - DataLine.Val[11]) space
			CommaString(DataLine.Val[11]) space
			CommaString(DataLine.Val[12]) space
			skip. 
        end.
  end.
	

{signatur.i &department = branch &user-only = yes}
{preview.i}

