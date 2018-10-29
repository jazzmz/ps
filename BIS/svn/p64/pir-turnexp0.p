/* ------------------------------------------------------
     File: $RCSfile: pir-turnexp0.p,v $ $Revision: 1.1 $ $Date: 2009-04-15 13:49:35 $
     Copyright: ��� �� "�p������������"
     ���������: 
     ��稭�: �ਪ�� 21 �� 27.03.2009
     �� ������: ��뢠�� ��楤��� ����� ॠ����� ��⮬���᪮� ��࠭���� � ��娢
     ��� ࠡ�⠥�: ������ 楯�窠 �맮�� ��� ��楤��
                   �ਬ�୮ �룫廊� ⠪:
                   
                   �����஢騪 -> pir-shdrep.p -> pir-turnexp0.p -> pir-turnexp1.p -> genpos.i
                   
                   ��-�� ��᫥����� ��ࠬ��� "1" (�. ������� � ���� ����)
                   ����� ������� �ய���� �맮� � �����䨪��� PIRREPSYSTEM,
                   �⮡� pir-shdrep.p ��� �����⨫. 
     ��ࠬ����: ᮣ��᭮ ����䥩� (�. 䠩� pir-shdrep.p)
     ���� ����᪠: �� ��楤��� pir-shdrep.p (�����஢騪 ����� �������)
     ����: $Author: Buryagin $ 
     ���������: $Log: not supported by cvs2svn $
------------------------------------------------------ */
{globals.i}

/** ����䥩� ��� ��⮬���᪮�� ��࠭���� */
DEF INPUT PARAM iBegDate    AS DATE NO-UNDO. /* ��砫쭠� ���         */
DEF INPUT PARAM iEndDate    AS DATE NO-UNDO. /* ����筠� ���          */
DEF INPUT PARAM iBranch     AS CHAR NO-UNDO. /* ��� ���ࠧ�������      */
DEF INPUT PARAM iFile       AS CHAR NO-UNDO. /* ��।������� ��� 䠩�� */
DEF INPUT PARAM iBalCat     AS CHAR NO-UNDO. /* ᯨ᮪ �����ᮢ�� ��⥣�਩ ��⮢ �������� � ����஥��� ���� */
DEF INPUT PARAM iParam      AS CHAR NO-UNDO. /* ��᪠ ��⮢ */

/** �᫨ �� ����⨫�, �� ��᫥���� ��ࠬ��� ࠢ����� 1 � ��� ���祭�� �� �� ��������, 
    �� ��������, � ��� ⮦� �� ����, �� ��� ��ࠬ��� ����室��, � ��� ���祭��,
    ��� �� �ᯥਬ��⠬, �� �� �� �� �����. � genpos.i ���� ��᪮�쪮 
    DEF INPUT PARAM, ����� ��࠭�祭� ����ᠬ� &IF*, �� ������ �४���������
    ��䨣, � �� �� �� ࠢ�� ����砥� � ��騩 ����䥩� ��楤���.
*/
RUN pir-turnexp1 (iBegDate,                    /* ��砫쭠� ���         */
                  iEndDate,                    /* ����筠� ���          */
                  iFile,       /* ��।������� ��� 䠩�� */
                  iParam,
                  "1").      /* ��ࠬ���� ��楤���    */
    