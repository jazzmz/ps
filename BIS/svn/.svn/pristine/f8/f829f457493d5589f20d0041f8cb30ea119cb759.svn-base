/* ------------------------------------------------------
File	        : $RCSfile: extrpars.fun,v $ $Revision: 1.21 $ $Date: 2011-02-15 14:45:58 $
Copyright     : ООО КБ "Проминвестрасчет"
Базируется    : extrpars.fun
Назначение    : Функции расширения стандартного парсера 
Место запуска : Шаблоны транзакций использующие парсер
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.19  2010/12/30 10:28:10  kraskov
Изменения     : dobavil funkciu vichislenia dati nachala uplati procentov.
Изменения     : zayavka #280
Изменения     :
Изменения     : Revision 1.18  2010/12/20 12:30:08  kraskov
Изменения     : dobavlena parsernaya funkcia CalcOborot()
Изменения     :
Изменения     : Revision 1.17  2010/09/15 06:37:33  borisov
Изменения     : Ubral GetNotEmpty
Изменения     :
Изменения     : Revision 1.16  2010/09/14 12:06:32  borisov
Изменения     : Ispravleny oshibki v KlntKr
Изменения     :
Изменения     : Revision 1.15  2010/09/13 12:02:41  borisov
Изменения     : Dobavil KlntKr() - kratkoe naimenovanie klienta
Изменения     :
Изменения     : Revision 1.14  2010/03/30 09:04:21  maslov
Изменения     : Modify PIRCAF result
Изменения     :
Изменения     : Revision 1.12  2009/12/07 08:20:47  Buryagin
Изменения     : Fix the bug. Delete not the necessary message in function PirCAF_2281U().
Изменения     :
Изменения     : Revision 1.10  2009/11/13 10:39:31  Buryagin
Изменения     : Added function "pir_if"
Изменения     :
Изменения     : Revision 1.9  2009/09/16 09:03:11  maslov
Изменения     : Add PirCeil
Изменения     :
Изменения     : Revision 1.8  2008/11/06 13:29:07  Buryagin
Изменения     : Added the new function PirFirstUsedAcctPerDay2()
Изменения     :
Изменения     : Revision 1.7  2008/02/22 13:17:35  kuntash
Изменения     : dorabotka 222-p
Изменения     :
Изменения     : Revision 1.6  2008/01/15 10:19:23  Buryagin
Изменения     : no message
Изменения     :
Изменения     : Revision 1.5  2008/01/14 14:01:25  Buryagin
Изменения     : The procedure 'PirCAF_275FZ' was added.
Изменения     :
Изменения     : Revision 1.4  2008/01/14 05:53:11  kuntash
Изменения     : dorabotka PirFizInn
Изменения     :
Изменения     : Revision 1.3  2007/09/26 07:35:21  lavrinenko
Изменения     : Добавлена функция PirTurn для подсчета оборотов поенту , с челью реализации решения правления от 06,09,2007 по установлению специальных тарифов для ряда клиентов
Изменения     :
Изменения     : Revision 1.2  2007/06/15 12:45:29  lavrinenko
Изменения     : реализован читаемый вывод сообщений об ошибках
Изменения     :
Изменения     : Revision 1.1  2007/06/13 13:28:33  lavrinenko
Изменения     : Добавлена прасерная функция КОмПИР
Изменения     :
------------------------------------------------------ */

/******************************************************************************

				УВАЖАЕМЫЕ КОДО ПИСАТЕЛИ!!!!

1. ЕСЛИ ХОТИТЕ РАБОТАТЬ С ПАРАМЕТРАМИ, ТО ОБЯЗАТЕЛЬНО
ВНАЧАЛЕ ВЫПОЛНЯЙТЕ Pars-ValidParams !!!!!!!!!!!!!!!!!!!!!!!!

2. ЕСЛИ ХОТИТЕ ЧТОБЫ ФУНКЦИЯ РАБОТАЛА, ТО ОБЯЗАТЕЛЬНО
ПРИСВАИВАЙТЕ is-ok = TRUE

Маслов Д.
*******************************/

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2001 ТОО "Банковские информационные системы"
     Filename: EXTRPARS.FUN
      Comment: Дополнительные функции парсера, написанные в банках
               Файл индивидуален для каждой версии банка
               
               Для программистов БИС: СЮДА ПИСАТЬ НЕЛЬЗЯ !!!!!!!!!!!!!!!
               
               Для программиста банка: все функции, добавленные в банке писать
               только сюда (а не в g-pfunc.def parsacct.def details.fun).
               Если функция будет хороша, то она возможно будет перенесена для
               использования в других местах
               
               ЭТО ВАЖНО!!!!!
               Огромная просьба:
               1. старайтесь СЮДА писать функции ТОЛЬКО если без них совсем ничего невозможно
               2. старайтесь уменьшать код до минимума
               3. желательно больше использовать функции в виде внешних процедур и функций в парсерных библиотеках!
               
   Parameters: &PARSER-DETAILS-P  - означает что функция будет использоваться только
                                    в парсере по полю "содержание"
               &PARSER-PARSACCT-P - означает что функция будет использоваться только
                                    в парсере по счетам
               &PARSER-PARSSEN-P  - означает что функция будет использоваться только
                                    в парсере по полям сумм
                                
               Как использовать ? Пишете:
               &IF DEFINED (PARSER-DETAILS-P) &THEN
                  /* Эта функция будет использоваться в парсере по полю "содержание" */
               &ENDIF
               
               Если нет никаких указателей - функция будет объявлена везде
               
               Не забывайте писать коментарии, что функция делает!!!!!!!!!!!!!!!!!!!!!!!!!
         Uses:
      Used by:
      Created: 25.06.2002 15:11 SEMA    для отделения функций банка от функций БИС
     Modified: 25.06.2002 15:54 SEMA     по заявке 0003868 создание файла
     Modified: 



   пример функции :

/*
  Что делает: Описание функции
  Синтаксис : ФункцияДляПримера1 ( Параметр1, Параметр2 )
  Автор     :
*/

PROCEDURE ФункцияДляПримера1:
    DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */
/* --- */
    IF NOT Pars-ValidParam(2) THEN RETURN.
/* --- */
    DEFINE VARIABLE vFuncParam1 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vFuncParam2 AS INTEGER    NO-UNDO.
    DEFINE VARIABLE vResult     AS CHARACTER  NO-UNDO.

    ASSIGN
        vFuncParam1 = Pars-GetString ( 0 )
        vFuncParam2 = Pars-GetInt ( 1 )
        .

    RUN ПроцедураОбрабатывающаяЧтоТо (vFuncParam1, vFuncParam2, OUTPUT vResult).

    RUN Pars-SetCHARResult ( vResult ).

/* --- */
    is-ok = TRUE.
END PROCEDURE.


&IF DEFINED (PARSER-DETAILS-P) &THEN
    /*
      Что делает: Описание функции
      Синтаксис : ФункцияДляПримера2 ( Параметр1 [, Параметр2 ] )
      Автор     :
    */
    
    PROCEDURE ФункцияДляПримера2:
        DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */
    /* --- */
        IF NOT (Pars-ValidParam(1) OR Pars-ValidParam(2)) THEN RETURN.
    /* --- */
        DEFINE VARIABLE vFuncParam1 AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE vFuncParam2 AS DECIMAL    NO-UNDO.
        DEFINE VARIABLE vResult     AS DECIMAL    NO-UNDO.
    
        ASSIGN
            vFuncParam1 = Pars-GetString ( 0 )
            vFuncParam2 = (IF pn > 0 THEN Pars-GetDec ( 1 ) ELSE 0)
            .
    
        RUN ПроцедураОбрабатывающаяЕщеЧтоТо (vFuncParam1, vFuncParam2, OUTPUT vResult).
    
        RUN Pars-SetResult ( vResult ).
    
    /* --- */
        is-ok = TRUE.
    END PROCEDURE.
&ENDIF

*/

/* ************************************ писать отсюда ****************************************** */

{intrface.get date}
{intrface.get cust}


/*
  Что делает: Возвращает символьный код страны клиента счета
  Синтаксис : КодСтраныПоСчетуС ( Счет )
  Автор     : 22.11.2006 Anisimov (PIR)
*/

PROCEDURE КодСтраныПоСчетуС:
    DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

    DEFINE VARIABLE vAcct    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vResult  AS CHARACTER  NO-UNDO.

    vResult="RUS".

    vAcct = Pars-GetString ( 1 ).

    FIND FIRST acct WHERE acct.acct EQ vAcct NO-LOCK NO-ERROR.
    CASE acct.cust-cat:
         WHEN "Ч" THEN DO:
                FIND FIRST person WHERE person.person-id EQ acct.cust-id NO-LOCK NO-ERROR.
                IF AVAIL person THEN vResult = GetXattrValueEx("person",STRING(person.person-id),"country-id2","").
              END.
         WHEN "Ю" THEN DO:
                  FIND FIRST cust-corp WHERE cust-corp.cust-id EQ acct.cust-id NO-LOCK NO-ERROR.
                  IF AVAIL cust-corp THEN vResult = GetXattrValueEx("cust-corp",STRING(cust-corp.cust-id),"country-id2","").
               END.
         WHEN "Б" THEN DO:
                  FIND FIRST banks WHERE banks.bank-id EQ acct.cust-id NO-LOCK NO-ERROR.
                  IF AVAIL banks THEN vResult = banks.country-id.
                   /* GetXattrValueEx("banks",STRING(banks.bank-id),"country-id2",""). */
               END.
    END CASE.
   
    IF pn <> 1 THEN 
      RETURN.
    ELSE pn = pn - 1.

    RUN Pars-SetCHARResult ( vResult ).

    is-ok = TRUE.

END PROCEDURE.


/*
  Что делает: Возвращает цифровой код страны клиента счета
  Синтаксис : КодСтраныПоСчетуЧ ( Счет )
  Автор     : 22.11.2006 Anisimov (PIR)
*/

PROCEDURE КодСтраныПоСчетуЧ:
    DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

    DEFINE VARIABLE vAcct    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vResult  AS CHARACTER  NO-UNDO.

    vAcct = Pars-GetString ( 1 ).

    vResult="RUS".

    FIND FIRST acct WHERE acct.acct EQ vAcct NO-LOCK NO-ERROR.
    CASE acct.cust-cat:
         WHEN "Ч" THEN DO:
                FIND FIRST person WHERE person.person-id EQ acct.cust-id NO-LOCK NO-ERROR.
                IF AVAIL person THEN vResult = GetXattrValueEx("person",STRING(person.person-id),"country-id2","").
              END.
         WHEN "Ю" THEN DO:
                  FIND FIRST cust-corp WHERE cust-corp.cust-id EQ acct.cust-id NO-LOCK NO-ERROR.
                  IF AVAIL cust-corp THEN vResult = GetXattrValueEx("cust-corp",STRING(cust-corp.cust-id),"country-id2","").
               END.
         WHEN "Б" THEN DO:
                  FIND FIRST banks WHERE banks.bank-id EQ acct.cust-id NO-LOCK NO-ERROR.
                  IF AVAIL banks THEN vResult = banks.country-id.
                   /* GetXattrValueEx("banks",STRING(banks.bank-id),"country-id2",""). */
               END.
    END CASE.

    FIND FIRST country WHERE country.country-id EQ vResult NO-LOCK NO-ERROR.
    vResult = IF AVAIL country THEN STRING( country.country-alt-id, "999" ) ELSE "643".
   
    IF pn <> 1 THEN 
      RETURN.
    ELSE pn = pn - 1.

    RUN Pars-SetCHARResult ( vResult ).

    is-ok = TRUE.

END PROCEDURE.


/*
  Что делает: Возвращает строку для ф402
  Синтаксис : КодФ402 ( СчетДебет, СчетКредит, Сумма )
  Автор     : 22.11.2006 Anisimov (PIR)
*/

PROCEDURE КодФ402:
    DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

    DEFINE VARIABLE vAcctD   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vAcctK   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vSumma   AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE vResult  AS CHARACTER  NO-UNDO.

    vAcctD = Pars-GetString ( 1 ).
    vAcctK = Pars-GetString ( 2 ).
    vSumma = Pars-GetDec ( 3 ).

    vResult="".

    IF ( TRIM(SUBSTR(vAcctD, 1,5)) EQ "70209" AND TRIM(SUBSTR(vAcctK, 1,5)) EQ "30114") THEN
       vResult = SUBSTR(vAcctK,6,3) + "#811,0," + TRIM(STRING(vSumma,">>>>>>>>>>>>9.99")) + ",,2".
    ELSE IF ( TRIM(SUBSTR(vAcctD, 1,5)) EQ "70209" AND TRIM(SUBSTR(vAcctK, 1,5)) EQ "30110") THEN 
       vResult = SUBSTR(vAcctK,6,3) + "#811,0," + TRIM(STRING(vSumma,">>>>>>>>>>>>9.99")) + ",,2".
    ELSE IF ( TRIM(SUBSTR(vAcctD, 1,8)) EQ "40820810" AND TRIM(SUBSTR(vAcctK, 1,5)) EQ "70107") OR 
            ( TRIM(SUBSTR(vAcctD, 1,8)) EQ "40807810" AND TRIM(SUBSTR(vAcctK, 1,5)) EQ "70107") THEN
       vResult = "#811,0," + TRIM(STRING(vSumma,">>>>>>>>>>>>9.99")) + ",,3".
    ELSE IF ( TRIM(SUBSTR(vAcctD, 1,5)) EQ "40820" AND TRIM(SUBSTR(vAcctK, 1,5)) EQ "70107") OR 
            ( TRIM(SUBSTR(vAcctD, 1,5)) EQ "40807" AND TRIM(SUBSTR(vAcctK, 1,5)) EQ "70107") THEN
       vResult = SUBSTR(vAcctD,6,3) + "#811,0," + TRIM(STRING(vSumma,">>>>>>>>>>>>9.99")) + ",,1".


    IF pn <> 3 THEN 
      RETURN.
    ELSE pn = pn - 1. 

    RUN Pars-SetCHARResult ( vResult ).

    is-ok = TRUE.

END PROCEDURE.

/*
  Что делает: Возвращает лицевой счет балансовый по внебалансовому по КАУ
  Синтаксис : СчетЛицпоВб ( Счет, ШаблонКау )
  Автор     : 22.11.2006 Anisimov (PIR)
*/
{globals.i}
{sh-defs.i}
{kautools.lib}

PROCEDURE СчетЛицпоВб:
    DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

    DEFINE VARIABLE vOAcct   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vBAcct   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vShKau   AS CHARACTER  NO-UNDO.

    def buffer bttkau for ttKau.
    def buffer bacct for acct.

    vOAcct = Pars-GetString ( 1 ).
    vShKau = Pars-GetString ( 2 ).
    vBAcct = "".

/*    MESSAGE 'Счет ' vOAcct  VIEW-AS ALERT-BOX ERROR.   */

find first acct where acct.acct = vOAcct.
IF AVAIL acct THEN DO:
   run fdbacct(buffer acct, "Да", vShKau). /* соответствующий балансовый*/
   if avail(ttKau) then do:
      find first bacct where recid(bacct) = ttKau.fRecId no-lock no-error.
      vBAcct = bacct.acct.
   end.
end.

    IF pn <> 2 THEN 
      RETURN.
    ELSE pn = pn - 1. 

    RUN Pars-SetCHARResult ( vBAcct ).

    is-ok = TRUE.

END PROCEDURE.


PROCEDURE СчетКредит:
    DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */
    DEF BUFFER x_wop FOR wop.

    DEFINE VARIABLE vShablon   AS INT  NO-UNDO.
    DEFINE VARIABLE vResult    AS CHAR NO-UNDO.

    vShablon = Pars-GetInt ( 1 ).
    vResult = "".

/* MESSAGE 'Счет ' bacct-cr    VIEW-AS ALERT-BOX ERROR.  */
    FIND FIRST x_wop WHERE x_wop.op-templ = vShablon NO-LOCK NO-ERROR.
    IF AVAIL x_wop THEN vResult = STRING(x_wop.acct-cr).

    IF pn <> 1 THEN 
      RETURN.
    ELSE pn = pn - 1. 

/*     MESSAGE 'Счет ' vResult  VIEW-AS ALERT-BOX ERROR. */
    RUN Pars-SetCHARResult ( vResult ).

    is-ok = TRUE.

END PROCEDURE.


PROCEDURE IsФизЛицо:
    DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

    DEFINE VARIABLE vAccount   AS CHAR NO-UNDO.
    DEFINE VARIABLE vResult    AS CHAR NO-UNDO.

    vAccount = Pars-GetString ( 1 ).
    vResult = "".

/*    MESSAGE 'Счет ' vAccount  VIEW-AS ALERT-BOX ERROR.   */
    find first acct where acct.acct = vAccount NO-LOCK NO-ERROR.
    IF acct.cust-cat EQ "Ч" then vResult="1".
    ELSE vResult = "0".

    IF pn <> 1 THEN 
      RETURN.
    ELSE pn = pn - 1. 

    RUN Pars-SetCHARResult ( vResult ).

    is-ok = TRUE.

END PROCEDURE.

/* Что делает: Вычисляет значение даты в формате дд/мм/гггг                */
/*             при необходимости сдвигает дату на требуемое кол-во опердней назад*/
/*     Формат: date(Строка[,кол-во дней]) 2 - вперед -2 - назад */
/*  Синтаксис: date("")            - текущая дата                          */
/*             date("ОпДень")      - дата опердня                          */
/*             date("НачПериода")  - начало периода для op_flt && nach2flt */
/*             date("КонПериода")  - конец  периода для op_flt && nach2flt */
/*             date("ГНачПериода") - начало глобального периода            */
/*             date("ГКонПериода") - конец  глобального периода            */
/*             date("ДатаСтрока")  - преобразование строки в дату          */
PROCEDURE PirDate:
   DEFINE OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */
   
   DEFINE VARIABLE vDateStr  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vTmpDate  AS DATE      NO-UNDO.
   DEFINE VARIABLE vQntDay   AS INTEGER   NO-UNDO.

   /* Разбор входных параметров. */
   IF NOT (   Pars-ValidParam(1)
           OR Pars-ValidParam(2)) THEN DO:
      RETURN.
   END.
   
   ASSIGN
      vDateStr = TRIM(Pars-GetString(0),"""")
      vQntDay  = Pars-GetInt(1) WHEN pn EQ 1
   .
   CASE vDateStr:
      WHEN ""            THEN
         vTmpDate = TODAY.
      WHEN "ОпДень"      THEN
         vTmpDate = in-op-date.
       WHEN "ОпДень+1"      THEN
         vTmpDate = in-op-date + 1.        
      WHEN "НачПериода"  THEN
         vTmpDate = beg-date.
      WHEN "КонПериода"  THEN
         vTmpDate = end-date.
      WHEN "ГНачПериода" THEN
         vTmpDate = gbeg-date.
      WHEN "ГКонПериода" THEN
         vTmpDate = gend-date.
      OTHERWISE DO:
         vTmpDate = DATE(vDateStr) NO-ERROR.
         IF ERROR-STATUS:ERROR THEN 
         DO:
            MESSAGE "В функции <date> задана неверная дата"
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN.
         END.
      END.
   END CASE.
   
   IF vQntDay NE 0 THEN
      vTmpDate = AfterOpDays(vTmpDate,vQntDay).

   ASSIGN 
      result_l[pj - pn] = INT(vTmpDate) 
      mvar[pj - pn]     = STRING(vTmpDate, "99/99/9999")
   .

   is-ok = YES.
   
END PROCEDURE.



/*
**    Что делает: Производит рассчет комисии. С учетом вычера порога комиссии
**    Синтаксис : КомПИР(<база начисления>, <код комиссии>, <cчет>, <валюта>, <период>, <тип даты>)
*/
PROCEDURE КомПИР:
   DEFINE OUTPUT PARAMETER is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

   IF NOT (Pars-ValidParam(4) OR
           Pars-ValidParam(5) OR
           Pars-ValidParam(6))
      THEN RETURN.

   DEF VAR vSumm     AS DEC   NO-UNDO. /* База начисления. */
   DEF VAR vCommName AS CHAR  NO-UNDO. /* Код вида комиссии. */
   DEF VAR vAcct     AS CHAR  NO-UNDO. /* Счет. */
   DEF VAR vCurrency AS CHAR  NO-UNDO. /* Валюта. */
   DEF VAR vPeriod   AS INT   NO-UNDO. /* период нахождения остатка */
   DEF VAR vDate     AS DATE  NO-UNDO. /* дата, на которую рассчитывается коммиссия */

   DEF BUFFER op         FOR op.          /* Локализация буфера. */
   DEF BUFFER commission FOR commission.  /* Локализация буфера. */
   DEF BUFFER acct       FOR acct.        /* Локализация буфера. */

   ASSIGN
      vSumm     = result_l[pj - pn]
      vCommName = Pars-GetString ( 1 )
      vAcct     = Pars-GetString ( 2 )
      vCurrency = Pars-GetStringFormatted ( 3 , "999" )
      vCurrency = (IF vCurrency EQ vNatCurrChar THEN "" ELSE vCurrency)
      vPeriod   = (IF pn GE 4  THEN  Pars-GetDec(4)  ELSE 0)
      vDate     = (IF pn EQ 5  THEN DATE(Pars-GetString(5)) ELSE in-op-date)
   .
   
   /* Поиск вида комиссии. (pp-comm, comm.pro)*/
   RUN get_head_comm (vCommName, vCurrency, vSumm, vPeriod, BUFFER commission). 
   IF ERROR-STATUS:ERROR THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "-1", "Не найден тариф " + vCommName).
      RETURN.
   END.

   /* получение описания комиссии (pp-comm, comm.pro) */
   RUN GetCommDesc IN h_comm (vCommName, vAcct, vCurrency, vSumm, vPeriod, vDate, BUFFER comm-rate) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "-1", "Не найдена ставка тарифа " + vCommName).
      RETURN.
   END.

   RUN Pars-SetResult (
   IF AVAILABLE comm-rate
      THEN (IF comm-rate.rate-fixed
               THEN  comm-rate.rate-comm
               ELSE (comm-rate.rate-comm / 100) * (vSumm - commission.min-value))
      ELSE 0 ).

   is-ok = TRUE.
   RETURN.

END PROCEDURE.

/*
**    Что делает: Производит расчет оборота по ДВ или КР счетов клиента
**                в корреспонденции со счетами указанными в маске 
**                начиная с указанной даты, результат возвращается в рублях
**    Синтаксис : PirTurn(<Тип оборота - ДБ/КР>, <счет>, <маска cчетов, в корреспонденции с которыми вычисляется оборот>, <Дата начиная с которой считается оборот>)
*/
PROCEDURE PirTurn:
   DEFINE OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */
   
   DEFINE VARIABLE vTurnDB   AS LOGICAL                      NO-UNDO.
   DEFINE VARIABLE vAcct     LIKE acct.acct                  NO-UNDO.
   DEFINE VARIABLE vMask     AS CHARACTER                    NO-UNDO.
   DEFINE VARIABLE vBegDt    AS DATE                         NO-UNDO.
   DEFINE VARIABLE vSum      LIKE op-entry.amt-rub INITIAL 0 NO-UNDO.
   
   DEFINE BUFFER   bacct     FOR  acct.
   DEFINE BUFFER   bacct-cli FOR  acct.
   DEFINE BUFFER   bop-entry FOR  op-entry.

   is-ok = NO. 

   /* Разбор входных параметров. */
   IF NOT (Pars-ValidParam(3) OR Pars-ValidParam(4)) THEN RETURN.
   
   ASSIGN
      vTurnDB = Pars-GetString(0) EQ 'ДБ'
      vAcct   = Pars-GetString(1)
      vMask   = Pars-GetString(2)
   .
   
   IF Pars-ValidParam(4) THEN DO:
      vBegDt = DATE(Pars-GetString(3)).
   END. ELSE 
      vBegDt = DATE (MONTH(in-op-date), 01, YEAR(in-op-date)).

   FIND FIRST bacct-cli WHERE bacct-cli.acct EQ vAcct NO-LOCK NO-ERROR.
   
   IF NOT AVAIL bacct-cli THEN DO:
      MESSAGE "В функции PirTurn не найден счет " vAcct "!"
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN.
   END. 
   
   IF bacct-cli.cust-cat EQ 'В' THEN DO:
      MESSAGE "В функции PirTurn счет " vAcct " не может быть внутренним !"
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN.
   END. 
   
   FOR EACH bacct WHERE bacct.cust-cat EQ bacct-cli.cust-cat AND  
                        bacct.cust-id  EQ bacct-cli.cust-id NO-LOCK,
       EACH bop-entry WHERE bop-entry.op-date GE vBegDt   AND  
                            bop-entry.op-date LE in-op-date AND  
                            (IF vTurnDB 
                              THEN (bop-entry.acct-db EQ bacct.acct AND
                                    CAN-DO(vMask,bop-entry.acct-cr)) 
                              ELSE (bop-entry.acct-cr EQ bacct.acct AND
                                    CAN-DO(vMask,bop-entry.acct-db)))
                            NO-LOCK:
       
        vSum = vSum + bop-entry.amt-rub.                      
        
   END. /* FOR EACH bacct WHERE*/
   
   RUN Pars-SetResult (vSum).
   ASSIGN
      {&type-er} = ""
      is-ok = YES
   .
   RETURN.
END PROCEDURE. /* PirTurn */


/*
**    Что делает: Выводит ИНН физического лица по счету
**    Синтаксис : PirFizInn(<счет>) пример PirFizInn(Кр(1))
*/
PROCEDURE PirFizInn:
   DEFINE OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */
   DEFINE VARIABLE vAcct     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vCurrency AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vResult   AS CHARACTER  NO-UNDO.
   
    DEFINE VARIABLE name1   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE name2   AS CHARACTER  NO-UNDO.

   IF NOT Pars-ValidParam(1) THEN RETURN.
   vAcct = Pars-GetString (0).
   vCurrency = ?.

   IF vCurrency NE ? THEN DO:
      {find-act.i
          &bact = acct
          &acct = vAcct
          &curr = vCurrency
      }
   END.
   ELSE DO:
      {find-act.i
          &bact = acct
          &acct = vAcct
      }
   END.
   IF AVAIL acct THEN
   DO:
      IF acct.cust-cat EQ "Ч" THEN
      Do:
      RUN GetCust IN h_base (BUFFER acct,YES,YES,
                       OUTPUT Name1,OUTPUT Name2,OUTPUT vResult ).
      END.
      ELSE
         vResult = ?.
   END.
   ELSE 
      MESSAGE "Счет" """" + vAcct +  """" "в качестве параметра не найден !"
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   
   RUN Pars-SetResult (vResult).

   is-ok = TRUE.
 
END PROCEDURE. /* PirFizInn */


/*
**    Что делает: Check And Fill (проверяет и заполняет) согласно 275-ФЗ различные поля документа.
**    Синтаксис: < PirCAF_275FZ( Дб(1) , field ) > 
**              (параметры: счет клиента, 
                            условное название поля, в котором используется функция
                            возможные значения {name, inn, acct} )
*/

{intrface.get strng}

PROCEDURE PirCAF_275FZ:
   DEFINE OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена? */
   DEFINE VARIABLE vAcct     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vField    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vResult   AS CHARACTER  NO-UNDO.
   
	 DEFINE VARIABLE inn AS CHARACTER NO-UNDO.
	 /** Набор возможных значений второго параметра */
	 DEFINE VARIABLE setOfTwoParam AS CHARACTER INITIAL "name,inn,acct" NO-UNDO.
	 /** Дабы избавиться от лишних условий в процессе вычисления, сохраним найденые значения сначала в массив,
	     а потом уже выберем из него нужный. Для этого и определяем */
	 DEFINE VARIABLE preResult AS CHARACTER EXTENT 3 NO-UNDO.
	 
   /** Проверка кол-ва параметров */
   IF NOT Pars-ValidParam(2) THEN RETURN.
   
   vAcct = Pars-GetString (0).
   vField = Pars-GetString (1).
   
   IF NOT CAN-DO(setOfTwoParam, vField) THEN DO:
     MESSAGE "Значение второго параметра должно быть равно любому из '" + setOfTwoParam + "'!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
     is-ok = false.
     RETURN.
   END.
		
	 /** Найдем счет */
	 FIND FIRST acct WHERE acct.acct = vAcct AND acct.cust-cat <> "В" NO-LOCK NO-ERROR.
	 IF AVAIL acct THEN 
	 	 DO:
			 /** Найдем клиента */
			 IF acct.cust-cat = "Ю" THEN DO:
			 	 FIND FIRST cust-corp where cust-corp.cust-id = acct.cust-id NO-LOCK NO-ERROR.
			 	 inn = cust-corp.inn.
			 END.
			 IF acct.cust-cat = "Ч" THEN DO:
			 	 FIND FIRST person WHERE person.person-id = acct.cust-id NO-LOCK NO-ERROR.
			 	 inn = TRIM(REPLACE(person.inn, "0", "")).
			 	 IF inn = "" THEN DO:
			 	 	 preResult[LOOKUP("name",setOfTwoParam)] = person.name-last + " " + person.first-names + CHR(10) + "( " +
			 	 	   DelDoubleChars(
			 	 	   (IF person.address[1] = person.address[2] THEN person.address[1] ELSE person.address[1] + "," + person.address[2]),
			 	 	   ",") + " )".
			 	 	 preResult[LOOKUP("acct",setOfTwoParam)] = vAcct.
			 	 	 preResult[LOOKUP("inn",setOfTwoParam)] = inn.
			 	 END.
			 END.
	 	 END.
	 ELSE
	 	 DO:
	 	 	 /*
	 	 	 MESSAGE "Функция PirCAF_275FZ сообщает: счет " + vAcct + " не найден либо он не принадлежит клиенту!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
	 	 	 */
	 	 	 is-ok = TRUE.
	 	 	 RUN Pars-SetCHARResult (""). 
	 	 	 RETURN.
	 	 END.
	 
	 vResult = preResult[LOOKUP(vField, setOfTwoParam)].
	 
	 /** MESSAGE vField + " = '" + preResult[LOOKUP(vField, setOfTwoParam)] + "'" VIEW-AS ALERT-BOX. */
	 
   RUN Pars-SetCHARResult (vResult).

   is-ok = TRUE.
 
END PROCEDURE. /* PirCAF_275FZ */

PROCEDURE PirCAF_2281U:
   DEFINE OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена? */
   DEFINE VARIABLE vAcct     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vField    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vContext  AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vOpTemplNum		 AS CHARACTER  NO-UNDO. /** номер шаблона */
   DEFINE VARIABLE vResult   AS CHARACTER  NO-UNDO.



/************************************
 * Переменные по заявке #638 *
 *************************************/

   DEF VAR cBen-Acct AS CHARACTER NO-UNDO.				/* Переменная для хранения счета банка получателя */
   DEF VAR oClient   AS TClient   NO-UNDO.	
   DEF VAR cBankNerList AS CHARACTER INITIAL "!*" NO-UNDO.		/* Маска счетов попадающих под контроль */

 /**************************************************
   * Конец Заявки: #638                                      *
  * **************************************************/				
   
	 DEFINE VARIABLE inn AS CHARACTER NO-UNDO.
	 /** Набор возможных значений второго параметра */
	 DEFINE VARIABLE setOfTwoParam AS CHARACTER INITIAL "name,inn,acct" NO-UNDO.
	 /** Набор возможных значений третьего параметра */
	 DEFINE VARIABLE setOfThreeParam AS CHARACTER INITIAL "0,1,2,3,4" NO-UNDO.
	 /** Дабы избавиться от лишних условий в процессе вычисления, сохраним найденые значения сначала в массив,
	     а потом уже выберем из него нужный. Для этого и определяем */
	 DEFINE VARIABLE preResult AS CHARACTER EXTENT 3 NO-UNDO.

	DEF VAR point-sum AS DECIMAL NO-UNDO.
	DEF VAR char-div AS CHAR NO-UNDO.
	DEF VAR amt-sum AS DECIMAL NO-UNDO.
	DEF VAR bank-name AS CHAR NO-UNDO.
	DEF VAR op-templ-num AS INT NO-UNDO.

    DEF BUFFER x_wop FOR wop.

	char-div = FGetSetting("Pir2281U", "Pir2281UCDiv", "//").
	/** пороговая сумма от которой зависит содержание поля плательщик */
	point-sum = DEC(FGetSetting("Pir2281U", "Pir2281USum1", "0")).
	
	bank-name = FGetSetting("Банк", "", "").
   
   /** Проверка кол-ва параметров */
   IF NOT Pars-ValidParam(4) THEN RETURN.
   
   vAcct = Pars-GetString (0).
   vField = Pars-GetString (1).
   vContext = Pars-GetString (2).
   vOpTemplNum = Pars-GetString (3).
   
   op-templ-num = INT(vOpTemplNum).

	/** сумма операции */
    FIND FIRST x_wop WHERE x_wop.op-templ = op-templ-num NO-LOCK NO-ERROR.
    IF AVAIL x_wop THEN amt-sum = x_wop.amt-rub.
   
   IF NOT CAN-DO(setOfTwoParam, vField) THEN DO:
     MESSAGE "PirCAF_2281U(): сообщает: Значение второго параметра должно быть равно любому из '" + setOfTwoParam + "'!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
     is-ok = false.
     RETURN.
   END.

   IF NOT CAN-DO(setOfThreeParam, vContext) THEN DO:
     MESSAGE "PirCAF_2281U(): сообщает: Значение третьего параметра должно быть равно любому из '" + setOfThreeParam + "'!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
     is-ok = false.
     RETURN.
   END.
		
	 /** Найдем счет */
	 FIND FIRST acct WHERE acct.acct = vAcct AND acct.cust-cat <> "В" NO-LOCK NO-ERROR.
	 IF AVAIL acct THEN 
	 	 DO:
			 /** Найдем клиента */
			 IF acct.cust-cat = "Ю" THEN DO:
			 	 FIND FIRST cust-corp where cust-corp.cust-id = acct.cust-id NO-LOCK NO-ERROR.
			 	 inn = cust-corp.inn.
			 END.

			 IF acct.cust-cat = "Ч" THEN DO:
			 	 FIND FIRST person WHERE person.person-id = acct.cust-id NO-LOCK NO-ERROR.
			 	 if (person.inn begins "000000") or (person.inn = "0") then 
			 	 	inn = TRIM(REPLACE(person.inn, "0", "")).
			 	 else
			 	 	inn = person.inn.
			 	 	

		 	 	 /** внешний платеж */
		 	 	 IF vContext = "1" THEN DO:
		 	 	 	IF amt-sum < point-sum THEN 
			 	 	 	preResult[LOOKUP("name",setOfTwoParam)] = person.name-last + " " + person.first-names.
				 	ELSE			
			 	 	 	preResult[LOOKUP("name",setOfTwoParam)] = person.name-last + " " + person.first-names + " " + char-div + " " +  
			 	 	   		DelDoubleChars(
			 	 	   		(IF person.address[1] = person.address[2] THEN person.address[1] ELSE person.address[1] + "," + person.address[2]),
			 	 	   		",") + " " + char-div.
			 	 	IF inn <> "" THEN 
			 	 		preResult[LOOKUP("name",setOfTwoParam)] = person.name-last + " " + person.first-names.
		 	 	 END. /* Конец IF vContext */
		 	 	 
		 	 	 /** внутренний перевод */
		 	 	 IF vContext = "2" THEN DO:
		 	 	 	preResult[LOOKUP("name",setOfTwoParam)] = person.name-last + " " + person.first-names.
		 	 	 END.
			 	 
			 	 /** перевод без открытия счета внешний */
		 	 	 IF vContext = "3" THEN DO:
		 	 	 	IF amt-sum < point-sum THEN
		 	 	 		preResult[LOOKUP("name",setOfTwoParam)] = bank-name + " " + char-div + " " +
		 	 	 			person.name-last + " " + person.first-names + " " + char-div. 
		 	 	 	ELSE
		 	 	 		preResult[LOOKUP("name",setOfTwoParam)] = bank-name + " " + char-div + " " +
		 	 	 			person.name-last + " " + person.first-names + " " + char-div + " " +
		 	 	 			DelDoubleChars(
			 	 	   		(IF person.address[1] = person.address[2] THEN person.address[1] ELSE person.address[1] + "," + person.address[2]),
			 	 	   		",") + " " + char-div.
			 	 	IF inn <> "" THEN 
		 	 	 		preResult[LOOKUP("name",setOfTwoParam)] = bank-name + " " + char-div + " " +
		 	 	 			person.name-last + " " + person.first-names + " " + char-div + " " +
		 	 	 			inn + " " + char-div.
		 	 	 END. /* Конец IF vContext */
				 
				 /** перевод без открытия счета внутренний */
		 	 	 IF vContext = "4" THEN DO:
	 	 	 		preResult[LOOKUP("name",setOfTwoParam)] = bank-name + " " + char-div + " " +
	 	 	 			person.name-last + " " + person.first-names + " " + char-div. 
			 	 	IF inn <> "" THEN 
		 	 	 		preResult[LOOKUP("name",setOfTwoParam)] = bank-name + " " + char-div + " " +
		 	 	 			person.name-last + " " + person.first-names + " " + char-div + " " +
		 	 	 			inn + " " + char-div.
		 	 	 END. /* Конец IF vContext */

		 	 	 preResult[LOOKUP("acct",setOfTwoParam)] = vAcct.
		 	 	 preResult[LOOKUP("inn",setOfTwoParam)] = inn.
			 END. /* Конец если acct.cust-cat = Ч */

				/**********************************************************
				 *							*
				 * В случае если оплата идет, через Банк                *
				 * нерезидент и сумма платежа больше 15 тыс.,           *
				 * то в поле плательщик обязательно  указание           *
				 * адреса плательщика.					*
				 *********************************************************
				 *							*
				 * Автор: Маслов Д. А. (Maslov D. A.)			*
				 * Дата создания: 10:10 17.02.2011			*
				 * Заявка: #638						*
				 *							*
				 ***********************************************************/
			 RUN internal-parser-getdetails-form-ttable (?,"opreq", "ben-acct", OUTPUT cBen-Acct).

			 cBankNerList = FGetSetting("PirChkOp","PirBankNerList","!*").

				IF amt-sum > point-sum THEN
					DO:
 					    IF CAN-DO(cBankNerList,cBen-Acct) THEN
						DO:
						   /*****************************
						    * Сумма проводки > 15 тыс,  *
						    * и счет получателя         *
						    * банк-нерезидент           *
						    *****************************/

						    oClient = new TClient(acct.acct).
						    
						       preResult[LOOKUP("name",setOfTwoParam)] = oClient:name-short + " " + char-div + oClient:address + char-div.
						       preResult[LOOKUP("acct",setOfTwoParam)] = vAcct.
						       preResult[LOOKUP("inn",setOfTwoParam)] = inn.

						    DELETE OBJECT oClient.

						END. /* Конец CAN-DO("30111*,30230*,30231*",cBen-Acct) */
					END. /* Конец amt-sub > point-sum */

				 /**************************************************
				  * Конец Заявки: #638                                      *
				  * **************************************************/

	 	 END.  /* Конец если найден счет */
	 ELSE
	 	 DO:
	 	 	 /*
	 	 	 MESSAGE "PirCAF_2281U(): сообщает: счет " + vAcct + " не найден либо он внутренний!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
	 	 	 */
	 	 	 is-ok = TRUE.
	 	 	 RUN Pars-SetCHARResult (""). 
	 	 	 RETURN.
	 	 END.
	 
	 vResult = preResult[LOOKUP(vField, setOfTwoParam)].
	 
	/*	 MESSAGE vField + " = '" + preResult[LOOKUP(vField, setOfTwoParam)] + "'" VIEW-AS ALERT-BOX. */
	 
	IF vResult = "" THEN vResult = ?.
	RUN Pars-SetCHARResult(vResult).

   is-ok = TRUE.
 
END PROCEDURE. /* PirCAF_2281U */


/*
  Что делает: Возвращает из двух один счет, который раньще всего использовался
              в текущем опер.дне. Если ни один счет не использовался в течение дня, 
              либо они использовались одновременно, то возвращается счет из первого 
              параметра.
  Синтаксис : PirFirstUsedAcctPerDay2 ( "47422*25", "47423*25", ДАТА() )
  Автор     : Бурягин Е.П.

*/

PROCEDURE PirFirstUsedAcctPerDay2:
    DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */
/* Проверка количества параметров */
    IF NOT Pars-ValidParam(3) THEN RETURN.
/* --- */
    DEFINE VARIABLE vAcct1 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vAcct2 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vDate AS DATE  NO-UNDO.
    DEFINE VARIABLE vResult AS CHARACTER  NO-UNDO.

    ASSIGN
        vAcct1 = Pars-GetString ( 0 )
        vAcct2 = Pars-GetString ( 1 )
        vDate = DATE(Pars-GetString( 2 ))
        .

    FIND FIRST op-entry 
    	 WHERE (
    	 		CAN-DO(vAcct1 + "," + vAcct2, op-entry.acct-db)
    	       	OR
    	       	CAN-DO(vAcct1 + "," + vAcct2, op-entry.acct-cr)
    	       ) AND op-entry.op-date = vDate
    	 NO-LOCK NO-ERROR.
   	IF AVAIL op-entry THEN DO:
   		IF CAN-DO(vAcct1, op-entry.acct-db) OR CAN-DO(vAcct1, op-entry.acct-cr) THEN
   			vResult = vAcct1.
   		ELSE 
   			vResult = vAcct2.   		
   	END. ELSE
   		vResult = vAcct1.

    RUN Pars-SetCHARResult (vResult).

/* --- */
    is-ok = TRUE.
END PROCEDURE.

PROCEDURE PirCeil:
					/************************************************
					 * 										              *
					 * Округляет до ближайшего сверху числа	              *
					 * с указанной точностью.					              *
					 * Автор: Маслов Д. А.					              *
					 * Дата создания: 15.09.2009				              *
					 * Пример: ceil(4.5,0) = 5; ceil(4.67,1) = 4.7;	              *
					 * ceil(4.6,1) = 4.6.							              *
					 * Параметры: (Что округляем, до скольки знаков)  *
					 *										              *
					 ************************************************/

     DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

     DEFINE VARIABLE vResult AS CHARACTER INITIAL "" NO-UNDO.

     DEFINE VARIABLE dWhat AS DECIMAL NO-UNDO.
     DEFINE VARIABLE iMeasure AS INTEGER NO-UNDO.

     DEFINE VARIABLE dTmp AS DECIMAL NO-UNDO.

    IF NOT Pars-ValidParam(2) THEN RETURN.

    dWhat = Pars-GetDec(0).
    iMeasure = Pars-GetDec(1).

     dTmp = dWhat - TRUNCATE(dWhat,iMeasure).

    /* Не стал использовать IF ради любопытства, как говориться чисто поржать */
     vResult  = STRING( TRUNCATE(dWhat + EXP(0.1,iMeasure) * INTEGER(LOGICAL(dTmp)),iMeasure)).   

    RUN Pars-SetCHARResult (vResult).
    is-ok = TRUE.
END PROCEDURE.
 
PROCEDURE pir_if:
/**
*	Если первый параметр отличен от пустой стрроки, то возвращается второй аргумент, иначе третий
*	Это аналог _if(), однако он не работает со строками, нельзя сравнить какую-нибудь строку с пустой строкой, например. 
*/
     DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

     DEFINE VARIABLE vResult AS CHARACTER INITIAL "".

     DEFINE VARIABLE expr AS CHAR NO-UNDO.
     DEFINE VARIABLE res1 AS CHAR NO-UNDO.
     DEFINE VARIABLE res2 AS CHAR NO-UNDO.

    IF NOT Pars-ValidParam(3) THEN RETURN.

    expr = TRIM(Pars-GetString(0)).
    IF expr = "0" THEN expr = "".
    res1 = TRIM(Pars-GetString(1)).
    IF res1 = "0" THEN res1 = "".
    res2 = TRIM(Pars-GetString(2)).
    IF res2 = "0" THEN res2 = "".

	vResult = (IF expr = "" THEN res2 ELSE res1).
	
    RUN Pars-SetCHARResult (vResult).
    is-ok = TRUE.
 END PROCEDURE.

/*
    * Что делает: Возвращает краткое наименование клиента.
    * Синтаксис : КлнтКр
    * Автор     : Om  16/10/00
    * Пример    : КлнтКр
    * На основе Клнтр() из details.fun
*/
PROCEDURE КлнтКр:

   DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */
   DEF VAR ph    AS HANDLE    NO-UNDO.
   DEF VAR name1 AS CHARACTER NO-UNDO.
   DEF VAR name2 AS CHARACTER NO-UNDO.
/*    DEF VAR Inn   AS CHARACTER NO-UNDO. */
   is-ok = FALSE.

   IF NOT Pars-ValidParam(0) THEN RETURN.

   /* Определение правильного применения функции,
   ** формат private-data */
   run LOAN_VALID_HANDLE (input-output ph).

   if not valid-handle (ph)
   then return.

   find first loan
      where loan.contract  eq entry(1, ph:private-data)
        and loan.cont-code eq entry(2, ph:private-data)
      no-lock no-error.
   if not avail loan then return.

   name2 = "".
   CASE loan.cust-cat:
      WHEN "Ю" THEN DO:
         FIND cust-corp
            WHERE cust-corp.cust-id EQ loan.cust-id
            NO-LOCK NO-ERROR.
         IF AVAIL cust-corp
         THEN name1 = cust-corp.name-short.
      END.
      WHEN "Ч" THEN DO:
         FIND FIRST person
            WHERE person.person-id EQ loan.cust-id
            NO-LOCK NO-ERROR.
         IF AVAIL person
         THEN name1 = person.name-last + " " + person.first-names.
      END.
      WHEN "Б" THEN DO:
         FIND banks
            WHERE banks.bank-id EQ loan.cust-id
            NO-LOCK NO-ERROR.
         IF AVAIL banks
         THEN name1 = banks.short-name.
      END.
   END CASE.

   name1 = TRIM(REPLACE(name1, "?", "")).

   IF name1 NE ""
   THEN DO:
      RUN Pars-SetCHARResult(   name1 +
                             IF name1 NE ""
                             THEN
                                (IF    SUBSTRING (name1,LENGTH(name1)) EQ '"'
                                    OR SUBSTRING (name1,LENGTH(name1)) EQ "'"
                                 THEN " "
                                 ELSE "")
                             ELSE "").

      ASSIGN
         result_l[pj - pn] = 0
         is-ok = TRUE
      .
   END.
   RETURN.

END PROCEDURE.

/*
    * Что делает: Возвращает оборот с учетом/безучета транзакций в параметре.
    * Синтаксис : CalcOborot(НомерСчета,"список транзакций",Дата)
    * Автор     : Kraskov  08/12/10
    *

*/
PROCEDURE CalcOborot:

   DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

   DEFINE VAR oTAcct       AS TAcct          NO-UNDO.
   DEFINE VAR cAcct        AS CHAR           NO-UNDO.
   DEFINE VAR cTransaction AS CHAR           NO-UNDO.
   DEFINE VAR vDate        AS DATE           NO-UNDO.
   DEFINE VAR Summ         AS DECIMAL INIT 0 NO-UNDO.

   IF NOT Pars-ValidParam(3) THEN RETURN.

   ASSIGN
   
      cAcct        = Pars-GetString ( 0 ).
      cTransaction = Pars-GetString ( 1 ).
      vDate = DATE(Pars-GetString( 2 )).

  
   oTAcct = new TAcct(cAcct).
   summ = oTAcct:calcOborot(vDate - 1,vDate,CHR(251),810,cTransaction).
   RUN Pars-SetResult (summ).
    is-ok = TRUE.

END PROCEDURE.

PROCEDURE GetLastWorkDay:
				/**********************************************************
				 * Функция возвращает последний			          *
				 * рабочий день.					  *
				 * В качестве параметров:				  *
				 *    1. dDate - дата, которая принадлежит,		  *
				 * текущему периоду.					  *
				 *    2. cPerType - тип периода. Может принимать          *
				 * значения: "Месяц",... пока только месяц.		  *
				 * Автор: Маслов Д. А.					  *
				 * Дата создания: 15:35 20.12.2010			  *
				 * Заявка: #555						  *
				 **********************************************************/

	DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO.

	DEF VAR dDate    AS DATE                         NO-UNDO.
	DEF VAR cPerType AS CHARACTER                    NO-UNDO.
	DEF VAR cFormat  AS CHARACTER INITIAL "%d.%m.%Y" NO-UNDO.

	DEF VAR oSysClass AS TSysClass NO-UNDO.
	
	oSysClass = new TSysClass().


		IF NOT Pars-ValidParam(3) THEN RETURN.

		ASSIGN
			dDate = DATE(Pars-GetString(0))
			cPerType = Pars-GetString(1)
			cFormat = Pars-GetString(2)
		.

	CASE cPerType:
			WHEN "Месяц" THEN
				DO:				
					RUN Pars-SetCharResult(oSysClass:DATETIME2STR(PrevWorkDay(LastMonDate(dDate) + 1),cFormat)).
				END.

			OTHERWISE RUN Pars-SetCharResult(oSysClass:DATETIME2STR(TODAY,cFormat)).
	END CASE.

	  is-ok = TRUE.
    DELETE OBJECT oSysClass.

END PROCEDURE.


PROCEDURE PirDateProc:                                                                  

				/************************************************************
				 * Функция возвращает день с коротого уплачиваются проценты *
				 * по частному вкладу					    *
				 * В качестве параметров:				    *
				 *    1. Loan - номер договора частного вклада		    *
				 *    2. dOpDate - дата начисления процентов     	    *
                                 *                                                          *
			 	 * Автор: Красков А.С.					    *
				 * Дата создания: 28.12.2010			 	    *
				 * Заявка: #280						    *
				 ************************************************************/

  DEF VAR dProcentDate AS Date    NO-UNDO.
  DEF VAR dTempDate    AS Date    NO-UNDO.
  DEF VAR Loan         AS Char    NO-UNDO.
  DEF VAR dOpDate      AS Date    NO-UNDO.
  DEF VAR iTempInt     AS Integer NO-UNDO.

  DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

  IF NOT Pars-ValidParam(2) THEN RETURN.
  
   ASSIGN
   
      Loan    = Pars-GetString ( 0 )
      DOpDate = DATE(Pars-GetString( 1 )).

  find last loan-cond where loan-cond.cont-code = loan and since <= dOpDate.
  iTempInt = dOpdate - Date(01,01,year(dOpDate)).
  
  IF loan-cond.int-period = "Кс" THEN dTempDate = loan-cond.since + 1.  /* в конце срока */
  IF loan-cond.int-period = "Г" THEN dTempDate = Date(01,01,year(dOpDate)).  /* ежегодно */
  IF (loan-cond.int-period = "К") OR (loan-cond.int-period = "КК") THEN  /* ежеквартально */
     DO:
        IF iTempInt < 90 THEN dTempDate = Date(01,01,year(dOpDate)). /* первый квартал */
           ELSE                                 
           DO:
           IF iTempInt < 181 THEN dTempDate = Date(04,01,year(dOpDate)). /* второй квартал */
           ELSE 
              DO:
              IF iTempInt <273 THEN dTempDate = Date(07,01,year(dOpDate)). /* третий квартал */
              ELSE dTempDate = Date(10,01,year(dOpDate)).                  /* четвертый квартал */
              END.
           END.
     END.
 
	/* #3197  не знаю с каким умылом но кто-то указал дважды период латинскими буквами = КМ 
	   Сделал только нормальный русский вариант */
   IF (loan-cond.int-period = "КМ") OR (loan-cond.int-period = "М") THEN /* в конце месяца */
     DO:
        dTempDate = Date(Month(dOpDate),01,year(dOpDate)).
     END.

   IF loan-cond.int-period = "ПГ" then
     DO:
        IF Month(dOpDate) >= 6 THEN dTempDate = Date(06,01,year(dOpDate)).
        ELSE dTempDate = Date(01,01,year(dOpDate)).
     END.      

  dProcentDate = MAXIMUM(dTempDate,loan-cond.since + 1).
  
  RUN Pars-SetCHARResult (string(dProcentDate,"99/99/9999")).

  is-ok = TRUE.

END PROCEDURE.



PROCEDURE PirReplace:                                                                  

				/************************************************************
				 * Заменяет символы из второго параметра на символы из 3ого *
				 * параметра в строке из первого параметра.                 *
				 * В качестве параметров:				    *
				 *    1. cStr - исходная строка;		            *
				 *    2. c2Replace - что меняем;     	                    *
				 *    3. cResStr - на что меняем.                           *
                                 *                                                          *
			 	 * Автор: Маслов Д.А.					    *
				 * Дата создания: 30.12.2010			 	    *
				 * Заявка: #538						    *
				 ************************************************************/

  DEF VAR cStr        AS CHARACTER NO-UNDO.
  DEF VAR c2Replace   AS CHARACTER NO-UNDO.
  DEF VAR c4Replace   AS CHARACTER NO-UNDO.

  DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

  IF NOT Pars-ValidParam(3) THEN RETURN.

  cStr      = Pars-GetString(0).
  c2Replace = Pars-GetString(1).
  c4Replace   = Pars-GetString(2).

  RUN Pars-SetCHARResult(REPLACE(cStr,c2Replace,c4Replace)).

  is-ok = TRUE.
  
END PROCEDURE.

PROCEDURE PirMaxDate:
				/*********************************************
				 * Функция выводит максимальную из двух дат. *
				 * В качестве параметров:                    *				 
				 *    1. cDate1 - дата номер №1;             *
				 *    2. cDate2 - дата номер №2;             *
				 * Даты должны быть в формате дд/мм/гггг.    *
				 *                                           *
				 * Автор: Маслов Д. А.                       *
				 * Дата создания: 25.01.11                   *
				 * Заявка: #597                              *
				 *********************************************/

  DEF VAR dDate1      AS DATE NO-UNDO.
  DEF VAR dDate2      AS DATE NO-UNDO.

  DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

  IF NOT Pars-ValidParam(2) THEN RETURN.

  dDate1 = DATE(Pars-GetString(0)).
  dDate2 = DATE(Pars-GetString(1)).

  RUN Pars-SetCHARResult(STRING(MAXIMUM(dDate1,dDate2))).

  is-ok = TRUE.

END PROCEDURE.

PROCEDURE PirPeriodProc:                                                                  

				/************************************************************
				 * Функция возвращает период уплаты проценты                *
				 * по частному вкладу					    *
				 * В качестве параметров:				    *
				 *    1. Loan - номер договора частного вклада		    *
				 *    2. dOpDate - дата начисления процентов     	    *
                                 *                                                          *
			 	 * Автор: Красков А.С.					    *
				 * Дата создания: 11.03.2010			 	    *
				 * Заявка: #653						    *
				 ************************************************************/

  DEF VAR dProcentDate AS Date NO-UNDO.
  DEF VAR dTempDate    AS Date NO-UNDO.

  DEF VAR dStartDate   AS Date NO-UNDO.
  DEF VAR dEndDate     AS Date NO-UNDO.
  DEF VAR dLoanEndDate AS Date NO-UNDO.
 
  DEF VAR dtemp    AS date    NO-UNDO.
  DEF VAR cLoan    AS Char    NO-UNDO.
  DEF VAR dOpDate  AS Date    NO-UNDO.
  DEF VAR iTempInt AS Integer NO-UNDO.
  DEF BUFFER bLoan for loan.

  DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

  IF NOT Pars-ValidParam(2) THEN RETURN.
  
   ASSIGN
   
      cLoan    = Pars-GetString ( 0 )
      DOpDate = DATE(Pars-GetString( 1 )).

  find last loan-cond where loan-cond.cont-code = cloan and since <= dOpDate NO-LOCK NO-ERROR. 
  find last bloan where bloan.cont-code = cloan NO-LOCK NO-ERROR.

 	/*
           dEndDate = DYNAMIC-FUNCTION("LastMonDate" IN h_date,Date(Month(dOpDate) - 1,01,year(dOpDate))).
	*/

  dendDate = DATE(Month(dOpDate),01,year(dOpDate)) - 1.


  if (day(dOpDate) > 10) then dendDate = DYNAMIC-FUNCTION("LastMonDate" IN h_date,dOpDate).
   if (NOT AVAILABLE(Loan-cond)) OR (NOT AVAILABLE(bloan)) Then message cloan view-as alert-box.
   dLoanEndDate = bloan.end-date.


   IF (loan-cond.int-period = "Кс")  THEN /* в конце срока */
     DO:
        dStartDate = bloan.open-date + 1.
	dEndDate = bloan.end-date. 
     END.


   IF (loan-cond.int-period = "М") THEN /* ежемесячно */
     DO:
	if Month(dOpDate) <> 1 then 
	do:
           dEndDate = DYNAMIC-FUNCTION("LastMonDate" IN h_date,Date(Month(dOpDate) - 1,01,year(dOpDate))).
           dStartDate = MAXIMUM(Date(Month(dOpDate) - 1,01,year(dOpDate)),bloan.open-date + 1).
        end.
        else
        do:
           dStartDate = MAXIMUM(Date(12,01,year(dOpDate) - 1),bloan.open-date + 1).
        end.
     END.


   IF (loan-cond.int-period = "КМ") THEN /* в конце месяца */
     DO:
	if Month(dOpDate) <> 1 then 
	do:
          dEndDate = DYNAMIC-FUNCTION("LastMonDate" IN h_date,Date(Month(dOpDate),01,year(dOpDate))).
          dStartDate = MAXIMUM(Date(Month(dOpDate),01,year(dOpDate)),bloan.open-date + 1).
        end.
        else
        do:
           dStartDate = MAXIMUM(Date(12,01,year(dOpDate) - 1),bloan.open-date + 1).
        end.
     END.

   IF (loan-cond.int-period = "КМ[3]") THEN 
     DO:
	if Month(dOpDate) <> 1 then 
	do:
          dEndDate = dOpDate . 
          dStartDate = MAXIMUM( Date(Month(dOpDate) - 3, DAY(bloan.open-date) + 1, year(dOpDate)), bloan.open-date + 1). 
        end.
        else
           dStartDate = MAXIMUM(Date(12,01,year(dOpDate) - 1),bloan.open-date + 1).
     END.


  IF loan-cond.int-period = "Г" THEN dStartDate = Date(01,01,year(dOpDate) - 1).  /* ежегодно */

  IF ((loan-cond.int-period = "К") OR (loan-cond.int-period = "КК")) and (Day(dOpDate) <= 10) THEN  /* ежеквартально */
     DO:

        iTempInt = DATE(Month(dOpdate),01,year(dOpDate)) - Date(01,01,year(dOpDate)) - 1.

        if iTempInt <0 then do: 
	 iTempInt = 274.
        /*************************
         * По заявке #823
         * В случае если начисление %
         * ведется в январе,
         * то проценты начисляем за 4
         * квартал предыдущего года.
         * Иначе делаем все остальные
         * телодвижения.
         *************************
	 * В этой ветке, типа и обрабатывается
	 * начало года.
         *************************/
	 dOpDate  = Date(10,01,year(dOpDate) - 1).
	 dEndDate = DATE(12,31,YEAR(dOpDate) - 1).
	end.


        IF iTempInt < 90   THEN dTempDate = Date(01,01,year(dOpDate)). /* первый квартал */
           ELSE                                 
           DO:
           IF iTempInt < 181 THEN dTempDate = Date(04,01,year(dOpDate)). /* второй квартал */
           ELSE 
              DO:
              IF iTempInt <273 THEN dTempDate = Date(07,01,year(dOpDate)). /* третий квартал */
              ELSE dTempDate = Date(10,01,year(dOpDate)).                  /* четвертый квартал */
              END.
           END.
/*        END.*/

/*         message dTempDate dStartDate denddate VIEW-AS ALERT-BOX.*/

         IF dEndDate = ? THEN dEndDate = DYNAMIC-FUNCTION("LastMonDate" IN h_date,Date(Month(dOpDate) - 1,01,year(dOpDate))).      
   if dLoanEndDate <> ? then 
	 dEndDate = MINIMUM(dEndDate,dLoanEndDate).


         dStartDate = MAXIMUM(dTempDate,bloan.open-date + 1). 
     END.

   if ((loan-cond.int-period = "К") OR (loan-cond.int-period = "КК")) and (loan-cond.int-date > 10) and (Day(dOpDate) >= 10)  THEN  /* ежеквартально */
       DO:
	iTempInt = dOpdate - Date(01,01,year(dOpDate)).
/*	message iTempInt VIEW-AS ALERT-BOX.*/
        IF iTempInt < 90 THEN dTempDate = Date(01,01,year(dOpDate)). /* первый квартал */
           ELSE                                 
           DO:
           IF iTempInt < 181 THEN dTempDate = Date(04,01,year(dOpDate)). /* второй квартал */
           ELSE 
              DO:
              IF iTempInt <273 THEN dTempDate = Date(07,01,year(dOpDate)). /* третий квартал */
              ELSE dTempDate = Date(10,01,year(dOpDate)).                  /* четвертый квартал */
              END.
           END.
         dStartDate = MAXIMUM(dTempDate,bloan.open-date + 1). 

         dEndDate = DYNAMIC-FUNCTION("LastMonDate" IN h_date,Date(Month(dOpDate) - 1,01,year(dOpDate))).

         dendDate = DATE(Month(dOpDate),01,year(dOpDate)) - 1.
         if dLoanEndDate <> ? then 
	 dEndDate = MINIMUM(dEndDate,dLoanEndDate).        

              
     END.                                                  

   IF loan-cond.int-period = "ПГ" then
     DO:
        IF Month(dOpDate) >= 6 THEN dTempDate = Date(01,01,year(dOpDate)).
        ELSE dTempDate = Date(06,01,year(dOpDate)).
        dStartDate = MAXIMUM(dTempDate,loan.open-date + 1). 
     END.      
                                                                             

/*      if dEnddate = 01/31/12 then dEnddate = 12/31/11.*/
      if dEnddate = 01/31/11 then dEnddate = 12/31/11.
      if dEndDate < dStartDate then dEndDate = Date(Month(dEndDate),Day(dEndDate),year(dEndDate) + 1).
/* от этого параноидального бреда надо избавляться
      if cLoan = "42307810400000735978" OR cLoan = "42307810400000735979" then do:
       dEndDate = 01/24/11.
       dStartDate = 10/23/11.
      end.*/
  RUN Pars-SetCHARResult (string(dStartDate,"99/99/9999") + "-" + string(dEndDate,"99/99/9999")).

  is-ok = TRUE.

END PROCEDURE.


PROCEDURE PirPeriodDonProc:  

				/************************************************************
				 * Функция возвращает период доначисления процентов         *
				 * по частному вкладу					    *
				 * В качестве параметров:				    *
				 *    							    *
				 *    1. Loan - номер договора частного вклада		    *
				 *    2. dOpDate - дата начисления процентов     	    *
                                 *                                                          *
			 	 * Автор: Красков А.С.					    *
				 * Дата создания: 25.05.2010			 	    *
				 * Заявка: #653						    *
				 ************************************************************/
  DEF VAR dStartDate AS Date NO-UNDO.
  DEF VAR dEndDate   AS Date NO-UNDO.
  DEF VAR cLoan      AS Char NO-UNDO.
  DEF VAR dOpDate    AS Date NO-UNDO.


  DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

  IF NOT Pars-ValidParam(2) THEN RETURN.
  
   ASSIGN
   
      cLoan    = Pars-GetString ( 0 )
      DOpDate = DATE(Pars-GetString( 1 )).


  find last loan where loan.cont-code = cloan NO-LOCK NO-ERROR.

        dStartDate = Date(Month(dOpDate),01,Year(dOpDate)).

         dEndDate = DYNAMIC-FUNCTION("LastMonDate" IN h_date,Date(Month(dOpDate),Day(dOpDate),year(dOpDate))).


        if loan.end-date <> ? then 
   	  dEndDate = MINIMUM(dEndDate,loan.end-date).

  RUN Pars-SetCHARResult (string(dStartDate,"99/99/9999") + "-" + string(dEndDate,"99/99/9999")).

  is-ok = TRUE.

END PROCEDURE.                                                                

PROCEDURE PirDoverDate:
				/************************************************************
				 * Функция возвращает дату начала действия доверенности     *
				 * по счету физического лица				    *
				 * В качестве параметров:				    *
				 *    							    *
				 *    1. cAcct - номер cчета                                 *
				 *    2. cClient - кому выдана доверенность                 *
				 *    2. cOpDate - дата 			     	    *
				 *    4. iType - тип вывода(in-полный текст содержания взнос *
                                 *                          out-полный текст содержания выдача*
				 *			    dov-только доверенность           *
			 	 * Автор: Красков А.С.					    *
				 * Дата создания: 28.06.2010			 	    *
				 * Заявка: #690						    *
				 * Модификация: #3679 Sitov S.A.			    *	
				 ************************************************************/

  DEF VAR cAcct          AS Char          NO-UNDO.
  DEF VAR cClient        AS Char          NO-UNDO.
  DEF VAR cOpDate        AS Date          NO-UNDO.
  DEF VAR iType          AS CHAR          NO-UNDO.
  DEF VAR cDover         AS Char INIT ""  NO-UNDO.
  DEF VAR cAcctOwner     AS Char INIT ""  NO-UNDO.
  DEF VAR cTemp          AS Char INIT ""  NO-UNDO.
  DEF OUTPUT PARAM is-ok AS LOGICAL       NO-UNDO. /* успешно ли выполнена ? */

  IF NOT Pars-ValidParam(4) THEN RETURN.
  
  ASSIGN
   
      cAcct   = Pars-GetString ( 0 )
      cClient = Pars-GetString ( 1 )	
      cOpDate = DATE(Pars-GetString( 2 ))
      iType = Pars-GetString( 3 )
  .                                  


  FIND FIRST acct WHERE acct.acct = cAcct NO-LOCK NO-ERROR.
  FIND FIRST person WHERE person.person-id =  acct.cust-id NO-LOCK NO-ERROR.
  IF AVAILABLE (person) THEN
	cAcctOwner = person.name-last + " " + person.first-names.


	/* Определяем, нужно ли проверять доверенность */
  IF acct.cust-cat = "Ч"  AND  TRIM(cClient) <> TRIM(cAcctOwner) 
	AND  (cClient <> ? AND cClient <> "" AND cClient <> "0" ) 
  THEN 
  DO:
	RUN pir-proxy-check.p( cAcct , cClient , cOpDate , OUTPUT cDover ) .  /* проверять нужно !*/
	IF cDover = "" THEN 
	DO:
	  MESSAGE COLOR WHITE/RED "НЕТ ДОВЕРЕННОСТИ ДЛЯ ДАННОГО КЛИЕНТА" VIEW-AS ALERT-BOX .
	END.
  END.


  IF iType = "in" THEN 
	cTemp = "Взнос денежных средств на " + ( IF acct.currency = "" THEN "рублевый" ELSE "валютный" ) + " счет клиента " .

  IF iType = "out" THEN 
  DO:
	IF acct.acct MATCHES '47422........050....' THEN
	  cTemp = "Возврат денежных средств после закрытия карточного счета." .
	ELSE
	  cTemp = "Выдача денежных средств с " + ( IF acct.currency = "" THEN "рублевого" ELSE "валютного" ) + " счета клиента " .

	IF (cDover <> "" OR cDover <> " ")  THEN 
          cTemp = cTemp + cAcctOwner .
  END.

  IF iType <> "dov" THEN 
	cDover = cTemp + " " + cDover.

  IF cDover = "" THEN cDover = " ".
  RUN Pars-SetCHARResult(cDover).
  is-ok = TRUE.

END PROCEDURE.

PROCEDURE PirAcctCom:

				/************************************************************
				 * Функция возвращает номер счета клиента для взимания      *
				 * комиссии по операции по счету 40821			    *
				 * В качестве параметров:				    *
				 *    							    *
				 *    1. Acct - номер cчета                                 *
				 *    2. dOpDate - дата 			     	    *
				 *     							    *
                                 *                                                          *
				 *			                                    *
			 	 * Автор: Красков А.С.					    *
				 * Дата создания: 29.09.2011			 	    *
				 * Заявка: #763						    *
				 ************************************************************/ 
  DEF VAR cAcct    AS Char         NO-UNDO.
  DEF VAR cAcctKom AS Char INIT "" NO-UNDO.
  DEF VAR dOpDate  AS Date         NO-UNDO.
  DEF var oAcct    AS TAcctBal     NO-UNDO.
  DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

  IF NOT Pars-ValidParam(2) THEN RETURN.
  
   ASSIGN
   
      cAcct   = Pars-GetString ( 0 )
      dOpDate = DATE(Pars-GetString ( 1 )).


       oAcct = NEW TAcctBal(cAcct).
         cAcctKom = oAcct:getAlias40821(dOPDate).
       DELETE OBJECT oAcct.

       RUN Pars-SetCHARResult(cAcctKom).
       
  is-ok = TRUE.

END PROCEDURE.  

/*PROCEDURE PirFreeCash:
				/*********************************************
				 * Функция возвращает сумму денежных средств *
                                 * доступных выдачи			     *
				 * В качестве параметров:                    *				 
				 *    1. cAcct - номер счета клиента;        *
				 *    2. cDate - дата;                       *
				 *   					     *
				 *                                           *
				 * Автор: Красков А.С.                       *
				 * Дата создания: 12.05.11                   *
				 * Заявка: #690                              *
				 *********************************************/

  DEF VAR cAcct      AS CHAR NO-UNDO.
  DEF VAR dDate      AS DATE NO-UNDO.
  
  def var ofunc as tfunc NO-UNDO.
  DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

  IF NOT Pars-ValidParam(2) THEN RETURN.

  cAcct = Pars-GetString(0).
  dDate = DATE(Pars-GetString(1)).

  oFunc = new tfunc().

 RUN Pars-SetCHARResult(oFunc:getFreeCash(cAcct,dDate)).

  is-ok = TRUE.

END PROCEDURE.                       */

PROCEDURE PirLoanProcDate:
				/*********************************************
				 * Функция возвращает дату начала расчета    *
                                 * процентов по договору ПК 		     *
				 * В качестве параметров:                    *				 
				 *    1. cLoan - номер договора;             *
				 *    2. dDate - дата;                       *
				 *    3. iParam - начисленые/текущие проценты*
				 *                                           *
				 * Автор: Красков А.С.                       *
				 * Дата создания: 05.03.12                   *
				 * Заявка: #860                              *
				 *********************************************/

  DEF VAR cLoan      AS CHAR NO-UNDO.
  DEF VAR dDate      AS DATE NO-UNDO.
  DEF VAR iParam     AS INTEGER NO-UNDO.  
  def var begdate as date NO-UNDO.
  DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

  IF NOT Pars-ValidParam(3) THEN RETURN.

  cloan = Pars-GetString(0).
  dDate = DATE(Pars-GetString(1)).
  iParam = Pars-GetInt ( 2 ).
  find first loan where loan.contract = "Кредит" and loan.cont-code = cloan NO-LOCK NO-ERROR.
  if AVAILABLE(loan) then do:
  begdate = loan.open-date + 1.

CASE iParam:
         WHEN 1 THEN DO:
	  FIND LAST loan-int
		WHERE loan-int.cont-code = loan.cont-code
		  AND loan-int.contract = loan.contract
		  AND loan-int.mdate >= loan.open-date 
		  AND loan-int.mdate <= dDate 
		  AND (loan-int.id-d = 6) /* НАЧ=6 И СП=4 ЭТО ОПЕРАЦИЯ 9 */
		  AND (loan-int.id-k = 4)
		NO-LOCK NO-ERROR.
        END.	
        WHEN 2 THEN DO:
	  FIND LAST loan-int
		WHERE loan-int.cont-code = loan.cont-code
		  AND loan-int.contract = loan.contract
		  AND loan-int.mdate >= loan.open-date 
		  AND loan-int.mdate <= dDate 
		  AND (((loan-int.id-d = 6) AND (loan-int.id-k = 4)) /* НАЧ=6 И СП=4 ЭТО ОПЕРАЦИЯ 9 */
		  OR ((loan-int.id-d = 32) AND (loan-int.id-k = 4)))
		NO-LOCK NO-ERROR.
        END.
        WHEN 3 THEN DO:
	  FIND LAST loan-int
		WHERE loan-int.cont-code = loan.cont-code
		  AND loan-int.contract = loan.contract
		  AND loan-int.mdate >= loan.open-date 
		  AND loan-int.mdate <= dDate 
		  AND ((loan-int.id-d = 26) AND (loan-int.id-k = 8)) /* НАЧ=26 И СП=8 ЭТО ОПЕРАЦИЯ 126 */
		NO-LOCK NO-ERROR.
	  if NOT AVAILABLE(loan-int) then begdate = loan.end-date + 1. 
       END.
END CASE.
       
 if AVAILABLE(loan-int) then begdate = loan-int.mdate + 1.
 end.
 RUN Pars-SetCHARResult(STRING(begdate)).

  is-ok = TRUE.

END PROCEDURE.       

/**************************************
 * Возвращает сумму                   *
 * к списанию с учетом                *
 * ТНГ и ТВГ.                         *
 **************************************
 *                                    *
 * Автор: Маслов Д. А. Maslov D. A.   *
 * Дата создания: 13.02.12            *
 * Заявка:#865                        *
 *                                    *
 **************************************/

PROCEDURE PirComm:
    DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO.    

    IF NOT Pars-ValidParam(4) THEN RETURN.

    DEF VAR vSumm     AS DEC   NO-UNDO.
    DEF VAR vCommName AS CHAR  NO-UNDO.
    DEF VAR vAcct     AS CHAR  NO-UNDO.
    DEF VAR vCurrency AS CHAR  NO-UNDO. 


    DEF VAR vDate     AS DATE    NO-UNDO.
    DEF VAR vPeriod   AS INT64   NO-UNDO.
    DEF VAR vFilialId AS CHAR    NO-UNDO.

    DEF VAR dRes      AS DECIMAL NO-UNDO.
    DEF VAR minSumm   AS DECIMAL NO-UNDO.
    DEF VAR maxSumm   AS DECIMAL NO-UNDO.

   ASSIGN
    vSumm     = DECIMAL(Pars-GetString(0))
    vCommName = Pars-GetString(1)
    vAcct     = Pars-GetString(2)
    vCurrency = Pars-GetStringFormatted(3, "999")
    vCurrency = ( IF vCurrency EQ vNatCurrChar THEN "" ELSE vCurrency)
    vPeriod   = 0
    vDate     = in-op-date
    vFilialId = ShFilial

   .
     
   RUN GetCommDesc IN h_comm(vCommName,vAcct,vCurrency,vSumm,"",vPeriod,vDate,vFilialId,BUFFER comm-rate) NO-ERROR.

/*  
   FIND LAST comm-rate where comm-rate.commission = vCommName 
                         and comm-rate.acct = vAcct 
			 and comm-rate.currency = vCurrency
		         and comm-rate.min-value <= vSumm
			 and comm-rate.Period = vPeriod
			 and comm-rate.since <= vDate
			 and comm-rate.filial-id = vFilialId     
	                 NO-LOCK NO-ERROR.
*/

   IF NOT AVAILABLE(comm-rate) then MESSAGE "Ошибка работы функции PirComm, не найдена запись в таблице comm-rate!" VIEW-AS ALERT-BOX.


   minSumm = DECIMAL(getXAttrValueEx("comm-rate",GetSurrogateBuffer("comm-rate",BUFFER comm-rate:HANDLE),"МинЗнач","0")).

   maxSumm = DECIMAL(getXAttrValueEx("comm-rate",GetSurrogateBuffer("comm-rate",BUFFER comm-rate:HANDLE),"МаксЗнач","-1")).

   dRes = IF comm-rate.rate-fixed THEN  comm-rate.rate-comm ELSE (comm-rate.rate-comm / 100) * vSumm.

   IF dRes < minSumm                 THEN dRes = minSumm.
   IF dRes > maxSumm AND maxSumm > 0 THEN dRes = maxSumm.
 
   RUN Pars-SetResult(dRes).

   is-ok = TRUE.

  RETURN.
END PROCEDURE.


PROCEDURE PirTarifComm:
				/*********************************************
				 * Функция возвращает размер комисси по счету*
                                 * клиента                                   *
				 * по тарифному плану                        *				 
				 *    1. cAcct   - номер счета клиента;      *
				 *    2. dSumm - код транзакции;            *
				 *    3. dDate - Дата опердня;		     *
				 *                                           *
				 * Автор: Красков А.С.                       *
				 * Дата создания: 28.02.13                   *
				 * Заявка: #                                 *
				 *********************************************/

  DEF VAR cAcct      AS CHAR NO-UNDO.
  DEF VAR cCur      AS CHAR NO-UNDO.
  DEF VAR dSumm    AS DEC NO-UNDO.
  DEF VAR dDate      AS DATE NO-UNDO.
  Def var outComm As dec no-UNDO.
  def var oTarif as TTarif NO-UNDO.

  DEF VAR str AS CHAR NO-UNDO. 



  DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

  IF NOT Pars-ValidParam(4) THEN RETURN.

  cAcct = Pars-GetString(0).
  dSumm = Pars-GetDec(1).
  dDate = DATE(Pars-GetString(2)).
  cCur = Pars-GetString(3).

  oTarif = new TTarif(cAcct,dDate).

  str = DYNAMIC-FUNCTION("GetCallOpkind" IN h_pbase,1,"OPKIND"). 

   find last wop where wop.op-kind eq str no-lock no-error. /* ищем в таблице-буфере создаваемых документов */ 

    if available wop then str = str + "," + STRING(wop.op-templ). 

   outComm = oTarif:GetCommission(str,dSumm,cCur,dDate).
 
  RUN Pars-SetResult(outComm).

  is-ok = TRUE.

END PROCEDURE.                       

/*********************************************************
 * Функция выводит на экран меню.                        *
 * Затем возвращает выбор пользователя                   *
 * назад в транзакцию.                                   *
 * @var CHARACTER caption Заголовок окна;                *
 * @var CHARACTER details Строка с пунктами              *
 * меню, запятая отделяет один пункт от другого.         *
 * @var CHARACTER type что будет возвращать назад        *
 * если key, то индекс, если value, то текст меню.       *
 * @result CHARACTER выбранный пользователем             *
 * пункт.                                                *
 *********************************************************
 *
 * Автор: Маслов Д. А. Maslov D. A.
 * Дата: 18.05.12
 * Заявка: #969
 **********************************************************/

PROCEDURE PirShowMenu:

  DEF VAR cMenuInfo AS CHARACTER NO-UNDO.
  DEF VAR caption   AS CHARACTER NO-UNDO.
  DEF VAR details   AS CHARACTER NO-UNDO.
  DEF VAR type      AS CHARACTER NO-UNDO.

  DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

  IF NOT Pars-ValidParam(3) THEN RETURN.

  caption = Pars-GetString(0).
  details = Pars-GetString(1).

  cMenuInfo = caption + "|" + details.


  RUN Fill-SysMes IN h_tmess ("","",3,cMenuInfo).

  IF type="key" THEN DO:
     RUN Pars-SetCHARResult(pick-value).
  END. ELSE DO:
     RUN Pars-SetCHARResult(ENTRY(INT(pick-value),details,",")).
  END.
  is-ok = TRUE.

END PROCEDURE.

/*****************************************
* Функция расчитывает сумму модернизации *
* для карточки ОС.                       *
* используется в модуле УМЦ              *
*                                        *
* Автор: Красков А.С.                    *
* Заявка: #957                           *
******************************************/

PROCEDURE СуммМодернизации:
   DEFINE var iDate   AS DATE     NO-UNDO.
   DEFINE var RESULT  AS DECIMAL  NO-UNDO.
   DEFINE var iContCode  AS CHARACTER  NO-UNDO.
   DEFINE var iContract  AS CHARACTER INIT "ОС" NO-UNDO.

   DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

   IF NOT Pars-ValidParam(2) THEN RETURN.

   iContCode = Pars-GetString(0).
   iDate = DATE(Pars-GetString(1)).
   iContract = ENTRY(1,iContCode).
   iContCode = ENTRY(2,iContCode).
   DEF VAR tempresult as DECIMAL INIT 0 NO-UNDO.

   find last loan-acct where loan-acct.contract = iContract 
			 and loan-acct.cont-code = iContCode 
	                 and loan-acct.acct-type = "ОС-учет"
			 NO-LOCK NO-ERROR.


  if available loan-acct then
   do:

      for each op where op.op-kind = "7012b2t+" and
   	 	        op.op-date >= FirstMonDate(GoMonth(iDate,-1)) and
	                op.op-date <= LastMonDate(GoMonth(iDate,-1))
	                NO-LOCK,
      first op-entry where op.op = op-entry.op and 
			op-entry.acct-db = loan-acct.acct NO-LOCK.

            tempresult = tempresult + op-entry.amt-rub.
      end.
   end.
   RESULT = tempresult.
   RUN Pars-SetResult(RESULT).
   is-ok = TRUE.

END PROCEDURE.

/*****************************************
* Функция возвращает группу амортизации  *
* по карточке УМЦ                        *
*                                        *
*                                        *
* Автор: Красков А.С.                    *
* Заявка: #1091                          *
******************************************/

PROCEDURE ПирГруппаАмортизации:
   DEFINE var iAcct       AS CHARACTER NO-UNDO.
   DEFINE var iAcct-type  AS CHARACTER NO-UNDO.
   DEFINE var iContract   AS CHARACTER NO-UNDO.
   DEFINE var cRESULT      AS CHARACTER NO-UNDO.
   DEFINE BUFFER loan FOR loan.
   DEFINE BUFFER asset FOR asset.



   DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */

   IF NOT Pars-ValidParam(3) THEN RETURN. 


   iAcct = Pars-GetString(0).
   iAcct-type = Pars-GetString(1).
   iContract = Pars-GetString(2).


   find last loan-acct where loan-acct.contract = iContract 
	                 and loan-acct.acct-type = iAcct-type
	                 and loan-acct.acct = iAcct
			 NO-LOCK NO-ERROR.


  if available loan-acct then
    do:
           FOR FIRST loan WHERE
             loan.contract  EQ loan-acct.contract
         AND loan.cont-code EQ loan-acct.cont-code
      NO-LOCK,
      FIRST asset OF loan NO-LOCK
      :
      cRESULT = GetXattrValue("asset",
                                 GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)),
                                  "AmortGr"
                                 ).
   END.

    end.
  else
   do:
	Message COLOR WHITE/RED "ОШИБКА РАБОТЫ ФУНКЦИИ ПирГруппаАмортизации" VIEW-AS ALERT-BOX.
   end.

   RUN Pars-SetCHARResult(cRESULT).
   is-ok = TRUE.

END PROCEDURE.

/***********************************
 * 
 * Процедура проверяет наличие индивидуальной
 * комиссии по счету и если такая есть,
 * то выводит true, иначе Ложь.
 * @param CHAR acct Номер счета по которому
 * проверяем наличие индивидуальной комиссии.
 * @param CHAR kName Наименование тарифа.
 * @param DEC dSum   Сумма операции
 * @param CHAR currency  Валюта операции
 * @result LOGICAL
 *
 ************************************
 *
 * Автор         :  Маслов Д. А. Maslov D. A.
 * Заявка        :  #1195
 * Дата создания : 08.08.12
 *
 ************************************/


PROCEDURE hasOwnComm:
   DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */



    DEF VAR vSumm     AS DEC   NO-UNDO.
    DEF VAR vCommName AS CHAR  NO-UNDO.
    DEF VAR vAcct     AS CHAR  NO-UNDO.
    DEF VAR vCurrency AS CHAR  NO-UNDO. 
    DEF VAR cRes      AS CHAR  NO-UNDO.

    DEF VAR vDate     AS DATE    NO-UNDO.
    DEF VAR vPeriod   AS INT64   NO-UNDO.
    DEF VAR vFilialId AS CHAR    NO-UNDO.

    DEF BUFFER commission FOR commission.


   IF NOT Pars-ValidParam(4) THEN RETURN.


   ASSIGN
    vSumm     = DECIMAL(Pars-GetString(0))
    vCommName = Pars-GetString(1)
    vAcct     = Pars-GetString(2)
    vCurrency = Pars-GetStringFormatted(3, "999")
    vCurrency = ( IF vCurrency EQ vNatCurrChar THEN "" ELSE vCurrency)
    vPeriod   = 0
    vDate     = in-op-date
    vFilialId = ShFilial

   .
        
   cRes = "0".

   RUN GetCommDesc IN h_comm(vCommName,vAcct,vCurrency,vSumm,"",vPeriod,vDate,vFilialId,BUFFER comm-rate) NO-ERROR.

   IF AVAILABLE(comm-rate) THEN DO:
      IF (comm-rate.acct <> "0") THEN DO:
	  cRes = "1".
      END.
   END. 

   RUN Pars-SetCHARResult(cRes).
   is-ok = TRUE.    
END PROCEDURE.

/**
 *
 **/
PROCEDURE PirCANDO:
   DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */
   DEF VAR cMask  AS CHAR NO-UNDO.
   DEF VAR cValue AS CHAR NO-UNDO.
   DEF VAR cRes   AS CHAR NO-UNDO.

   IF NOT Pars-ValidParam(2) THEN RETURN.

   cMask  = Pars-GetString(0).
   cValue = Pars-GetString(1).

   cRes = STRING(CAN-DO(cMask,cValue)).

   RUN Pars-SetCHARResult(cRes).
   is-ok = TRUE.    

END PROCEDURE.

/**
 * Метод возвращает значение дополнительного
 * реквизита на дату.
 **/
PROCEDURE PirGetXAttrValue:
   DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */
   
   DEF VAR cFileName  AS CHAR        NO-UNDO.
   DEF VAR cSurrogate AS CHAR        NO-UNDO.
   DEF VAR cCode      AS CHAR        NO-UNDO.
   DEF VAR cDefValue  AS CHAR INIT ? NO-UNDO.
   DEF VAR dDate      AS DATE INIT ? NO-UNDO.
   DEF VAR cResult    AS CHAR        NO-UNDO.

   IF NOT ( Pars-ValidParam(3) OR Pars-ValidParam(4) OR Pars-ValidParam(5) ) THEN RETURN.


   cFileName   = Pars-GetString(0).
   cSurrogate  = Pars-GetString(1).
   cCode       = Pars-GetString(2).

   IF pn GE 3 THEN DO:
       cDefValue = Pars-GetString(3).
   END.
   
   IF pn GE 4 THEN DO:
       dDate = DATE(Pars-GetString(4)).
   END.

   
   IF dDate = ? THEN DO:
     cResult = getXAttrValueEx(cFileName,cSurrogate,cCode,cDefValue).
   END. ELSE DO:
     cResult = GetTempXAttrValueEx(cFileName,cSurrogate,cCode,dDate,cDefValue).
   END.

   RUN Pars-SetCHARResult(cResult).
   is-ok = TRUE.    
END PROCEDURE.

/*
  Что делает: Вставляет номер документа созданного по шаблону из параметра
  Синтаксис : НомерДок(1) - вставит номер документа, который был создан шаблоном 1
  Автор     : Никитина Ю.А.
*/

PROCEDURE НомерДок:
 
    DEFINE VARIABLE iOPTEMPL AS integer NO-UNDO. 	/* из какого шаблона взять номер док */
    DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. 		/* успешно ли выполнена ? */
    DEFINE VARIABLE vResult  AS CHARACTER  NO-UNDO.     /* результат в виде номера документа*/
    DEF VAR wopk AS CHAR NO-UNDO. 			/*какая транзакция запущена*/ 
    DEFINE VARIABLE cDocNum AS CHARACTER NO-UNDO.	/*номер документа создаваемого*/ 

    IF NOT Pars-ValidParam(1) THEN RETURN.

    iOPTEMPL = int(Pars-GetString(0)).
    wopk = DYNAMIC-FUNCTION("GetCallOpkind" IN h_pbase,1,"OPKIND"). 			/* намименование транзакции, которая сейчас запущена */

    find first wop where wop.op-kind eq wopk and wop.op-templ eq iOPTEMPL no-lock no-error. /* ищем в таблице-буфере создаваемых документов */
    if avail(wop) THEN DO:
	RUN internal-parser-getdetails-form-ttable (iOPTEMPL,"opreq", "doc-num", OUTPUT cDocNum). 	/* номер документа, который создан шблоном iOPTEMPL*/
	vResult = cDocNum.
    end.
    else do:                             
	vResult = "Не найден документ, который был создан шаблоном " + string(iOPTEMPL) + "  в таблице-буфере wop". 
    end.
	
    RUN Pars-SetCHARResult (vResult).

    is-ok = TRUE.

END PROCEDURE.

/*
  Что делает: Возвращает код VO для резидента и нерезидента, если не требуется - то пустое значение
  Синтаксис : GetVoCod(@Счет,"Код для резидента,Код для не резидента для рублевого счета,Код для не резидента для валютного счета","Валюта документа")
  Автор     : Красков А.С.
*/

PROCEDURE GetVoCod:
   DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. 		/* успешно ли выполнена ? */
   DEF VAR cAcct AS CHAR NO-UNDO.
   DEF VAR iKodVO AS CHAR NO-UNDO.
   DEF VAR cCountry AS CHAR NO-UNDO.
   def var iCur as char NO-UNDO.
   DEF VAR i AS INT INIT 0 NO-UNDO.
   def var result as char NO-UNDO.
   IF NOT Pars-ValidParam(3) THEN RETURN.
   cAcct  = Pars-GetString(0).
   iKodVO = Pars-GetString(1).
   iCur   = Pars-GetString(2).

   
   FIND FIRST acct WHERE acct.acct = cAcct NO-LOCK NO-ERROR.
   if available(acct) then 
	DO:
	   if acct.cust-cat = "Ч" then 
	     do:
	        find first person where person.person-id = acct.cust-id.
	        if available(person) then cCountry = person.country-id.
	     end.
	   if acct.cust-cat = "Ю" then 
	     do:
	        find first cust-corp where cust-corp.cust-id = acct.cust-id.
	        if available(cust-corp) then cCountry = cust-corp.country-id.
	     end.
	   if acct.cust-cat = "Б" then 
	     do:
	        find first banks where banks.bank-id = acct.cust-id.
	        if available(banks) then cCountry = banks.country-id.

	     end.



    if cCountry = "RUS" then i = 1. else i = 2.	
    if acct.cust-cat = "Ч" then i = 0.    /*Для физиков не проставляется больше код VO, так же как и для рублевых платежей резидентов.*/
    if cCountry = "Rus" and (iCur = "" OR iCur = "810") then i = 0.
    if cCountry = "RUS" and acct.currency = "" then i = 0. /*для резедентов операции с рублевых счетов не требуют код VO*/
    if cCountry <> "RUS" and acct.currency = "" and acct.cust-cat <> "Ч" then i = 2. 
    if cCountry <> "RUS" and acct.currency <> "" and acct.cust-cat <> "Ч" then i = 3.
	END.
    if i = 3 and NUM-ENTRIES(iKodVO) < i then i = 2.	
    if i = 0 then 
	do:    
          result = ?.
/*          RUN Pars-SetResult (result).           */
        RUN Pars-SetCHARResult (" ").		
	END.
    else
        RUN Pars-SetCHARResult (ENTRY(i,iKodVO)).

    is-ok = TRUE.


END PROCEDURE.


/**
 * Процедура возвращает информацию по клиенту.
 * Если передан один параметр, то ID клиента 
 * берет из tmp-person-id для g_buysel.
 * Если указано 2 параметра, то второй считается
 * ID клиента.
 * @var INT ipType 
 * @var INT personId
 * @return CHAR
 **
 * Автор: Маслов Д. А. Maslov D. A.
 * Дата создания: 17.01.13
 * Заявка: #2149
 ***************/
PROCEDURE GetCustInfoGBuySel:
 DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. 		/* успешно ли выполнена ? */

 DEF VAR opResult AS CHAR         NO-UNDO.
 DEF VAR ipType   AS INT64        NO-UNDO.
 DEF VAR personId AS INT64 INIT ? NO-UNDO.

  IF NOT (Pars-ValidParam(1) OR Pars-ValidParam(2)) THEN RETURN.
  ipType  = INT64(Pars-GetString(0)).

  IF pn = 1 THEN DO:
    personId = INT64(Pars-GetString(1)).
  END.

  IF ipType > 0 THEN DO:
      RUN GetCustInfoBlock IN h_cust ("Ч",(IF personId = ? THEN INT64(GetSysConf("tmp-person-id")) ELSE personId),OUTPUT opResult) .

      IF NUM-ENTRIES(opResult, CHR(1)) < ipType
      THEN opResult = "".
      ELSE opResult = ENTRY(ipType, opResult, CHR(1)).
   END.
   ELSE opResult = "".

 RUN Pars-SetCHARResult(opResult).		
 is-ok = TRUE.
END PROCEDURE.

/**
 * @param iType INT тип наименования 1 - полное наименование, 
 * 2 - коротко наименование
 * @return CHAR
 **/
PROCEDURE PirGetBank:
    DEF OUTPUT PARAM is-ok       AS LOG     NO-UNDO.

    DEF VAR iType      AS INT  NO-UNDO.
    DEF VAR out_Result AS CHAR NO-UNDO.

IF NOT (Pars-ValidParam(1)) THEN RETURN.

iType = INT(Pars-GetString(0)).

{get-bankname.i}

CASE iType:
  WHEN 1 THEN out_Result = cBankName.
  WHEN 2 THEN out_Result = cBankNameFull.
END CASE.

 RUN Pars-SetCHARResult(out_Result).		
 is-ok = TRUE.

END PROCEDURE.

/************
 * Для картотечных транзакций.
 * Выводит тип документа, который
 * будет выводиться в содержании внебаланса.
 ************
 * Автор : Маслов Д. А.
 * Дата  : 12.02.13
 * Заявка: #2071
 ************/

PROCEDURE PirGetDT4Queue:
 DEF OUTPUT PARAM is-ok  AS LOG     NO-UNDO.

 DEF VAR cDocCode AS CHAR NO-UNDO.
 DEF VAR cRes     AS CHAR NO-UNDO.

 IF NOT (Pars-ValidParam(1)) THEN RETURN.

 cDocCode = Pars-GetString(0).

 CASE cDocCode:
      WHEN "01"  THEN cRes = "п/п".
      WHEN "02"  THEN cRes = "п/т".
      WHEN "015" THEN cRes = "и/п".
      WHEN "016" THEN cRes = "п/о".
      WHEN "17"  THEN cRes = "б/о".
      OTHERWISE       cRes = "п/о".                
 END CASE.
 RUN Pars-SetCHARResult(cRes).		
 is-ok = TRUE.
END PROCEDURE.


/*
    * Что делает: Возвращает доп.реквизит "ДатаСогл" с КД 
                  Если передан 1 параметр "Соглаш" то возвращается дата вышестоящего договора
    * Синтаксис : ПИРДРДатаСогл(["Соглаш"])
    * Пример    : ПИРДРДатаСогл(), ПИРДРДатаСогл("Соглаш")
*/
PROCEDURE ПИРДРДатаСогл:
   DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. /* успешно ли выполнена ? */
   def var ph as handle no-undo.

   is-ok = FALSE.

   IF NOT (Pars-ValidParam(0) OR Pars-ValidParam(1)) THEN RETURN.
 
     /* Определение правильного применения функции, формат private-data */
   RUN LOAN_VALID_HANDLE (INPUT-OUTPUT ph).

   IF NOT VALID-HANDLE(ph) THEN RETURN.

   IF pn EQ 0 AND TRIM(Pars-GetString(0), """'") EQ "Соглаш" 
   THEN    /* если 1 параметр и он равен "Соглаш" */
     FIND FIRST loan 
       WHERE  loan.contract  EQ ENTRY(1, ph:private-data) 
       AND    loan.cont-code EQ SUBSTR(ENTRY(2, ph:private-data), 1, R-INDEX(ENTRY(2, ph:private-data), " ") - 1)
     NO-LOCK NO-ERROR.
   ELSE 
     FIND FIRST loan 
       WHERE  loan.contract  eq entry(1, ph:private-data) 
       AND    loan.cont-code eq entry(2, ph:private-data)
     NO-LOCK NO-ERROR.

   IF NOT AVAIL loan THEN RETURN .

   RUN Pars-SetCHARResult (GetXattrValue("loan",loan.contract + "," + loan.cont-code,"ДатаСогл")).

   is-ok = TRUE.

END PROCEDURE.


/************
 * Возвращает код VO для корпоративных карточных операций оплаты, снятия наличных 
 * PirCardCodeVO(СчетДБ,СчетКР, "КодКорпКартаРез,КодКорпКартаНЕРез,Прочие" )
 ************
 * Автор : Sitov S.A.
 * Дата  : 2013-09-11
 * Заявка: #3736
 ************/
PROCEDURE PirCardCodeVO:
 DEF OUTPUT PARAM is-ok  AS LOG     NO-UNDO.

 DEF VAR vAcctDb AS CHAR NO-UNDO.
 DEF VAR vAcctCr AS CHAR NO-UNDO.
 DEF VAR vCodeVO AS CHAR NO-UNDO.
 DEF VAR vRes    AS CHAR NO-UNDO.
 DEFINE BUFFER bloan-acct FOR loan-acct.

 IF NOT (Pars-ValidParam(3)) THEN RETURN.

 vAcctDb  = Pars-GetString(0).
 vAcctCr  = Pars-GetString(1).
 vCodeVO  = Pars-GetString(2).

	/* ПРАВИЛА ПРОСТАВЛЕНИЯ КОДА ВАЛЮТНОЙ ОПЕРАЦИИ */
     /* Корпоративная карта ЮЛ. Операции оплаты, снятия н.д.с */ 
 FIND LAST bloan-acct 
   WHERE bloan-acct.acct = vAcctDb
   AND   bloan-acct.acct-type BEGINS "SCS@"
   AND   bloan-acct.contract = "card-corp"
 NO-LOCK NO-ERROR.

 IF AVAIL(bloan-acct) THEN
 DO:
   IF CAN-DO("40702.........50*,40703.........50*,40502.........50*,40503.........50*,40602.........50*,40603.........50*,40802.........50*,40807.........50*",vAcctDb)  
   THEN
      IF vAcctDb BEGINS "40807.........50*" THEN
         vRes = ENTRY(2,vCodeVO) .  
      ELSE
         vRes = ENTRY(1,vCodeVO) .
   ELSE
      vRes = ENTRY(3,vCodeVO) .
 END.
 ELSE 
   vRes = ENTRY(3,vCodeVO) .

 IF vRes = ? OR vRes = "" THEN vRes = " ".

 RUN Pars-SetCHARResult(vRes).		
 is-ok = TRUE.

END PROCEDURE.

/************
 * возвращает сумму не акцептованного "прихода" по межбанку.
 ************
 * Автор : Красков А.С.
 * Дата  : 21.10.13
 * Заявка: #3969
 ************/

PROCEDURE PirGetRKCIn:

 DEF OUTPUT PARAM is-ok  AS LOG     NO-UNDO.

 DEF VAR cAcct    AS CHAR NO-UNDO.
 DEF var iRes     AS decimal INIT 0 NO-UNDO.
 IF NOT (Pars-ValidParam(1)) THEN RETURN.

 cAcct = Pars-GetString(0).

 for each op-entry where op-entry.acct-cr = cAcct
                     and op-entry.acct-db = "30102810900000000491"    
                     and op-entry.op-status = "К"
                     and op-entry.op-date = in-op-date
                     NO-LOCK.

    iRes = iRes + op-entry.amt-rub.

 END.

 RUN Pars-SetResult(iRes).		
 is-ok = TRUE.        

END PROCEDURE.



/************
 * Возвращает код VO 
 * ОБЩАЯ ПРОЦЕДУРА
 * Предполагается, что сюда будут добавляться проверки,
 * а сама парсерная функция будет вставляться во все транзакции  
 * PirGetCodeVOall(@СчетДБ,@СчетКР,@Вал, "Что-нибудьНаБудущее" )
 ************
 * Автор : Sitov S.A.
 * Дата  : 2013-10-16
 * Заявка: #3950
 ************/

PROCEDURE PirGetCodeVOall :
   DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. 		/* успешно ли выполнена ? */
   DEF VAR vAcctDb	AS CHAR NO-UNDO.
   DEF VAR vAcctCr	AS CHAR NO-UNDO.
   DEF VAR vVal		AS CHAR NO-UNDO.
   DEF VAR vSomething	AS CHAR NO-UNDO.
   DEF VAR oVOCode	AS CHAR INIT "" NO-UNDO.

/**** #4102*/
   IF NOT Pars-ValidParam(4) THEN 
	RETURN.

   vAcctDb    = Pars-GetString(0).
   vAcctCr    = Pars-GetString(1).
   vVal       = Pars-GetString(2).
   vSomething = Pars-GetString(3).

   RUN pir-u102-codevo.p( vAcctDb , vAcctCr , vVal , vSomething , OUTPUT oVOCode ) .  
/*******/

   IF oVOCode = "" THEN oVOCode = " ".

   RUN Pars-SetCHARResult (oVOCode).
   is-ok = TRUE.
END PROCEDURE.


/*Функция для определения суммы лимита по условию минус сумма выданных траншей*/

PROCEDURE PirRestoreLimit :
   DEF OUTPUT PARAM is-ok AS LOGICAL NO-UNDO. 		/* успешно ли выполнена ? */
   DEF VAR iContCode as CHAR NO-UNDO.
   DEF VAR iDate as DATE NO-UNDO.
   DEF VAR oSumm as DEC INIT 0 NO-UNDO.
   DEF VAR Btok AS LOGICAL INIT FALSE NO-UNDO.

   IF NOT (Pars-ValidParam(2)) THEN RETURN.

   iContCode = Pars-GetString(0).
   iDate = DATE(Pars-GetString(1)).

   FIND LAST term-obl WHERE term-obl.contract  EQ 'Кредит'
                        AND term-obl.cont-code EQ iContCode
                        AND term-obl.idnt      EQ 2
                        AND term-obl.end-date  LE iDate
     NO-LOCK NO-ERROR.

   IF AVAIL term-obl THEN 
   DO:
      oSumm = term-obl.amt.
     
      FOR EACH loan WHERE loan.cont-code begins iContCode + ' '
                      AND loan.contract = 'Кредит'
                      AND loan.close-date = ? 
                      NO-LOCK:
          find last loan-var where (loan-var.amt-id = 0  OR loan-var.amt-id = 7)
                               and loan-var.cont-code = iContCode
                               and loan-var.contract = 'Кредит'
                               and loan-var.since <= iDate  
                               NO-LOCK NO-ERROR.
          IF available loan-var then oSumm = oSumm - loan-var.balance. 
      END. 
   END.


   IF oSumm > 0 THEN 
   DO:

      MESSAGE "Восстановить лимит по договору " + ENTRY(1,iContCode," ") + " на сумму: " + STRING(oSumm) + "?"  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE BtOk. 
      IF NOT BtOk or Btok = ? THEN oSumm = 0.

   END.

   RUN Pars-SetResult (oSumm).

   is-ok = TRUE.
END PROCEDURE.






