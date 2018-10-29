/*********************************
 * Инлкюдник с получение         *
 * счетчика электронного архива. *
 *********************************/
DEF VAR iCurrOut  AS INTEGER NO-UNDO.
iCurrOut = GetCounterCurrentValue("PirA2346U",TODAY). 	/* Получили текущий номер счетчика */

IF iCurrOut EQ ? THEN DO:
	MESSAGE "Не запущен сервер автонумерации!\nВыгрузка в архив невозможна" VIEW-AS ALERT-BOX.
RETURN "ERROR".
END.
SetCounterValue("PirA2346U",?,TODAY).			/* Тут же его инкрементировали */