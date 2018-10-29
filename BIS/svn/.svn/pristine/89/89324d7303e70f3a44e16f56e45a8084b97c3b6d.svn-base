{pirsavelog.p}

/** 
    ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007

    Формирование анкеты выгодоприобретателя - юридического лица
    
    Бурягин Е.П., 14.05.2007 15:26
    
    <Как_запускается> : Запускается из броузера клиентов ЮЛ.
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

/******************************************* Реализация */

FOR EACH tmprecid NO-LOCK,
    FIRST cust-corp WHERE RECID(cust-corp) = tmprecid.id NO-LOCK
  :
/******************************************* Присвоение значений переменным и др. */
    
    /** См. определение в pir_xf_def.i */
    CREATE ttBeneficiaryCorp.
    ttBeneficiaryCorp.opf = GetCodeName("КодПредп", GetCodeVal("КодПредп", cust-corp.cust-stat)).
    ttBeneficiaryCorp.benefitInfo = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "СведВыгДрЛица", "").
    ttBeneficiaryCorp.fullName = ttBeneficiaryCorp.opf + " " + cust-corp.name-corp.
    ttBeneficiaryCorp.shortName = cust-corp.name-short.
    ttBeneficiaryCorp.foreignLanguageName = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "engl-name", "").
    ttBeneficiaryCorp.opf = GetCodeName("КодПредп",
                               GetCodeVal("КодПредп", cust-corp.cust-stat)
                        ).
    ttBeneficiaryCorp.ogrn = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОГРН", "").
    ttBeneficiaryCorp.registrationDate = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "RegDate", "")).
    ttBeneficiaryCorp.registrationPlace = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "RegPlace", "").

/*
    ttBeneficiaryCorp.addressOfStay = DelDoubleChars(
        (IF cust-corp.addr-of-low[1] <> cust-corp.addr-of-low[2] 
         THEN cust-corp.addr-of-low[1] + " " + addr-of-low[2] 
         ELSE cust-corp.addr-of-low[1]
        ),
    "," ).
    ttBeneficiaryCorp.addressOfPost = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "АдресП", "").
*/
    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ю'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ 'АдрЮр'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBeneficiaryCorp.addressOfStay = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ю'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ 'АдрФакт'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBeneficiaryCorp.addressOfPost = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    ttBeneficiaryCorp.tel = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "tel", "").
    ttBeneficiaryCorp.fax = cust-corp.fax.
    ttBeneficiaryCorp.inn = cust-corp.inn.
    ttBeneficiaryCorp.iin = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ИИН", "").

    tmpStr                     = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "СоставСД", "").
    ttBeneficiaryCorp.struct   = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "СтруктОрг", "")
       + IF (tmpStr EQ "") THEN "" ELSE (";" + CHR(10) + "Совет директоров: " + tmpStr).
    ttBeneficiaryCorp.capital  = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "УставКап", "").
    ttBeneficiaryCorp.exist    = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ПрисутОргУправ", "").
    
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
  
    /** Найдем сотрудника, заполнившего анкету в электронном виде */
      tmpStr = GetFirstHistoryUserid("cust-corp", STRING(cust-corp.cust-id)).
      FIND FIRST _user WHERE _user._userid = tmpStr  NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttBeneficiaryCorp.userNameInput = _user._user-name.
        ttBeneficiaryCorp.userPostInput = GetXAttrValueEx("_user", _user._userid, "Должность", "").
      END.
    
    /** Найдем сотрудника, перенесшего анкету на бумажный носитель */
    FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
    IF AVAIL _user THEN DO:
      ttBeneficiaryCorp.userNamePrint = _user._user-name.
      ttBeneficiaryCorp.userPostPrint = GetXAttrValueEx("_user", _user._userid, "Должность", "").
    END.
    

        
/******************************************* Формирование печатной формы анкеты */
    
    str[1] = "1.1. Сведения об основаниях, свидетельствующих о том, что клиент действует к выгоде другого лица при проведении банковских операций и иных сделок: " 
                + PrintStringInfo(ttBeneficiaryCorp.benefitInfo) + CHR(10)
           + "1.2. Полное наименование: " + PrintStringInfo(ttBeneficiaryCorp.fullName) + CHR(10) 
           + "1.3. Краткое наименование: " + PrintStringInfo(ttBeneficiaryCorp.shortName) + CHR(10)
           + "1.4. Наименование на иностранном языке: " + PrintStringInfo(ttBeneficiaryCorp.foreignLanguageName) + CHR(10)
           + "1.5. Организационно правовая форма: " + PrintStringInfo(ttBeneficiaryCorp.opf) + CHR(10)
           + "1.6. Государственный регистрационный номер: " + PrintStringInfo(ttBeneficiaryCorp.ogrn) + CHR(10)
           + "1.7. Дата регистрации: " + PrintDateInfo(ttBeneficiaryCorp.registrationDate) + CHR(10)
           + "1.8. Место регистрации (город, область), наименование регистрирующего органа: " + 
                 PrintStringInfo(ttBeneficiaryCorp.registrationPlace) + CHR(10)
           + "1.9. Адрес местонахождения: " + PrintStringInfo(ttBeneficiaryCorp.addressOfStay) + CHR(10)
           + "1.10. Почтовый адрес: " + PrintStringInfo(ttBeneficiaryCorp.addressOfPost) + CHR(10)
           + "1.11. Номера " + CHR(10) 
           + "#tabконтактных телефонов: " + PrintStringInfo(ttBeneficiaryCorp.tel) + CHR(10)
           + "#tabфаксов: " + PrintStringInfo(ttBeneficiaryCorp.fax) + CHR(10)
           + "1.12. ИНН - для резидента: " + PrintStringInfo(ttBeneficiaryCorp.inn) + CHR(10)
           + "1.13. ИИН или код иностранной организации - для нерезидента: " + PrintStringInfo(ttBeneficiaryCorp.iin) + CHR(10)
           + "1.14. Сведения о лицензии на право осуществления деятельности, подлежащей лицензированию: " + CHR(10)
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
    
    str[1] = str[1] + "1.15. Сведения об органах юридического лица (структура и персональный состав органов управления юридического лица):" 
                          + PrintStringInfo(ttBeneficiaryCorp.struct) + CHR(10)
                    + "1.16. Сведения о величине зарегистрированного и оплаченного уставного (складочного) капитала или величине уставного фонда, имущества:"
                          + PrintStringInfo(ttBeneficiaryCorp.capital) + CHR(10)
                    + "1.17. Сведения о присутствии или отсутствии по своему местонахождению юридического лица, его постоянно действующего органа управления, "
                        + "иного органа или лица, которые имею право действовать от имени юридического лица без доверенности: " 
                        + PrintStringInfo(ttBeneficiaryCorp.exist) + CHR(10)
                    + "1.18. Работник банка, заполнивший Анкету выгодоприобретателя в электронном виде" + CHR(10)
                        + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBeneficiaryCorp.userNameInput) + CHR(10)
                        + "#tabДолжность: " + PrintStringInfo(ttBeneficiaryCorp.userPostInput) + CHR(10)
                    + "1.19. Подпись уполномоченного работника Банка, перенесшего Анкету выгодоприобретателя, заполненную в электронном виде,"
                        + " на бумажный носитель" + CHR(10)
                        + "#tabФамилия, Имя, Отчество: " + PrintStringInfo(ttBeneficiaryCorp.userNamePrint) + CHR(10)
                        + "#tabДолжность: " + PrintStringInfo(ttBeneficiaryCorp.userPostPrint) + CHR(10).
    
    
    {wordwrap.i &s=str &n=200 &l=80}
    
    {setdest.i}
    PUT UNFORMATTED SPACE(77) "ф. ВП.ЮЛ-1" SKIP(1)
                    SPACE(30) "АНКЕТА ВЫГОДОПРИОБРЕТАТЕЛЯ - ЮРИДИЧЕСКОГО ЛИЦА" SKIP(2).
    
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
