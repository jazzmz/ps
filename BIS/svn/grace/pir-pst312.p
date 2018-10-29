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
def var btOk as logical NO-UNDO.


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


def buffer bloan for loan.

/*message "����" flt-template.op-kind VIEW-AS ALERT-BOX.*/

FOR EACH all_recids, 
  loan WHERE RECID(loan) = all_recids.rid NO-LOCK:

  bDel = true.

  if not bDel THEN DO:
     for each bloan where bloan.cont-code begins loan.cont-code + " "
                      and bloan.contract  = loan.contract
                      and bloan.close-date = ?
                      NO-LOCK,
     first loan-int where loan-int.contract   = bloan.contract
                         and loan-int.cont-code = bloan.cont-code
                         and loan-int.mdate     = svPlanDate 
                         and loan-int.id-d = 7                   /*�뭮� �� ������ ����*/
                         and loan-int.id-k = 0 
                         NO-LOCK.
            bDel = false.
      end.
  END.

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

 

  if bDel = false THEN  MESSAGE "������� ����� �� �������� " + loan.contract + "?"  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE BtOk. 
  if btOk = ? or NOT btOk then DELETE all_recids.

  if bDel then DELETE all_recids.

END.

/*����� ��ன ��室 ��� �३�-�࠭襩*/

