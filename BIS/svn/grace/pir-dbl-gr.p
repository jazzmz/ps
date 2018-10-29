/*************************
 *
 * ���. 䨫����� ��� ��楤��� ����襭��
 * �� ������⠬. �᪫�砥� ������� ࠡ���
 * �࠭���樨 
 * ��蠥��� ���. ४�� �� all_flt
 *
 *************************
 *
 * ����: ��᪮� �.�.
 * ���: #2700
 * ��� ᮧ�����: 15.04.2013
 *
 **************************/
{globals.i}
{svarloan.def}
{loan-def.i}
{pick-val.i}
{flt-file.i} /* ������� 䨫��� �� ������ࠬ */
{l-table.def new}
{sh-defs.i}
{all_note.def} /* ������ � recid, ��࠭��� �� 䨫���� ����ᥩ Shared */
{flt_var.def}
{over-def.def} /* ���ᠭ�� ⠡���� over-error */
{loan.pro}     /* DS - ����� � ���ﬨ ⠡���� loan. */
{mf-loan.i}

{intrface.get xclass}
{tloan.pro}
{intrface.get loan}
{intrface.get ovl}
{intrface.get op}
{intrface.get bag}
{intrface.get blkob}

DEF INPUT PARAM oprid AS RECID NO-UNDO.

DEF BUFFER bloan-cond for loan-cond.

DEF VAR mTotalRecs  AS INT64     NO-UNDO.
def var bDel as logical NO-UNDO.
/*message "����" VIEW-AS ALERT-BOX.*/

FIND LAST all_recids NO-ERROR.
IF NOT AVAIL all_recids THEN
DO:
   {intrface.del tloan}
   {intrface.del loan}
   {intrface.del ovl}
   {intrface.del op}
   RETURN.
END.
ELSE
   mTotalRecs = all_recids.count.

find first flt-template NO-LOCK.

/*message "����" flt-template.op-kind VIEW-AS ALERT-BOX.*/

FOR EACH all_recids, 
  loan WHERE RECID(loan) = all_recids.rid NO-LOCK:

  bDel = false.

  for each loan-int where loan-int.contract   = loan.contract
                       and loan-int.cont-code = loan.cont-code
                       and loan-int.mdate     = svPlanDate 
                       NO-LOCK,
      first op where op.op = loan-int.op
                 and op.op-kind = flt-template.op-kind
     NO-LOCK:
        bDel = true.
/*        message "������ ����� �� �������� " loan.cont-code VIEW-AS ALERT-BOX.*/

  end.

    find last loan-cond where loan-cond.contract   = loan.contract
                          and loan-cond.cont-code  = loan.cont-code
                          and loan-cond.since     <= svPlanDate  
                          NO-LOCK NO-ERROR.


   IF GetXattrValueEx("loan-cond", loan-cond.contract + "," 
                                 + loan-cond.cont-code + "," 
                                 + STRING(loan-cond.since,"99/99/99"), "�३�","���") = "��" then bDel = true.


  if bDel then DELETE all_recids.

END.

/*����� ��ன ��室 ��� �३�-�࠭襩*/

