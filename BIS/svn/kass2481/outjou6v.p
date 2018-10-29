{pirsavelog.p}

/*
               Å†≠™Æ¢·™†Ô ®≠‚•£‡®‡Æ¢†≠≠†Ô ·®·‚•¨† Åàë™¢®‚
    Copyright: (C) 1992-2003 íéé "Å†≠™Æ¢·™®• ®≠‰Æ‡¨†Ê®Æ≠≠Î• ·®·‚•¨Î"
     Filename: injourvp.p
      Comment: è•Á†‚Ï ™†··Æ¢Æ£Æ ¶„‡≠†´† ¢ ¢†´Ó‚•
   Parameters:
         Uses:
      Used by:
      Created: 18/03/2004 Nav
     Modified: 06/04/2004 Alex_lom
*/
DEFINE INPUT PARAMETER iPar AS CHAR.

{globals.i}
{tmprecid.def}
{getdate.i}
&glob end-date end-date
{korder.i}

do on error undo, return on endkey undo, return:
    run acct.p ("b", 3).
    if return-value = "error" or keyfunc(lastkey) = "END-ERROR" then
       undo, return.
    if not can-find(first tmprecid) then do:
       message "ç• ¢Î°‡†≠Î ·Á•‚†!" view-as alert-box.
       undo, retry.
    end.
end.

def buffer xop-entry for op-entry.
def buffer x-signs   for signs.
def var suppinsp as logical format "Ñ†/ç•‚" init yes no-undo.
def var suppress as logical format "Ñ†/ç•‚" init yes no-undo.
def var nightkas as logical format "Ñ†/ç•‚" init yes no-undo.
def var date-rep  like op-date.op-date no-undo.
def var br-name like branch.name no-undo.
def var doc-count as int format ">>>>9" no-undo. 
def var all-count as int format ">>>>9" no-undo.
def var ins-count as int format ">>>>9" no-undo.
def var user1 as char             no-undo.
def var user2 as char             no-undo.
def var user3 as char             no-undo.
def var user4 as char             no-undo.

message "Ç•Á•‡≠ÔÔ ™†··† ?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO update nightkas.
message "èÆ§¢Æ§®‚Ï ®‚Æ£® ØÆ Æ‚¢•‚·‚¢•≠≠Æ¨„ ®·ØÆ´≠®‚•´Ó ?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO update suppinsp.
message "èÆ§†¢´Ô‚Ï Ø„·‚Î• ·‚‡Æ™®?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO update suppress.

{setdest.i}
{get-user.i}

IF NOT list-id > '' THEN DO:
   MESSAGE "ç• ¢Î°‡†≠Î ·Æ‚‡„§≠®™®!" 
   VIEW-AS ALERT-BOX.
   UNDO, RETRY.
END.

FOR EACH tmprecid, FIRST acct WHERE recid(acct) = tmprecid.id NO-LOCK:

   {acctread.i &bufacct=acct 
               &class-code= acct.class-code}
   IF NOT ({&user-rights})THEN next.
   if suppress then do:
      find first op-entry where op-entry.acct-cr eq acct.acct and
                                op-entry.op-status >= gop-status and
                                op-entry.op-date eq end-date no-lock no-error.
      if not avail op-entry then next.
   end.

   def var long-acct as char format "x(25)" column-label "ãàñÖÇéâ ëóÖí" no-undo.
   {get-fmt.i &obj='" + acct.acct-cat + ""-Acct-Fmt"" + "'}
   long-acct = {out-fmt.i acct.acct fmt}.

   find first currency where currency.currency = acct.currency no-lock no-error.
   find branch where branch.branch-id = acct.branch-id no-lock no-error.
   if avail branch then br-name = branch.name.
                   else br-name = "".

   br-name = branch.name.

   br-name   = branch.name.
   all-count = 0.
   doc-count = 0.

   form with frame cs down.
   for each op-entry where op-entry.acct-cr eq acct.acct
                       and op-entry.op-status >= gop-status
                       and op-entry.op-date eq end-date
                       and op-entry.amt-cur ne 0 no-lock,
        each op where op.op eq op-entry.op
                  and (if nightkas then can-do(iPar,op.op-kind)
                                   else not can-do(iPar,op.op-kind)) no-lock
            break 
              by op.user-inspector
              by op.user-id
              by op-entry.op 
              by op-entry.amt-cur
            on endkey undo, return with frame cs width 136:
      down.

      IF op.doc-num BEGINS "è" THEN NEXT.
      IF NOT CAN-DO(list-id,op.user-inspector) THEN NEXT.
   
      doc-count = doc-count + 1.

      IF LAST-OF(op-entry.op) THEN DO:
         all-count = all-count + 1.
         ins-count = ins-count + 1.
      END.            	

      release xop-entry.

      if op-entry.acct-db eq ? then
         find first xop-entry of op where xop-entry.acct-cr eq ? no-lock no-error.

      accumulate op.op             (count).
      accumulate op.user-inspector (count).
      accumulate op.user-id        (count).
      accumulate op-entry.amt-rub  (total).
      accumulate op-entry.amt-cur  (total).
      accumulate op.doc-num        (count).

      accumulate op-entry.amt-cur (total by op.user-inspector).
      accumulate op-entry.amt-rub (total by op.user-inspector).
      accumulate op-entry.amt-cur (total by op.user-id).
      accumulate op-entry.amt-rub (total by op.user-id).

      FIND FIRST doc-type WHERE doc-type.doc-type EQ op.doc-type NO-LOCK NO-ERROR.

      IF FIRST-OF(op.user-inspector) THEN DO:    

         if nightkas then do:
            find last op-date where op-date.op-date < end-date no-lock no-error.
            date-rep = op-date.op-date.
         end.
         else do:   
            date-rep = end-date.
         end.

         find first _user where _user._userid eq op.user-inspector no-lock no-error.
         display caps(br-name) @ name-bank skip(2)                   
             "äÄëëéÇõâ " skip                                    
             "ÜìêçÄã èé êÄëïéÑì" skip                            
             "áÄ"  date-rep "ä-í " long-acct SKIP(2)            
             "ÇÄãûíÄ   : "  (if available currency then name-currenc
                             else "≠• ØÆ¢•ß´Æ") format "x(20)" SKIP     
             "äéçíêéãÖê: " _user._user-name 
             with no-box frame top no-label.                     
      END.
      DISPLAY
         doc-count column-label "N è/è"
         op.doc-num column-label "çéåÖê!éêÑÖêÄ"
         doc-type.name-doc column-label  "çÄàåÖçéÇÄçàÖ!ÑéäìåÖçíÄ"
         {out-fmt.i op-entry.acct-db fmt} when op-entry.acct-db ne ? @ acct.acct
         {out-fmt.i xop-entry.acct-db fmt} when op-entry.acct-db eq ? 
                                            and avail xop-entry @ acct.acct
         op-entry.amt-cur column-label "ëìååÄ èé çéåàçÄãì"
         op-entry.amt-rub column-label "ëìååÄ êìÅã.ùäÇàÇ."
         FRealSymbol (ROWID (op-entry), YES) column-label "ëàåÇéã!äÄëëéÇéâ!éíóÖíçéëíà".

      IF LAST-OF(op.user-id) and suppinsp THEN DO:
         find first _user where _user._userid eq op.user-id no-lock no-error.
         down with frame cs.
         underline doc-count acct.acct doc-type.name-doc op.doc-num
                   op-entry.amt-cur op-entry.amt-rub with frame cs.
         display "àíéÉé" @ op.doc-num
                 _user._user-name @ doc-type.name-doc      
                 ins-count @ acct.acct
                 accum total by op.user-inspector op-entry.amt-cur @ op-entry.amt-cur
                 accum total by op.user-inspector op-entry.amt-rub @ op-entry.amt-rub with frame cs.
            DOWN 1.
            doc-count = 0.
            ins-count = 0.
      END.

      IF LAST-OF(op.user-inspector) THEN DO:     
         find first _user where _user._userid eq op.user-inspector no-lock no-error.
         down with frame cs.
         underline doc-count acct.acct doc-type.name-doc op.doc-num
                   op-entry.amt-cur op-entry.amt-rub with frame cs.
         down with frame cs.
         display "àíéÉé" @ op.doc-num
                 _user._user-name @ doc-type.name-doc      
                  all-count @ acct.acct
                  accum total by op.user-inspector op-entry.amt-cur @ op-entry.amt-cur
                  accum total by op.user-inspector op-entry.amt-rub @ op-entry.amt-rub with frame cs.

         find first _user where _user._userid eq user("bisquit") no-lock no-error.                                   
         if avail _user then do:                                                                                     
            user2 = _user._user-name.                                                                                
            find first signs where signs.code eq "ÑÆ´¶≠Æ·‚Ï"                                                         
                               and signs.file-name eq "_user"                                                        
                               and signs.surrogate eq _user._userid no-lock no-error.                                
            if avail signs then do:                                                                                  
               user1 = signs.xattr-value.                                                                            
               find first signs where signs.code eq "é‚§•´•≠®•"                                                      
                                  and signs.file-name eq "_user"                                                       
                                  and signs.surrogate eq _user._userid                                                 
                                  no-lock no-error.                                                                    
               if avail signs then do:                                                                               
                  find first x-signs where x-signs.code eq "á†¢ä†·ÑÆ´"                                               
                                       and x-signs.file-name eq "branch"                                                 
                                       and x-signs.surrogate eq signs.xattr-value                                        
                                        no-lock no-error.                                                                 
                  if avail x-signs then do:                                                                          
                     user3 = x-signs.xattr-value.                                                                     
                  end.                                                                                               
                  find first x-signs where x-signs.code eq "á†¢ä†·"                                                  
                                       and x-signs.file-name eq "branch"                                                 
                                       and x-signs.surrogate eq signs.xattr-value                                        
                                       no-lock no-error.                                                                 
                  if avail x-signs then do:                                                                          
                     user4 = x-signs.xattr-value.                                                                    
                  end.
               end.                                                                                               
            end.                                                                                                  
         end.                                                                                    
 
	 doc-count = 0.
         ins-count = 0.
	 all-count = 0.

         display skip(2)
         "     " user1 format "x(35)" "   "  user2 format "x(20)" skip(2)
         "     " user3 format "x(35)" "   "  user4 format "x(20)" skip(2)
         with frame foot no-label.
      END.
   END.
END.

{preview.i}
