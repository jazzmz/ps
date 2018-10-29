{pirsavelog.p}

/** 
	Заполнение дополнительных реквизитов документа, для его последующей обработки
	транзакцией автоматического формирования счетов-фактур.
	Бурягин Е.П., 18.01.2007 15:19
*/

{globals.i}

{intrface.get asset}

{tmprecid.def} /** Объявление использования глобальной временной таблицы выделенных в броузере записей */



DEF VAR detailsServName AS CHAR LABEL "Наименование цен./услуги" VIEW-AS EDITOR SIZE 40 BY 5 SCROLLBAR-VERTICAL.
DEF VAR detailsServCode AS CHAR LABEL "Код цен./услуги" FORMAT "x(9)".
DEF VAR detailsServCount AS INT LABEL "Кол-во" FORMAT ">>>>>>".
DEF VAR tmpStr AS CHAR.
DEF VAR detailsIsExists AS LOGICAL.
DEF VAR infoIsExists AS LOGICAL.
DEF VAR numberIsExists AS LOGICAL.
DEF VAR amountIsExists AS LOGICAL.

DEF VAR infoSfType AS CHAR LABEL "Тип счет-фактуры" FORMAT "x(20)"
	VIEW-AS COMBO-BOX 
		LIST-ITEM-PAIRS "Выставленная","sf-out","Принятая","sf-in"
		.

DEF VAR infoPayType AS CHAR LABEL "Тип операции" FORMAT "x(40)"
	VIEW-AS COMBO-BOX
		LIST-ITEM-PAIRS "Открытие/пролонгация аренды ИБС.","а/о","Комиссия по аренде ИБС","п/о","Другая","п/о"
		.

DEF VAR infoSummaType AS CHAR LABEL "Тип суммы" FORMAT "x(20)"
	VIEW-AS COMBO-BOX 
		LIST-ITEM-PAIRS "Сумма без НДС","оплата","НДС от суммы","ндс"
		.

DEF VAR infoLoan AS CHAR LABEL "Номер договора" FORMAT "x(20)".
DEF VAR infoLoanContCode AS CHAR.

DEF VAR infoLoanType AS CHAR LABEL "Вид договора" FORMAT "x(20)"
	VIEW-AS COMBO-BOX
		LIST-ITEM-PAIRS "Старый ИБС","АХД","Новый ИБС","Депоз"
		.
DEF VAR infoNeedLoan AS CHAR LABEL "Связь с договором" 
	VIEW-AS COMBO-BOX
		LIST-ITEMS "Нет","Да"
		.

DEF VAR sfNumber AS CHAR LABEL "Номер СФ" FORMAT "x(12)".
DEF VAR sfDate AS DATE LABEL "Дата СФ" FORMAT "99/99/9999".

DEF VAR sfAmount AS DECIMAL LABEL "Сумма с уч.НДС" FORMAT ">>>,>>>,>>9.99".
pause 0.

/** Определение формы */
DEF FRAME editFrame
				"---------------------------------------------------- Текущий документ ---" SKIP 
				op.doc-num op.op-date SKIP
				op.details VIEW-AS EDITOR SIZE 40 BY 3 SKIP
				"-------------------------------------------------------------- Услуга ---" SKIP 
				detailsServCode SKIP
				detailsServName SKIP
				detailsServCount SKIP
				"-------------------------------------------------------- Счет-фактура ---" SKIP 
				infoSfType SKIP
				infoPayType SKIP
				infoSummaType SKIP
				infoNeedLoan SKIP infoLoanType infoLoan SKIP op.contract-date SKIP
				sfNumber sfDate sfAmount
				WITH SIZE 75 BY 22 SIDE-LABELS CENTERED OVERLAY TITLE "Информация о СФ по документу".

/** Компоненты доступны для изменения */
ENABLE infoLoanType WITH FRAME editFrame.
ENABLE infoLoan WITH FRAME editFrame.
ENABLE op.contract-date WITH FRAME editFrame.

/** Определение событий компонентов формы */
ON f1 OF detailsServCode IN FRAME editFrame DO:
	RUN "a-class.p" ("asset","asset", "КЛАССИФИКАТОР УСЛУГ И ЦЕННОСТЕЙ",4).
	IF (LASTKEY = 13 OR LASTKEY = 10) AND pick-value <> ? THEN DO:
		detailsServCode:SCREEN-VALUE IN FRAME editFrame = pick-value.
		detailsServName:SCREEN-VALUE IN FRAME editFrame = GetAssetName(shFilial,pick-value).
	END.
END.

/** Выпендреж необходимый! Из-за того, что номер договора АХД - это поле doc-num, а не cont-code, как в депозитах! */
ON LEAVE OF infoLoan IN FRAME editFrame DO:
	IF infoLoanType:SCREEN-VALUE IN FRAME editFrame = "АХД" THEN 
		DO:
			FIND FIRST loan WHERE 
				contract = infoLoanType:SCREEN-VALUE IN FRAME editFrame
				AND
				doc-num = infoLoan:SCREEN-VALUE IN FRAME editFrame
				NO-LOCK NO-ERROR.
			IF AVAIL loan THEN 
				DO:
					infoLoanContCode = loan.cont-code.
				END.
			ELSE
				DO:
					MESSAGE "Договор не найден!" VIEW-AS ALERT-BOX.
					RETURN NO-APPLY.
				END.
		END.
	ELSE
		DO:
			FIND FIRST loan WHERE 
				contract = infoLoanType:SCREEN-VALUE IN FRAME editFrame
				AND
				cont-code = infoLoan:SCREEN-VALUE IN FRAME editFrame
				NO-LOCK NO-ERROR.
			IF AVAIL loan THEN 
				DO:
					infoLoanContCode = loan.cont-code.
				END.
			ELSE
				DO:
					MESSAGE "Договор не найден!" VIEW-AS ALERT-BOX.
					RETURN NO-APPLY.
				END.
		END.
END.

ON LEAVE OF detailsServCode IN FRAME editFrame DO:
	IF detailsServCode:SCREEN-VALUE IN FRAME editFrame = "" THEN 
		DO:
			MESSAGE "Код ценности/услуги должен быть указан! (выбор из справочника - F1)" VIEW-AS ALERT-BOX.
			RETURN NO-APPLY.
		END.
	IF NOT AvailAsset(shFilial, detailsServCode:SCREEN-VALUE IN FRAME editFrame) THEN
		DO:
			MESSAGE "Нет ценности/услуги с таким кодом! (выбор из справочника - F1)" VIEW-AS ALERT-BOX.
			RETURN NO-APPLY.
		END.
END.

ON VALUE-CHANGED OF detailsServCode IN FRAME editFrame DO:
	if AvailAsset(shFilial, detailsServCode:SCREEN-VALUE IN FRAME editFrame) then 
		do:
			detailsServName:SCREEN-VALUE IN FRAME editFrame =
					GetAssetName(shFilial, detailsServCode:SCREEN-VALUE IN FRAME editFrame).
		end.	
END.

ON VALUE-CHANGED OF infoNeedLoan IN FRAME editFrame DO:
	RUN widgetVisible1.
END.

/** Перебираем выделенные документы */
FOR EACH tmprecid NO-LOCK,
		FIRST op WHERE RECID(op) = tmprecid.id 
	:
		
		/** Читаем из БД значения */
		{pirsfopsigns-r.i}
		
		/** Показываем форму */
		DISPLAY op.doc-num op.op-date op.details
						detailsServCode 
						detailsServName 
						detailsServCount 
						infoSfType 
						infoPayType 
						infoSummaType 
						infoNeedLoan 
						infoLoanType 
						infoLoan 
						op.contract-date LABEL "Дата начала срока, за который платят"
						sfNumber 
						sfDate 
						sfAmount 
						WITH FRAME editFrame.

		/** Подготовка компонентов формы: что-то показать, что-то скрыть*/
		RUN widgetVisible1.

		SET detailsServCode 
				detailsServName
				detailsServCount
				infoSfType
				infoPayType
				infoSummaType 
				infoNeedLoan
				sfNumber sfDate sfAmount 
				WITH FRAME editFrame.
				
		/** Сохраняем данные в БД */
		{pirsfopsigns-w.i}
END.


HIDE FRAME editFrame.


/** Управляет видимостью некоторых компонент на форме */
PROCEDURE widgetVisible1 :

		/*MESSAGE infoNeedLoan:SCREEN-VALUE IN FRAME editFrame VIEW-AS ALERT-BOX.*/
		IF infoNeedLoan:SCREEN-VALUE IN FRAME editFrame = "Да" THEN 
			DO:
				infoLoanType:VISIBLE IN FRAME editFrame = YES.
				infoLoan:VISIBLE IN FRAME editFrame = YES.
				if infoPayType:SCREEN-VALUE IN FRAME editFrame = "а/о" then 
					op.contract-date:VISIBLE IN FRAME editFrame = YES.
				/*APPLY "ENTRY" TO infoLoanType IN FRAME editFrame.*/
			END.
		ELSE 
			DO:
				infoLoanType:VISIBLE IN FRAME editFrame = NO.
				infoLoan:VISIBLE IN FRAME editFrame = NO.
				op.contract-date:VISIBLE IN FRAME editFrame = NO.
			END.

END.

{intrface.del}