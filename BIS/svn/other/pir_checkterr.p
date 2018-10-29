/* ------------------------------------------------------
     File: $RCSfile: pir_checkterr.p,v $ $Revision: 1.1 $ $Date: 2008-12-19 08:42:14 $
     Copyright: ��� �� "�p������������"
     ���������: 
     ��稭�: ������� ����� �஥�� ������ ����묨 ����� iBank-�������-SWIFT
     �� ������: �஢���� ��宦���� ������ ⥪�� �� �������� �࣠����樨 ��� ����� �� �ࠢ�筨�� �����⮢
     ��� ࠡ�⠥�: �ᯮ���� �⠭����� ������⥪� ���
     ��ࠬ����: iString - ��ப�, ᮤ�ন��� ���ன �㦭� �஢����
     �������: true/false
     ���� ����᪠: �ᯮ������ � �� ��㯯� PIReVAL  
     ����: $Author: Buryagin $ 
     ���������: $Log: not supported by cvs2svn $
------------------------------------------------------ */

{globals.i}
{intrface.get terr}
{intrface.get xclass}
{intrface.get tmess}

DEF INPUT  PARAM iValue     AS CHAR   NO-UNDO. /* ���祭�� ��ꥪ�. */

DEF VAR hasError AS LOGICAL INIT false NO-UNDO.

DEFINE TEMP-TABLE t-obj NO-UNDO
	FIELD rec AS RECID
.

{empty t-obj}
RUN CompareFast IN h_terr (iValue, 'plat', INPUT-OUTPUT TABLE t-obj).

IF CAN-FIND(FIRST t-obj) THEN DO:
    RUN Fill-SysMes("", "", "-1", "--- � � � � � � � � !!! --- [" + iValue + "] ����� �⭮襭�� � �����⠬!").
    hasError = true.
END. ELSE DO:
	RUN Fill-SysMes("", "", "0", iValue + " �஢�७� �� ���� - ��!").
	hasError = false.
END.

{intrface.del}

IF hasError THEN RETURN ERROR. ELSE RETURN.



