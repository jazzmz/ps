/*   ��誨ॢ �.�.
        31/07/97 ���室 �� INT64 -> decimal

*/

{globals.i}
{intrface.get print}
{sh-defs.i}
{pick-val.i}
{chkacces.i}

{getdate.i}
&GLOBAL-DEFINE BreakPageOfUser YES


DEFINE VARIABLE mdtBegDate LIKE beg-date.
DEFINE VARIABLE mdtEndDate LIKE beg-date.

DEFINE VARIABLE mIsSeparate AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mAvGrList   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mIsFirst    AS LOGICAL    NO-UNDO.

DEFINE VARIABLE mIsMacro     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mMaxWidthTxt AS INT64     NO-UNDO.
DEFINE VARIABLE vLine        AS CHARACTER NO-UNDO.
{initstrp.i}
{op-print.pro}

{get-bankname.i}
name-bank = cBankname .

mIsSeparate = FGetSetting("�믨᪨", "���冷�", "���") EQ "�믨᪠".
/* ����砥� ᯨ᮪ ����㯭�� ���짮��⥫� ��㯯 �����⮢ */
mAvGrList = GetRightPersGroup().

if end-date = ? then undo, retry.
if not can-find(first op-entry where op-entry.op-date eq end-date) then do:
        {message "|�� ��� ���� �� �뫮 �஢����"}
        undo, retry.
end.

ASSIGN mdtBegDate = beg-date /* ������㥬 ����, �⮡� getbac.i �� �����⨫ �� */
       mdtEndDate = end-date.
{getbac.i} 
ASSIGN beg-date = mdtBegDate /* ����⠭�������� �ᯮ�祭��� */
       end-date = mdtEndDate.

{getuser2.i}
{stmt.i new "/*"}
{getstmt.i}
mIsFirst = YES.

IF mIsSeparate AND ts.cmode EQ 3 THEN
DO:
   ts.cmode = 1.

   for each bal-acct where bal-acct.acct-cat begins in-acct-cat
                       and can-do(bac,string(bal-acct.bal-acct, "99999")) no-lock,
      each acct of bal-acct where (access EQ "" OR acct.user-id EQ access)
                             and acct.acct-cat begins in-acct-cat
       and (if num-entries(list-id) > 1 then can-do(list-id,acct.user-id) else true)
       and can-do(cur,acct.currency)
       and (acct.close-date eq ? or acct.close-date >= end-date)
       and acct.open-date <= end-date
      no-lock
      break by acct.user-id
      by bal-acct.bal-acct
      by substr(acct.acct,vSortPoz)
      on endkey undo, leave:

      {on-esc return}
      if not {acctlook.i} then next.

            /* �஢�ઠ �ࠢ� ����㯠 � ���� �� ⨯� ������ */
      IF     acct.cust-cat         EQ "�"
         AND mAvGrList NE "*"
         AND NOT GetPersonPermissionIList(mAvGrList,acct.cust-id)
      THEN NEXT.

      if first-of(acct.user-id) then do:
         find _user where _user._userid = acct.user-id no-lock no-error.
         put unformatted
            skip(2)
            "***** ���������: " + _user._user-name + " (" + _user._userid
            + ") *****"
            skip.
      end.
      {stmt-prt.i &NEXT    ="NEXT"
                  &begdate = end-date
                  &enddate = end-date
                  &bufacct = acct
      }
   end.
   ts.cmode = 2.
   ts.name-vip = "������� �� �������� �����".
END.
mIsFirst = YES.

for each bal-acct where bal-acct.acct-cat begins in-acct-cat
                    and can-do(bac,string(bal-acct.bal-acct, "99999")) no-lock,
   each acct of bal-acct where (access EQ "" OR acct.user-id EQ access)
                          and acct.acct-cat begins in-acct-cat
    and (if num-entries(list-id) > 1 then can-do(list-id,acct.user-id) else true)
    and can-do(cur,acct.currency)
    and (acct.close-date eq ? or acct.close-date >= end-date)
    and acct.open-date <= end-date
   no-lock
   break by acct.user-id
   by bal-acct.bal-acct
   by substr(acct.acct,vSortPoz)
   on endkey undo, leave:

   {on-esc return}
   if not {acctlook.i} then next.

         /* �஢�ઠ �ࠢ� ����㯠 � ���� �� ⨯� ������ */
   IF     acct.cust-cat         EQ "�"
      AND mAvGrList NE "*"
      AND NOT GetPersonPermissionIList(mAvGrList,acct.cust-id)
   THEN NEXT.

   if first-of(acct.user-id) then do:
      find _user where _user._userid = acct.user-id no-lock no-error.

      IF ts.vmode-proc BEGINS "stmtb"
         AND ts.break_user EQ YES THEN
         DO:

            IF mIsFirst THEN
               mIsFirst = NO.
            ELSE
               PAGE.
         END.
      put unformatted
         skip(2)
         "***** ���������: " + _user._user-name + " (" + _user._userid
         + ") *****"
         skip.
   end.
   {stmt-prt.i &NEXT    ="NEXT"
               &begdate = end-date
               &enddate = end-date
               &bufacct = acct
   }
end.

{stmtview.i}
{intrface.del}

