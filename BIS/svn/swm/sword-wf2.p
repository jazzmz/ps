{pirsavelog.p}

/*-----------------------------------------------------------------------------
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2001 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: sword-pw.p
      Comment: ����� ᢮����� ����ਠ�쭮�� �थ� (�ᯮ������ 䨫���).
               ����頥� ��室 �㬠��. ������砥��� � CTRL-G � ���-�� ���.
   Parameters:
         Uses: nowhere
      Used by:
      Created: 28/02/2000 Vlad
     Modified: 06/03/2000 Vlad - ��ਠ�� ��� ��㧥� �஢����
     Modified: 16/05/2001 yakv - �뢮� ����� 䨫��� �� ��ன ��ப�
     Modified: 28/02/2003 kraw (13230) ��ਠ�� � �ப�� ������
-----------------------------------------------------------------------------*/
form "~n@(#) SWORD-P.P vlad yakv "
with frame sccs-id stream-io width 250.

&if defined( FILE_sword_p_p ) = 0 &then &global-define FILE_sword_p_p true
&endif
&if defined( FILE_sword_i_wide ) = 0 &then &global-define FILE_sword_i_wide true
&endif
/*---------------------------------------------------------------------------*/
{swordf2.i}
