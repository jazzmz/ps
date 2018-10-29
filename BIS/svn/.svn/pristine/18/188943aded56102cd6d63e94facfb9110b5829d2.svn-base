{pirsavelog.p}

/**

	Процедура группового изменения номеров счетов-фактур.
	Бурягин Е.П., 07.02.2007 12:19
	
	Запускается из картотеки счетов-фактур
	
*/

{globals.i}

{tmprecid.def} /** Объявление использования глобальной временной таблицы выделенных в броузере записей */

DEF INPUT PARAM iParam AS CHAR.
DEF VAR start-doc-num AS INT LABEL "Первый номер".
DEF VAR tmpStr AS CHAR.
DEF VAR i AS INTEGER.
DEF VAR inFormat AS CHAR.
DEF BUFFER inLoan FOR loan. /** Принятые счета-фактуры */
DEF BUFFER existsLoan FOR loan.

pause 0.

inFormat = ENTRY(1, iParam).

/** Выводим форму */
DISPLAY start-doc-num SKIP
		WITH FRAME doc-num-frame SIDE-LABELS CENTERED OVERLAY.
		
/** Редактирование значений в форме */
SET start-doc-num WITH FRAME doc-num-frame.

i = start-doc-num.


/*
FOR EACH tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) = tmprecid.id
*/
FOR EACH loan WHERE loan.contract = "sf-out" AND CAN-FIND(tmprecid WHERE tmprecid.id = RECID(loan))
		BY loan.conf-date BY loan.doc-num
	:
		
		/** Проверяем, не имеет ли какая-либо СФ номер, который пытаемся присвоить */
		DO WHILE CAN-FIND (FIRST existsLoan WHERE 
				YEAR(existsLoan.conf-date) = YEAR(loan.conf-date) 
				AND
				existsLoan.contract = "sf-out"
				AND 
				existsLoan.doc-num = STRING(i, inFormat))
		:
			/** Берем следующий по порядку */
			i = i + 1.
		END.

		IF GetXAttrValueEx("loan", loan.contract + "," + loan.cont-code, "PIRNoRenum", "Нет") = "Нет" THEN
			DO:
			 	/** Найдем счета-факутры (принятые), которые созданы в момент списания комиссии по договорам.
			 	    Согласно 914-П их номера и даты должны соответствовать СФ выданным в момент оплаты */
			 	FOR EACH inLoan WHERE 
			 			inLoan.contract = "sf-in" 
			 			AND 
			 			inLoan.conf-date = loan.conf-date
			 			AND
			 			inLoan.doc-num = loan.doc-num
			 		:
			 			inLoan.doc-num = STRING(i, inFormat).
			 	END.
			 	loan.doc-num = STRING(i, inFormat).
				i = i + 1.
			END.
		
END.

HIDE FRAME doc-num-frame.
