/* ------------------------------------------------------
     File: $RCSfile: pirgetfname.p,v $ $Revision: 1.1 $ $Date: 2008-05-29 08:45:25 $
     Copyright: ��� �� "�p������������"
     ���������: 
     ��稭�: 
     �� ������: �������� � ���������� ०��� ����� 䠩�
     ��� ࠡ�⠥�: 
     ��ࠬ����: 
     ���� ����᪠: �㭪�� PROMPT � 㭨���ᠫ��� �࠭������  
     ����: $Author: Buryagin $ 
     ���������: $Log: not supported by cvs2svn $
------------------------------------------------------ */

{globals.i}

DEF INPUT PARAM iParam AS CHAR NO-UNDO. 
DEF VAR fname AS CHAR NO-UNDO.

fname = iParam.

RUN ch-file.p (INPUT-OUTPUT fname).

pick-value = fname.