{pirsavelog.p}

/** 
    ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007

    Формирует анкету выгодоприобретателя - физического лица.
    
    Бурягин Е.П., 15.05.2007 10:46
    
    <Как_запускается> : Запускается из картотеки клиентов ФЛ.
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

{pir_xf_def.i}
DEFINE VARIABLE cCntry       AS CHAR NO-UNDO.

/******************************************* Реализация */


FOR EACH tmprecid NO-LOCK,
    FIRST person WHERE RECID(person) = tmprecid.id NO-LOCK
  :
/******************************************* Присвоение значений переменным и др. */

    CREATE ttBeneficiaryPers.
    ttBeneficiaryPers.benefitInfo = GetXAttrValueEx("person", STRING(person.person-id), "СведВыгДрЛица", "").
    ttBeneficiaryPers.lastName = person.name-last.
    ttBeneficiaryPers.firstName = ENTRY(1, person.first-names, " ").
    ttBeneficiaryPers.patronymic = (IF NUM-ENTRIES(person.first-names, " ") > 1 THEN ENTRY(2, person.first-names, " ") ELSE "").
    ttBeneficiaryPers.birthDate = person.birthday.
    ttBeneficiaryPers.birthPlace = GetXAttrValueEx("person", STRING(person.person-id), "BirthPlace", "").
    
    /** Найдем гражданство */
    FIND FIRST country WHERE country.country-id = person.country-id NO-LOCK NO-ERROR.
    IF AVAIL country THEN ttBeneficiaryPers.nationality = country.country-name.
    
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
          ttBeneficiaryPers.document = GetCodeName("КодДокум", cust-ident.cust-code-type) + " "
              + cust-ident.cust-code + " выдан " + STRING(cust-ident.open-date, "99.99.9999")
              + " " + cust-ident.issue.
     END.
     
     ttBeneficiaryPers.migrationCard = GetXAttrValueEx("person", STRING(person.person-id), "МигрКарт", "").
     ttBeneficiaryPers.visa = GetCodeName("VisaType", GetXAttrValueEx("person", STRING(person.person-id), "VisaType", "")) 
         + " " + GetXAttrValueEx("person", STRING(person.person-id), "Visa", "").
     ttBeneficiaryPers.visaSeries = GetXAttrValueEx("person", STRING(person.person-id), "VisaNum", "").
     ttBeneficiaryPers.visaNumber = (IF NUM-ENTRIES(ttBeneficiaryPers.visaSeries, " ") > 1 THEN ENTRY(2, ttBeneficiaryPers.visaSeries, " ") ELSE "").
     ttBeneficiaryPers.visaSeries = ENTRY(1, ttBeneficiaryPers.visaSeries, " ").
    
    /** Найдем гражданство по визе */
    cCntry = GetXAttrValue("person", STRING(person.person-id), "country-id2").
    FIND FIRST country WHERE country.country-id = cCntry NO-LOCK NO-ERROR.
    IF AVAIL country THEN ttBeneficiaryPers.visaNationality = country.country-name.
    
    ttBeneficiaryPers.visaTarget = GetXAttrValueEx("person", STRING(person.person-id), "МигрЦельВизита", "").
    ttBeneficiaryPers.visaPeriodBegin = DATE(GetXAttrValueEx("person", STRING(person.person-id), "МигрПребывС", "")).
    ttBeneficiaryPers.visaPeriodEnd = DATE(GetXAttrValueEx("person", STRING(person.person-id), "МигрПребывПо", "")).
    ttBeneficiaryPers.visaOrderBegin = DATE(GetXAttrValueEx("person", STRING(person.person-id), "МигрПравПребС", "")).
    ttBeneficiaryPers.visaOrderEnd = DATE(GetXAttrValueEx("person", STRING(person.person-id), "МигрПравПребПо", "")).

/*
    ttBeneficiaryPers.addressOfLaw = DelDoubleChars(
          (IF person.address[1] = person.address[2] THEN person.address[1] ELSE person.address[1] + "," + person.address[2]),
          ","
    ).
    ttBeneficiaryPers.addressOfStay = DelDoubleChars(GetXAttrValueEx("person", STRING(person.person-id), "PlaceOfStay", ""), ",").
    IF ttBeneficiaryPers.addressOfStay = "" THEN ttBeneficiaryPers.addressOfStay = ttBeneficiaryPers.addressOfLaw.
*/
    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ч'
         AND cust-ident.cust-id        EQ person.person-id
         AND cust-ident.cust-code-type EQ 'АдрПроп'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBeneficiaryPers.addressOfLaw = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE ?.

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ч'
         AND cust-ident.cust-id        EQ person.person-id
         AND cust-ident.cust-code-type EQ 'АдрФакт'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBeneficiaryPers.addressOfStay = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE ?.

    ttBeneficiaryPers.inn = person.inn.
    IF ttBeneficiaryPers.inn = "000000000000" OR ttBeneficiaryPers.inn = "0" THEN ttBeneficiaryPers.inn = "".
    ttBeneficiaryPers.tel = TRIM(person.phone[1] + " " + person.phone[2]).
    ttBeneficiaryPers.fax = person.fax.
    
    /** Найдем сотрудника, заполнившего анкету в электронном виде */
    tmpStr = GetFirstHistoryUserid("person", STRING(person.person-id)).
    FIND FIRST _user WHERE _user._userid = tmpStr  NO-LOCK NO-ERROR.
    IF AVAIL _user THEN DO:
      ttBeneficiaryPers.userNameInput = _user._user-name.
      ttBeneficiaryPers.userPostInput = GetXAttrValueEx("_user", _user._userid, "Должность", "").
    END.
    /** Найдем сотрудника, перенесшего анкету на бумажный носитель */
    FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
    IF AVAIL _user THEN DO:
      ttBeneficiaryPers.userNamePrint = _user._user-name.
      ttBeneficiaryPers.userPostPrint = GetXAttrValueEx("_user", _user._userid, "Должность", "").
    END.
    

        
/******************************************* Формирование печатной формы анкеты */
    
    str[1] = "1.1. Сведения об основаниях, свидетельствующих о том, что клиент действует к выгоде лица при проведении банковских операций и иных сделок: " 
              + PrintStringInfo(ttBeneficiaryPers.benefitInfo) + CHR(10)
           + "1.2. Фамилия: " + PrintStringInfo(ttBeneficiaryPers.lastName) + " Имя: " 
                + PrintStringInfo(ttBeneficiaryPers.firstName) + " Отчество: " 
                + PrintStringInfo(ttBeneficiaryPers.patronymic) + CHR(10) 
           + "1.3. Дата рождения: " + PrintDateInfo(ttBeneficiaryPers.birthDate) + CHR(10)
           + "1.4. Место рождения: " + PrintStringInfo(ttBeneficiaryPers.birthPlace) + CHR(10)
           + "1.5. Гражданство: " + PrintStringInfo(ttBeneficiaryPers.nationality) + CHR(10)
           + "1.6. Документ, удостоверяющий личность: " + PrintStringInfo(ttBeneficiaryPers.document) + CHR(10)
           + "1.7. Данные миграционной карты".
    
    IF ttBeneficiaryPers.migrationCard = "" AND ttBeneficiaryPers.visaSeries = "" THEN 
      str[1] = str[1] + ": " + PrintStringInfo("") + CHR(10).
    ELSE DO:
      str[1] = str[1] + "#tabНомер миграционной карты: " + PrintStringInfo(ttBeneficiaryPers.migrationCard) + CHR(10)
                      + "Данные документа, подтверждающего право на пребывание (проживание) в РФ" + CHR(10)
                      + "#tabСерия: " + PrintStringInfo(ttBeneficiaryPers.visaSeries) + CHR(10)
                      + "#tabНомер документа: " + PrintStringInfo(ttBeneficiaryPers.visaNumber) + CHR(10)
                      + "#tabГражданство: " + PrintStringInfo(ttBeneficiaryPers.visaNationality) + CHR(10)
                      + "#tabЦель визита: " + PrintStringInfo(ttBeneficiaryPers.visaTarget) + CHR(10)
                      + "#tabСрок пребывания с " + PrintDateInfo(ttBeneficiaryPers.visaPeriodBegin) 
                            + " до " + PrintDateInfo(ttBeneficiaryPers.visaPeriodEnd) + CHR(10)
                      + "#tabСрок действия права пребывания с " + PrintDateInfo(ttBeneficiaryPers.visaOrderBegin) 
                            + " до " + PrintDateInfo(ttBeneficiaryPers.visaOrderEnd) + CHR(10).
    END.
    
    str[1] = str[1] + "1.8. Адрес места жительства (регистрации): " + 
                 PrintStringInfo(ttBeneficiaryPers.addressOfLaw) + CHR(10)
           + "1.9. Адрес места пребывания (проживания): " + PrintStringInfo(ttBeneficiaryPers.addressOfStay) + CHR(10)
           + "1.10. ИНН: " + PrintStringInfo(ttBeneficiaryPers.inn) + CHR(10)
           + "1.11. Номера " + CHR(10) 
            + "#tabконтактных телефонов: " + PrintStringInfo(ttBeneficiaryPers.tel) + CHR(10)
           + "#tabфаксов: " + PrintStringInfo(ttBeneficiaryPers.fax) + CHR(10)
           + "1.12. Работник банка, заполнивший Анкету выгодоприобретателя в электронном виде" + CHR(10)
              + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBeneficiaryPers.userNameInput) + CHR(10)
              + "#tabДолжность: " + PrintStringInfo(ttBeneficiaryPers.userPostInput) + CHR(10)
           + "1.13. Подпись уполномоченного работника Банка, перенесшего Анкету выгодоприобретателя, заполненную в электронном виде,"
               + " на бумажный носитель" + CHR(10)
               + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBeneficiaryPers.userNamePrint) + CHR(10)
               + "#tabДолжность: " + PrintStringInfo(ttBeneficiaryPers.userPostPrint) + CHR(10).
    
    
    {wordwrap.i &s=str &n=200 &l=80}
    
    {setdest.i}
    PUT UNFORMATTED SPACE(77) "ф. ВП.ФЛ-1" SKIP(1)
                    SPACE(25) "АНКЕТА ВЫГОДОПРИОБРЕТАТЕЛЯ - ФИЗИЧЕСКОГО ЛИЦА" SKIP(2).
    
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