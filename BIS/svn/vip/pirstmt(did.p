{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pirstmt(did.p,v $ $Revision: 1.4 $ $Date: 2007-10-18 07:42:24 $
Copyright     : ��� �� "�p������������"
���������    : stmt(did.p, �� ����������� ��୮��� �ࠢ��
��稭�       : �ਪ�� �64 �� 25.10.2005
���� ����᪠ : ��/�����/��室�� ���/����� �� ��楢� ��⠬/�믨᪨
����         : ?????
���������     : $Log: not supported by cvs2svn $
���������     : Revision 1.3  2007/08/16 14:02:30  lavrinenko
���������     : �������� �⠭����� ���������
���������     :
------------------------------------------------------ */
{globals.i}
{sh-defs.i}
{pick-val.i}
{chkacces.i}

{getdate.i}

{intrface.get print}
{intrface.get bag}

DEFINE VARIABLE mdtBegDate LIKE beg-date.
DEFINE VARIABLE mdtEndDate LIKE beg-date.

DEFINE VARIABLE mIsSeparate AS LOGICAL NO-UNDO. 

{get-bankname.i}
name-bank = cBankname .

mIsSeparate = FGetSetting("�믨᪨", "���冷�", "���") EQ "�믨᪠".

if end-date = ? then undo, retry.

ASSIGN mdtBegDate = beg-date /* ������㥬 ����, �⮡� tempacct.i �� �����⨫ �� */
       mdtEndDate = end-date.
{tempacct.i
   &tempacct_i = "YES"}
ASSIGN beg-date = mdtBegDate /* ����⠭�������� �ᯮ�祭��� */
       end-date = mdtEndDate.

{stmt.i new}

/* PIR begin */
&GLOB filename arch_file_name
{pirraproc.def}
{pirraproc.i &in-end-date=end-date &arch_file_name="vipcl.txt"}
/* PIR end */

{getstmt.i "/*"}

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

      {stmt-prt.i &NEXT    ="NEXT"
                  &begdate = end-date
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

   {on-esc leave}
   if not {acctlook.i} then next.
   {stmt-prt.i &NEXT    ="NEXT"
               &begdate = end-date
               &enddate = end-date
               &bufacct = acct
   }
end.
{stmtview.i}
