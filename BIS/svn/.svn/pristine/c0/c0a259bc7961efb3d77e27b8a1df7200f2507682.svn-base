/* ООО "ПИР Банк" Управление автоматизации 2013г.								*/
/* #3474													*/
/* Изначально написана П.Нечаевым.										*/
/* Допилена А.Гончаровым для обработки ручных документов							*/
/* Что делает: Экспортирует данные из БИС в текстовый файл, понятный для SWIFT					*/
/* Как работает: по выбранным в броузере документов записям, процедура  заполняет файл в необходимом формате.	*/
/* Место запуска: броузер документов.										*/

/** Глобальные системные определения */
{globals.i}
{ulib.i} 

/** используем информацию из броузера */
{tmprecid.def}
{wordwrap.def}
{gstrings.i}


/*DEF INPUT PARAM iParam AS CHAR.*/
define variable saveDir AS CHAR NO-UNDO.
define variable fileName AS CHAR NO-UNDO.
define variable rSurrogate as char no-undo.
define variable rClass as char no-undo.
define variable rProc as char init "pir-swiftfill" no-undo. 

DEF TEMP-TABLE ttReport NO-UNDO
	FIELD id AS INT
	FIELD ourClientID AS CHAR /** для группировки */
	FIELD doc-num AS INT INIT 0	/**	Номер документа	*/
	FIELD bank AS CHAR INIT ""	/**	Receiver банк	*/
	/** теги 
		формат: <litera>=<value>~<litera>=<value>~...~<litera>=<value> 
	*/
	/** теги SWIFT */
	FIELD tag13 AS CHAR INIT "" /**	Указание времени	*/
	FIELD tag20 AS CHAR INIT "" /**	Референс отправителя */
	FIELD tag23 AS CHAR INIT "" /**	В=Код банковской операции Е=Код инструкций */
	FIELD tag26 AS CHAR INIT "" /**	Код типа операции */
	FIELD tag32 AS CHAR INIT "" /**	Дата валютирования / Валюта / Сумма МБ */
	FIELD tag33 AS CHAR INIT "" /**	Валюта / Сумма платежного поручения */
	FIELD tag36 AS CHAR INIT "" /**	Курс конвертации */
	FIELD tag50Cor AS CHAR INIT "" /**	Клиент - заказчик */
	FIELD tag51 AS CHAR INIT "" /**	Организаци отправитель */
	FIELD tag52 AS CHAR INIT "" /**	Финансовая организация - заказчик */
	FIELD tag53 AS CHAR INIT "" /**	Корсчет отправителя */
	FIELD tag54 AS CHAR INIT "" /**	Корсчет получателя */
	FIELD tag55 AS CHAR INIT "" /**	Третий банк возмещения */
	FIELD tag56 AS CHAR INIT "" /**	Посредник */
	FIELD tag57 AS CHAR INIT "" /**	Банк бенефициара */
	FIELD tag59Cor AS CHAR INIT "" /**	Клиент - бенефициар */
	FIELD tag59 AS CHAR INIT "" /**	Клиент - бенефициар */
	FIELD tag70 AS CHAR INIT "" /**	Информация о платеже */
	FIELD tag70Cor AS CHAR INIT "" /**	Информация о платеже */
	FIELD tag71 AS CHAR INIT "" /**	Детализация расходов */
	FIELD tag72 AS CHAR INIT "" /**	Информация, отправленная получателю */
	FIELD tag77 AS CHAR INIT "" /**	Содержание конверта */
.

define variable i AS INTEGER NO-UNDO INIT 0.
define variable j AS INTEGER NO-UNDO INIT 0.
define variable tmpStr AS CHAR NO-UNDO.
define variable tmpStr2 AS CHAR NO-UNDO.
define variable Ref AS CHAR NO-UNDO.
define variable SKIP1 AS CHAR NO-UNDO INIT "".
DEF FRAME fSet 
	 "странно, похоже адрес слишком ДЛИННЫЙ" SKIP tmpStr SKIP1 
	 WITH CENTERED NO-LABELS TITLE "Введите данные".

/** обработка выбранных документов */
FOR EACH tmprecid NO-LOCK,
	FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK,
	FIRST op-entry WHERE op-entry.op = op.op NO-LOCK:

	i = i + 1.
	/** Создаем объекты отчета и собираем данные */
	CREATE ttReport.
		ttReport.id = i.

	 /**********************************************************
		 *
		 * БАНКИ У КОТОРЫХ НАШИ СЧЕТА.
		 * С ЭТИХ СЧЕТОВ БУДЕТ ПРОХОДИТЬ СПИСАНИЕ
		 * ВАЛЮТЫ.
		 *
		 **********************************************************/
		ttReport.bank = STRING(op-entry.acct-cr).
		IF ttReport.bank = "30114840800000000009" or ttReport.bank = "30114978400000000009" or ttReport.bank = "30114826400000000009"
			THEN ttReport.bank = "OWHBDEFFXXX".
		IF ttReport.bank = "30110840800000000016" or ttReport.bank = "30110978000000000021" 
			THEN ttReport.bank = "SABRRUMMXXX".
		IF ttReport.bank = "30110840000000000023" or ttReport.bank = "30110978600000000023" 
			THEN ttReport.bank = "IMBKRUMMXXX".
		IF ttReport.bank = "30114840800000000012" or ttReport.bank = "30114978400000000012" 
			THEN ttReport.bank = "RZBAATWWXXX".
	
		ttReport.doc-num = INT(op.doc-num).

		tmpStr = STRING(op.details).
		j = INDEX(tmpStr,"REF"). 
		IF j > 0 THEN tmpStr = SUBSTRING(tmpStr, j + 3, LENGTH(tmpStr) - j - 2).
		j = INDEX(tmpStr," "). 
		IF j > 0 THEN tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
		j = INDEX(tmpStr," "). 
		IF j > 0 THEN tmpStr = SUBSTRING(tmpStr, 1, j - 1).
		ttReport.tag20 = tmpStr.
	
/*Ниже: если нет допреков, указывающих на то, что документ пришёл из КБ, меняем класс и суррогат допреков
и запускаем i-шку заполнения допреков в авто-мануальном режиме */

	if GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0","pirSwift32", "?") = "?" then do:
		message "Ручной документ\nПереходим к заполнению недостающих реквизитов." view-as alert-box.
		rClass = "op".
		rSurrogate = string(op.op).
		{pir-swiftfill.i}
	end.
	else do: 
		rClass = "msg-impexp".
		rSurrogate = "op," + string(op.op) + ",i-clb103,0".
	end.

	ttReport.tag32 = GetXAttrValueEx(rClass, rSurrogate,"pirSwift32", "?").
	ttReport.tag33 = GetXAttrValueEx(rClass, rSurrogate, "pirSwift33", "?").
	ttReport.tag50Cor = GetXAttrValueEx(rClass, rSurrogate, "pirSwift50Cor", "?").
	IF ttReport.tag50Cor = "" OR ttReport.tag50Cor = "?" then do:
		message "Необходимо проверить данный по полю 50 (Перевододатель)" view-as alert-box.
		return.
	end.

	ttReport.tag52 = GetXAttrValueEx(rClass, rSurrogate, "pirSwift52", "?").
	ttReport.tag56 = GetXAttrValueEx(rClass, rSurrogate, "pirSwift56", "?").
	ttReport.tag57 = GetXAttrValueEx(rClass, rSurrogate, "pirSwift57", "?").
	ttReport.tag59Cor = TranslitIt(CAPS(GetXAttrValueEx(rClass, rSurrogate,"pirSwift59Cor", "?"))).
	IF ttReport.tag59Cor = "" OR ttReport.tag59Cor = "?" THEN DO:
		message "Необходимо проверить данный по полю 59 (Бенефициар)" view-as alert-box.
		return.
	end.

	ttReport.tag70Cor = GetXAttrValueEx(rClass, rSurrogate,"pirSwift70Cor", "?").
	IF ttReport.tag70Cor = "" OR ttReport.tag70Cor = "?" THEN DO:
			message "Необходимо проверить данный по полю 70 (Назначение платежа)" view-as alert-box.
			return.
	end.

	ttReport.tag71 = GetXAttrValueEx(rClass, rSurrogate,"pirSwift71", "?").


/** сбор данных закончен */
end.

/** Формирование файлов */
pause 0.

/* saveDir = "/home/PIRBANK/agoncharov/3785".*/
saveDir = "./users/" + LC(USERID).

SKIP1 = "".
SKIP1 = CHR(13) + CHR(10).

/** выводим данные */
FOR EACH ttReport BREAK BY ttReport.ourClientID:
	fileName = "sw" + SUBSTRING(ttReport.tag32, INDEX(ttReport.tag32,"=") + 1, 6).
	fileName = fileName + "-" + STRING(ttReport.doc-num) + ".103".
	fileName = saveDir + "/" + fileName.

	OUTPUT TO VALUE(fileName).
		
	/** Выгружаем заголовок */
	PUT UNFORMATTED "~{1:F01BPIRRUMMAXXX0000000000~}~{2:I103" ttReport.bank.
	PUT UNFORMATTED "XN~}~{4:" SKIP1.

	/** Выгружаем TAG20 */
	tmpStr = CAPS(ttReport.tag20).
	Ref = "".
	Ref = SUBSTRING(tmpStr, 1, 2).
	Ref = SUBSTRING(tmpStr, 3, 2) + Ref.
	Ref = SUBSTRING(tmpStr, 5, 2) + Ref.
	IF tmpStr <> "?" THEN PUT UNFORMATTED ":20:" tmpStr SKIP1.
	/** IF tmpStr <> "?" THEN PUT UNFORMATTED ":20:" Ref SKIP1. */

	/** Выгружаем TAG23 CRED (стандартно) */
	tmpStr = CAPS(ttReport.tag23).
	IF tmpStr <> "?" THEN PUT UNFORMATTED ":23B:CRED" SKIP1.

	/** Выгружаем TAG32 */
	tmpStr = CAPS(ttReport.tag32).
	j = INDEX(tmpStr,"=").
	tmpStr = substring(tmpstr, j + 1, 6) + SUBSTRING(tmpStr, j + 7, LENGTH(tmpStr) - j - 6).


	SUBSTRING(tmpStr, INDEX(tmpStr,"."), 1, "CHARACTER") = ",".
	IF tmpStr <> "?" THEN PUT UNFORMATTED ":32A:" tmpStr SKIP1.

	/** Выгружаем TAG33, если 71А BEN */
	tmpStr = CAPS(ttReport.tag33).
	j = INDEX(tmpStr,"=").
	tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
	tmpStr2 = CAPS(ttReport.tag71).
	tmpStr2 = SUBSTRING(tmpStr2, INDEX(tmpStr2,"=") + 1, 3).
	IF tmpStr <> "?" AND tmpStr2 = "BEN" THEN PUT UNFORMATTED ":33B:" tmpStr SKIP1.

	/** Выгружаем TAG50 */
	tmpStr = CAPS(ttReport.tag50Cor).
	REPEAT WHILE INDEX(tmpStr, "?") > 0:
			SUBSTRING(tmpStr, INDEX(tmpStr,"?"), 1, "CHARACTER") = "".
	END.
	REPEAT WHILE INDEX(tmpStr, CHR(10)) <> 0:
			j = INDEX(tmpStr, CHR(10)).
			PUT UNFORMATTED SUBSTRING(tmpStr, 1, j - 1) SKIP1.
			tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
	END.
	IF LENGTH(tmpStr) > 0 THEN PUT UNFORMATTED tmpStr SKIP1.

	/** Выгружаем TAG56 */
	tmpStr = CAPS(ttReport.tag56).
	IF tmpStr <> "?" AND tmpStr <> "" THEN DO:
			j = INDEX(tmpStr,"=").
			IF tmpStr <> "?" THEN PUT UNFORMATTED ":56A:" SUBSTRING(tmpStr, j + 1, INDEX(tmpStr,"~~") - j - 1) SKIP1.
			/** Выгружаем TAG57 */
			tmpStr = CAPS(ttReport.tag57).
			j = INDEX(tmpStr,"=").
			tmpStr2 = SUBSTRING(tmpStr, j + 1, INDEX(tmpStr,"~~") - j - 1).
			j = INDEX(tmpStr,"~~").
			tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
			j = INDEX(tmpStr,"~~").
			IF j > 0 THEN tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
			j = INDEX(tmpStr,"~~").
			IF j > 0 THEN tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
			j = INDEX(tmpStr,"~~").
			IF j > 0 THEN tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
			/* IF tmpStr <> "?" THEN PUT UNFORMATTED ":57A:/" SUBSTRING(tmpStr, 1, INDEX(tmpStr,"~~") - 1) SKIP1. */
			IF tmpStr <> "?" THEN DO:
					IF tmpStr <> "-" THEN DO:
							PUT UNFORMATTED ":57A:/" tmpStr SKIP1.
							IF tmpStr2 <> "?" THEN PUT UNFORMATTED tmpStr2 SKIP1.
					END.
					ELSE IF tmpStr2 <> "?" THEN PUT UNFORMATTED ":57A:" tmpStr2 SKIP1.
			END.
	END.
	ELSE DO:
			/** Выгружаем TAG57 */
			tmpStr = CAPS(ttReport.tag57).
			j = INDEX(tmpStr,"=").
			IF tmpStr <> "?" THEN PUT UNFORMATTED ":57A:" SUBSTRING(tmpStr, j + 1, INDEX(tmpStr,"~~") - j - 1) SKIP1.
	END.


	/** Выгружаем TAG59 */
	tmpStr = CAPS(ttReport.tag59Cor).
	REPEAT WHILE INDEX(tmpStr, "?") > 0:
			SUBSTRING(tmpStr, INDEX(tmpStr,"?"), 1, "CHARACTER") = "".
	END.
	REPEAT WHILE INDEX(tmpStr, CHR(10)) <> 0:
			j = INDEX(tmpStr, CHR(10)).
			PUT UNFORMATTED SUBSTRING(tmpStr, 1, j - 1) SKIP1.
			tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
	END.
	IF LENGTH(tmpStr) > 0 THEN PUT UNFORMATTED tmpStr SKIP1.

	/** Выгружаем TAG70 */
	tmpStr = CAPS(ttReport.tag70Cor).
	REPEAT WHILE INDEX(tmpStr, "?") > 0:
			SUBSTRING(tmpStr, INDEX(tmpStr,"?"), 1, "CHARACTER") = "".
	END.
	REPEAT WHILE INDEX(tmpStr, CHR(10)) <> 0:
			j = INDEX(tmpStr, CHR(10)).
			PUT UNFORMATTED SUBSTRING(tmpStr, 1, j - 1) SKIP1.
			tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
	END.
	IF LENGTH(tmpStr) > 0 THEN PUT UNFORMATTED tmpStr SKIP1.
	
	/** Выгружаем TAG71A */
	tmpStr = CAPS(ttReport.tag71).
	j = INDEX(tmpStr,"=").
	tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
	IF tmpStr <> "?" THEN PUT UNFORMATTED ":71A:" SUBSTRING(tmpStr, 1, INDEX(tmpStr,"~~") - 1) SKIP1.

	/** Выгружаем TAG71F */
	j = INDEX(tmpStr,"=").
	tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
	tmpStr2 = CAPS(ttReport.tag71).
	tmpStr2 = SUBSTRING(tmpStr2, INDEX(tmpStr2,"=") + 1, 3).
	IF tmpStr <> "?" AND tmpStr2 = "BEN" THEN PUT UNFORMATTED ":71F:" tmpStr SKIP1.
	PUT UNFORMATTED "-~}" SKIP1.

	OUTPUT CLOSE.

	MESSAGE "Данные экспортированы в файл " + fileName VIEW-AS ALERT-BOX.

END.
				