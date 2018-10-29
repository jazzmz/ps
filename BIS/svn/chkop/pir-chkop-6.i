/* ------------------------------------------------------
     File: $RCSfile: pir-chkop-6.i,v $ $Revision: 1.8 $ $Date: 2010-08-17 12:06:01 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: 
     Что делает: ПОДФТ Контроль при модификации документа
     Как работает: см. документацию - Алгоритм 1
     Параметры:
     Место запуска: переменные определяются в pir-chkop-6.def 
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.7  2010/04/07 09:06:27  Buryagin
     Изменения: Fix for 'poluprovodok'
     Изменения:
     Изменения: Revision 1.6  2009/12/30 13:49:28  Buryagin
     Изменения: Reading the field datablock.comment added to the first "IF" expression.
     Изменения:
     Изменения: Revision 1.5  2009/12/17 13:45:12  Buryagin
     Изменения: Check #6 (PODFT) Upgrade for v2.0
     Изменения:
     Изменения: Revision 1.4  2009/11/18 06:33:56  Buryagin
     Изменения: Added the the accounts changing check.
     Изменения:
     Изменения: Revision 1.1  2009/07/24 10:29:40  Buryagin
     Изменения: New version of the PODFT's control.
     Изменения:
------------------------------------------------------ */

/** 
 * Если отдел ПОДФТ уже начал формирование блока данных
 * и 
 * Если на документе нет доп.реквизита, разрешающего редактирование
 * то 
 * проверим на исключения
 *
 **/

podft_class = FGetSetting("PirPODFTClass", "", "").
podft_sum1 = DEC(FGetSetting("PirPODFTSum1", "", "600000")).
podft_sum1_check = FGetSetting("PirPODFTCkS1", "", "").

IF (GetXattrValueEx("op", string(op.op), "PIRcheckPODFT","") <> "Да")
   AND
   (CAN-FIND(FIRST datablock WHERE 
   			 datablock.dataclass-id = podft_class
   			 AND
   			 datablock.beg-date = datablock.end-date
   			 AND
   			 datablock.beg-date = op-entry.op-date
   			 AND
   			 TRIM(datablock.comment) = ""
   			 NO-LOCK)
   )
THEN DO:

	/**
	 * Если корреспонденция документа попадет под исключение
	 * то редактировать его можно,
	 * иначе редактировать нельзя ни при каких условиях.
	 * Причем, если в процессе корректировки корреспонденция изменяется, то
	 * программа должна проверить как старую корреспонденцию, так и новую.
	 * Если хотя бы одна из них отсутствует в исключениях, то данное изменение недопустимо. 
	 **/

	podft_new_acct_db = op-entry.acct-db.
	podft_new_acct_cr = op-entry.acct-cr.
	
	/** полупроводки */
	if podft_new_acct_db = ? then do:
		find first podft-op-entry where 
			podft-op-entry.op = op-entry.op and podft-op-entry.acct-db <> ? no-lock no-error.
		if avail podft-op-entry then podft_new_acct_db = podft-op-entry.acct-db.
	end.
	if podft_new_acct_cr = ? then do:
		find first podft-op-entry where 
			podft-op-entry.op = op-entry.op and podft-op-entry.acct-cr <> ? no-lock no-error.
		if avail podft-op-entry then podft_new_acct_cr = podft-op-entry.acct-cr.
	end.
	
	podft_old_acct_db = podft_new_acct_db.
	podft_old_acct_cr = podft_new_acct_cr.
	
	IF 'op-entry' EQ iParam THEN 
	DO:
		FIND LAST history WHERE history.file-name  EQ 'op-entry' AND 
								history.field-ref  EQ STRING(op.op) + ',' + STRING(op-entry.op-entry) AND 
				 				history.modif-date EQ TODAY AND
				 				history.modif-time GE (TIME - 10)
				 				NO-LOCK NO-ERROR.
		IF AVAIL history AND LOOKUP ('acct-db',history.field-value) > 0 and podft_old_acct_db <> ? THEN DO:
			podft_old_acct_db = ENTRY(LOOKUP ('acct-db',history.field-value) + 1, history.field-value).
		END.
		IF AVAIL history AND LOOKUP ('acct-cr',history.field-value) > 0 and podft_old_acct_cr <> ? THEN DO:
			podft_old_acct_cr = ENTRY(LOOKUP ('acct-cr',history.field-value) + 1, history.field-value).
		END.
		
		
	END.
	
	IF (
	   		(? = FirstIndicateCandoIn_ULL("PirPODFTEntr", 
	                            podft_new_acct_db + "," + podft_new_acct_cr + "," + op.op-kind,
	                            op-entry.op-date,
	                            "Да", ""))
	   		OR
	   		(? = FirstIndicateCandoIn_ULL("PirPODFTEntr", 
	                            podft_old_acct_db + "," + podft_old_acct_cr + "," + op.op-kind,
	                            op-entry.op-date,
	                            "Да", ""))
	   )
	   AND                        
   	   (op-entry.op-status >= '√')
	THEN DO:
	   &IF DEFINED(CLOSEDAY) &THEN 
	   podft_need = true.
	   &ELSE
	   MESSAGE COLOR WHITE/RED
	   				" Операционный день " op-entry.op-date " уже взят под контроль отделом ПОДФТ." skip  
		    		" Документ возможно попадает под Противодействие легализации !!!" skip
		    		" Дальнейшая работа с ним невозможна !!!" skip
		    		" Обратитесь к сотруднику ПОДФТ !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "Ошибка документа".
		RETURN.
		&ENDIF
	END.
	
	/**
	 * Если сумма документа больше или равна 600 000 рублей (эквивалент)
	 * то выдаем сообщение и запрещаем редактировать
	 */
	IF (op-entry.amt-rub >= podft_sum1) 
	   AND
	   (  
	      CAN-DO(podft_sum1_check, podft_new_acct_db) 
	      OR
	      CAN-DO(podft_sum1_check, podft_new_acct_cr)
	   )
	   AND 
	   (op-entry.op-status >= '√') THEN DO:
	   &IF DEFINED(CLOSEDAY) &THEN 
	   podft_need = true.
	   &ELSE
	   MESSAGE COLOR WHITE/RED
	   				" Сумма документа больше или равна" TRIM(STRING(podft_sum1, ">>>,>>>,>>9.99")) "рублей." skip  
		    		" Документ возможно попадает под Противодействие легализации !!!" skip
		    		" Дальнейшая работа с ним невозможна !!!" skip
		    		" Обратитесь к сотруднику ПОДФТ !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "Ошибка документа".
		RETURN.
		&ENDIF
	END.
	
	IF (GetXattrValueEx("op", string(op.op), "ПодозДокумент","") <> "")
	   OR
	   (GetXattrValueEx("op", string(op.op), "КодОпОтмыв","") <> "")
	THEN DO:
	   &IF DEFINED(CLOSEDAY) &THEN 
	   podft_need = true.
	   &ELSE
	   MESSAGE COLOR WHITE/RED 
		    		" Документ промаркирован отделом ПОДФТ как подозрительный!!!" skip
		    		" Дальнейшая работа с ним невозможна !!!" skip
		    		" Обратитесь к сотруднику ПОДФТ !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "Ошибка документа".
		RETURN.
		&ENDIF
	END.
	  
END.

