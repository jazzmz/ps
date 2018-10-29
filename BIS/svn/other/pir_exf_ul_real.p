{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
                Формирование списка клиентов(ЮЛ) для экспорта .
                Анисимов А.А., 23.10.2007
   По Просьбе Гамана В.В. в анкету добавил поля "Сообщение по клиенту", "ОКВЭД", "ОКПО".
   rusinov 06.05.08 15:48
	По #3912 это теперь новая p-шка.
*/

/** Глобальные определения */
{globals.i}
/** Используем информацию из броузера */
{tmprecid.def}
/** Функции для работы с метасхемой */
{intrface.get xclass}
/** Функции для работы со строками */
{intrface.get strng}

{sh-defs.i}
{pir_exf_vrt.i}

/******************************************* Определение переменных и др. */
DEF VAR FirstStr AS LOGICAL          NO-UNDO.
DEF VAR cXL      AS CHAR             NO-UNDO.
DEF VAR symb     AS CHAR INITIAL "-" NO-UNDO.
DEF VAR cNShort  AS CHAR             NO-UNDO. /* Название клиента */
DEF VAR cId      AS CHAR             NO-UNDO.
DEF VAR cDate    AS CHAR             NO-UNDO.
DEF VAR cUser    AS CHAR             NO-UNDO. /* Сотрудник, делавший отчет */
DEF VAR cDolgn   AS CHAR             NO-UNDO. /* его должность             */
DEF VAR cKlb     AS CHAR             NO-UNDO. /* Клиент-банк               */
DEF VAR cAdr     AS CHAR             NO-UNDO. /* Новые адреса              */

define temp-table tacct no-undo
	field	acct like acct.acct
	field	currency like acct.currency
	field	open-date like acct.open-date
	field	close-date like acct.close-date
	field	user-id like acct.user-id
	field	rdpo as date.


{pir_xf_def.i}  /* GetLastHistoryDate */

{pir_exf_exl.i}

{exp-path.i &exp-filename = "'ul.xls'"}

/******** Сотрудник, делавший отчет *********************/
FIND FIRST _user
   WHERE (_user._userid EQ USERID)
   NO-LOCK NO-ERROR.
cUser  = _user._user-name.
cDolgn = GetXAttrValue("_user", _user._userid, "Должность").

/******************************************* Реализация */
put unformatted XLHead("ul", "CCDDCCCCCCCCDCCCCCCCCCCCCCCCCCCCDDDCDDCCCC", ",150").

cXL = XLCell("Наименование")
    + XLCell("Счет")
    + XLCell("Дата движения")
    + XLCell("РДПО")
    + XLCell("Клиент-банк")
    + XLCell("Cообщение по клиенту")
    + XLCell("Сокращенное наименование")
    + XLCell("Английское наименование")
    + XLCell("Орган.прав.форма")
    + XLCell("ОГРН")
    + XLCell("ОКВЭД")
    + XLCell("ОКПО")
    + XLCell("Дата регистрации")
    + XLCell("Место регистрации")
    + XLCell("Юридический адрес")
    + XLCell("Юридический адрес (старый)")
    + XLCell("Фактический адрес")
    + XLCell("Фактический адрес (старый)")
    + XLCell("Телефон")
    + XLCell("Факс")
    + XLCell("ИНН")
    + XLCell("ИИН")
    + XLCell("Структура (стар)")
    + XLCell("Исполнит.орган")
    + XLCell("Общее собрание")
    + XLCell("Совет директоров")
    + XLCell("Состав ИКО")
    + XLCell("Капитал")
    + XLCell("Присутствие органа управления")
    + XLCell("Легализация(риск)")
    + XLCell("pirOtherBanks")
    + XLCell("Оценка риска")
    + XLCell("Дата первого счета")
    + XLCell("Дата начала")
    + XLCell("Дата последнего изменения")
    + XLCell("Лицензия")
    + XLCell("Дата открытия счета")
    + XLCell("Дата закрытия счета")
    + XLCell("Работник, открывший счет")
    + XLCell("Должность")
    + XLCell("Работник, составивший отчет")
    + XLCell("Должность")
    .

put unformatted XLRow(0) cXL XLRowEnd().

for each tmprecid no-lock,
	first cust-corp
	where (RECID(cust-corp) = tmprecid.id)
	no-lock:
		FirstStr = YES.
		/* #3912 */
/*		Prdpo = findrdpo(acct.acct,beg-date).*/
		/* #3912 */
		empty temp-table tacct.
		for each acct where (acct.cust-cat EQ "Ю") and (acct.cust-id  EQ cust-corp.cust-id) no-lock:
			create tacct.
			assign
				tacct.acct = acct.acct
				tacct.currency = acct.currency
				tacct.open-date = acct.open-date
				tacct.close-date = acct.close-date
				tacct.user-id = acct.user-id
				tacct.rdpo = findrdpo(acct.acct,beg-date).
		end.
                for each tacct by tacct.rdpo:
			if VrTest(tacct.acct, tacct.currency, tacct.open-date, tacct.close-date) then do:
				put screen col  1 row 24 "Обрабатывается " + TRIM(tacct.acct) + STRING(" ","X(45)").
				put screen col 77 row 24 "(" + symb + ")" .
				CASE symb :
					WHEN "\\"  THEN symb = "|".
					WHEN "|"   THEN symb = "/".
					WHEN "/"   THEN symb = "-".
					WHEN "-"   THEN symb = "\\".
				END CASE.

			cNShort = cust-corp.name-short.
			cId     = STRING(cust-corp.cust-id).

			/** Найдем Клиент-банк */
			FIND FIRST mail-user WHERE (LOOKUP(tacct.acct, mail-user.acct) > 0) NO-LOCK NO-ERROR.
			cKlb = (IF (AVAIL mail-user) THEN SUBSTRING(mail-user.file-exp ,28 ,5) ELSE "").



			put unformatted XLRow(0).

			IF FirstStr THEN DO:
				cDate = GetXAttrValue("cust-corp", cId, "FirstAccDate").
				cXL = XLCell(GetCodeName("КодПредп",GetCodeVal("КодПредп", cust-corp.cust-stat)) + " " + cust-corp.name-corp)
				+ XLCell(TRIM(tacct.acct))
				+ XLDateCell(lastmove)
				+ XLDateCell(tacct.rdpo)/*Новый столбец!*/
				+ XLCell(cKlb)
				+ XLCell(GetXAttrValue("cust-corp", cId, "mess"))
				+ XLCell(cNShort)
				+ XLCell(GetXAttrValue("cust-corp", cId, "engl-name"))
				+ XLCell(GetCodeName("КодПредп",GetCodeVal("КодПредп", cust-corp.cust-stat)))
				+ XLCell(GetXAttrValue("cust-corp", cId, "ОГРН"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "ОКВЭД"))
				+ XLCell(cust-corp.okpo)
				+ XLDateCell(DATE(GetXAttrValue("cust-corp", cId, "RegDate")))
				+ XLCell(GetXAttrValue("cust-corp", cId, "RegPlace"))
				.

				FIND FIRST cust-ident
					WHERE cust-ident.cust-cat       EQ "Ю"
					AND cust-ident.cust-id        EQ cust-corp.cust-id
					AND cust-ident.cust-code-type EQ "АдрЮр"
					AND cust-ident.class-code     EQ "p-cust-adr"
					AND cust-ident.close-date     EQ ?
					NO-ERROR.

				cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".
				cXL = cXL
				+ XLCell(cAdr)
				+ XLCell(DelDoubleChars((IF (cust-corp.addr-of-low[1] NE cust-corp.addr-of-low[2])
					THEN cust-corp.addr-of-low[1] + " " + addr-of-low[2]
					ELSE cust-corp.addr-of-low[1]),",")).

				FIND FIRST cust-ident
					WHERE cust-ident.cust-cat       EQ 'Ю'
					AND cust-ident.cust-id        EQ cust-corp.cust-id
					AND cust-ident.cust-code-type EQ 'АдрФакт'
					AND cust-ident.class-code     EQ "p-cust-adr"
					AND cust-ident.close-date     EQ ?
					NO-ERROR.

				cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".
				cXL = cXL
				+ XLCell(cAdr)
				+ XLCell(GetXAttrValue("cust-corp", cId, "АдресП"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "tel"))
				+ XLCell(cust-corp.fax)
				+ XLCell(cust-corp.inn)
				+ XLCell(GetXAttrValue("cust-corp", cId, "ИИН"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "СтруктОрг"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "ИсполнОрган"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "ОбщСобрание"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "СоставСД"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "СоставИКО"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "УставКап"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "ПрисутОргУправ"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "РискОтмыв"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "pirOtherBanks"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "ОценкаРиска"))
				+ XLDateCell(DATE(cDate))
				+ XLDateCell(IF cDate = "" THEN cust-corp.date-in ELSE DATE(cDate))
				+ XLDateCell(GetLastHistoryDate("cust-corp", cId)).

				/** найдем первую лицензию  */
				FIND FIRST cust-ident
					WHERE cust-ident.cust-cat   EQ "Ю"
					AND cust-ident.cust-id    EQ cust-corp.cust-id
					AND cust-ident.class-code EQ "cust-lic"
					NO-LOCK NO-ERROR.

				IF AVAIL cust-ident THEN
					cXL = cXL
					+ XLCell(GetCodeName("ВидЛицДеят", cust-ident.cust-code-type) + " " +
					cust-ident.cust-code + " " + STRING(cust-ident.open-date,"99.99.9999") + " " +
					cust-ident.issue + " " + STRING(cust-ident.close-date,"99.99.9999")).
				ELSE
					cXL = cXL
					+ XLEmptyCell().
				FirstStr = NO.
			END.
			ELSE
				cXL = XLCell(GetCodeName("КодПредп",GetCodeVal("КодПредп", cust-corp.cust-stat)) + " " + cust-corp.name-corp)
				+ XLCell(TRIM(tacct.acct))
				+ XLDateCell(lastmove)
				+ XLDateCell(tacct.rdpo)/*Новый столбец!*/
				+ XLCell(cKlb)
				+ XLCell(GetXAttrValue("cust-corp", cId, "mess"))
				+ XLEmptyCells(30).
			cXL = cXL
			+ XLDateCell(tacct.open-date)
			+ XLDateCell(tacct.close-date).

			FIND FIRST _user
				WHERE (_user._userid EQ tacct.user-id)
				NO-LOCK NO-ERROR.
			IF AVAIL _user THEN 
				cXL = cXL
				+ XLCell(_user._user-name)
				+ XLCell(GetXAttrValue("_user", _user._userid, "Должность"))
			.
			ELSE
				cXL = cXL
				+ XLEmptyCell()
				+ XLEmptyCell()
			.

			cXL = cXL
			+ XLCell(cUser)
			+ XLCell(cDolgn)
			.
			put unformatted cXL XLRowEnd() .
		END.
	END.
END.

put unformatted XLEnd().
put screen col 1 row 24 color normal STRING(" ","X(80)").

{intrface.del}
