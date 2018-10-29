{pirsavelog.p}

/* 
	Š PŒˆ‚…‘’€‘—…’ 

	‘â â¨áâ¨ª¨ “6.
	 áç¥â ­  ®á­®¢¥ acct-pos, ¢ á¢ï§¨ á íâ¨¬ ­¥ ¢¨¤¨â ¯¥à¥®æ¥­ªã.
		
	04/04/06	­ ç «...
	[vk]
*/		
{globals.i}
{sh-defs.i}

def input parameter bline as char init "40702,40703,40802,40807,40817,42301,42305,42306,42601,42606,45505,45506".

def var i as integer no-undo.
def var a as integer extent 6 no-undo.

define temp-table ttrezult
	field bacct2 as char
	field AllOpenAcct as integer       /* ¢á¥£® ®âªàëâëå «¨æ¥¢ëå áç¥â®¢*/
	field NotNullOpenAcct as integer   /* ¨§ ­¨å ®âªàëâë¥ ­¥ ­ã«¥¢ë¥ */
	field WorkOpenAcct as integer      /* ¨§ ­¨å ®âªàëâë¥, à ¡®â «¨ */
	field OpenAcct as integer          /* ¨§ ­¨å ®âªàë«¨áì ¢ ãª § ­­®¬ ¯¥à¨®¤¥ */ 
	field WorkAcct as integer          /* ¨§ ­¨å à ¡®â «¨ ¢ ãª § ­­®¬ ¯¥à¨®¤¥ */
	field CloseAcct as integer.        /* ¨§ ­¨å § ªàë«¨áì ¢ ãª § ­­®¬ ¯¥à¨®¤¥ */

{getdates.i}

{setdest.i}

do i = 1 to num-entries(bline).
create ttrezult.
ttrezult.bacct2 = entry(i, bline).

 for each acct where acct.bal-acct = integer(entry(i, bline)) by acct.acct:
       lastmove = ?.
       lastcurr = ?.	

     /* ®âªàëâë¥ ¢á¥£® */ 
     if acct.open-date <= end-date and (acct.close-date = ? or
	acct.close-date > end-date) then do: 
		ttRezult.AllOpenAcct = ttRezult.AllOpenAcct + 1.

       run acct-pos in h_base (acct.acct, acct.currency, beg-date, end-date, "û").
       /* àã¡«¨ */
       if acct.currency = "" then do:
         /* ­¥­ã«¥¢ë¥ ­  ª®­¥æ ãª § ­­®£® ¯¥à¨®¤  */
         if abs(sh-bal) > 0 then ttRezult.NotNullOpenAcct = ttRezult.NotNullOpenAcct + 1.
         
         /* à ¡®â «¨ ¢ â¥ç¥­¨¨ ãª § ­­®£® ¯¥à¨®¤  */
         if (lastmove >= beg-date and lastmove <= end-date) then  
			ttRezult.WorkOpenAcct = ttRezult.WorkOpenAcct + 1. 

         /* ®âªàë«¨áì ¢ â¥ç¥­¨¨ ¯¥à¨®¤  */
         if acct.open-date >= beg-date and  
  	    acct.open-date <= end-date then ttRezult.OpenAcct = ttRezult.OpenAcct + 1.	

         /* ®âªàë«¨áì ¨ à ¡®â «¨ ¢ â¥ç¥­¨¨ ¯¥à¨®¤  */ 
         if (acct.open-date >= beg-date and 
	    acct.open-date <= end-date) and 
	    lastmove >= beg-date and lastmove <= end-date then ttRezult.WorkAcct = ttRezult.WorkAcct + 1.	
       end.

       /* ¢ «îâ  */
       if acct.currency <> "" then do:
         /* ­¥­ã«¥¢ë¥ ­  ª®­¥æ ãª § ­­®£® ¯¥à¨®¤  */
         if abs(sh-val) > 0 then ttRezult.NotNullOpenAcct = ttRezult.NotNullOpenAcct + 1.
         
         /* à ¡®â «¨ ¢ â¥ç¥­¨¨ ãª § ­­®£® ¯¥à¨®¤  */
         if lastcurr >= beg-date and lastcurr <= end-date then ttRezult.WorkOpenAcct = ttRezult.WorkOpenAcct + 1. 

         /* ®âªàë«¨áì ¢ â¥ç¥­¨¨ ¯¥à¨®¤  */
         if acct.open-date >= beg-date and  
  	    acct.open-date <= end-date then ttRezult.OpenAcct = ttRezult.OpenAcct + 1.	

         /* ®âªàë«¨áì ¨ à ¡®â «¨ ¢ â¥ç¥­¨¨ ¯¥à¨®¤  */ 
         if acct.open-date >= beg-date and 
	    acct.open-date <= end-date and 
	    lastcurr >= beg-date and lastcurr <= end-date then ttRezult.WorkAcct = ttRezult.WorkAcct + 1.	
       end.

     end.

     /* § ªàë«¨áì ¢ â¥ç¥­¨¨ ¯¥à¨®¤  */
     if acct.close-date >= beg-date and acct.close-date <= end-date then ttRezult.CloseAcct = ttRezult.CloseAcct + 1.	
 end.
end. 


Put Unformatted "              ‘’€’ˆ‘’ˆŠ€  ‚‘…Œ ‘—…’€Œ € „€’“ " end-date " €—ˆ€Ÿ ‘ " beg-date skip (1).
Put Unformatted "ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" SKIP.
Put Unformatted "³        ³               Š‹-‚ ’Š›’›• ‘—…’‚ € „€’“  " end-date "              ³Š‹-‚ ‘—…’‚³" SKIP.
Put Unformatted "³        ÃÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ ‡€Š›‚˜ˆ•‘Ÿ ³" SKIP.
Put Unformatted "³ €‹€‘ ³   ‚‘…ƒ   ³ ˆ‡ ˆ• ³ˆ‡ ˆ• €’€‹ˆ ³ ˆ‡ ˆ• ’Š›‹ˆ ‘—…’ ‚  …ˆ„ ³   ‚ …ˆ„  ³" SKIP.
Put Unformatted "³  ‘—…’  ³           ³‘ …“‹.³   ‚ …ˆ„     ³ ‘ " beg-date "  " end-date " ‚Š‹—. ³ ‘  " beg-date " ³" SKIP.
Put Unformatted "³        ³           ³ ‘’€’. ³  ‘ " beg-date "    ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´  " end-date " ³" SKIP.
Put Unformatted "³        ³           ³        ³ " end-date " ‚Š‹.³     ‚‘…ƒ   ³ ˆ‡ ˆ• €’€‹ˆ ³‚Š‹—ˆ’…‹œ.³" SKIP.               
Put Unformatted "ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´" SKIP.

for each ttrezult by bacct2:
  put unformatted "³  " ttrezult.bacct2 " ³ " 
		string(ttrezult.AllOpenAcct,">>>>>>>>9") " ³" 
		string(ttrezult.NotNullOpenAcct,">>>>>>9") " ³" 
		string(ttrezult.WorkOpenAcct,">>>>>>>>>>>>>>9") " ³"
		string(ttrezult.OpenAcct,">>>>>>>>>>>9") " ³" 
                string(ttrezult.WorkAcct,">>>>>>>>>>>>>>>9") " ³" 
                string(ttrezult.CloseAcct,">>>>>>>>>>>9") " ³" skip.
Put Unformatted "ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´" SKIP.
end.

for each ttrezult by bacct2:
   a[1] = a[1] + ttrezult.AllOpenAcct.
   a[2] = a[2] + ttrezult.NotNullOpenAcct.
   a[3] = a[3] + ttrezult.WorkOpenAcct.
   a[4] = a[4] + ttrezult.OpenAcct.
   a[5] = a[5] + ttrezult.WorkAcct.
   a[6] = a[6] + ttrezult.CloseAcct.
end.

  Put Unformatted "³  ˆ’ƒ:³ "
		string(a[1],">>>>>>>>9") " ³" 
		string(a[2],">>>>>>9") " ³" 
		string(a[3],">>>>>>>>>>>>>>9") " ³"
		string(a[4],">>>>>>>>>>>9") " ³" 
		string(a[5],">>>>>>>>>>>>>>>9") " ³" 
		string(a[6],">>>>>>>>>>>9") " ³" skip.
 
  Put Unformatted "ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip.

{preview.i}
