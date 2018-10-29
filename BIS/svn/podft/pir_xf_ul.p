{pirsavelog.p}

/** 
    ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
    
    Формирование анкеты клиента юридического лица.
    
    Бурягин Е.П., 08.05.2007 14:22
    
    Запускается из броузера клиентов ЮЛ.
    <Параметры запуска> : Строка в виде выражения <имя_параметра>=<значение_параметра>[,...]
                          Обрабатываемые параметры: СотрУтвердОткрСчета - код сотрудника чья фамилия и должность 1.23.
                          выводятся в пункте 
    <Как_работает> : Для каждой записи, выделеной в броузере, заполняет ttCorporation (см. инклюдник pir_xf_def.i)
                     и ttLicense, если это необходимо. После сбора всей информации происходит формирование текста
                     анкеты, в конце в форматируется по ширине и выводится в PreView.
    <Особенности реализации> : Обработка праметров реализована индивидуально для каждой процедуры в ее коде.
    
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

/** Код пользователя из базы данных, который утверждает открытие счета */
DEFINE VARIABLE userIdAssent AS CHAR NO-UNDO.
/** Код пользователя из базы данных, который открыл первый счет */
DEFINE VARIABLE userOpenAcct AS CHAR NO-UNDO.
DEFINE VARIABLE cAcct        AS CHAR NO-UNDO.
DEFINE VARIABLE dAcct        AS DATE NO-UNDO.

{pir_xf_def3.i}


/******************************************* Реализация */

/** Разбор входного параметра */
userIdAssent = GetParamByNameAsChar(iParam, "СотрУтвердОткрСчета", "").


FOR EACH tmprecid NO-LOCK,
    FIRST cust-corp WHERE RECID(cust-corp) = tmprecid.id NO-LOCK
  :
/******************************************* Присвоение значений переменным и др. */
    
    /** См. определение в pir_xf_def.i */
    CREATE ttCorporation.
    ttCorporation.opf = GetCodeName("КодПредп",GetCodeVal("КодПредп", cust-corp.cust-stat)).
    ttCorporation.fullName = ttCorporation.opf + " " + cust-corp.name-corp.
    ttCorporation.shortName = cust-corp.name-short.
    ttCorporation.foreignLanguageName = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "engl-name", "").
    ttCorporation.opf = GetCodeName("КодПредп",
                               GetCodeVal("КодПредп", cust-corp.cust-stat)
                        ).
    ttCorporation.ogrn = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОГРН", "").
    ttCorporation.registrationDate = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "RegDate", "")).
    ttCorporation.registrationPlace = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "RegPlace", "").

/*
    ttCorporation.addressOfStay = DelDoubleChars(
        (IF cust-corp.addr-of-low[1] <> cust-corp.addr-of-low[2] 
         THEN cust-corp.addr-of-low[1] + " " + addr-of-low[2] 
         ELSE cust-corp.addr-of-low[1]
        ),
    "," ).
    ttCorporation.addressOfPost = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "АдресП", "").
*/
    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ю'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ 'АдрЮр'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttCorporation.addressOfStay = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE ?.

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ю'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ 'АдрФакт'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttCorporation.addressOfPost = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE ?.

    ttCorporation.tel = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "tel", "").
    ttCorporation.fax = cust-corp.fax.
    ttCorporation.inn = cust-corp.inn.
    ttCorporation.iin = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ИИН", "").

    tmpStr                      = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "СоставСД", "").
    ttCorporation.struct        = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "СтруктОрг", "")
       + IF ((tmpStr EQ "") OR (tmpStr EQ "нет")) THEN "" ELSE (";" + CHR(10) + "Совет директоров: " + tmpStr).
    tmpStr                      = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "СоставИКО", "").
    ttCorporation.struct        = ttCorporation.struct
       + IF ((tmpStr EQ "") OR (tmpStr EQ "нет")) THEN "" ELSE (";" + CHR(10) + "Исполнительный коллегиальный орган: " + tmpStr).
    ttCorporation.capital       = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "УставКап", "").
    ttCorporation.exist         = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ПрисутОргУправ", "").
    ttCorporation.riskLevel     = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "РискОтмыв", "").
    ttCorporation.otherBanks    = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "pirOtherBanks", "").
    ttCorporation.businessImage = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "pirBusImage", "").
    
    tmpStr                      = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОценкаРиска", "").
    ttCorporation.riskInfo      = GetCode("PirОценкаРиска", tmpStr).
    /** если по коду tmpStr записи в классификаторе нет, то в том же классификаторе
       ищем значение с кодом из ttCorporation.riskLevel */
    if ttCorporation.riskInfo = ? and tmpStr = "" then 
      ttCorporation.riskInfo = GetCode("PirОценкаРиска", ttCorporation.riskLevel).
    /** если вообще ничего не сработало и значение не присвоено, то оно будет пустым */
    if ttCorporation.riskInfo = ? then
       ttCorporation.riskInfo = tmpStr.
    
    ttCorporation.firstAcctOpenDate = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "FirstAccDate", "")).
    ttCorporation.inputDate = (IF ttCorporation.firstAcctOpenDate = ? THEN cust-corp.date-in ELSE ttCorporation.firstAcctOpenDate).
    ttCorporation.modifDate = GetLastHistoryDate("ЮЛ", cust-corp.cust-id, ttCorporation.inputDate).
    
    /** Соберем информацию о лицензиях */
    FOR EACH cust-ident WHERE cust-ident.cust-cat EQ "Ю"
                               AND cust-ident.cust-id  EQ cust-corp.cust-id
                               AND cust-ident.class-code = "cust-lic" 
            NO-LOCK:

               CREATE ttLicense.
               ttLicense.typeName = GetCodeName("ВидЛицДеят", cust-ident.cust-code-type).
               ttLicense.number = cust-ident.cust-code.
               ttLicense.openDate = cust-ident.open-date.
               ttLicense.issue = cust-ident.issue.
               ttLicense.endDate = cust-ident.close-date.

    END.

    /** Найдем сотрудника, открывшего счет  */
    cAcct = "".
    dAcct = DATE("01/01/2005").
    FOR EACH acct WHERE cust-cat = "Ю" AND cust-id = cust-corp.cust-id 
                    AND contract = "Расчет" NO-LOCK BY open-date:
      cAcct = acct.acct.
      dAcct = acct.open-date.
      userOpenAcct = GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "СотрОткрСч", acct.user-id).
      FIND FIRST _user WHERE _user._userid = userOpenAcct NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttCorporation.userNameOpenAcct = _user._user-name.
        ttCorporation.userPostOpenAcct = GetXAttrValueEx("_user", _user._userid, "Должность", "").
      END.
      LEAVE.
    END.
       /* Если нет расчетного счета */
    IF cAcct = ""
    THEN DO:
      FOR EACH acct WHERE cust-cat = "Ю" AND cust-id = cust-corp.cust-id 
                    NO-LOCK BY open-date:
        cAcct = acct.acct.
        dAcct = acct.open-date.
        userOpenAcct = GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "СотрОткрСч", acct.user-id).
        FIND FIRST _user WHERE _user._userid = userOpenAcct NO-LOCK NO-ERROR.
        IF AVAIL _user THEN DO:
          ttCorporation.userNameOpenAcct = _user._user-name.
          ttCorporation.userPostOpenAcct = GetXAttrValueEx("_user", _user._userid, "Должность", "").
        END.
        LEAVE.
      END.
    END.
       /* Если нет ни одного счета */
    IF cAcct = ""
    THEN DO:
      ttCorporation.userNameOpenAcct = "Без открытия счета".
      ttCorporation.userPostOpenAcct = "".
      userOpenAcct = "".
    END.

    /** Найдем сотрудника, заполнившего анкету в электронном виде */
       /* Если сотрудник не найден по счету или счет заводился в Бисквите */
    IF userOpenAcct = ? OR userOpenAcct = "" OR dAcct > DATE("27/07/2005")
    THEN DO:
      userOpenAcct = GetFirstHistoryUserid("cust-corp", STRING(cust-corp.cust-id)).
      FIND FIRST _user WHERE _user._userid = userOpenAcct NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttCorporation.userNameInput = _user._user-name.
        ttCorporation.userPostInput = GetXAttrValueEx("_user", _user._userid, "Должность", "").
      END.
    END.
    ELSE DO:
      ttCorporation.userNameInput = ttCorporation.userNameOpenAcct.
      ttCorporation.userPostInput = ttCorporation.userPostOpenAcct.
    END.

    /** Найдем сотрудника, утвердившего открытие счета. Это входной параметр процедуры. */
    IF cAcct = ""
    THEN DO:
      ttCorporation.userNameAssent = "Без открытия счета".
      ttCorporation.userPostAssent = "".
    END.
    ELSE DO:
      FIND FIRST _user WHERE _user._userid = userIdAssent NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttCorporation.userNameAssent = _user._user-name.
        ttCorporation.userPostAssent = GetXAttrValueEx("_user", _user._userid, "Должность", "").
      END.
    END.
    /** Найдем сотрудника, перенесшего анкету на бумажный носитель */
    FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
    IF AVAIL _user THEN DO:
      ttCorporation.userNamePrint = _user._user-name.
      ttCorporation.userPostPrint = GetXAttrValueEx("_user", _user._userid, "Должность", "").
    END.
    

        
/******************************************* Формирование печатной формы анкеты */
    
    str[1] = "1.1. Полное наименование: " + PrintStringInfo(ttCorporation.fullName) + CHR(10) 
           + "1.2. Краткое наименование: " + PrintStringInfo(ttCorporation.shortName) + CHR(10)
           + "1.3. Наименование на иностранном языке: " + PrintStringInfo(ttCorporation.foreignLanguageName) + CHR(10)
           + "1.4. Организационно правовая форма: " + PrintStringInfo(ttCorporation.opf) + CHR(10)
           + "1.5. Государственный регистрационный номер: " + PrintStringInfo(ttCorporation.ogrn) + CHR(10)
           + "1.6. Дата регистрации: " + PrintDateInfo(ttCorporation.registrationDate) + CHR(10)
           + "1.7. Место регистрации (город, область), наименование регистрирующего органа: " + 
                 PrintStringInfo(ttCorporation.registrationPlace) + CHR(10)
           + "1.8. Адрес местонахождения: " + PrintStringInfo(ttCorporation.addressOfStay) + CHR(10)
           + "1.9. Почтовый адрес: " + PrintStringInfo(ttCorporation.addressOfPost) + CHR(10)
           + "1.10. Номера " + CHR(10) 
            + "#tabконтактных телефонов: " + PrintStringInfo(ttCorporation.tel) + CHR(10)
           + "#tabфаксов: " + PrintStringInfo(ttCorporation.fax) + CHR(10)
           + "1.11. ИНН - для резидента: " + PrintStringInfo(ttCorporation.inn) + CHR(10)
           + "1.12. ИИН или код иностранной организации - для нерезидента: " + PrintStringInfo(ttCorporation.iin) + CHR(10)
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
                        + "Срок действия до: " + PrintDateInfo(ttLicense.endDate) + "#cr" + CHR(10) .                
      END.
    
    str[1] = str[1] + "1.14. Сведения об органах юридического лица (структура и персональный состав органов управления юридического лица): "
                        + PrintStringInfo(ttCorporation.struct) + CHR(10)
                    + "1.15. Сведения о величине зарегистрированного и оплаченного уставного (складочного) капитала или величине уставного фонда, имущества:"
                        + PrintStringInfo(ttCorporation.capital) + CHR(10)
                    + "1.16. Сведения о присутствии или отсутствии по своему местонахождению юридического лица, его постоянно действующего органа управления, "
                        + "иного органа или лица, которые имею право действовать от имени юридического лица без доверенности: " 
                        + PrintStringInfo(ttCorporation.exist) + CHR(10)
                    + "1.17. Наименования кредитных организаций, в которых клиент обслуживается (ранее обслуживался): " + PrintStringInfo(ttCorporation.otherBanks) + CHR(10)
                    + "1.18. Сведения о деловой репутации клиента: " + PrintStringInfo(ttCorporation.businessImage) + CHR(10)
                    + "1.19. Уровень степени риска: " + PrintStringInfo(ttCorporation.riskLevel) + CHR(10)
                    + "1.20. Обоснование оценки степени риска: " + PrintStringInfo(ttCorporation.riskInfo) + CHR(10)
                    + "1.21. Дата открытия первого банковского счета (вклада): " 
                        + PrintDateInfo(ttCorporation.firstAcctOpenDate) + CHR(10)
                    + "1.22. Дата заполнения Анкеты клиента: " + PrintDateInfo(ttCorporation.inputDate) + CHR(10)
                    + "1.23. Дата обновления Анкеты клиента: " + PrintDateInfo(ttCorporation.modifDate) + CHR(10)
                    + "1.24. Работник банка, открывший счет " + CHR(10)
                        + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttCorporation.userNameOpenAcct) + CHR(10)
                        + "#tabДолжность: " + PrintStringInfo(ttCorporation.userPostOpenAcct) + CHR(10)
                    + "1.25. Работник банка, утвердивший открытие счета" + CHR(10)
                        + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttCorporation.userNameAssent) + CHR(10)
                        + "#tabДолжность: " + PrintStringInfo(ttCorporation.userPostAssent) + CHR(10)
                    + "1.26. Работник банка, заполнивший Анкету клиента в электронном виде" + CHR(10)
                        + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttCorporation.userNameInput) + CHR(10)
                        + "#tabДолжность: " + PrintStringInfo(ttCorporation.userPostInput) + CHR(10)
                    + "1.27. Подпись уполномоченного работника Банка, перенесшего Анкету клиента, заполненную в электронном виде,"
                        + " на бумажный носитель" + CHR(10)
                        + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttCorporation.userNamePrint) + CHR(10)
                        + "#tabДолжность: " + PrintStringInfo(ttCorporation.userPostPrint) + CHR(10).
    
    
    {wordwrap.i &s=str &n=200 &l=80}
    
    {setdest.i}
    PUT UNFORMATTED SPACE(77) "ф. ЮЛ-1" SKIP(1)
                    SPACE(30) "АНКЕТА КЛИЕНТА - ЮРИДИЧЕСКОГО ЛИЦА" SKIP
                    SPACE(28) "(не являющегося кредитной организацией)" SKIP(2).
    
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


