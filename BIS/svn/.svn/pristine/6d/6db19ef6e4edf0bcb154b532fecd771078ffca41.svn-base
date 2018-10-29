/*
                ­ª®¢áª ï ¨­â¥£à¨à®¢ ­­ ï á¨áâ¥¬  ˆ‘ª¢¨â
    Copyright: (C) 1992-1997 ’ " ­ª®¢áª¨¥ ¨­ä®à¬ æ¨®­­ë¥ á¨áâ¥¬ë"
     Filename: OTDEPO3.P
      Comment: †ãà­ « ®¡®à®â®¢ ‹‘ ¤¥¯®
   Parameters:
         Uses:
      Used by:
      Created: 1/04/97 Nata
     Modified: 18.03.2002 Gunk à®¡«¥¬ë á® áâ âãá®¬ ¯à®¢®¤®ª
     Modified: 20.01.2002 Gunk „à®¡­ë¥ ª®«¨ç¥áâ¢ 
     Modified: 18.07.2006 OZMI (0054745) ‚ ª®­áâàãªæ¨ïå for each ãçâ¥­ ä¨«¨ «.
*/

{globals.i}
{sh-defs.i}
DEFINE INPUT PARAMETER iParmStr AS CHARACTER.
DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.

DEFINE VARIABLE cnt      AS INTEGER     NO-UNDO.
DEFINE VARIABLE cur-date AS DATE        NO-UNDO.
DEFINE VARIABLE fl       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE mFmt     AS CHARACTER   NO-UNDO.

cnt = 7.
{pir-otdepo.i}
{getdaydir.i}

cFileName = getDayDir('/home2/bis/quit41d/imp-exp/Arhiv',INTEGER(iParmStr)) + '/otdepo3.txt'.

if cacct eq "*" then filt = yes .
else filt = no .

FORM
   cur-date
      COLUMN-LABEL "„€’€!‚…‘…ˆŸ!‡€ˆ‘ˆ"
      FORMAT       "99/99/9999"
   sh-in-qty
      COLUMN-LABEL "‘’€’Š €  ‹‘!€ €—€‹ „Ÿ"
      FORMAT       "->>>>>>>>>>>>>>9.9999999"
   sh-qdb
      COLUMN-LABEL "’! „……’“"
      FORMAT       "->>>>>>>>>>>>>>9.9999999"
   sh-qcr
      COLUMN-LABEL "’! Š…„ˆ’“"
      FORMAT       "->>>>>>>>>>>>>>9.9999999"
   sh-qty
      COLUMN-LABEL "‘’€’Š € ‹‘!€ Š…– „Ÿ"
      FORMAT       "->>>>>>>>>>>>>>9.9999999"
WITH FRAME prn WIDTH 200.

ASSIGN
   mFmt                          = GetFmtQty("", "acct", 24, 7)
   sh-in-qty:FORMAT IN FRAME prn = mFmt
   sh-qdb:FORMAT IN FRAME prn    = mFmt
   sh-qcr:FORMAT IN FRAME prn    = mFmt
   sh-qty:FORMAT IN FRAME prn    = mFmt
.
{setdest.i &filename=cFileName}
  cur-date =  beg-date .

  for each acct  where acct.acct-cat eq "d" and
                       (filt or acct.acct eq cacct) and
                       can-do(sec-cod1,acct.currency) AND
                       acct.filial-id EQ shFilial no-lock
        by acct.currency with frame prn :

   find first op-entry where op-entry.acct-cat eq "d" and
                             op-entry.acct-cr eq acct.acct and
                             op-entry.currency eq acct.currency and
                             op-entry.op-status >= gop-status and
                             op-entry.op-date >= beg-date and
                             op-entry.op-date <= end-date no-lock no-error.
   if not avail op-entry then
   find first op-entry where op-entry.acct-cat eq "d" and
                             op-entry.acct-db eq acct.acct and
                             op-entry.op-status >= gop-status and
                             op-entry.currency eq acct.currency and
                             op-entry.op-date >= beg-date and
                             op-entry.op-date <= end-date no-lock no-error.

   if not avail op-entry then next.

   find sec-code where sec-code.sec-code eq acct.currency no-lock no-error .
   cur-date = beg-date .

   put " " skip(2) .
   put unformatted
           caps(dept.name-bank) format "x(55)" skip(1)
           "†“€‹ ’‚ ‹ˆ–…‚ƒ ‘—…’€ „…" skip
           string(if beg-date ne end-date then "c " + string(beg-date) + " ¯® " + string(end-date)
                                   else "") at 1  skip(1)
           "Š„ ‹ˆ–…‚ƒ ‘—…’€ „…:                       " + string(acct.acct) skip(1)
           "Œ… ƒ‘“„€‘’‚…‰ …ƒˆ‘’€–ˆˆ " skip
           "‚›“‘Š€ –, “—ˆ’›‚€…Œ›• € ’Œ ‹ˆ–…‚Œ ‘—…’…: " + sec-code.reg-num
           skip(1)
           "‚…„Œ‘’œ ’‚  ‹ˆ–…‚Œ“ ‘—…’“ „…:" SKIP(1).

   fl = no .
   do while cur-date le end-date with frame prn   :

    run acct-qty in h_base
      (acct.acct,acct.currency,cur-date,cur-date,?).

    if sh-in-qty ne sh-qty or (sh-qdb ne 0 or sh-qcr ne 0) then do:

     disp cur-date
          sh-in-qty  when sh-in-qty gt 0 @ sh-in-qty
         - sh-in-qty when sh-in-qty lt 0 @ sh-in-qty
          0 when sh-in-qty eq  0 @ sh-in-qty
          sh-qdb
          sh-qcr
          sh-qty  when sh-qty ge 0 @ sh-qty
         - sh-qty when sh-qty lt 0 @ sh-qty
          0 when sh-qty eq 0 @ sh-qty skip
          .
       down .
       fl = yes .
    end.
    cur-date = cur-date + 1.
   end.
   if fl then
   put "  " skip(1) .
  end.
