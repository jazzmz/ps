/************************************
 * Удаляет из электронного архива   *
 * документы попутно снимает        *
 * доп. рек.                        *
 ************************************
 *
 * Автор         : Маслов Д. А.
 * Заявка        :
 * Дата создания : 19.10.11
 *
 ************************************/

{bislogin.i}
{globals.i}
{intrface.get xclass}

DEF INPUT PARAMETER opd  AS DATE      				       NO-UNDO.

DEF VAR cExpNum          AS CHARACTER INITIAL ? LABEL "Номер экспорта" NO-UNDO.

DISPLAY cExpNum WITH FRAME fSetExpNum OVERLAY CENTERED SIDE-LABELS.
SET cExpNum WITH FRAME fSetExpNum.
HIDE FRAME fSetExpNum.


run soap-del.p(opd,cExpNum).

IF NOT ERROR-STATUS:ERROR THEN DO:
   MESSAGE "Начинаю удалять допники" VIEW-AS ALERT-BOX.

	FOR EACH signs WHERE signs.file-name EQ "op" 
			     AND signs.code EQ "PirA2346U" 
			     AND signs.code-value EQ cExpNum NO-LOCK:

/*			     UpdateSigns("op",signs.surrogate,"PirA2346U",?,TRUE).*/

			      FOR EACH op-entry WHERE op-entry.op EQ INT64(signs.surrogate) NO-LOCK:				 
				 UpdateSigns("op-entry",STRING(signs.surrogate) + "," + STRING(op-entry.op-entry),"PirDEVLink",?,TRUE).
			      END.			

	END.

END.
ELSE DO:
   MESSAGE "Ошибка выгрузки" ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX.
END.