/************************************
 * Удаляет из электронного архива   *
 * документы попутно снимает        *
 * доп. рек.                        *
 ************************************
 *                                  *
 * Автор         : Маслов Д. А.	    *
 * Заявка        : #790             *
 * Дата создания : 19.10.11         *
 *                                  *
 ************************************/

{bislogin.i}
{globals.i}
{intrface.get xclass}

/*DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.*/
DEFINE INPUT PARAMETER iOpRID     AS RECID NO-UNDO.

DEF VAR in-op-date       AS CHARACTER INITIAL ? LABEL "Дата ОД" FORMAT "x(10)" NO-UNDO.
DEF VAR cExpNum          AS CHARACTER INITIAL ? LABEL "Номер экспорта" NO-UNDO.


DISPLAY in-op-date WITH FRAME fSetExpDate OVERLAY CENTERED SIDE-LABELS.
SET in-op-date WITH FRAME fSetExpDate.
HIDE FRAME fSetExpDate.

DISPLAY cExpNum    WITH FRAME fSetExpNum  OVERLAY CENTERED SIDE-LABELS.
SET cExpNum WITH FRAME fSetExpNum.
HIDE FRAME fSetExpNum.


run soap-del.p (in-op-date,cExpNum).

IF NOT ERROR-STATUS:ERROR THEN DO:

	FOR EACH signs WHERE signs.file-name EQ "op" 
			     AND signs.code EQ "PirA2346U" 
			     AND INT64(signs.code-value) EQ INT64(cExpNum) NO-LOCK:


			      FOR EACH op-entry WHERE op-entry.op EQ INT64(signs.surrogate) NO-LOCK:				 
				 UpdateSigns("op-entry",STRING(signs.surrogate) + "," + STRING(op-entry.op-entry),"PirDEVLink",?,TRUE).
			      END.			

			     UpdateSigns("op",signs.surrogate,"PirA2346U",?,TRUE).


	END.

END.
ELSE DO:
   MESSAGE "Ошибка выгрузки" ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX.
END.