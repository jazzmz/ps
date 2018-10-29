/*
                ­ª®¢áª ï ¨­â¥£à¨à®¢ ­­ ï á¨áâ¥¬  ˆ‘ª¢¨â
    Copyright: (C) 1992-1996 ’ŽŽ " ­ª®¢áª¨¥ ¨­ä®à¬ æ¨®­­ë¥ á¨áâ¥¬ë"
     Filename: jourttlp.i
      Comment: Š áá®¢ë© ¦ãà­ « ¯® à áå®¤ã ¯® ¤®ªã¬¥­â ¬ (ç¥ª ¬)
   Parameters:
         Uses:
      Used by: outjour*
      Created: 18/03/2004 Nav
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
def var doc-count as int format ">>>>9" no-undo. 
def var all-count as int format ">>>>9" no-undo. 
def var ins-count as int format ">>>>9" no-undo. 
def var date-rep  like op-date.op-date no-undo.
def var suppress as logical format "„ /¥â" init yes no-undo.
def var nightkas as logical format "„ /¥â" init yes no-undo.

def buffer   xacct     for acct.
def buffer   xop-entry for op-entry.
def buffer   x-signs   for signs.
def workfile wf
       field bal-acct like acct.bal-acct
       field symbol   like op-entry.symbol
       field summa    as   dec
       field branch   like branch.branch-id.


/*===============================================================================================*/

message "‚¥ç¥à­ïï ª áá  ?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO update nightkas.
message "®¤¢®¤¨âì ¨â®£¨ ¯® ª áá¨à ¬ ?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO update suppress.

FOR EACH tmprecid, FIRST acct WHERE recid(acct) = tmprecid.id NO-LOCK,
    each op-entry where op-entry.{&DESK_ACCT} eq acct.acct
                    and op-entry.op-status    >= gop-status
                    and op-entry.op-date      eq end-date no-lock,
         each op where op.op eq op-entry.op
                   and (if nightkas then can-do(iPar,op.op-kind)
                                    else not can-do(iPar,op.op-kind)) no-lock,
         each doc-type where doc-type.doc-type eq op.doc-type no-lock
    break
       by acct.bal-acct
       by acct.acct
       by op.user-inspector
       by op-entry.op
       by op-entry.{&CLNT_ACCT}                  /* acct-cr - ¯à¨å®¤,  acct-db - à áå®¤          */
       by op-entry.amt-rub

    on endkey undo, return with frame body size 120 by 1:

    doc-count   = doc-count + 1.

    {acctread.i
      &bufacct=acct
      &class-code= acct.class-code
    }
    IF NOT ({&user-rights})THEN next.
    if first-of(acct.bal-acct) then page.

    mRealSymbol = FRealSymbol (ROWID (op-entry),"{&CLNT_ACCT}" EQ "acct-cr").

    def var long-acct as char format "x(25)" no-undo.
    {get-fmt.i &obj='" + acct.acct-cat + ""-Acct-Fmt"" + "'}
    long-acct = {out-fmt.i acct.acct fmt}.

    if nightkas then do:
       find last op-date where op-date.op-date < end-date no-lock no-error.
       date-rep = op-date.op-date.
    end.
    else do:   
       date-rep = end-date.
    end.

    form
        doc-count column-label "N /"
        op.doc-num column-label "ŽŒ…!Ž„…€"
        doc-type.name-doc column-label  "€ˆŒ…Ž‚€ˆ…!„ŽŠ“Œ…’€"
        op-entry.{&CLNT_ACCT} column-label "Š-’"
        op-entry.amt-rub column-label "‘“ŒŒ€ “‹.Š‚ˆ‚."
        op-entry.symbol  column-label "‘ˆŒ‚Ž‹!Š€‘‘Ž‚Ž‰ Ž’—…’Ž‘’ˆ"
        header caps(br-name) format "x(55)" SKIP(2)
               "Š€‘‘Ž‚›‰"
               {&JOUR_NAME}  format "x(20)" SKIP
               "‡€"  date-rep "„-’ " long-acct SKIP(2)
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
                  op-entry.amt-rub (total by acct.bal-acct ).

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
       underline doc-count 
                 op.doc-num
                 doc-type.name-doc 
                 op-entry.{&CLNT_ACCT}
                 op-entry.amt-rub
                 op-entry.symbol. down.
       display "ˆ’ŽƒŽ" @ op.doc-num
               _user._user-name @ doc-type.name-doc      
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

       display "ˆ’ŽƒŽ" @ op.doc-num
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
          find first signs where signs.code eq "„®«¦­®áâì"
                             and signs.file-name eq "_user"
                             and signs.surrogate eq _user._userid no-lock no-error.
          if avail signs then do:
             user1 = signs.xattr-value.

             find first signs where signs.code eq "Žâ¤¥«¥­¨¥"
                              and signs.file-name eq "_user"
                              and signs.surrogate eq _user._userid 
                              no-lock no-error.
             if avail signs then do:
                find first x-signs where x-signs.code eq "‡ ¢Š á„®«"
                                 and x-signs.file-name eq "branch"
                                 and x-signs.surrogate eq signs.xattr-value 
                                 no-lock no-error.
                if avail x-signs then do:
                  user3 = x-signs.xattr-value.
                end.
                find first x-signs where x-signs.code eq "‡ ¢Š á"
                                 and x-signs.file-name eq "branch"
                                 and x-signs.surrogate eq signs.xattr-value 
                                 no-lock no-error.
                if avail x-signs then do:
                   user4 = x-signs.xattr-value.
                end.
             end.
          end.
       end.

       display skip(2)
               "     " user1 format "x(35)" "   "  user2 format "x(20)" skip(2)
               "     " user3 format "x(35)" "   "  user4 format "x(20)" skip(2)
          with frame foot no-label.
       doc-count = 0.
       all-count = 0.
    end.
end.
/*************************************************************************************************/
