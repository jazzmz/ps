/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1996 ТОО "Банковские информационные системы"
     Filename: jourttlp.i
      Comment: Кассовый журнал по расходу по документам (чекам)
   Parameters:
         Uses:
      Used by: outjour*
      Created: 18/03/2004 Nav

     					 21.07.2006 17:01 Бурягин Е.П. - добавлен штапм. Выводится на печать в случае
     					                  если код отделения = 00002.
     					 21.07.2006 17:03 Бурягин Е.П. - закоментирован диалог "Вечерняя касса"
     					 24.07.2006 10:42 Бурягин Е.П. - добавил условие, которое исключает из отчета 
     					                  операции аванса/возврата в/из кассы послеоперационного обслуживания.
*/

&glob end-date end-date

{korder.i}

DEFINE INPUT PARAMETER iPar AS CHAR.

DEF VAR mRealSymbol AS CHAR           NO-UNDO.
def var spbal as char                 no-undo.
def var x     as char    format   "x" no-undo.
def var fa    as logical              no-undo.
def var br    as logical              no-undo.
def var br-name   like branch.name    no-undo.
def var user1 as char             no-undo.
def var user2 as char             no-undo.
def var user3 as char             no-undo.
def var user4 as char             no-undo.
def var username as char             no-undo.
def var doc-count as int format ">>>>9" no-undo. 
def var all-count as int format ">>>>9" no-undo. 
def var ins-count as int format ">>>>9" no-undo. 
def var date-rep  like op-date.op-date no-undo.
def var suppress as logical format "Да/Нет" init yes no-undo.
def var nightkas as logical format "Да/Нет" init yes no-undo.
def buffer   xacct     for acct.
def buffer   xop-entry for op-entry.
def buffer   x-signs   for signs.
def workfile wf
       field bal-acct like acct.bal-acct
       field symbol   like op-entry.symbol
       field summa    as   dec
       field branch   like branch.branch-id.

/** Бурягин добавил определение буфера 24.07.2006 10:06 */
def buffer bfrAcct for acct.
/** Признак отображения штампа послеоперационного обслуживания */
def var label_displayed as logical initial no. 
/** Бурягин end */

/*===============================================================================================*/

message "Вечерняя касса ?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO update nightkas.
message "Подводить итоги по кассирам ?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO update suppress.

FOR EACH tmprecid, FIRST branch WHERE recid(branch) = tmprecid.id NO-LOCK ,
    each acct   where acct.contract begins "Касса"
                    and acct.currency eq ""
                    AND acct.acct-cat EQ "b"
                    and (acct.close-date eq ? or acct.close-date >end-date)
                    AND acct.branch = branch.branch-id 
              use-index acct-cont no-lock,
    each op-entry where op-entry.{&DESK_ACCT} eq acct.acct
                    and op-entry.op-status    > "A"  /* >= gop-status*/
                    and op-entry.op-date      >= end-date no-lock,
    first bfrAcct where bfrAcct.acct = op-entry.{&CLNT_ACCT}
                    and ((bfrAcct.acct begins "20202810"
                          and
                          bfrAcct.branch-id = acct.branch-id
                         ) or (
                          bfrAcct.acct begins "20202810"
                          and
                          acct.branch-id <> "00002"
                          and 
                          bfrAcct.branch-id <> acct.branch-id
                         ) or (
                          not bfrAcct.acct begins "20202810"
                         )) no-lock, 
    each op where op.op eq op-entry.op
                   and (if nightkas then can-do(iPar,op.op-kind)
                                    else not can-do(iPar,op.op-kind))
                     /* изменено Кунташевым для выборки по послеоперационке и вечерней */
                   and (if branch.branch-id = "00002" or nightkas then end-date eq op.doc-date
                                     else end-date eq op.op-date)
                                     no-lock,
         doc-type where doc-type.doc-type eq op.doc-type no-lock
    break
       by branch.branch-id
       by acct.bal-acct
       by acct.acct
       by op.user-inspector
       by op-entry.op
       by op-entry.{&CLNT_ACCT}                  /* acct-cr - приход,  acct-db - расход          */
       by op-entry.amt-rub

    on endkey undo, return with frame body size 120 by 1:
/* message "" branch.branch-id first(branch.branch-id) first-of(branch.branch-id). pause.*/

    /** Бурягин добавил поиск и условие 24.07.2006 10:03 */
    /** Buryagin commented 
    if op-entry.{&CLNT_ACCT} begins "20202810" then do:
    		find first bfrAcct where bfrAcct.acct = op-entry.{&CLNT_ACCT} no-lock.
    		if bfrAcct.branch-id <> acct.branch-id and branch.branch-id = "00002" then do:
    			next.
    		end.
    end.
    */
    /** Бурягин end */
    
    doc-count   = doc-count + 1.

    {acctread.i
      &bufacct=acct
      &class-code= acct.class-code
    }
    IF NOT ({&user-rights})THEN next.
    if first-of(acct.bal-acct) then page.
    if first-of(branch.branch-id) then do:
      br-name = branch.name.
      page.
    end.

    mRealSymbol = FRealSymbol (ROWID (op-entry),"{&CLNT_ACCT}" EQ "acct-cr").

    def var long-acct as char format "x(25)" no-undo.
    {get-fmt.i &obj='" + acct.acct-cat + ""-Acct-Fmt"" + "'}
    long-acct = {out-fmt.i acct.acct fmt}.
    
    if nightkas or branch.branch-id = "00002" then do:
       find last op-date where op-date.op-date < end-date no-lock no-error.
       /* date-rep = op-date.op-date.*/
       date-rep = op.doc-date.
    end.
    else do:
       date-rep = end-date.
    end.
    
    /** Бурягин добавил условие 21.07.2006 15:39 */
    
    if not label_displayed and (branch.branch-id = "00002") then do:
    	label_displayed = yes.
    	display  "┌───────────────────┐" AT 95 SKIP
               "│   Обслуживание    │" AT 95 SKIP
               "│в послеоперационное│" AT 95 SKIP
               "│      время        │" AT 95 SKIP
               "└───────────────────┘" AT 95 SKIP(2)
        with no-box frame toptop size 120 by 5 no-label.
    end.
    
    if not label_displayed and nightkas then do:
    	label_displayed = yes.
    	display  "┌───────────────────┐" AT 95 SKIP
               "│   Обслуживание    │" AT 95 SKIP
               "│в послеоперационное│" AT 95 SKIP
               "│      время        │" AT 95 SKIP
               "└───────────────────┘" AT 95 SKIP(2)
        with no-box frame toptop size 120 by 5 no-label.
    end.
		/** Бурягин end */

    form         
        doc-count column-label "N П/П"
        op.doc-num column-label "НОМЕР!ОРДЕРА"
        doc-type.name-doc column-label  "НАИМЕНОВАНИЕ!ДОКУМЕНТА"
        op-entry.{&CLNT_ACCT} /* column-label "  " */
        op-entry.amt-rub column-label "СУММА РУБЛ.ЭКВИВ."
        op-entry.symbol  column-label "СИМВОЛ!КАССОВОЙ ОТЧЕТНОСТИ"
        header caps(br-name) format "x(55)" SKIP(2)
               "КАССОВЫЙ"
               {&JOUR_NAME}  format "x(20)" SKIP
               "ЗА"  date-rep {&NAME_GOL} format "x(6)" long-acct SKIP(2)
        with frame body down.
			
    release xop-entry.
    if op-entry.{&CLNT_ACCT} eq ? then
       find first xop-entry of op where xop-entry.{&DESK_ACCT} eq ? no-lock no-error.

    find first xacct where xacct.acct     eq (if op-entry.{&CLNT_ACCT} eq ?
                                                 then xop-entry.{&CLNT_ACCT}
                                                 else op-entry.{&CLNT_ACCT})
                       and xacct.currency begins op-entry.currency  no-lock.

    if first-of(acct.acct) then fa = yes.

    if not can-do(spbal,string(xacct.bal-acct,"99999")) then do:
       accumulate op-entry.amt-rub (total by acct.acct)
                  op-entry.amt-rub (total by op-entry.op)
                  op-entry.amt-rub (count by op-entry.op)
                  op-entry.amt-rub (total by op.user-inspector)
                  op-entry.amt-rub (count by op.user-inspector)
                  op-entry.amt-rub (total by branch.branch-id by acct.bal-acct ).

       IF LAST-OF(op-entry.op) THEN DO:
          all-count = all-count + 1.
          ins-count = ins-count + 1.
       END.

       find first wf where wf.bal-acct eq acct.bal-acct
                       and wf.symbol   eq mRealSymbol
                       and wf.branch   EQ acct.branch-id no-error.
       if not available(wf) then do:
          create wf.
          assign
             wf.bal-acct = acct.bal-acct
             wf.symbol   = mRealSymbol
             wf.branch   = acct.branch-id.
       end.
       wf.summa = wf.summa + op-entry.amt-rub.

       display
              doc-count
              op.doc-num
              doc-type.name-doc
              {out-fmt.i op-entry.{&CLNT_ACCT}  fmt} when op-entry.{&CLNT_ACCT} ne ? @ op-entry.{&CLNT_ACCT}
              {out-fmt.i xop-entry.{&CLNT_ACCT} fmt} when op-entry.{&CLNT_ACCT} eq ?
                                                      and available(xop-entry)  @ op-entry.{&CLNT_ACCT}
              op-entry.amt-rub
              mRealSymbol @ op-entry.symbol
       .
       fa = no.
    end.                     
    if last-of(op.user-inspector) and suppress and
       (accum total by op.user-inspector op-entry.amt-rub) ne 0 then do:
       find first _user where _user._userid eq op.user-inspector no-lock no-error.
              /*Добавил Кунташев В.Н. */
       IF AVAIL _user THEN username = _user._user-name.
       								ELSE username = "      НПБ".

       underline doc-count 
                 op.doc-num
                 doc-type.name-doc 
                 op-entry.{&CLNT_ACCT}
                 op-entry.amt-rub
                 op-entry.symbol. down.
       display "ИТОГО" @ op.doc-num
               username @ doc-type.name-doc      
               ins-count @ op-entry.{&CLNT_ACCT} 
               accum total by op.user-inspector op-entry.amt-rub @ op-entry.amt-rub.

       down 1.
       doc-count = 0.
       ins-count = 0.
    end.

    if last-of(acct.acct) and
       (accum total by acct.acct op-entry.amt-rub) ne 0 then do:
       underline doc-count 
                 op.doc-num
                 doc-type.name-doc 
                 op-entry.{&CLNT_ACCT}
                 op-entry.amt-rub
                 op-entry.symbol. down.

       display "ИТОГО" @ op.doc-num
               all-count @ op-entry.{&CLNT_ACCT}
               accum total by acct.acct op-entry.amt-rub @ op-entry.amt-rub.
       down 2.
       ASSIGN
          user1 = ""
          user2 = ""
          user2 = ""
          user3 = ""
       .

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
      
     if nightkas then display
         skip(2)
         "Кассир                            __________________" skip(2)
	 "Бухгалтерский работник (контролер)__________________" skip(2)
	 "Заведующий кассой                 __________________" skip(2)
         "СВЕРЕНО:" skip(1)
	 "Гл.Бухгалтер                      __________________" skip(2)
	 with frame opreq.
     else  display 
         skip(2)
 
         "Бухгалтерский работник (контролер)__________________" skip(2)
         with frame foot no-label.


/*       display skip(2)
               "     " user1 format "x(35)" "   "  user2 format "x(20)" skip(2)
               "     " user3 format "x(35)" "   "  user4 format "x(20)" skip(2)
          with frame foot no-label.
 */
       doc-count = 0.
       all-count = 0.
    end.
end.
/*************************************************************************************************/
