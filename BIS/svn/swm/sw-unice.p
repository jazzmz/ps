{pirsavelog.p}

/*-----------------------------------------------------------------------------
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2003 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: sw-unice.p
      Comment: ���� ������ �� ����᪥ �� �஢����
   Parameters:
         Uses: 
      Used by:
      Created: 27/05/2003 Peter
     Modified: 
-----------------------------------------------------------------------------*/
form "~n@(#) sw-unice.p Peter Peter" with frame sccs-id stream-io width 250.

&if defined( FILE_sword_p_p ) = 0 &then &global-define FILE_sword_p_p true
&endif

{globals.i}
{pp-uni.var}
{pp-uni.prg &NEW_1256=Yes}
{sw-uni.def &NOINPUT=YES}
{sw-uni.pro}

MESSAGE "���� ������ �� �஢�����...".
{sw-uni.i}
