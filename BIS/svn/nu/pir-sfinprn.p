/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2005 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: pir-SFINPRN.P
      Comment: ����� ��ୠ�� ����祭��� ��⮢-䠪���
		� ���ᨨ PIR ����ࠢ���� sf-in-[hdr,body,end] �� �।��� 㤠����� "��� ������ ���-䠪����"
   Parameters:
         Uses: 
      Used by:
      Created: 27.01.2005 Gorm  (0045974)
     Modified: 16.06.2005 11:11 gorm     
     Modified:   
*/

{globals.i}
{intrface.get xclass}
{intrface.get axd}
{intrface.get strng}

DEF VAR mContract AS CHAR NO-UNDO.
DEF VAR mTitle AS CHAR NO-UNDO.    /*��������� ����*/

ASSIGN
   mContract = "sf-in"
   mTitle = "��ୠ� ��� ����祭��� ��⮢-䠪���"
    .

{pir-sfprn.i}

{intrface.del}
