{pirsavelog.p}

/*

Š PŒˆ‚…‘’€‘—…’

22/02/06  ‚ë£àã§ª  ¤ ­­ëå ¯® ¡ « ­á®¢ë¬ áç¥â ¬ ¤«ï F1100 ”‘”
          
[vk]

*/

def var i as int no-undo.
def var rname as char initial  "Š€ˆ’€‹ ˆ ”„›,
				„……†›… ‘…„‘’‚€ ˆ „€ƒ.Œ…’€‹‹›,
				Œ…†€Š‚‘Šˆ… …€–ˆˆ,
				…€–ˆˆ ‘ Š‹ˆ…’€Œˆ,
				…€–ˆˆ ‘ –…›Œˆ “Œ€ƒ€Œˆ,
				‘…„‘’‚€ ˆ ˆŒ“™…‘’‚,
				…‡“‹œ’€’› „…Ÿ’…‹œ‘’ˆ".

{branches.i}

{br-put.i "„€›… „‹Ÿ ”Œ› F1100 ”‘”" }
{setdest.i}
MESSAGE "‚›‚„ˆ’œ €ˆŒ…‚€ˆŸ €‡„…‹‚ €‹€‘‚›• ‘—…’‚?" 
         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mWop AS LOG.


put unformatted "„€›… „‹Ÿ ”Œ› F1100 ”‘”" skip(1).

do i=1 to 7.
  if mWop then do:
     put unformatted " " skip.
     put unformatted string(i,"9") ". " trim(ENTRY(i,rname)) skip.
     put unformatted " /‘              €Š’ˆ‚             €Š’ˆ‚                €Š’ˆ‚            €‘‘ˆ‚            €‘‘ˆ‚               €‘‘ˆ‚" skip.
     put unformatted "----- ------------------- ------------------- ------------------- ------------------- ------------------- -------------------" skip.
  end.

  put unformatted " " skip.

for each bal-acct where string(bal-acct.bal-acct) begins string(i) AND bal-acct.acct-cat = "b" 
 and bal-acct.bal-acct > 1 by bal-acct.bal-acct:
  find first DataLine of DataBlock where DataLine.Sym1 = string(bal-acct.bal-acct) no-error.
  if avail DataLine then do:
        put unformatted string(DataLine.Sym1,"99999") space 
			string((DataLine.Val[9] - DataLine.Val[8]),"->>>>>>>>>>>>>>9.99") space
			string(DataLine.Val[8],"->>>>>>>>>>>>>>9.99") space
			string(DataLine.Val[9],"->>>>>>>>>>>>>>9.99") space
			string((DataLine.Val[12] - DataLine.Val[11]),"->>>>>>>>>>>>>>9.99") space
			string(DataLine.Val[11],"->>>>>>>>>>>>>>9.99") space
			string(DataLine.Val[12],"->>>>>>>>>>>>>>9.99") space
			skip. 
  end.
  else do:
        put unformatted string(bal-acct.bal-acct,"99999") space(16) 
			"0.00" space(16) 
			"0.00" space(16) 
			"0.00" space(16) 
			"0.00" space(16) 
			"0.00" space(16) 
			"0.00" space(16) skip.
  end.
end.

/*
  for each DataLine of DataBlock where DataLine.Sym1 begins string(i) no-lock 
    break by DataLine.Sym1:
        put unformatted string(DataLine.Sym1,"99999") space 
			string((DataLine.Val[9] - DataLine.Val[8]),"->>>>>>>>>>>>>>9.99") space
			string(DataLine.Val[8],"->>>>>>>>>>>>>>9.99") space
			string(DataLine.Val[9],"->>>>>>>>>>>>>>9.99") space
			string((DataLine.Val[12] - DataLine.Val[11]),"->>>>>>>>>>>>>>9.99") space
			string(DataLine.Val[11],"->>>>>>>>>>>>>>9.99") space
			string(DataLine.Val[12],"->>>>>>>>>>>>>>9.99") space
			skip. 
  end.
*/
end.


{signatur.i &department = branch &user-only = yes}
{preview.i}

