{pirsavelog.p}
/* ------------------------------------------------------
File          : $RCSfile: pir-pril7.p,v $ $Revision: 1.1 $ $Date: 2008-04-30 06:46:21 $
Copyright     : ��� �� "�p������������"
���������    : POSNEW1.P
��稭�       : �ਪ�� �64 �� 25.10.2005
�����祭��    : �ਫ������ �7
��ࠬ����     : - ��砫쭠� ���
              : - ����筠� ���
              : - ��� ���ࠧ�������
              : - ��� ����             
              : - ��� ����� ������              
���� ����᪠ : �����஢騪 �����, ��楤�� pir-shdrep.p 
����         : $Author: kuntash $ 
���������     : $Log: not supported by cvs2svn $
------------------------------------------------------ */
DEF INPUT PARAM iBegDate    AS DATE NO-UNDO. /* ��砫쭠 ���         */
DEF INPUT PARAM iEndDate    AS DATE NO-UNDO. /* ����筠� ���         */
DEF INPUT PARAM iBranch     AS CHAR NO-UNDO. /* ��� ���ࠧ��������    */
DEF INPUT PARAM iReport     AS CHAR NO-UNDO. /* ��� ����          */
DEF INPUT PARAM iClass      AS CHAR NO-UNDO. /* ��� ����� ������      */
DEF INPUT PARAM iBalCat     AS CHAR NO-UNDO. /* ᯨ᮪ �����ᮢ�� ��⮢ */



DEFINE VARIABLE in-DataClass-Id LIKE DataClass.DataClass-Id NO-UNDO.
DEFINE VARIABLE in-branch-id    LIKE DataBlock.Branch-Id    NO-UNDO.
DEFINE VARIABLE Out-Data-Id     LIKE DataBlock.Data-Id      NO-UNDO.
DEFINE VARIABLE in-beg-date     LIKE DataBlock.beg-date     NO-UNDO.
DEFINE VARIABLE in-end-date     LIKE DataBlock.end-date     NO-UNDO.
DEFINE VARIABLE in-partition    LIKE user-proc.partition    NO-UNDO.

{globals.i}
{norm.i NEW}

ASSIGN
   in-beg-date     = iBegDate
   in-end-date     = iEndDate
   in-dataClass-Id = iClass
   in-branch-id    = iBranch
.

gRemote = yes.

{norm-beg.i 
   &recalc    = YES
   &nobeg     = YES 
   &noend     = YES 
   &hibeg     = YES 
   &nofil     = YES
   &title     = "'��������� ������'" 
   &is-branch = YES 
   &with-zo   = YES}

{justamin}  
RUN sv-get.p (       in-dataClass-Id, 
                     in-branch-id, 
                     in-end-date, 
                     in-end-date, 
              OUTPUT out-data-id).

RUN norm-rpt.p (in-partition, iReport, in-branch-id, in-end-date, in-end-date).
 
