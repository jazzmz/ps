{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-pril9.p,v $ $Revision: 1.5 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ��� �� "�p������������"
���������    : p14-9bas.p
��稭�       : �ਪ�� �64 �� 25.10.2005
�����祭��    : �ਫ������ �8
��ࠬ����     : - ��砫쭠� ���
              : - ����筠� ���
              : - ��� ���ࠧ�������
              : - ��� 䠩��
              : - ���᮪ �����ᮢ�� ��⥣�਩ ��⮢ �������� � ����஥��� ����              
              : - �������⥫�� ��ࠬ���� ��楤��� �१ ","              
���� ����᪠ : �����஢騪 �����, ��楤�� pir-shdrep.p 
����         : $Author: anisimov $ 
���������     : $Log: not supported by cvs2svn $
���������     : Revision 1.4  2007/08/21 13:39:00  lavrinenko
���������     : ����������� ��࠭���� � ������ � ������ � ��⠫���
���������     :
���������     : Revision 1.3  2007/08/16 14:08:30  Lavrinenko
���������     : ��ࠢ����� ���ᠭ��
���������     :
���������     : Revision 1.2  2007/08/16 13:12:30  Lavrinenko
���������     : ��������� �ଠ� �맮��
���������     :
���������     : Revision 1.1  2007/08/15 14:22:54  Lavrinenko
���������     : ���������  �ਪ��� N9
���������     :
------------------------------------------------------ */
{globals.i}

DEF INPUT PARAM iBegDate    AS DATE NO-UNDO. /* ��砫쭠� ���         */
DEF INPUT PARAM iEndDate    AS DATE NO-UNDO. /* ����筠� ���          */
DEF INPUT PARAM iBranch     AS CHAR NO-UNDO. /* ��� ���ࠧ�������      */
DEF INPUT PARAM iFile       AS CHAR NO-UNDO. /* ��।������� ��� 䠩�� */
DEF INPUT PARAM iParam      AS CHAR NO-UNDO. /* ᯨ᮪ �����ᮢ�� ��⥣�਩ ��⮢ �������� � ����஥��� ���� */

ASSIGN
   gRemote   = YES 
   gbeg-date = iBegDate
   gend-date = iEndDate
.

FIND FIRST branch WHERE branch.branch-id EQ iBranch NO-LOCK NO-ERROR.

{pirraproc.def}
{pirraproc.i &in-beg-date=iBegDate &in-end-date=iEndDate &arch_file_name=iFile &arch_file_name_var=yes}

&GLOB filename arch_file_name
&GLOBAL-DEFINE p14-8 YES /*⠪�� ���� ��ࠧ�� ������� ����� �ᯮ�殮���. ��� #2809*/

{p14-9bas.p }
