/** 
 *  Процедура удаления транзакций ПЦ, импортированных из заданного файла
 *  
 *  Бурягин Е.П., 2010
 */
 
DEFINE INPUT PARAM iFileName AS CHAR.
DEFINE INPUT PARAM iOpDate AS DATE.

DEF VAR isok AS LOGICAL INIT false NO-UNDO.
DEF VAR delcount AS INT NO-UNDO. 
DEF BUFFER bfrSigns FOR signs.


MAIN-BLOCK:
DO ON ERROR UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

	delcount = 0.

	FOR EACH signs WHERE file-name = "pc-trans" AND code = "pir_fromfile"
			AND xattr-value = iFileName,
		FIRST pc-trans WHERE pc-trans.pctr-id = INT(signs.surrogate)
			AND YEAR(pc-trans.proc-date) = YEAR(iOpDate)
		:

			/** если хотя бы одна ТПЦ имеет статус "Обработана" */
			IF pc-trans.pctr-status = "ОБР" THEN DO:
				MESSAGE "Удаление транзакций ПЦ, импортированных из файла" + CHR(10) + "'" + iFileName + "'," + CHR(10) + "завершилось с ошибкой. Найдены транзакции ПЦ со статусом ОБР." VIEW-AS ALERT-BOX. 
				UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK.
			END.	

			/** если хотя бы одна ТПЦ имеет связанный с ней документ */
			FIND FIRST bfrSigns WHERE bfrSigns.file-name = "op" and bfrSigns.code = "ТранзПЦ" and bfrSigns.code-value = STRING(pc-trans.pctr-id) NO-LOCK NO-ERROR.
			IF AVAIL bfrSigns THEN DO:
				MESSAGE "Удаление транзакций ПЦ, импортированных из файла" + CHR(10) + "'" + iFileName + "'," + CHR(10) + "завершилось с ошибкой. Найдены документы, созданные на основании транзакций ПЦ." VIEW-AS ALERT-BOX. 
				UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK.
			END.	

			FOR EACH pc-trans-amt OF pc-trans :
				DELETE pc-trans-amt.	
			END.
			
			DELETE pc-trans.
			
			delcount = delcount + 1.

	END.
	
	isok = true.
	
END.

IF isok AND delcount = 0 THEN DO:
	MESSAGE "Не найдено ни одной транзакции ПЦ, импортированной из файла" + CHR(10) + "'" + iFileName + "'." VIEW-AS ALERT-BOX. 
END.

IF isok AND delcount > 0 THEN DO:
	MESSAGE "Удалено " + STRING(delcount) + " транзакции(й) ПЦ, импортированных из файла" + CHR(10) + "'" + iFileName + "'." VIEW-AS ALERT-BOX. 
END.

IF NOT isok THEN RETURN ERROR.