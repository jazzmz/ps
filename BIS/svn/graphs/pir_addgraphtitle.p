/*
��ନ��� ����� �������⥫��� ������ ��� ���ࠨ����� �
��䨪 ������ �� ������� ⠬, ��� �� �㦭�.
��-�� � pir_outputtoplot.p
�������� �.�. 24.09.2013
*/

{globals.i}
{wordwrap.def}

DEFINE INPUT PARAMETER iEndDate AS DATE NO-UNDO.
DEFINE INPUT PARAMETER iType AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER gTitle AS CHAR NO-UNDO.
DEF VAR tmp AS DECIMAL NO-UNDO.

DEF BUFFER currDataBLock for DataBlock.
DEF BUFFER forDataBLock for DataBlock.
DEF BUFFER currDataLine for DataLine.

FUNCTION getBISdata RETURNS DECIMAL (INPUT tvName AS CHAR).
FIND FIRST forDataBLock WHERE forDataBLock.DataClass-Id EQ 'PIR_params' 
                             and forDataBLock.end-date = iEndDate
                             and forDataBLock.beg-date = iEndDate
                             NO-LOCK NO-ERROR.
	FIND FIRST currDataLine WHERE currDataLine.Sym1 = tvName AND currDataLine.data-id = forDataBlock.data-id NO-LOCK NO-ERROR.
	tmp = DECIMAL(currDataLine.Val[1]).
RETURN(tmp).
END FUNCTION.

CASE iType:
	WHEN "1" THEN gTitle = " �����.१.: " + STRING(ROUND(getBISdata("�_������") / getBISdata("�_��������_����") * 100,2)) + "%; ��.�⠢�� (810): " 
 + STRING(getBISdata("�_��_������_��810")) + "%; ��.�⠢�� (840): " + STRING(getBISdata("�_��_������_��840")) + "%; ��.�⠢�� (978): " 
 + STRING(getBISdata("�_��_������_��978")) + "%.".
	WHEN "2" THEN gTitle = " ��.�⠢�� (810): " + STRING(getBISdata("�_��_������_���810")) + "%; ��.�⠢�� (840): " + STRING(getBISdata("�_��_������_���840"))
 + "%; ��.�⠢�� (978): " + STRING(getBISdata("�_��_������_���978")) + "%.".
END.
RETURN(gTitle).

