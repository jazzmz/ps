DEFINE VARIABLE iVR AS INTEGER FORMAT "9" INITIAL 1 NO-UNDO. /* Вариант отчета */

/** Процедура поиска даты последнего движения по счету ********/
/** Код срисован из файлов acct-pos.i и last-pos.i pos ********/

PROCEDURE LookLastMove.
   DEFINE INPUT PARAMETER in-acct     LIKE acct.acct     NO-UNDO.
   DEFINE INPUT PARAMETER in-currency LIKE acct.currency NO-UNDO.
   DEFINE INPUT PARAMETER since       AS   DATE          NO-UNDO.

   DEFINE VARIABLE vLastPos AS DATE  NO-UNDO.

   vLastPos = since.
   REPEAT:
      FIND LAST acct-pos WHERE
         acct-pos.acct EQ in-acct AND
         acct-pos.currency EQ in-currency AND
         acct-pos.since LT vLastPos
         NO-LOCK NO-ERROR.
      /* только в случае отсутствия транзакции, иначе происходит
         переполнение таблицы блокировок */
      IF NOT TRANSACTION AND AVAIL acct-pos THEN DO:
         /* уменьшаем дату для исключения поиска заблокированной записи */
         vLastPos = acct-pos.since.
         FIND CURRENT acct-pos
            SHARE-LOCK NO-WAIT NO-ERROR.
         IF NOT AVAIL acct-pos THEN
            /* если запись успели удалить при откате дня
            или она заблокирована при закрытии дня */
            NEXT.
         ELSE
            /* освобождаем захват */
            FIND CURRENT acct-pos
               NO-LOCK NO-ERROR.
      END.
      LEAVE.
   END.
   lastmove = IF AVAILABLE acct-pos THEN acct-pos.since ELSE ?.

END PROCEDURE.

Function FindRDPO returns date (input in-acct as char,
				input in-since as date).
/* По заявке #3912 от Гамана: хочет "реальное" движение по счёту */
	define variable rValue as date init 01/01/1900 no-undo.
	define variable CodRub as char init "810" no-undo.  /*Константа для кода рубля*/
	define variable min_amt as integer init 300 no-undo. /*Константа для минимальной суммы документа*/
	define variable EntryDateCr as date init 01/01/1900 no-undo.
	define variable EntryDateDb as date init 01/01/1900 no-undo.

	if substring(in-acct, 6, 8) ne CodRub then do: /*документ не рублёвый*/
		find last op-entry where op-entry.op-date ge in-since and
					op-entry.acct-cr eq in-acct and
					op-entry.amt-cur ne 0 and  /* Исключаем валютную переоценку */
					op-entry.amt-rub gt min_amt no-lock no-error.
		if available op-entry then EntryDateCr = op-entry.op-date.
			find last op-entry where op-entry.op-date ge in-since and /*or крайне медленно работает в запросах, т.к. идёт не по индексу. Разбиваем на 2 запроса */
						op-entry.acct-db eq in-acct and 
						op-entry.amt-cur ne 0 and  /* Исключаем валютную переоценку */
						op-entry.amt-rub gt min_amt no-lock no-error.
		if available op-entry then EntryDateDb = op-entry.op-date.
		rValue = max(EntryDateDb, EntryDateCr).
	end.
	else do:
		find last op-entry where op-entry.op-date ge in-since and
					op-entry.acct-db eq in-acct and
					op-entry.amt-rub gt min_amt no-lock no-error.
		if available op-entry then EntryDateCr = op-entry.op-date.
		find last op-entry where op-entry.op-date ge in-since and /*or крайне медленно работает в запросах, т.к. идёт не по индексу. Разбиваем на 2 запроса */
					op-entry.acct-cr eq in-acct and
					op-entry.amt-rub gt min_amt no-lock no-error.
		if available op-entry then EntryDateDb = op-entry.op-date.
		rValue = max(EntryDateDb, EntryDateCr).
	end.
	if rValue eq 01/01/1900 then rValue = ?.
	return rValue.
End Function.

/** Проверка условия отбора счетов по введенному варианту iVR */

FUNCTION VrTest RETURNS LOGICAL
   (INPUT acct     AS CHAR, /* счет          */
    INPUT currency AS CHAR, /* валюта        */
    INPUT dOpen    AS DATE, /* дата открытия */
    INPUT dClose   AS DATE  /* дата закрытия */
   ):

   DEFINE VARIABLE lRt AS LOGICAL NO-UNDO.

   CASE iVR :
      WHEN 1 THEN
         lRt = ((dOpen GE beg-date ) AND (dOpen LE end-date)).
      WHEN 2 THEN
         lRt = ((dClose GE beg-date ) AND (dClose LE end-date)).
      WHEN 3 THEN
         lRt = (dClose LE end-date).
      WHEN 4 THEN
         DO:
            RUN LookLastMove(acct, currency, end-date).
            lRt = ((dOpen GE beg-date ) AND (dOpen LE end-date) AND (lastmove EQ ?)).
         END.
      WHEN 5 THEN
         lRt = ((dOpen LE end-date) AND ((dClose GT end-date) OR (dClose EQ ?))).
   END CASE.

   IF lRt THEN RUN LookLastMove(acct, currency, TODAY).
   RETURN lRt.
END FUNCTION.

/**********************************************************************/
/** На месте инклюдника запрашивается вариант отчета и даты ***********/

FORM
   "1 - Открытые в указанный период (все, вместе с закрытыми);"
   "2 - Закрытые в указанный период;"
   "3 - Открытые и закрытые до указанной даты;"
   "4 - Открытые и не начали движение по счету;"
   "5 - Действующие на указанную дату."
   iVR LABEL "ВАРИАНТ" VALIDATE ( iVR < 6, "Несуществующий вариант !!!")
   WITH FRAME fVR 
   OVERLAY
   SIDE-LABELS
   1 COL
   CENTERED
   ROW 3 
   TITLE COLOR BRIGHT-WHITE "[ Введите вариант расчета: ]"
   WIDTH 60.

DO 
   ON ENDKEY UNDO , RETURN
   ON ERROR  UNDO , RETRY
:
   UPDATE iVR WITH FRAME fVR.
END.

IF (iVR = 3) OR (iVR = 5) THEN DO:
   {getdate.i}
END.
ELSE DO:
   {getdates.i}
END.
HIDE FRAME fVR.
