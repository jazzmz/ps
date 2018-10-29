/* ------------------------------------------------------
     File: $RCSfile: pir_checkterr.p,v $ $Revision: 1.1 $ $Date: 2008-12-19 08:42:14 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: Является частью проекта обмена данными между iBank-БИСКВИТ-SWIFT
     Что делает: Проверяет похожесть некого текста на название организации или имени из справочника террористов
     Как работает: Использует стандартные библиотеки БИС
     Параметры: iString - строка, содержимое которой нужно проверить
     Результат: true/false
     Место запуска: Используется в УТ группы PIReVAL  
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
------------------------------------------------------ */

{globals.i}
{intrface.get terr}
{intrface.get xclass}
{intrface.get tmess}

DEF INPUT  PARAM iValue     AS CHAR   NO-UNDO. /* Значение объекта. */

DEF VAR hasError AS LOGICAL INIT false NO-UNDO.

DEFINE TEMP-TABLE t-obj NO-UNDO
	FIELD rec AS RECID
.

{empty t-obj}
RUN CompareFast IN h_terr (iValue, 'plat', INPUT-OUTPUT TABLE t-obj).

IF CAN-FIND(FIRST t-obj) THEN DO:
    RUN Fill-SysMes("", "", "-1", "--- В Н И М А Н И Е !!! --- [" + iValue + "] имеет отношение к террористам!").
    hasError = true.
END. ELSE DO:
	RUN Fill-SysMes("", "", "0", iValue + " проверено на террор - ок!").
	hasError = false.
END.

{intrface.del}

IF hasError THEN RETURN ERROR. ELSE RETURN.



