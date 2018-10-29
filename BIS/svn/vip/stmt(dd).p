{globals.i}
{intrface.get print}
{sh-defs.i}
{pick-val.i}
{chkacces.i}

{getdates.i}

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

ASSIGN mdtBegDate = beg-date /* ������㥬 ����, �⮡� tempacct.i �� �����⨫ �� */
       mdtEndDate = end-date.
{tempacct.i
   &tempacct_i = "YES"}
ASSIGN beg-date = mdtBegDate /* ����⠭�������� �ᯮ�祭��� */
       end-date = mdtEndDate.

{stmt.i new }
{getstmt.i}

IF mIsSeparate AND ts.cmode EQ 3 THEN
DO:
   ts.cmode = 1.

   FOR EACH tmprecid NO-LOCK,
       FIRST acct WHERE RECID(acct) = tmprecid.id NO-LOCK
                  BY acct.bal-acct
                  BY SUBSTRING(acct.acct,vSortPoz):

      {on-esc RETURN}

      IF NOT {acctlook.i} THEN
         NEXT.

            /* �஢�ઠ �ࠢ� ����㯠 � ���� �� ⨯� ������ */
      IF     acct.cust-cat         EQ "�"
         AND mAvGrList NE "*"
         AND NOT GetPersonPermissionIList(mAvGrList,acct.cust-id)
      THEN NEXT.

      {stmt-prt.i &NEXT    ="NEXT"
                  &begdate = beg-date
                  &enddate = end-date
                  &bufacct = acct
      }
   END.
   ts.cmode = 2.
   ts.name-vip = "������� �� �������� �����".
END.

for each tmprecid no-lock,
   first acct where recid(acct) = tmprecid.id no-lock
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
               &begdate = beg-date
               &enddate = end-date
               &bufacct = acct
   }
end.

{stmtview.i}
{intrface.del}

