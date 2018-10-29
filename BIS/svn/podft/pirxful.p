{pirsavelog.p}
/*
		Анкета юридического лица.
		Бурягин Е.П., 30.01.2006 9:48
*/
/* Глобальные определения системы */
{globals.i}
/* Объявление инструментария переноса строк */
{wordwrap.def}
{tmprecid.def}        /** Используем информацию из броузера */

/* Утверждающий открытие счета */
DEF VAR pirbosD6 AS CHAR NO-UNDO.
pirbosD6 = FGetSetting("PIRBoss","PIRBosD6","").
DEF VAR pirbosU6 AS CHAR NO-UNDO.
pirbosU6 = FGetSetting("PIRBoss","PIRBosU6","").

/* Дата заполнения анкеты */
DEF VAR xfile-date AS DATE LABEL "Дата заполнения" INITIAL TODAY NO-UNDO.
/* ФИО сотрудника открывшего счет (первый) */
DEF VAR auserFIO AS CHAR NO-UNDO.
/* Должность сотрудника открывшего счет (первый) */
DEF VAR auserPost AS CHAR NO-UNDO.
/* Имя пользователя системы */
DEF VAR auserID AS CHAR NO-UNDO.
/* Итератор */
DEF VAR i AS INTEGER NO-UNDO.
/* рабочая лошадка */
DEF VAR tmp AS CHAR NO-UNDO.
DEF VAR tmp_d AS DATE NO-UNDO.
/* Месяца */
DEF VAR months AS CHAR
	INITIAL "января,февраля,марта,апреля,мая,июня,июля,августа,сентября,октября,ноября,декабря" NO-UNDO.

/* Для первой записи, выделенной в броузере, делаем... */
FOR FIRST tmprecid NO-LOCK,
		FIRST cust-corp WHERE RECID(cust-corp) EQ tmprecid.id NO-LOCK
:
	PAUSE 0.
	DISPLAY xfile-date SKIP
		cust-corp.name-corp FORMAT "x(30)"
		WITH FRAME myFrame CENTERED OVERLAY SIDE-LABELS.
	SET xfile-date WITH FRAME myFrame.
	HIDE FRAME myFrame.
	/* Объявление стандартного вывода в файл */
	{setdest.i}
	PUT UNFORMATTED SPACE(25) "Анкета клиента - юридического лица" SKIP
								SPACE(23) "(не являющегося кредитной организацией)." SKIP (2).
	PUT UNFORMATTED "Наименование клиента (полное) " SKIP 
		GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"FullName","") SKIP(1).
	PUT UNFORMATTED "                     (сокращенное)" SKIP 
		cust-corp.cust-stat ' ' cust-corp.name-corp SKIP(1).
	PUT UNFORMATTED "                     (на иностранном языке)" SKIP
		GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"engl-name","") SKIP(1).
	PUT UNFORMATTED 'Регистрационный номер ' SKIP 
		GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"ОГРН","") SKIP(1).
	
	tmp_d = DATE(GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"ДатаОГРН","")).
	PUT UNFORMATTED 'Дата гос.регистрации "' STRING(DAY(tmp_d)) '" ' 
		 ENTRY(MONTH(tmp_d),months) ' ' STRING(YEAR(tmp_d)) 'г.' SKIP(1).
	
	PUT UNFORMATTED 'Место гос.регистрации ' 
		GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"RegPlace","") SKIP(1). 
	
	PUT UNFORMATTED 'Регистрирующий орган '
		/* GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"ОргСведПред","")*/ SKIP(1).
	
	PUT UNFORMATTED 'Адрес места нахождения ' SKIP
	 cust-corp.addr-of-low[1] SKIP(1).
	PUT UNFORMATTED 'Почтовый адрес ' SKIP
	 GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"АдресП","") SKIP(1).
	PUT UNFORMATTED 'Номера контактных телефонов и факсов ' SKIP
	 cust-corp.fax SKIP(1).
	PUT UNFORMATTED 'ИНН налогоплательщика (ИНН для резидента и ИНН или код для нерезидента (если' SKIP
	 'имеются) ' cust-corp.inn SKIP(1).
	PUT UNFORMATTED 'Сведения о лицензии на право осуществления деятельности (в случае ее налиия)' SKIP
	 GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"ЛицензОрг","") SKIP(1).
	PUT UNFORMATTED 'Органы юридического лица (структура и персональный состав органов управления' SKIP
		'юридического лица) ' GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"СтруктОрг","") SKIP(1).
	PUT UNFORMATTED 'Величина зарегистрированного и оплаченного уставного капитала или величина' SKIP
		'уставного фонда, имущества) ' GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"УставКап","") SKIP(1).
	PUT UNFORMATTED 'Сведения  о  присутствии  или  отсутствии  по  своему местонахождению юридического' SKIP
	                'лица, его постоянно действующего органа управления, иного органа или лица, которые' SKIP
	                'имеют право действовать от имени юридического лица без доверенности' SKIP(1)
	                '                      ПРИСУТСТВУЕТ / ОТСУТСТВУЕТ' SKIP
	                '                         (ненужное зачеркнуть)' SKIP(1).
 	PUT UNFORMATTED 'Основные виды деятельности (ОКВЭД)' SKIP
 	GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"ОКВЭД","") SKIP(1).
	
	/* Счета */
	i = 1.
	FOR EACH acct WHERE
		acct.cust-cat = "Ю"
		AND
		acct.cust-id = cust-corp.cust-id
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
		auserFIO ', ' auserPost SKIP(1).
	PUT UNFORMATTED 'Фамилия, имя, отчество, должность, а также подпись лица, уполномоченного' SKIP
	 'сотрудника банка '
		ENTRY(2,PIRBosU6) ', ' ENTRY(1,PIRBosU6) SKIP(1).
	PUT UNFORMATTED 'Уровень риска ' GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"РискОтмыв","") SKIP(1).
	PUT UNFORMATTED 'Оценка риска ' GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"ОценкаРиска","") SKIP.
	{preview.i}
END.

