{pirsavelog.p}

/*
 Š PŒˆ‚…‘’€‘—…’

 17/01/06  - âç¥â ® áç¥â å ­¥à¥§¨¤¥­â®¢ ®âªàëâëå §  ¯¥à¨®¤.
	     ‡ ª § ¤ ª®¢®© ‘.‹.

 [vk]

*/
{globals.i}                  
{getdates.i}

def var symb as char no-undo.

symb = "-".

{setdest.i &cols=100}

put unformatted "               ‘—…’€ Š‹ˆ…’‚-……‡ˆ„…’‚ ’Š›’›… ‡€ …ˆ„" skip
                "                           " beg-date " - " end-date skip(2).

put unformatted " " skip "à¨¤¨ç¥áª¨¥ «¨æ :" skip.
put unformatted " " skip.

put unformatted "        ‘—…’          „€’€  ’Š  ‘’                             €‡‚€ˆ… " skip.
put unformatted "--------------------  ----------  ---  -----------------------------------------------------------" skip.

for each cust-corp where cust-corp.country-id <> "RUS" by cust-corp.cust-id:

  for each acct where acct.cust-cat  = "" and acct.cust-id = cust-corp.cust-id 
      and acct.open-date >= beg-date and acct.open-date <= end-date by acct.open-date:

   put unformatted acct.acct space(2) 
                   string(acct.open-date,"99/99/9999") space(2) 
                   cust-corp.country-id space(2) 
                   string (cust-corp.name-corp,"x(50)") skip.

   put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .

      CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
      END CASE.
  end.

end.


put unformatted " " skip.
put unformatted " " skip "”¨§¨ç¥áª¨¥ «¨æ :" skip.
put unformatted " " skip.
put unformatted "        ‘—…’          „€’€  ’Š  ‘’                             €‡‚€ˆ… " skip.
put unformatted "--------------------  ----------  ---  -----------------------------------------------------------" skip.

for each person where person.country-id <> "RUS" by person.person-id:

  for each acct where acct.cust-cat  = "—" and acct.cust-id = person.person-id 
      and acct.open-date >= beg-date and acct.open-date <= end-date by acct.open-date:

   put unformatted acct.acct space(2) 
                   string(acct.open-date,"99/99/9999") space(2) 
                   person.country-id space(2) 
                   person.name-last space person.first-names skip.

   put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .

      CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
      END CASE.
  end.

end.



{preview.i}


