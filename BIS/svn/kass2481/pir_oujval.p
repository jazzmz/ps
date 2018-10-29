{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ТОО "Банковские информационные системы"
     Filename: injourvp.p
      Comment: Печать кассового журнала в валюте
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
    run bran#ot.p ("*", 3).
    if return-value = "error" or keyfunc(lastkey) = "END-ERROR" then
       undo, return.
    if not can-find(first tmprecid) then do:
       message "Не выбраны отделения!" view-as alert-box.
       undo, retry.
    end.
end.

def buffer xop-entry for op-entry.
def buffer x-signs   for signs.
def var suppinsp as logical format "Да/Нет" init yes no-undo.
def var suppress as logical format "Да/Нет" init yes no-undo.
def var nightkas as logical format "Да/Нет" init yes no-undo.
def var date-rep  like op-date.op-date no-undo.
def var br-name like branch.name no-undo.
def var doc-count as int format ">>>>9" no-undo. 
def var all-count as int format ">>>>9" no-undo.
def var ins-count as int format ">>>>9" no-undo.
def var user1 as char             no-undo.
def var user2 as char             no-undo.
def var user3 as char             no-undo.
def var user4 as char             no-undo.

/** Бурягин добавил определение буфера 24.07.2006 10:06 */
def buffer bfrAcct for acct.
/** Бурягин end */

/* message "Вечерняя касса ?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO update nightkas.
*/
nightkas = no.
message "Подводить итоги по кассирам ?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO update suppinsp.
message "Подавлять пустые строки?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO update suppress.
{setdest.i}

FOR EACH tmprecid, FIRST branch WHERE recid(branch) = tmprecid.id NO-LOCK BREAK BY branch.branch-id:
    tr:
    for each acct where acct.contract begins "Касса"
                  and acct.currency <> ""
                  AND acct.acct-cat EQ "b"
                  and acct.close-date eq ? 
                  AND acct.branch = branch.branch-id  use-index acct-cont no-lock:
    
      {acctread.i
        &bufacct=acct
        &class-code= acct.class-code
      }
      IF NOT ({&user-rights})THEN next.
      if suppress then do:
        find first op-entry where op-entry.acct-cr eq acct.acct and
                                  op-entry.op-status >= gop-status and 
				                          /* op-entry.amt-cur <> 0 and */
				                         op-entry.op-date >= end-date no-lock no-error.
        if not avail op-entry then next.
      end.
      def var long-acct as char format "x(25)" column-label "ЛИЦЕВОЙ СЧЕТ" no-undo.
      {get-fmt.i &obj='" + acct.acct-cat + ""-Acct-Fmt"" + "'}
      long-acct = {out-fmt.i acct.acct fmt}.
      find first currency where currency.currency = acct.currency no-lock no-error.
      if first-of(branch.branch-id) then do:
/*        page.
 */
        br-name = branch.name.
      end.

      if nightkas then do:
/*       find last op-date where op-date.op-date < end-date no-lock no-error.
         date-rep = op-date.op-date.*/
         find first op where op.op eq op-entry.op no-lock no-error.
         date-rep = op.doc-date.
      end.
      else do:   
         date-rep = end-date.
      end.

    /** Бурягин добавил условие 21.07.2006 16:58 */
    if branch.branch-id = "00002" then
    	do:
    	display  "┌───────────────────┐" AT 75 SKIP
               "│   Обслуживание    │" AT 75 SKIP
               "│в послеоперационное│" AT 75 SKIP
               "│      время        │" AT 75 SKIP
               "└───────────────────┘" AT 75 SKIP(2)
                with no-box frame toptop size 120 by 5 no-label.
    	end.
    
    if nightkas then do:
    	
    	display  "┌───────────────────┐" AT 95 SKIP
               "│   Обслуживание    │" AT 95 SKIP
               "│в послеоперационное│" AT 95 SKIP
               "│      время        │" AT 95 SKIP
               "└───────────────────┘" AT 95 SKIP(2)
        with no-box frame toptop size 120 by 5 no-label.
    end.	
    /** Бурягин end */
    
      display caps(br-name) @ name-bank skip(2)                   
              "КАССОВЫЙ " skip                                    
              "ЖУРНАЛ ПО РАСХОДУ" skip                            
               "ЗА"  date-rep "К-Т " long-acct SKIP(2)            
              "ВАЛЮТА: "  (if available currency then name-currenc
                           else "не повезло") format "x(20)"      
              with no-box frame top no-label.                     
              form with frame cs down.
      for each op-entry where op-entry.acct-cr eq acct.acct
                          and op-entry.op-status >= gop-status
			                    and op-entry.op-date >= end-date
                          /* and op-entry.amt-cur ne 0 */ NO-LOCK,
        each op where op.op eq op-entry.op
                  and (if nightkas then can-do(iPar,op.op-kind)
                                   else not can-do(iPar,op.op-kind)) 
          /* добавил Кунташев чтобы отбирались документы которые переносились */ 
                  and (if branch.branch-id = "00002" or nightkas then end-date eq op.doc-date
                                                                 else end-date eq op.op-date)                                   
                  NO-LOCK
	     break 
	        by op.user-inspector
                by op-entry.op 
	        by op-entry.amt-cur
                on endkey undo, return with frame cs width 136:
         down.

       /** Бурягин добавил поиск и условие 24.07.2006 10:45 */
		    if op-entry.acct-db begins "20202" then do:
    			find first bfrAcct where bfrAcct.acct = op-entry.acct-db no-lock.
    			if bfrAcct.branch-id <> acct.branch-id and branch.branch-id = "00002" then do:
    				next.
    			end.
    		end.
    		/** Бурягин end */
    		
         IF op.doc-num BEGINS "П" THEN NEXT.
   
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
         accumulate op-entry.amt-rub  (total).
         accumulate op-entry.amt-cur  (total).
 
    	 accumulate op.doc-num        (count).

         accumulate op-entry.amt-cur (total by op.user-inspector).
         accumulate op-entry.amt-rub (total by op.user-inspector).
 

         FIND FIRST doc-type WHERE doc-type.doc-type EQ op.doc-type NO-LOCK NO-ERROR.

         display
            doc-count column-label "N П/П"
            op.doc-num column-label "НОМЕР!ОРДЕРА"
            doc-type.name-doc column-label  "НАИМЕНОВАНИЕ!ДОКУМЕНТА"
            {out-fmt.i op-entry.acct-db fmt} when op-entry.acct-db ne ? @ acct.acct
            {out-fmt.i xop-entry.acct-db fmt} when op-entry.acct-db eq ? 
                                               and avail xop-entry @ acct.acct
            op-entry.amt-cur column-label "СУММА ПО НОМИНАЛУ"
            op-entry.amt-rub column-label "СУММА РУБЛ.ЭКВИВ."
/*            FRealSymbol (ROWID (op-entry), YES) column-label "СИМВОЛ!КАССОВОЙ!ОТЧЕТНОСТИ" */ .
 
         IF LAST-OF(op.user-inspector) and suppinsp THEN DO:
            find first _user where _user._userid eq op.user-inspector no-lock no-error.
            down with frame cs.
            underline doc-count acct.acct doc-type.name-doc op.doc-num
                      op-entry.amt-cur op-entry.amt-rub with frame cs.
            display "ИТОГО" @ op.doc-num
                    _user._user-name @ doc-type.name-doc      
                    ins-count @ acct.acct
                    accum total by op.user-inspector op-entry.amt-cur @ op-entry.amt-cur
                    accum total by op.user-inspector op-entry.amt-rub @ op-entry.amt-rub with frame cs.
            DOWN 1.
            doc-count = 0.
            ins-count = 0.
        END.
      end.

      down with frame cs.
      underline doc-count acct.acct doc-type.name-doc op.doc-num
                op-entry.amt-cur op-entry.amt-rub with frame cs.
      down with frame cs.

      display "ИТОГО" @ op.doc-num
/* alex_lom*/                             
              all-count @ acct.acct
              accum total op-entry.amt-cur @ op-entry.amt-cur
              accum total op-entry.amt-rub @ op-entry.amt-rub  with frame cs.

      find first _user where _user._userid eq user("bisquit") no-lock no-error.                                 
      if avail _user then do:                                                                                   
                                                                                                             
         user2 = _user._user-name.                                                                              
         find first signs where signs.code eq "Должность"                                                       
                            and signs.file-name eq "_user"                                                      
                            and signs.surrogate eq _user._userid no-lock no-error.
      if avail signs then do:                                                                                
            user1 = signs.xattr-value.                                                                          
                                                                                                             
            find first signs where signs.code eq "Отделение"                                                    
                             and signs.file-name eq "_user"                                                     
                             and signs.surrogate eq _user._userid                                               
                             no-lock no-error.                                                                  
            if avail signs then do:                                                                             
               find first x-signs where x-signs.code eq "ЗавКасДол"                                             
                                and x-signs.file-name eq "branch"                                               
                                and x-signs.surrogate eq signs.xattr-value                                      
                                no-lock no-error.                                                               
               if avail x-signs then do:                                                                        
                 user3 = x-signs.xattr-value.                                                                   
               end.                                                                                             
               find first x-signs where x-signs.code eq "ЗавКас"                                                
                                and x-signs.file-name eq "branch"                                               
                                and x-signs.surrogate eq signs.xattr-value                                      
                                no-lock no-error.                                                               
               if avail x-signs then do:                                                                        
                  user4 = x-signs.xattr-value.                                                                  
               end.                                                                                             
            end.                                                                                                
         end.                                                                                                   
      end.        
      all-count=0.                                                                                              

                                                              

      if nightkas then 
 display
         skip(2)  
         "Кассир                             __________________" skip(2)      
	 "Бухгалтерский работник (контролер) __________________" skip(2) 
         "Заведующий кассой                  __________________" skip(2)
         "СВЕРЕНО:" skip(1)
	 "Гл.Бухгалтер                       __________________" skip(2).	       
      else   display 
         skip(2) 
         "Бухгалтерский работник (контролер) __________________" skip(2)
         with frame foot no-label.
 
      
      
/*       "     " user1 format "x(35)" "   "  user2 format "x(20)" skip(2)       
         "     " user3 format "x(35)" "   "  user4 format "x(20)" skip(2)
         with frame foot no-label.
 */
         page.                                                                 
    END.
END.
{preview.i}
