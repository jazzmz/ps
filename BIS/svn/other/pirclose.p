{pirsavelog.p}

/*
               
    Copyright:
     Filename: 
      Comment: 
   Parameters: 
      Used by: 
      Created: 
     Modified: 
*/
/*Form "~n@(#) BPOS_.P Валидация данных и свертка расходов/доходов"
with frame sccs-id stream-io width 250./
*/
{globals.i}
{sv-calc.i &nodebug = yes}
{intrface.get xclass}
/* {sv-temp.i new}*/

def var par_str as char no-undo.
def var par1 as char no-undo.
def var par2 as char no-undo.
def var i as int no-undo.
def var delta as dec extent 2 no-undo.
def var del_a as dec extent 2 no-undo.
def var del_b as dec extent 2 no-undo.
def var del-prt as dec extent 2 no-undo.
def var err as char no-undo.

def var dob as date no-undo.
def var cl-acct-cat as char no-undo.
def var per    as char format "x(20)" no-undo.
def var period as char format "x(12)" no-undo.

/* def buffer xDataLine  for DataLine.
def buffer xbal-acct  for bal-acct.
def buffer xbranch for branch.
{branch.pro}

def query q-branch for xbranch.
find first branch of DataBlock no-lock.
*/
cl-acct-cat = SUBSTRING(dataclass.dataclass-id,1,1).
dob = DataBlock.beg-date.
per = {term2str beg-date end-date }.
period = {sv-tstr beg-date end-date }.
  
if cl-acct-cat eq "b" then
DO:
/* Проверка на 61406 61306 */
for each op where op.doc-date eq DataBlock.beg-date
						and op.doc-num begins "П" no-lock:

    find first op-entry of op where
               op-entry.acct-cr begins "61406" no-lock no-error.
          if avail op-entry then
             do:
             		run normdbg in h_debug (0,"Ошибка","Кредитовая операция при автоматической переоценке по счету "    
             		+  string(op-entry.acct-cr,"x(20)")).
             		             
             MESSAGE color white/red
      				" По счету № "  string(op-entry.acct-cr,"x(20)") SKIP
              " прошла кредитовая операция " 
              "в"
              STRING (DataBlock.beg-date,"99.99.9999")
             VIEW-AS ALERT-BOX.
             
             		DataBlock.IsFinal = NO.
             		             	
              end.
     find first op-entry of op where
                op-entry.acct-db begins "61306" no-lock no-error.
          if avail op-entry then
             do:
             		run normdbg in h_debug (0,"Ошибка","Дебетовая операция при автоматической переоценке по счету "    
             		+  string(op-entry.acct-db,"x(20)")).
             	             		
             		MESSAGE color white/red
      				   " По счету № "  string(op-entry.acct-db,"x(20)") SKIP
                 " прошла  операция " 
                 "в"
                 STRING (DataBlock.beg-date,"99.99.9999")
                VIEW-AS ALERT-BOX. 
                DataBlock.IsFinal = NO.
             end.
 end.
/* Конец проверки 61306 61406 */
END.

/* Проверка на красное сальдо по счетам */
  for each acct-pos where
            acct-pos.filial-id = shFilial and
            acct-pos.since eq dob and
            can-do(cl-acct-cat,acct-pos.acct-cat) and
            acct-pos.acct gt "0" no-lock,
            acct of acct-pos no-lock:
            
		if acct.side eq "А" and acct-pos.balance < 0 then 
						do:
										run normdbg in h_debug (0,"Ошибка","Кредитовое сальдо на активном счете "    
             		                            +  string(acct.acct,"x(20)")).
		                MESSAGE color white/red
      				      " На счете №"  string(acct.acct,"x(20)") SKIP
                    " Кредитовое сальдо" 
                    "на"
                    STRING (DataBlock.beg-date,"99.99.9999")
                    VIEW-AS ALERT-BOX. 
                    DataBlock.IsFinal = NO.
           end.

     if acct.side eq "П" and acct-pos.balance > 0 then 
          do:
                    run normdbg in h_debug (0,"Ошибка","Кредитовое сальдо на пассивном счете "    
             		                            +  string(acct.acct,"x(20)")).
		                MESSAGE color white/red
      				      " На счете №"  string(acct.acct,"x(20)") SKIP
                    " Кредитовое сальдо" 
                    "на"
                    STRING (DataBlock.beg-date,"99.99.9999")
                    VIEW-AS ALERT-BOX. 
                    DataBlock.IsFinal = NO.
           end.
     
     if acct.side eq "П" and acct-pos.balance > 0  and acct.contr-acct ne "" then 
          do:
                    run normdbg in h_debug (0,"Ошибка","Счет не свернулся "    
             		                            +  string(acct.acct,"x(20)")).
		                MESSAGE color white/red
      				      " Счете №"  string(acct.acct,"x(20)") SKIP
                    " не свернулся" 
                    "на №"
                    string(acct.contr-acct,"x(20)")
                    VIEW-AS ALERT-BOX. 
                    DataBlock.IsFinal = NO.
         end.
      
      if acct.side eq "А" and acct-pos.balance < 0  and acct.contr-acct ne "" then 
          do:
                    run normdbg in h_debug (0,"Ошибка","Счет не свернулся "    
             		                            +  string(acct.acct,"x(20)")).
		                MESSAGE color white/red
      				      " Счете №"  string(acct.acct,"x(20)") SKIP
                    " не свернулся" 
                    "на №"
                    string(acct.contr-acct,"x(20)")
                    VIEW-AS ALERT-BOX. 
                    DataBlock.IsFinal = NO.
         end.
         
         
      if acct.close-date <= dob and acct-pos.balance ne 0 then 
             do:
      							run normdbg in h_debug (0,"Ошибка","Ненулевое сальдо на закрытом счете "    
             		                            +  string(acct.acct,"x(20)")).
		                MESSAGE color white/red
      				      " На счете №"  string(acct.acct,"x(20)") SKIP
                    " Ненулевое сальдо на закрытом счете" 
                    "на"
                    STRING (DataBlock.beg-date,"99.99.9999")
                    VIEW-AS ALERT-BOX. 
                    DataBlock.IsFinal = NO.
             end.
              
/*  Проверка свертки расходов доходов на конец месяца */
/* больше не нужно
      if cl-acct-cat eq "b" and acct-pos.balance ne 0 
         and can-do("706*",acct.acct)  and period eq "Квартал" then 
             do:
      							run normdbg in h_debug (0,"Ошибка","Ненулевое сальдо на счете дохода/расхода на конец квартала "    
             		                            +  string(acct.acct,"x(20)")).
		                MESSAGE color white/red
      				      " На счете №"  string(acct.acct,"x(20)") SKIP
                    " Ненулевое сальдо на конец квартала" 
                    "на"
                    STRING (DataBlock.end-date,"99.99.9999")
                    VIEW-AS ALERT-BOX. 
                    DataBlock.IsFinal = NO.
             end. 
*/
      

   end.