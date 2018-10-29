{pirsavelog.p}
/*
		Анкета физического лица.
		Бурягин Е.П., 26.01.2006 9:26
*/
/*
		Анисимов А.А., 04.05.2007 12:59
		При отсутствии миграционной карты выводится текст не требуется
*/
/* Глобальные определения системы */
{globals.i}
/* Объявление инструментария переноса строк */
{wordwrap.def}
{tmprecid.def}        /** Используем информацию из броузера */

/* Утверждающий открытие счета */
DEF VAR pirbosD6 AS CHAR.
pirbosD6 = FGetSetting("PIRBoss","PIRBosD6","").
/* Дата заполнения анкеты */
DEF VAR xfile-date AS DATE LABEL "Дата заполнения" INITIAL TODAY.
/* Дата выдачи документа, удостоверяющего личность */
DEF VAR document-issue-date AS CHAR.
/* Строка реквизитов документа */
DEF VAR document-line AS CHAR EXTENT 3.
/* Телефоны */
DEF VAR phone-line AS CHAR EXTENT 3.
/* ФИО сотрудника открывшего счет (первый) */
DEF VAR auserFIO AS CHAR.
/* Должность сотрудника открывшего счет (первый) */
DEF VAR auserPost AS CHAR.
/* Имя пользователя системы */
DEF VAR auserID AS CHAR.
/* Место рождения */
DEF VAR birthPlace AS CHAR.
/* Гражданство */
DEF VAR CitizenShip AS CHAR.
/* Тип документа ВИЗЫ */
DEF VAR VisaType AS CHAR.
/* Итератор */
DEF VAR i AS INTEGER.
/* рабочая лошадка */
DEF VAR tmp AS CHAR.
/* Месяца */
DEF VAR months AS CHAR 
	INITIAL "января,февраля,марта,апреля,мая,июня,июля,августа,сентября,октября,ноября,декабря".

/* Для первой записи, выделенной в броузере, делаем... */
FOR FIRST tmprecid NO-LOCK,
		FIRST person WHERE RECID(person) EQ tmprecid.id NO-LOCK
:
	PAUSE 0.
	DISPLAY xfile-date SKIP
		person.name-last FORMAT "x(30)" SKIP
		person.first-names FORMAT "x(40)"
		WITH FRAME myFrame CENTERED OVERLAY SIDE-LABELS.
	SET xfile-date WITH FRAME myFrame.
	HIDE FRAME myFrame.
	/* Объявление стандартного вывода в файл */
	{setdest.i}
	PUT UNFORMATTED SPACE(25) "Анкета клиента - физического лица." SKIP(2).
	/* ФИО */
	PUT UNFORMATTED "Ф.И.О. " person.name-last ' ' person.first-names SKIP(1).
	/* Документ */
	document-issue-date = GetXAttrValueEx("person",STRING(person.person-id),"Document4Date_vid","").
	document-line[1] = person.document-id + " " 
								+ person.document + " " + person.issue + " " 
								+ document-issue-date.
	{wordwrap.i &s=document-line &l=70 &n=3}
	PUT UNFORMATTED "Реквизиты документа," SKIP
	                "удостоверяющего" SKIP
	                "личность " document-line[1] SKIP.
	DO i = 2 TO 3 :
		IF document-line[i] <> "" THEN
		PUT UNFORMATTED "         " document-line[i] SKIP.
	END.

	/* Дата рождения */
	PUT UNFORMATTED ' ' SKIP 'Дата рождения "' STRING(DAY(person.birthday)) '" ' 
			ENTRY(MONTH(person.birthday),months) ' ' STRING(YEAR(person.birthday)) 'г.' SKIP(1).

	/* Место рождения */
	birthPlace = GetXAttrValueEx("person",STRING(person.person-id),"BirthPlace","").
	PUT UNFORMATTED 'Место рождения ' birthPlace SKIP(1).

	/* Гражданство */
	CitizenShip = GetXAttrValueEx("person",STRING(person.person-id),"CitizenShip","").
	PUT UNFORMATTED 'Гражданство ' CitizenShip SKIP(1).

	/* Данные миргационной карты */
	PUT UNFORMATTED 'Данные миграционной карты' SKIP.
	tmp = GetXAttrValueEx("person",STRING(person.person-id),"МигрКарт","").
/* start Анисимов А.А. */
	IF tmp EQ "" THEN
		PUT UNFORMATTED SPACE(10) 'Не требуется ' SKIP.
/* edn   Анисимов А.А. */
	IF tmp <> "" THEN
		PUT UNFORMATTED SPACE(10) 'Номер: ' tmp SKIP.
	tmp = GetXAttrValueEx("person",STRING(person.person-id),"МигрПравПребС","").
	IF tmp <> "" THEN
		PUT UNFORMATTED SPACE(10) 'Дата начала права пребывания: ' tmp SKIP.
	tmp = GetXAttrValueEx("person",STRING(person.person-id),"МигрПребывС","").
	IF tmp <> "" THEN
		PUT UNFORMATTED SPACE(10) 'Дата начала пребывания: ' tmp SKIP.
	tmp = GetXAttrValueEx("person",STRING(person.person-id),"МигрПравПребПо","").
	IF tmp <> "" THEN
		PUT UNFORMATTED SPACE(10) 'Дата окончания права пребывания: ' tmp SKIP.
	tmp = GetXAttrValueEx("person",STRING(person.person-id),"МигрПребывПо","").
	IF tmp <> "" THEN
		PUT UNFORMATTED SPACE(10) 'Дата окончания пребывания: ' tmp SKIP.
	tmp = GetXAttrValueEx("person",STRING(person.person-id),"МигрЦельВизита","").
	IF tmp <> "" THEN
		PUT UNFORMATTED SPACE(10) 'Цель визита: ' tmp SKIP.
		
	/* Данные документа на пребывание в РФ */
	VisaType = GetXAttrValueEx("person",STRING(person.person-id),"VisaType","").
	FIND FIRST code WHERE 
		code.class = "VisaType" 
		AND
		code.code = VisaType
		NO-LOCK NO-ERROR.
	IF AVAIL code THEN VisaType = code.name.
	PUT UNFORMATTED ' ' SKIP 'Данные документа, подтверждающего' SKIP
	                'право иностранного гражданина или лица без' SKIP
	                'гражданства на пребывание в РФ ' VisaType 
	                GetXAttrValueEx("person",STRING(person.person-id),"Visa","") SKIP(1).
	
	/* Телефоны и факсы */
	phone-line[1] = person.phone[1] + " " +  person.phone[2] + " " + person.fax.
	{wordwrap.i &s=phone-line &l=40 &n=3}
	PUT UNFORMATTED 'Номера контактных телефонов и факсов ' phone-line[1] SKIP.
	DO i = 2 TO 3 :
		IF phone-line[i] <> "" THEN
			PUT UNFORMATTED '                                     ' phone-line[i] SKIP.
	END.
	
	/* ИНН */
	PUT UNFORMATTED ' ' SKIP 'ИНН налогоплательщика (если имеется) ' person.inn SKIP(1).
	
	/* Счета */
	i = 1.
	FOR EACH acct WHERE
		acct.cust-cat = "Ч"
		AND
		acct.cust-id = person.person-id
		NO-LOCK
		BY open-date
	:
		IF i = 1 THEN
			DO:
				PUT UNFORMATTED "Дата открытия перв.сч.".
				auserID = acct.user-id.
			END.
		ELSE
			PUT UNFORMATTED "Дата открытия других сч.".
		i = i + 1.
		PUT UNFORMATTED '"' STRING(DAY(acct.open-date)) '" ' 
			ENTRY(MONTH(acct.open-date),months) ' ' STRING(YEAR(acct.open-date)) 'г. ' acct.acct SKIP.
	END.
	
	/* Дата заполнения */
	PUT UNFORMATTED ' ' SKIP 'Дата заполнения анкеты ' STRING(xfile-date,"99/99/9999") SKIP(1).
	
	/* Сотрудники */
	FIND FIRST _user WHERE _user._userid EQ auserID NO-LOCK NO-ERROR.
	IF AVAIL _user THEN
		auserFIO = _user._user-name.
	auserPost = GetXAttrValueEx("_user",auserID,"Должность","").
	PUT UNFORMATTED 
	'Фамилия, имя, отчество, должность сотрудника,' SKIP
	'открывшего счет ' auserFIO ', ' auserPost SKIP(1).
	PUT UNFORMATTED 
	'Фамилия, имя, отчество, должность сотрудника,' SKIP
	'утвердившего открытие счета ' 
		ENTRY(2,PIRBosD6) ', ' ENTRY(1,PIRBosD6) SKIP(1).
	PUT UNFORMATTED 'Фамилия, имя, отчество, должность лица,' SKIP
	 'заполнившего анкету в электронном виде '
		auserFIO ', ' auserPost SKIP.
	{preview.i}
END.

