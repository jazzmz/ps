{pirsavelog.p}

/** 
		ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007

		Формирование печатной формы сообщения об операции юридического лица.
		
		Бурягин Е.П., 15.05.2007 15:16
		
		<Как_запускается> : Запускается из документов операционного дня.
		<Параметры запуска>
		<Как_работает>
		<Особенности_реализации>
		
		Изменено: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>)
		          <Описание изменения>

		Изменено: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>)
		          <Описание изменения>

*/

/** Глобальные определения */
{globals.i}

/** Используем информацию из броузера */
{tmprecid.def}

/* Будем использовать перенос по словам */
{wordwrap.def}

{parsin.def}
/** Функции для работы с метасхемой */
{intrface.get xclass}
/** Функции для работы со строками */
{intrface.get strng}

/******************************************* Определение переменных и др. */

/** Информация, отражаемая в сообщении */
DEF TEMP-TABLE ttMessage NO-UNDO
	FIELD needControl AS CHAR /* Операция нуждается в контроле */
	FIELD irregulary AS CHAR /* Необычная операция */
	FIELD documentNumber AS CHAR LABEL "Номер документа" /* Номер документа */
	FIELD documentDetails AS CHAR /* Содержание операции */
	FIELD documentCurrency AS CHAR /* Код валюты операции */
	FIELD documentAmount AS DECIMAL /* Сумма операции */
	FIELD documentDate AS DATE /* Дата операции */
	FIELD troubles AS CHAR /* Описание возникших затруднений квалификации */
	FIELD userName AS CHAR /* Сотрудник, составивший сообщение */
	FIELD userPost AS CHAR /* Должность сотрудника */
	FIELD dateTime AS CHAR /* Дата и время составления */
  FIELD resolve AS CHAR /* Принято решение */
	.
/** Информация о лицах, проводящих операцию */
DEF TEMP-TABLE ttClient NO-UNDO
	FIELD id AS INTEGER
	FIELD name AS CHAR /* ФИО */
	FIELD inn AS CHAR 
	FIELD ogrn AS CHAR
	FIELD addressOfStay AS CHAR
	FIELD addressOfPost AS CHAR
	FIELD account AS CHAR /* Счет, с помощью которого проводится сделка */
	.


DEF VAR documentType AS CHAR /* Операция, подлежащая контролю / Необычная сделка */
			LABEL "Категория"
			VIEW-AS RADIO-SET RADIO-BUTTONS "Подлежит контролю", "control", "Необычная", "irregulary".

/** Визуальный элемент, с помощью которого в случае необходимости 
    можно выбрать клиента, который попадет в сообщение */
DEF VAR needClient AS CHAR LABEL "Нужный клиент" FORMAT "x(30)"
	VIEW-AS COMBO-BOX LIST-ITEM-PAIRS "","" INNER-LINES 5
.

DEF FRAME frmMessage 
	ttMessage.documentNumber SKIP
	documentType SKIP
	needClient SKIP
	ttMessage.troubles LABEL "Описание возникших затруднений"
	   VIEW-AS EDITOR SIZE 40 BY 6
	WITH SIDE-LABELS CENTERED OVERLAY TITLE "Реквизиты сообщения".

DEF VAR str AS CHAR EXTENT 100. /** Текст сообщения */
DEF VAR i AS INTEGER. /** Итератор */

DEF VAR withoutAcctMask AS CHAR INIT "40909*,40913*".

/******************************************* Реализация */

FOR EACH tmprecid NO-LOCK,
    FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK
  :
  	CREATE ttMessage.
  	
  	ttMessage.documentNumber = op.doc-num.

  	ttMessage.documentDetails = op.details.
  	
  	/** Найдем код валюты и сумму */
  	FIND FIRST op-entry OF op NO-LOCK NO-ERROR.
  	IF AVAIL op-entry THEN DO:
  		ttMessage.documentCurrency = (IF op-entry.currency = "" THEN "810" ELSE op-entry.currency).
  		ttMessage.documentAmount = (IF op-entry.currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur).
  	END.
  	
  	ttMessage.documentDate = op.doc-date.
  	
  	/** Зачистим таблицу */
  	FOR EACH ttClient: 		DELETE ttClient.  	END.
  	DO i = 1 TO needClient:NUM-ITEMS :     needClient:DELETE(i). 	END.
  	i = 0.
  	/** Найдем всех лиц, проводящих операцию */
  	/** Обработаем счет по дебету и кредиту */
  	FOR EACH acct WHERE 
 				acct.cust-cat = "Ю"
  			AND 
  			(
  				acct.acct = op-entry.acct-db
  				OR 
  				acct.acct = op-entry.acct-cr
  			)
  			NO-LOCK
  		:
  			FIND FIRST cust-corp WHERE cust-corp.cust-id = acct.cust-id NO-LOCK NO-ERROR.
  			IF AVAIL cust-corp THEN DO:
  				CREATE ttClient.
  				i = i + 1.
  				ttClient.id = i.
  				ttClient.name = cust-corp.name-corp.
  				ttClient.inn = cust-corp.inn.
	  			IF ttClient.inn = "0" OR ttClient.inn = "000000000000" THEN ttClient.inn = "".
	  			ttClient.ogrn = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОГРН", "").
  				/** При присвоении адреса страхуемся от "двойного значения" */
	  			ttClient.addressOfStay = DelDoubleChars(IF addr-of-low[1] = addr-of-low[2] THEN addr-of-low[1] ELSE addr-of-low[1] + " " + addr-of-low[2], ",").
	  			ttClient.addressOfPost = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "АдресП", "").
	  			IF ttClient.addressOfPost = "" THEN ttClient.addressOfPost = ttClient.addressOfStay.
	  			ttClient.account = (IF CAN-DO(withoutAcctMask, acct.acct) THEN "" ELSE acct.acct).
	  			needClient:ADD-LAST(ttClient.name, STRING(ttClient.id)).
  			END.
  	END.
  	
		FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
		IF AVAIL _user THEN DO:
			ttMessage.userName = _user._user-name.
			ttMessage.userPost = GetXAttrValueEx("_user", _user._userid, "Должность", "").
			ttMessage.dateTime = STRING(TODAY, "99.99.9999") /* + ", " + STRING(TIME, "HH:MM:SS") */.
		END.

  	/** Запросим тип и другие данные по операции у пользователя */
  	PAUSE 0.
  	documentType = "".
  	DISPLAY ttMessage.documentNumber documentType ttMessage.troubles WITH FRAME frmMessage.
  	SET documentType needClient ttMessage.troubles WITH FRAME frmMessage.
  	
  	IF documentType:SCREEN-VALUE = "control" THEN 
  		ASSIGN ttMessage.needControl = "X" ttMessage.irregulary = "".
  	ELSE
  		ASSIGN ttMessage.needControl = "" ttMessage.irregulary = "X".
  	
  	ttMessage.troubles = ttMessage.troubles:SCREEN-VALUE.

  	
  	{setdest.i}

		PUT UNFORMATTED SPACE(50) "СООБЩЕНИЕ" SKIP
		                SPACE(40) "об операции юридического лица." SKIP
		                .
		
  	PUT UNFORMATTED 
  	"┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐" SKIP
  	"│Сведения об операции (сделке)                                                                                │" SKIP
  	"├─────────────────────────────────────────────────────────────────────────────────────────────────────────────┤" SKIP
  	"│Принадлежность к указанным категориям (нужное пометить 'X')                                                  │" SKIP
  	"├────────────────────────────────────────────────┬────────────────────────────────────────────────────────────┤" SKIP
  	"│   Операция, подлежащая обязательному контролю  │" ttMessage.needControl FORMAT "x(60)"                     "│" SKIP
  	"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  	"│   Необычная сделка                             │" ttMessage.irregulary FORMAT "x(60)"                      "│" SKIP
  	"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  	"│Документ, на основании которого осуществляется  │" ttMessage.documentNumber FORMAT "x(60)"                  "│" SKIP
  	"│операция (сделка)                               │                                                            │" SKIP
  	"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP.
  	
  	/** Содержание операции нужно разбить по строкам */
  	str[1] = ttMessage.documentDetails.
  	{wordwrap.i &s=str &n=100 &l=60}
  	
  	PUT UNFORMATTED
  	"│   Содержание операции (сделки)                 │" str[1] FORMAT "x(60)"                                    "│" SKIP.
  	DO i = 2 TO 100 :
  		IF str[i] <> "" THEN DO:
  			PUT UNFORMATTED
		  	"│                                                │" str[i] FORMAT "x(60)"                                    "│" SKIP.
		  	str[i] = "".
		  END.
  	END.
  	
  	PUT UNFORMATTED
  	"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  	"│   Код валюты операции (сделки)                 │" ttMessage.documentCurrency FORMAT "x(60)"                "│" SKIP
  	"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  	"│   Сумма операции (сделки)                      │" TRIM(STRING(ttMessage.documentAmount, ">>>,>>>,>>>,>>9.99")) FORMAT "x(60)" "│" SKIP
  	"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  	"│   Дата совершения операции (сделки)            │" STRING(ttMessage.documentDate, "99.99.9999") FORMAT "x(60)" "│" SKIP
  	"├────────────────────────────────────────────────┴────────────────────────────────────────────────────────────┤" SKIP
  	"│Сведения о лице, проводящем операцию (совершающем сделку)                                            │" SKIP
  	"├────────────────────────────────────────────────┬────────────────────────────────────────────────────────────┤" SKIP.
  	
  	FIND FIRST ttClient WHERE ttClient.id = INT(needClient:SCREEN-VALUE) NO-LOCK NO-ERROR.
  	IF AVAIL ttClient THEN DO:
  		str[1] = ttClient.ogrn.
  		{wordwrap.i &s=str &n=3 &l=60}
  		
  		PUT UNFORMATTED
  		"│   Наименование                                 │" ttClient.name FORMAT "x(60)" "│" SKIP
  		"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  		"│   ИНН                                          │" ttClient.inn FORMAT "x(60)" "│" SKIP
  		"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  		"│   Регистрационный номер, место регистрации     │" str[1] FORMAT "x(60)" "│" SKIP
  		"│                                                │" str[2] FORMAT "x(60)" "│" SKIP
  		"│                                                │" str[3] FORMAT "x(60)" "│" SKIP
  		"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP.
  		
  		str[1] = ttClient.addressOfStay. str[2] = "". str[3] = "".
  		PUT UNFORMATTED
  		"│   Место нахождения юридического лица           │" str[1] FORMAT "x(60)" "│" SKIP
  		"│                                                │" str[2] FORMAT "x(60)" "│" SKIP
  		"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP.
  		str[1] = ttClient.addressOfPost. str[2] = "".
  		PUT UNFORMATTED
  		"│   Почтовый адрес                               │" str[1] FORMAT "x(60)" "│" SKIP
  		"│                                                │" str[2] FORMAT "x(60)" "│" SKIP.
  		
  		
  	
	  	PUT UNFORMATTED
  		"├────────────────────────────────────────────────┴────────────────────────────────────────────────────────────┤" SKIP
  		"│Сведения о счете, с использованием которого проводится операция или сделка (кроме случаев осуществления      │" SKIP
	  	"│переводов без открытия счета):                                                                               │" SKIP
  		"├────────────────────────────────────────────────┬────────────────────────────────────────────────────────────┤" SKIP
  		"│   № счета                                      │" ttClient.account FORMAT "x(60)" "│" SKIP
	  	"├────────────────────────────────────────────────┴────────────────────────────────────────────────────────────┤" SKIP
  		"│Описание возникших затруднений квалификации операции как подлежащей обязательному контролю или причины,      │" SKIP
  		"│по которым сделка квалифицируется как необычная                                                              │" SKIP
  		"├─────────────────────────────────────────────────────────────────────────────────────────────────────────────┤" SKIP.
  	END.	
  	
  	str[1] = ttMessage.troubles.
  	{wordwrap.i &s=str &n=10 &l=109}
  	
  	DO i = 1 TO 10:
  		IF str[i] <> "" THEN 
  			PUT UNFORMATTED
  			"│" str[i] FORMAT "x(109)" "│" SKIP.
  	END.
  	
  	PUT UNFORMATTED
  	"├─────────────────────────────────────────────────────────────────────────────────────────────────────────────┤" SKIP
  	"│Сведения о сотруднике, составившем сообщение                                                                 │" SKIP
  	"├────────────────────────────────────────────────┬────────────────────────────────────────────────────────────┤" SKIP
  	"│   Ф.И.О.                                       │" /* ttMessage.userName FORMAT "x(60)" */ SPACE(60) "│" SKIP
  	"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  	"│   Должность                                    │" /* ttMessage.userPost FORMAT "x(60)" */ SPACE(60) "│" SKIP
  	"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  	"│   Подпись                                      │                                                            │" SKIP
  	"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  	"│   Дата, время                                  │" /* ttMessage.dateTime FORMAT "x(60)" */ SPACE(60) "│" SKIP
  	"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  	"│ПОДПИСЬ РУКОВОДИТЕЛЯ ПОДРАЗДЕЛЕНИЯ              │                                                            │" SKIP
  	"├────────────────────────────────────────────────┴────────────────────────────────────────────────────────────┤" SKIP
  	"│Отметка Ответственного сотрудника о получении Сообщения:                                                     │" SKIP
  	"├────────────────────────────────────────────────┬────────────────────────────────────────────────────────────┤" SKIP
  	"│   Дата, время                                  │                                                            │" SKIP
  	"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  	"│   Подпись                                      │                                                            │" SKIP
  	"├────────────────────────────────────────────────┴────────────────────────────────────────────────────────────┤" SKIP
  	"│Отметка Ответственного сотрудника о принятом решении:                                                        │" SKIP
  	"├────────────────────────────────────────────────┬────────────────────────────────────────────────────────────┤" SKIP
  	"│   Принято решение                              │" ttMessage.resolve FORMAT "x(60)" "│" SKIP
  	"│                                                │                                                            │" SKIP
  	"│                                                │                                                            │" SKIP
  	"│                                                │                                                            │" SKIP
  	"│                                                │                                                            │" SKIP
  	"│                                                │                                                            │" SKIP
  	"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  	"│   Дата                                         │                                                            │" SKIP
  	"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  	"│Подпись Руководителя Банка                      │                                                            │" SKIP
  	"│                                                │                                                            │" SKIP
  	"└────────────────────────────────────────────────┴────────────────────────────────────────────────────────────┘" SKIP.
  	
  	{preview.i}
  	
END.

HIDE FRAME frmMessage.

{intrface.del}
