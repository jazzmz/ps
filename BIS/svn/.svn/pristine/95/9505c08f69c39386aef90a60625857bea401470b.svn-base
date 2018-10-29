/** 
		ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007

		Определения общие для всех типов анкет.
		
		Бурягин Е.П., 08.05.2007 16:10
		
		<Как_запускается>
		<Параметры запуска>
		<Как_работает>
		<Особенности_реализации>
		
		Изменено: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>)
		          <Описание изменения>

		Изменено: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>)
		          <Описание изменения>

*/

/** Информация о ЮЛ, отражаемая в анкете */
DEF TEMP-TABLE ttCorporation NO-UNDO
	FIELD fullName AS CHAR
	FIELD shortName AS CHAR
	FIELD foreignLanguageName AS CHAR
	FIELD opf AS CHAR /* Организационно-правовая форма */
	FIELD ogrn AS CHAR /* Общероссийский государственный регистрационный номер */
	FIELD registrationDate AS DATE /* Дата регистрации */
	FIELD registrationPlace AS CHAR /* Место регистрации */
	FIELD addressOfStay AS CHAR /* Адрес места нахождения */
	FIELD addressOfPost AS CHAR /* Почтовый адрес */
	FIELD tel AS CHAR /* Телефоны */
	FIELD fax AS CHAR /* Факс */
	FIELD inn AS CHAR
	FIELD iin AS CHAR /* ИИН или код иностранной организации - для нерезидента */
	FIELD struct AS CHAR /* Сведения об органах юридического лица (структура и персональный состав) */
	FIELD capital AS CHAR /* Сведения о величине зарегистрированного и оплаченного уставного капитала */
	FIELD exist AS CHAR /* Присутствует/отсутствует по своему местонахождению */
	FIELD riskLevel AS CHAR /* Уровень риска */
	FIELD riskInfo AS CHAR /* Обоснование риска */
	FIELD firstAcctOpenDate AS DATE /* Дата открытия первого счета */
	FIELD inputDate AS DATE /* Дата заполнения анкеты */
	FIELD modifDate AS DATE /* Дата изменения анкеты */
	FIELD userNameOpenAcct AS CHAR /* Сотрудник, открывший счет */
	FIELD userPostOpenAcct AS CHAR /* Должность сотрудника */
	FIELD userNameAssent AS CHAR /* Сотрудник, утвердивший открытие счета */
	FIELD userPostAssent AS CHAR
	FIELD userNameInput AS CHAR /* Сотрудник, заполнивший анкету в электронном виде */
	FIELD userPostInput AS CHAR 
	FIELD userNamePrint AS CHAR /* Сотрудник, перенесший анкету на бумажный носитель */
	FIELD userPostPrint AS CHAR
	FIELD otherBanks AS CHAR /* Информация о других банках клиента */
	FIELD businessImage AS CHAR /* Сведения о репутации клиента */
	.
	
/** Информация о ФЛ, отражаемая в анкете */
DEF TEMP-TABLE ttPerson NO-UNDO
	FIELD lastName AS CHAR /* Фамилия */
	FIELD firstName AS CHAR /* Имя */
	FIELD patronymic AS CHAR /* Отчество */
	FIELD birthDate AS DATE /* Дата рождения */
	FIELD birthPlace AS CHAR /* Место рождения */
	FIELD nationality AS CHAR /* Гражданство */
	FIELD document AS CHAR /* Документ, удостоверяющий личность */
	FIELD migrationCard AS CHAR /* Номер миграционной карты */
	FIELD visa AS CHAR /* Данные о визе: тип и доп. информация */
	FIELD visaSeries AS CHAR /* Серия визы */
	FIELD visaNumber AS CHAR /* Номер визы */
	FIELD visaNationality AS CHAR /* Гражданство в визе */
	FIELD visaTarget AS CHAR /* Цель визита */
	FIELD visaPeriodBegin AS DATE /* Дата начала срока пребывания */
	FIELD visaPeriodEnd AS DATE /* Дата конца срока пребывания */
	FIELD visaOrderBegin AS DATE /* Дата начала действия права пребывания */
	FIELD visaOrderEnd AS DATE /* Дата конца действия права пребывания */
	FIELD addressOfLaw AS CHAR /* Место регистрации */
	FIELD addressOfStay AS CHAR /* Место пребывания */
	FIELD inn AS CHAR
	FIELD hasRelationToForeignBoss AS CHAR /* Данные об отношениях с иностранным должностным лицом */
	FIELD isForeignBoss AS CHAR /* Данные о иностранном должностном лице */
	FIELD fromFamilyOfForeignBoss AS CHAR /* Данные о семейном родстве с иностранным должностным лицом */ 
	FIELD tel AS CHAR
	FIELD fax AS CHAR
	FIELD riskLevel AS CHAR /* Уровень риска */
	FIELD riskInfo AS CHAR /* Обоснование риска */
	FIELD firstAcctOpenDate AS DATE /* Дата открытия первого счета */
	FIELD inputDate AS DATE /* Дата заполнения анкеты */
	FIELD modifDate AS DATE /* Дата изменения анкеты */
	FIELD userNameOpenAcct AS CHAR /* Сотрудник, открывший счет */
	FIELD userPostOpenAcct AS CHAR /* Должность сотрудника */
	FIELD userNameAssent AS CHAR /* Сотрудник, утвердивший открытие счета */
	FIELD userPostAssent AS CHAR
	FIELD userNameInput AS CHAR /* Сотрудник, заполнивший анкету в электронном виде */
	FIELD userPostInput AS CHAR 
	FIELD userNamePrint AS CHAR /* Сотрудник, перенесший анкету на бумажный носитель */
	FIELD userPostPrint AS CHAR
	.
	
/** Информация об индивидуальном предпринимателе. Наследован от ttPerson */
DEFINE TEMP-TABLE ttBusinessmen NO-UNDO LIKE ttPerson
	FIELD ogrn AS CHAR /* Код ОГРН */
	FIELD registrationDate AS DATE /* Дата регистрации */
	FIELD registrationPlace AS CHAR /* Место регистрации */
	FIELD addressOfPost AS CHAR /* Почтовый адрес */
	FIELD otherBanks AS CHAR /* Информация о других банках клиента */
	FIELD businessImage AS CHAR /* Сведения о репутации клиента */
	.

/** Информация о банке-клиенте, отражаемая в анкете */
DEF TEMP-TABLE ttBank NO-UNDO
	FIELD fullName AS CHAR
	FIELD shortName AS CHAR
	FIELD foreignLanguageName AS CHAR
	FIELD opf AS CHAR /* Организационно-правовая форма */
	FIELD ogrn AS CHAR /* Общероссийский государственный регистрационный номер */
	FIELD registrationDate AS DATE /* Дата регистрации */
	FIELD registrationPlace AS CHAR /* Место регистрации */
	FIELD addressOfStay AS CHAR /* Адрес места нахождения */
	FIELD addressOfPost AS CHAR /* Почтовый адрес */
	FIELD tel AS CHAR /* Телефоны */
	FIELD fax AS CHAR /* Факс */
	FIELD inn AS CHAR
	FIELD iin AS CHAR /* ИИН или код иностранной организации - для нерезидента */
	FIELD okpo AS CHAR /* Код ОКПО */
	FIELD bic AS CHAR /* БИК банка (для резидентов) */
	FIELD struct AS CHAR /* Сведения об органах юридического лица (структура и персональный состав) */
	FIELD capital AS CHAR /* Сведения о величине зарегистрированного и оплаченного уставного капитала */
	FIELD exist AS CHAR /* Присутствует/отсутствует по своему местонахождению */
	FIELD riskLevel AS CHAR /* Уровень риска */
	FIELD riskInfo AS CHAR /* Обоснование риска */
	FIELD firstAcctOpenDate AS DATE /* Дата открытия первого счета */
	FIELD inputDate AS DATE /* Дата заполнения анкеты */
	FIELD modifDate AS DATE /* Дата изменения анкеты */
	FIELD userNameOpenAcct AS CHAR /* Сотрудник, открывший счет */
	FIELD userPostOpenAcct AS CHAR /* Должность сотрудника */
	FIELD userNameAssent AS CHAR /* Сотрудник, утвердивший открытие счета */
	FIELD userPostAssent AS CHAR
	FIELD userNameInput AS CHAR /* Сотрудник, заполнивший анкету в электронном виде */
	FIELD userPostInput AS CHAR 
	FIELD userNamePrint AS CHAR /* Сотрудник, перенесший анкету на бумажный носитель */
	FIELD userPostPrint AS CHAR
	.
	
/** Информация о выгодоприобретателе ЮЛ, отражаемая в анкете */
DEF TEMP-TABLE ttBeneficiaryCorp NO-UNDO LIKE ttCorporation
	FIELD benefitInfo AS CHAR /* Сведения о выгоде */
	.

/** Информация о выгодоприобретателе ФЛ, отражаемая в анкете */
DEF TEMP-TABLE ttBeneficiaryPers NO-UNDO LIKE ttPerson
  FIELD benefitInfo AS CHAR /* Сведения о выгоде */
  .
  
/** Информация о выгодоприобретателе ИП, отражаемая в анкете */
DEF TEMP-TABLE ttBeneficiaryBusinessmen NO-UNDO LIKE ttBusinessmen
	FIELD benefitInfo AS CHAR /* Сведения о выгоде */
	FIELD opf AS CHAR /* Организацонно-правовая форма */
	.
  	
/** Информация о лицензиях */
DEF TEMP-TABLE ttLicense NO-UNDO
	FIELD typeName AS CHAR /* Вид лицензируемой деятельности */
	FIELD number AS CHAR /* Номер лицензии */
	FIELD openDate AS DATE /* Дата выдачи */
	FIELD issue AS CHAR /* Кем выдана */
	FIELD endDate AS DATE /* Дата окончания действия */
	.

DEF VAR i AS INTEGER NO-UNDO. /* Итератор */
DEF VAR str AS CHAR EXTENT 200 NO-UNDO. /* Текст анкеты */
DEF VAR tmpStr AS CHAR NO-UNDO.

DEF VAR notExistMessage AS CHAR INIT "(отсутствует)" NO-UNDO.

/** Функция печати символьной информации. При ее отсутствии выводится соответсвующее сообщение */
FUNCTION PrintStringInfo RETURNS CHAR (INPUT str AS CHAR) :
	IF str = ? OR str = "" THEN RETURN notExistMessage. ELSE RETURN str.
END FUNCTION.

/** Функция печати даты . При ее отсутствии выводится соответсвующее сообщение */
FUNCTION PrintDateInfo RETURNS CHAR (INPUT d AS DATE) :
	IF d = ? THEN RETURN notExistMessage. ELSE RETURN STRING(d, "99.99.9999").
END FUNCTION.

/** Взято из cl_anket.p. Раньше она называлась vHistoryDate 
    Возвращает время последнего изменения */
FUNCTION GetLastHistoryDate RETURNS DATE (INPUT iTabl     AS CHARACTER,
                                    			INPUT iMasterId AS CHARACTER ).

   FIND LAST history WHERE history.file-name EQ iTabl
                       AND history.field-ref EQ iMasterId
      NO-LOCK NO-ERROR.

   IF AVAILABLE history THEN
      RETURN history.modif-date.
   ELSE
      RETURN ?.
END.

/** Возвращает первый отличный от "BIS" код кользователя, создавший или внесший изменение в запись */
FUNCTION GetFirstHistoryUserid RETURNS CHAR (INPUT iTabl     AS CHARACTER,
                                    			INPUT iMasterId AS CHARACTER ).

   FIND FIRST history WHERE history.file-name EQ iTabl
                       AND history.field-ref EQ iMasterId
                       AND NOT CAN-DO("BIS", history.user-id) 
      NO-LOCK NO-ERROR.

   IF AVAILABLE history THEN
      RETURN history.user-id.
   ELSE
      RETURN "".
END.

/* Преобразование адреса в формате КЛАДР к удобочитаемому виду                   */
/* формат КЛАДР: индекс,район,город,нас.пункт,улица,дом,корпус,квартира,строение */
/* причем поз.2-5 сопровождаются дополнениями г,р-н,ул и т.д., а поз.6-9 заполняются одними цифрами */
FUNCTION Kladr RETURNS CHARACTER (INPUT cAdr AS CHARACTER).

   DEFINE VARIABLE cAdrPart AS CHARACTER EXTENT 9 INITIAL "".
   DEFINE VARIABLE cAdrDop  AS CHARACTER EXTENT 9 INITIAL ['', ',', ',', ',', ',', ',д.', ',корп.', ',кв.', ',стр.'].
   DEFINE VARIABLE cAdrKl   AS CHARACTER.
   DEFINE VARIABLE iI       AS INTEGER.
   DEFINE VARIABLE iNzpt    AS INTEGER.

   iNzpt = MINIMUM(NUM-ENTRIES(cAdr), 9).

   DO iI = 1 TO iNzpt:
      cAdrPart[iI] = ENTRY(iI, cAdr).
   END.

   cAdrKl = IF (cAdrPart[1] NE "") THEN cAdrPart[1] ELSE "".
   DO iI = 2 TO MINIMUM(iNzpt, 6) :
      IF (cAdrPart[iI] NE "") THEN cAdrKl = cAdrKl + cAdrDop[iI] + cAdrPart[iI].
   END.

   IF (cAdrPart[9] NE "") AND (iNzpt EQ 9) THEN cAdrKl = cAdrKl + cAdrDop[9] + cAdrPart[9].
   IF (cAdrPart[7] NE "") AND (iNzpt GE 7) THEN cAdrKl = cAdrKl + cAdrDop[7] + cAdrPart[7].
   IF (cAdrPart[8] NE "") AND (iNzpt GE 8) THEN cAdrKl = cAdrKl + cAdrDop[8] + cAdrPart[8].

   RETURN cAdrKl.
END.