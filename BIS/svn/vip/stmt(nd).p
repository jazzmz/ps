{globals.i}
{intrface.get print}
{sh-defs.i}
{pick-val.i}
{chkacces.i}

{getdate.i}

DEFINE VARIABLE mdtBegDate LIKE beg-date.
DEFINE VARIABLE mdtEndDate LIKE beg-date.

DEFINE VARIABLE mIsSeparate AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mAvGrList   AS CHARACTER  NO-UNDO.

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
{stmt.i new "/*" }
{getstmt.i}

def buffer xxxpos for acct-pos.

IF mIsSeparate AND ts.cmode EQ 3 THEN
DO:
   ts.cmode = 1.

   for each xxxpos where xxxpos.since eq end-date
                     and can-do(cur,xxxpos.currency) no-lock,
       each acct of xxxpos where (access EQ "" OR acct.user-id EQ access)
                             and acct.acct-cat begins in-acct-cat
      and (if num-entries(list-id) > 1 then can-do(list-id,acct.user-id) else true)
      and can-do(bac,string(acct.bal-acct, "99999"))
      and (acct.close-date eq ? or acct.close-date >= end-date)
      and acct.open-date <= end-date
      no-lock
           by acct.bal-acct
           by substr(acct.acct,vSortPoz):

      {on-esc return}
      if not {acctlook.i} then next.
            /* �஢�ઠ �ࠢ� ����㯠 � ���� �� ⨯� ������ */
      IF     acct.cust-cat         EQ "�"
         AND mAvGrList NE "*"
         AND NOT GetPersonPermissionIList(mAvGrList,acct.cust-id)
      THEN NEXT.
      {stmt-prt.i &NEXT    ="NEXT"
                  &begdate = end-date
                  &enddate = end-date
                  &bufacct = acct
      }
   end.
   ts.cmode = 2.
   ts.name-vip = "������� �� �������� �����".
END.

for each xxxpos where xxxpos.since eq end-date
                  and can-do(cur,xxxpos.currency) no-lock,
    each acct of xxxpos where (access EQ "" OR acct.user-id EQ access)
                          and acct.acct-cat begins in-acct-cat
   and (if num-entries(list-id) > 1 then can-do(list-id,acct.user-id) else true)
   and can-do(bac,string(acct.bal-acct, "99999"))
   and (acct.close-date eq ? or acct.close-date >= end-date)
   and acct.open-date <= end-date
   no-lock
        by acct.bal-acct
        by substr(acct.acct,vSortPoz):

   {on-esc return}
   if not {acctlook.i} then next.
         /* �஢�ઠ �ࠢ� ����㯠 � ���� �� ⨯� ������ */
   IF     acct.cust-cat         EQ "�"
      AND mAvGrList NE "*"
      AND NOT GetPersonPermissionIList(mAvGrList,acct.cust-id)
   THEN NEXT.
   {stmt-prt.i &NEXT    ="NEXT"
               &begdate = end-date
               &enddate = end-date
               &bufacct = acct
   }
end.

{stmtview.i}
{intrface.del}

