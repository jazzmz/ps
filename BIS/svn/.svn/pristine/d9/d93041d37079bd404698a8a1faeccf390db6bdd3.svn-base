{pirsavelog.p}

/*
	Š PŒˆ‚…‘’€‘—…’
	‘â â¨áâ¨ª  „6: ¤®å®¤ë ®â ª«¨¥­â®¢ ¤¥¯ àâ ¬¥­â .
	
	Cç¥â  ª«¨¥­â®¢ ¤¥¯ àâ ¬¥­â  „6, ®â¡¨à îâáï ¯® „ ‘â â¨áâ¨ª .
	‘ç¥â  ¤®å®¤®¢ âã¯® 70601.

	¯ à ¬¥âàë:
	à¨§­ ª=“16

*/

def input parameter inline as char no-undo.


{globals.i}

{getdates.i}
{setdest.i}

define temp-table ttrezult
	field op-date like op-entry.op-date 
	field acct-db like op-entry.acct-db 
	field acct-cr like op-entry.acct-cr
	field amt-cur like op-entry.amt-cur
	field amt-rub like op-entry.amt-rub
        FIELD isLnk   AS LOG
.

def buffer act for acct.
def var tentry as char             no-undo.
def var name   as char             no-undo.
def var symb   as char             no-undo.
def var i      as int init 0       no-undo.
def var icount as integer extent 2 no-undo.
def var isum   as decimal extent 2 no-undo.
def var kod    as char             no-undo.

DEF VAR oDoc    AS TDocument NO-UNDO.
DEF VAR showLnk AS LOG       NO-UNDO.

MESSAGE "®ª §ë¢ âì ¢§ ¨¬®á¢ï§ ­­®áâì?" VIEW-AS ALERT-BOX BUTTONS YES-NO TITLE "‡ ¯à®á ­  ®â®¡à ¦¥­¨¥ ¤®¯. ¯®«¥©" SET showLnk.

do i = 1 to num-entries(inline,";").
 tentry = entry(i,inline,";").
 case entry(1,tentry,"="):
    when "à¨§­ ª"      then kod = entry(2,tentry,"=").
 end.
end.
symb = "-".

for each acct where acct begins "4" no-lock:
  if lookup(kod,GetXattrValue("acct",trim(acct.acct) + "," + trim(acct.currency),"‘â â¨áâ¨ª ")) > 0 then do: 	

   for each op-entry  where op-entry.op-date >= beg-date and op-entry.op-date <=end-date and
       op-entry.acct-db = acct.acct and op-entry.acct-cr begins "70601" /* by op-entry.acct-cr 
		by op-entry.op-date by op-entry.acct-db */ no-lock:
        oDoc = NEW TDocument(op-entry.op).

	create ttrezult.
        ASSIGN
  	  ttrezult.op-date = op-entry.op-date 
	  ttrezult.acct-db = op-entry.acct-db 
	  ttrezult.acct-cr = op-entry.acct-cr
	  ttrezult.amt-cur = op-entry.amt-cur
	  ttrezult.amt-rub = op-entry.amt-rub
          ttrezult.isLnk   = oDoc:isBelongToDepended()
         .

        DELETE OBJECT oDoc.

        put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
        CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
        END CASE.
			
   end.	
  end.     
end.

put unformatted space (10) "„•„› ’ …€–ˆ‰  ‘—…’€Œ Š‹ˆ…’‚ " kod  skip.
put unformatted space (18) "§  ¯¥à¨®¤ á " beg-date " ¯® " end-date skip(3).
put unformatted "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" skip.
put unformatted "³                                             ³                      ³Š‹-‚³‘“ŒŒ€ ŠŒˆ‘‘ˆˆ³" skip.
put unformatted "³           €ˆŒ…‚€ˆ…/”ˆ Š‹ˆ…’€          ³     ‹ˆ–…‚‰ ‘—…’     ³„Š-‚ ³      ‡€      ³" skip.
put unformatted "³                                             ³                      ³      ³    …ˆ„    ³" skip.
put unformatted "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.
                                                                                                            
for each acct where acct.acct begins "70601" and 
	(acct.close-date = ? or acct.close-date <= end-date) by acct.acct:

        put screen col 77 row 24 color red "(" + symb + ")" .
        CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
        END CASE.

	find first ttrezult where ttrezult.acct-cr = acct.acct no-lock no-error.
	if avail ttrezult then do:
  	   i = i + 1.
           put unformatted "³"  space(90) "³" skip.
           put unformatted "³" string((string(i,"99") + "." + acct.details),"x(65)") space(25) "³" skip.
           put unformatted "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.

  	   for each ttrezult where ttrezult.acct-cr = acct.acct break by ttrezult.acct-db:
 		accumulate ttrezult.amt-rub (total count by ttrezult.acct-db).
		if last-of (ttrezult.acct-db) then do:
		    find first act where act.acct = ttrezult.acct-db no-lock no-error.

	            if act.cust-cat = "—" then do:
	              find first person where person.person-id = act.cust-id no-lock no-error.
	              name = person.name-last + " " + person.first-names. 
                    end.
                    if act.cust-cat = "" then do:
	              find first cust-corp where cust-corp.cust-id = act.cust-id no-lock no-error.
	              name = cust-corp.cust-stat + " " + cust-corp.name-corp. 
                    end.

		    put unformatted "³ " (IF NOT showLnk THEN string(trim(name),"x(43)") ELSE STRING("(" + STRING(ttrezult.isLnk) + ")" + trim(name),"x(39)")) "³" ttrezult.acct-db 
			" ³ " string(accum count by ttrezult.acct-db amt-rub,">>>9") 
			" ³ "string(accum total by ttrezult.acct-db amt-rub,">>>>>>>>9.99") 
			" ³" skip.
		    icount[1] = icount[1] + accum count by ttrezult.acct-db amt-rub.
		    isum[1]  = isum[1] + accum total by ttrezult.acct-db amt-rub.
		end.
           end.

           put unformatted "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.
           put unformatted "³" string(acct.details,"x(62)")  "ˆ’ƒ:" "³ " string(icount[1],">>>9") " ³ " string(isum[1],">>>>>>>>9.99") " ³" skip.
           put unformatted "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.
           icount[2] = icount[2] + icount [1].
           icount[1] = 0.
	   isum[2] = isum[2] + isum[1].
	   isum[1] = 0.		                                                                                    

        end. 
end.

put unformatted "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.
put unformatted "³" space(27) "ˆ’ƒ ‡€ …ˆ„ C " beg-date "  " end-date 
		":³ " string(icount[2],">>>>>9") 
		" ³ " string(isum[2],">>>>>>>>9.99") 
                " ³"skip.
put unformatted "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip.


{signatur.i  &user-only = yes}
{preview.i}



