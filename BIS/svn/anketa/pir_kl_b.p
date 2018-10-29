{pirsavelog.p}

/** 
    ООО КБ "ПPOМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007

    Формирование анкеты клиента - кредитной организации.
    
    Бурягин Е.П., 14.05.2007 9:30
    
    <Как_запускается> : Запускается из броузера банков-клиентов
    <Параметры запуска> : Строка в виде выражения <имя_параметра>=<значение_параметра>[,...]
                          Обрабатываемые параметры: СотрУтвердОткрСчета - код сотрудника чья фамилия и должность 1.25.
                          выводятся в пункте
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

DEFINE INPUT PARAMETER iParam AS CHAR.

/** Код пользователя из базы данных, которые утверждает открытие счета */
DEFINE VARIABLE userIdAssent AS CHAR NO-UNDO.

{pir_xf_def3.i}


/******************************************* Реализация */

/** Разбор входного параметра */
userIdAssent = GetParamByNameAsChar(iParam, "СотрУтвердОткрСчета", "").


FOR EACH tmprecid NO-LOCK,
    FIRST banks WHERE RECID(banks) = tmprecid.id NO-LOCK
  :
/******************************************* Присвоение значений переменным и др. */
    
    /** См. определение в pir_xf_def.i */
    CREATE ttBank.
    ttBank.fullName = GetXAttrValue("banks", STRING(banks.bank-id), "pirFullName").
    IF NOT {assigned ttBank.fullName} THEN ttBank.fullName = banks.name.
    ttBank.shortName = GetXAttrValue("banks", STRING(banks.bank-id), "pirShortName").
    IF NOT {assigned ttBank.shortName} THEN ttBank.shortName = banks.short-name.
    ttBank.foreignLanguageName = GetXAttrValueEx("banks", STRING(banks.bank-id), "engl-name", "").
    ttBank.opf = GetCodeName("КодПредп", GetXAttrValueEx("banks", STRING(banks.bank-id), "bank-stat", "")).
    ttBank.ogrn = GetXAttrValueEx("banks", STRING(banks.bank-id), "ОГРН", "").
    ttBank.registrationDate = DATE(GetXAttrValueEx("banks", STRING(banks.bank-id), "RegDate", "")).
    ttBank.registrationPlace = GetXAttrValueEx("banks", STRING(banks.bank-id), "RegPlace", "").
/*
    ttBank.addressOfStay = DelDoubleChars(banks.law-address, "," ).
    ttBank.addressOfPost = DelDoubleChars(banks.mail-address, ",").
*/
    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Б'
         AND cust-ident.cust-id        EQ banks.bank-id
         AND cust-ident.cust-code-type EQ 'АдрЮр'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBank.addressOfStay = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Б'
         AND cust-ident.cust-id        EQ banks.bank-id
         AND cust-ident.cust-code-type EQ 'АдрПочт'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBank.addressOfPost = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    ttBank.tel = GetXAttrValueEx("banks", STRING(banks.bank-id), "tel", "").
    ttBank.fax = GetXAttrValueEx("banks", STRING(banks.bank-id), "fax", "").

    /**ttBank.inn = banks.inn.*/
    /** Найдем ИНН и БИК */
    FIND FIRST cust-ident WHERE cust-ident.cust-cat = "Б" AND cust-ident.cust-id = banks.bank-id
        AND cust-ident.cust-code-type = "ИНН" NO-LOCK NO-ERROR.
    IF AVAIL cust-ident THEN ttBank.inn = cust-ident.cust-code.   
    /* Buryagin commented at 30.05.2007 14:57
    FIND FIRST banks-code WHERE banks-code.bank-id = banks.bank-id AND banks-code.bank-code-type = "ИНН" NO-LOCK NO-ERROR.
    IF AVAIL banks-code THEN ttBank.inn = banks-code.bank-code.
    */
    FIND FIRST banks-code WHERE banks-code.bank-id = banks.bank-id AND banks-code.bank-code-type = "МФО-9" NO-LOCK NO-ERROR.
    IF AVAIL banks-code THEN ttBank.bic = banks-code.bank-code.
    
    ttBank.okpo = GetXAttrValueEx("banks", STRING(banks.bank-id), "okpo", "").
    ttBank.iin = GetXAttrValueEx("banks", STRING(banks.bank-id), "ИИН", "").
    ttBank.struct = GetXAttrValueEx("banks", STRING(banks.bank-id), "СтруктОрг", "").
    ttBank.capital = GetXAttrValueEx("banks", STRING(banks.bank-id), "УставКап", "").
    ttBank.exist = GetXAttrValueEx("banks", STRING(banks.bank-id), "ПрисутОргУправ", "").
    ttBank.riskLevel = GetXAttrValueEx("banks", STRING(banks.bank-id), "РискОтмыв", "").
    
/*
    tmpStr = GetXAttrValueEx("banks", STRING(banks.bank-id), "ОценкаРиска", "").
    ttBank.riskInfo = GetCode("PirОценкаРиска", tmpStr).
    if ttBank.riskInfo = ? then ttBank.riskInfo = tmpStr.
*/
    tmpStr = GetXAttrValueEx("banks", STRING(banks.bank-id), "ОценкаРиска", "").
    ttBank.riskInfo = GetCode("PirОценкаРиска", tmpStr).
    /** если по коду tmpStr записи в классификаторе нет, то в том же классификаторе
       ищем значение с кодом из ttBank.riskLevel */
    if ttBank.riskInfo = ? and tmpStr = "" then 
      ttBank.riskInfo = GetCode("PirОценкаРиска", ttBank.riskLevel).
    /** если вообще ничего не сработало и значение не присвоено, то оно будет пустым */
    if ttBank.riskInfo = ? then
      ttBank.riskInfo = tmpStr.
    
    ttBank.firstAcctOpenDate = DATE(GetXAttrValueEx("banks", STRING(banks.bank-id), "FirstAccDate", "")).
    ttBank.inputDate = (IF ttBank.firstAcctOpenDate = ? 
                        THEN DATE(GetXAttrValueEx("banks", STRING(banks.bank-id), "date-in", "")) 
                        ELSE ttBank.firstAcctOpenDate).
    ttBank.modifDate = GetLastHistoryDate("Б", banks.bank-id, ttBank.inputDate).
    
    
    /** Соберем информацию о лицензиях */
    FOR EACH cust-ident WHERE cust-ident.cust-cat EQ "Б"
                               AND cust-ident.cust-id  EQ banks.bank-id 
                               AND cust-ident.class-code = "cust-lic"
      NO-LOCK:

        CREATE ttLicense.
        ttLicense.typeName = GetCodeName("ВидБанкЛиц", cust-ident.cust-code-type).
        ttLicense.number = cust-ident.cust-code.
        ttLicense.openDate = cust-ident.open-date.
        ttLicense.issue = cust-ident.issue.
        ttLicense.endDate = cust-ident.close-date.

    END.
  
    /** Найдем сотрудника, открывшего счет и сотрудника, заполнившего анкету в электронном виде */
    FIND FIRST acct WHERE acct.cust-cat = "Б" AND acct.cust-id = banks.bank-id NO-LOCK NO-ERROR.
    IF AVAIL acct THEN DO:
      FIND FIRST _user WHERE _user._userid = acct.user-id NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttBank.userNameOpenAcct = _user._user-name.
        ttBank.userPostOpenAcct = GetXAttrValueEx("_user", _user._userid, "Должность", "").
        ttBank.userNameInput = ttBank.userNameOpenAcct.
        ttBank.userPostInput = ttBank.userPostOpenAcct.
      END.
    END.
    /** Найдем сотрудника, утвердившего открытие счета. Это входной параметр процедуры. */
    FIND FIRST _user WHERE _user._userid = userIdAssent NO-LOCK NO-ERROR.
    IF AVAIL _user THEN DO:
      ttBank.userNameAssent = _user._user-name.
      ttBank.userPostAssent = GetXAttrValueEx("_user", _user._userid, "Должность", "").
    END.
    /** Найдем сотрудника, перенесшего анкету на бумажный носитель */
    FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
    IF AVAIL _user THEN DO:
      ttBank.userNamePrint = _user._user-name.
      ttBank.userPostPrint = GetXAttrValueEx("_user", _user._userid, "Должность", "").
    END.
    

        
/******************************************* Формирование печатной формы анкеты */
    
    str[1] = "1.1. Полное наименование: " + PrintStringInfo(ttBank.fullName) + CHR(10) 
           + "1.2. Краткое наименование: " + PrintStringInfo(ttBank.shortName) + CHR(10)
           + "1.3. Наименование на иностранном языке: " + PrintStringInfo(ttBank.foreignLanguageName) + CHR(10)
           + "1.4. Организационно правовая форма: " + PrintStringInfo(ttBank.opf) + CHR(10)
           + "1.5. Государственный регистрационный номер: " + PrintStringInfo(ttBank.ogrn) + CHR(10)
           + "1.6. Дата регистрации: " + PrintDateInfo(ttBank.registrationDate) + CHR(10)
           + "1.7. Место регистрации (город, область), наименование регистрирующего органа: " + 
                 PrintStringInfo(ttBank.registrationPlace) + CHR(10)
           + "1.8. Адрес местонахождения: " + PrintStringInfo(ttBank.addressOfStay) + CHR(10)
           + "1.9. Почтовый адрес: " + PrintStringInfo(ttBank.addressOfPost) + CHR(10)
           + "1.10. Номера " + CHR(10) 
            + "#tabконтактных телефонов: " + PrintStringInfo(ttBank.tel) + CHR(10)
           + "#tabфаксов: " + PrintStringInfo(ttBank.fax) + CHR(10)
           + "1.11. ИНН - для резидента: " + PrintStringInfo(ttBank.inn) + CHR(10)
           + "1.12. ИИН или код иностранной организации - для нерезидента: " + PrintStringInfo(ttBank.iin) + CHR(10)
           + "1.13. Сведения о лицензии на право осуществления деятельности, подлежащей лицензированию: " + CHR(10)
           .
           
    /** Выводим информацию о лицензиях */
    IF NOT CAN-FIND(FIRST ttLicense) THEN 
      /** Если информации о лицензиях нет, то сообщяем об этом */
      str[1] = str[1] + PrintStringInfo("") + CHR(10).
    ELSE
      FOR EACH ttLicense :
        str[1] = str[1] + "Вид лицензируемой деятельности: " + PrintStringInfo(ttLicense.typeName) + CHR(10)
                        + "Номер: " + PrintStringInfo(ttLicense.number) + CHR(10)
                        + "Дата выдачи лицензии: " + PrintDateInfo(ttLicense.openDate) + CHR(10)
                        + "Кем выдана: " + PrintStringInfo(ttLicense.issue) + CHR(10)
                        + "Срок действия до: " + PrintDateInfo(ttLicense.endDate) + "#cr" + CHR(10).                
      END.
    
    str[1] = str[1] + "1.14. Банковский идентификационный код: (для резидентов) " + PrintStringInfo(ttBank.bic) + CHR(10)
                    + "1.15. Сведения об органах юридического лица (структура и персональный состав органов управления юридического лица): " 
                          + PrintStringInfo(ttBank.struct) + CHR(10)
                    + "1.16. Сведения о величине зарегистрированного и оплаченного уставного (складочного) капитала или величине уставного фонда, имущества: "
                          + PrintStringInfo(ttBank.capital) + CHR(10)
                    + "1.17. Сведения о присутствии или отсутствии по своему местонахождению юридического лица, его постоянно действующего органа управления, "
                        + "иного органа или лица, которые имею право действовать от имени юридического лица без доверенности: " 
                        + PrintStringInfo(ttBank.exist) + CHR(10)
                    + "1.18. Уровень степени риска: " + PrintStringInfo(ttBank.riskLevel) + CHR(10)
                    + "1.19. Обоснование оценки степени риска: " + PrintStringInfo(ttBank.riskInfo) + CHR(10)
                    + "1.20. Дата открытия первого банковского счета (вклада): " 
                        + PrintDateInfo(ttBank.firstAcctOpenDate) + CHR(10)
                    + "1.21. Дата заполнения Анкеты клиента: " + PrintDateInfo(ttBank.inputDate) + CHR(10)
                    + "1.22. Дата обновления Анкеты клиента: " + PrintDateInfo(ttBank.modifDate) + CHR(10)
                    + "1.23. Работник банка, открывший счет " + CHR(10)
                        + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBank.userNameOpenAcct) + CHR(10)
                        + "#tabДолжность: " + PrintStringInfo(ttBank.userPostOpenAcct) + CHR(10)
                    + "1.24. Работник банка, утвердивший открытие счета" + CHR(10)
                        + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBank.userNameAssent) + CHR(10)
                        + "#tabДолжность: " + PrintStringInfo(ttBank.userPostAssent) + CHR(10)
                    + "1.25. Работник банка, заполнивший Анкету клиента в электронном виде" + CHR(10)
                        + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBank.userNameInput) + CHR(10)
                        + "#tabДолжность: " + PrintStringInfo(ttBank.userPostInput) + CHR(10)
                    + "1.26. Подпись уполномоченного работника Банка, перенесшего Анкету клиента, заполненную в электронном виде,"
                        + " на бумажный носитель" + CHR(10)
                        + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBank.userNamePrint) + CHR(10)
                        + "#tabДолжность: " + PrintStringInfo(ttBank.userPostPrint) + CHR(10).
    
    
    {wordwrap.i &s=str &n=200 &l=80}
    
    {setdest.i}
    PUT UNFORMATTED /*SPACE(77) "ф. ЮЛ-1" SKIP(1)*/
                    SPACE(30) "АНКЕТА КЛИЕНТА - КРЕДИТНОЙ ОРГАНИЗАЦИИ" SKIP(2).
    
    DO i = 1 TO 200:
      IF str[i] <> "" THEN DO:
        str[i] = REPLACE(str[i], "#tab",CHR(9)).
        str[i] = REPLACE(str[i], "#cr", CHR(10)).
        PUT UNFORMATTED str[i] SKIP.
      END.
    END.
    
    {preview.i}

END.

{intrface.del}


