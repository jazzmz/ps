{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: norm-rpt.p,v $ $Revision: 1.3 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ��� �� "�p������������"
���������    : normcalc.p
��稭�       : �ਪ�� �64 �� 25.10.2005
���� ����᪠ : ??????
����         : ??????
���������     : $Log: not supported by cvs2svn $
���������     : Revision 1.2  2007/08/17 07:35:42  Lavrinenko
���������     : 1. �������� �⠭����� ��������� 2. �ந������� ࠡ��� ��� ���४⭮�� �뭮� norm-end.i norm-rpt.i
���������     :
------------------------------------------------------ */

/*
                ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright:  (C) 1992-1996 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename:  NORMCALC.P
      Comment:

         Uses:
      Used by:
      Created:  09/04/1996 15:09:06 Serge
     Modified:  09/04/1996 15:09:06 Serge
     Modified:  31/03/1997 Serge �।���⥫�� ���� �ਭ� ����, var PrinterWidth
     Modified:  29/05/1997 Serge ������ "���������� 1000" - �� ��室�� �����
                               �� ���⪠�/����⠬ ���㣫����� �� �����/���������.
     Modified:  02/10/1998 Serge �ଠ� (��᫥ ":") ���ਭ������� ⮫쪮, �ᤨ � ��� ��� ")"
     Modified:  27/08/2001 NIK. ���ᠭ�� ��६����� �뭥ᥭ� � 䠩� norm-rpt.def,
                           �᭮���� �ᯮ��塞� ��� �뭥ᥭ � 䠩� norm-rpt.i
*/

Form "~n@(#) NORMCALC.P 1.0 Serge 09/04/96 Serge 09/04/96"
with frame sccs-id stream-io width 250.

{globals.i}
{pick-val.i}

{norm-rpt.def}                                   /* ��।������ ��ࠬ��஢ � ��६�����          */
{norm.i}
{norm.def 
&normshtmp = "yes"
&TDataBlock = "yes"
&TmpText = "yes"
&tab-prn = "yes"
&norm-dates = "yes"}
{calcdate.i}

{n-lines.i &norm=InputFName &file=norm}

{pirraproc.def}
&GLOB filename arch_file_name
{pirraproc.i}																		/*�������: ��⮬���᪮� ��࠭���� ������ �� */

{norm-rpt.i}                                     /* �᭮���� ��ࠡ�⪠ ���� �� ��ଠ⨢��      */

{norm-end.i}

/*************************************************************************************************/
