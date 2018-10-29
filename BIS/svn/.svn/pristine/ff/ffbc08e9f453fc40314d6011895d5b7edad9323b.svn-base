/*
Формирует строчку дополнительных данных для встраивания в
график данных из Анализа там, где это нужно.
исп-ся в pir_outputtoplot.p
Бакланов А.В. 24.09.2013
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
	WHEN "1" THEN gTitle = " Коэфф.рез.: " + STRING(ROUND(getBISdata("А_РЕЗЕРВ") / getBISdata("А_ПОРТФЕЛЬ_БАНК") * 100,2)) + "%; Ср.ставка (810): " 
 + STRING(getBISdata("А_СР_СТАВКА_КР810")) + "%; Ср.ставка (840): " + STRING(getBISdata("А_СР_СТАВКА_КР840")) + "%; Ср.ставка (978): " 
 + STRING(getBISdata("А_СР_СТАВКА_КР978")) + "%.".
	WHEN "2" THEN gTitle = " Ср.ставка (810): " + STRING(getBISdata("А_СР_СТАВКА_ДЕП810")) + "%; Ср.ставка (840): " + STRING(getBISdata("А_СР_СТАВКА_ДЕП840"))
 + "%; Ср.ставка (978): " + STRING(getBISdata("А_СР_СТАВКА_ДЕП978")) + "%.".
END.
RETURN(gTitle).

