/** 
    ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007

    Формирует анкету выгодоприобретателя - индивидуального предпринимателя.
    
    Бурягин Е.П., 15.05.2007 14:18
    
    <Как_запускается> : Запускается из броузера клиентов ЮЛ.
    <Параметры запуска> : Строка в виде выражения <имя_параметра>=<значение_параметра>[,...]
                          Обрабатываемые параметры: СотрУтвердОткрСчета - код сотрудника чья фамилия и должность 1.23.
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

{pir_xf_def.i}


/******************************************* Реализация */

/** Разбор входного параметра */
userIdAssent = GetParamByNameAsChar(iParam, "СотрУтвердОткрСчета", "").


FOR EACH tmprecid NO-LOCK,
    FIRST cust-corp WHERE RECID(cust-corp) = tmprecid.id NO-LOCK
  :
/******************************************* Присвоение значений переменным и др. */

    CREATE ttBeneficiaryBusinessmen.
    ttBeneficiaryBusinessmen.benefitInfo = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "СведВыгДрЛица", "").
    ttBeneficiaryBusinessmen.opf = GetCodeName("КодПредп", GetCodeVal("КодПредп", cust-corp.cust-stat)).
    ttBeneficiaryBusinessmen.lastName = TRIM(ENTRY(1, cust-corp.name-corp, " ")).
    ttBeneficiaryBusinessmen.firstName = (IF NUM-ENTRIES(cust-corp.name-corp, " ") > 1 THEN ENTRY(2, cust-corp.name-corp, " ") ELSE "").
    ttBeneficiaryBusinessmen.patronymic = (IF NUM-ENTRIES(cust-corp.name-corp, " ") > 2 THEN ENTRY(3, cust-corp.name-corp, " ") ELSE "").
    ttBeneficiaryBusinessmen.birthDate = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "BirthDay", "")).
    ttBeneficiaryBusinessmen.birthPlace = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "BirthPlace", "").
    
    /** Найдем гражданство */
    FIND FIRST country WHERE country.country-id = cust-corp.country-id NO-LOCK NO-ERROR.
    IF AVAIL country THEN ttBeneficiaryBusinessmen.nationality = country.country-name.
    
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
    ttBeneficiaryBusinessmen.document = GetCodeName("КодДокум", 
                        GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "document-id", "")) 
                        + " "  + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "document", "")
                        + " выдан " + STRING(DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "Document4Date_vid", "")), "99.99.9999")
                        + " " + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "issue", "").
     
     ttBeneficiaryBusinessmen.migrationCard = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "МигрКарт", "").
     ttBeneficiaryBusinessmen.visa = GetCodeName("VisaType", GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "VisaType", "")) 
         + " " + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "Visa", "").
     ttBeneficiaryBusinessmen.visaSeries = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "VisaNum", "").
     ttBeneficiaryBusinessmen.visaNumber = (IF NUM-ENTRIES(ttBeneficiaryBusinessmen.visaSeries, " ") > 1 THEN ENTRY(2, ttBeneficiaryBusinessmen.visaSeries, " ") ELSE "").
     ttBeneficiaryBusinessmen.visaSeries = ENTRY(1, ttBeneficiaryBusinessmen.visaSeries, " ").
    
    /** Найдем гражданство по визе */
    FIND FIRST country WHERE country.country-id = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "country-id2", "") NO-LOCK NO-ERROR.
    IF AVAIL country THEN ttBeneficiaryBusinessmen.visaNationality = country.country-name.
    
    ttBeneficiaryBusinessmen.visaTarget = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "МигрЦельВизита", "").
    ttBeneficiaryBusinessmen.visaPeriodBegin = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "МигрПребывС", "")).
    ttBeneficiaryBusinessmen.visaPeriodEnd = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "МигрПребывПо", "")).
    ttBeneficiaryBusinessmen.visaOrderBegin = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "МигрПравПребС", "")).
    ttBeneficiaryBusinessmen.visaOrderEnd = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "МигрПравПребПо", "")).

/*
    ttBeneficiaryBusinessmen.addressOfLaw = DelDoubleChars(
        (IF cust-corp.addr-of-low[1] <> cust-corp.addr-of-low[2] 
         THEN cust-corp.addr-of-low[1] + " " + addr-of-low[2] 
         ELSE cust-corp.addr-of-low[1]
        ),
    "," ).
    ttBeneficiaryBusinessmen.addressOfStay = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "АдресП", "").
    IF ttBeneficiaryBusinessmen.addressOfStay = "" THEN ttBeneficiaryBusinessmen.addressOfStay = ttBeneficiaryBusinessmen.addressOfLaw.
    ttBeneficiaryBusinessmen.addressOfPost = ttBeneficiaryBusinessmen.addressOfStay.
*/
    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ю'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ 'АдрЮр'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBeneficiaryBusinessmen.addressOfLaw = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ю'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ 'АдрФакт'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBeneficiaryBusinessmen.addressOfStay = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ю'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ 'АдрПочт'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBeneficiaryBusinessmen.addressOfPost = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    ttBeneficiaryBusinessmen.ogrn = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОГРН", "").
    ttBeneficiaryBusinessmen.registrationDate = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "RegDate", "")).
    ttBeneficiaryBusinessmen.registrationPlace = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "RegPlace", "").
    
    ttBeneficiaryBusinessmen.inn = cust-corp.inn.
    IF ttBeneficiaryBusinessmen.inn = "000000000000" OR ttBeneficiaryBusinessmen.inn = "0" THEN ttBeneficiaryBusinessmen.inn = "".
    ttBeneficiaryBusinessmen.tel = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "tel", "").
    ttBeneficiaryBusinessmen.fax = cust-corp.fax.
    
    ttBeneficiaryBusinessmen.riskLevel = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "РискОтмыв", "").
    
/*
    tmpStr = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОценкаРиска", "").
    ttBeneficiaryBusinessmen.riskInfo = GetCode("PirОценкаРиска", tmpStr).
    if ttBeneficiaryBusinessmen.riskInfo = ? then ttBeneficiaryBusinessmen.riskInfo = tmpStr.
*/

    tmpStr = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОценкаРиска", "").
    ttBeneficiaryBusinessmen.riskInfo = GetCode("PirОценкаРиска", tmpStr).
    /** если по коду tmpStr записи в классификаторе нет, то в том же классификаторе
       ищем значение с кодом из ttBeneficiaryBusinessmen.riskLevel */
    if ttBeneficiaryBusinessmen.riskInfo = ? and tmpStr = "" then 
      ttBeneficiaryBusinessmen.riskInfo = GetCode("PirОценкаРиска", ttBeneficiaryBusinessmen.riskLevel).
    /** если вообще ничего не сработало и значение не присвоено, то оно будет пустым */
    if ttBeneficiaryBusinessmen.riskInfo = ? then
      ttBeneficiaryBusinessmen.riskInfo = tmpStr.
/*
    ttBeneficiaryBusinessmen.firstAcctOpenDate = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "FirstAccDate", "")).
    ttBeneficiaryBusinessmen.inputDate = ttBeneficiaryBusinessmen.firstAcctOpenDate.
    ttBeneficiaryBusinessmen.modifDate = GetLastHistoryDate("cust-corp", STRING(cust-corp.cust-id)).
*/
    /** Найдем сотрудника, заполнившего анкету в электронном виде */
      tmpStr = GetFirstHistoryUserid("cust-corp", STRING(cust-corp.cust-id)).
      FIND FIRST _user WHERE _user._userid = tmpStr  NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttBeneficiaryBusinessmen.userNameInput = _user._user-name.
        ttBeneficiaryBusinessmen.userPostInput = GetXAttrValueEx("_user", _user._userid, "Должность", "").
      END.

    /** Найдем сотрудника, утвердившего открытие счета. Это входной параметр процедуры. */
    FIND FIRST _user WHERE _user._userid = userIdAssent NO-LOCK NO-ERROR.
    IF AVAIL _user THEN DO:
      ttBeneficiaryBusinessmen.userNameAssent = _user._user-name.
      ttBeneficiaryBusinessmen.userPostAssent = GetXAttrValueEx("_user", _user._userid, "Должность", "").
    END.
    /** Найдем сотрудника, перенесшего анкету на бумажный носитель */
    FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
    IF AVAIL _user THEN DO:
      ttBeneficiaryBusinessmen.userNamePrint = _user._user-name.
      ttBeneficiaryBusinessmen.userPostPrint = GetXAttrValueEx("_user", _user._userid, "Должность", "").
    END.
    

        
/******************************************* Формирование печатной формы анкеты */
    
    str[1] = "1.1. Сведения об основаниях, свидетельствующих о том, что клиент действует к выгоде лица при проведении банковских операций и иных сделок: "
              + PrintStringInfo(ttBeneficiaryBusinessmen.benefitInfo) + CHR(10)
           + "1.2. Фамилия: " + PrintStringInfo(ttBeneficiaryBusinessmen.lastName) + " Имя: " 
                + PrintStringInfo(ttBeneficiaryBusinessmen.firstName) + " Отчество: " 
                + PrintStringInfo(ttBeneficiaryBusinessmen.patronymic) + CHR(10) 
           + "1.3. Дата рождения: " + PrintDateInfo(ttBeneficiaryBusinessmen.birthDate) + CHR(10)
           + "1.4. Место рождения: " + PrintStringInfo(ttBeneficiaryBusinessmen.birthPlace) + CHR(10)
           + "1.5. Гражданство: " + PrintStringInfo(ttBeneficiaryBusinessmen.nationality) + CHR(10)
           + "1.6. Документ, удостоверяющий личность: " + PrintStringInfo(ttBeneficiaryBusinessmen.document) + CHR(10)
           + "1.7. Данные миграционной карты".
    
    IF ttBeneficiaryBusinessmen.migrationCard = "" AND ttBeneficiaryBusinessmen.visaSeries = "" THEN 
      str[1] = str[1] + ": " + PrintStringInfo("") + CHR(10).
    ELSE DO:
      str[1] = str[1] + "#tabНомер миграционной карты: " + PrintStringInfo(ttBeneficiaryBusinessmen.migrationCard) + CHR(10)
                      + "Данные документа, подтверждающего право на пребывание (проживание) в РФ" + CHR(10)
                      + "#tabСерия: " + PrintStringInfo(ttBeneficiaryBusinessmen.visaSeries) + CHR(10)
                      + "#tabНомер документа: " + PrintStringInfo(ttBeneficiaryBusinessmen.visaNumber) + CHR(10)
                      + "#tabГражданство: " + PrintStringInfo(ttBeneficiaryBusinessmen.visaNationality) + CHR(10)
                      + "#tabЦель визита: " + PrintStringInfo(ttBeneficiaryBusinessmen.visaTarget) + CHR(10)
                      + "#tabСрок пребывания с " + PrintDateInfo(ttBeneficiaryBusinessmen.visaPeriodBegin) 
                            + " до " + PrintDateInfo(ttBeneficiaryBusinessmen.visaPeriodEnd) + CHR(10)
                      + "#tabСрок действия права пребывания с " + PrintDateInfo(ttBeneficiaryBusinessmen.visaOrderBegin) 
                            + " до " + PrintDateInfo(ttBeneficiaryBusinessmen.visaOrderEnd) + CHR(10).
    END.
    
    str[1] = str[1] + "1.8. Адрес места жительства (регистрации): " + 
                 PrintStringInfo(ttBeneficiaryBusinessmen.addressOfLaw) + CHR(10)
           + "1.9. Адрес места пребывания (проживания): " + PrintStringInfo(ttBeneficiaryBusinessmen.addressOfStay) + CHR(10)
           + "1.10. ИНН: " + PrintStringInfo(ttBeneficiaryBusinessmen.inn) + CHR(10)
           + "1.11. Номера " + CHR(10) 
            + "#tabконтактных телефонов: " + PrintStringInfo(ttBeneficiaryBusinessmen.tel) + CHR(10)
           + "#tabфаксов: " + PrintStringInfo(ttBeneficiaryBusinessmen.fax) + CHR(10)
           + "1.12. Организационно-правовая форма: " + PrintStringInfo(ttBeneficiaryBusinessmen.opf) + CHR(10)
           + "1.13. Государственный регистрационный номер: " + PrintStringInfo(ttBeneficiaryBusinessmen.ogrn) + CHR(10)
           + "1.14. Дата регистрации: " + PrintDateInfo(ttBeneficiaryBusinessmen.registrationDate) + CHR(10)
           + "1.15. Место регистрации (город, область): " + PrintStringInfo(ttBeneficiaryBusinessmen.registrationPlace) + CHR(10)
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
           
     str[1] = str[1] + "1.17. Почтовый адрес: " + PrintStringInfo(ttBeneficiaryBusinessmen.addressOfPost) + CHR(10)
            /*
            + "1.18. Уровень степени риска: " + PrintStringInfo(ttBeneficiaryBusinessmen.riskLevel) + CHR(10)
           + "1.19. Обоснование оценки степени риска: " + PrintStringInfo(ttBeneficiaryBusinessmen.riskInfo) + CHR(10)
           + "1.20. Дата открытия первого банковского счета (вклада): " 
              + PrintDateInfo(ttBeneficiaryBusinessmen.firstAcctOpenDate) + CHR(10)
           + "1.21. Дата заполнения Анкеты клиента: " + PrintDateInfo(ttBeneficiaryBusinessmen.inputDate) + CHR(10)
           + "1.22. Дата обновления Анкеты клиента: " + PrintDateInfo(ttBeneficiaryBusinessmen.modifDate) + CHR(10)
           + "1.23. Работник банка, открывший счет " + CHR(10)
              + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBeneficiaryBusinessmen.userNameOpenAcct) + CHR(10)
               + "#tabДолжность: " + PrintStringInfo(ttBeneficiaryBusinessmen.userPostOpenAcct) + CHR(10)
           + "1.24. Работник банка, утвердивший открытие счета" + CHR(10)
               + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBeneficiaryBusinessmen.userNameAssent) + CHR(10)
              + "#tabДолжность: " + PrintStringInfo(ttBeneficiaryBusinessmen.userPostAssent) + CHR(10) 
           */
           + "1.18. Работник банка, заполнивший Анкету клиента в электронном виде" + CHR(10)
              + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBeneficiaryBusinessmen.userNameInput) + CHR(10)
              + "#tabДолжность: " + PrintStringInfo(ttBeneficiaryBusinessmen.userPostInput) + CHR(10)
           + "1.19. Подпись уполномоченного работника Банка, перенесшего Анкету клиента, заполненную в электронном виде,"
               + " на бумажный носитель" + CHR(10)
               + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBeneficiaryBusinessmen.userNamePrint) + CHR(10)
               + "#tabДолжность: " + PrintStringInfo(ttBeneficiaryBusinessmen.userPostPrint) + CHR(10).
    
    
    {wordwrap.i &s=str &n=200 &l=80}
    
    {setdest.i}
    PUT UNFORMATTED /*SPACE(77) "ф. ФЛ-1" SKIP(1)*/
                    SPACE(10) "АНКЕТА ВЫГОДОПРИОБРЕТАТЕЛЯ - ИНДИВИДУАЛЬНОГО ПРЕДПРИНИМАТЕЛЯ" SKIP(2).
    
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



