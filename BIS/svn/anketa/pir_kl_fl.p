{pirsavelog.p}

/** 
    ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007

    Формирование анкеты ФЛ.
    
    Бурягин Е.П., 11.05.2007 9:41
    
    <Как_запускается> : Из броузера ФЛ
    <Параметры запуска> : Строка в виде выражения <имя_параметра>=<значение_параметра>[,...]
                          Обрабатываемые параметры: СотрУтвердОткрСчета - код сотрудника чья фамилия и должность 1.17.
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
DEFINE VARIABLE userOpenAcct AS CHAR NO-UNDO.
DEFINE VARIABLE cAcct        AS CHAR NO-UNDO.
DEFINE VARIABLE dAcct        AS DATE NO-UNDO.
DEFINE VARIABLE cCntry       AS CHAR NO-UNDO.

{pir_xf_def3.i}


/******************************************* Реализация */

/** Разбор входного параметра */
userIdAssent = GetParamByNameAsChar(iParam, "СотрУтвердОткрСчета", "").


FOR EACH tmprecid NO-LOCK,
    FIRST person WHERE RECID(person) = tmprecid.id NO-LOCK
  :
/******************************************* Присвоение значений переменным и др. */

    CREATE ttPerson.
    ttPerson.lastName = person.name-last.
    ttPerson.firstName = ENTRY(1, person.first-names, " ").
    ttPerson.patronymic = (IF NUM-ENTRIES(person.first-names, " ") > 1 THEN ENTRY(2, person.first-names, " ") ELSE "").
    ttPerson.birthDate = person.birthday.
    ttPerson.birthPlace = GetXAttrValueEx("person", STRING(person.person-id), "BirthPlace", "").
    
    /** Найдем гражданство */
    FIND FIRST country WHERE country.country-id = person.country-id NO-LOCK NO-ERROR.
    IF AVAIL country THEN ttPerson.nationality = country.country-name.

    /** Найдем документ */
    FOR EACH cust-ident WHERE 
        cust-ident.cust-cat = "Ч" 
        AND 
        cust-ident.cust-id = person.person-id
        AND
        cust-ident.class-code = "p-cust-ident"
        NO-LOCK 
      :
        /*IF GetXAttrValueEx("cust-ident",
                     STRING(cust-ident.cust-code-type) + ',' +
                     STRING(cust-ident.cust-code) + ',' +
                     STRING(cust-ident.cust-type-num),
                     "class-code",
                     "") EQ "p-cust-ident"
        THEN*/ 
          ttPerson.document = GetCodeName("КодДокум", cust-ident.cust-code-type) + " "
              + cust-ident.cust-code + " выдан " + STRING(cust-ident.open-date, "99.99.9999")
              + " " + cust-ident.issue.
     END.
     
     ttPerson.migrationCard = GetXAttrValueEx("person", STRING(person.person-id), "МигрКарт", "").
     ttPerson.visa = GetCodeName("VisaType", GetXAttrValueEx("person", STRING(person.person-id), "VisaType", "")) 
         + " " + GetXAttrValueEx("person", STRING(person.person-id), "Visa", "").
     ttPerson.visaSeries = GetXAttrValueEx("person", STRING(person.person-id), "VisaNum", "").
     ttPerson.visaNumber = (IF NUM-ENTRIES(ttPerson.visaSeries, " ") > 1 THEN ENTRY(2, ttPerson.visaSeries, " ") ELSE "").
     ttPerson.visaSeries = ENTRY(1, ttPerson.visaSeries, " ").
    
    /** Найдем гражданство по визе */
    cCntry = GetXAttrValue("person", STRING(person.person-id), "country-id2").
    FIND FIRST country WHERE country.country-id = cCntry NO-LOCK NO-ERROR.
    IF AVAIL country THEN ttPerson.visaNationality = country.country-name.

    ttPerson.visaTarget = GetXAttrValueEx("person", STRING(person.person-id), "МигрЦельВизита", "").
    ttPerson.visaPeriodBegin = DATE(GetXAttrValueEx("person", STRING(person.person-id), "МигрПребывС", "")).
    ttPerson.visaPeriodEnd = DATE(GetXAttrValueEx("person", STRING(person.person-id), "МигрПребывПо", "")).
    ttPerson.visaOrderBegin = DATE(GetXAttrValueEx("person", STRING(person.person-id), "МигрПравПребС", "")).
    ttPerson.visaOrderEnd = DATE(GetXAttrValueEx("person", STRING(person.person-id), "МигрПравПребПо", "")).

/*
    ttPerson.addressOfLaw = DelDoubleChars(
          (IF person.address[1] = person.address[2] THEN person.address[1] ELSE person.address[1] + "," + person.address[2]),
          ","
    ).
    ttPerson.addressOfStay = DelDoubleChars(GetXAttrValueEx("person", STRING(person.person-id), "PlaceOfStay", ""), ",").
    IF ttPerson.addressOfStay = "" THEN ttPerson.addressOfStay = ttPerson.addressOfLaw.
*/
    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ч'
         AND cust-ident.cust-id        EQ person.person-id
         AND cust-ident.cust-code-type EQ 'АдрПроп'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttPerson.addressOfLaw = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ч'
         AND cust-ident.cust-id        EQ person.person-id
         AND cust-ident.cust-code-type EQ 'АдрФакт'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttPerson.addressOfStay = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    ttPerson.inn = person.inn.
    IF ttPerson.inn = "000000000000" OR ttPerson.inn = "0" THEN ttPerson.inn = "".
    
    ttPerson.hasRelationToForeignBoss = GetXAttrValueEx("person", STRING(person.person-id), "ОтнОкруж_ИПДЛ","").
    ttPerson.isForeignBoss = GetXAttrValueEx("person", STRING(person.person-id), "Статус_ИПДЛ","").
    ttPerson.fromFamilyOfForeignBoss = GetXAttrValueEx("person", STRING(person.person-id), "СтепРодст_ИПДЛ","").
    
    ttPerson.tel = TRIM(person.phone[1] + " " + person.phone[2]).
    ttPerson.fax = person.fax.
    
    ttPerson.riskLevel = GetXAttrValueEx("person", STRING(person.person-id), "РискОтмыв", "").
    
/*
    tmpStr = GetXAttrValueEx("person", STRING(person.person-id), "ОценкаРиска", "").
    ttPerson.riskInfo = GetCode("PirОценкаРиска", tmpStr).
    if ttPerson.riskInfo = ? then ttPerson.riskInfo = tmpStr.
*/
    tmpStr = GetXAttrValueEx("person", STRING(person.person-id), "ОценкаРиска", "").
    ttPerson.riskInfo = GetCode("PirОценкаРиска", tmpStr).
    /** если по коду tmpStr записи в классификаторе нет, то в том же классификаторе
       ищем значение с кодом из ttPerson.riskLevel */
    if ttPerson.riskInfo = ? and tmpStr = "" then 
      ttPerson.riskInfo = GetCode("PirОценкаРиска", ttPerson.riskLevel).
    /** если вообще ничего не сработало и значение не присвоено, то оно будет пустым */
    if ttPerson.riskInfo = ? then
      ttPerson.riskInfo = tmpStr.
    
    ttPerson.firstAcctOpenDate = DATE(GetXAttrValueEx("person", STRING(person.person-id), "FirstAccDate", "")).
    ttPerson.inputDate = ttPerson.firstAcctOpenDate.
    ttPerson.modifDate = GetLastHistoryDate("ФЛ", person.person-id, ttPerson.inputDate).

    /** Найдем сотрудника, открывшего счет  */
    cAcct = "".
    dAcct = DATE("01/01/2005").
    FOR EACH acct WHERE cust-cat = "Ч" AND cust-id = person.person-id 
                    AND contract = "Текущ" NO-LOCK BY open-date:
      cAcct = acct.acct.
      dAcct = acct.open-date.
      userOpenAcct = GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "СотрОткрСч", acct.user-id).
      FIND FIRST _user WHERE _user._userid = userOpenAcct NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttPerson.userNameOpenAcct = _user._user-name.
        ttPerson.userPostOpenAcct = GetXAttrValueEx("_user", _user._userid, "Должность", "").
      END.
      LEAVE.
    END.
       /* Если нет текущего счета */
    IF cAcct = ""
    THEN DO:
      FOR EACH acct WHERE cust-cat = "Ч" AND cust-id = person.person-id 
                    NO-LOCK BY open-date:
        cAcct = acct.acct.
        dAcct = acct.open-date.
        userOpenAcct = GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "СотрОткрСч", acct.user-id).
        FIND FIRST _user WHERE _user._userid = userOpenAcct NO-LOCK NO-ERROR.
        IF AVAIL _user THEN DO:
          ttPerson.userNameOpenAcct = _user._user-name.
          ttPerson.userPostOpenAcct = GetXAttrValueEx("_user", _user._userid, "Должность", "").
        END.
        LEAVE.
      END.
    END.
       /* Если нет ни одного счета */
    IF cAcct = ""
    THEN DO:
      ttPerson.userNameOpenAcct = "Без открытия счета".
      ttPerson.userPostOpenAcct = "".
      userOpenAcct = "".
    END.

    /** Найдем сотрудника, заполнившего анкету в электронном виде */
       /* Если сотрудник не найден по счету или счет заводился в Бисквите */
    IF userOpenAcct = ? OR userOpenAcct = "" OR dAcct > DATE("27/07/2005")
    THEN DO:
      userOpenAcct = GetFirstHistoryUserid("person", STRING(person.person-id)).
      FIND FIRST _user WHERE _user._userid = userOpenAcct NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttPerson.userNameInput = _user._user-name.
        ttPerson.userPostInput = GetXAttrValueEx("_user", _user._userid, "Должность", "").
      END.
    END.
    ELSE DO:
      ttPerson.userNameInput = ttPerson.userNameOpenAcct.
      ttPerson.userPostInput = ttPerson.userPostOpenAcct.
    END.

    /** Найдем сотрудника, утвердившего открытие счета. Это входной параметр процедуры. */
    IF cAcct = ""
    THEN DO:
      ttPerson.userNameAssent = "Без открытия счета".
      ttPerson.userPostAssent = "".
    END.
    ELSE DO:
      FIND FIRST _user WHERE _user._userid = userIdAssent NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttPerson.userNameAssent = _user._user-name.
        ttPerson.userPostAssent = GetXAttrValueEx("_user", _user._userid, "Должность", "").
      END.
    END.
    /** Найдем сотрудника, перенесшего анкету на бумажный носитель */
    FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
    IF AVAIL _user THEN DO:
      ttPerson.userNamePrint = _user._user-name.
      ttPerson.userPostPrint = GetXAttrValueEx("_user", _user._userid, "Должность", "").
    END.

/******************************************* Формирование печатной формы анкеты */

    str[1] = "1.1. Фамилия: " + PrintStringInfo(ttPerson.lastName) + " Имя: " 
                + PrintStringInfo(ttPerson.firstName) + " Отчество: " 
                + PrintStringInfo(ttPerson.patronymic) + CHR(10) 
           + "1.2. Дата рождения: " + PrintDateInfo(ttPerson.birthDate) + CHR(10)
           + "1.3. Место рождения: " + PrintStringInfo(ttPerson.birthPlace) + CHR(10)
           + "1.4. Гражданство: " + PrintStringInfo(ttPerson.nationality) + CHR(10)
           + "1.5. Документ, удостоверяющий личность: " + PrintStringInfo(ttPerson.document) + CHR(10)
           + "1.6. Данные миграционной карты".
    
    IF ttPerson.migrationCard = "" AND ttPerson.visaSeries = "" THEN 
      str[1] = str[1] + ": " + PrintStringInfo("") + CHR(10).
    ELSE DO:
      str[1] = str[1] + "#tabНомер миграционной карты: " + PrintStringInfo(ttPerson.migrationCard) + CHR(10)
                      + "Данные документа, подтверждающего право на пребывание (проживание) в РФ" + CHR(10)
                      + "#tabСерия: " + PrintStringInfo(ttPerson.visaSeries) + CHR(10)
                      + "#tabНомер документа: " + PrintStringInfo(ttPerson.visaNumber) + CHR(10)
                      + "#tabГражданство: " + PrintStringInfo(ttPerson.visaNationality) + CHR(10)
                      + "#tabЦель визита: " + PrintStringInfo(ttPerson.visaTarget) + CHR(10)
                      + "#tabСрок пребывания с " + PrintDateInfo(ttPerson.visaPeriodBegin) 
                            + " до " + PrintDateInfo(ttPerson.visaPeriodEnd) + CHR(10)
                      + "#tabСрок действия права пребывания с " + PrintDateInfo(ttPerson.visaOrderBegin) 
                            + " до " + PrintDateInfo(ttPerson.visaOrderEnd) + CHR(10).
    END.
    
    str[1] = str[1] + "1.7. Адрес места жительства (регистрации): " + 
                 PrintStringInfo(ttPerson.addressOfLaw) + CHR(10)
           + "1.8. Адрес места пребывания (проживания): " + PrintStringInfo(ttPerson.addressOfStay) + CHR(10)
           + "1.9. ИНН: " + PrintStringInfo(ttPerson.inn) + CHR(10)
           + "1.10. Отношение к иностранным публичным должностным лицам и связанным с ними лицам (нужное отметит):" + CHR(10)
           + "  ┌─────┐  Является иностранным публич-  ┌─────┐  Имеет отношение к иностранному"+ CHR(10)
           + "  │ " + (IF ttPerson.isForeignBoss > "" THEN "Д А" ELSE "НЕТ") 
           + " │  ным должностным лицом         │ " + (IF ttPerson.hasRelationToForeignBoss + ttPerson.fromFamilyOfForeignBoss > "" THEN "Д А" ELSE "НЕТ") 
           + " │  публичному должностному лицу" + CHR(10)
           + "  └─────┘                                └─────┘" + CHR(10).

     IF (ttPerson.hasRelationToForeignBoss > "") AND (NUM-ENTRIES(ttPerson.hasRelationToForeignBoss, ";") = 4) THEN 
       DO:
         str[1] = str[1] 
             + "Фамилия, имя и (при наличии) отчество: " + PrintStringInfo(ENTRY(1,ttPerson.hasRelationToForeignBoss,";")) + CHR(10)
             + "Занимаемая должность: " + PrintStringInfo(ENTRY(2, ttPerson.hasRelationToForeignBoss, ";")) + CHR(10)
             + "Наименование Государства: " + PrintStringInfo(ENTRY(3,ttPerson.hasRelationToForeignBoss,";")) + CHR(10)
             + "Степень родства или иное отношение: " + PrintStringInfo(ENTRY(4,ttPerson.hasRelationToForeignBoss,";")) + CHR(10).
      END.
    ELSE IF (ttPerson.fromFamilyOfForeignBoss > "") AND (NUM-ENTRIES(ttPerson.fromFamilyOfForeignBoss, ";") = 4) THEN
      DO:
         str[1] = str[1] 
             + "Фамилия, имя и (при наличии) отчество: " + PrintStringInfo(ENTRY(1,ttPerson.fromFamilyOfForeignBoss,";")) + CHR(10)
             + "Занимаемая должность: " + PrintStringInfo(ENTRY(2, ttPerson.fromFamilyOfForeignBoss, ";")) + CHR(10)
             + "Наименование Государства: " + PrintStringInfo(ENTRY(3,ttPerson.fromFamilyOfForeignBoss,";")) + CHR(10)
             + "Степень родства или иное отношение: " + PrintStringInfo(ENTRY(4,ttPerson.fromFamilyOfForeignBoss,";")) + CHR(10).
      END.
/** Buryagin wrote but commented 
    ELSE
      DO:
        str[1] = str[1] 
        + "Неверный формат в одном из д.р. person.ОтнОкруж_ИПДЛ или person.СтепРодст_ИПДЛ. Нужно четыре строковых значения, разделенных точкой с запятой <;>" + CHR(10).
      END.
*/
    
    str[1] = str[1] + "1.11. Номера " + CHR(10) 
            + "#tabконтактных телефонов: " + PrintStringInfo(ttPerson.tel) + CHR(10)
           + "#tabфаксов: " + PrintStringInfo(ttPerson.fax) + CHR(10)
           + "1.12. Уровень степени риска: " + PrintStringInfo(ttPerson.riskLevel) + CHR(10)
           + "1.13. Обоснование оценки степени риска: " + PrintStringInfo(ttPerson.riskInfo) + CHR(10)
           + "1.14. Дата открытия первого банковского счета (вклада): " 
              + PrintDateInfo(ttPerson.firstAcctOpenDate) + CHR(10)
           + "1.15. Дата заполнения Анкеты клиента: " + PrintDateInfo(ttPerson.inputDate) + CHR(10)
           + "1.16. Дата обновления Анкеты клиента: " + PrintDateInfo(ttPerson.modifDate) + CHR(10)
           + "1.17. Работник банка, открывший счет " + CHR(10)
              + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttPerson.userNameOpenAcct) + CHR(10)
               + "#tabДолжность: " + PrintStringInfo(ttPerson.userPostOpenAcct) + CHR(10)
           + "1.18. Работник банка, утвердивший открытие счета" + CHR(10)
               + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttPerson.userNameAssent) + CHR(10)
              + "#tabДолжность: " + PrintStringInfo(ttPerson.userPostAssent) + CHR(10)
           + "1.19. Работник банка, заполнивший Анкету клиента в электронном виде" + CHR(10)
              + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttPerson.userNameInput) + CHR(10)
              + "#tabДолжность: " + PrintStringInfo(ttPerson.userPostInput) + CHR(10)
           + "1.20. Подпись уполномоченного работника Банка, перенесшего Анкету клиента, заполненную в электронном виде,"
               + " на бумажный носитель" + CHR(10)
               + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttPerson.userNamePrint) + CHR(10)
               + "#tabДолжность: " + PrintStringInfo(ttPerson.userPostPrint) + CHR(10).
    
    
    {wordwrap.i &s=str &n=200 &l=80}
    
    {setdest.i}
    PUT UNFORMATTED SPACE(77) "ф. ФЛ-1" SKIP(1)
                    SPACE(30) "АНКЕТА КЛИЕНТА - ФИЗИЧЕСКОГО ЛИЦА" SKIP(2).
    
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

