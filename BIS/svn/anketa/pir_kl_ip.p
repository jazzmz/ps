{pirsavelog.p}
/** 
    ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
    Формирует анкету клиента - индивидуального предпринимателя
    
    Бурягин Е.П., 14.05.2007 11:23
    
    <Как_запускается> : Запускается из броузера клиентов ЮЛ.
    <Параметры запуска> : Строка в виде выражения <имя_параметра>=<значение_параметра>[,...]
                          Обрабатываемые параметры: СотрУтвердОткрСчета - код сотрудника чья фамилия и должность 1.23.
                          выводятся в пункте
    <Как_работает>
    <Особенности_реализации> : Не смотря на то, что поиск информации ведется по таблице cust-corp, для хранения найденной
                               информации используем таблицу ttBusinessmen, т.к. она в точности подходит.
    
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

    CREATE ttBusinessmen.
    ttBusinessmen.lastName = TRIM(ENTRY(1, cust-corp.name-corp, " ")).
    ttBusinessmen.firstName = (IF NUM-ENTRIES(cust-corp.name-corp, " ") > 1 THEN ENTRY(2, cust-corp.name-corp, " ") ELSE "").
    ttBusinessmen.patronymic = (IF NUM-ENTRIES(cust-corp.name-corp, " ") > 2 THEN ENTRY(3, cust-corp.name-corp, " ") ELSE "").
    ttBusinessmen.birthDate = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "BirthDay", "")).
    ttBusinessmen.birthPlace = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "BirthPlace", "").
    
    /** Найдем гражданство */
    FIND FIRST country WHERE country.country-id = cust-corp.country-id NO-LOCK NO-ERROR.
    IF AVAIL country THEN ttBusinessmen.nationality = country.country-name.
    
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

    /** Найдем документ. Формат строки: <Тип_документа> <Номер> <Когда_выдан> <Кем_выдан> */
    ttBusinessmen.document = GetCodeName("КодДокум", 
                        GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "document-id", "")) 
                        + " "  + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "document", "")
                        + " выдан " + STRING(DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "Document4Date_vid", "")), "99.99.9999")
                        + " " + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "issue", "").
     
     ttBusinessmen.migrationCard = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "МигрКарт", "").
     ttBusinessmen.visa = GetCodeName("VisaType", GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "VisaType", "")) 
         + " " + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "Visa", "").
     ttBusinessmen.visaSeries = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "VisaNum", "").
     ttBusinessmen.visaNumber = (IF NUM-ENTRIES(ttBusinessmen.visaSeries, " ") > 1 THEN ENTRY(2, ttBusinessmen.visaSeries, " ") ELSE "").
     ttBusinessmen.visaSeries = ENTRY(1, ttBusinessmen.visaSeries, " ").
    
    /** Найдем гражданство по визе */
    FIND FIRST country WHERE country.country-id = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "country-id2", "") NO-LOCK NO-ERROR.
    IF AVAIL country THEN ttBusinessmen.visaNationality = country.country-name.
    
    ttBusinessmen.visaTarget = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "МигрЦельВизита", "").
    ttBusinessmen.visaPeriodBegin = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "МигрПребывС", "")).
    ttBusinessmen.visaPeriodEnd = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "МигрПребывПо", "")).
    ttBusinessmen.visaOrderBegin = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "МигрПравПребС", "")).
    ttBusinessmen.visaOrderEnd = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "МигрПравПребПо", "")).

/*
    ttBusinessmen.addressOfLaw = DelDoubleChars(
        (IF cust-corp.addr-of-low[1] <> cust-corp.addr-of-low[2] 
         THEN cust-corp.addr-of-low[1] + " " + addr-of-low[2] 
         ELSE cust-corp.addr-of-low[1]
        ),
    "," ).
    ttBusinessmen.addressOfStay = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "АдресП", "").
    IF ttBusinessmen.addressOfStay = "" THEN ttBusinessmen.addressOfStay = ttBusinessmen.addressOfLaw.
    ttBusinessmen.addressOfPost = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "PlaceOfStay", "").
    IF ttBusinessmen.addressOfPost = "" THEN ttBusinessmen.addressOfPost = ttBusinessmen.addressOfStay.
*/
    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ю'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ 'АдрЮр'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBusinessmen.addressOfLaw = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ю'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ 'АдрФакт'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBusinessmen.addressOfStay = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ю'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ 'АдрПочт'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBusinessmen.addressOfPost = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    ttBusinessmen.ogrn = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОГРН", "").
    ttBusinessmen.registrationDate = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "RegDate", "")).
    ttBusinessmen.registrationPlace = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "RegPlace", "").
    
    ttBusinessmen.inn = cust-corp.inn.
    IF ttBusinessmen.inn = "000000000000" OR ttBusinessmen.inn = "0" THEN ttBusinessmen.inn = "".

    ttBusinessmen.hasRelationToForeignBoss = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОтнОкруж_ИПДЛ","").
    ttBusinessmen.isForeignBoss = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "Статус_ИПДЛ","").
    ttBusinessmen.fromFamilyOfForeignBoss = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "СтепРодст_ИПДЛ","").

    ttBusinessmen.tel = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "tel", "").
    ttBusinessmen.fax = cust-corp.fax.
    
    ttBusinessmen.riskLevel = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "РискОтмыв", "").
    ttBusinessmen.otherBanks = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "pirOtherBanks", "").
    ttBusinessmen.businessImage = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "pirBusImage", "").
    
/*
    tmpStr = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОценкаРиска", "").
    ttBusinessmen.riskInfo = GetCode("PirОценкаРиска", tmpStr).
    if ttBusinessmen.riskInfo = ? then ttBusinessmen.riskInfo = tmpStr.
*/
    tmpStr = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОценкаРиска", "").
    ttBusinessmen.riskInfo = GetCode("PirОценкаРиска", tmpStr).
    /** если по коду tmpStr записи в классификаторе нет, то в том же классификаторе
       ищем значение с кодом из ttBusinessmen.riskLevel */
    if ttBusinessmen.riskInfo = ? and tmpStr = "" then 
      ttBusinessmen.riskInfo = GetCode("PirОценкаРиска", ttBusinessmen.riskLevel).
    /** если вообще ничего не сработало и значение не присвоено, то оно будет пустым */
    if ttBusinessmen.riskInfo = ? then
      ttBusinessmen.riskInfo = tmpStr.

    ttBusinessmen.firstAcctOpenDate = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "FirstAccDate", "")).
    ttBusinessmen.inputDate = ttBusinessmen.firstAcctOpenDate.
    ttBusinessmen.modifDate = GetLastHistoryDate("ИП", cust-corp.cust-id, ttBusinessmen.inputDate).

    
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
        ttBusinessmen.userNameOpenAcct = _user._user-name.
        ttBusinessmen.userPostOpenAcct = GetXAttrValueEx("_user", _user._userid, "Должность", "").
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
          ttBusinessmen.userNameOpenAcct = _user._user-name.
          ttBusinessmen.userPostOpenAcct = GetXAttrValueEx("_user", _user._userid, "Должность", "").
        END.
        LEAVE.
      END.
    END.
       /* Если нет ни одного счета */
    IF cAcct = ""
    THEN DO:
      ttBusinessmen.userNameOpenAcct = "Без открытия счета".
      ttBusinessmen.userPostOpenAcct = "".
      userOpenAcct = "".
    END.

    /** Найдем сотрудника, заполнившего анкету в электронном виде */
       /* Если сотрудник не найден по счету или счет заводился в Бисквите */
    IF userOpenAcct = ? OR userOpenAcct = "" OR dAcct > DATE("27/07/2005")
    THEN DO:
      userOpenAcct = GetFirstHistoryUserid("cust-corp", STRING(cust-corp.cust-id)).
      FIND FIRST _user WHERE _user._userid = userOpenAcct NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttBusinessmen.userNameInput = _user._user-name.
        ttBusinessmen.userPostInput = GetXAttrValueEx("_user", _user._userid, "Должность", "").
      END.
    END.
    ELSE DO:
      ttBusinessmen.userNameInput = ttBusinessmen.userNameOpenAcct.
      ttBusinessmen.userPostInput = ttBusinessmen.userPostOpenAcct.
    END.

    /** Найдем сотрудника, утвердившего открытие счета. Это входной параметр процедуры. */
    IF cAcct = ""
    THEN DO:
      ttBusinessmen.userNameAssent = "Без открытия счета".
      ttBusinessmen.userPostAssent = "".
    END.
    ELSE DO:
      FIND FIRST _user WHERE _user._userid = userIdAssent NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttBusinessmen.userNameAssent = _user._user-name.
        ttBusinessmen.userPostAssent = GetXAttrValueEx("_user", _user._userid, "Должность", "").
      END.
    END.
    /** Найдем сотрудника, перенесшего анкету на бумажный носитель */
    FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
    IF AVAIL _user THEN DO:
      ttBusinessmen.userNamePrint = _user._user-name.
      ttBusinessmen.userPostPrint = GetXAttrValueEx("_user", _user._userid, "Должность", "").
    END.
    

        
/******************************************* Формирование печатной формы анкеты */
    
    str[1] = "1.1. Фамилия: " + PrintStringInfo(ttBusinessmen.lastName) + " Имя: " 
                + PrintStringInfo(ttBusinessmen.firstName) + " Отчество: " 
                + PrintStringInfo(ttBusinessmen.patronymic) + CHR(10) 
           + "1.2. Дата рождения: " + PrintDateInfo(ttBusinessmen.birthDate) + CHR(10)
           + "1.3. Место рождения: " + PrintStringInfo(ttBusinessmen.birthPlace) + CHR(10)
           + "1.4. Гражданство: " + PrintStringInfo(ttBusinessmen.nationality) + CHR(10)
           + "1.5. Документ, удостоверяющий личность: " + PrintStringInfo(ttBusinessmen.document) + CHR(10)
           + "1.6. Данные миграционной карты".
    
    IF ttBusinessmen.migrationCard = "" AND ttBusinessmen.visaSeries = "" THEN 
      str[1] = str[1] + ": " + PrintStringInfo("") + CHR(10).
    ELSE DO:
      str[1] = str[1] + "#tabНомер миграционной карты: " + PrintStringInfo(ttBusinessmen.migrationCard) + CHR(10)
                      + "Данные документа, подтверждающего право на пребывание (проживание) в РФ" + CHR(10)
                      + "#tabСерия: " + PrintStringInfo(ttBusinessmen.visaSeries) + CHR(10)
                      + "#tabНомер документа: " + PrintStringInfo(ttBusinessmen.visaNumber) + CHR(10)
                      + "#tabГражданство: " + PrintStringInfo(ttBusinessmen.visaNationality) + CHR(10)
                      + "#tabЦель визита: " + PrintStringInfo(ttBusinessmen.visaTarget) + CHR(10)
                      + "#tabСрок пребывания с " + PrintDateInfo(ttBusinessmen.visaPeriodBegin) 
                            + " до " + PrintDateInfo(ttBusinessmen.visaPeriodEnd) + CHR(10)
                      + "#tabСрок действия права пребывания с " + PrintDateInfo(ttBusinessmen.visaOrderBegin) 
                            + " до " + PrintDateInfo(ttBusinessmen.visaOrderEnd) + CHR(10).
    END.
    
    str[1] = str[1] + "1.7. Адрес места жительства (регистрации): " + 
                 PrintStringInfo(ttBusinessmen.addressOfLaw) + CHR(10)
           + "1.8. Адрес места пребывания (проживания): " + PrintStringInfo(ttBusinessmen.addressOfStay) + CHR(10)
           + "1.9. Почтовый адрес: " + PrintStringInfo(ttBusinessmen.addressOfPost) + CHR(10)
           + "1.10. ИНН: " + PrintStringInfo(ttBusinessmen.inn) + CHR(10)
           + "1.11. Отношение к иностранным публичным должностным лицам и связанным с ними лицам (нужное отметит):" + CHR(10)
           + "  ┌─────┐  Является иностранным публич-  ┌─────┐  Имеет отношение к иностранному"+ CHR(10)
           + "  │ " + (IF ttBusinessmen.isForeignBoss > "" THEN "Д А" ELSE "НЕТ") 
           + " │  ным должностным лицом         │ " + (IF ttBusinessmen.hasRelationToForeignBoss + ttBusinessmen.fromFamilyOfForeignBoss > "" THEN "Д А" ELSE "НЕТ") 
           + " │  публичному должностному лицу" + CHR(10)
           + "  └─────┘                                └─────┘" + CHR(10).

     IF (ttBusinessmen.hasRelationToForeignBoss > "") AND (NUM-ENTRIES(ttBusinessmen.hasRelationToForeignBoss, ";") = 4) THEN 
       DO:
         str[1] = str[1] 
             + "Фамилия, имя и (при наличии) отчество: " + PrintStringInfo(ENTRY(1,ttBusinessmen.hasRelationToForeignBoss,";")) + CHR(10)
             + "Занимаемая должность: " + PrintStringInfo(ENTRY(2, ttBusinessmen.hasRelationToForeignBoss, ";")) + CHR(10)
             + "Наименование Государства: " + PrintStringInfo(ENTRY(3,ttBusinessmen.hasRelationToForeignBoss,";")) + CHR(10)
             + "Степень родства или иное отношение: " + PrintStringInfo(ENTRY(4,ttBusinessmen.hasRelationToForeignBoss,";")) + CHR(10).
      END.
    ELSE IF (ttBusinessmen.fromFamilyOfForeignBoss > "") AND (NUM-ENTRIES(ttBusinessmen.fromFamilyOfForeignBoss, ";") = 4) THEN
      DO:
         str[1] = str[1] 
             + "Фамилия, имя и (при наличии) отчество: " + PrintStringInfo(ENTRY(1,ttBusinessmen.fromFamilyOfForeignBoss,";")) + CHR(10)
             + "Занимаемая должность: " + PrintStringInfo(ENTRY(2, ttBusinessmen.fromFamilyOfForeignBoss, ";")) + CHR(10)
             + "Наименование Государства: " + PrintStringInfo(ENTRY(3,ttBusinessmen.fromFamilyOfForeignBoss,";")) + CHR(10)
             + "Степень родства или иное отношение: " + PrintStringInfo(ENTRY(4,ttBusinessmen.fromFamilyOfForeignBoss,";")) + CHR(10).
      END.
/** Buryagin wrote but commented 
    ELSE
      DO:
        str[1] = str[1] 
        + "Неверный формат в одном из д.р. person.ОтнОкруж_ИПДЛ или person.СтепРодст_ИПДЛ. Нужно четыре строковых значения, разделенных точкой с запятой <;>" + CHR(10).
      END.
*/

    str[1] = str[1] + "1.12. Номера " + CHR(10) 
            + "#tabконтактных телефонов: " + PrintStringInfo(ttBusinessmen.tel) + CHR(10)
           + "#tabфаксов: " + PrintStringInfo(ttBusinessmen.fax) + CHR(10)
           + "1.13. Государственный регистрационный номер: " + PrintStringInfo(ttBusinessmen.ogrn) + CHR(10)
           + "1.14. Дата регистрации: " + PrintDateInfo(ttBusinessmen.registrationDate) + CHR(10)
           + "1.15. Место регистрации (город, область): " + PrintStringInfo(ttBusinessmen.registrationPlace) + CHR(10)
           + "1.16. Сведения о лицензии на право осуществления деятельности, подлежащей лицензированию: " + CHR(10)
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
           
     str[1] = str[1] 
            + "1.17. Наименования кредитных организаций, в которых клиент обслуживается (ранее обслуживался): " + PrintStringInfo(ttBusinessmen.otherBanks) + CHR(10)
            + "1.18. Сведения о деловой репутации клиента: " + PrintStringInfo(ttBusinessmen.businessImage) + CHR(10)
            + "1.19. Уровень степени риска: " + PrintStringInfo(ttBusinessmen.riskLevel) + CHR(10)
           + "1.20. Обоснование оценки степени риска: " + PrintStringInfo(ttBusinessmen.riskInfo) + CHR(10)
           + "1.21. Дата открытия первого банковского счета (вклада): " 
              + PrintDateInfo(ttBusinessmen.firstAcctOpenDate) + CHR(10)
           + "1.22. Дата заполнения Анкеты клиента: " + PrintDateInfo(ttBusinessmen.inputDate) + CHR(10)
           + "1.23. Дата обновления Анкеты клиента: " + PrintDateInfo(ttBusinessmen.modifDate) + CHR(10)
           + "1.24. Работник банка, открывший счет " + CHR(10)
              + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBusinessmen.userNameOpenAcct) + CHR(10)
               + "#tabДолжность: " + PrintStringInfo(ttBusinessmen.userPostOpenAcct) + CHR(10)
           + "1.25. Работник банка, утвердивший открытие счета" + CHR(10)
               + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBusinessmen.userNameAssent) + CHR(10)
              + "#tabДолжность: " + PrintStringInfo(ttBusinessmen.userPostAssent) + CHR(10)
           + "1.26. Работник банка, заполнивший Анкету клиента в электронном виде" + CHR(10)
              + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBusinessmen.userNameInput) + CHR(10)
              + "#tabДолжность: " + PrintStringInfo(ttBusinessmen.userPostInput) + CHR(10)
           + "1.27. Подпись уполномоченного работника Банка, перенесшего Анкету клиента, заполненную в электронном виде,"
               + " на бумажный носитель" + CHR(10)
               + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBusinessmen.userNamePrint) + CHR(10)
               + "#tabДолжность: " + PrintStringInfo(ttBusinessmen.userPostPrint) + CHR(10).
    
    
    {wordwrap.i &s=str &n=200 &l=80}
    
    {setdest.i}
    PUT UNFORMATTED /*SPACE(77) "ф. ФЛ-1" SKIP(1)*/
                    SPACE(10) "АНКЕТА КЛИЕНТА - ИНДИВИДУАЛЬНОГО ПРЕДПРИНИМАТЕЛЯ" SKIP(2).
    
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

