
                   /*******************************************
                    *                                         *
                    *  ������� ������������ � �������������!  *
                    *                                         *
                    *  ������������� ������ ���� ����������,  *
                    *  �.�. �� ��������� ����������� �������  *
                    *             �������������!              *
                    *                                         *
                    *******************************************/

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2002 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: acctvedf.frm
      Comment: ��।������ �� ��� 横��� ���� acctvedf
      Comment:
   Parameters:
         Uses:
      Used by:
      Created: 03/01/02 17:19:36 RepGen
     Modified:
*/

/*--------------- ��।������ ��६����� ---------------*/
Define Variable iYear            As Integer              No-Undo.
Define Variable iYear1           As Integer              No-Undo.
Define Variable iYear2           As Integer              No-Undo.

/*--------------- ��।������ �� ��� 横��� ---------------*/
/* ��ଠ ��� 横�� "header" */
Form
   "�஢�७� �� ����� ��襣� ���." at 5 skip
        "���⢥ত���, �� �஢�ਢ �� ��訬 �믨᪠� �� �����, �� ��⠭�����, �� ���"  at 10 skip
   "ᤥ����  �ࠢ��쭮  �  㪠�����  �  ���  ���⪨  ���������  ᮮ⢥������" at 5 skip
   "���⪠� �� ��襬� ����." at 5 skip(3)
        "�.�.                        �㪮����⥫�  ____________" at 10 skip(2)
        "<____> ______________" at 5 iYear format "9999" at 27 "�.    ��.��壠���  ____________" at 32 skip(2)
       "�����饥 ���⢥ত���� ���⪮� ᢥ७� � ��⠬� ������ � ��ࠧ栬� �����ᥩ."  at 5 skip(2)
        "�.�.                 ����㤭�� �����  ________________" at 10 skip(2)
        "<____> ______________" at 5 iYear1 format "9999" at 27 "�.              ________________" at 32 skip
with frame acctvedf-Frame-1 down no-labels no-underline no-box width 95.

Form
   "���⢥ত��." at 5 skip(3)
        "<____> ______________" at 5 iYear format "9999" at 27 "�.    ������:  _______________" at 32 skip(2)
       "�����饥 ���⢥ত���� ���⪮� ᢥ७� � ��⠬� ������ � ��ࠧ栬� �����ᥩ."  at 5 skip(2)
        "�.�.                 ����㤭�� �����  ________________" at 10 skip(2)
        "<____> ______________" at 5 iYear1 format "9999" at 27 "�.              ________________" at 32 skip
with frame acctvedf-Frame-2 down no-labels no-underline no-box width 95.

Def Var FH_acctvedf-1 as integer init 19 no-undo. /* acctvedf-Frame1: ���. ��ப �� ���室� �� ����� ��࠭��� */


