{pirsavelog.p}

/** 
		ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007

		Формирование печатной формы сообщения об операции физического лица или индивидуального предпринимателя.
		
		Бурягин Е.П., 14.05.2007 16:20
		
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
	FIELD document AS CHAR
	FIELD address AS CHAR
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

/** Функция, возвращающая реквизиты документа, удостоверяющего личность ФЛ */
/** Вход: id - идентификатор записи person */
/** Выход: строка, содержащая реквизиты документа */ 
FUNCTION GetPersDocument RETURNS CHAR (INPUT id AS INTEGER) :

		/** Найдем документ */
		FOR EACH cust-ident WHERE 
				cust-ident.cust-cat = "Ч" 
				AND 
				cust-ident.cust-id = id
        NO-LOCK 
      :
    		IF GetXAttrValueEx("cust-ident",
                     STRING(cust-ident.cust-code-type) + ',' +
                     STRING(cust-ident.cust-code) + ',' +
                     STRING(cust-ident.cust-type-num),
                     "class-code",
                     "") EQ "p-cust-ident"
        THEN 
					RETURN GetCodeName("КодДокум", cust-ident.cust-code-type) + " "
    					+ cust-ident.cust-code + " выдан " + STRING(cust-ident.open-date, "99.99.9999")
    					+ " " + cust-ident.issue.
    			
   	END.
   	
END.

/** Функция, возвращающая реквизиты документа, удостоверяющего личность ИП */
/** Вход: id - идентификатор записи cust-corp */
/** Выход: строка, содержащая реквизиты документа */ 
FUNCTION GetCorpDocument RETURNS CHAR (INPUT id AS INTEGER) :
	RETURN GetCodeName("КодДокум", 
												GetXAttrValueEx("cust-corp", STRING(id), "document-id", "")) 
												+ " "	+ GetXAttrValueEx("cust-corp", STRING(id), "document", "")
												+ " выдан " + STRING(DATE(GetXAttrValueEx("cust-corp", STRING(id), "Document4Date_vid", "")), "99.99.9999")
    										+ " " + GetXAttrValueEx("cust-corp", STRING(id), "issue", "").
END.
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
  		ttMessage.documentCurrency = op-entry.currency.
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
  			(
  				acct.cust-cat = "Ч"
  				OR
  				acct.cust-cat = "Ю"
  			)
  			AND 
  			(
  				acct.acct = op-entry.acct-db
  				OR 
  				acct.acct = op-entry.acct-cr
  			)
  			NO-LOCK
  		:
	  		FIND FIRST person WHERE acct.cust-cat = "Ч" AND person.person-id = acct.cust-id NO-LOCK NO-ERROR.
  			IF AVAIL person THEN DO:
  				CREATE ttClient.
  				i = i + 1.
  				ttClient.id = i.
  				ttClient.name = person.name-last + " " + person.first-names.
	  			ttClient.inn = person.inn.
	  			IF ttClient.inn = "0" OR ttClient.inn = "000000000000" THEN ttClient.inn = "".
  				ttClient.ogrn = GetXAttrValueEx("person", STRING(person.person-id), "ОГРН", "").
  				/** Реквизиты документа извлекаются с помощью локальной функции */
  				ttClient.document = GetPersDocument(person.person-id).
  				/** При присвоении адреса страхуемся от "двойного значения" */
	  			ttClient.address = DelDoubleChars(IF address[1] = address[2] THEN address[1] ELSE address[1] + " " + address[2], ",").
	  			ttClient.account = (IF CAN-DO(withoutAcctMask, acct.acct) THEN "" ELSE acct.acct).
	  			needClient:ADD-LAST(ttClient.name, STRING(ttClient.id)).
  			END.
  			
  			FIND FIRST cust-corp WHERE acct.cust-cat = "Ю" AND cust-corp.cust-id = acct.cust-id NO-LOCK NO-ERROR.
  			IF AVAIL cust-corp AND GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "Предпр", "") = "Предпр" THEN DO:
  				CREATE ttClient.
  				i = i + 1.
  				ttClient.id = i.
  				ttClient.name = cust-corp.name-corp.
  				ttClient.inn = cust-corp.inn.
	  			IF ttClient.inn = "0" OR ttClient.inn = "000000000000" THEN ttClient.inn = "".
	  			ttClient.ogrn = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОГРН", "").
  				/** Реквизиты документа извлекаются с помощью локальной функции */
	  			ttClient.document = GetCorpDocument(cust-corp.cust-id).
  				/** При присвоении адреса страхуемся от "двойного значения" */
	  			ttClient.address = DelDoubleChars(IF addr-of-low[1] = addr-of-low[2] THEN addr-of-low[1] ELSE addr-of-low[1] + " " + addr-of-low[2], ",").
	  			ttClient.account = (IF CAN-DO(withoutAcctMask, acct.acct) THEN "" ELSE acct.acct).
	  			needClient:ADD-LAST(ttClient.name, STRING(ttClient.id)).
  			END.
  	END.
  	
		FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
		IF AVAIL _user THEN DO:
			ttMessage.userName = _user._user-name.
			ttMessage.userPost = GetXAttrValueEx("_user", _user._userid, "Должность", "").
			ttMessage.dateTime = STRING(TODAY, "99.99.9999") /*+ ", " + STRING(TIME, "HH:MM:SS") */.
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
		                SPACE(20) "об операции физического лица или индивидуального предпринимателя." SKIP
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
  	"│Сведения о лице (лицах), проводящих операцию (совершающих сделку)                                            │" SKIP
  	"├────────────────────────────────────────────────┬────────────────────────────────────────────────────────────┤" SKIP.
  	
  	FIND FIRST ttClient WHERE ttClient.id = INT(needClient:SCREEN-VALUE) NO-LOCK NO-ERROR.
  	IF AVAIL ttClient THEN DO:
  		str[1] = ttClient.ogrn + " " + ttClient.document.
  		{wordwrap.i &s=str &n=3 &l=60}
  		
  		PUT UNFORMATTED
  		"│   Ф.И.О.                                       │" ttClient.name FORMAT "x(60)" "│" SKIP
  		"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  		"│   ИНН                                          │" ttClient.inn FORMAT "x(60)" "│" SKIP
  		"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP
  		"│   ОГРН для ИП, Данные документа,               │" str[1] FORMAT "x(60)" "│" SKIP
  		"│   удостоверяющего личность (тип, серия, номер, │" str[2] FORMAT "x(60)" "│" SKIP
  		"│   кем и когда выдан)                           │" str[3] FORMAT "x(60)" "│" SKIP
  		"├────────────────────────────────────────────────┼────────────────────────────────────────────────────────────┤" SKIP.
  		
  		str[1] = ttClient.address. str[2] = "". str[3] = "".
  		PUT UNFORMATTED
  		"│   Адрес места жительства (регистрации) или     │" str[1] FORMAT "x(60)" "│" SKIP
  		"│   места пребывания                             │" str[2] FORMAT "x(60)" "│" SKIP.
  		
  	
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
