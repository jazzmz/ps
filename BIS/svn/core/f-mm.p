&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 Character
&ANALYZE-RESUME
/* Connected Databases
          bisquit          PROGRESS
*/
&Scoped-define WINDOW-NAME TERMINAL-SIMULATION



/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-amount NO-UNDO LIKE term-obl
       FIELD viddogob$ AS CHARACTER /* ВидДогОб (Вид договора обеспечения) */
       FIELD vidob$ AS CHARACTER /* ВидОб (Вид предмета обеспечения) */
       FIELD datapost$ AS DATE /* ДатаПост (Дата поступления) */
       FIELD dopinfo$ AS CHARACTER /* ДопИнфо (Дополнительная информация) */
       FIELD mestonahowzdenie$ AS CHARACTER /* Местонахождение (Местонахождение имущества) */
       FIELD nomdogob$ AS CHARACTER /* НомДогОб (Номер договора обеспечения) */
       FIELD nomerpp$ AS INT64 /* НомерПП (Порядковый номер) */
       FIELD opisanie$ AS CHARACTER /* Описание (Описание предмета обеспечения) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-amount" "amount" }
       .
DEFINE TEMP-TABLE tt-broker NO-UNDO LIKE cust-role
       FIELD contract AS CHARACTER /* contract (Номер договора) */
       FIELD HiddenFields AS CHARACTER /* HiddenFields (Список скр. полей в завис. от Ver-format) */
       FIELD is_mandatory AS LOGICAL /* is_mandatory (Основная роль) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */
       INDEX cust-role-id cust-role-id
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-broker" "broker" }
       .
DEFINE TEMP-TABLE tt-comm-rate NO-UNDO LIKE comm-rate
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */
       FIELD min_value       AS DECIMAL HELP "Минимальное значение за весь период просрочки"  /* Минимальное значение */
       INDEX local__id IS UNIQUE local__id
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-comm-rate" "loan-cond:comm-rate" }
       .
DEFINE TEMP-TABLE tt-comm-cond NO-UNDO LIKE comm-cond
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */
       INDEX local__id IS UNIQUE local__id
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-comm-cond" "loan-cond:comm-cond" }
       .
DEFINE TEMP-TABLE tt-commrate NO-UNDO LIKE comm-rate
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-commrate" "commrate" }
       .
DEFINE TEMP-TABLE tt-contragent NO-UNDO LIKE cust-role
       FIELD contract AS CHARACTER /* contract (Номер договора) */
       FIELD HiddenFields AS CHARACTER /* HiddenFields (Список скр. полей в завис. от Ver-format) */
       FIELD is_mandatory AS LOGICAL /* is_mandatory (Основная роль) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */
       INDEX cust-role-id cust-role-id
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-contragent" "contragent" }
       .
DEFINE TEMP-TABLE tt-dealer NO-UNDO LIKE cust-role
       FIELD contract AS CHARACTER /* contract (Номер договора) */
       FIELD HiddenFields AS CHARACTER /* HiddenFields (Список скр. полей в завис. от Ver-format) */
       FIELD is_mandatory AS LOGICAL /* is_mandatory (Основная роль) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */
       INDEX cust-role-id cust-role-id
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-dealer" "dealer" }
       .
DEFINE TEMP-TABLE tt-loan NO-UNDO LIKE loan
       FIELD akt_vzv$ AS CHARACTER /* Акт_взв (Активы взешенные с учетом риска) */
       FIELD grup_dog$ AS CHARACTER /* Груп_дог (Группа договора) */
       FIELD datasogl$ AS DATE /* ДатаСогл (Дата заключения кредитного договора) */
       FIELD data_uar$ AS CHARACTER /* Дата_УАР (Номер и дата подтверждения УАР) */
       FIELD dosroka$ AS CHARACTER /* ДоСРОКА (Нельзя снимать средства до срока) */
       FIELD igndtokwc$ AS LOGICAL /* ИгнДтОкч (Игнорировать дату окончания договора) */
       FIELD nesno$ AS CHARACTER /* НеснО (Неснижаемые обороты) */
       FIELD okrugsum$ AS LOGICAL /* ОкругСум (Округление суммы плановых платежей) */
       FIELD rewzim$ AS CHARACTER /* Режим (Формы договоров привлечения) */
       FIELD sindkred$ AS LOGICAL /* СиндКред (Синдицированный кредит) */
       FIELD BankCust AS CHARACTER /* BankCust (Код клиента исполняющего банка) */
       FIELD Bfnc AS CHARACTER /* Bfnc (Код функции Bfnc в DBI) */
       FIELD CallAcct AS CHARACTER /* CallAcct (DBI счет требований по аккредитиву) */
       FIELD dateend AS DATE /* dateend (Дата окончания/закрытия из ldmfDD.txt) */
       FIELD DTKind AS CHARACTER /* DTKind (Разновидность сделки для Decision Table) */
       FIELD DTType AS CHARACTER /* DTType (Вид договора для Decision Table) */
       FIELD Exec_D AS LOGICAL /* Exec_D (Не учитывать при подсчете кол-ва дог.) */
       FIELD IntAcct AS CHARACTER /* IntAcct (Процентный DBI счет) */
       FIELD list_type AS CHARACTER /* list_type (Список типов счетов для авт. закрытия) */
       FIELD main-loan-acct AS CHARACTER /* main-loan-acct (Роль счета) */
       FIELD main-loan-cust AS CHARACTER /* main-loan-cust (Основная роль клиента) */
       FIELD OblAcct AS CHARACTER /* OblAcct (DBI счет обязательств по аккредитиву) */
       FIELD op-date AS CHARACTER /* op-date (1111) */
       FIELD PrevLoanID AS CHARACTER /* PrevLoanID (Ссылка на пролонгированную сделку) */
       FIELD ProfitCenter AS CHARACTER /* ProfitCenter (Код подразделения банка/ProfitCenter) */
       FIELD rel_type AS CHARACTER /* rel_type (Список типов счетов для привязки) */
       FIELD ReplDate AS DATE /* ReplDate (Дата отмены сделки) */
       FIELD RevRef1 AS CHARACTER /* RevRef1 (Ссылка на новую сделку) */
       FIELD RevRef2 AS CHARACTER /* RevRef2 (Ссылка на отмененную сделку) */
       FIELD round AS LOGICAL /* round (Округление) */
       FIELD TermKey AS CHARACTER /* TermKey (Код срочности в DBI) */
       FIELD TicketNumber AS CHARACTER /* TicketNumber (Номер тикета DBI (DocNum)) */
       FIELD ovrpr$ AS INT64
       FIELD ovrstop$ AS INT64
       FIELD ovrstopr$ AS CHARACTER /* ДР ОврСтопР */
       FIELD tranwspertip$ AS LOGICAL /* ДР ТраншПерТип */
       FIELD prodkod$ AS CHARACTER /* Продукты КиД:код продукта */
       FIELD svodgravto$ AS LOGICAL /* ДР СводГрАвто */
       FIELD svodgrafik$ AS LOGICAL /* ДР СводГрафик */
       FIELD svodskonca$ AS LOGICAL /* ДР СводСКонца */
       FIELD svodform$ AS LOGICAL /* ДР СводФорм */
       FIELD svodspostr$ AS LOGICAL /* ДР СводСПосТр */
       FIELD UniformBag AS CHARACTER /* ДР UniformBag */
       FIELD sum-depos AS DECIMAL /* ДР Сумма связанного вклада */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */
       FIELD rate-list AS CHARACTER
       FIELD stream-show AS LOGICAL
       FIELD AgrCounter  AS CHARACTER     /* Номер договора по счетчику */
       FIELD LimitGrafDate AS DATE
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-loan" "" }
       .
DEFINE TEMP-TABLE tt-loan-acct NO-UNDO LIKE loan-acct
       FIELD class-code AS CHARACTER /* class-code (Класс loan-acct) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-loan-acct" "loan-acct" }
       .
DEFINE TEMP-TABLE tt-loan-acct-cust NO-UNDO LIKE loan-acct
       FIELD class-code AS CHARACTER /* class-code (Класс loan-acct) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-loan-acct-cust" "loan-acct-cust" }
       .
DEFINE TEMP-TABLE tt-loan-acct-main NO-UNDO LIKE loan-acct
       FIELD class-code AS CHARACTER /* class-code (Класс loan-acct) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-loan-acct-main" "loan-acct-main" }
       .
DEFINE TEMP-TABLE tt-loan-cond NO-UNDO LIKE loan-cond
       FIELD annuitplat$  AS DECIMAL /* АннуитПлат (Сумма аннуитетного платежа) */
       FIELD end-date AS DATE /* end-date (Дата окончания) */
       FIELD EndDateBeforeProl AS DATE /* EndDateBeforeProl (Дата окончания вклада до пролонгации) */
       FIELD kollw#gtper$ AS INT64 /* КолЛьгтПер (Количество льготных периодов) */
       FIELD kollw#gtperprc$ AS INT64 /* КолЛьгтПерПрц (Количество льготных периодов (проценты)) */
       FIELD cred-offset AS CHARACTER
       FIELD int-offset AS CHARACTER
       FIELD delay-offset AS CHARACTER
       FIELD delay-offset-int AS CHARACTER
       FIELD cred-mode AS CHARACTER /* cred-mode (Способ задания плат.периода (осн.долг)) */
       FIELD int-mode AS CHARACTER /* int-mode (Способ задания плат.периода (проценты)) */
       FIELD DateDelay AS INT64 /* DateDelay (День окончания плат.периода (осн.долг)) */
       FIELD DateDelayInt AS INT64 /* DateDelayInt (День окончания плат.периода (проценты)) */
       FIELD cred-work-calend AS LOGICAL /* cred-work-cale (Режим расчета продолж.периода (осн.долг)) */
       FIELD cred-curr-next AS LOGICAL /* cred-curr-next (Режим расчета окончания периода(осн.долг) */
       FIELD int-work-calend AS LOGICAL /* int-work-calen (Режим расчета продолж.периода (проценты)) */
       FIELD int-curr-next AS LOGICAL /* int-curr-next (Режим расчета окончания периода (проц.)) */
       FIELD Prolong AS LOGICAL /* Prolong (Пролонгция вклада) */
       FIELD interest AS CHAR /* Схема начилений */
       FIELD shemaplat$ AS LOGICAL /* СхемаПлат (Схема платежа) */
       FIELD isklmes$ AS LOGICAL /* ИсклМес (Наличие исключений месяцев) */
       FIELD NDays AS INT64 /* Количество дней действия условия */
       FIELD NMonthes AS INT64 /* Количество месяцев действия условия */
       FIELD NYears AS INT64 /* Количество лет действия условия */
       FIELD Test01 AS CHARACTER /* Test01 (Test01) */
       FIELD kredplat$ AS DECIMAL /* КредПлат (Сумма периодич.платежа погаш. осн.долга) */
       FIELD prodtrf$ AS CHARACTER /* Код тарифа продукта */
       FIELD annuitkorr$ AS INT64       /* ДР АннуитКорр */
       FIELD grperiod$ AS LOG /* ДР ГрПериод */
       FIELD grdatas$ AS DATE /* ДР ГрДатаС */
       FIELD grdatapo$ AS DATE /* ДР ГрДатаПо */
       FIELD PartAmount AS DECIMAL /* ДР Доля кредита первого периода */
       FIELD FirstPeriod AS INTEGER /* ДР Продолжительность первого периода в месяцах */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-loan-cond" "loan-cond" }
       .
DEFINE TEMP-TABLE tt-MonthOut NO-UNDO LIKE term-obl
       FIELD viddogob$ AS CHARACTER /* ВидДогОб (Вид договора обеспечения) */
       FIELD vidob$ AS CHARACTER /* ВидОб (Вид предмета обеспечения) */
       FIELD datapost$ AS DATE /* ДатаПост (Дата поступления) */
       FIELD dopinfo$ AS CHARACTER /* ДопИнфо (Дополнительная информация) */
       FIELD mestonahowzdenie$ AS CHARACTER /* Местонахождение (Местонахождение имущества) */
       FIELD nomdogob$ AS CHARACTER /* НомДогОб (Номер договора обеспечения) */
       FIELD nomerpp$ AS INT64 /* НомерПП (Порядковый номер) */
       FIELD opisanie$ AS CHARACTER /* Описание (Описание предмета обеспечения) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-MonthOut" "loan-cond:MonthOut" }
       .
DEFINE TEMP-TABLE tt-MonthSpec NO-UNDO LIKE term-obl
       FIELD viddogob$ AS CHARACTER /* ВидДогОб (Вид договора обеспечения) */
       FIELD vidob$ AS CHARACTER /* ВидОб (Вид предмета обеспечения) */
       FIELD datapost$ AS DATE /* ДатаПост (Дата поступления) */
       FIELD dopinfo$ AS CHARACTER /* ДопИнфо (Дополнительная информация) */
       FIELD mestonahowzdenie$ AS CHARACTER /* Местонахождение (Местонахождение имущества) */
       FIELD nomdogob$ AS CHARACTER /* НомДогОб (Номер договора обеспечения) */
       FIELD nomerpp$ AS INT64 /* НомерПП (Порядковый номер) */
       FIELD opisanie$ AS CHARACTER /* Описание (Описание предмета обеспечения) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-MonthSpec" "loan-cond:MonthSpec" }
       .
DEFINE TEMP-TABLE tt-percent NO-UNDO LIKE term-obl
       FIELD viddogob$ AS CHARACTER /* ВидДогОб (Вид договора обеспечения) */
       FIELD vidob$ AS CHARACTER /* ВидОб (Вид предмета обеспечения) */
       FIELD datapost$ AS DATE /* ДатаПост (Дата поступления) */
       FIELD dopinfo$ AS CHARACTER /* ДопИнфо (Дополнительная информация) */
       FIELD mestonahowzdenie$ AS CHARACTER /* Местонахождение (Местонахождение имущества) */
       FIELD nomdogob$ AS CHARACTER /* НомДогОб (Номер договора обеспечения) */
       FIELD nomerpp$ AS INT64 /* НомерПП (Порядковый номер) */
       FIELD opisanie$ AS CHARACTER /* Описание (Описание предмета обеспечения) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-percent" "percent" }
       .
DEFINE TEMP-TABLE tt-term-obl NO-UNDO LIKE term-obl
       FIELD viddogob$ AS CHARACTER /* ВидДогОб (Вид договора обеспечения) */
       FIELD vidob$ AS CHARACTER /* ВидОб (Вид предмета обеспечения) */
       FIELD datapost$ AS DATE /* ДатаПост (Дата поступления) */
       FIELD dopinfo$ AS CHARACTER /* ДопИнфо (Дополнительная информация) */
       FIELD mestonahowzdenie$ AS CHARACTER /* Местонахождение (Местонахождение имущества) */
       FIELD nomdogob$ AS CHARACTER /* НомДогОб (Номер договора обеспечения) */
       FIELD nomerpp$ AS INT64 /* НомерПП (Порядковый номер) */
       FIELD opisanie$ AS CHARACTER /* Описание (Описание предмета обеспечения) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INT64   /* Идентификатор записи     */
       FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-term-obl" "term-obl" }
       .



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS TERMINAL-SIMULATION
/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: F-MM.P
      Comment: Экранная форма договора/сделки привлечения/размещения средств
   Parameters:
         Uses:
      Used by:
     Modified: 16.04.2004 20:02 KSV      (0019947) Унификация кода с модулем
                                         ВАЛЮТНЫЙ РЫНОК.
     Modified: 19.05.2004 Илюха          (0027778) Доработки секции условий
                                         для Аннуитетной схемы платежей

     Modified: 21.02.2005 18:44 KSV      (0041920) Изменение заполнения поля
                                         CONT-CODE.
     Modified: 26.02.2006 ZIAL (0045121) с17: Увеличить формат коэф. создания
                                              резерва по ссуде
     Modified: 21.04.2006 ZIAL (0045121) с17: Увеличить формат коэф. создания
                                              резерва по ссуде
     Modified: 04.10.2007 JADV (0082676) - Исправлена опечатка сообщения
     Modified: 18.10.2007 JADV (0077319) - Добавлены проверки на необходимость
                                           сдвига дат
     Modified: 07.11.2007 JADV (0082850) - Проверка полей графы "Мс" на 0 для
                                           значений периода Г, ПГ, К
     Modified: 23.11.2007 JADV (0084482) - размерность полей "Дней", "Мес"
                                           увеличена до 3-х символов
     Modified: 23.11.2007 JADV (0084483) - Изменен порядок след.и ввода
                                           полей "Режим" и "Дн"
     Modified: 23.11.2007 JADV (0046190)
     Modified: 26.09.2008 19:06 KSV      (0097966) QBIS. Добавлен
                                         ввод/изменение и удаление проц. ставки
     Modified: 10.10.2008 12:14 Chumv    <comment>
     Modified: 06.10.2009 16:27 ksv      (0118160) исправление компиляции 10.1B

     Modified: 27.08.2010 16:27 ches     (0054602) без изменений
     Modified: 21.09.2010 16:27 ches     (0129479) ввод Портфеля при создании договора

*/
/*          This file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Commented by KSV: Данный шаблон предназначен для создания экранной формы
** осуществляющей добавление, изменение и просмотр информации об объекте
** метасхемы БИСКВИТА без непосредственного обращения к базе данных.
**
** Шаги по созданию экранной формы:
**    0. Настройте PROPATH AppBuilder на SRC каталог БИСКВИТа. ВАЖНО, чтобы
**       служебные каталоги PROGRESS находились после каталога SRC/TOOLS.
**       Подключитесь к базе данных БИСКВИТа.
**    1. Выберите пункт меню AppBuilder Tools - Procedure Settings. Далее
**       нажмите кнопку Temp-Table Definition, в появившемся диалоге нажмите
**       кнопку BISQUIT и выберите класс метасхемы, объект которого будет
**       обрабатываться формой. На основе выбранного класса в форму добавится
**       объявления временных таблиц как для выбранного класса, так и для
**       всех аггрегированных на нем классов.
**    2. Разместите поля временных таблиц во фрейме. Для связи виджета с
**       полем из временной таблицы в форме свойств поля щелкните по кнопке
**       Database Field правой копкой мыши и в появившемся меню выберите
**       пункт Bisquit.
**       Вы  можете создать специальные поля разделители, для этого необходимо
**       создать FILL-IN c идентификатором SEPARATOR# (где # - любое число от
**       2, первый FILL-IN имеет идентифкатор без номера) и аттрибутом
**       VIES-AS TEXT. С помощью разделителей вы можете визуально выделять
**       группы полей.
**    3. Объедините поля в списки в зависимости от того в каком из режимов
**       поле должно быть доступно для редактирования. Для добавления поля
**       в список в диалоге его атрибутов нажмите кнопку Advanced и поставьте
**       галки в полях LIST-1, LIST-2 или LIST-3. Назначение списков:
**       -  LIST-1 - поля доступные для редактирования в режиме добавления
**                   записи
**       -  LIST-2 - поля доступные для редактирования в режиме редактирования
**                   записи
**       -  LIST-3 - поля доступные для редактирования в режиме просмотра.
**                   (Обычно это поля, отображаемы в виджете EDITOR для
**                   запрещения их изменения воспользуйтесь атрибутом READ-ONLY)
**       -  LIST-4 - поля для которых атрибут формат определяется в форме.
**                   Для других он заполняется из метасхемы.
**    4. Контроль за значением полей должен быть определен на триггере LEAVE
**       поля, который в случае несоответствия значения требуемому должен
**       возвращать значение {&RET-ERROR}.
**       Правильная конструкция триггера:

   .......

   IF <ОШИБКА> THEN
   DO:
      MESSAGE '......'
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   APPLY "LEAVE" TO FRAME {&MAIN-FRAME}. /* стандартная проверка */
   IF RETURN-VALUE EQ {&RET-ERROR}
      THEN RETURN NO-APPLY.

**    5. Для выбора значения поля из списка должен быть опредлен триггер F1 поля
**       (не путать с триггером на событие HELP в TTY - это разные события)
**    6. Если в форме присутсвуют виджеты не относящиеся к полям временной
**       таблицы, например кнопки, но которые д.б. доступны в режимах
**       редактирования и добавления поместите их в список LIST-4.
**    7. Более тонкую настройку поведения формы вы можете указать в процедуре
**       LocalEnableDisable, которая будет вызываться, в cлучае если она
**       определена, в конце EnableDisable.
**    8. Используйте процедуру LocalSetObject, которая будет вызываться,
**       в cлучае если она определена, перед записью данных в БД.
**    9. Для передачи специфических параметров процедуре экранной формы
**       воспользуйтесб функциями библиотеки PP-TPARA.P
**   10. Описание переменных для управления экранной формой находится в секции
**       Definitions библиотеки bis-tty.pro
**   11. Описание TEMP-TABL ов
*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE MAIN-FRAME fMain
/* Расскомментировать в случае вызова из NAVIGATE.CQR
{navigate.cqr
   ...
   &UseBisTTY=YES
   &edit=bis-tty.ef
   ...
}
   Если определена &UseBisTTY - то ссылка на динамическую таблицу верхнего класса
будет храниться в переменной IInstance.
   Если определена &InstanceFile - то будет определена и заполнена статическая
TEMP-TABLE tt-instance LIKE {&InstanceFile}

&GLOBAL-DEFINE UseBisTTY
&GLOBAL-DEFINE InstanceFile ИМЯ_ТАБЛИЦЫ_ПРОГРЕСС_ДЛЯ_ВЕРХНЕГО_КЛАССА
*/

&GLOBAL-DEFINE xDEBUG-INSTANCE-GET
&GLOBAL-DEFINE xDEBUG-INSTANCE-SET

/* Безусловное включение\отключение вызова xattr-ed
(иначе он вызывается при наличие незаполненных обязательных реквизитов */
/*
&GLOBAL-DEFINE XATTR-ED-OFF
&GLOBAL-DEFINE XATTR-ED-ON
*/
{globals.i}
{svarloan.def}          /* Shared переменные модуля "Кредиты и депозиты". */
{intrface.get fx}
{intrface.get mm}
{intrface.get i254}
{intrface.get bag}      /* Библиотека для работ с ПОС. */
{intrface.get loan}     /* Инструменты для работы с табличкой loan. */
{intrface.get loanc}
{intrface.get loanx}
{intrface.get limit}
{intrface.get tmcod}
{intrface.get refer}
{intrface.get ovl}
{deal.def}
{dtterm.i}
{loan.pro}
{mf-loan.i}             /* Функции addFilToLoan и delFilFromLoan преобразований
                        ** полей loan.doc-ref в loan.cont-code и наоборот. */
DEFINE VARIABLE mNameCommi    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mListContract AS CHARACTER  NO-UNDO INIT "Кредит,Депоз".

DEFINE VARIABLE mRateList          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mI                 AS INT64    NO-UNDO.
DEFINE VARIABLE mBrowseCommRateOFF AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mChangedField      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mHandCalcAnnuitet  AS LOGICAL    NO-UNDO.  /* Признак, что сумма платежа введена вручную */

DEFINE VARIABLE mEndDate     AS DATE       NO-UNDO.
DEFINE VARIABLE mAmount      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE mCredPeriod  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mCredDate    AS INT64    NO-UNDO.
DEFINE VARIABLE mIntPeriod   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mIntDate     AS INT64    NO-UNDO.
DEFINE VARIABLE mDelay1      AS INT64    NO-UNDO.
DEFINE VARIABLE mCredOffset  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mCountPer    AS INT64    NO-UNDO.
DEFINE VARIABLE mSurrcr      AS CHAR       NO-UNDO. /* Суррогат comm-rate, необходимый при создании записи на ДР МинЗнач */
DEFINE VARIABLE mSurrcr2     AS CHAR       NO-UNDO. /* Суррогат comm-rate, необходимый при просмотре записи по F1 и F9 ( ДР МинЗнач ) */
DEFINE VARIABLE mOffsetVld   AS CHARACTER  NO-UNDO. /* формат полей "Сд" (Сдвиг) */
DEFINE VARIABLE mNDays       AS INT64    NO-UNDO.
DEFINE VARIABLE mNMonth      AS INT64    NO-UNDO.
DEFINE VARIABLE mNYear       AS INT64    NO-UNDO.
DEFINE VARIABLE mSrokChange  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mSumma-sd    AS DECIMAL    NO-UNDO. /* для суммы течения */
DEFINE VARIABLE mModeBrowse  AS INT64    NO-UNDO. /* для проверок касательно комиссий */
DEFINE VARIABLE mDateEnd     AS DATE       NO-UNDO. /* для проверок даты "по" */
DEFINE VARIABLE vEndRasch    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mCounterVal  AS INT64    NO-UNDO. /* Счетчик дог.при автогенерации */
DEFINE VARIABLE mUniformBag AS CHARACTER  NO-UNDO. /* Дополнительный реквезит UniformBag */
DEFINE VARIABLE mHiddenField AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mProdCode    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mSvodROnly   AS LOG        NO-UNDO. /* доступность ДР СводГрАвто, СводГрафик, СводСКонца, СводСПосТр для редактирования */
DEFINE VARIABLE md1          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE md2          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE vCredPlav    AS CHAR       NO-UNDO.
DEFINE VARIABLE vCounter     AS INT64      NO-UNDO. /* Счетчик */
DEFINE VARIABLE vRatePS      AS DEC        NO-UNDO. /* Значение плавающей ставки */
DEFINE VARIABLE mFindLoanCond AS CHARACTER NO-UNDO. /* Значение НП КредФУсл */
DEFINE VARIABLE mLstDR        AS CHAR      NO-UNDO. /*список наследуемых ДР*/
/* значение полей Сдвиг, отображаемое вместо пустой строки */
DEFINE VARIABLE mOffsetNone AS CHARACTER   NO-UNDO INIT "--".
DEFINE VARIABLE mSummaDog    AS DEC        NO-UNDO. /* Сумма по договору */
DEFINE VARIABLE mdate2       AS DATE       NO-UNDO .
DEFINE VARIABLE mNewEndDate  AS DATE       NO-UNDO.

DEFINE VARIABLE mIsChanGRisk    AS LOGICAL    NO-UNDO INIT NO.
DEFINE NEW SHARED VARIABLE mask AS CHARACTER NO-UNDO INITIAL ?.

&GLOBAL-DEFINE BASE-TABLE tt-loan
   /* для loan-trg.pro */
&GLOBAL-DEFINE CorrectAnnuitet YES

DEFINE TEMP-TABLE tmp-loan NO-UNDO LIKE loan.
DEFINE TEMP-TABLE ttTermObl NO-UNDO LIKE term-obl.

DEFINE BUFFER b-comm-rate FOR tt-comm-rate.
DEFINE BUFFER t-comm-rate FOR comm-rate.
DEFINE BUFFER xbcomm-rate FOR comm-rate.
DEFINE BUFFER b-comm-cond FOR tt-comm-cond.
DEFINE BUFFER b-monthout  FOR tt-monthout.
DEFINE BUFFER b-monthspec FOR tt-monthspec.
DEFINE BUFFER xxloan-cond FOR loan-cond.

&GLOBAL-DEFINE InstanceFile loan
&GLOBAL-DEFINE mGlobalErr  yes


DEFINE VARIABLE hDefaultRate AS HANDLE NO-UNDO.
DEF VAR ii AS INT64 NO-UNDO .
DEFINE VARIABLE mTxtPercent AS CHARACTER NO-UNDO INIT "Проценты:".
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME br-comm

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-comm-rate tt-comm-cond

/* Definitions for BROWSE br-comm                                       */
&Scoped-define FIELDS-IN-QUERY-br-comm tt-comm-rate.commission /* tt-comm-rate.local__id */ tt-comm-rate.rate-fixed ENTRY(1, GetBufferValue( "commission", "WHERE commission.commission = '" + tt-comm-rate.commission + "'", "name-comm"),CHR(1)) @ mNameCommi tt-comm-rate.rate-comm tt-comm-rate.min_value tt-comm-cond.commission tt-comm-cond.since
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-comm tt-comm-rate.commission ~
tt-comm-rate.rate-fixed ~
tt-comm-cond.FloatType ~
tt-comm-rate.rate-comm ~
tt-comm-rate.min_value
&Scoped-define ENABLED-TABLES-IN-QUERY-br-comm tt-comm-rate tt-comm-cond
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-comm tt-comm-rate
&Scoped-define SELF-NAME br-comm
&Scoped-define QUERY-STRING-br-comm PRESELECT EACH tt-comm-rate WHERE tt-comm-rate.since EQ tt-loan-cond.since SHARE-LOCK, LAST tt-comm-cond OUTER-JOIN WHERE tt-comm-cond.commission EQ tt-comm-rate.commission AND tt-comm-cond.since LE tt-loan-cond.since SHARE-LOCK BY tt-comm-rate.since INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-comm OPEN QUERY {&SELF-NAME} PRESELECT EACH tt-comm-rate WHERE tt-comm-rate.since EQ tt-loan-cond.since SHARE-LOCK, LAST tt-comm-cond OUTER-JOIN WHERE tt-comm-cond.commission EQ tt-comm-rate.commission AND tt-comm-cond.since LE tt-loan-cond.since SHARE-LOCK BY tt-comm-rate.commission INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-comm tt-comm-rate tt-comm-cond
&Scoped-define FIRST-TABLE-IN-QUERY-br-comm tt-comm-rate


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-br-comm}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-loan-cond.NDays tt-loan-cond.NMonthes ~
tt-loan-cond.NYears tt-loan-cond.cred-month tt-loan-cond.cred-offset ~
tt-loan-cond.cred-mode tt-loan-cond.cred-work-calend ~
tt-loan-cond.cred-curr-next tt-loan-cond.DateDelay ~
tt-loan-cond.delay-offset tt-loan-cond.kredplat$ tt-loan-cond.int-month ~
tt-loan-cond.int-offset tt-loan-cond.kollw#gtperprc$ ~
tt-loan-cond.int-work-calend tt-loan-cond.int-curr-next ~
tt-loan-cond.DateDelayInt tt-loan-cond.delay-offset-int ~
tt-loan-cond.isklmes$
&Scoped-define ENABLED-TABLES tt-loan-cond
&Scoped-define FIRST-ENABLED-TABLE tt-loan-cond
&Scoped-Define ENABLED-OBJECTS cred-offset_ delay-offset_ int-offset_ ~
delay-offset-int_ mBag mSvod mLimit mLimitRest
&Scoped-Define DISPLAYED-FIELDS tt-loan.branch-id tt-loan.datasogl$ ~
tt-loan.cust-cat tt-loan.cust-id tt-loan.doc-num tt-loan.doc-ref ~
tt-loan.cont-type tt-loan.DTType tt-loan.DTKind tt-amount.amt-rub ~
tt-loan.currency tt-loan.open-date tt-loan-cond.NDays tt-loan-cond.NMonthes ~
tt-loan-cond.NYears tt-loan.end-date tt-percent.amt-rub tt-loan.ovrstop$ tt-loan.ovrstopr$ ~
tt-loan.ovrpr$ tt-loan.tranwspertip$ tt-loan-acct-main.acct tt-loan-acct-cust.acct ~
tt-loan-cond.cred-period tt-loan-cond.cred-date tt-loan-cond.cred-month ~
tt-loan-cond.cred-offset tt-loan-cond.kollw#gtper$ tt-loan-cond.cred-mode ~
tt-loan-cond.cred-work-calend tt-loan-cond.cred-curr-next ~
tt-loan-cond.delay1 tt-loan-cond.DateDelay tt-loan-cond.delay-offset ~
tt-loan-cond.kredplat$ tt-loan-cond.annuitplat$ tt-loan-cond.int-period ~
tt-loan-cond.int-date tt-loan-cond.int-month tt-loan-cond.int-offset ~
tt-loan-cond.kollw#gtperprc$ tt-loan-cond.int-mode ~
tt-loan-cond.int-work-calend tt-loan-cond.int-curr-next tt-loan-cond.delay ~
tt-loan-cond.DateDelayInt tt-loan-cond.delay-offset-int ~
tt-loan-cond.isklmes$ tt-loan.rewzim$ tt-loan-cond.disch-type ~
tt-loan.user-id tt-loan.loan-status tt-loan.close-date tt-loan.trade-sys ~
tt-dealer.cust-cat tt-dealer.cust-id tt-broker.cust-cat tt-broker.cust-id ~
tt-loan.comment
&Scoped-define DISPLAYED-TABLES tt-loan tt-amount tt-loan-cond tt-percent ~
tt-loan-acct-main tt-loan-acct-cust tt-dealer tt-broker
&Scoped-define FIRST-DISPLAYED-TABLE tt-loan
&Scoped-define SECOND-DISPLAYED-TABLE tt-amount
&Scoped-define THIRD-DISPLAYED-TABLE tt-loan-cond
&Scoped-define FOURTH-DISPLAYED-TABLE tt-percent
&Scoped-define FIFTH-DISPLAYED-TABLE tt-loan-acct-main
&Scoped-define SIXTH-DISPLAYED-TABLE tt-loan-acct-cust
&Scoped-define SEVENTH-DISPLAYED-TABLE tt-dealer
&Scoped-define EIGHTH-DISPLAYED-TABLE tt-broker
&Scoped-Define DISPLAYED-OBJECTS mBranchName CustName1 mNameCredPeriod ~
cred-offset_ delay-offset_ mNameIntPeriod int-offset_ delay-offset-int_ ~
mBag mSvod mLimit  mNameDischType mLimitRest mGrRiska mRisk CustName2 CustName3

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 tt-loan.branch-id tt-loan.datasogl$ tt-loan.cust-cat ~
tt-loan.cust-id tt-loan.doc-num tt-loan.doc-ref tt-loan.cont-type ~
tt-loan.DTType tt-loan.DTKind tt-amount.amt-rub tt-loan.currency ~
tt-loan.open-date tt-loan.sum-depos tt-loan-cond.PartAmount tt-loan-cond.FirstPeriod tt-loan-cond.NDays tt-loan-cond.NMonthes ~
tt-loan-cond.NYears tt-loan.end-date tt-percent.amt-rub tt-loan.ovrstop$ tt-loan.ovrstopr$ ~
tt-loan.ovrpr$ tt-loan.tranwspertip$ tt-loan-acct-main.acct tt-loan-acct-cust.acct ~
tt-loan-cond.cred-period tt-loan-cond.cred-date tt-loan-cond.cred-month ~
cred-offset_ tt-loan-cond.kollw#gtper$ tt-loan-cond.cred-mode ~
tt-loan-cond.cred-work-calend tt-loan-cond.cred-curr-next ~
tt-loan-cond.delay1 tt-loan-cond.DateDelay delay-offset_ ~
tt-loan-cond.kredplat$ tt-loan-cond.annuitplat$ tt-loan-cond.int-period ~
tt-loan-cond.int-date tt-loan-cond.int-month int-offset_ ~
tt-loan-cond.kollw#gtperprc$ tt-loan-cond.int-mode ~
tt-loan-cond.int-work-calend tt-loan-cond.int-curr-next tt-loan-cond.delay ~
tt-loan-cond.DateDelayInt delay-offset-int_ tt-loan-cond.isklmes$ ~
tt-loan.rewzim$ mLimit tt-loan-cond.disch-type mGrRiska mRisk ~
tt-loan.user-id tt-loan.loan-status tt-loan.trade-sys tt-dealer.cust-cat ~
tt-dealer.cust-id tt-broker.cust-cat tt-broker.cust-id tt-loan.comment mSvod ~
tt-loan-cond.annuitkorr$ mBag tt-loan-cond.grperiod$
&Scoped-define List-2 tt-loan.branch-id tt-loan.datasogl$ tt-loan.doc-num ~
tt-loan.cont-type tt-loan.DTType tt-loan.DTKind tt-loan-cond.NDays ~
tt-loan-cond.NMonthes tt-loan-cond.NYears tt-loan.end-date tt-loan.ovrstop$ tt-loan.ovrstopr$ ~
tt-loan.ovrpr$ tt-loan.tranwspertip$ tt-loan.rewzim$ tt-loan.user-id tt-loan.loan-status ~
tt-loan.close-date tt-loan.trade-sys tt-dealer.cust-cat tt-dealer.cust-id ~
tt-broker.cust-cat tt-broker.cust-id tt-loan.comment mSvod ~
tt-loan-cond.grperiod$
&Scoped-define List-3 tt-loan.branch-id tt-loan.datasogl$ tt-loan.cust-id ~
tt-loan.doc-num tt-loan.doc-ref tt-loan.cont-type tt-loan.DTType ~
tt-loan.DTKind tt-amount.amt-rub tt-loan.currency tt-loan.open-date ~
tt-loan-cond.NDays tt-loan-cond.NMonthes tt-loan-cond.NYears ~
tt-loan.end-date tt-percent.amt-rub tt-loan.ovrstop$ tt-loan.ovrstopr$ tt-loan.ovrpr$ tt-loan.tranwspertip$ ~
tt-loan-acct-main.acct tt-loan-acct-cust.acct tt-loan-cond.cred-period ~
tt-loan-cond.cred-date tt-loan-cond.cred-month cred-offset_ ~
tt-loan-cond.kollw#gtper$ tt-loan-cond.cred-mode ~
tt-loan-cond.cred-work-calend tt-loan-cond.cred-curr-next ~
tt-loan-cond.delay1 tt-loan-cond.DateDelay delay-offset_ ~
tt-loan-cond.kredplat$ tt-loan-cond.annuitplat$ tt-loan-cond.int-period ~
tt-loan-cond.int-date tt-loan-cond.int-month int-offset_ ~
tt-loan-cond.kollw#gtperprc$ tt-loan-cond.int-mode ~
tt-loan-cond.int-work-calend tt-loan-cond.int-curr-next tt-loan-cond.delay ~
tt-loan-cond.DateDelayInt delay-offset-int_ tt-loan-cond.isklmes$ mBag mSvod ~
tt-loan.rewzim$ tt-loan-cond.disch-type mGrRiska mRisk tt-loan.user-id ~
tt-loan.loan-status tt-loan.close-date tt-loan.trade-sys tt-dealer.cust-id ~
tt-broker.cust-id tt-loan.comment mSvod tt-loan.prodkod$ ~
tt-loan-cond.grperiod$
&Scoped-define List-4 tt-amount.amt-rub tt-percent.amt-rub ~
tt-loan-cond.cred-period tt-loan-cond.kollw#gtper$ tt-loan-cond.cred-mode ~
tt-loan-cond.cred-work-calend tt-loan-cond.cred-curr-next ~
tt-loan-cond.DateDelay tt-loan-cond.kredplat$ tt-loan-cond.kollw#gtperprc$ ~
tt-loan-cond.int-mode tt-loan-cond.int-work-calend ~
tt-loan-cond.int-curr-next tt-loan-cond.DateDelayInt tt-loan-cond.isklmes$ ~
mLimit  mLimitRest tt-loan-cond.annuitkorr$
&Scoped-define List-5 mBranchName CustName1 mNameCredPeriod mNameIntPeriod ~
mNameDischType CustName2 CustName3

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CheckCliAcct TERMINAL-SIMULATION
FUNCTION CheckCliAcct RETURNS LOGICAL
  ( INPUT iAcctType AS CHAR,
    INPUT iAcct AS CHAR,
    INPUT iCurr AS CHAR,
    INPUT iCat AS CHAR,
    INPUT iId AS INT64 )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetQntPer TERMINAL-SIMULATION
FUNCTION GetQntPer RETURNS INT64 (
   INPUT iBegDate  AS DATE, /* дата открытия договора */
   INPUT iEndDate  AS DATE, /* зата закрытия договора */
   INPUT iPayDay   AS INT64,  /* число, кот. производ. операция (только М и К) */
   INPUT iGlInt    AS CHAR, /* интервал м/у плановыми операциями */
   INPUT iCondBegD AS DATE  /* дата начала условия, используется при расчете даты при К или ПГ
                             ** если ? то отрабатывать доп.проверка не будет */
) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE cred-offset_ AS CHARACTER FORMAT "XX":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
     &ELSE SIZE 2 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE CustName1 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 41 BY 1
     &ELSE SIZE 41 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE CustName2 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 43 BY 1
     &ELSE SIZE 43 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE CustName3 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 43 BY 1
     &ELSE SIZE 43 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE delay-offset-int_ AS CHARACTER FORMAT "XX":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
     &ELSE SIZE 2 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE delay-offset_ AS CHARACTER FORMAT "XX":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
     &ELSE SIZE 2 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE int-offset_ AS CHARACTER FORMAT "XX":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
     &ELSE SIZE 2 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mBag AS CHARACTER FORMAT "X(256)":U
     LABEL "Портфель"
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mBranchName AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 30 BY 1
     &ELSE SIZE 30 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mGrRiska AS INT64 FORMAT "9" INITIAL 0
     LABEL "КК"
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 1 BY 1
     &ELSE SIZE 1 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mLimit AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0
     LABEL "Лимит"
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 13 BY 1
     &ELSE SIZE 13 BY 1 &ENDIF NO-UNDO.


DEFINE VARIABLE mLimitRest AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0
     LABEL "Лим.ост."
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 13 BY 1
     &ELSE SIZE 13 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mNameCredPeriod AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mNameDischType AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 32 BY 1
     &ELSE SIZE 32 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mNameIntPeriod AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mRisk AS DECIMAL FORMAT ">>9.99999" INITIAL 0
     LABEL "Риск"
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
     &ELSE SIZE 9 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE separator AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 42 BY 1
     &ELSE SIZE 42 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE separator-2 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 78 BY 1
     &ELSE SIZE 78 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE separator-3 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE separator-4 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 70 BY 1
     &ELSE SIZE 70 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE Separator-5 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 5 BY 1
     &ELSE SIZE 5 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSvod AS LOGICAL
     LABEL "Свод "
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8 BY 1 &ENDIF NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-comm FOR
      tt-comm-rate, tt-comm-cond SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-comm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-comm TERMINAL-SIMULATION _FREEFORM
  QUERY br-comm NO-LOCK DISPLAY
      tt-comm-rate.commission FORMAT "x(10)":U
      /*
      tt-comm-rate.local__id FORMAT 9
      */
      tt-comm-rate.rate-fixed FORMAT "=/%":U
      ENTRY(1,
            GetBufferValue(
               "commission",
               "WHERE commission.commission = '" + tt-comm-rate.commission + "'",
               "name-comm"),CHR(1))
         @ mNameCommi FORMAT "x(25)":U
      tt-comm-cond.FloatType FORMAT "Да/Нет":U
      tt-comm-rate.rate-comm FORMAT ">>>>>>>>>>>9.99999":U WIDTH 18
      tt-comm-rate.min_value FORMAT "->>>>>>>>9.99":U WIDTH 13
  ENABLE
      tt-comm-rate.commission
      tt-comm-rate.rate-fixed
      tt-comm-cond.FloatType
      tt-comm-rate.rate-comm
      tt-comm-rate.min_value
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-BOX NO-LABELS NO-ROW-MARKERS SIZE 78 BY 2 ROW-HEIGHT-CHARS 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     Separator-5
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 78 RIGHT-ALIGNED
          &ELSE AT ROW 4 COL 78 RIGHT-ALIGNED &ENDIF NO-LABEL
     tt-loan.branch-id
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 16 COLON-ALIGNED
          &ELSE AT ROW 1 COL 16 COLON-ALIGNED &ENDIF
          LABEL "Подразделение"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
     mBranchName
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 25 COLON-ALIGNED
          &ELSE AT ROW 1 COL 25 COLON-ALIGNED &ENDIF NO-LABEL
     tt-loan.datasogl$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 66 COLON-ALIGNED
          &ELSE AT ROW 1 COL 66 COLON-ALIGNED &ENDIF
          LABEL "    Закл"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-loan.cust-cat
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 2 COL 16 COLON-ALIGNED
          &ELSE AT ROW 2 COL 16 COLON-ALIGNED &ENDIF
          LABEL "     Контрагент"
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 5 BY 1
          &ELSE SIZE 5 BY 1 &ENDIF
     tt-loan.cust-id
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 2 COL 26 COLON-ALIGNED
          &ELSE AT ROW 2 COL 26 COLON-ALIGNED &ENDIF
          LABEL "Код"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
     CustName1
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 2 COL 35 COLON-ALIGNED
          &ELSE AT ROW 2 COL 35 COLON-ALIGNED &ENDIF NO-LABEL
     tt-loan.doc-num
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 16 COLON-ALIGNED
          &ELSE AT ROW 3 COL 16 COLON-ALIGNED &ENDIF
          LABEL "   Номер сделки" FORMAT "X(1022)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 22 BY 1
          &ELSE SIZE 22 BY 1 &ENDIF
     tt-loan.doc-ref
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 16 COLON-ALIGNED
          &ELSE AT ROW 2.99 COL 16 COLON-ALIGNED &ENDIF
          LABEL "Номер договора" FORMAT "x(22)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 23 BY 1
          &ELSE SIZE 23 BY 1 &ENDIF
     tt-loan.cont-type
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 44 COLON-ALIGNED
          &ELSE AT ROW 3 COL 44 COLON-ALIGNED &ENDIF
          LABEL "Тип"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
          &ELSE SIZE 9 BY 1 &ENDIF
     tt-loan.DTType
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 62 COLON-ALIGNED
          &ELSE AT ROW 3 COL 62 COLON-ALIGNED &ENDIF
          LABEL "  Сделка" FORMAT "x(256)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 13 BY 1
          &ELSE SIZE 13 BY 1 &ENDIF
     tt-loan.DTKind
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 62 COLON-ALIGNED
          &ELSE AT ROW 3 COL 62 COLON-ALIGNED &ENDIF HELP
          "Разновидность сделок"
          LABEL "Продукт" FORMAT "x(12)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 13 BY 1
          &ELSE SIZE 13 BY 1 &ENDIF
     tt-loan.prodkod$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 62 COLON-ALIGNED
          &ELSE AT ROW 3 COL 62 COLON-ALIGNED &ENDIF HELP
          "Код продукта"
          LABEL "Прод." FORMAT "x(12)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 13 BY 1
          &ELSE SIZE 13 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     tt-amount.amt-rub
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 16 COLON-ALIGNED
          &ELSE AT ROW 5 COL 16 COLON-ALIGNED &ENDIF
          LABEL "         Сумма"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-loan.currency
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 44 COLON-ALIGNED
          &ELSE AT ROW 5 COL 44 COLON-ALIGNED &ENDIF
          LABEL "Вал" FORMAT "x(3)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan.open-date
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 51 COLON-ALIGNED
          &ELSE AT ROW 5 COL 51 COLON-ALIGNED &ENDIF
          LABEL "С"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-loan-cond.NDays
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 48 COLON-ALIGNED
          &ELSE AT ROW 4 COL 48 COLON-ALIGNED &ENDIF
          LABEL "Дней" FORMAT ">>>>9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 5 BY 1
          &ELSE SIZE 5 BY 1 &ENDIF
     tt-loan-cond.NMonthes
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 59 COLON-ALIGNED
          &ELSE AT ROW 4 COL 59 COLON-ALIGNED &ENDIF
          LABEL "Мес" FORMAT ">>>9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 4 BY 1
          &ELSE SIZE 4 BY 1 &ENDIF
     tt-loan-cond.NYears
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 69 COLON-ALIGNED
          &ELSE AT ROW 4 COL 69 COLON-ALIGNED &ENDIF
          LABEL "Лет" FORMAT ">>9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan.end-date
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 66 COLON-ALIGNED
          &ELSE AT ROW 5 COL 66 COLON-ALIGNED &ENDIF
          LABEL "По"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-loan.sum-depos
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 16 COLON-ALIGNED
          &ELSE AT ROW 6 COL 16 COLON-ALIGNED &ENDIF
          LABEL " Сумма Вклада"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-loan-cond.PartAmount 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 44 COLON-ALIGNED
          &ELSE AT ROW 6 COL 44 COLON-ALIGNED &ENDIF
          LABEL " Доля(%)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan-cond.FirstPeriod 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 66 COLON-ALIGNED
          &ELSE AT ROW 6 COL 66 COLON-ALIGNED &ENDIF
          LABEL " Период ум."
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 4 BY 1
          &ELSE SIZE 4 BY 1 &ENDIF
     tt-percent.amt-rub
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 16 COLON-ALIGNED
          &ELSE AT ROW 6 COL 16 COLON-ALIGNED &ENDIF
          LABEL "      Проценты"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-loan.ovrstop$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 30 COLON-ALIGNED
          &ELSE AT ROW 6 COL 30 COLON-ALIGNED &ENDIF HELP
          "Количество дней до окончания срока кредитования, за которое пре"
          LABEL "Прекратить выдачу транша за" FORMAT ">>9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan.ovrstopr$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 34 COLON-ALIGNED
          &ELSE AT ROW 6 COL 34 COLON-ALIGNED &ENDIF 
&IF DEFINED(MANUAL-REMOTE) &THEN
          VIEW-AS COMBO-BOX INNER-LINES 3 DROP-DOWN-LIST  
&ELSE
          HELP "Размерность до окончания срока кредитования, за которое пре"
          NO-LABEL   FORMAT "д/м"  
          VIEW-AS FILL-IN 
&ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan.ovrpr$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 50 COLON-ALIGNED
          &ELSE AT ROW 6 COL 50 COLON-ALIGNED &ENDIF HELP
          "Период овердрафтного кредитования"
          LABEL "Длит.транша" FORMAT ">>9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan.tranwspertip$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 70 COLON-ALIGNED
          &ELSE AT ROW 6 COL 70 COLON-ALIGNED &ENDIF HELP
          "Разрешено вводить транши с пересекающимся периодом"
          LABEL "Пересек.транши " FORMAT "Да/Нет"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     tt-loan-acct-main.acct
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 7 COL 16 COLON-ALIGNED
          &ELSE AT ROW 7 COL 16 COLON-ALIGNED &ENDIF
          LABEL "Лицевой счет" FORMAT "x(20)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-loan-acct-cust.acct
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 7 COL 56 COLON-ALIGNED
          &ELSE AT ROW 7 COL 56 COLON-ALIGNED &ENDIF
          LABEL "Клиентский счет" FORMAT "x(20)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     separator
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 1
          &ELSE AT ROW 4 COL 1 &ENDIF NO-LABEL
     separator-2
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 8 COL 1
          &ELSE AT ROW 8 COL 1 &ENDIF NO-LABEL
     br-comm
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 1
          &ELSE AT ROW 9 COL 1 &ENDIF
     separator-3
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 11 COL 1
          &ELSE AT ROW 11 COL 1 &ENDIF NO-LABEL
     mSvod
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 11 COL 1
          &ELSE AT ROW 11 COL 1 &ENDIF HELP
          "Нажмите F1 для редактирования"
     separator-4
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 11 COL 9
          &ELSE AT ROW 11 COL 9 &ENDIF NO-LABEL
     tt-loan-cond.cred-period
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 9 COLON-ALIGNED
          &ELSE AT ROW 14 COL 9 COLON-ALIGNED &ENDIF
          LABEL "Осн.долг"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
     mNameCredPeriod
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 12 COLON-ALIGNED
          &ELSE AT ROW 14 COL 12 COLON-ALIGNED &ENDIF NO-LABEL
     tt-loan-cond.cred-date
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 21 COLON-ALIGNED
          &ELSE AT ROW 14 COL 21 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
     tt-loan-cond.cred-month
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 24 COLON-ALIGNED
          &ELSE AT ROW 14 COL 24 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
     tt-loan-cond.cred-offset
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 27 COLON-ALIGNED
          &ELSE AT ROW 14 COL 27 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Item 1"
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     cred-offset_
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 27 COLON-ALIGNED
          &ELSE AT ROW 14 COL 27 COLON-ALIGNED &ENDIF HELP
          "Режим смещения даты погашения (основной долг)" NO-LABEL
     tt-loan-cond.kollw#gtper$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 30 COLON-ALIGNED
          &ELSE AT ROW 14 COL 30 COLON-ALIGNED &ENDIF HELP
          "" NO-LABEL FORMAT ">>9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     tt-loan-cond.cred-mode
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 34 COLON-ALIGNED
          &ELSE AT ROW 14 COL 34 COLON-ALIGNED &ENDIF HELP
          "Способ задания платежного периода (основной долг)" NO-LABEL FORMAT "x(12)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
     tt-loan-cond.cred-work-calend
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 49 COLON-ALIGNED
          &ELSE AT ROW 14 COL 49 COLON-ALIGNED &ENDIF HELP
          "Режим расчета продолжительности периода (основной долг)" NO-LABEL FORMAT "Календ/Рабоч"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
     tt-loan-cond.cred-curr-next
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 49 COLON-ALIGNED
          &ELSE AT ROW 14 COL 49 COLON-ALIGNED &ENDIF HELP
          "Режим расчета окончания периода (основной долг)." NO-LABEL FORMAT "Текущ/След"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
     tt-loan-cond.delay1
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 60 RIGHT-ALIGNED
          &ELSE AT ROW 14 COL 60 RIGHT-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan-cond.DateDelay
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 56 COLON-ALIGNED
          &ELSE AT ROW 14 COL 56 COLON-ALIGNED &ENDIF HELP
          "Дата окончания (день месяца) окончания платежного периода по ос" NO-LABEL FORMAT ">9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan-cond.delay-offset
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 60 COLON-ALIGNED
          &ELSE AT ROW 14 COL 60 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Item 1"
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     delay-offset_
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 60 COLON-ALIGNED
          &ELSE AT ROW 14 COL 60 COLON-ALIGNED &ENDIF HELP
          "Режим смещения даты окончания платежного периода (основной долг)" NO-LABEL
     tt-loan-cond.kredplat$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 63 COLON-ALIGNED
          &ELSE AT ROW 14 COL 63 COLON-ALIGNED &ENDIF NO-LABEL FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
     tt-loan-cond.annuitplat$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 63 COLON-ALIGNED
          &ELSE AT ROW 14 COL 63 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     mTxtPercent
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 1
          &ELSE AT ROW 14.99 COL 1 &ENDIF
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
          NO-LABEL FORMAT "x(9)"
     tt-loan-cond.int-period
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 9 COLON-ALIGNED
          &ELSE AT ROW 14.99 COL 9 COLON-ALIGNED &ENDIF
          LABEL "Проценты"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
     mNameIntPeriod
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 12 COLON-ALIGNED
          &ELSE AT ROW 15 COL 12 COLON-ALIGNED &ENDIF NO-LABEL
     tt-loan-cond.int-date
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 21 COLON-ALIGNED
          &ELSE AT ROW 15 COL 21 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
     tt-loan-cond.int-month
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 24 COLON-ALIGNED
          &ELSE AT ROW 15 COL 24 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
     tt-loan-cond.int-offset
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 27 COLON-ALIGNED
          &ELSE AT ROW 15 COL 27 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Item 1"
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     int-offset_
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 27 COLON-ALIGNED
          &ELSE AT ROW 15 COL 27 COLON-ALIGNED &ENDIF HELP
          "Режим смещения даты погашения (проценты)" NO-LABEL
     tt-loan-cond.kollw#gtperprc$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 30 COLON-ALIGNED
          &ELSE AT ROW 15 COL 30 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan-cond.int-mode
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 34 COLON-ALIGNED
          &ELSE AT ROW 15 COL 34 COLON-ALIGNED &ENDIF HELP
          "Способ задания платежного периода (проценты)" NO-LABEL FORMAT "x(12)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
     tt-loan-cond.int-work-calend
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 49 COLON-ALIGNED
          &ELSE AT ROW 15 COL 49 COLON-ALIGNED &ENDIF HELP
          "Режим расчета продолжительности периода (проценты)" NO-LABEL FORMAT "Календ/Рабоч"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
     tt-loan-cond.int-curr-next
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 49 COLON-ALIGNED
          &ELSE AT ROW 15 COL 49 COLON-ALIGNED &ENDIF HELP
          "Режим расчета окончания периода (проц.)" NO-LABEL FORMAT "Текущ/След"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     tt-loan-cond.delay
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 56 COLON-ALIGNED
          &ELSE AT ROW 15 COL 56 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan-cond.DateDelayInt
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 56 COLON-ALIGNED
          &ELSE AT ROW 15 COL 56 COLON-ALIGNED &ENDIF HELP
          "Дата окончания (день месяца) платежного периода по процентам" NO-LABEL FORMAT ">9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan-cond.delay-offset-int
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 60 COLON-ALIGNED
          &ELSE AT ROW 15 COL 60 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Item 1"
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     delay-offset-int_
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 60 COLON-ALIGNED
          &ELSE AT ROW 15 COL 60 COLON-ALIGNED &ENDIF HELP
          "Режим смещения даты окончания платежного периода (проценты)" NO-LABEL
     tt-loan-cond.annuitkorr$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 75 COLON-ALIGNED
          &ELSE AT ROW 15 COL 75 COLON-ALIGNED &ENDIF
          LABEL "Корр." FORMAT "-9"
          HELP "Изм. числа период. аннуитета, ? - по НП АннуитФорм"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
     tt-loan-cond.grperiod$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 63 COLON-ALIGNED
          &ELSE AT ROW 15 COL 63 COLON-ALIGNED &ENDIF HELP
          "График ОД - ежедневный с периодическим обнулением (F1/пробел - периода построения)"
          LABEL " Гр. ОД"
          VIEW-AS TOGGLE-BOX      
     tt-loan-cond.isklmes$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 1
          &ELSE AT ROW 16 COL 1 &ENDIF HELP
          "Нажмите F1 для редактирования условий"
          LABEL "Искл. мес."
          VIEW-AS TOGGLE-BOX
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 13 BY 1
          &ELSE SIZE 13 BY 1 &ENDIF
     mBag
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 23 COLON-ALIGNED
          &ELSE AT ROW 16 COL 23 COLON-ALIGNED &ENDIF
     tt-loan.rewzim$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 42 COLON-ALIGNED
          &ELSE AT ROW 16 COL 42 COLON-ALIGNED &ENDIF HELP
          "Формы договоров привлечения"
          LABEL "Режим" FORMAT "x(256)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
          &ELSE SIZE 11 BY 1 &ENDIF
     mLimit
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 64 COLON-ALIGNED
          &ELSE AT ROW 16 COL 64 COLON-ALIGNED &ENDIF HELP
          "Лимит выдачи на дату состояния"
     tt-loan-cond.disch-type
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 14 COLON-ALIGNED
          &ELSE AT ROW 17 COL 14 COLON-ALIGNED &ENDIF
          LABEL "Форма расчета"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     mNameDischType
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 18 COLON-ALIGNED
          &ELSE AT ROW 17 COL 18 COLON-ALIGNED &ENDIF NO-LABEL DISABLE-AUTO-ZAP
     mLimitRest
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 64 COLON-ALIGNED
          &ELSE AT ROW 17 COL 64 COLON-ALIGNED &ENDIF HELP
          "Оставшийся лимит выдачи на дату состояния"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     mGrRiska
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 4 COLON-ALIGNED
          &ELSE AT ROW 18 COL 4 COLON-ALIGNED &ENDIF HELP
          "Категория качества"
     mRisk
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 12 COLON-ALIGNED
          &ELSE AT ROW 18 COL 12 COLON-ALIGNED &ENDIF HELP
          "Риск данной операции, задаваемый пользователем"
     tt-loan.user-id
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 33 COLON-ALIGNED
          &ELSE AT ROW 18 COL 33 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
     tt-loan.loan-status
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 50 COLON-ALIGNED
          &ELSE AT ROW 18 COL 50 COLON-ALIGNED &ENDIF
          LABEL "Статус"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
     tt-loan.close-date
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 66 COLON-ALIGNED
          &ELSE AT ROW 18 COL 66 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-loan.trade-sys
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 14 COLON-ALIGNED
          &ELSE AT ROW 19 COL 14 COLON-ALIGNED &ENDIF
          LABEL "Торг.система"
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
     tt-dealer.cust-cat
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 12 COLON-ALIGNED
          &ELSE AT ROW 18 COL 12 COLON-ALIGNED &ENDIF
          LABEL "    Дилер" FORMAT "x(5)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 5 BY 1
          &ELSE SIZE 5 BY 1 &ENDIF
     tt-dealer.cust-id
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 24 COLON-ALIGNED
          &ELSE AT ROW 19 COL 24 COLON-ALIGNED &ENDIF
          LABEL "Код"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
     CustName2
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 33 COLON-ALIGNED
          &ELSE AT ROW 19 COL 33 COLON-ALIGNED &ENDIF NO-LABEL
     tt-broker.cust-cat
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 13 COLON-ALIGNED
          &ELSE AT ROW 19 COL 13 COLON-ALIGNED &ENDIF
          LABEL "    Брокер" FORMAT "x(5)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 5 BY 1
          &ELSE SIZE 5 BY 1 &ENDIF
     tt-broker.cust-id
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 24 COLON-ALIGNED
          &ELSE AT ROW 19 COL 24 COLON-ALIGNED &ENDIF
          LABEL "Код"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     CustName3
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 33 COLON-ALIGNED
          &ELSE AT ROW 19 COL 33 COLON-ALIGNED &ENDIF NO-LABEL
     tt-loan.comment
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 1
          &ELSE AT ROW 19 COL 1 &ENDIF HELP
          "Введите комментарий." NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP LARGE NO-BOX
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 78 BY 1
          &ELSE SIZE 78 BY 1 &ENDIF
     "Погашение" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
          &ELSE SIZE 9 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 1
          &ELSE AT ROW 12 COL 1 &ENDIF
     "Дн" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 58
          &ELSE AT ROW 12 COL 58 &ENDIF
     "Сумма платежа" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 65
          &ELSE AT ROW 12 COL 65 &ENDIF
     "--" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 26
          &ELSE AT ROW 13 COL 26 &ENDIF
     "---------" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
          &ELSE SIZE 9 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 1
          &ELSE AT ROW 13 COL 1 &ENDIF
     "--" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 23
          &ELSE AT ROW 13 COL 23 &ENDIF
     "--------------" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 36
          &ELSE AT ROW 13 COL 36 &ENDIF
     "--" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 29
          &ELSE AT ROW 13 COL 29 &ENDIF
     "---" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 58
          &ELSE AT ROW 13 COL 58 &ENDIF
     "---" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 32
          &ELSE AT ROW 13 COL 32 &ENDIF
     "------" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 51
          &ELSE AT ROW 13 COL 51 &ENDIF
     "--------------" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 65
          &ELSE AT ROW 13 COL 65 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     "Период" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
          &ELSE SIZE 11 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 11
          &ELSE AT ROW 12 COL 11 &ENDIF
     "--" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 62
          &ELSE AT ROW 13 COL 62 &ENDIF
     "Сд" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 29
          &ELSE AT ROW 12 COL 29 &ENDIF
     "Дн" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 23
          &ELSE AT ROW 12 COL 23 &ENDIF
     "Плат. период" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 36
          &ELSE AT ROW 12 COL 36 &ENDIF
     "Мс" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 26
          &ELSE AT ROW 12 COL 26 &ENDIF
     "Льг" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 32
          &ELSE AT ROW 12 COL 32 &ENDIF
     "Сд" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 62
          &ELSE AT ROW 12 COL 62 &ENDIF
     "Режим" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 51
          &ELSE AT ROW 12 COL 51 &ENDIF
     "-----------" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
          &ELSE SIZE 11 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 11
          &ELSE AT ROW 13 COL 11 &ENDIF
     mHiddenField
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 34 COLON-ALIGNED
          &ELSE AT ROW 12 COL 34 COLON-ALIGNED &ENDIF
          VIEW-AS EDITOR
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 43 BY 2
          &ELSE SIZE 43 BY 2 &ENDIF NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21
        TITLE "".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Temp-Tables and Buffers:
      TABLE: tt-amount T "?" NO-UNDO bisquit term-obl
      ADDITIONAL-FIELDS:
          FIELD viddogob$ AS CHARACTER /* ВидДогОб (Вид договора обеспечения) */
          FIELD vidob$ AS CHARACTER /* ВидОб (Вид предмета обеспечения) */
          FIELD datapost$ AS DATE /* ДатаПост (Дата поступления) */
          FIELD dopinfo$ AS CHARACTER /* ДопИнфо (Дополнительная информация) */
          FIELD mestonahowzdenie$ AS CHARACTER /* Местонахождение (Местонахождение имущества) */
          FIELD nomdogob$ AS CHARACTER /* НомДогОб (Номер договора обеспечения) */
          FIELD nomerpp$ AS INT64 /* НомерПП (Порядковый номер) */
          FIELD opisanie$ AS CHARACTER /* Описание (Описание предмета обеспечения) */
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-amount" "amount" }

      END-FIELDS.
      TABLE: tt-broker T "?" NO-UNDO bisquit cust-role
      ADDITIONAL-FIELDS:
          FIELD contract AS CHARACTER /* contract (Номер договора) */
          FIELD HiddenFields AS CHARACTER /* HiddenFields (Список скр. полей в завис. от Ver-format) */
          FIELD is_mandatory AS LOGICAL /* is_mandatory (Основная роль) */
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */
          INDEX cust-role-id cust-role-id
          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-broker" "broker" }

      END-FIELDS.
      TABLE: tt-comm-rate T "?" NO-UNDO bisquit comm-rate
      ADDITIONAL-FIELDS:
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */
          FIELD min_value       AS DECIMAL help "Минимальное значение за весь период просрочки"  /* Минимальное значение */
          INDEX local__id IS UNIQUE local__id
          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-comm-rate" "loan-cond:comm-rate" }

      END-FIELDS.

      TABLE: tt-comm-cond T "?" NO-UNDO bisquit comm-cond
      ADDITIONAL-FIELDS:
         FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
         FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
         FIELD local__id       AS INT64   /* Идентификатор записи     */
         FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
         FIELD user__mode      AS INT64   /* Флаг управления записью в БД */
         INDEX local__id IS UNIQUE local__id
         /* Записываем ссылку на временную таблицу в специальную таблицу */
         {ln-tthdl.i "tt-comm-cond" "loan-cond:comm-cond" }
         .

      END-FIELDS.

      TABLE: tt-commrate T "?" NO-UNDO bisquit comm-rate
      ADDITIONAL-FIELDS:
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-commrate" "commrate" }

      END-FIELDS.

      TABLE: tt-contragent T "?" NO-UNDO bisquit cust-role
      ADDITIONAL-FIELDS:
          FIELD contract AS CHARACTER /* contract (Номер договора) */
          FIELD HiddenFields AS CHARACTER /* HiddenFields (Список скр. полей в завис. от Ver-format) */
          FIELD is_mandatory AS LOGICAL /* is_mandatory (Основная роль) */
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */
          INDEX cust-role-id cust-role-id
          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-contragent" "contragent" }

      END-FIELDS.
      TABLE: tt-dealer T "?" NO-UNDO bisquit cust-role
      ADDITIONAL-FIELDS:
          FIELD contract AS CHARACTER /* contract (Номер договора) */
          FIELD HiddenFields AS CHARACTER /* HiddenFields (Список скр. полей в завис. от Ver-format) */
          FIELD is_mandatory AS LOGICAL /* is_mandatory (Основная роль) */
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */
          INDEX cust-role-id cust-role-id
          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-dealer" "dealer" }

      END-FIELDS.
      TABLE: tt-loan T "?" NO-UNDO bisquit loan
      ADDITIONAL-FIELDS:
          FIELD akt_vzv$ AS CHARACTER /* Акт_взв (Активы взешенные с учетом риска) */
          FIELD grup_dog$ AS CHARACTER /* Груп_дог (Группа договора) */
          FIELD datasogl$ AS DATE /* ДатаСогл (Дата заключения кредитного договора) */
          FIELD data_uar$ AS CHARACTER /* Дата_УАР (Номер и дата подтверждения УАР) */
          FIELD dosroka$ AS CHARACTER /* ДоСРОКА (Нельзя снимать средства до срока) */
          FIELD igndtokwc$ AS LOGICAL /* ИгнДтОкч (Игнорировать дату окончания договора) */
          FIELD nesno$ AS CHARACTER /* НеснО (Неснижаемые обороты) */
          FIELD okrugsum$ AS LOGICAL /* ОкругСум (Округление суммы плановых платежей) */
          FIELD rewzim$ AS CHARACTER /* Режим (Формы договоров привлечения) */
          FIELD sindkred$ AS LOGICAL /* СиндКред (Синдицированный кредит) */
          FIELD BankCust AS CHARACTER /* BankCust (Код клиента исполняющего банка) */
          FIELD Bfnc AS CHARACTER /* Bfnc (Код функции Bfnc в DBI) */
          FIELD CallAcct AS CHARACTER /* CallAcct (DBI счет требований по аккредитиву) */
          FIELD dateend AS DATE /* dateend (Дата окончания/закрытия из ldmfDD.txt) */
          FIELD DTKind AS CHARACTER /* DTKind (Разновидность сделки для Decision Table) */
          FIELD DTType AS CHARACTER /* DTType (Вид договора для Decision Table) */
          FIELD Exec_D AS LOGICAL /* Exec_D (Не учитывать при подсчете кол-ва дог.) */
          FIELD IntAcct AS CHARACTER /* IntAcct (Процентный DBI счет) */
          FIELD list_type AS CHARACTER /* list_type (Список типов счетов для авт. закрытия) */
          FIELD main-loan-acct AS CHARACTER /* main-loan-acct (Роль счета) */
          FIELD main-loan-cust AS CHARACTER /* main-loan-cust (Основная роль клиента) */
          FIELD OblAcct AS CHARACTER /* OblAcct (DBI счет обязательств по аккредитиву) */
          FIELD op-date AS CHARACTER /* op-date (1111) */
          FIELD PrevLoanID AS CHARACTER /* PrevLoanID (Ссылка на пролонгированную сделку) */
          FIELD ProfitCenter AS CHARACTER /* ProfitCenter (Код подразделения банка/ProfitCenter) */
          FIELD rel_type AS CHARACTER /* rel_type (Список типов счетов для привязки) */
          FIELD ReplDate AS DATE /* ReplDate (Дата отмены сделки) */
          FIELD RevRef1 AS CHARACTER /* RevRef1 (Ссылка на новую сделку) */
          FIELD RevRef2 AS CHARACTER /* RevRef2 (Ссылка на отмененную сделку) */
          FIELD round AS LOGICAL /* round (Округление) */
          FIELD TermKey AS CHARACTER /* TermKey (Код срочности в DBI) */
          FIELD TicketNumber AS CHARACTER /* TicketNumber (Номер тикета DBI (DocNum)) */
          FIELD ovrpr$ AS INT64
          FIELD ovrstop$ AS INT64
          FIELD ovrstopr$ AS CHARACTER /* ДР ОврСтопР */
          FIELD tranwspertip$ AS LOGICAL /* ДР ТраншПерТип */
          FIELD prodkod$ AS CHARACTER /* Продукты КиД:код продукта */
          FIELD svodgravto$ AS LOGICAL /* ДР СводГрАвто */
          FIELD svodgrafik$ AS LOGICAL /* ДР СводГрафик */
          FIELD svodskonca$ AS LOGICAL /* ДР СводСКонца */
          FIELD svodspostr$ AS LOGICAL /* ДР СводСПосТр */
          FIELD sum-depos AS DECIMAL /* ДР Сумма связанного вклада */
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */
          FIELD rate-list AS CHARACTER
          FIELD stream-show AS LOGICAL
          FIELD AgrCounter  AS CHARACTER     /* Номер договора по счетчику */
          FIELD LimitGrafDate AS DATE
          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-loan" "" }

      END-FIELDS.
      TABLE: tt-loan-acct T "?" NO-UNDO bisquit loan-acct
      ADDITIONAL-FIELDS:
          FIELD class-code AS CHARACTER /* class-code (Класс loan-acct) */
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-loan-acct" "loan-acct" }

      END-FIELDS.
      TABLE: tt-loan-acct-cust T "?" NO-UNDO bisquit loan-acct
      ADDITIONAL-FIELDS:
          FIELD class-code AS CHARACTER /* class-code (Класс loan-acct) */
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-loan-acct-cust" "loan-acct-cust" }

      END-FIELDS.
      TABLE: tt-loan-acct-main T "?" NO-UNDO bisquit loan-acct
      ADDITIONAL-FIELDS:
          FIELD class-code AS CHARACTER /* class-code (Класс loan-acct) */
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-loan-acct-main" "loan-acct-main" }

      END-FIELDS.
      TABLE: tt-loan-cond T "?" NO-UNDO bisquit loan-cond
      ADDITIONAL-FIELDS:
          FIELD annuitplat$  AS DECIMAL /* АннуитПлат (Сумма аннуитетного платежа) */
          FIELD end-date AS DATE /* end-date (Дата окончания) */
          FIELD EndDateBeforeProl AS DATE /* EndDateBeforeProl (Дата окончания вклада до пролонгации) */
          FIELD kollw#gtper$ AS INT64 /* КолЛьгтПер (Количество льготных периодов) */
          FIELD kollw#gtperprc$ AS INT64 /* КолЛьгтПерПрц (Количество льготных периодов (проценты)) */
          FIELD cred-offset AS CHARACTER
          FIELD int-offset AS CHARACTER
          FIELD delay-offset AS CHARACTER
          FIELD delay-offset-int AS CHARACTER
          FIELD cred-mode AS CHARACTER /* cred-mode (Способ задания плат.периода (осн.долг)) */
          FIELD int-mode AS CHARACTER /* int-mode (Способ задания плат.периода (проценты)) */
          FIELD DateDelay AS INT64 /* DateDelay (День окончания плат.периода (осн.долг)) */
          FIELD DateDelayInt AS INT64 /* DateDelayInt (День окончания плат.периода (проценты)) */
          FIELD cred-work-calend AS LOGICAL /* cred-work-cale (Режим расчета продолж.периода (осн.долг)) */
          FIELD cred-curr-next AS LOGICAL /* cred-curr-next (Режим расчета окончания периода(осн.долг) */
          FIELD int-work-calend AS LOGICAL /* int-work-calen (Режим расчета продолж.периода (проценты)) */
          FIELD int-curr-next AS LOGICAL /* int-curr-next (Режим расчета окончания периода (проц.)) */
          FIELD Prolong AS LOGICAL /* Prolong (Пролонгция вклада) */
          FIELD interest AS CHAR /* Схема начилений */
          FIELD shemaplat$ AS LOGICAL /* СхемаПлат (Схема платежа) */
          FIELD isklmes$ AS LOGICAL /* ИсклМес (Наличие исключений месяцев) */
          FIELD NDays AS INT64 /* Количество дней действия условия */
          FIELD NMonthes AS INT64 /* Количество месяцев действия условия */
          FIELD NYears AS INT64 /* Количество лет действия условия */
          FIELD Test01 AS CHARACTER /* Test01 (Test01) */
          FIELD kredplat$ AS DECIMAL /* КредПлат (Сумма периодич.платежа погаш. осн.долга) */
          FIELD prodtrf$ AS CHARACTER /* Код тарифа продукта */
          FIELD PartAmount AS DECIMAL /* ДР Доля кредита первого периода */
          FIELD FirstPeriod AS INTEGER /* ДР Продолжительность первого периода в месяцах */
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-loan-cond" "loan-cond" }

      END-FIELDS.
      TABLE: tt-MonthOut T "?" NO-UNDO bisquit term-obl
      ADDITIONAL-FIELDS:
          FIELD viddogob$ AS CHARACTER /* ВидДогОб (Вид договора обеспечения) */
          FIELD vidob$ AS CHARACTER /* ВидОб (Вид предмета обеспечения) */
          FIELD datapost$ AS DATE /* ДатаПост (Дата поступления) */
          FIELD dopinfo$ AS CHARACTER /* ДопИнфо (Дополнительная информация) */
          FIELD mestonahowzdenie$ AS CHARACTER /* Местонахождение (Местонахождение имущества) */
          FIELD nomdogob$ AS CHARACTER /* НомДогОб (Номер договора обеспечения) */
          FIELD nomerpp$ AS INT64 /* НомерПП (Порядковый номер) */
          FIELD opisanie$ AS CHARACTER /* Описание (Описание предмета обеспечения) */
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-MonthOut" "loan-cond:MonthOut" }

      END-FIELDS.
      TABLE: tt-MonthSpec T "?" NO-UNDO bisquit term-obl
      ADDITIONAL-FIELDS:
          FIELD viddogob$ AS CHARACTER /* ВидДогОб (Вид договора обеспечения) */
          FIELD vidob$ AS CHARACTER /* ВидОб (Вид предмета обеспечения) */
          FIELD datapost$ AS DATE /* ДатаПост (Дата поступления) */
          FIELD dopinfo$ AS CHARACTER /* ДопИнфо (Дополнительная информация) */
          FIELD mestonahowzdenie$ AS CHARACTER /* Местонахождение (Местонахождение имущества) */
          FIELD nomdogob$ AS CHARACTER /* НомДогОб (Номер договора обеспечения) */
          FIELD nomerpp$ AS INT64 /* НомерПП (Порядковый номер) */
          FIELD opisanie$ AS CHARACTER /* Описание (Описание предмета обеспечения) */
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-MonthSpec" "loan-cond:MonthSpec" }

      END-FIELDS.
      TABLE: tt-percent T "?" NO-UNDO bisquit term-obl
      ADDITIONAL-FIELDS:
          FIELD viddogob$ AS CHARACTER /* ВидДогОб (Вид договора обеспечения) */
          FIELD vidob$ AS CHARACTER /* ВидОб (Вид предмета обеспечения) */
          FIELD datapost$ AS DATE /* ДатаПост (Дата поступления) */
          FIELD dopinfo$ AS CHARACTER /* ДопИнфо (Дополнительная информация) */
          FIELD mestonahowzdenie$ AS CHARACTER /* Местонахождение (Местонахождение имущества) */
          FIELD nomdogob$ AS CHARACTER /* НомДогОб (Номер договора обеспечения) */
          FIELD nomerpp$ AS INT64 /* НомерПП (Порядковый номер) */
          FIELD opisanie$ AS CHARACTER /* Описание (Описание предмета обеспечения) */
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-percent" "percent" }

      END-FIELDS.
      TABLE: tt-term-obl T "?" NO-UNDO bisquit term-obl
      ADDITIONAL-FIELDS:
          FIELD viddogob$ AS CHARACTER /* ВидДогОб (Вид договора обеспечения) */
          FIELD vidob$ AS CHARACTER /* ВидОб (Вид предмета обеспечения) */
          FIELD datapost$ AS DATE /* ДатаПост (Дата поступления) */
          FIELD dopinfo$ AS CHARACTER /* ДопИнфо (Дополнительная информация) */
          FIELD mestonahowzdenie$ AS CHARACTER /* Местонахождение (Местонахождение имущества) */
          FIELD nomdogob$ AS CHARACTER /* НомДогОб (Номер договора обеспечения) */
          FIELD nomerpp$ AS INT64 /* НомерПП (Порядковый номер) */
          FIELD opisanie$ AS CHARACTER /* Описание (Описание предмета обеспечения) */
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INT64   /* Идентификатор записи     */
          FIELD local__upid     AS INT64   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INT64   /* Флаг управления записью в БД */

          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-term-obl" "term-obl" }

      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW TERMINAL-SIMULATION ASSIGN
         HIDDEN             = YES
         TITLE              = "   <insert window title>"
         HEIGHT             = 26.28
         WIDTH              = 91.43
         MAX-HEIGHT         = 26.28
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 26.28
         VIRTUAL-WIDTH      = 91.43
         RESIZE             = YES
         SCROLL-BARS        = NO
         STATUS-AREA        = YES
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = YES
         THREE-D            = YES
         MESSAGE-AREA       = YES
         SENSITIVE          = YES.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB TERMINAL-SIMULATION
/* ************************* Included-Libraries *********************** */

{bis-tty.pro}
{termobl.pro}           /* Инструменты для работы с плановыми сущностями. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME fMain
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-comm separator-2 fMain */
/* SETTINGS FOR FILL-IN tt-loan-acct-cust.acct IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL EXP-FORMAT                                   */
/* SETTINGS FOR FILL-IN tt-loan-acct-main.acct IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL EXP-FORMAT                                   */
/* SETTINGS FOR FILL-IN tt-amount.amt-rub IN FRAME fMain
   NO-ENABLE 1 3 4 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-percent.amt-rub IN FRAME fMain
   NO-ENABLE 1 3 4 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan-cond.annuitplat$ IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR BROWSE br-comm IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-loan.branch-id IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan.close-date IN FRAME fMain
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR EDITOR tt-loan.comment IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                        */
ASSIGN
       tt-loan.comment:RETURN-INSERTED IN FRAME fMain  = TRUE.

/* SETTINGS FOR FILL-IN tt-loan.cont-type IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan-cond.cred-curr-next IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-loan-cond.cred-date IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN tt-loan-cond.cred-mode IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
ASSIGN
       tt-loan-cond.cred-mode:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN tt-loan-cond.cred-month IN FRAME fMain
   1 3 EXP-LABEL                                                        */
/* SETTINGS FOR FILL-IN cred-offset_ IN FRAME fMain
   1 3                                                                  */
ASSIGN
       cred-offset_:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN tt-loan-cond.cred-period IN FRAME fMain
   NO-ENABLE 1 3 4 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan-cond.cred-work-calend IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-loan.currency IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL EXP-FORMAT                                   */
/* SETTINGS FOR COMBO-BOX tt-loan.cust-cat IN FRAME fMain
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR COMBO-BOX tt-dealer.cust-cat IN FRAME fMain
   NO-ENABLE 1 2 EXP-LABEL EXP-FORMAT                                   */
/* SETTINGS FOR COMBO-BOX tt-broker.cust-cat IN FRAME fMain
   NO-ENABLE 1 2 EXP-LABEL EXP-FORMAT                                   */
/* SETTINGS FOR FILL-IN tt-dealer.cust-id IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-broker.cust-id IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan.cust-id IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN CustName1 IN FRAME fMain
   NO-ENABLE 5                                                          */
ASSIGN
       CustName1:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN CustName2 IN FRAME fMain
   NO-ENABLE 5                                                          */
ASSIGN
       CustName2:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN CustName3 IN FRAME fMain
   NO-ENABLE 5                                                          */
ASSIGN
       CustName3:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN tt-loan.datasogl$ IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan-cond.DateDelay IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-loan-cond.DateDelayInt IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-loan-cond.delay IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN delay-offset-int_ IN FRAME fMain
   1 3                                                                  */
ASSIGN
       delay-offset-int_:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN delay-offset_ IN FRAME fMain
   1 3                                                                  */
ASSIGN
       delay-offset_:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN tt-loan-cond.delay1 IN FRAME fMain
   NO-ENABLE ALIGN-R 1 3 EXP-LABEL                                      */
/* SETTINGS FOR FILL-IN tt-loan-cond.disch-type IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN tt-loan.doc-num IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT                                 */
/* SETTINGS FOR FILL-IN tt-loan.doc-ref IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL EXP-FORMAT                                   */
/* SETTINGS FOR FILL-IN tt-loan.DTKind IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                        */
/* SETTINGS FOR FILL-IN tt-loan.DTType IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT                                 */
/* SETTINGS FOR FILL-IN tt-loan.end-date IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan-cond.int-curr-next IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-loan-cond.int-date IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN tt-loan-cond.int-mode IN FRAME fMain
   NO-ENABLE 1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                        */
ASSIGN
       tt-loan-cond.int-mode:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN tt-loan-cond.int-month IN FRAME fMain
   1 3 EXP-LABEL                                                        */
/* SETTINGS FOR FILL-IN int-offset_ IN FRAME fMain
   1 3                                                                  */
ASSIGN
       int-offset_:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN tt-loan-cond.int-period IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN tt-loan-cond.int-work-calend IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR TOGGLE-BOX tt-loan-cond.isklmes$ IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-loan-cond.kollw#gtper$ IN FRAME fMain
   NO-ENABLE 1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                        */
/* SETTINGS FOR FILL-IN tt-loan-cond.kollw#gtperprc$ IN FRAME fMain
   1 3 4 EXP-LABEL                                                      */
/* SETTINGS FOR FILL-IN tt-loan-cond.kredplat$ IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tt-loan.loan-status IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN mBag IN FRAME fMain
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN mBranchName IN FRAME fMain
   NO-ENABLE 5                                                          */
ASSIGN
       mBranchName:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN mGrRiska IN FRAME fMain
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN mLimit IN FRAME fMain
   1 4                                                                  */
/* SETTINGS FOR FILL-IN mLimitRest IN FRAME fMain
   4                                                                    */
/* SETTINGS FOR FILL-IN mNameCredPeriod IN FRAME fMain
   NO-ENABLE 5                                                          */
ASSIGN
       mNameCredPeriod:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN mNameDischType IN FRAME fMain
   NO-ENABLE 5                                                          */
ASSIGN
       mNameDischType:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN mNameIntPeriod IN FRAME fMain
   NO-ENABLE 5                                                          */
ASSIGN
       mNameIntPeriod:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN mRisk IN FRAME fMain
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN tt-loan-cond.NDays IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tt-loan-cond.NMonthes IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tt-loan-cond.NYears IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tt-loan.open-date IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN tt-loan.ovrpr$ IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                        */
/* SETTINGS FOR FILL-IN tt-loan.ovrstop$ IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                        */
/* SETTINGS FOR FILL-IN tt-loan.ovrstopr$ IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                        */
/* SETTINGS FOR FILL-IN tt-loan.tranwspertip$ IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                        */
/* SETTINGS FOR FILL-IN tt-loan.rewzim$ IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                        */
/* SETTINGS FOR FILL-IN separator IN FRAME fMain
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN
       separator:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN separator-2 IN FRAME fMain
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN separator-3 IN FRAME fMain
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN separator-4 IN FRAME fMain
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN Separator-5 IN FRAME fMain
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
/* SETTINGS FOR COMBO-BOX tt-loan.trade-sys IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan.user-id IN FRAME fMain
   NO-ENABLE 1 2 3                                                      */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(TERMINAL-SIMULATION)
THEN TERMINAL-SIMULATION:HIDDEN = YES.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-comm
/* Query rebuild information for BROWSE br-comm
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} PRESELECT EACH tt-comm-rate WHERE tt-comm-rate.since EQ tt-loan-cond.since SHARE-LOCK, LAST tt-comm-cond OUTER-JOIN WHERE tt-comm-cond.commission EQ tt-comm-rate.commission AND tt-comm-cond.since LE tt-comm-rate.since SHARE-LOCK BY tt-comm-rate.commission INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-comm */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fMain
/* Query rebuild information for FRAME fMain
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fMain */
&ANALYZE-RESUME

/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME tt-loan-acct-main.acct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-acct-main.acct TERMINAL-SIMULATION
ON F1 OF tt-loan-acct-main.acct IN FRAME fMain /* Лицевой счет */
,tt-loan-acct-cust.acct
DO:
   DEFINE VARIABLE vFields AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vFieldsValue AS CHARACTER  NO-UNDO.
   IF iMode EQ {&MOD_VIEW} THEN DO:
      {find-act.i
         &acct    = SELF:SCREEN-VALUE
         &curr    = tt-loan.currency:SCREEN-VALUE
         }
      IF AVAIL acct THEN
         RUN formld.p(acct.class-code,
                      acct.acct + "," + acct.currency, "", "{&MOD_VIEW}",
                      iLevel + 1) NO-ERROR.
   END.
   ELSE
   DO TRANS:
      vFields =
         "OffLdFlt|" +
         "acct-cat" + CHR(1) +
         "cust-cat" + CHR(1) +
         "cust-id" + CHR(1) +
         "currency".
      vFieldsValue =
         "YES|" +
         "b" + CHR(1) +
         tt-loan.cust-cat:SCREEN-VALUE + CHR(1) +
         STRING(tt-loan.cust-id:INPUT-VALUE) + CHR(1) +
         tt-loan.currency:SCREEN-VALUE.
      RUN browseld.p ("acct",
                vFields,
                vFieldsValue,
                "cust-cat"  + CHR(1) + "cust-id",
                iLevel + 1).
      IF LASTKEY = 10 AND pick-value <> ? THEN
         SELF:SCREEN-VALUE = ENTRY(1,pick-value).
   END.
   RUN PutHelp("",FRAME {&MAIN-FRAME}:HANDLE).
   /* Давим пищалку */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mLimitGraf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mLimitGraf TERMINAL-SIMULATION
ON F6 OF FRAME fMain ANYWHERE
DO:
DEFINE VARIABLE vRez AS LOGICAL NO-UNDO .

  /* Форма заполнения условий разворачивания графиков лимитов */
  IF tt-loan.rewzim$:SCREEN-VALUE  NE ? AND
     tt-loan.rewzim$:SCREEN-VALUE  NE ""  THEN DO:

      mDate2  = tt-loan.LimitGrafDate .
      RUN limgru.p (
          iMode ,
          tt-loan.contract  ,
          tt-loan.cont-code ,
          tt-loan.open-date ,
          DATE(tt-loan.end-date:SCREEN-VALUE ),
          INPUT-OUTPUT mDate2  ,
          OUTPUT  vRez
          ).
      IF iMode NE {&MOD_VIEW} THEN DO:
         tt-loan.LimitGrafDate = mdate2.
      END.
  END.
  ELSE DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "Не задан режим кредитной линии!" ).
      RETURN NO-APPLY .
  END.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-acct-main.acct TERMINAL-SIMULATION
ON LEAVE OF tt-loan-acct-main.acct IN FRAME fMain /* Лицевой счет */
,tt-loan-acct-cust.acct
DO:
   {&BEG_BT_LEAVE}
   IF iMode NE {&MOD_VIEW} THEN
   DO:
      IF     SELF:SCREEN-VALUE NE ""
         AND SELF:SCREEN-VALUE NE "?"  THEN
      DO:
         {find-act.i
            &acct    = SELF:SCREEN-VALUE
            &curr    = tt-loan.currency:SCREEN-VALUE
         }

         IF AVAIL acct THEN
         DO:
            IF acct.branch-id NE tt-loan.branch-id:SCREEN-VALUE
            THEN DO:
               RUN Fill-SysMes IN h_tmess (
                  "", "", "4",
                  "Код подразделения договора не совпадает\nс кодом подразделения " +
                  "выбранного счета.\nПродолжить?"
               ).
               IF pick-value NE "YES"
               THEN DO:
                  RUN Fill-SysMes IN h_tmess (
                     "", "", "0",
                     "Выберите другой счёт или измените код подразделения"
                  ).

                  RETURN NO-APPLY .
               END.
            END.
         END.
         ELSE
         DO:
            {find-act.i
               &filial  = tt-loan.filial-id
               &acct    = SELF:SCREEN-VALUE
               &curr    = tt-loan.currency:SCREEN-VALUE
            }

            IF NOT AVAIL acct THEN
            DO:
               RUN Fill-SysMes IN h_tmess (
                  "", "", "0",
                  "Счет отсутствует в справочнике или не соответствует валюте договора"
               ).

               RETURN NO-APPLY {&RET-ERROR}.
            END.
         END.
         /* Если есть счет, то надо установить acct-type т.к. при постановке
         ** на аналитику проверяется роль счета */
         ASSIGN
            SELF:SCREEN-VALUE           = acct.acct
            tt-loan-acct-main.acct-type = "Кредит"   WHEN tt-loan-acct-main.acct:SCREEN-VALUE NE "?"
            tt-loan-acct-cust.acct-type = "КредРасч" WHEN tt-loan-acct-cust.acct:SCREEN-VALUE NE "?"
         .
      END.
      ELSE
         ASSIGN
            tt-loan-acct-main.acct-type = "" WHEN tt-loan-acct-main.acct:SCREEN-VALUE EQ "?"
            tt-loan-acct-cust.acct-type = "" WHEN tt-loan-acct-cust.acct:SCREEN-VALUE EQ "?"
         .
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mBag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mBag TERMINAL-SIMULATION
ON LEAVE OF mBag IN FRAME fMain /* Портфель */
DO:
  {&BEG_BT_LEAVE}

  ASSIGN
    mBag
  .

   IF  iMode EQ {&MOD_ADD}
   THEN DO:
      RUN bagadd.p (
         INPUT tt-loan.contract,
         INPUT tt-loan.cont-code,
         INPUT mBag,
         INPUT tt-loan.open-date,
         INPUT gEnd-date
         ) NO-ERROR .
         IF ERROR-STATUS :ERROR THEN DO:
            RUN Fill-SysMes IN h_tmess ("", "", "0", RETURN-VALUE ).
            mBag = "".
            DISPLAY mBag WITH FRAME {&FRAME-NAME} .
            RETURN NO-APPLY {&RET-ERROR}.
         END.
    END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-amount.amt-rub
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-amount.amt-rub TERMINAL-SIMULATION
ON LEAVE OF tt-amount.amt-rub IN FRAME fMain /*          Сумма */
DO:
   {&BEG_BT_LEAVE}
   {&BT_LEAVE}
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
      &RecalcAnnuitet = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan.sum-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.sum-depos TERMINAL-SIMULATION
ON LEAVE OF tt-loan.sum-depos IN FRAME fMain /*          Сумма */
DO:
   {&BEG_BT_LEAVE}
   {&BT_LEAVE}
   ASSIGN tt-loan.sum-depos.
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
      &RecalcAnnuitet = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.sum-depos TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan.sum-depos IN FRAME fMain /* cred-date */
DO:
   mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan-cond.PartAmount
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.PartAmount TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.PartAmount IN FRAME fMain /*          Сумма */
DO:
   {&BEG_BT_LEAVE}
   {&BT_LEAVE}
   ASSIGN tt-loan-cond.PartAmount.
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
      &RecalcAnnuitet = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.PartAmount TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.PartAmount IN FRAME fMain /* cred-date */
DO:
   mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan-cond.FirstPeriod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.FirstPeriod TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.FirstPeriod IN FRAME fMain /*          Сумма */
DO:
   {&BEG_BT_LEAVE}
   {&BT_LEAVE}
   ASSIGN tt-loan-cond.FirstPeriod.
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
      &RecalcAnnuitet = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.FirstPeriod TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.FirstPeriod IN FRAME fMain /* cred-date */
DO:
   mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-percent.amt-rub
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-percent.amt-rub TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-percent.amt-rub IN FRAME fMain /*       Проценты */
DO:
   IF SELF:INPUT-VALUE NE 0 THEN ASSIGN
      tt-loan-cond.int-period:SCREEN-VALUE IN FRAME {&MAIN-FRAME} = "Кс"
      mNameIntPeriod:SCREEN-VALUE =
         GetDomainCodeName(tt-loan-cond.class-code,
                           "int-period",
                           tt-loan-cond.int-period:SCREEN-VALUE)
      tt-loan-cond.disch-type:SCREEN-VALUE IN FRAME {&MAIN-FRAME} = "-1"
      mNameDischType:SCREEN-VALUE =
         GetBufferValue("disch-type",
                        "where disch-type = " + tt-loan-cond.disch-type:SCREEN-VALUE,
                        "name").
   ELSE ASSIGN
      tt-loan-cond.disch-type:SCREEN-VALUE = STRING(tt-loan-cond.disch-type)
      mNameDischType:SCREEN-VALUE =
         GetBufferValue("disch-type",
                        "where disch-type = " + STRING(tt-loan-cond.disch-type),
                        "name").
      /*
   APPLY "LEAVE" TO tt-loan-cond.disch-type IN FRAME {&MAIN-FRAME}.
   RETURN NO-APPLY.
   */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.annuitplat$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.annuitplat$ TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.annuitplat$ IN FRAME fMain /* annuitplat$ */
DO:
   mHandCalcAnnuitet = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan-cond.annuitplat$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.annuitplat$ TERMINAL-SIMULATION
ON ENTRY OF tt-loan-cond.annuitplat$ IN FRAME fMain /* annuitplat$ */
DO:
   IF    iMode EQ {&MOD_ADD}
      OR iMode EQ {&MOD_EDIT}
   THEN DO:
      SetHelpStrAdd(mHelpStrAdd + "F5 Пересчет суммы платежа").
      RUN PutHelp("",FRAME {&MAIN-FRAME}:HANDLE).
   END.
   {&BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan-cond.annuitplat$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.annuitplat$ TERMINAL-SIMULATION
ON F5 OF tt-loan-cond.annuitplat$ IN FRAME fMain /* Искл. мес. */
DO:
   IF    iMode EQ {&MOD_ADD}
      OR iMode EQ {&MOD_EDIT}
   THEN DO:
      /* Принудительный пересчет суммы аннуитетного платежа */
      mChangedField = YES.

      ASSIGN
         tt-loan.end-date
         tt-amount.amt-rub
         tt-loan-cond.cred-date
         tt-loan-cond.cred-period
         tt-loan-cond.cred-month
         tt-loan-cond.kollw#gtper$
         tt-loan-cond.cred-offset
         tt-loan-cond.annuitkorr$
         tt-loan.sum-depos
         tt-loan-cond.PartAmount
         tt-loan-cond.FirstPeriod
      .
      {loan-trg.pro
         &RecalcAnnuitet = YES
         &LogVarChanged  = mChangedField
         &tt-loan        = tt-loan
         &tt-loan-cond   = tt-loan-cond
         &tt-comm-rate   = tt-comm-rate
         &tt-amount      = tt-amount
         &br-comm        = br-comm
      }
      mHandCalcAnnuitet = NO.
   END.
   RETURN NO-APPLY.
END.

&Scoped-define SELF-NAME tt-loan-cond.annuitplat$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.annuitplat$ TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.annuitplat$ IN FRAME fMain /* annuitplat$ */
DO:
   IF    iMode EQ {&MOD_ADD}
      OR iMode EQ {&MOD_EDIT}
   THEN DO:
      SetHelpStrAdd(REPLACE(mHelpStrAdd,"F5 Пересчет суммы платежа","")).
      RUN PutHelp("",FRAME {&MAIN-FRAME}:HANDLE).
   END.
   {&BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan.rewzim$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.rewzim$ TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan.rewzim$ IN FRAME fMain /* rewzim$ */
DO:
   IF NOT (   tt-loan.rewzim$:SCREEN-VALUE EQ "ЛимВыдЗад"
           OR tt-loan.rewzim$:SCREEN-VALUE EQ "ВозобнЛиния"
           OR tt-loan.rewzim$:SCREEN-VALUE EQ "НевозЛиния") THEN
      ASSIGN
         mLimit:VISIBLE IN FRAME fMain     = NO
         mLimitRest:VISIBLE IN FRAME fMain = NO
      .
   ELSE DO:
      ASSIGN
         mLimit:VISIBLE IN FRAME fMain     = YES
         mLimitRest:VISIBLE IN FRAME fMain = YES
      .
      APPLY "ENTRY" TO mLimit IN FRAME fMain.
      RETURN NO-APPLY.
      END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define BROWSE-NAME br-comm
&Scoped-define SELF-NAME br-comm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON CTRL-F2 OF br-comm IN FRAME fMain
ANYWHERE
DO:
   DEF VAR vRwd      AS ROWID                  NO-UNDO.
   DEF VAR vNewRate  LIKE comm-rate.rate-comm  NO-UNDO.
   DEF VAR vNewFixed LIKE comm-rate.rate-fixed NO-UNDO.
   DEF VAR vCommSpec AS CHARACTER              NO-UNDO.

   APPLY "VALUE-CHANGED" TO tt-comm-rate.rate-comm IN BROWSE br-comm.
   IF iMode NE {&MOD_ADD} THEN
      RETURN NO-APPLY.
   APPLY "LEAVE" TO FOCUS.
   IF RETURN-VALUE = {&RET-ERROR} THEN
      RETURN NO-APPLY.
   /* Создадим новую запись во временной таблице комиссий c пустой комиссией */
   FIND FIRST tt-comm-rate WHERE tt-comm-rate.since EQ tt-loan-cond.since
      AND tt-comm-rate.commission = "" NO-ERROR.
   IF NOT AVAIL tt-comm-rate THEN
   DO:
      CREATE tt-comm-rate.
      FOR EACH b-comm-rate BY b-comm-rate.Local__Id DESC:
         LEAVE.
      END.
      BUFFER-COPY b-comm-rate EXCEPT local__id local__rowid commission rate-comm
         TO tt-comm-rate.
      tt-comm-rate.commission = "".
      tt-comm-rate.Local__UpId = tt-loan-cond.local__Id.
      tt-comm-rate.since = tt-loan-cond.since.
      tt-comm-rate.Local__Id = MAX(GetInstanceId("tt-comm-rate"),
                                   b-comm-rate.Local__Id) + 1.
      /* Создадим новую  запись во временной таблице плавающих ставок аналогично */
      FIND FIRST tt-comm-cond WHERE tt-comm-cond.since EQ tt-loan-cond.since
                                AND tt-comm-cond.commission = "" NO-ERROR.
      IF NOT AVAIL tt-comm-cond THEN
      DO:
         FOR EACH b-comm-cond BY b-comm-cond.Local__Id DESC:
            LEAVE.
         END.
         CREATE tt-comm-cond.
         ASSIGN
            tt-comm-cond.contract  = tt-loan.contract
            tt-comm-cond.cont-code = tt-loan.cont-code
            tt-comm-cond.commission = tt-comm-rate.commission
            tt-comm-cond.since = tt-comm-rate.since
            tt-comm-cond.class-code = "comm-cond"
            tt-comm-cond.local__UpId = tt-loan-cond.local__Id.
            tt-comm-cond.local__Id = MAX(GetInstanceId("tt-comm-cond"),
                                            b-comm-cond.Local__Id) + 1.
      END.
   END.
   vRwd = ROWID(tt-comm-rate).
   {&OPEN-QUERY-br-comm}
   REPOSITION br-comm TO ROWID vRwd.
   APPLY "F1" TO tt-comm-rate.commission IN BROWSE br-comm.
   vNewRate = ?.

   IF     LASTKEY    EQ 10
      AND pick-value NE ? THEN
   DO:
      IF CAN-FIND(FIRST b-comm-rate WHERE
                  b-comm-rate.commission EQ pick-value AND
                  b-comm-rate.since      EQ tt-loan-cond.since AND
                  RECID(b-comm-rate) NE RECID(tt-comm-rate)) THEN
      DO:
         MESSAGE
            COLOR MESSAGES
            SUBSTITUTE("Комиссия <&1> уже есть  !" , pick-value )
            VIEW-AS ALERT-BOX.

         DELETE tt-comm-rate.
         br-comm:DELETE-SELECTED-ROW(1).
         vRwd = ROWID(tt-comm-rate).
         {&OPEN-QUERY-br-comm}
         REPOSITION br-comm TO ROWID vRwd.
         &IF DEFINED(MANUAL-REMOTE) &THEN
         RUN UpdateBrowser(br-comm:HANDLE).
         &ENDIF
         APPLY "entry" TO FOCUS.
         RETURN.
      END.


      /* Проверим , можно ли добавить эту коммисию */
      vCommSpec = FGetSettingEx("РазрешДопКом",
                                 IF tt-loan.Contract EQ "Депоз"
                                    THEN "ДепДопКом"
                                    ELSE "КредДопКом",
                                 "",
                                 NO).

      IF LOOKUP(pick-value, vCommSpec) = 0 THEN DO:
         MESSAGE
            COLOR MESSAGES
            SUBSTITUTE("Комиссия <&1> не подходит для Кредитов/Депозитов !" , pick-value )
            VIEW-AS ALERT-BOX.

         DELETE tt-comm-rate.
         br-comm:DELETE-SELECTED-ROW(1).
         vRwd = ROWID(tt-comm-rate).
         {&OPEN-QUERY-br-comm}
         REPOSITION br-comm TO ROWID vRwd.
         &IF DEFINED(MANUAL-REMOTE) &THEN
         RUN UpdateBrowser(br-comm:HANDLE).
         &ENDIF
         APPLY "entry" TO FOCUS.
         RETURN.
      END.
      tt-comm-rate.commission = pick-value.
      RUN getDefaultRate IN hDefaultRate ('init-rate' , /* Код справочника. */
                                          tt-loan.open-date:INPUT-VALUE,
                                          tt-loan.class-code,
                                          tt-loan.currency:INPUT-VALUE,
                                          tt-loan.cont-type:INPUT-VALUE,
                                          tt-comm-rate.commission,
                                          OUTPUT vNewRate).
      /* определяем тип комиссии по умолчанию (= / %) */
      RUN getDefaultFixed IN hDefaultRate ('init-fixed',
                                           tt-loan.open-date:INPUT-VALUE,
                                           tt-loan.class-code,
                                           tt-loan.currency:INPUT-VALUE,
                                           tt-loan.cont-type:INPUT-VALUE,
                                           tt-comm-rate.commission,
                                           OUTPUT vNewFixed).
      IF vNewFixed NE ? THEN
         tt-comm-rate.rate-fixed = vNewFixed.
      ELSE
         tt-comm-rate.rate-fixed = GET_HEAD_COMM_TYPE (tt-comm-rate.commission,
                                                       tt-loan.currency:INPUT-VALUE,
                                                       tt-loan.open-date:INPUT-VALUE).
   END.
   ELSE
      APPLY "CTRL-F3" TO tt-comm-rate.rate-comm IN BROWSE br-comm.
   APPLY "ENTRY" TO tt-comm-rate.rate-comm IN BROWSE br-comm.
   IF RETURN-VALUE EQ {&RET-ERROR}
   THEN RETURN NO-APPLY.
   IF vNewRate NE ? THEN
      tt-comm-rate.rate-comm = vNewRate.
   ELSE
      tt-comm-rate.rate-comm = 0.
   tt-comm-rate.min_value = 0.
   FIND FIRST commission WHERE commission.commission EQ   tt-comm-rate.commission
                           AND commission.currency   EQ   tt-loan.currency:SCREEN-VALUE NO-LOCK.
   DISP
      tt-comm-rate.commission
      tt-comm-rate.rate-fixed
      tt-comm-cond.floattype
      tt-comm-rate.rate-comm
      tt-comm-rate.min_value
      commission.name-comm[1] @ mNameCommi
      WITH BROWSE br-comm.
   IF tt-comm-rate.commission EQ "" THEN
      DISP
         "" @ mNameCommi
         WITH BROWSE br-comm.
   &IF DEFINED(MANUAL-REMOTE) &THEN
   RUN UpdateBrowser(br-comm:HANDLE).
   &ENDIF
END.

ON LEAVE OF tt-comm-rate.min_value IN BROWSE br-comm DO:
 tt-comm-rate.min_value = DEC (tt-comm-rate.min_value:screen-value IN BROWSE br-comm ) NO-ERROR .
END.

ON LEAVE OF tt-comm-rate.rate-comm IN BROWSE br-comm DO:
 tt-comm-rate.rate-comm = DEC (tt-comm-rate.rate-comm:screen-value IN BROWSE br-comm ) NO-ERROR .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define BROWSE-NAME br-comm
&Scoped-define SELF-NAME br-comm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON CTRL-F9 OF br-comm IN FRAME fMain
ANYWHERE
DO:
   IF iMode EQ {&MOD_ADD} THEN
   DO:

      DEF VAR vTempRateComm AS DEC NO-UNDO.
      DEFINE VARIABLE vDateClc AS DATE    NO-UNDO.
      DEFINE VARIABLE vOk AS LOGICAL    NO-UNDO.

      vTempRateComm = DEC(tt-comm-rate.rate-comm:SCREEN-VALUE IN BROWSE br-comm).

      RUN f-cratepl.p (INPUT BUFFER tt-comm-rate:HANDLE,INPUT BUFFER tt-comm-cond:HANDLE,br-comm:ROW,OUTPUT vOk).

      /* При вводе договора ставки только заводятся, и пользователь может указать любую из ставок
      ** на договоре. Поэтому расчитывать из ставок договора смысла нет */
      IF tt-comm-cond.source EQ "Общие ставки" THEN
      DO:
         RUN CalcFloatRate (tt-loan.contract,
                            tt-loan.cont-code,
                            tt-comm-cond.source,
                            tt-comm-cond.BaseCode,
                            DATE(tt-loan.open-date:SCREEN-VALUE),
                            tt-comm-cond.action,
                            tt-comm-cond.BaseChange,
                            tt-comm-cond.firstdelay,
                            OUTPUT vRatePS).
         IF vRatePS NE 0 THEN
         DO:
            vDateClc = tt-loan.open-date - tt-comm-cond.firstdelay.
            RUN GET_COMM_BUF (tt-comm-cond.BaseCode, /* Код комиссии. */
                     ?,                              /* Идентификатор счета. */
                     "",                             /* Код валюты. */
                     "",                             /* Код КАУ ("" - по умолчанию). */
                     0.00,                           /* Миним. остаток (0 - поумолчанию). */
                     0,                              /* Период/срок (0 - поумолчанию). */
                     vDateClc,                       /* Дата поиска. */
                     BUFFER t-comm-rate
                     ).
   
            IF AVAIL t-comm-rate 
               AND t-comm-rate.since NE vDateClc
            THEN DO:
               RUN Fill-SysMes IN h_tmess ("", "", "0", 
              "На дату опердня " + STRING(vDateClc) + " не найдено значение ставки по коду " +
              STRING(tt-comm-cond.BaseCode) + " !~n Последнее изменение ставки " + STRING(t-comm-rate.since) + "." ).
            END.

            FIND FIRST tt-comm-rate WHERE tt-comm-rate.commission EQ tt-comm-cond.commission
                                      AND tt-comm-rate.since      EQ tt-comm-cond.since
            EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL tt-comm-rate THEN
               ASSIGN
                  tt-comm-rate.rate-comm = vRatePS.
      END.
      END.
      ELSE
         tt-comm-rate.rate-comm = vTempRateComm.

      IF vOk  THEN
      DO:
         br-comm:REFRESH().
         &IF DEFINED(MANUAL-REMOTE) &THEN
         RUN UpdateBrowser(br-comm:HANDLE).
         &ENDIF
      END.
   END.
END.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON CTRL-F3 OF br-comm IN FRAME fMain
ANYWHERE
DO:
   DEFINE VARIABLE vRwd AS ROWID     NO-UNDO.
   DEFINE VARIABLE vTmp AS ROWID     NO-UNDO.
   IF iMode NE {&MOD_ADD} THEN
      RETURN NO-APPLY.
   IF NUM-RESULTS("br-comm") EQ 1 THEN
   DO:
      vRwd = ROWID(tt-comm-rate).
      tt-comm-rate.commission = "".
      tt-comm-rate.rate-comm = 0.
      tt-comm-cond.commission = "".
      tt-comm-cond.FloatType = NO .
      tt-comm-rate.local__template = YES.
      tt-comm-rate.Local__Id = GetInstanceId("tt-comm-rate") + 1.
      DISP
         tt-comm-rate.commission
         /*
         tt-comm-rate.Local__Id
         */
         "" @ mNameCommi
         tt-comm-rate.rate-comm
         WITH BROWSE br-comm.
   END.
   ELSE
   DO:
      /* Если ставка была плавающей,
      ** то отмечаем её как не плавающей */
      tt-comm-cond.FloatType = NO .
      DELETE tt-comm-rate.
      br-comm:DELETE-SELECTED-ROW(1).
      vRwd = ROWID(tt-comm-rate).
   END.
   {&OPEN-QUERY-br-comm}
   REPOSITION br-comm TO ROWID vRwd.
   &IF DEFINED(MANUAL-REMOTE) &THEN
   RUN UpdateBrowser(br-comm:HANDLE).
   &ENDIF
   APPLY "entry" TO FOCUS.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON CTRL-J OF br-comm IN FRAME fMain
ANYWHERE
DO:
   APPLY "LEAVE" TO FOCUS.
   IF RETURN-VALUE = {&RET-ERROR} THEN
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON ENTER OF br-comm IN FRAME fMain
ANYWHERE
DO:
   DEFINE VARIABLE vRow AS ROWID      NO-UNDO.
   DEFINE VARIABLE vH   AS HANDLE     NO-UNDO.

   vH = BROWSE br-comm:NEXT-TAB-ITEM.
   DO WHILE NOT(    vH:VISIBLE
                AND vH:SENSITIVE):
      vH = vH:NEXT-TAB-ITEM.
   END.

   APPLY "LEAVE" TO FOCUS.
   IF RETURN-VALUE = {&RET-ERROR} THEN
      RETURN NO-APPLY.
   IF FOCUS:NAME EQ "rate-comm" THEN
   DO:
      vRow = ROWID(tt-comm-rate).
      APPLY "CURSOR-DOWN" TO br-comm.
      IF vRow EQ ROWID(tt-comm-rate) THEN
         APPLY "ENTRY" TO vH.
   END.
   ELSE IF FOCUS:NAME EQ "min_value" THEN
   DO:
      vRow = ROWID(tt-comm-rate).
      APPLY "CURSOR-DOWN" TO br-comm.
      IF vRow EQ ROWID(tt-comm-rate)
         THEN APPLY "TAB"        TO SELF.
         ELSE APPLY "BACK-TAB"  TO SELF.
   END.
   ELSE
      APPLY "TAB" TO SELF.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON ENTRY OF br-comm IN FRAME fMain
DO:
   IF SELF:NAME EQ "br-comm" THEN
   DO:
      IF iMode EQ {&MOD_ADD} THEN
      FOR EACH tt-comm-rate:
         tt-comm-rate.since = tt-loan-cond.since.
         tt-comm-cond.since = tt-loan-cond.since.
      END.
      {&OPEN-QUERY-br-comm}
       br-comm:REFRESH() .
      RUN PutHelp(
         "F1" + (IF iMode EQ {&MOD_ADD} THEN "│Ctrl-F2 - Добавить│Ctrl-F3 - Удалить│Ctrl-F9 - Редактировать" ELSE (IF mSwitchF9 AND iMode EQ {&MOD_VIEW} THEN "│F9" ELSE "")),
         FRAME {&MAIN-FRAME}:HANDLE).
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON F1 OF br-comm IN FRAME fMain
ANYWHERE
DO:
   IF SELF:NAME EQ "commission" AND iMode EQ {&MOD_ADD} THEN
   DO:
      DO TRANS:
         RUN browseld.p (
            "commission",
            "currency" + CHR(1) + "contract" + CHR(1) + "enable-editing",
            STRING(tt-loan.currency:SCREEN-VALUE) + CHR(1) + STRING(tt-loan.contract) + CHR(1) + "enable-editing",
            "currency" + CHR(1) + "contract",
            iLevel).
         IF LASTKEY = 10 AND pick-value <> ? THEN
            SELF:SCREEN-VALUE = pick-value.
      END.
   END.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON LEAVE OF br-comm IN FRAME fMain
ANYWHERE
DO:
   mModeBrowse = iMode  .
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
     &RecalcAnnuitet = YES
     &LogVarChanged   = mChangedField
     &tt-loan         = tt-loan
     &tt-loan-cond    = tt-loan-cond
     &tt-comm-rate    = tt-comm-rate
     &tt-amount       = tt-amount
     &br-comm         = br-comm
  }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON VALUE-CHANGED OF br-comm IN FRAME fMain
ANYWHERE DO:

   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
      &ValueChangedBrowseComm = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.branch-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.branch-id TERMINAL-SIMULATION
ON LEAVE OF tt-loan.branch-id IN FRAME fMain /* Подразделение */
DO:
  {&BEG_BT_LEAVE}
  IF iMode NE {&MOD_VIEW} AND
     GetBufferValue("branch",
                    "where branch-id = '" + SELF:SCREEN-VALUE + "'",
                    "branch-id") EQ ? THEN
  DO:
     MESSAGE "Неверный код подразделения"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN NO-APPLY {&RET-ERROR}.
  END.
  mBranchName:SCREEN-VALUE = GetCliName("В",
                                        SELF:SCREEN-VALUE,
                                        OUTPUT vAddr,
                                        OUTPUT vINN,
                                        OUTPUT vKPP,
                                        INPUT-OUTPUT vType,
                                        OUTPUT vCode,
                                        OUTPUT vAcct).
  {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.cont-type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.cont-type TERMINAL-SIMULATION
ON LEAVE OF tt-loan.cont-type IN FRAME fMain /* Тип */
DO:
   {&BEG_BT_LEAVE}
   IF iMode NE {&MOD_VIEW} AND
      AVAIL tt-Instance AND
      SELF:SCREEN-VALUE EQ "Течение" THEN
   DO:
      MESSAGE 'Договор - течение некоторого договора не может иметь тип "Течение"!'
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.cred-date
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.cred-date TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.cred-date IN FRAME fMain /* cred-date */
DO:
  {&BEG_BT_LEAVE}
  {&BT_LEAVE}
  mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
  {loan-trg.pro
     &RecalcAnnuitet = YES
     &LogVarChanged  = mChangedField
     &tt-loan        = tt-loan
     &tt-loan-cond   = tt-loan-cond
     &tt-comm-rate   = tt-comm-rate
     &tt-amount      = tt-amount
     &br-comm        = br-comm
  }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.cred-date TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.cred-date IN FRAME fMain /* cred-date */
DO:
   mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.cred-mode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.cred-mode TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.cred-mode IN FRAME fMain /* cred-mode */
DO:
   /* изменяем видимые поля в зависимости от значения cred-mode (Плат. период - осн.долг) */
   CASE tt-loan-cond.cred-mode:SCREEN-VALUE:
      WHEN "КоличДней" THEN
         ASSIGN
            tt-loan-cond.DateDelay        :VISIBLE = NO
            tt-loan-cond.cred-curr-next   :VISIBLE = NO
            tt-loan-cond.delay1           :VISIBLE = YES
            tt-loan-cond.cred-work-calend :VISIBLE = YES
            tt-loan-cond.grperiod$        :VISIBLE = NO
         .
      WHEN "ДатаОконч" THEN
         ASSIGN
            tt-loan-cond.DateDelay        :VISIBLE = YES
            tt-loan-cond.cred-curr-next   :VISIBLE = YES
            tt-loan-cond.delay1           :VISIBLE = NO
            tt-loan-cond.cred-work-calend :VISIBLE = NO
            tt-loan-cond.grperiod$        :VISIBLE = NO
         .
      WHEN "ПериодДн" THEN
      DO:
         ASSIGN
            tt-loan-cond.DateDelay        :VISIBLE = NO
            tt-loan-cond.cred-curr-next   :VISIBLE = NO
            tt-loan-cond.delay1           :VISIBLE = YES
            tt-loan-cond.cred-work-calend :VISIBLE = NO
            tt-loan-cond.grperiod$        :VISIBLE = YES
         .
         DISPLAY tt-loan-cond.grperiod$ WITH FRAME {&MAIN-FRAME} .
      END.
   END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.cred-month
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.cred-month TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.cred-month IN FRAME fMain /* cred-month */
DO:
  {&BEG_BT_LEAVE}
  IF  ( tt-loan-cond.cred-period:INPUT-VALUE EQ "К"
    AND tt-loan-cond.cred-month:INPUT-VALUE GT 3
    OR  tt-loan-cond.cred-period:INPUT-VALUE EQ "ПГ"
    AND tt-loan-cond.cred-month:INPUT-VALUE GT 6
    OR  tt-loan-cond.cred-period:INPUT-VALUE EQ "Г"
    AND tt-loan-cond.cred-month:INPUT-VALUE GT 12 )
    OR ((tt-loan-cond.cred-period:INPUT-VALUE EQ "К"
    OR   tt-loan-cond.cred-period:INPUT-VALUE EQ "ПГ"
    OR   tt-loan-cond.cred-period:INPUT-VALUE EQ "Г")
    AND  tt-loan-cond.cred-month:INPUT-VALUE  LE 0) THEN
  DO:
     RUN Fill-SysMes ("", "", "0", "В указанном периоде нет месяца с указанным номером.") NO-ERROR.
     {return_no_apply.i '{&RET-ERROR}'}
  END.
  {&BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.cred-month TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.cred-month IN FRAME fMain /* cred-month */
DO:
  mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cred-offset_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cred-offset_ TERMINAL-SIMULATION
ON F1 OF cred-offset_ IN FRAME fMain
,int-offset_,delay-offset_,delay-offset-int_
DO:
   DEF VAR vi AS INT64    NO-UNDO.
   /* переключение значений */
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      vi = LOOKUP(SELF:SCREEN-VALUE,mOffsetVld).
      vi = vi + 1.
      IF vi GT NUM-ENTRIES(mOffsetVld) THEN vi = 1.
      SELF:SCREEN-VALUE = ENTRY(vi,mOffsetVld).
      APPLY "VALUE-CHANGED" TO SELF.
      RETURN NO-APPLY.
   END.
   {&BT_F1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cred-offset_ TERMINAL-SIMULATION
ON LEAVE OF cred-offset_ IN FRAME fMain
DO:
   {&BEG_BT_LEAVE}
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      /* валидация значения */
      IF NOT CAN-DO(mOffsetVld,SELF:SCREEN-VALUE)  THEN
      DO:
         RUN GetXAttr (tt-loan.class-code, "cred-offset",BUFFER xattr).
         RUN Fill-SysMes IN h_tmess ("", "", "0",
            "Значение реквизита ~"" + xattr.name + "~" класса ~"" + xattr.class-code +
            "~" не соответствует списку допустимых значений ~"" + mOffsetVld + "~"").
         RETURN NO-APPLY {&RET-ERROR}.
      END.
      ASSIGN
        /* записываем правильное значение в "настоящее" поле ({&CB-NONE} вместо "--") */
        tt-loan-cond.cred-offset:SCREEN-VALUE = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                           THEN {&CB-NONE}
                                           ELSE SELF:SCREEN-VALUE
        tt-loan-cond.cred-offset              = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                           THEN ""
                                           ELSE SELF:SCREEN-VALUE.
      {&BT_LEAVE}
      mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
      {loan-trg.pro
         &RecalcAnnuitet = YES
         &LogVarChanged  = mChangedField
         &tt-loan        = tt-loan
         &tt-loan-cond   = tt-loan-cond
         &tt-comm-rate   = tt-comm-rate
         &tt-amount      = tt-amount
         &br-comm        = br-comm
      }
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cred-offset_ TERMINAL-SIMULATION
ON VALUE-CHANGED OF cred-offset_ IN FRAME fMain
DO:
   mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.cred-period
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.cred-period TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.cred-period IN FRAME fMain /* Осн.долг */
DO:
   {&BEG_BT_LEAVE}
   {&BT_LEAVE}
   ASSIGN
      mNameCredPeriod:SCREEN-VALUE =
         GetDomainCodeName(tt-loan-cond.class-code,
                           "cred-period",
                           tt-loan-cond.cred-period:SCREEN-VALUE)
   .
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
     &RecalcAnnuitet = YES
     &LogVarChanged  = mChangedField
     &tt-loan        = tt-loan
     &tt-loan-cond   = tt-loan-cond
     &tt-comm-rate   = tt-comm-rate
     &tt-amount      = tt-amount
     &br-comm        = br-comm
  }
   
   DEFINE VARIABLE vH   AS HANDLE     NO-UNDO.
   vH = tt-loan-cond.cred-period:HANDLE:NEXT-SIBLING.
   DO WHILE VALID-HANDLE(vH):
      IF (    vH:VISIBLE
          AND vH:SENSITIVE) THEN
      DO :
         APPLY "ENTRY" TO vH.
         RETURN NO-APPLY. 
      END.
      vH = vH:NEXT-SIBLING.
   END.
   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.cred-period TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.cred-period IN FRAME fMain /* Осн.долг */
DO:
   ASSIGN
     tt-loan-cond.cred-month:SCREEN-VALUE = "1"
     mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.currency
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.currency TERMINAL-SIMULATION
ON LEAVE OF tt-loan.currency IN FRAME fMain /* Вал */
DO:
   {&BEG_BT_LEAVE}
   DEFINE VARIABLE vName AS CHARACTER  NO-UNDO.
   APPLY "LEAVE" TO FRAME {&MAIN-FRAME}.
   IF RETURN-VALUE EQ {&RET-ERROR}
      THEN RETURN NO-APPLY.
   IF LASTKEY = KEYCODE("ESC") OR iMode EQ {&MOD_VIEW} THEN RETURN.
   vName = GetBufferValue("currency",
                          "WHERE currency.currency EQ '" +
                              INPUT FRAME {&MAIN-FRAME} tt-loan.currency + "'",
                          "i-currency").
  IF vName EQ ? THEN
  DO:
     SELF:SCREEN-VALUE = "".
     MESSAGE "Валюта отсутствует в справочнике"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN NO-APPLY {&RET-ERROR}.
  END.
  {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-broker.cust-cat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-broker.cust-cat TERMINAL-SIMULATION
ON F1 OF tt-broker.cust-cat IN FRAME fMain /*     Брокер */
, tt-broker.cust-id
DO:
   IF tt-loan.alt-contract EQ "mm" AND
      iMode NE {&MOD_VIEW} THEN
   DO:
      {f-fx.trg
         &F1-BROKER = YES
         &BASE-TABLE=tt-loan}
   END.
   ELSE
   DO:
      {&BT_F1}
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-dealer.cust-cat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dealer.cust-cat TERMINAL-SIMULATION
ON F1 OF tt-dealer.cust-cat IN FRAME fMain /*     Дилер */
, tt-dealer.cust-id
DO:
   IF tt-loan.alt-contract EQ "mm" AND
      iMode NE {&MOD_VIEW} THEN
   DO:
      {f-fx.trg
         &F1-DEALER = YES
         &BASE-TABLE=tt-loan}
   END.
   ELSE
   DO:
      {&BT_F1}
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.cust-cat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.cust-cat TERMINAL-SIMULATION
ON F1 OF tt-loan.cust-cat IN FRAME fMain /*      Контрагент */
, tt-loan.cust-id
DO:
   IF tt-loan.alt-contract EQ "mm" AND
      iMode NE {&MOD_VIEW} THEN
   DO:
      {f-fx.trg
         &F1-CUST = YES
         &BASE-TABLE=tt-loan}
   END.
   ELSE
   DO:
      {&BT_F1}
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-dealer.cust-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dealer.cust-id TERMINAL-SIMULATION
ON LEAVE OF tt-dealer.cust-id IN FRAME fMain /* Код */
DO:
   {&BEG_BT_LEAVE}
   IF tt-loan.alt-contract = "mm" THEN
   DO:
      {f-fx.trg &LEAVE-DEALER-CUST-ID = YES}
   END.
   ELSE
   DO:
      {&BT_LEAVE}
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.cust-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.cust-id TERMINAL-SIMULATION
ON LEAVE OF tt-loan.cust-id IN FRAME fMain /* Код */
DO:
   {&BEG_BT_LEAVE}
   IF tt-loan.alt-contract = "mm" THEN
   DO:
      {f-fx.trg &LEAVE-CUST-ID = YES}
   END.
   ELSE
   DO:
      {&BT_LEAVE}
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-broker.cust-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-broker.cust-id TERMINAL-SIMULATION
ON LEAVE OF tt-broker.cust-id IN FRAME fMain /* Код */
DO:
   {&BEG_BT_LEAVE}
   IF tt-loan.alt-contract = "mm" THEN
   DO:
      {f-fx.trg &LEAVE-BROKER-CUST-ID = YES}
   END.
   ELSE
   DO:
      {&BT_LEAVE}
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.datasogl$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.datasogl$ TERMINAL-SIMULATION
ON LEAVE OF tt-loan.datasogl$ IN FRAME fMain /*     Закл */
DO:
  {&BEG_BT_LEAVE}
  IF BT_Modify(SELF) THEN
  DO:
     IF DATE(tt-loan.datasogl$:SCREEN-VALUE) > DATE(tt-loan.open-date:SCREEN-VALUE) THEN
     DO:
        IF iMode EQ {&MOD_ADD} THEN
           tt-loan.open-date:SCREEN-VALUE = STRING(tt-loan.datasogl$:SCREEN-VALUE).
        ELSE
        DO:
           MESSAGE "Дата заключения договора не может быть больше даты открытия"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY {&RET-ERROR}.
        END.
     END.
  END.

  {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.DateDelay
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.DateDelay TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.DateDelay IN FRAME fMain /* DateDelay */
DO:
   {&BEG_BT_LEAVE}

   /* номер дня в месяце на может быть > 31 или <1 */
   IF INT64(SELF:SCREEN-VALUE) GT 31 THEN SELF:SCREEN-VALUE = "31".
   IF INT64(SELF:SCREEN-VALUE) LT 1  THEN SELF:SCREEN-VALUE = "1".

   /* номер дня (в текущем месяце) окончания плат.периода не может быть
   ** больше номера дня начала платежного периода */
   IF     tt-loan-cond.cred-date:VISIBLE
      AND tt-loan-cond.cred-curr-next:SCREEN-VALUE EQ ENTRY(1,tt-loan-cond.cred-curr-next:FORMAT,"/")
      AND INT64(tt-loan-cond.cred-date:SCREEN-VALUE) GT INT64(tt-loan-cond.DateDelay:SCREEN-VALUE)
   THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "", "Дата окончания платежного периода (день " +
                                  tt-loan-cond.DateDelay:SCREEN-VALUE + ") не может быть~n " +
                                  "меньше даты его начала (день " + tt-loan-cond.cred-date:SCREEN-VALUE + ").").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.DateDelayInt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.DateDelayInt TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.DateDelayInt IN FRAME fMain /* DateDelayInt */
DO:
   {&BEG_BT_LEAVE}

   /* номер дня в месяце на может быть > 31 или <1 */
   IF INT64(SELF:SCREEN-VALUE) GT 31 THEN SELF:SCREEN-VALUE = "31".
   IF INT64(SELF:SCREEN-VALUE) LT 1  THEN SELF:SCREEN-VALUE = "1".

   /* номер дня (в текущем месяце) окончания плат.периода не может быть
   ** больше номера дня начала платежного периода */
   IF     tt-loan-cond.int-date:VISIBLE
      AND tt-loan-cond.int-curr-next:SCREEN-VALUE EQ ENTRY(1,tt-loan-cond.int-curr-next:FORMAT,"/")
      AND INT64(tt-loan-cond.int-date:SCREEN-VALUE) GT INT64(tt-loan-cond.DateDelayInt:SCREEN-VALUE)
   THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "", "Дата окончания платежного периода (день " +
                                  tt-loan-cond.DateDelayInt:SCREEN-VALUE + ") не может быть~n " +
                                  "меньше даты его начала (день " + tt-loan-cond.int-date:SCREEN-VALUE + ").").
      RETURN NO-APPLY {&RET-ERROR}.
   END.

   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME delay-offset-int_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL delay-offset-int_ TERMINAL-SIMULATION
ON LEAVE OF delay-offset-int_ IN FRAME fMain
DO:
   {&BEG_BT_LEAVE}
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      /* валидация значения */
      IF NOT CAN-DO(mOffsetVld,SELF:SCREEN-VALUE)  THEN
      DO:
         RUN GetXAttr (tt-loan.class-code,"delay-offset-int",BUFFER xattr).
         RUN Fill-SysMes IN h_tmess ("", "", "0",
            "Значение реквизита ~"" + xattr.name + "~" класса ~"" + xattr.class-code +
            "~" не соответствует списку допустимых значений ~"" + mOffsetVld + "~"").
         RETURN NO-APPLY {&RET-ERROR}.
      END.
      /* записываем правильное значение в "настоящее" поле ({&CB-NONE} вместо "--") */
      ASSIGN
         tt-loan-cond.delay-offset-int:SCREEN-VALUE = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                                         THEN {&CB-NONE}
                                                         ELSE SELF:SCREEN-VALUE
         tt-loan-cond.delay-offset-int              = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                                         THEN ""
                                                         ELSE SELF:SCREEN-VALUE.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME delay-offset_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL delay-offset_ TERMINAL-SIMULATION
ON LEAVE OF delay-offset_ IN FRAME fMain
DO:
   {&BEG_BT_LEAVE}
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      /* валидация значения */
      IF NOT CAN-DO(mOffsetVld,SELF:SCREEN-VALUE)  THEN
      DO:
         RUN GetXAttr (tt-loan.class-code,"delay-offset",BUFFER xattr).
         RUN Fill-SysMes IN h_tmess ("", "", "0",
            "Значение реквизита ~"" + xattr.name + "~" класса ~"" + xattr.class-code +
            "~" не соответствует списку допустимых значений ~"" + mOffsetVld + "~"").
         RETURN NO-APPLY {&RET-ERROR}.
      END.
      /* записываем правильное значение в "настоящее" поле ({&CB-NONE} вместо "--") */
      ASSIGN
         tt-loan-cond.delay-offset:SCREEN-VALUE = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                                     THEN {&CB-NONE}
                                                     ELSE SELF:SCREEN-VALUE
         tt-loan-cond.delay-offset              = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                                     THEN ""
                                                     ELSE SELF:SCREEN-VALUE.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.disch-type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.disch-type TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.disch-type IN FRAME fMain /* Форма расчета */
DO:
   {&BEG_BT_LEAVE}
   IF iMode NE {&MOD_VIEW} THEN
   DO:
      IF GetBufferValue("disch-type",
                        "where disch-type = " + SELF:SCREEN-VALUE,
                        "name") EQ ? THEN
      DO:
         MESSAGE "Форма расчета отсутствует в справочнике"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY {&RET-ERROR}.
      END.
   END.
   IF iMode EQ {&MOD_ADD} AND SELF:INPUT-VALUE NE -1 THEN
      tt-percent.amt-rub:SCREEN-VALUE = "0".
   mNameDischType:SCREEN-VALUE =
      GetBufferValue("disch-type",
                     "where disch-type = " + SELF:SCREEN-VALUE,
                     "name").
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.doc-ref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.doc-ref TERMINAL-SIMULATION
ON LEAVE OF tt-loan.doc-ref IN FRAME fMain /* Номер договора */
DO:
   {&BEG_BT_LEAVE}
   IF SELF:INPUT-VALUE EQ "" THEN
   DO:
      MESSAGE "Номер договора должен быть введен!"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   IF CAN-FIND(FIRST loan WHERE
               loan.filial-id EQ tt-loan.filial-id AND
               loan.contract EQ tt-loan.contract AND
               loan.doc-ref EQ SELF:INPUT-VALUE AND
               ROWID(loan) NE tt-loan.local__rowid) THEN
   DO:
      MESSAGE "Договор с таким номером уже существует"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   IF   INDEX(SELF:INPUT-VALUE,",") NE 0
     OR INDEX(SELF:INPUT-VALUE,";") NE 0 THEN
   DO:
      RUN fill-sysmes IN h_tmess ("", "", "0", "Номер договора содержит запрещенные символы.").
      RETURN NO-APPLY {&RET-ERROR}.
   END.

   IF ShMode THEN
   DO:
      tt-loan.cont-code = addFilToLoan(SELF:INPUT-VALUE,ShFilial).
   END.
   ELSE DO:
      tt-loan.cont-code = SELF:INPUT-VALUE.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.end-date
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.end-date TERMINAL-SIMULATION
ON LEAVE OF tt-loan.end-date IN FRAME fMain /* По */
DO:
   DEF VAR vEnd_date AS DATE  NO-UNDO.
   DEF VAR vMove     AS INT64 NO-UNDO.
   DEF VAR vMess     AS CHAR  NO-UNDO.
   DEF VAR vFlag     AS INT64 NO-UNDO.

   IF     mNewEndDate  NE ?
      AND mNewEndDate  NE DATE(tt-loan.end-date:SCREEN-VALUE)
   THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "4", "Была изменина автоматически установленая дата окончания с "
                                  + STRING(mNewEndDate,"99/99/9999") + " на " + tt-loan.end-date:SCREEN-VALUE
                                  + ". Оставить?").
      IF pick-value NE "yes" 
      THEN
         tt-loan.end-date:SCREEN-VALUE = STRING(mNewEndDate,"99/99/9999").
   END.

   ASSIGN
      vMove     = 0
      vEnd_date = GetFstWrkDay(tt-loan.Class-Code, tt-loan.user-id, DATE(tt-loan.end-date:SCREEN-VALUE), 9, 1).
   {&BEG_BT_LEAVE}
   IF tt-loan.end-date:SCREEN-VALUE EQ "" THEN
      tt-percent.amt-rub:SCREEN-VALUE = "0".
   IF tt-loan.end-date:INPUT-VALUE LE tt-loan.open-date:INPUT-VALUE THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "Дата окончания не может быть меньше даты начала").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   IF AVAIL tt-instance AND
      tt-loan.end-date:INPUT-VALUE GT tt-instance.end-date THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "Дата закрытия течения не может быть больше даты закрытия договора").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
         /* Изменение даты окончания договора в меньшую сторону */
   IF     iMode EQ {&MOD_EDIT}
      AND tt-loan.end-date:INPUT-VALUE LT tt-loan.end-date
   THEN DO:
      /* Если есть пролонгации датой больше новой даты окончания договора */
      IF CAN-FIND(FIRST pro-obl WHERE pro-obl.contract   EQ tt-loan.contract
                                  AND pro-obl.cont-code  EQ tt-loan.cont-code
                                  AND pro-obl.idnt       EQ 3
                                  AND pro-obl.n-end-date GT tt-loan.end-date:INPUT-VALUE)
      THEN DO:
         /* Не позволяем изменение даты, т.к. при этом платеж пролонгированный будет удален */
         RUN Fill-SysMes IN h_tmess ("", "", "0", "Существуют пролонгации обязательств на даты больше новой даты окончания договора. Сначала удалите пролонгации вручную.").
         tt-loan.end-date:SCREEN-VALUE = STRING(tt-loan.end-date).
         {return_no_apply.i '{&RET-ERROR}'}
      END.
      /* Если есть условия дата начала которых больше  новой даты окончания договора */
      IF CAN-FIND(FIRST loan-cond WHERE loan-cond.contract     EQ tt-loan.contract
                                  AND   loan-cond.cont-code    EQ tt-loan.cont-code
                                  AND   loan-cond.since        GT tt-loan.end-date:INPUT-VALUE)
      THEN DO:
         /* Не позволяем изменение даты, т.к. пока не удалят условие */
         RUN Fill-SysMes IN h_tmess ("", "", "0", "Существует условие договора на дату больше новой даты окончания договора. Сначала удалите условие вручную.").
         tt-loan.end-date:SCREEN-VALUE = STRING(tt-loan.end-date).
         {return_no_apply.i '{&RET-ERROR}'}
      END.
   END.
   IF     iMode EQ {&MOD_ADD}
      AND AVAIL tt-instance THEN
   DO:
      Set_Loan(tt-loan.contract,ENTRY(1,tt-loan.cont-code," ")).
      RUN Chk_Stop_cond(DATE(tt-loan.open-date:SCREEN-VALUE),
                 OUTPUT vFlag).
      IF vFlag LT 0 THEN
      DO:
         IF vFlag EQ -1 THEN vmess = "из-за потери соглашения".
         ELSE IF vFlag EQ -2 THEN vmess = "из-за нарушения срока выдачи".
         ELSE IF vFlag EQ -3 THEN vmess = "из-за наличия непогашенного транша".
         ELSE IF vFlag EQ -4 THEN vmess = "из-за попадания в период действия др. транша".
         ELSE vmess = "".
         RUN Fill-SysMes IN h_tmess ("", "", "0", "Транш не прошел проверки " + vmess).
         RETURN NO-APPLY {&RET-ERROR}.
      END.
   END.
   IF tt-loan-cond.grperiod$ AND tt-loan-cond.grdatapo$ GT tt-loan.end-date:INPUT-VALUE THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "Дата окончания договора не может быть меньше даты окончания построения графиков (ДР ГрДатаПо)").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   /*mitr: заполнение % ставок значениями "по умолчанию"*/
   IF iMode EQ {&MOD_ADD}
      AND NOT mBrowseCommRateOFF THEN
   DO:

      DEFINE VARIABLE vNewRate  LIKE comm-rate.rate-comm  NO-UNDO.
      DEFINE VARIABLE vNewFixed LIKE comm-rate.rate-fixed NO-UNDO.
      FOR EACH tt-comm-rate WHERE tt-comm-rate.rate-comm EQ 0.0 :

         RUN getDefaultRate IN hDefaultRate (
            'init-rate' , /* Код справочника. */
            tt-loan.open-date:INPUT-VALUE,
            tt-loan.class-code,
            tt-loan.currency:INPUT-VALUE,
            tt-loan.cont-type:INPUT-VALUE,
            tt-comm-rate.commission,
            OUTPUT vNewRate).

         IF vNewRate NE ?
            AND vNewRate NE tt-comm-rate.rate-comm THEN
            ASSIGN
               tt-comm-rate.rate-comm = vNewRate
               mChangedField          = YES      /* Для пересчета аннуитета */
            .
         RUN getDefaultFixed IN hDefaultRate (
            'init-fixed' , /* Код справочника. */
            tt-loan.open-date:INPUT-VALUE,
            tt-loan.class-code,
            tt-loan.currency:INPUT-VALUE,
            tt-loan.cont-type:INPUT-VALUE,
            tt-comm-rate.commission,
            OUTPUT vNewFixed).
         IF vNewFixed NE ?
            AND vNewFixed NE tt-comm-rate.rate-fixed THEN
            ASSIGN
               tt-comm-rate.rate-fixed = vNewFixed
               mChangedField           = YES      /* Для пересчета аннуитета */
            .
      END.
      br-comm:REFRESH().
   END.

   pick-value = "".
   {&BT_LEAVE}
   /* Проверка на необходимость сдвига даты */
   IF     DATE(tt-loan.end-date:SCREEN-VALUE) NE mDateEnd
      AND DATE(tt-loan.end-date:SCREEN-VALUE) NE vEnd_date THEN DO:
      IF pick-value EQ "" THEN
         RUN Fill-SysMes IN h_tmess("","",3,"Дата ~"По~" попала на выходной день" + "~n" + "Сдвинуть на ближайший рабочий ?|Сдвигать вперед,Сдвигать назад,Не Сдвигать").
      vMove = IF pick-value = "2" THEN -1 ELSE IF pick-value = "1" THEN 1 ELSE 0.
      IF vMove NE 0 THEN
         tt-loan.end-date:SCREEN-VALUE = STRING(GetFstWrkDay(tt-loan.Class-Code, tt-loan.user-id, DATE(tt-loan.end-date:SCREEN-VALUE), 9, vMove)).
   END.
   mDateEnd = DATE(tt-loan.end-date:SCREEN-VALUE) NO-ERROR.

   IF    mSrokChange
     AND tt-loan.open-date:SCREEN-VALUE NE "?"
     AND tt-loan.end-date:SCREEN-VALUE  NE "?"
     AND tt-loan.end-date:SCREEN-VALUE  NE "" THEN
   DO:
      RUN DMY_In_Per(tt-loan.open-date:SCREEN-VALUE,
                     tt-loan.end-date:SCREEN-VALUE,
                     OUTPUT mNDays,
                     OUTPUT mNMonth,
                     OUTPUT mNYear).

      IF GetXattrInit(tt-loan.Class-Code,"ФиксДн") EQ "Да" THEN
      ASSIGN
         tt-loan-cond.NDays:SCREEN-VALUE  = STRING(tt-loan.end-date:INPUT-VALUE - tt-loan.open-date:INPUT-VALUE)
         tt-loan-cond.NMonth:SCREEN-VALUE = STRING(0)
         tt-loan-cond.NYears:SCREEN-VALUE = STRING(0)
         mChangedField                    = YES   /* Для пересчета аннуитета */
      .
      ELSE IF GetXattrInit(tt-loan.Class-Code,"ФиксМес") EQ "Да" THEN
      ASSIGN
         tt-loan-cond.NDays:SCREEN-VALUE  = STRING(mNDays)
         tt-loan-cond.NMonth:SCREEN-VALUE = STRING(mNMonth + mNYear * 12)
         tt-loan-cond.NYears:SCREEN-VALUE = STRING(0)
         mChangedField                    = YES   /* Для пересчета аннуитета */
      .
      ELSE
      ASSIGN
         tt-loan-cond.NDays:SCREEN-VALUE  = STRING(mNDays)
         tt-loan-cond.NMonth:SCREEN-VALUE = STRING(mNMonth)
         tt-loan-cond.NYears:SCREEN-VALUE = STRING(mNYear)
         mChangedField                    = YES   /* Для пересчета аннуитета */
      .
   END.
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
     &RecalcAnnuitet = YES
     &LogVarChanged  = mChangedField
     &tt-loan        = tt-loan
     &tt-loan-cond   = tt-loan-cond
     &tt-comm-rate   = tt-comm-rate
     &tt-amount      = tt-amount
     &br-comm        = br-comm
  }
/*для счета Кредит проверим бал2 */
   DEFINE VAR yy            AS INT64     NO-UNDO.
   DEFINE VAR dd            AS INT64     NO-UNDO.
   DEF VAR vTerm  AS CHAR INITIAL ""
                          NO-UNDO.
   DEF VAR vDTType AS CHAR NO-UNDO.
   DEF VAR vDTKind AS CHAR NO-UNDO.
   DEF VAR vDTTerm AS CHAR NO-UNDO.
   DEF VAR vDTCust AS CHAR NO-UNDO.

   IF     AVAIL tt-instance
      AND iMode EQ {&MOD_ADD} THEN
   DO:
      RUN DTCust(tt-instance.cust-cat,tt-instance.cust-id,?,OUTPUT vDTcust).
      ASSIGN
         vDTType = GetXAttrValueEx("loan",
                                   tt-instance.contract + "," + tt-instance.cont-code,
                                   "DTType",
                                   GetXAttrInit(tt-instance.class-code,"DTType"))
         vDTKind = GetXAttrValueEx("loan",
                                   tt-instance.contract + "," + tt-instance.cont-code,
                                   "DTKind",
                                   GetXAttrInit(tt-instance.class-code,"DTKind"))
         pick-value = ?
      .
      FOR EACH code WHERE code.class = "DTTerm" AND code.parent = "DTTerm"
          NO-LOCK:
         IF IS-Term(DATE(tt-loan.open-date:SCREEN-VALUE),
                    (IF DATE(tt-loan.end-date:SCREEN-VALUE) = ? THEN
                        12/31/9999
                     ELSE
                        DATE(tt-loan.end-date:SCREEN-VALUE)),
                    code.code,
                    NO,
                    0,
                    OUTPUT yy,
                    OUTPUT dd)
    THEN DO:
            Mask = tt-instance.contract + CHR(1)
                          + vDTType + CHR(1)
                          + vDTCust + CHR(1)
                          + vDTKind + CHR(1)
                          + code.code.
            RUN cbracct.p("DecisionTable","DecisionTable","DecisionTable",0).
            LEAVE.
         END.
      END. /*FOR*/
      IF pick-value EQ ? THEN
         RUN Fill-SysMes IN h_tmess ("", "", "0", "Для транша не определен бал2 ").
      ELSE IF NOT tt-loan-acct-main.acct BEGINS pick-value THEN
      DO:
/* поищем на др траншах */
         ASSIGN
            tt-loan-acct-main.acct = ?
            tt-loan-acct-main.acct:SCREEN-VALUE = ?
         .
         IF GetXAttrValueEx("loan",
                            tt-instance.contract + ',' + tt-instance.cont-code,
                            "ТраншПерТип",
                            "Да") EQ "Нет" THEN
         FOR EACH loan-acct WHERE loan-acct.contract  EQ tt-instance.contract
                              AND loan-acct.cont-code BEGINS tt-instance.cont-code
                              AND loan-acct.acct-type EQ tt-instance.contract
                              AND loan-acct.acct      BEGINS pick-value NO-LOCK,
            FIRST acct WHERE acct.acct EQ loan-acct.acct
                         AND acct.open-date LE DATE(tt-loan.open-date:SCREEN-VALUE)
                         AND (   acct.close-date EQ ?
                              OR acct.close-date GT DATE(tt-loan.end-date:SCREEN-VALUE))
                NO-LOCK :
            ASSIGN
               tt-loan-acct-main.acct = acct.number
               tt-loan-acct-main.acct:SCREEN-VALUE = acct.number
            .
         END.
      END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.end-date TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan.end-date IN FRAME fMain /* По */
DO:
  mSrokChange   = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.int-mode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.int-mode TERMINAL-SIMULATION
ON F1 OF tt-loan-cond.int-mode IN FRAME fMain /* int-mode */
,tt-loan-cond.cred-mode
DO:
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      SELF:READ-ONLY = NO.
      mCall_F1_IN_Frame = YES.
      APPLY "F1" TO FRAME {&MAIN-FRAME}.
      mCall_F1_IN_Frame = NO.
      SELF:READ-ONLY = YES.
      RETURN NO-APPLY.
   END.
   {&BT_F1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.int-mode TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.int-mode IN FRAME fMain /* int-mode */
DO:
   {&BEG_BT_LEAVE}
   IF tt-loan-cond.int-mode:INPUT-VALUE EQ "ПериодДн" THEN
   DO:
      RUN Fill-SysMes ("", "", "0", "Для % нельзя выбрать тип ПериодДн.") NO-ERROR.
      {return_no_apply.i '{&RET-ERROR}'}
   END.
   {&BT_LEAVE}
   /* изменяем видимые поля в зависимости от значения int-mode (Плат. период - проценты) */
   IF tt-loan-cond.int-mode:SCREEN-VALUE  EQ "КоличДней"
   THEN ASSIGN tt-loan-cond.DateDelayint     :VISIBLE = NO
               tt-loan-cond.int-curr-next    :VISIBLE = NO
               tt-loan-cond.delay            :VISIBLE = YES
               tt-loan-cond.int-work-calend  :VISIBLE = YES.
   ELSE ASSIGN tt-loan-cond.delay            :VISIBLE = NO
               tt-loan-cond.int-work-calend  :VISIBLE = NO
               tt-loan-cond.DateDelayint     :VISIBLE = YES
               tt-loan-cond.int-curr-next    :VISIBLE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.int-month
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.int-month TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.int-month IN FRAME fMain /* int-month */
DO:
  {&BEG_BT_LEAVE}
  /* Проверка на корректность месяца */
  IF  ( tt-loan-cond.int-period:INPUT-VALUE EQ "К"
    AND tt-loan-cond.int-month:INPUT-VALUE GT 3
    OR  tt-loan-cond.int-period:INPUT-VALUE EQ "ПГ"
    AND tt-loan-cond.int-month:INPUT-VALUE GT 6
    OR  tt-loan-cond.int-period:INPUT-VALUE EQ "Г"
    AND tt-loan-cond.int-month:INPUT-VALUE GT 12 )
    OR ((tt-loan-cond.int-period:INPUT-VALUE EQ "К"
    OR   tt-loan-cond.int-period:INPUT-VALUE EQ "ПГ"
    OR   tt-loan-cond.int-period:INPUT-VALUE EQ "Г")
    AND  tt-loan-cond.int-month:INPUT-VALUE  LE 0) THEN
  DO:
     RUN Fill-SysMes ("", "", "0", "В указанном периоде нет месяца с указанным номером.") NO-ERROR.
     {return_no_apply.i '{&RET-ERROR}'}
  END.
  {&BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.int-month TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.int-month IN FRAME fMain /* int-month */
DO:
  mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-offset_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-offset_ TERMINAL-SIMULATION
ON LEAVE OF int-offset_ IN FRAME fMain
DO:
   {&BEG_BT_LEAVE}
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      /* валидация значения */
      IF NOT CAN-DO(mOffsetVld,SELF:SCREEN-VALUE)  THEN
      DO:
         RUN GetXAttr (tt-loan.class-code,"int-offset",BUFFER xattr).
         RUN Fill-SysMes IN h_tmess ("", "", "0",
            "Значение реквизита ~"" + xattr.name + "~" класса ~"" + xattr.class-code +
            "~" не соответствует списку допустимых значений ~"" + mOffsetVld + "~"").
         RETURN NO-APPLY {&RET-ERROR}.
      END.
      ASSIGN
         /* записываем правильное значение в "настоящее" поле ({&CB-NONE} вместо "--") */
         tt-loan-cond.int-offset:SCREEN-VALUE = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                           THEN {&CB-NONE}
                                           ELSE SELF:SCREEN-VALUE
         tt-loan-cond.int-offset              = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                           THEN ""
                                           ELSE SELF:SCREEN-VALUE.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.int-period
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.int-period TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.int-period IN FRAME fMain /* Проценты */
DO:
  {&BEG_BT_LEAVE}
  IF tt-loan-cond.int-period:INPUT-VALUE EQ "ДН" THEN
  DO:
     RUN Fill-SysMes ("", "", "0", "Для % нельзя выбрать тип ДН.") NO-ERROR.
     {return_no_apply.i '{&RET-ERROR}'}
  END.  
  {&BT_LEAVE}
  ASSIGN
     mNameIntPeriod:SCREEN-VALUE =
        GetDomainCodeName(tt-loan-cond.class-code,
                          "int-period",
                          tt-loan-cond.int-period:SCREEN-VALUE)
  .
  mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
  {loan-trg.pro
     &RecalcAnnuitet = YES
     &LogVarChanged  = mChangedField
     &tt-loan        = tt-loan
     &tt-loan-cond   = tt-loan-cond
     &tt-comm-rate   = tt-comm-rate
     &tt-amount      = tt-amount
     &br-comm        = br-comm
  }
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.int-period TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.int-period IN FRAME fMain /* Проценты */
DO:
  ASSIGN
     tt-loan-cond.int-month:SCREEN-VALUE = "1"
     mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.isklmes$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.isklmes$ TERMINAL-SIMULATION
ON F1 OF tt-loan-cond.isklmes$ IN FRAME fMain /* Искл. мес. */
DO:

  IF tt-loan.cont-code = "" THEN DO:
     MESSAGE "Введите номер договора."
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
     APPLY "entry" TO tt-loan.doc-ref IN FRAME {&FRAME-NAME}.
     RETURN NO-APPLY.
  END.

  DO TRANSACTION:
     RUN term-exc.p (iMode,
                     tt-loan.contract,
                     tt-loan.cont-code,
                     IF iMode EQ {&MOD_ADD}
                        THEN tt-loan.open-date
                        ELSE tt-loan-cond.since,
                     INPUT-OUTPUT TABLE ttTermObl,
                     INPUT 4).
     IF CAN-FIND(FIRST ttTermObl) THEN
         SELF:SCREEN-VALUE = "yes".
     ELSE SELF:SCREEN-VALUE = "no".

     mChangedField = YES.
     mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
     {loan-trg.pro
         &RecalcAnnuitet = YES
         &LogVarChanged  = mChangedField
         &tt-loan        = tt-loan
         &tt-loan-cond   = tt-loan-cond
         &tt-comm-rate   = tt-comm-rate
         &tt-amount      = tt-amount
         &br-comm        = br-comm
      }
  END.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.isklmes$ TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.isklmes$ IN FRAME fMain /* Искл. мес. */
DO:
  IF SELF:SCREEN-VALUE = "yes" THEN DO:
     APPLY "F1" TO SELF.
  END.
  ELSE DO:
      FOR EACH ttTermObl:
          DELETE ttTermObl.
      END.
      mChangedField = YES.
      mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
      {loan-trg.pro
         &RecalcAnnuitet = YES
         &LogVarChanged  = mChangedField
         &tt-loan        = tt-loan
         &tt-loan-cond   = tt-loan-cond
         &tt-comm-rate   = tt-comm-rate
         &tt-amount      = tt-amount
         &br-comm        = br-comm
      }
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.kollw#gtper$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.kollw#gtper$ TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.kollw#gtper$ IN FRAME fMain /* kollw#gtper$ */
DO:
   {&BEG_BT_LEAVE}
      /* валидация значения */
   IF INT64(SELF:SCREEN-VALUE) GE GetQntPer(DATE(tt-loan.open-date:SCREEN-VALUE),
                                          DATE(tt-loan.end-date:SCREEN-VALUE),
                                          IF tt-loan-cond.cred-date:VISIBLE EQ YES
                                             THEN INT64(tt-loan-cond.cred-date:SCREEN-VALUE)
                                             ELSE 0,
                                          tt-loan-cond.cred-period:SCREEN-VALUE + ":" + tt-loan-cond.cred-month:SCREEN-VALUE,
                                          tt-loan-cond.since)
      AND INT64(SELF:SCREEN-VALUE) NE 0 THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0",
         "Число льготных периодов должно быть меньше числа полных периодов").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
      &RecalcAnnuitet = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.kollw#gtper$ TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.kollw#gtper$ IN FRAME fMain /* kollw#gtper$ */
DO:
  mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.kollw#gtperprc$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.kollw#gtperprc$ TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.kollw#gtperprc$ IN FRAME fMain /* kollw#gtperprc$ */
DO:
   {&BEG_BT_LEAVE}
      /* валидация значения */
   IF INT64(SELF:SCREEN-VALUE) GE GetQntPer(DATE(tt-loan.open-date:SCREEN-VALUE),
                                          DATE(tt-loan.end-date:SCREEN-VALUE),
                                          IF tt-loan-cond.int-date:VISIBLE EQ YES
                                             THEN INT64(tt-loan-cond.int-date:SCREEN-VALUE)
                                             ELSE 0,
                                          tt-loan-cond.int-period:SCREEN-VALUE + ":" + tt-loan-cond.int-month:SCREEN-VALUE,
                                          tt-loan-cond.since)
      AND INT64(SELF:SCREEN-VALUE) NE 0 THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0",
         "Число льготных периодов должно быть меньше числа полных периодов").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   {&BT_LEAVE}
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
      &RecalcAnnuitet = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.kollw#gtperprc$ TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.kollw#gtperprc$ IN FRAME fMain /* kollw#gtperprc$ */
DO:
  mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.kredplat$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.kredplat$ TERMINAL-SIMULATION
ON F5 OF tt-loan-cond.kredplat$ IN FRAME fMain /* kredplat$ */
DO:
   DEF VAR mPerCnt      AS INT64    NO-UNDO. /* счетчик периодов */
   DEF VAR vi_lgt       AS INT64    NO-UNDO. /* число льготных периодов по ОД */
   DEF VAR vGrDateS     AS DATE     NO-UNDO. /* дата начала графика погошения */
   DEF VAR vGrDatePo    AS DATE     NO-UNDO. /* дата окончания графика погошения */

   vi_lgt = INT64(tt-loan-cond.kollw#gtper$:SCREEN-VALUE).   /* определение числа льготных периодов по ОД */
   IF tt-loan-cond.grperiod$ AND tt-loan-cond.grdatas$ NE ? THEN
      vGrDateS = tt-loan-cond.grdatas$ - 1.
   ELSE
      vGrDateS = DATE(tt-loan.open-date:SCREEN-VALUE).
   IF tt-loan-cond.grperiod$ AND tt-loan-cond.grdatapo$ NE ? THEN
      vGrDatePo = tt-loan-cond.grdatapo$.
   ELSE
      vGrDatePo = DATE(tt-loan.end-date:SCREEN-VALUE).
   mPerCnt = GetQntPer (vGrDateS,
                        vGrDatePo,
                        IF tt-loan-cond.cred-date:VISIBLE EQ YES THEN INT64(tt-loan-cond.cred-date:SCREEN-VALUE)
                                                              ELSE 0,
                        tt-loan-cond.cred-period:SCREEN-VALUE + ":" + tt-loan-cond.cred-month:SCREEN-VALUE,
                        tt-loan-cond.since) - vi_lgt.
      /* предвычисление суммы платежа */
   SELF:SCREEN-VALUE = STRING(DEC(tt-amount.amt-rub:SCREEN-VALUE) / mPerCnt).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mBag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mBag TERMINAL-SIMULATION
ON F1 OF mBag IN FRAME fMain /* Портфель */
DO:
   IF       iMode             EQ {&MOD_VIEW}
      AND   SELF:SCREEN-VALUE NE ""
      AND   SELF:SCREEN-VALUE NE "?"
      THEN RUN bagform.p (?, ?, "UniformBag", "ПОС," + SELF:SCREEN-VALUE, {&MOD_VIEW}, 4).

   IF       iMode             EQ {&MOD_ADD}
      THEN DO:
         DO TRANSACTION: /* без TRANSACTION  некорректный pick-value */
            RUN browseld.p ('UniformBag', '', '', '', 4).
            IF LASTKEY NE 10
            THEN
               pick-value = "".
         END.
         RUN bagadd.p (
            INPUT tt-loan.contract,
            INPUT tt-loan.cont-code,
            INPUT pick-value,
            INPUT tt-loan.open-date,
            INPUT gEnd-date
            ) NO-ERROR .

         IF ERROR-STATUS :ERROR THEN DO:
            RUN Fill-SysMes IN h_tmess ("", "", "0", RETURN-VALUE ).
            RETURN NO-APPLY {&RET-ERROR}.
         END.
         ELSE DO:
            mBag = pick-value.
            DISPLAY mBag WITH FRAME {&FRAME-NAME} .

         END.
      END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mSvod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mSvod TERMINAL-SIMULATION
ON " ",F1 OF mSvod IN FRAME fMain /* Сводный график */
DO:
   RUN "f-mm-dop.p" (INPUT-OUTPUT tt-loan.svodgrafik$,   /* ДР СводГрафик */
                     INPUT-OUTPUT tt-loan.svodskonca$,   /* ДР СводСКонца */
                     INPUT-OUTPUT tt-loan.svodgravto$,   /* ДР СводГрАвто */
                     INPUT-OUTPUT tt-loan.svodspostr$,   /* ДР СводСПосТр */
                     10,
                     iLevel + 11,
                     mSvodROnly).
   mSvod:SCREEN-VALUE = STRING(tt-loan.svodgrafik$ OR tt-loan.svodskonca$ OR tt-loan.svodgravto$ OR tt-loan.svodspostr$).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mGrRiska
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mGrRiska TERMINAL-SIMULATION
ON F1 OF mGrRiska IN FRAME fMain /* Гр */
DO:

   DO TRANSACTION:

      RUN codelay.p  ("Резерв",
                      "Резерв",
                      "Категории качества",
                      iLevel + 1).

   END.

   IF LASTKEY = 10 AND pick-value <> ? THEN
   DO: 
       SELF:SCREEN-VALUE = ENTRY(1,pick-value,"гр").
       mIsChanGRisk = YES.
   END.     

   RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mGrRiska TERMINAL-SIMULATION
ON LEAVE OF mGrRiska IN FRAME fMain /* Гр */
DO:
   DEFINE VARIABLE vListGrRiska AS CHARACTER   NO-UNDO.
   {&BEG_BT_LEAVE}
   /*{&BT_LEAVE}*/
   IF (INPUT {&SELF-NAME} ) <>  {&SELF-NAME} THEN
   DO:
      ASSIGN {&SELF-NAME}.
      RUN LnGetRiskGrList IN h_i254 (DEC(mRisk:SCREEN-VALUE),
                                     DATE(tt-loan.open-date:SCREEN-VALUE),
                                     YES,
                                     OUTPUT vListGrRiska).

      IF NOT CAN-DO(vListGrRiska,mGrRiska:SCREEN-VALUE)
      THEN DO:

         RUN LnGetPersRsrvOnDate IN h_i254 (INPUT INPUT mGrRiska,
                                       INPUT INPUT tt-loan.open-date,
                                        OUTPUT mRisk).

         mRisk:SCREEN-VALUE = STRING(mRisk).
      END.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mLimit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mLimit TERMINAL-SIMULATION
ON LEAVE OF mLimit IN FRAME fMain /* Лимит в. */
DO:
   IF iMode EQ {&MOD_ADD} THEN
      mLimitRest:SCREEN-VALUE = mLimit:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mRisk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mGrRiska TERMINAL-SIMULATION
ON VALUE-CHANGED OF mGrRiska IN FRAME fMAin
DO:
   {&BEG_BT_LEAVE}
   mIsChanGRisk = YES.
   {&END_BT_LEAVE}
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mRisk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mRisk TERMINAL-SIMULATION
ON LEAVE OF mRisk IN FRAME fMain /* Риск */
DO:
   DEFINE VARIABLE vListGrRiska AS CHARACTER   NO-UNDO.
   {&BEG_BT_LEAVE}
   IF mRisk:INPUT-VALUE < 0 OR
      mRisk:INPUT-VALUE > 100 THEN
   DO:
      MESSAGE 'Неправильный коэффициент резервирования'
         VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY {&RET-ERROR}.
   END.

   IF (INPUT {&SELF-NAME} ) <>  {&SELF-NAME} THEN
   DO:

      ASSIGN {&SELF-NAME}.

      RUN LnGetRiskGrList IN h_i254 (DEC(mRisk:SCREEN-VALUE),
                                     DATE(tt-loan.open-date:SCREEN-VALUE),
                                     YES,
                                     OUTPUT vListGrRiska).
                                     
      IF NOT CAN-DO(vListGrRiska,mGrRiska:SCREEN-VALUE) OR NOT mIsChanGRisk
      THEN DO:
         RUN LnGetRiskGrOnDate IN h_i254 (DEC(mRisk:SCREEN-VALUE),
                                          DATE(tt-loan.open-date:SCREEN-VALUE),
                                          OUTPUT mGrRiska).
         IF mGrRiska = ? THEN
         DO:
            MESSAGE 'Не удалось расчитать КК' SKIP
                    'по указанному коэффициенту резервирования'
               VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY {&RET-ERROR}.
         END.

         mGrRiska:SCREEN-VALUE = STRING(mGrRiska).
      END.
      ELSE mGrRiska:SCREEN-VALUE = ENTRY(1,vListGrRiska).
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.NYears
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.NYears TERMINAL-SIMULATION
ON ENTRY OF tt-loan-cond.NYears IN FRAME fMain /* Лет */
DO:
   vEndRasch = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.NYears TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.NYears IN FRAME fMain /* Лет */
DO:
   IF iMode = {&MOD_ADD} AND tt-loan.open-date:SCREEN-VALUE NE "?" AND NOT vEndRasch THEN DO:

      tt-loan.end-date:SCREEN-VALUE = STRING(
                        GoMonth(DATE(tt-loan.open-date:SCREEN-VALUE),
                                INT64(tt-loan-cond.NYears:SCREEN-VALUE) * 12 +
                                INT64(tt-loan-cond.NMonth:SCREEN-VALUE))
                      + INT64(tt-loan-cond.NDays:SCREEN-VALUE)
                   ).
      vEndRasch = YES.
   END.
   mSrokChange = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.open-date
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.open-date TERMINAL-SIMULATION
ON LEAVE OF tt-loan.open-date IN FRAME fMain /* С */
DO:
   DEF VAR vDayTr AS INT64 NO-UNDO.
   DEF VAR vProdPog AS CHAR  NO-UNDO.

   {&BEG_BT_LEAVE}

  IF AVAIL tt-instance THEN
  DO:
     IF tt-loan.open-date:INPUT-VALUE LT tt-instance.open-date THEN
     DO:
        MESSAGE "Дата открытия течения не может быть меньше даты открытия договора"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN NO-APPLY {&RET-ERROR}.
     END.
     IF iMode EQ {&MOD_ADD} THEN
     DO:
        vDayTr = INT64(GetXAttrValueEx("loan",
                       tt-instance.contract + ',' + tt-instance.cont-code,
                       "ОврПр",
                       "0")).
        IF vDayTr GT 0 AND tt-loan.end-date EQ ? THEN
           ASSIGN
              mSrokChange = TRUE
              tt-loan.end-date:SCREEN-VALUE = STRING(DATE(DATE(tt-loan.open-date:SCREEN-VALUE) + vDayTr))
              tt-loan.end-date = DATE(tt-loan.end-date:SCREEN-VALUE)
           NO-ERROR.
     END.
  END.

  IF DATE(tt-loan.open-date:SCREEN-VALUE) < DATE(tt-loan.datasogl$:SCREEN-VALUE) THEN
  DO:
     MESSAGE "Дата открытия должна быть больше или равна даты заключения договора"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN NO-APPLY {&RET-ERROR}.
  END.

  {&BT_LEAVE}

   IF    mSrokChange
     AND tt-loan.open-date:SCREEN-VALUE NE "?"
     AND tt-loan.end-date:SCREEN-VALUE  NE "?"
     AND tt-loan.end-date:SCREEN-VALUE  NE "" THEN
   DO:
      RUN DMY_In_Per(tt-loan.open-date:SCREEN-VALUE,
                     tt-loan.end-date:SCREEN-VALUE,
                     OUTPUT mNDays,
                     OUTPUT mNMonth,
                     OUTPUT mNYear).

      IF GetXattrInit(tt-loan.Class-Code,"ФиксДн") EQ "Да" THEN
      ASSIGN
         tt-loan-cond.NDays:SCREEN-VALUE  = STRING(tt-loan.end-date:INPUT-VALUE - tt-loan.open-date:INPUT-VALUE)
         tt-loan-cond.NMonth:SCREEN-VALUE = STRING(0)
         tt-loan-cond.NYears:SCREEN-VALUE = STRING(0)
      .
      ELSE IF GetXattrInit(tt-loan.Class-Code,"ФиксМес") EQ "Да" THEN
      ASSIGN
         tt-loan-cond.NDays:SCREEN-VALUE  = STRING(mNDays)
         tt-loan-cond.NMonth:SCREEN-VALUE = STRING(mNMonth + mNYear * 12)
         tt-loan-cond.NYears:SCREEN-VALUE = STRING(0)
      .
      ELSE
      ASSIGN
         tt-loan-cond.NDays:SCREEN-VALUE  = STRING(mNDays)
         tt-loan-cond.NMonth:SCREEN-VALUE = STRING(mNMonth)
         tt-loan-cond.NYears:SCREEN-VALUE = STRING(mNYear)
      .
   END.
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.

   IF     mSrokChange    
      AND {assigned tt-loan.prodkod$} THEN
   DO:
      vProdPog = GetRefVal ("ПродПог", gend-date, tt-loan.prodkod$ + "," + "ОД").

      IF ENTRY(NUM-ENTRIES(vProdPog), vProdPog) EQ "ДД" THEN
      DO:
         pick-value = ?.
         RUN Fill-SysMes ("", "", "3",
                          "Изменить дни погашения основного долга и процентов?|Да,Нет").
         IF pick-value EQ "1" THEN
         DO:
            ASSIGN
               tt-loan-cond.cred-date:SCREEN-VALUE = STRING(DAY(DATE(tt-loan.open-date:SCREEN-VALUE)))
               tt-loan-cond.int-date:SCREEN-VALUE  = STRING(DAY(DATE(tt-loan.open-date:SCREEN-VALUE)))
            .
         END.
      END.
   END.

  {loan-trg.pro
     &RecalcAnnuitet = YES
     &LogVarChanged  = mChangedField
     &tt-loan        = tt-loan
     &tt-loan-cond   = tt-loan-cond
     &tt-comm-rate   = tt-comm-rate
     &tt-amount      = tt-amount
     &br-comm        = br-comm
  }

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.open-date TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan.open-date IN FRAME fMain /* С */
DO:
  ASSIGN
     mSrokChange   = YES
     mChangedField = YES
  .

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan-cond.annuitkorr$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.annuitkorr$ TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.annuitkorr$ IN FRAME fMain /*          Сумма */
DO:
   {&BEG_BT_LEAVE}
   {&BT_LEAVE}
   mChangedField = NOT mHandCalcAnnuitet.
   {loan-trg.pro
      &RecalcAnnuitet = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan.user-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.user-id TERMINAL-SIMULATION
ON LEAVE OF tt-loan.user-id IN FRAME fMain /* Юзер */
DO:
   {&BEG_BT_LEAVE}

   IF iMode NE {&MOD_VIEW} THEN 
   DO:
      IF NOT {assigned tt-loan.user-id:SCREEN-VALUE} THEN 
      DO:
         RUN Fill-SysMes IN h_tmess ("", "", "0",
                                     "Реквизит  ~"Сотрудник~" обязательный.").
         RETURN NO-APPLY {&RET-ERROR}.
      END.
   END.   
  
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan-cond.grperiod$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mStrah TERMINAL-SIMULATION
ON " ", F1 OF tt-loan-cond.grperiod$ IN FRAME fMain
DO:
   RUN per-graf.p(iMode,
                  tt-loan.open-date:INPUT-VALUE,
                  tt-loan.end-date:INPUT-VALUE,
                  INPUT-OUTPUT tt-loan-cond.grdatas$,
                  INPUT-OUTPUT tt-loan-cond.grdatapo$
                  ).
   tt-loan-cond.grperiod$ = tt-loan-cond.grdatas$ NE ? OR tt-loan-cond.grdatapo$ NE ?.
   DISPLAY tt-loan-cond.grperiod$ WITH FRAME fMain.
END.
   /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mStrah TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.grperiod$ IN FRAME fMain
DO:
   {&BEG_BT_LEAVE}
   tt-loan-cond.grperiod$ = tt-loan-cond.grdatas$ NE ? OR tt-loan-cond.grdatapo$ NE ?.
   DISPLAY tt-loan-cond.grperiod$ WITH FRAME fMain.
   {&BT_LEAVE}
END.

   /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK TERMINAL-SIMULATION


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE
   RUN disable_UI.

/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.
ON ENDKEY, END-ERROR OF FRAME fMain ANYWHERE DO:
   DEFINE VARIABLE mChoice AS LOGICAL     NO-UNDO.
   IF iMode NE {&MOD_VIEW}
   THEN DO:
      MESSAGE
         "Выйти без сохранения изменений?"
      VIEW-AS ALERT-BOX BUTTONS YES-NO UPDATE mChoice.
      IF NOT mChoice OR
         mChoice EQ ?
         THEN RETURN NO-APPLY.
   END.
   mRetVal = IF mOnlyForm THEN
      {&RET-ERROR}
      ELSE
         "".
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

ON ENTRY OF tt-comm-rate.rate-fixed IN BROWSE br-comm
DO:
   IF LASTKEY EQ KEYCODE ("TAB")
   THEN  DO:
      APPLY "ENTRY" TO tt-comm-rate.rate-comm IN BROWSE br-comm.
      RETURN NO-APPLY.
   END.
END.

ON ENTRY OF tt-comm-rate.commission IN BROWSE br-comm
DO:
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      IF LASTKEY EQ KEYCODE ("BACK-TAB")
      THEN /* BACK-TAB */
         APPLY "BACK-TAB" TO BROWSE br-comm.
      ELSE /* TAB  OR  ENTER */
         APPLY "ENTRY" TO tt-comm-rate.rate-comm IN BROWSE br-comm.
      RETURN NO-APPLY.
   END.
END.

&IF DEFINED(MANUAL-REMOTE) &THEN
ON F9 OF br-comm IN FRAME fMain ANYWHERE
DO:
   DEFINE VARIABLE vOk AS LOGICAL    NO-UNDO.

   IF iMode <> {&MOD_ADD} OR NOT AVAIL tt-comm-rate THEN
      RETURN NO-APPLY.

   RUN f-crate.p (INPUT BUFFER tt-comm-rate:HANDLE,br-comm:ROW,OUTPUT vOk).
   IF vOk  THEN
   DO:
      br-comm:REFRESH().
      &IF DEFINED(MANUAL-REMOTE) &THEN
      RUN UpdateBrowser(br-comm:HANDLE).
      &ENDIF
   END.
END.
ON INSERT OF br-comm IN FRAME fMain ANYWHERE
DO:
   APPLY "CTRL-F2" TO br-comm.
   RETURN NO-APPLY.
END.
ON DEL OF br-comm IN FRAME fMain ANYWHERE
DO:
   APPLY "CTRL-F3" TO br-comm.
   RETURN NO-APPLY.
END.
&ENDIF

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

   /* Commented by KSV: Инициализация системных сообщений */
   RUN Init-SysMes("","","").

   /* Commented by KSV: Корректируем вертикальную позицию фрейма */
   iLevel = GetCorrectedLevel(FRAME fMain:HANDLE,iLevel).
   FRAME fMain:ROW = iLevel.
   /* Делаем TITLE COLOR bright-white */
   FRAME fMain:TITLE-DCOLOR = {&bright-white}.

   /*mitr: инструмент для получения % ставок по умолчанию для
   комиссий, прописанных в доп.реквизите loan.rate-list */
   RUN ln-init-rate.p PERSISTENT SET hDefaultRate .

/* Commented by KSV: Читаем данные */
   RUN GetObject.

   IF tt-loan-cond.isklmes$ = ? THEN tt-loan-cond.isklmes$ = NO.

   IF iMode = {&MOD_ADD} THEN
   DO:
      tt-loan.filial-id = dept.branch.
   END.

   ASSIGN
      mRateList = GetXattrEx(iClass,"rate-list","Initial")
      mBrowseCommRateOFF = NOT {assigned tt-loan.rate-list}
   .
   IF NOT mBrowseCommRateOFF THEN
   DO:
      IF iMode EQ {&MOD_ADD} THEN
      DO:
         DO mI = 1 TO NUM-ENTRIES(mRateList):
            FIND FIRST tt-comm-rate WHERE tt-comm-rate.commission = "" NO-ERROR.
            IF NOT AVAIL tt-comm-rate THEN
            DO:
               CREATE tt-comm-rate.
               tt-comm-rate.local__id = mI.
               CREATE tt-comm-cond.
               tt-comm-cond.local__id = mI.
            END.
            ASSIGN
               tt-comm-rate.commission = ENTRY(mI,mRateList)
               tt-comm-rate.acct       =  "0"
               tt-comm-cond.commission = ENTRY(mI,mRateList)
            .
            tt-comm-rate.rate-fixed = GET_HEAD_COMM_TYPE (tt-comm-rate.commission,
                                                          tt-loan.currency,
                                                          tt-loan.open-date).
         END.
         FOR EACH tt-comm-rate:
            tt-comm-rate.since = tt-loan-cond.since.
         END.
         FOR EACH tt-comm-cond:
            tt-comm-cond.since = tt-loan-cond.since.
         END.

            /* Создание ставок по тарифам */
         IF     tt-loan-cond.prodtrf$ NE ?
            AND tt-loan-cond.prodtrf$ NE ""
            AND tt-loan-cond.prodtrf$ NE "?" THEN
         DO:
               /* Сначала на "ПродЛин" ищем общий тариф продукта╨ */
            IF     tt-loan.prodkod$ NE ""
               AND tt-loan.prodkod$ NE "?"
               AND tt-loan.prodkod$ NE ? THEN
            DO:
                  /* Ищем напрямую темпорированный классификатор, т.к.
                  ** getTCodeFld отказывается работать с массивами */
               mProdCode = tt-loan.prodkod$.
               FIND LAST tmp-code WHERE
                         tmp-code.class      EQ "ПродЛин"
                  AND    tmp-code.code       EQ mProdCode
                  AND    tmp-code.beg-date   LE tt-loan.open-date
                  AND   (tmp-code.end-date   GE tt-loan.open-date
                     OR  tmp-code.end-date   EQ ?)
               NO-LOCK NO-ERROR.
                  /* Если на подпродукте не задан базовый тариф, то ищем на родителях */
               REPEAT WHILE AVAIL tmp-code AND tmp-code.misc[7] EQ "":
                  FIND FIRST code WHERE
                             code.class EQ "ПродЛин"
                         AND code.code  EQ mProdCode
                  NO-LOCK NO-ERROR.
                  IF AVAIL code AND code.parent NE "" THEN
                  DO:
                     mProdCode = code.parent.
                     FIND LAST tmp-code WHERE
                               tmp-code.class      EQ "ПродЛин"
                        AND    tmp-code.code       EQ mProdCode
                        AND    tmp-code.beg-date LE tt-loan.open-date
                        AND   (tmp-code.end-date GE tt-loan.open-date
                            OR tmp-code.end-date EQ ?)
                     NO-LOCK NO-ERROR.
                  END.
                  ELSE
                     RELEASE tmp-code.
               END.

               IF AVAIL tmp-code AND tmp-code.misc[7] NE "" THEN
                  RUN SetTariffCommRate (tmp-code.misc[7]).
            END.

               /* И, наконец, частный тариф продукта */
            RUN SetTariffCommRate (tt-loan-cond.prodtrf$).
               /* корректируем тарифы модификаторами */
            IF     tt-loan.prodkod$ NE ""
               AND tt-loan.prodkod$ NE "?"
               AND tt-loan.prodkod$ NE ? THEN
               RUN ModCommRate (tt-loan.prodkod$).
         END.
      END.
      ELSE
      DO:
         mI = 1.
         FOR EACH tt-commrate BREAK BY tt-commrate.commission:
            IF LAST-OF(tt-commrate.commission) THEN
            DO:
               FIND FIRST tt-comm-rate WHERE
                          tt-comm-rate.commission EQ tt-commrate.commission AND
                          tt-comm-rate.since EQ tt-loan-cond.since NO-LOCK NO-ERROR.

               IF AVAILABLE tt-comm-rate THEN DO:

                  ASSIGN
                     msurrcr2 = string(tt-comm-rate.commission) + "," +
                                string(tt-comm-rate.acct) + "," +
                                string(tt-loan.currency) + "," +
                                PushSurr(STRING(tt-loan.contract) + "," + STRING(tt-loan.cont-code))  + "," +
                                string(tt-comm-rate.min-value) + "," +
                                string(tt-comm-rate.period) + "," +
                                string(tt-comm-rate.since)
                     tt-comm-rate.min_value = dec(GetXAttrValueEx("comm-rate",msurrcr2,"МинЗнач","0"))
                  .
               END.
               ELSE DO:
                  /* все ставки покажем только для условия ПОСЛЕДИЕ  */
                  IF NOT CAN-DO("ПЕРВЫЕ,ДАТАСОСТ", mFindLoanCond) THEN DO:
                  CREATE tt-comm-rate.
                  ASSIGN
                     tt-comm-rate.commission = tt-commrate.commission
                     tt-comm-rate.since = tt-loan-cond.since
                     tt-comm-rate.rate-comm = tt-commrate.rate-comm
                     tt-comm-rate.local__template = YES
                     tt-comm-rate.local__id = GetInstanceId("tt-comm-rate") + mI
                     mI = mI + 1
                  .
                     tt-comm-rate.rate-fixed = GET_HEAD_COMM_TYPE (tt-comm-rate.commission,
                                                                   tt-loan.currency,
                                                                   tt-loan.open-date).
               END.
              END.
            END.
         END.
      END.
      /* Теперь создадим информацию по плавающим ставкам */
      mI = 1.
      FOR EACH tt-comm-rate:
         FIND FIRST tt-comm-cond WHERE tt-comm-cond.commission EQ tt-comm-rate.commission
                                   AND tt-comm-cond.since      EQ tt-comm-rate.since
         EXCLUSIVE-LOCK NO-ERROR.
         IF NOT AVAIL tt-comm-cond THEN
         DO:
            FOR EACH b-comm-cond BY b-comm-cond.Local__Id DESC:
               LEAVE.
            END.
            CREATE tt-comm-cond.
            ASSIGN
               tt-comm-cond.commission = tt-comm-rate.commission
               tt-comm-cond.since      = tt-comm-rate.since
               tt-comm-cond.contract   = tt-loan.contract
               tt-comm-cond.cont-code  = tt-loan.cont-code
               tt-comm-cond.class-code = "comm-cond"
               tt-comm-cond.local__template = YES
               tt-comm-cond.local__Id = MAX(GetInstanceId("tt-comm-cond"),
                                            b-comm-cond.Local__Id) + 1.
           .




               FIND LAST comm-cond WHERE comm-cond.contract   EQ tt-loan.contract
                                     AND comm-cond.cont-code  EQ tt-loan.cont-code
                                     AND comm-cond.commission EQ tt-comm-cond.commission
                                     AND comm-cond.since      LE tt-comm-cond.since
               NO-LOCK NO-ERROR.
                  /* подтягиваем только тип, т.к. в форму плавающих ставок при
                  ** редактировании не попасть */
               IF AVAIL comm-cond THEN
                  ASSIGN
                     tt-comm-cond.FloatType = comm-cond.FloatType.
            END.
         END.


      /* Предзаполняем ставки на основании классификатора ПлавСтПарам */
      IF iMode EQ {&MOD_ADD} THEN
      DO:
         vCredPlav = GetXattrInit (tt-loan.class-code,"КредПлав").
         IF    vCredPlav NE ""
           AND vCredPlav NE ? THEN
         DO:
            DO vCounter = 1 TO NUM-ENTRIES(vCredPlav):

               FIND FIRST code WHERE code.class EQ "ПлавСтПарам"
                                 AND code.code  EQ ENTRY(vCounter,vCredPlav)
               NO-LOCK NO-ERROR.
               IF AVAIL code THEN
               DO:
                  FIND FIRST tt-comm-cond WHERE tt-comm-cond.commission EQ ENTRY(2,code.misc[2])
                                            AND tt-comm-cond.since      EQ tt-loan-cond.since
                  EXCLUSIVE-LOCK NO-ERROR.
                  IF AVAIL tt-comm-cond THEN
                  DO:
                     ASSIGN
                        tt-comm-cond.action     = code.misc[3]
                        tt-comm-cond.BaseChange = DEC(code.misc[4])
                        tt-comm-cond.BaseCode   = ENTRY(1,code.misc[2])
                        tt-comm-cond.contract   = tt-loan.contract
                        tt-comm-cond.cont-code  = tt-loan.cont-code
                        tt-comm-cond.day        = INT64(ENTRY(1,code.misc[8]))
                        tt-comm-cond.delay      = INT64(ENTRY(2,code.misc[5]))
                        tt-comm-cond.FirstDelay = INT64(ENTRY(1,code.misc[5]))
                        tt-comm-cond.FloatType  = YES
                        tt-comm-cond.month      = INT64(ENTRY(2,code.misc[8]))
                        tt-comm-cond.period     = code.misc[6]
                        tt-comm-cond.quantity   = INT64(code.misc[7])
                        tt-comm-cond.reference  = ENTRY(vCounter,vCredPlav)
                        tt-comm-cond.source     = code.misc[1]
                     .

                     /* Если ставка берется из договора, то ничего делать не надо, т.к. мы просто
                     ** указываем при вводе договора ставку. Если из общих ставок, то вычисляем
                     ** по указанным правилам */
                     IF tt-comm-cond.source EQ "Общие ставки" THEN
                     DO:
                        RUN CalcFloatRate (tt-loan.contract,
                                           tt-loan.cont-code,
                                           tt-comm-cond.source,
                                           tt-comm-cond.BaseCode,
                                           DATE(tt-loan.open-date:SCREEN-VALUE),
                                           tt-comm-cond.action,
                                           tt-comm-cond.BaseChange,
                                           tt-comm-cond.firstdelay,
                                           OUTPUT vRatePS).
                        IF vRatePS NE 0 THEN
                           FIND FIRST tt-comm-rate WHERE tt-comm-rate.commission EQ tt-comm-cond.commission
                                                     AND tt-comm-rate.since      EQ tt-comm-cond.since
                           EXCLUSIVE-LOCK NO-ERROR.
                           IF AVAIL tt-comm-rate THEN
                              ASSIGN
                                 tt-comm-rate.rate-comm = vRatePS.
                     END.
                  END.
               END.
            END.
         END.
      END.
   END.

   IF iMode EQ {&MOD_EDIT} OR
      iMode EQ {&MOD_VIEW} THEN
   DO:

      mRisk = LnRsrvRate(tt-loan.contract, tt-loan.cont-code, tt-loan.since).
      mGrRiska = re_history_risk(tt-loan.contract, tt-loan.cont-code, tt-loan.since, INT64(mRisk)).
      mBag = LnInBagOnDate (tt-loan.contract, tt-loan.cont-code, gend-date ).

      FOR FIRST tt-amount WHERE tt-amount.amt-rub NE 0 BY tt-amount.end-date:
         LEAVE.
      END.
      FIND LAST tt-percent NO-ERROR.
      FIND LAST tt-loan-acct-main NO-ERROR.
      FIND LAST tt-loan-acct-cust NO-ERROR.
   END.

   /* Если у нас последнее условие и оно на дату окончания договора,
   ** то необходимо отображать не 0, в карточке дог-ра, а сумму последнего
   ** не нулевого планового платежа */
   IF tt-loan-cond.since EQ tt-loan.end-date THEN
      RUN RE_PLAN_SUMM_BY_LOAN IN h_loan (tt-loan.contract,
                                          tt-loan.cont-code,
                                          tt-loan-cond.since - 1,
                                          OUTPUT mSumma-sd).
   ELSE
      RUN RE_PLAN_SUMM_BY_LOAN IN h_loan (tt-loan.contract,
                                          tt-loan.cont-code,
                                          tt-loan-cond.since,
                                          OUTPUT mSumma-sd).
   ASSIGN
      mEndDate    = tt-loan.end-date
      mAmount     = mSumma-sd
      mCredPeriod = tt-loan-cond.Cred-Period  WHEN AVAIL tt-loan-cond
      mCredDate   = tt-loan-cond.Cred-Date    WHEN AVAIL tt-loan-cond
      mIntPeriod  = tt-loan-cond.int-period
      mIntDate    = tt-loan-cond.int-date
      mDelay1     = tt-loan-cond.Delay1       WHEN AVAIL tt-loan-cond
      mCredOffset = tt-loan-cond.cred-offset
      mCountPer   = tt-loan-cond.kollw#gtper$ WHEN AVAIL tt-loan-cond

      mBranchName = GetCliName(
         "В",
         tt-loan.branch-id,
         OUTPUT vAddr,
         OUTPUT vINN,
         OUTPUT vKPP,
         INPUT-OUTPUT vType,
         OUTPUT vCode,
         OUTPUT vAcct)
      mNameCredPeriod =
         GetDomainCodeName(tt-loan-cond.class-code,
                           "cred-period",
                           tt-loan-cond.cred-period)
      mNameIntPeriod =
         GetDomainCodeName(tt-loan-cond.class-code,
                           "int-period",
                           tt-loan-cond.int-period)
      mNameDischType =
         GetBufferValue("disch-type",
                        "where disch-type = " + STRING(tt-loan-cond.disch-type),
                        "name")
      mPartition = GetXattrEx(iClass,"Partition","Initial") /* Раздел печати */
      rid-t      = Rowid2Recid("loan-cond",tt-loan-cond.local__rowid)
                       WHEN (iMode = {&MOD_EDIT} OR
                             iMode = {&MOD_VIEW}) AND
                            tt-loan-cond.local__rowid <> ?
      rid-p      = Rowid2Recid("loan",tt-loan.local__rowid)
                       WHEN iMode = {&MOD_EDIT} OR
                            iMode = {&MOD_VIEW}
   .

   /* Берем с верхнего договора форму расчета */
   IF     tt-loan.class-code EQ "loan-tran-lin-ann"
      AND AVAIL tt-instance THEN
   DO:
      FIND LAST loan-cond WHERE loan-cond.contract  EQ tt-instance.contract
                            AND loan-cond.cont-code EQ tt-instance.cont-code
      NO-LOCK NO-ERROR.
      IF AVAIL loan-cond THEN
         tt-loan-cond.disch-type = loan-cond.disch-type.
   END.

   /* Заполняем COMBO-BOX'ы данными из метасхемы */
   RUN FillComboBox(FRAME {&MAIN-FRAME}:HANDLE).

   /* Commented by KSV: Показываем экранную форму */
   STATUS DEFAULT "".
   RUN enable_UI.

   /* Commented by KSV: Открываем те поля, которые разрешено изменять
   ** в зависимости от режима открытия */
   RUN EnableDisable.
   /* Commented by KSV: Рисуем разделители. Разделители задаются как FILL-IN
   ** с идентификатором SEPARATOR# с атрибутом VIES-AS TEXT */
   RUN Separator(FRAME fMain:HANDLE,"1").

   IF NOT THIS-PROCEDURE:PERSISTENT THEN
      WAIT-FOR CLOSE OF THIS-PROCEDURE FOCUS mFirstTabItem.
END.

/* Commented by KSV: Закрываем службу системных сообщений */
RUN End-SysMes.

RUN disable_ui.

/* Commented by KSV: Удаляем экземпляр объекта */
IF VALID-HANDLE(mInstance) AND NOT mOnlyForm THEN
   RUN DelEmptyInstance(mInstance).

/* Commented by KSV: Выгружаем библиотеки */
{intrface.del}

/*mitr: выгрухка инструмента ln-init-rate */
PUBLISH 'done'.

/* Commented by KSV: Возвращаем значение вызывающей процедуре */
RETURN mRetVal.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CheckAutoTermDistrTT TERMINAL-SIMULATION
PROCEDURE CheckAutoTermDistrTT :
/*------------------------------------------------------------------------------
  Purpose: Проверка возможности автоматической разноски платежей по траншам
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   DEF INPUT  PARAM iContract AS CHAR   NO-UNDO.   /* Назначение договора */
   DEF INPUT  PARAM iContCode AS CHAR   NO-UNDO.   /* Номер договора */
   DEF OUTPUT PARAM oCheckOk  AS LOG    NO-UNDO.   /* Результат */


   DEF BUFFER b-loan          FOR loan.            /* Соглашение */
   DEF BUFFER b-loan-cond     FOR loan-cond.       /* Условие соглашения */
   DEF BUFFER b-term-obl      FOR term-obl.        /* Обязательства соглашения */

   oCheckOk = TRUE.
      /* Позиционируемся на соглашении */
   FIND FIRST b-loan WHERE
              b-loan.contract  EQ iContract
      AND     b-loan.cont-code EQ ENTRY(1, iContCode, " ")
   NO-LOCK NO-ERROR.
   IF AVAIL b-loan THEN
   DO:
         /* Проверка осуществляется только при автоматической разноске графика (ДР "СводГрАвто" = "Да") */
      IF GetXAttrValue("loan", b-loan.contract + "," + b-loan.cont-code, "СводГрАвто") EQ "Да" THEN
      DO:
         bkl:
         DO:
               /* Ищем действующее условие соглашения */
            FIND LAST b-loan-cond WHERE
                      b-loan-cond.contract  EQ b-loan.contract
               AND    b-loan-cond.cont-code EQ b-loan.cont-code
               AND    b-loan-cond.since     LE b-loan.end-date
            NO-LOCK NO-ERROR.
            IF AVAIL b-loan-cond THEN
            DO:
                  /* Не Конец срока */
               IF tt-loan-cond.cred-period:SCREEN-VALUE IN FRAME {&frame-name} NE "Кс" THEN
               DO:
                     /* 1. Проверка совпадения параметров периодичности */
                  IF    b-loan-cond.cred-period NE     tt-loan-cond.cred-period:SCREEN-VALUE IN FRAME {&frame-name}
                     OR b-loan-cond.cred-date   NE INT64(tt-loan-cond.cred-date:SCREEN-VALUE   IN FRAME {&frame-name})
                     OR b-loan-cond.cred-month  NE INT64(tt-loan-cond.cred-month:SCREEN-VALUE  IN FRAME {&frame-name})
                  THEN DO:
                     pick-value = "2".        /* Предустановка меню: "2" - Нет */
                     RUN Fill-SysMes IN h_tmess ("", "", "3",
                                                 "Не совпадают параметры даты погашения ОД на соглашении и транше.~n" +
                                                 "Автоматическая разноска невозможна.~n" +
                                                 "Продолжить?:|Да,Нет").
                     oCheckOk = IF pick-value EQ "1"
                                   THEN TRUE
                                   ELSE FALSE.
                     IF NOT oCheckOk THEN
                        LEAVE bkl.
                  END.
               END.
                  /* Конец срока */
               ELSE IF tt-loan-cond.cred-period:SCREEN-VALUE IN FRAME {&frame-name} EQ "Кс" THEN
               DO:
                     /* Ищем в графике соглашения проверяется наличие записи на дату окончания срока транша */
                  FIND FIRST b-term-obl WHERE
                             b-term-obl.contract     EQ b-loan.contract    /* Данные */
                     AND     b-term-obl.cont-code    EQ b-loan.cont-code   /* соглашения */
                     AND     b-term-obl.idnt         EQ 3
                     AND     b-term-obl.end-date     EQ DATE(tt-loan.end-date:SCREEN-VALUE IN FRAME {&frame-name})      /* Окончание транша */
                  NO-LOCK NO-ERROR.
                     /* Не найдено - ругаемся и выходим */
                  IF NOT AVAIL b-term-obl THEN
                  DO:
                     oCheckOk = FALSE.
                     RUN Fill-SysMes IN h_tmess ("", "", "1",
                                                 "В графике соглашения нет записи на дату окончания транша <" +
                                                 (tt-loan.end-date:SCREEN-VALUE IN FRAME {&frame-name}) + ">.").
                     LEAVE bkl.
                  END.
               END.
            END.
            ELSE
            DO:
               oCheckOk = FALSE.
               RUN Fill-SysMes IN h_tmess ("", "", "1",
                                           "Не найдено действующее условие").
               LEAVE bkl.
            END.
         END.
      END.
   END.
END PROCEDURE. /* CheckAutoTermDistrTT */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreLoanStream TERMINAL-SIMULATION
PROCEDURE CreLoanStream :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER iCommRateId AS INT64    NO-UNDO.

   DEFINE BUFFER b-loan FOR tt-loan.
      FIND FIRST b-loan WHERE b-loan.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-loan THEN DELETE b-loan.
   DEFINE BUFFER b-loan-cond FOR tt-loan-cond.
      FIND FIRST b-loan-cond WHERE b-loan-cond.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-loan-cond THEN DELETE b-loan-cond.
   DEFINE BUFFER b-amount FOR tt-amount.
      FIND FIRST b-amount WHERE b-amount.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-amount THEN DELETE b-amount.
   DEFINE BUFFER b-percent FOR tt-percent.
      FIND FIRST b-percent WHERE b-percent.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-percent THEN DELETE b-percent.
   DEFINE BUFFER b-loan-acct-main FOR tt-loan-acct-main.
      FIND FIRST b-loan-acct-main WHERE b-loan-acct-main.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-loan-acct-main THEN DELETE b-loan-acct-main.
   DEFINE BUFFER b-loan-acct-cust FOR tt-loan-acct-cust.
      FIND FIRST b-loan-acct-cust WHERE b-loan-acct-cust.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-loan-acct-cust THEN DELETE b-loan-acct-cust.
   DEFINE BUFFER b-contragent FOR tt-contragent.
      FIND FIRST b-contragent WHERE b-contragent.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-contragent THEN DELETE b-contragent.
   DEFINE BUFFER b-dealer FOR tt-dealer.
      FIND FIRST b-dealer WHERE b-dealer.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-dealer THEN DELETE b-dealer.
   DEFINE BUFFER b-broker FOR tt-broker.
      FIND FIRST b-broker WHERE b-broker.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-broker THEN DELETE b-broker.
   DEFINE BUFFER b-comm-rate FOR tt-comm-rate.
      FOR EACH b-comm-rate WHERE b-comm-rate.local__UpID EQ 1:
         DELETE b-comm-rate.
      END.

   FIND FIRST tt-loan WHERE tt-loan.local__UpId EQ 0 NO-ERROR.
   FIND FIRST tt-contragent WHERE tt-contragent.local__UpId EQ 0 NO-ERROR.
   FIND FIRST tt-dealer WHERE tt-dealer.local__UpId EQ 0 NO-ERROR.
   FIND FIRST tt-broker WHERE tt-broker.local__UpId EQ 0 NO-ERROR.
   FIND LAST tt-loan-cond WHERE tt-loan-cond.local__UpId EQ 0 NO-ERROR.
   FIND LAST tt-amount WHERE tt-amount.local__UpId EQ 0 NO-ERROR.
   FIND LAST tt-percent WHERE tt-percent.local__UpId EQ 0 NO-ERROR.
   FIND LAST tt-loan-acct-main WHERE tt-loan-acct-main.local__UpId EQ 0 NO-ERROR.
   FIND LAST tt-loan-acct-cust WHERE tt-loan-acct-cust.local__UpId EQ 0 NO-ERROR.

   IF NOT AVAIL tt-loan THEN
      RETURN ERROR "Отсутствует LOAN".

   CREATE b-loan.
   CREATE tmp-loan. /*чтоб не копировать доп.реки */
   BUFFER-COPY tt-loan  EXCEPT cont-code doc-ref alt-contract TO tmp-loan.
   BUFFER-COPY tmp-loan EXCEPT cont-code doc-ref alt-contract TO b-loan.
   DELETE tmp-loan.
   ASSIGN
      tt-loan.cont-type   = "Течение"
      b-loan.cont-type    = tt-loan.cont-type:SCREEN-VALUE IN FRAME {&MAIN-FRAME}
      b-loan.cont-code    = tt-loan.cont-code + " 1"
      b-loan.Local__Id    = 1
      b-loan.alt-contract = IF tt-loan.alt-contract EQ "mm" THEN "mmap"
                                                            ELSE tt-loan.alt-contract
   .
      b-loan.class-code = GetXattrEx(iClass,"amt-part","Domain-Code").
      b-loan.doc-ref    = IF ShMode THEN DelFilFromLoan(b-loan.cont-code)
                                    ELSE b-loan.cont-code.

   CREATE b-loan-cond.
   BUFFER-COPY tt-loan-cond EXCEPT cont-code local__id local__upid
      TO b-loan-cond.
   ASSIGN
      b-loan-cond.cont-code = b-loan.cont-code
      b-loan-cond.Local__UpId = 1
      b-loan-cond.Local__Id = 1.

   IF tt-amount.amt-rub NE 0 THEN
   DO:
      CREATE b-amount.
      BUFFER-COPY tt-amount EXCEPT cont-code local__id local__upid
         TO b-amount.
      ASSIGN
         b-amount.cont-code = b-loan.cont-code
         b-amount.Local__UpId = 1
         b-amount.Local__Id = 1.
   END.
   FIND FIRST tt-term-obl.
   ASSIGN
      tt-term-obl.idnt = 3
      tt-term-obl.fop-date = tt-loan.open-date
      tt-term-obl.end-date = tt-loan.end-date
      tt-term-obl.amt-rub = b-amount.amt-rub
      tt-term-obl.Local__UpId = 1.

   IF {assigned tt-loan-acct-main.acct} THEN
   DO:
      IF shMode THEN
      DO: /* tt-loan-acct-main.acct может быть без @ */
         FIND FIRST acct WHERE acct.filial-id EQ tt-loan.filial-id
                           AND acct.number    EQ ENTRY(1, tt-loan-acct-main.acct, "@")
                           AND acct.currency  EQ tt-loan-acct-main.currency
            NO-LOCK NO-ERROR.
         IF AVAIL acct THEN
         DO:
            IF tt-loan-acct-main.acct NE acct.acct THEN
               tt-loan-acct-main.acct = acct.acct.
         END.
      END.
      CREATE b-loan-acct-main.
      BUFFER-COPY tt-loan-acct-main EXCEPT cont-code local__id local__upid
         TO b-loan-acct-main.
      ASSIGN
         b-loan-acct-main.cont-code = b-loan.cont-code
         b-loan-acct-main.Local__UpId = 1
         b-loan-acct-main.Local__Id = 1.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI TERMINAL-SIMULATION  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  RUN DeleteOldDataProtocol IN h_base ("ОкруглениеДоРублей").
  /* Hide all frames. */
  HIDE FRAME fMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI TERMINAL-SIMULATION  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  separator-3:VISIBLE IN FRAME {&MAIN-FRAME} = NO. /*  */
  DISPLAY mBranchName CustName1 mNameCredPeriod cred-offset_ delay-offset_
          mNameIntPeriod int-offset_ delay-offset-int_ mBag mSvod mLimit
          mNameDischType mLimitRest mGrRiska mRisk CustName2 CustName3
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-amount THEN
    DISPLAY tt-amount.amt-rub
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-broker THEN
    DISPLAY tt-broker.cust-cat tt-broker.cust-id
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-dealer THEN
    DISPLAY tt-dealer.cust-cat tt-dealer.cust-id
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-loan THEN
    DISPLAY tt-loan.branch-id tt-loan.datasogl$ tt-loan.cust-cat tt-loan.cust-id
          tt-loan.doc-num tt-loan.doc-ref tt-loan.cont-type tt-loan.DTType
          tt-loan.DTKind tt-loan.currency tt-loan.open-date tt-loan.sum-depos tt-loan-cond.PartAmount tt-loan-cond.FirstPeriod tt-loan.end-date
          tt-loan.ovrstop$ tt-loan.ovrstopr$ tt-loan.ovrpr$ tt-loan.tranwspertip$ tt-loan.rewzim$ tt-loan.user-id
          tt-loan.loan-status tt-loan.close-date tt-loan.trade-sys
          tt-loan.comment tt-loan.prodkod$
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-loan-acct-cust THEN
    DISPLAY tt-loan-acct-cust.acct
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-loan-acct-main THEN
    DISPLAY tt-loan-acct-main.acct
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-loan-cond THEN
    DISPLAY tt-loan-cond.NDays tt-loan-cond.NMonthes tt-loan-cond.NYears
          tt-loan-cond.cred-period tt-loan-cond.cred-date
          tt-loan-cond.cred-month tt-loan-cond.cred-offset
          tt-loan-cond.kollw#gtper$ tt-loan-cond.cred-mode
          tt-loan-cond.cred-work-calend tt-loan-cond.cred-curr-next
          tt-loan-cond.delay1 tt-loan-cond.DateDelay tt-loan-cond.delay-offset
          tt-loan-cond.kredplat$ tt-loan-cond.annuitplat$
          tt-loan-cond.int-period tt-loan-cond.int-date tt-loan-cond.int-month
          tt-loan-cond.int-offset tt-loan-cond.kollw#gtperprc$
          tt-loan-cond.int-mode tt-loan-cond.int-work-calend
          tt-loan-cond.int-curr-next tt-loan-cond.delay
          tt-loan-cond.DateDelayInt tt-loan-cond.delay-offset-int
          tt-loan-cond.isklmes$ tt-loan-cond.disch-type tt-loan-cond.annuitkorr$
          tt-loan-cond.grperiod$
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-percent THEN
    DISPLAY tt-percent.amt-rub
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  ENABLE tt-loan-cond.NDays tt-loan-cond.NMonthes tt-loan-cond.NYears
         tt-loan-cond.cred-month tt-loan-cond.cred-offset cred-offset_
         tt-loan-cond.cred-mode tt-loan-cond.cred-work-calend
         tt-loan-cond.cred-curr-next tt-loan-cond.DateDelay
         tt-loan-cond.delay-offset delay-offset_ tt-loan-cond.kredplat$
         tt-loan-cond.int-month tt-loan-cond.int-offset int-offset_
         tt-loan-cond.kollw#gtperprc$ tt-loan-cond.int-work-calend
         tt-loan-cond.int-curr-next tt-loan-cond.DateDelayInt
         tt-loan-cond.delay-offset-int delay-offset-int_ tt-loan-cond.isklmes$
         mBag mSvod mLimit mLimitRest tt-loan-cond.grperiod$
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW TERMINAL-SIMULATION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetTermObl TERMINAL-SIMULATION
PROCEDURE GetTermObl :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    FOR EACH ttTermObl:
        DELETE ttTermObl.
    END.

/* Заполняем временную таблицу - месяцы для исключения и с особым режимом */
   FOR EACH term-obl WHERE
            term-obl.contract = tt-loan.contract
        AND term-obl.cont-code = tt-loan.cont-code
        AND term-obl.idnt >= 200
        AND term-obl.idnt <= 201
        AND term-obl.end-date = IF iMode = {&MOD_ADD}
                                   THEN tt-loan.open-date
                                   ELSE tt-loan-cond.since
       NO-LOCK:

       BUFFER-COPY term-obl TO ttTermObl.

       RELEASE ttTermObl.

   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LocalEnableDisable TERMINAL-SIMULATION
PROCEDURE LocalEnableDisable :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE BUFFER b-percent     FOR tt-percent.
DEFINE BUFFER xtt-comm-rate FOR tt-comm-rate.
DEFINE BUFFER bloan         FOR loan.
DEFINE BUFFER loan-cond     FOR loan-cond.

DEFINE VARIABLE vNextStream AS INT64    NO-UNDO.
DEFINE VARIABLE vPercent    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE vCount      AS INT64    NO-UNDO.
DEFINE VARIABLE vNum        AS CHARACTER  NO-UNDO. /* Автосгенерированный № дог. */
DEFINE VARIABLE vMeasure    AS CHARACTER  NO-UNDO. /* Затычка для get-one-limit */
DEFINE VARIABLE vOperSumm   AS DECIMAL    NO-UNDO. /* Значение лимита */
DEFINE VARIABLE hTrade-Sys  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hComment    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTSLabel    AS HANDLE     NO-UNDO.
DEFINE VARIABLE oAutoCodeNeed AS LOGICAL NO-UNDO . /* Нужно ли для формирования номера что-то запустить*/

   IF     mNewEndDate NE ?
      AND GetFstWrkDay(tt-loan.Class-Code, tt-loan.user-id, mNewEndDate, 9, 1) NE mNewEndDate 
   THEN
      mNewEndDate = ?.
   IF mNewEndDate NE ? 
   THEN DO:
      tt-loan.end-date:SCREEN-VALUE IN FRAME {&MAIN-FRAME} = STRING (mNewEndDate,"99/99/9999").
      mSrokChange = YES.
   END.

   DISPLAY mTxtPercent WITH FRAME {&MAIN-FRAME} .

   IF tt-loan.contract = "Депоз" THEN
      ASSIGN
         mGrRiska    :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         mRisk       :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         mBag        :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
      .
   
   IF  tt-loan.class-code NE "loan_dbl_ann" AND
       (   FGetSetting("РасчСумОб","АннуитОбесп","?") NE "Да"
        OR tt-loan.class-code NE "loan_mortgage")  THEN
      tt-loan.sum-depos:VISIBLE IN FRAME {&MAIN-FRAME} = FALSE.

   IF  tt-loan.class-code NE "loan_dbl_ann" THEN
       ASSIGN
           tt-loan-cond.PartAmount:VISIBLE   IN FRAME {&MAIN-FRAME} = FALSE
           tt-loan-cond.FirstPeriod:VISIBLE IN FRAME {&MAIN-FRAME} = FALSE.
   
   IF tt-loan.contract = "Депоз" AND FGetSetting("СкрПол", "", ?) EQ "ДА" THEN
      ASSIGN
         mHiddenField                   :VISIBLE IN FRAME {&MAIN-FRAME} = TRUE
         tt-loan-cond.cred-period       :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         mNameCredPeriod                :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.cred-date         :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.cred-month        :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.cred-offset       :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         cred-offset_                   :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.kollw#gtper$      :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.cred-mode         :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.cred-work-calend  :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.cred-curr-next    :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.delay1            :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.DateDelay         :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.delay-offset      :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         delay-offset_                  :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.kredplat$         :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.int-mode          :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.int-work-calend   :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.int-curr-next     :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.delay             :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.DateDelayInt      :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.delay-offset-int  :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         delay-offset-int_              :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.isklmes$          :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan.rewzim$                :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
      .
   ELSE
      mHiddenField:VISIBLE IN FRAME {&MAIN-FRAME} = FALSE.
      /* Формирование номера течения */
   IF AVAIL tt-instance AND iMode EQ {&MOD_ADD} THEN
   DO:
      vNextStream = INT64(ENTRY(2,
         GetBuffersValue(
            "loan",
            "FOR EACH loan WHERE
                 loan.contract EQ '" + tt-instance.contract + "' AND
                 loan.cont-code BEGINS '" + tt-instance.cont-code + " ' AND
                 NUM-ENTRIES(loan.cont-code,' ') EQ 2 NO-LOCK BY INT64(ENTRY(2,loan.cont-code,' ')) DESC",
            "loan.cont-code"),
         " ")) NO-ERROR.

      vNextStream = IF vNextStream EQ ? THEN 1 ELSE vNextStream + 1.
      tt-loan.doc-ref   = ENTRY(1,tt-instance.doc-ref," ") + " " + STRING(vNextStream).
      IF ShMode THEN
         tt-loan.cont-code = addFilToLoan(tt-loan.doc-ref,ShFilial).
      ELSE
         tt-loan.cont-code = tt-loan.doc-ref.

      tt-loan.doc-ref:SCREEN-VALUE IN FRAME {&MAIN-FRAME} = tt-loan.doc-ref.
      IF tt-loan.cust-cat:VISIBLE THEN ASSIGN
         tt-loan.cust-cat:SCREEN-VALUE = tt-instance.cust-cat.
      IF tt-loan.cust-id:VISIBLE THEN ASSIGN
         tt-loan.cust-id:SCREEN-VALUE = STRING(tt-instance.cust-id).
      APPLY "leave" TO tt-loan.cust-id.
      RUN BT_HiddOrDisableField(tt-loan.doc-ref:HANDLE,NO,YES).
      RUN BT_HiddOrDisableField(tt-loan.cust-cat:HANDLE,NO,YES).
      RUN BT_HiddOrDisableField(tt-loan.cust-id:HANDLE,NO,YES).
      tt-loan.cont-type:SCREEN-VALUE = GetxAttrValueEx("loan",
                                                       tt-instance.contract + "," + tt-instance.cont-code,
                                                       "ТипДогСогл",
                                                       "").
      IF tt-loan.cont-type:SCREEN-VALUE NE "" THEN
         RUN BT_HiddOrDisableField(tt-loan.cont-type:HANDLE,NO,YES).
      ASSIGN
         tt-loan.currency:SCREEN-VALUE = tt-instance.currency
         tt-loan.currency:SENSITIVE = NO
      .
   END.

      /* Если договор не транш договора типа "Течение",
      ** то запускаем алгоритм формирования № договора */

   IF     NOT AVAIL tt-instance
      AND iMode EQ {&MOD_ADD} THEN
   DO:
      /* Нужен ли тип договора для генерации автокода ?*/
      RUN AutoCodeNeed IN h_loan (tt-loan.Class-Code,"t" , OUTPUT oAutoCodeNeed) .
      IF oAutoCodeNeed AND
         tt-loan.cont-type:SCREEN-VALUE = ""
      THEN
        APPLY "F1" TO tt-loan.cont-type. /* Если нужен - зададим его */

      RUN GetNumLoan IN h_loan (tt-loan.Class-Code,
                                tt-loan.open-date,
                                SUBSTITUTE("&1|&2|&3|&4|&5" ,
                                             tt-loan.branch-id ,
                                             "","","" ,
                                             tt-loan.cont-type:SCREEN-VALUE ) , /* Код филиала    и все необходимые теги  */
                                NO,
                                OUTPUT vNum,
                                OUTPUT mCounterVal).
      tt-loan.doc-ref = vNum.
      ASSIGN
         tt-loan.cont-code = IF ShMode THEN addFilToLoan(vNum, ShFilial)
                                       ELSE vNum
         tt-loan.doc-ref:SCREEN-VALUE IN FRAME {&MAIN-FRAME} = vNum
      .
   END.


   IF mBrowseCommRateOFF THEN
   DO:
      RUN BT_HiddAndDisableField(tt-percent.amt-rub:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.int-period:HANDLE).
      RUN BT_HiddAndDisableField(mNameIntPeriod:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.int-date:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.delay:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.int-offset:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.disch-type:HANDLE).
      RUN BT_HiddAndDisableField(mNameDischType:HANDLE).
      RUN BT_HiddAndDisableField(int-offset_:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.kollw#gtperprc$:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.int-mode:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.int-work-calend:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.DateDelayInt:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.int-curr-next:HANDLE).
      RUN BT_HiddAndDisableField(delay-offset-int_:HANDLE).
      RUN BT_HiddAndDisableField(tt-comm-cond.floattype:HANDLE IN BROWSE br-comm).
      IF br-comm:VISIBLE IN FRAME {&MAIN-FRAME} THEN
      DO:
         DISABLE br-comm WITH FRAME {&MAIN-FRAME}.
         br-comm:VISIBLE IN FRAME {&MAIN-FRAME} = NO.
         separator-2:VISIBLE IN FRAME {&MAIN-FRAME} = NO.
         RUN BT_UpForm(separator-3:HANDLE,3).
            /* TOGGLE-BOXы потом не перерисрвываются, поэтому рисуем здесь */
         IF tt-loan-cond.isklmes$:VISIBLE IN FRAME {&MAIN-FRAME} THEN
         DO:
            tt-loan-cond.isklmes$:VISIBLE IN FRAME {&MAIN-FRAME} = NO.
            tt-loan-cond.isklmes$:VISIBLE IN FRAME {&MAIN-FRAME} = YES.
         END.
         FRAME {&MAIN-FRAME}:HEIGHT = FRAME {&MAIN-FRAME}:HEIGHT - 3.
         RUN PutHelp("",FRAME {&MAIN-FRAME}:HANDLE).
      END.
   END.
   ELSE
   DO:
      ENABLE br-comm WITH FRAME {&MAIN-FRAME}.
      IF iMode EQ {&MOD_ADD} THEN
      DO:
         tt-comm-rate.commission:READ-ONLY IN BROWSE br-comm = NO.
         tt-comm-rate.rate-comm:READ-ONLY IN BROWSE br-comm = NO.
         tt-comm-cond.floattype:READ-ONLY IN BROWSE br-comm = YES.
      END.
      ELSE
         RUN ReadOnly(FRAME {&MAIN-FRAME}:HANDLE,"br-comm","br-comm",YES).
      /* Вынести в библиотеку */
      FOR EACH term-obl OF tt-loan WHERE term-obl.idnt EQ 1 NO-LOCK:
         ACCUMULATE
            term-obl.amt-rub (TOTAL)
            term-obl.amt-rub (COUNT).
      END.
      vPercent = (ACCUM TOTAL term-obl.amt-rub).
      vCount = (ACCUM COUNT term-obl.amt-rub).
      IF vCount GT 1 AND tt-percent.amt-rub:VISIBLE THEN
      DO:
         DISP vPercent @ tt-percent.amt-rub
            WITH FRAME {&MAIN-FRAME}.
         DISABLE tt-percent.amt-rub WITH FRAME {&MAIN-FRAME}.
      END.
   END.
      /* для классов loan-repo-bm,loan-repo-lm
   ** нужно поле tt-loan.trade-sys, а оно закрыто полем tt-loan.comment */
   IF CAN-DO("loan-repo-bm,loan-repo-lm", tt-loan.Class-code)
      AND tt-loan.trade-sys:VISIBLE
      AND tt-loan.comment:VISIBLE THEN
   DO:
      hTrade-Sys = tt-loan.trade-sys:HANDLE.
      hComment   = tt-loan.comment:HANDLE.
      hTSLabel   = hTrade-Sys:SIDE-LABEL-HANDLE.

      IF     hTrade-Sys:ROW EQ hComment:ROW
         AND hTrade-Sys:COL + hTrade-Sys:WIDTH GE hComment:COL THEN
      DO:
        /* сдвинем поле tt-loan.comment вправо, на сколько нужно,
        ** чтобы tt-loan.trade-sys было видно */
         hComment:INNER-CHARS = hComment:INNER-CHARS - 
                               (hTrade-Sys:WIDTH + hTSLabel:WIDTH + 2).
         hComment:COL = (hTrade-Sys:COL + hTrade-Sys:WIDTH + 1). 
      END. 
   END.
   IF tt-loan-acct-main.acct:VISIBLE AND
      GetXattrEx(iClass,"loan-acct-main","xattr-label") NE "" THEN
      tt-loan-acct-main.acct:LABEL =
         GetXattrEx(iClass,"loan-acct-main","xattr-label").
   IF tt-loan-acct-cust.acct:VISIBLE AND
      GetXattrEx(iClass,"loan-acct-cust","xattr-label") NE "" THEN
      tt-loan-acct-cust.acct:LABEL =
         GetXattrEx(iClass,"loan-acct-cust","xattr-label").
   IF iMode = {&MOD_ADD}                      AND
      NOT IsEmpty  (tt-loan.parent-cont-code) THEN
   DO:
      DISABLE tt-loan.cust-cat tt-loan.cust-id WITH FRAME fMain.
   END.
   IF tt-loan.alt-contract EQ "mm" THEN
   DO:
      IF iMode NE {&MOD_ADD} THEN
         tt-loan.cont-type:SCREEN-VALUE = MM_GetContTypeStreem(tt-loan.contract,tt-loan.cont-code).
      tt-loan.doc-ref:VISIBLE = NO.
      IF tt-loan.doc-num:VISIBLE THEN ASSIGN
         tt-loan.doc-num:LABEL =
            tt-loan.doc-num:HANDLE:SIDE-LABEL-HANDLE:SCREEN-VALUE
         tt-loan.doc-num:SCREEN-VALUE = tt-loan.doc-num.
   END.
   ELSE
   DO:
      tt-loan.doc-num:VISIBLE = NO.
      IF tt-loan.doc-ref:VISIBLE THEN ASSIGN
         tt-loan.doc-ref:LABEL =
            tt-loan.doc-ref:HANDLE:SIDE-LABEL-HANDLE:SCREEN-VALUE
         tt-loan.doc-ref:SCREEN-VALUE = tt-loan.doc-ref.
   END.
   IF iMode = {&MOD_ADD} THEN
   DO:
      tt-loan-cond.annuitkorr$:SCREEN-VALUE =
         GetXAttrInit(tt-loan-cond.class-code,
                      "АннуитКорр").
      IF tt-loan-cond.annuitkorr$:SCREEN-VALUE = "" THEN
         tt-loan-cond.annuitkorr$:SCREEN-VALUE = ?.
   END.
   ELSE
      IF GetXAttrValueEx("loan-cond",
                         tt-loan-cond.contract + "," + tt-loan-cond.cont-code + "," + STRING(tt-loan-cond.since),
                         "АннуитКорр",
                         "") EQ "" THEN
         tt-loan-cond.annuitkorr$:SCREEN-VALUE = ?.
   IF tt-loan-cond.shemaplat$ THEN
   DO:
      IF iMode = {&MOD_ADD} THEN
      DO:
         /* Установим округление, если оно есть */
         IF GetXattrInit(tt-loan.class-code,"ОкругДоРуб") EQ "Да" THEN
            RUN SetSysConf IN h_base ("ОкруглениеДоРублей","YES"). 

         FIND FIRST xtt-comm-rate WHERE
                    xtt-comm-rate.commission = "%Кред"
         NO-ERROR.

         IF AVAIL xtt-comm-rate THEN
            RUN CalcAnnuitet(
                          tt-loan.contract,
                          tt-loan.cont-code,
                          DATE(tt-loan.open-date:SCREEN-VALUE),
                          DATE(tt-loan.end-date:SCREEN-VALUE),
                          tt-amount.amt-rub,
                          xtt-comm-rate.rate-comm,
                          INT64(tt-loan-cond.cred-date:SCREEN-VALUE),
                          tt-loan-cond.cred-period:SCREEN-VALUE,
                          tt-loan-cond.cred-month:SCREEN-VALUE,
                          INT64(tt-loan-cond.kollw#gtper$:SCREEN-VALUE),
                          LOOKUP(tt-loan-cond.cred-offset:SCREEN-VALUE,tt-loan-cond.cred-offset:LIST-ITEMS),
                          INT64(tt-loan-cond.annuitkorr$:SCREEN-VALUE),
                          DEC(tt-loan.sum-depos:SCREEN-VALUE),
                          INT64(tt-loan-cond.FirstPeriod:SCREEN-VALUE),
                          DEC(tt-loan-cond.PartAmount:SCREEN-VALUE),
                          OUTPUT tt-loan-cond.annuitplat$).
         IF    tt-loan.class-code EQ "loan-transh-ann"
            OR tt-loan.class-code EQ "loan-transh-lin-ann" THEN
            tt-loan-cond.annuitplat$ = ?.
         tt-loan-cond.annuitplat$:SCREEN-VALUE = STRING(tt-loan-cond.annuitplat$).
      END.
   END.
   ELSE
      tt-loan-cond.annuitkorr$:VISIBLE = NO.

   IF tt-loan-cond.isklmes$:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "yes"
      THEN DO:
      RUN GetTermObl.
   END.

   IF FGetSetting("Закрытие","","?") EQ "нет" THEN
      tt-loan.close-date:SENSITIVE = NO.

   /* изменяем видимые поля в зависимости от значения cred-mode (Плат. период - осн.долг) */
   CASE tt-loan-cond.cred-mode:SCREEN-VALUE:
      WHEN "КоличДней" THEN
         ASSIGN
            tt-loan-cond.DateDelay        :VISIBLE = NO
            tt-loan-cond.cred-curr-next   :VISIBLE = NO
         .
      WHEN "ДатаОконч" THEN
         ASSIGN
            tt-loan-cond.delay1           :VISIBLE = NO
            tt-loan-cond.cred-work-calend :VISIBLE = NO
         .
      WHEN "ПериодДн" THEN
         ASSIGN
            tt-loan-cond.DateDelay        :VISIBLE = NO
            tt-loan-cond.cred-curr-next   :VISIBLE = NO
            tt-loan-cond.cred-work-calend :VISIBLE = NO
         .
   END CASE.
   /* изменяем видимые поля в зависимости от значения int-mode (Плат. период - проценты) */
   IF tt-loan-cond.int-mode:SCREEN-VALUE  EQ "КоличДней"
   THEN ASSIGN tt-loan-cond.DateDelayint     :VISIBLE = NO
               tt-loan-cond.int-curr-next    :VISIBLE = NO.
   ELSE ASSIGN tt-loan-cond.delay            :VISIBLE = NO
               tt-loan-cond.int-work-calend  :VISIBLE = NO.
   ASSIGN
      cred-offset_            :SCREEN-VALUE  =  IF NOT {assigned tt-loan-cond.cred-offset}
                                       THEN mOffsetNone
                                       ELSE tt-loan-cond.cred-offset:SCREEN-VALUE
      int-offset_             :SCREEN-VALUE  =  IF NOT {assigned  tt-loan-cond.int-offset}
                                       THEN mOffsetNone
                                       ELSE tt-loan-cond.int-offset:SCREEN-VALUE
      delay-offset_           :SCREEN-VALUE  =  IF NOT {assigned  tt-loan-cond.delay-offset}
                                       THEN mOffsetNone
                                       ELSE tt-loan-cond.delay-offset:SCREEN-VALUE
      delay-offset-int_       :SCREEN-VALUE  =  IF NOT {assigned  tt-loan-cond.delay-offset-int}
                                       THEN mOffsetNone
                                       ELSE tt-loan-cond.delay-offset-int:SCREEN-VALUE
      cred-offset_            :READ-ONLY     = YES
      int-offset_             :READ-ONLY     = YES
      delay-offset_           :READ-ONLY     = YES
      delay-offset-int_       :READ-ONLY     = YES
      tt-loan-cond.cred-offset     :VISIBLE       = NO
      tt-loan-cond.int-offset      :VISIBLE       = NO
      tt-loan-cond.delay-offset    :VISIBLE       = NO
      tt-loan-cond.delay-offset-int:VISIBLE       = NO.
   IF iMode NE {&MOD_ADD}
   THEN
      ASSIGN
         cred-offset_          :SENSITIVE = NO
         int-offset_           :SENSITIVE = NO
         delay-offset_         :SENSITIVE = NO
         delay-offset-int_     :SENSITIVE = NO
      .
/* в спецверсиях Multi, Etb в этом месте стоит FGetSetting("ИспПрод","",?),
** нужно исправить на FGetSetting("Продукты","ИспПрод",?) */

   /* Если редактирование, то закрываем поля */
   IF iMode = {&MOD_EDIT} THEN
      ASSIGN
         tt-loan-cond.NDays   :SENSITIVE = NO
         tt-loan-cond.NMonthes:SENSITIVE = NO
         tt-loan-cond.NYears  :SENSITIVE = NO
      .
   IF work-module EQ "loan-fiz"
   THEN
      ASSIGN
         tt-loan.cust-cat :LIST-ITEMS   = "Ч"
         tt-loan.cust-cat :SCREEN-VALUE = "Ч"
         tt-loan.cust-cat :SENSITIVE    = NO
         tt-loan.cust-cat
      .
   ELSE IF work-module EQ "loan-jur"
   THEN
      ASSIGN
         tt-loan.cust-cat :LIST-ITEMS   = "Ю,Б"
         tt-loan.cust-cat :SCREEN-VALUE = "Ю"
         tt-loan.cust-cat
      .
&IF DEFINED(MANUAL-REMOTE) &THEN
   tt-loan.ovrstopr$ :LIST-ITEMS = "Д,М" . 
   IF tt-loan.ovrstopr$ NE ? THEN tt-loan.ovrstopr$:SCREEN-VALUE = tt-loan.ovrstopr$ .
&ENDIF 

    /* Лимиты выдачи */
   IF   ( iMode EQ {&MOD_EDIT}
      OR  iMode EQ {&MOD_VIEW} )
     AND ( tt-loan.rewzim$:SCREEN-VALUE EQ "ЛимВыдЗад" OR
           tt-loan.rewzim$:SCREEN-VALUE EQ "НевозЛиния" )THEN
   DO:
      /* Получим установленный лимит */
      RUN get-one-limit ("loan",
                         tt-loan.contract + "," + tt-loan.cont-code,
                         "limit-l-distr",
                         tt-loan.since ,
                         "",
                         OUTPUT vMeasure,
                         OUTPUT mLimit).
      mLimit:SCREEN-VALUE = STRING(mLimit).

      /* Теперь просуммируем все операции выдачи, в т.ч. по траншам
      ** и вычтем их из лимита - получим оставшийся лимит */
      FOR EACH loan-int WHERE loan-int.contract  EQ tt-loan.contract
                          AND loan-int.cont-code EQ tt-loan.cont-code
                          AND loan-int.id-d      EQ 0
                          AND loan-int.id-k      EQ 3
                          AND loan-int.mdate     LE tt-loan.since
      NO-LOCK:
         vOperSumm = vOperSumm + loan-int.amt-rub.
      END.
      IF tt-loan.cont-type EQ "Течение" THEN
         FOR EACH loan-int WHERE loan-int.contract  EQ     tt-loan.contract
                             AND loan-int.cont-code BEGINS tt-loan.cont-code + " "
                             AND loan-int.id-d      EQ     0
                             AND loan-int.id-k      EQ     3
                             AND loan-int.mdate     LE     tt-loan.since
         NO-LOCK:
            vOperSumm = vOperSumm + loan-int.amt-rub.
         END.
      ASSIGN
         mLimitRest              = mLimit - vOperSumm
         mLimitRest:SCREEN-VALUE = STRING(mLimitRest).
   END.
   /* Лимит задолженности */
   IF   ( iMode EQ {&MOD_EDIT}
      OR  iMode EQ {&MOD_VIEW})
     AND tt-loan.rewzim$:SCREEN-VALUE EQ "ВозобнЛиния" THEN
   DO:
      /* Получим установленный лимит на дату состояния  */
      RUN get-one-limit-loan ("loan",
                              tt-loan.contract + "," + tt-loan.cont-code,
                              "limit-l-debts",
                              tt-loan.since ,
                              "",
                              OUTPUT vMeasure,
                              OUTPUT mLimit).

      /* Доступный лимит это параметр 19 - Неиспользованные заемные средства  */
      RUN STNDRT_PARAM (tt-loan.contract,
                        tt-loan.cont-code,
                        19,
                        tt-loan.since,
                        OUTPUT mLimitRest,
                        OUTPUT md1,
                        OUTPUT md2).

      ASSIGN
         mLimit:SCREEN-VALUE = STRING(mLimit)
         mLimitRest:SCREEN-VALUE = STRING(mLimitRest).
   END.



   IF NOT (   tt-loan.rewzim$:SCREEN-VALUE EQ "ЛимВыдЗад"
           OR tt-loan.rewzim$:SCREEN-VALUE EQ "ВозобнЛиния"
           OR tt-loan.rewzim$:SCREEN-VALUE EQ "НевозЛиния") THEN
      ASSIGN
         mLimit:VISIBLE IN FRAME fMain     = NO
         mLimitRest:VISIBLE IN FRAME fMain = NO
      .

   IF NOT tt-loan.svodform$ THEN
   DO:
      RUN BT_HiddAndDisableField(mSvod:HANDLE).
      separator-3:VISIBLE IN FRAME {&MAIN-FRAME} = YES.
   END.
   ELSE
      mSvodROnly =     iMode NE {&MOD_ADD}
                   AND CAN-FIND(FIRST bloan WHERE
                                      bloan.contract                    EQ     tt-loan.contract
                                  AND bloan.cont-code                   BEGINS tt-loan.cont-code + " "
                                  AND NUM-ENTRIES(bloan.cont-code, " ") GT 1
                                )
                   OR (   tt-loan.class-code EQ "loan-transh-ann"
                       OR tt-loan.class-code EQ "loan-tran-lin-ann")
      .

      /* показываем, если редактирование, или просмотр
      ** и установлен платежный период = ПериодДн */
   IF iMode NE {&MOD_ADD} AND tt-loan-cond.cred-mode EQ "ПериодДн" AND tt-loan-cond.shemaplat$ NE YES THEN
   DO:
         /* TOGGLE-BOXы потом не перерисрвываются, поэтому рисуем здесь */
      tt-loan-cond.grperiod$:VISIBLE IN FRAME {&MAIN-FRAME} = NO.
      tt-loan-cond.grperiod$:VISIBLE IN FRAME {&MAIN-FRAME} = YES.
   END.
   ELSE
      tt-loan-cond.grperiod$:VISIBLE = NO.
/*====*/
   ii = ii + 1 .
   IF ii LE 1 THEN DO:
      SetHelpStrAdd(mHelpStrAdd + "│F6-Период доступности средств").
      RUN PutHelp("",FRAME {&MAIN-FRAME}:HANDLE).
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LocalSetObject TERMINAL-SIMULATION
PROCEDURE LocalSetObject :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   DEFINE VARIABLE vRet   AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vRwd   AS ROWID      NO-UNDO.
   DEFINE VARIABLE vId    AS INT64      NO-UNDO.
   DEFINE VARIABLE vHs    AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vSum   AS DEC        NO-UNDO.
   DEFINE VARIABLE vHT    AS HANDLE     NO-UNDO.

   DEFINE VARIABLE vHRisk    AS HANDLE   NO-UNDO.
   DEFINE VARIABLE vHGrRiska AS HANDLE   NO-UNDO.
   DEFINE VARIABLE vCheckMon AS LOG      NO-UNDO.
   DEFINE VARIABLE vOk       AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE vFL       AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE VoKs      AS LOGICAL  NO-UNDO.

   DEF BUFFER xloan      FOR loan.
   DEF BUFFER xcomm-rate FOR comm-rate.

   /* Сумма по договору */
   mSummaDog = tt-amount.amt-rub.
   /* для того, чтобы сохранить из временной таблицы значения реквизитов,
   ** не объектами полями, нужно добавить их в список след. образом : */
   SetFormDefList(GetFormDefList() +
                  ",tt-loan-cond.cred-offset,tt-loan-cond.int-offset" +
                  ",tt-loan-cond.delay-offset,tt-loan-cond.delay-offset-int" +
                  ",tt-loan.AgrCounter,tt-loan.UniformBag,tt-loan.prodkod$,tt-loan-cond.prodtrf$" +
                  ",tt-loan.svodgrafik$,tt-loan.svodskonca$,tt-loan.svodgravto$,tt-loan.svodspostr$" +
                  ",tt-loan.LimitGrafDate,tt-loan-cond.grdatas$,tt-loan-cond.grdatapo$").
      /* Проверка ДатаПо лимитов */
      IF tt-loan.rewzim$ NE ? AND
         tt-loan.rewzim$ NE ""  AND
         tt-loan.LimitGrafDate EQ ?
      THEN DO:
         tt-loan.LimitGrafDate = tt-loan.end-date .
      END.
      IF tt-loan.rewzim$ EQ ? OR
         tt-loan.rewzim$ EQ ""
      THEN DO:
         tt-loan.LimitGrafDate = ? .
      END.
      IF tt-loan.rewzim$ NE ? AND
         tt-loan.rewzim$ NE ""  AND
         tt-loan.LimitGrafDate NE  tt-loan.end-date
      THEN DO:
             RUN LimitChangeDatePo IN h_limit( "",
            tt-loan.contract  ,
            tt-loan.cont-code ,
            tt-loan.End-date  ,
            INPUT-OUTPUT tt-loan.LimitGrafDate
            ) NO-ERROR .
         IF ERROR-STATUS :ERROR THEN
            RETURN ERROR RETURN-VALUE .
      END.  /* tt-loan.LimitGrafDate NE  tt-loan.end-date */

      /* Проверка на возможность автоматической разноски сводного графика */
   RUN CheckAutoTermDistrTT (tt-loan.contract,     /* Назначение договора */
                             tt-loan.cont-code,    /* Номер договора */
                             OUTPUT vCheckMon).    /* Результат */
   IF NOT vCheckMon THEN
   DO:
      ASSIGN
         mRetVal = {&RET-ERROR}
         vRet    = RETURN-VALUE
      .
      RETURN ERROR "Проверка на возможность автоматической разноски графика не пройдена".
   END.

   IF iMode = {&MOD_ADD} THEN
   DO:
      vHRisk = GetProperty(mInstance,"risk","").

      IF VALID-HANDLE(vHRisk) THEN
         vHRisk:PRIVATE-DATA = {&FORM-DEF} NO-ERROR.

      vHGrRiska = GetProperty(mInstance,"gr-riska","").

      IF VALID-HANDLE(vHGrRiska) THEN
         vHGrRiska:PRIVATE-DATA = {&FORM-DEF} NO-ERROR.

      ASSIGN
         tt-loan.risk = DECIMAL(mRisk:SCREEN-VALUE IN FRAME {&frame-name})
         tt-loan.gr-riska = INT64(mGrRiska:SCREEN-VALUE IN FRAME {&frame-name})
      .
   END.

   IF tt-loan-cond.shemaplat$ THEN
   DO WITH FRAME {&MAIN-FRAME}:
      vHs = GetProperty(mInstance,"loan-cond","").
      IF VALID-HANDLE(vHs) THEN
         ASSIGN
            vHs  = vHs:BUFFER-VALUE
            vHs  = vHs:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("shemaplat$")
            .
      IF VALID-HANDLE(vHs) THEN
         vHs:PRIVATE-DATA = {&FORM-DEF} NO-ERROR.
      ASSIGN
         tt-loan-cond.int-period  = tt-loan-cond.cred-period
         tt-loan-cond.int-month   = tt-loan-cond.cred-month
         tt-loan-cond.int-date    = tt-loan-cond.cred-date
         tt-loan-cond.delay       = tt-loan-cond.delay1
         tt-loan-cond.int-offset  = tt-loan-cond.cred-offset
         tt-loan-cond.end-date    = tt-loan.end-date
         .
      IF iMode = {&MOD_ADD} THEN
      DO:
         vHs = GetProperty(mInstance,"loan-cond","").

         IF VALID-HANDLE(vHs) THEN
            ASSIGN
               vHs = vHs:BUFFER-VALUE
               vHs = vHs:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("end-date")
               .
         IF VALID-HANDLE(vHs) THEN
            vHs:PRIVATE-DATA = {&FORM-DEF} NO-ERROR.
      END.

      FIND FIRST b-comm-rate WHERE
                 b-comm-rate.commission = "%Кред"
      NO-ERROR.
      IF tt-loan.class-code EQ "loan-tran-lin-ann" THEN
      DO:
         FIND FIRST xloan WHERE xloan.contract  EQ tt-loan.contract
                            AND xloan.cont-code EQ ENTRY(1,tt-loan.cont-code," ")
         NO-LOCK NO-ERROR.
         IF AVAIL xloan THEN
            FIND LAST  xcomm-rate WHERE
                       xcomm-rate.commission EQ "%Кред"
                   AND xcomm-rate.acct       EQ "0"
                   AND xcomm-rate.kau        EQ xloan.contract + "," + xloan.cont-code
                   AND xcomm-rate.since      LE tt-loan-cond.since
            NO-LOCK NO-ERROR.
       END.
      /* Если это изменение записи, то на данный момент мы можем либо установить дату
      ** закрытия, либо пролонгировать дату окончания договора.
      ** В любом случае, расчет должен вестись от даты последнего условия до даты
      ** окончания договора. Если не переискивать xxloan-cond и tt-amount,
      ** то при изменении чего либо в карточке договора, расчет будет вестись
      ** от даты начала договора до даты следующего условия, что не верно,
      ** поэтмоу переискиваем нужные даты */
      IF iMode EQ {&MOD_EDIT} THEN
      DO:
         FIND LAST xxloan-cond WHERE xxloan-cond.contract  EQ tt-loan.contract
                                 AND xxloan-cond.cont-code EQ tt-loan.cont-code
                                 AND xxloan-cond.since     LE DATE(tt-loan.end-date:SCREEN-VALUE)
         NO-LOCK NO-ERROR.
         FIND FIRST tt-amount WHERE tt-amount.contract  EQ tt-loan.contract
                                AND tt-amount.cont-code EQ tt-loan.cont-code
                                AND tt-amount.idnt      EQ 2
                                AND tt-amount.end-date  LE xxloan-cond.since
         NO-LOCK NO-ERROR.
      END.

      RUN CalcAnnuitet(
                       tt-loan.contract,
                       tt-loan.cont-code,
                       IF iMode EQ {&MOD_EDIT} THEN xxloan-cond.since
                                               ELSE DATE(tt-loan.open-date:SCREEN-VALUE),
                       DATE(tt-loan.end-date:SCREEN-VALUE),
                       tt-amount.amt-rub,
                       (IF AVAIL xcomm-rate THEN xcomm-rate.rate-comm ELSE IF AVAIL b-comm-rate THEN b-comm-rate.rate-comm ELSE 0),
                       INT64(tt-loan-cond.cred-date:SCREEN-VALUE),
                       tt-loan-cond.cred-period:SCREEN-VALUE,
                       tt-loan-cond.cred-month:SCREEN-VALUE,
                       INT64(tt-loan-cond.kollw#gtper$:SCREEN-VALUE),
                       LOOKUP(tt-loan-cond.cred-offset:SCREEN-VALUE,tt-loan-cond.cred-offset:LIST-ITEMS),
                       INT64(tt-loan-cond.annuitkorr$:SCREEN-VALUE),
                       DEC(tt-loan.sum-depos:SCREEN-VALUE),
                       INT64(tt-loan-cond.FirstPeriod:SCREEN-VALUE),
                       DEC(tt-loan-cond.PartAmount:SCREEN-VALUE),
                       OUTPUT vSum).
     IF RETURN-VALUE <> "" THEN
     DO:
        ASSIGN
           mRetVal = {&RET-ERROR}
           vRet    = RETURN-VALUE
           .
        RETURN ERROR vRet.
     END.

         /* Проверка ограничения по сроку аннуитета, имеет смысл только для
         ** класса "loan_mortgage", для других классов пропускается */
      IF    AVAIL b-comm-rate
         OR AVAIL xcomm-rate THEN
      DO:
         RUN CheckTermLimit(tt-loan.Class-Code,
                            DATE(tt-loan.open-date:SCREEN-VALUE),
                            DATE(tt-loan.end-date:SCREEN-VALUE),
                            (IF AVAIL xcomm-rate THEN xcomm-rate.rate-comm ELSE b-comm-rate.rate-comm),
                            OUTPUT vCheckMon,
                            OUTPUT mRetVal
                            ).
         IF vCheckMon THEN
            RETURN ERROR mRetVal.
         ELSE IF mRetVal NE "" THEN
            RUN Fill-SysMes IN h_tmess ("", "", "", mRetVal).
      END.
   END.

   IF br-comm:VISIBLE AND NOT mBrowseCommRateOFF THEN
   DO:
      FOR EACH b-comm-rate WHERE b-comm-rate.since EQ tt-loan-cond.since BY Local__ID:
         IF iMode EQ {&MOD_ADD} THEN
         DO:
            mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
            {loan-trg.pro
               &CheckCommRate  = YES
               &LogVarChanged  = mChangedField
               &tt-loan        = tt-loan
               &tt-loan-cond   = tt-loan-cond
               &tt-comm-rate   = tt-comm-rate
               &tt-amount      = tt-term-amt
               &br-comm        = br-comm
            }
            b-comm-rate.currency = tt-loan.currency.
            vId = b-comm-rate.local__id + 1.
         END.
      END.
   END.
   tt-loan-cond.user__mode =
      IF BT_CAN-TABLE("tt-loan-cond","visible",OUTPUT vHT) THEN
         {&MOD_EDIT}
         ELSE
            {&MOD_DELETE}.
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      tt-loan.since = tt-loan.open-date.
      tt-loan-cond.since = tt-loan.open-date.
      tt-loan-cond.contract = tt-loan.contract.
      IF tt-loan.cont-code EQ "" THEN
         tt-loan.cont-code = ?.

      IF tt-loan.doc-ref EQ "" THEN
         tt-loan.doc-ref = ?.

      IF tt-amount.amt-rub NE 0 THEN ASSIGN
         tt-amount.fop-date = tt-loan.open-date
         tt-amount.end-date = tt-loan.open-date.
      IF tt-percent.amt-rub NE 0 THEN ASSIGN
         tt-percent.fop-date = tt-loan.open-date
         tt-percent.end-date = tt-loan.end-date.

      IF {assigned tt-loan-acct-main.acct} THEN
      DO:
         IF shMode THEN
         DO: /* tt-loan-acct-main.acct может быть без @ */
            FIND FIRST acct WHERE acct.filial-id EQ tt-loan.filial-id
                              AND acct.number    EQ ENTRY(1, tt-loan-acct-main.acct, "@")
                              AND acct.currency  EQ tt-loan.currency
               NO-LOCK NO-ERROR.
            IF AVAIL acct THEN
            DO:
               IF tt-loan-acct-main.acct NE acct.acct THEN
                  tt-loan-acct-main.acct = acct.acct.
            END.
         END.
         ASSIGN
            tt-loan-acct-main.currency = tt-loan.currency
            tt-loan-acct-main.since = tt-loan.open-date
         .
      END.
      IF {assigned tt-loan-acct-cust.acct} THEN
      DO:
         IF shMode THEN
         DO: /* tt-loan-acct-cust.acct может быть без @ */
            FIND FIRST acct WHERE acct.filial-id EQ tt-loan.filial-id
                              AND acct.number    EQ ENTRY(1, tt-loan-acct-cust.acct, "@")
                              AND acct.currency  EQ tt-loan.currency
               NO-LOCK NO-ERROR.
            IF AVAIL acct THEN
            DO:
               IF tt-loan-acct-cust.acct NE acct.acct THEN
                  tt-loan-acct-cust.acct = acct.acct.
            END.
         END.
         ASSIGN
            tt-loan-acct-cust.currency = tt-loan.currency
            tt-loan-acct-cust.since = tt-loan.open-date
         .
      END.
   END.

   IF tt-loan.alt-contract EQ "mm" THEN
   DO:
      {f-fx.trg
         &CHECK-AGREEMENT=YES
         &BASE-TABLE=tt-loan
      }
      IF iMode EQ {&MOD_ADD} THEN /* создание течения */
      DO:
         RUN CreLoanStream(vId) NO-ERROR.
         IF ERROR-STATUS:ERROR THEN
         DO:
            mRetVal = {&RET-ERROR}.
            RETURN ERROR RETURN-VALUE.
         END.
      END.
      ELSE
      DO:
         RUN MM_SetContTypeStreem IN h_mm(tt-loan.contract,tt-loan.cont-code,tt-loan.cont-type).
         tt-loan.cont-type = "Течение".
      END.
   END.

   RUN SetTermObl.

    /* Если у договора транша есть дополнтельный реквизит UnformBag,
        то предлагаем его добавить в течении */
   IF iMode EQ {&MOD_ADD} AND AVAIL tt-instance THEN
   DO:
      mUniformBag = GetXAttrValueEx("loan", tt-instance.contract + "," + tt-instance.cont-code, "UniformBag", "").
      IF tt-instance.cont-type EQ "Течение" AND mUniformBag NE "" THEN
      DO:
         pick-value ="".
         RUN Fill-SysMes IN h_tmess ("","","4", "На охватывающем договоре установлен ДР UniformBag в значение " + mUniformBag + ". Установить данный реквизит на течении?").
         IF pick-value EQ "YES" THEN /* YES */
            tt-loan.UniformBag = mUniformBag.
      END.
   END.

      /* Сохраняем значение счетчика в ДР договора "AgrCounter" */
   IF mCounterVal GT 0 THEN
   DO:
     IF NOT UpdateSigns("loan",
                         tt-loan.contract + "," + tt-loan.cont-code,
                         "AgrCounter",
                         STRING(mCounterVal),
                         NO) THEN
         RUN Fill-SysMes IN h_tmess ("","","", "Ошибка сохранения ДР AgrCounter").
      ELSE
         tt-loan.AgrCounter = STRING(mCounterVal).
   END.

   /* Обработка лимитов при наличии комиссии "%МинОД" */
   FIND FIRST tt-comm-rate WHERE
              tt-comm-rate.commission EQ "%МинОД"
   NO-ERROR.
   IF     AVAIL tt-comm-rate
   THEN DO:
      IF NOT {assigned tt-loan.rewzim$} THEN
         ASSIGN
            tt-loan.rewzim$:SCREEN-VALUE = "ВозобнЛиния"
            tt-loan.rewzim$
         .
      IF tt-loan.rewzim$ NE "ВозобнЛиния"
      THEN DO:
         IF  tt-loan.rewzim$ = ? OR tt-loan.rewzim$ = ""
         THEN
            ASSIGN
            tt-loan.rewzim$:SCREEN-VALUE = "ВозобнЛиния"
            tt-loan.rewzim$              = "ВозобнЛиния"
            .
         ELSE DO:
            RUN Fill-SysMes IN h_tmess ("", "", "", "Ставка минимального погашения ОД обрабатывается в режиме ВозобнЛиния").
            RETURN ERROR "Ставка минимального погашения ОД обрабатывается в режиме ВозобнЛиния".
         END.
      END.
      ELSE DO:
         /* Сохранение лимитов */
         IF (mLimit EQ ? OR mLimit EQ 0)
         THEN DO:
            mLimit = tt-amount.amt-rub.
            RUN SaveLoanLimit (tt-loan.contract,tt-loan.cont-code,tt-loan.open-date,tt-loan.currency,"limit-l-debts",mLimit,OUTPUT vOk).
            IF NOT vOk THEN
               RUN Fill-SysMes IN h_tmess ("","","0","Возникла ошибка при сохранении лимита задолженности. Лимит не сохранен.").
         END.
      END.
   END.

   /* Свод */
   IF tt-loan.cont-type NE "Течение" THEN
      ASSIGN
         tt-loan.svodgrafik$ = IF tt-loan.svodgrafik$ EQ NO THEN ? ELSE tt-loan.svodgrafik$
         tt-loan.svodskonca$ = IF tt-loan.svodskonca$ EQ NO THEN ? ELSE tt-loan.svodskonca$
         tt-loan.svodgravto$ = IF tt-loan.svodgravto$ EQ NO THEN ? ELSE tt-loan.svodgravto$
         tt-loan.svodspostr$ = IF tt-loan.svodspostr$ EQ NO THEN ? ELSE tt-loan.svodspostr$
      .
      /* для ставок, которые были созданы для корректного отображения в браузере
      br-comm, устанавливаем признак удаления */
   IF iMode NE {&MOD_ADD} THEN
      FOR EACH tt-comm-rate WHERE tt-comm-rate.local__template EQ YES:
          tt-comm-rate.user__mode = {&MOD_DELETE}.
      END.
      /* для tt-comm-cond проверка local__template не требуется, т.к.
      ** анализируется реальное изменение ставок */
   FOR EACH tt-comm-cond:
         /* для работоспособности сохранения плавающих ставок
         ** необходимо изменить tt-comm-cond.since
         ** так же как и сделали выше с tt-loan-cond.since */
         /* ищем предыдущую ставку, отличную от текущей */
      FIND LAST comm-cond WHERE
                comm-cond.contract   EQ tt-comm-cond.contract
            AND comm-cond.cont-code  EQ tt-comm-cond.cont-code
            AND comm-cond.commission EQ tt-comm-cond.commission
            AND comm-cond.since      LE tt-comm-cond.since
      NO-LOCK NO-ERROR.
      IF AVAIL comm-cond THEN
      DO:
         IF comm-cond.since EQ tt-comm-cond.since
         THEN
            tt-comm-cond.local__rowid = ROWID(comm-cond).
         ELSE IF    comm-cond.FloatType EQ tt-comm-cond.FloatType
                 OR comm-cond.Action    EQ tt-comm-cond.Action
                   /* здесь необходимо перечислить все поля
                   ** возможные к изменению при заведении
                   ** нового условия */
         THEN
               /* признак удаления при сохранении */
            tt-comm-cond.user__mode = {&MOD_DELETE}.
      END.
      ELSE
         IF NOT tt-comm-cond.FloatType THEN
            tt-comm-cond.user__mode = {&MOD_DELETE}.
   END.
      /* перед записью заполняем связи с агрегирующими объектами */

IF NOT AVAIL tt-loan-cond THEN
      FIND FIRST tt-loan-cond NO-ERROR.

   FOR EACH tt-comm-cond WHERE tt-comm-cond.user__mode NE {&MOD_DELETE}:

      IF AVAIL tt-loan-cond THEN
         tt-comm-cond.local__UpId = tt-loan-cond.local__Id.
      ELSE
            /* если не нашли подходящего условия, то не сохраняем ставку */
         tt-comm-cond.user__mode = {&MOD_DELETE}.
   END.

   IF iMode EQ {&MOD_ADD} THEN
      FOR FIRST tt-comm-rate WHERE 
                tt-comm-rate.rate-comm EQ ? 
      NO-LOCK:
         RUN Fill-SysMes IN h_tmess ("","","0",
                                     "Не задано значение процентой ставки " + 
                                     tt-comm-rate.commission).
         RETURN ERROR.
      END.  
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Local_F9 TERMINAL-SIMULATION
PROCEDURE Local_F9:
                  /* Проверка прав на редактирование договора подчиненного */
   IF     USERID("bisquit") NE tt-loan.user-id
      AND NOT GetSlavePermission(USERID("bisquit"),tt-loan.user-id,"w")
   THEN RETURN ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PostGetObject TERMINAL-SIMULATION
PROCEDURE PostGetObject :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   DEFINE VARIABLE vCustCat      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vCustID       AS INT64    NO-UNDO.
   DEFINE VARIABLE vH            AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vAcctTypeList AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vAcctType     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vAcct         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vProd         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vOk           AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE vInstCond     AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vBuffCond     AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vProdPogOD    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vProdPogPr    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vProdType     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vDR           AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vValDR        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vI            AS INT64      NO-UNDO.
   DEFINE VARIABLE vLstDR        AS CHAR       NO-UNDO. /*список наследуемых ДР*/
   DEFINE VARIABLE vLoan         AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vBufField     AS HANDLE     NO-UNDO. 

   DEF BUFFER bPos       FOR loan.      /* Локализация буфера. */
   DEF BUFFER bterm-obl  FOR term-obl.  /* Локализация буфера. */

   IF     AVAIL tt-Instance
      AND iMode EQ {&MOD_ADD} THEN
      IF tt-Instance.cont-type EQ "Течение" THEN 
      DO:
         vLstDR =  GetXAttrInit(tt-Instance.class-code, "СписНаслДР").
         vLoan = BUFFER tt-loan:HANDLE.
         DO vI = 1 TO NUM-ENTRIES(vLstDR):
            vDR  =  ENTRY(vI,vLstDR).
            vValDr  = GetXAttrValueEx("loan", tt-Instance.contract + "," + tt-Instance.cont-code, vDR,"").
            vBufField = vLoan:BUFFER-FIELD(GetMangLedName(vDR)) NO-ERROR.
            IF vBufField EQ ? THEN
               {additem.i mLstDR vDR}
            ELSE
               CASE vBufField:DATA-TYPE:
                  WHEN "int64"   THEN vBufField:BUFFER-VALUE = INT64(vValDr).
                  WHEN "date"    THEN vBufField:BUFFER-VALUE = DATE(vValDr).
                  WHEN "decimal" THEN vBufField:BUFFER-VALUE = DEC(vValDr).
                  OTHERWISE           vBufField:BUFFER-VALUE = vValDr.
               END CASE.
         END.
      END.

         /* Проверка прав доступа к информации клиента-владельца договора */
   IF    (iMode EQ {&MOD_EDIT}
      OR  iMode EQ {&MOD_VIEW})
      AND tt-loan.cust-cat EQ "Ч"
      AND NOT GetPersonPermission(tt-loan.cust-id)
   THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "ap16", "", "%s=" + STRING(tt-loan.cust-id)).
      RETURN ERROR.
   END.

   IF    iMode EQ {&MOD_EDIT}
      OR iMode EQ {&MOD_VIEW}
   THEN
   DO:
      mBag = LnInBagOnDate (tt-loan.contract, tt-loan.cont-code,gend-date).
      CASE tt-loan.contract:
         WHEN "Кредит" THEN
            mFindLoanCond = FGetSetting("КредФУсл", "", "").
         WHEN "Депоз" THEN
            mFindLoanCond = FGetSetting("ДепФУсл", "", "").
      END CASE.
      CASE mFindLoanCond:
         WHEN "ПЕРВЫЕ" THEN
            FIND FIRST tt-loan-cond WHERE
                       tt-loan-cond.cont-code EQ tt-loan.cont-code
                   AND tt-loan-cond.contract  EQ tt-loan.contract
            NO-LOCK NO-ERROR.
         WHEN "ДАТАСОСТ" THEN
            FIND LAST tt-loan-cond WHERE
                      tt-loan-cond.cont-code EQ tt-loan.cont-code
                  AND tt-loan-cond.contract  EQ tt-loan.contract
                  AND tt-loan-cond.since     LE tt-loan.since
            NO-LOCK NO-ERROR.
      END CASE.
      IF CAN-DO("ДАТАСОСТ,ПОСЛЕДНИЕ", mFindLoanCond) THEN
      DO:
            /* подмена суммы в соответствии с найденным условием */
         FIND FIRST bterm-obl WHERE
                    bterm-obl.contract  EQ tt-loan.contract
                AND bterm-obl.cont-code EQ tt-loan.cont-code
                AND bterm-obl.end-date  EQ tt-loan-cond.since
                AND bterm-obl.idnt      EQ 2
         NO-LOCK NO-ERROR.
         IF AVAIL bterm-obl THEN DO:

            RUN PrepareInstance IN h_data ("").

            RUN GetInstance IN h_data ("term-obl",
                                       bterm-obl.contract + "," + bterm-obl.cont-code + "," + STRING(bterm-obl.idnt) + "," + STRING(bterm-obl.end-date) + "," + STRING(bterm-obl.nn),
                                       OUTPUT vInstCond,
                                       OUTPUT vOk).
            vBuffCond = vInstCond:DEFAULT-BUFFER-HANDLE.
            vBuffCond:FIND-FIRST().
            BUFFER tt-amount:BUFFER-COPY(vBuffCond) NO-ERROR.
            tt-amount.local__rowid = TO-ROWID (getInstanceProp2 (vBuffCond, "__rowid")).

         END.
      END.
   END.

   /* Commented by KSV: Если режим новой записи, иницализируем ряд полей */
   IF iMode = {&MOD_ADD} THEN
   DO:
      tt-loan.open-time = TIME.
      tt-loan.datasogl$ = TODAY.
      IF tt-loan.alt-contract = "mm"  THEN
      DO:
         {f-fx.trg &INIT-AGREEMENT = YES}
      END.
                        /* Определение риска. */
      mRisk =  tt-loan.risk.
      IF mBag NE ?
      THEN DO:
         FIND FIRST bPos WHERE
                  bPos.contract  EQ "ПОС"
            AND   bPos.cont-code EQ mBag
         NO-LOCK NO-ERROR.
         IF AVAIL bPos THEN
            mRisk = DEC (fGetBagRate ((BUFFER bPos:HANDLE), "%Рез", tt-loan.since, "rate-comm")).
      END.
      RUN LnGetRiskGrOnDate IN h_i254 (DEC(mRisk),
                                       tt-loan.since,
                                       OUTPUT mGrRiska).
      IF mGrRiska = ? THEN
      DO:
         MESSAGE 'Не удалось расчитать группу риска' SKIP
                 'по указанному коэффициенту резервирования'
            VIEW-AS ALERT-BOX ERROR.
      END.

      IF AVAIL tt-instance THEN
      DO:
         IF iMode EQ {&MOD_ADD} THEN ASSIGN
            mGrRiska = tt-instance.gr-riska
            mRisk    = tt-instance.risk
            tt-loan.currency = tt-instance.currency.
         vAcctTypeList = GetXattrEx(iClass,"acct-type-list","Initial").
         vH = GetProperty(iInstance,"loan-acct-main:acct-type","").
         vAcctType = vH:BUFFER-VALUE.
         vH = GetProperty(iInstance,"loan-acct-main:acct","").
         vAcct = vH:BUFFER-VALUE.
         IF {assigned vAcctType} AND
            NOT {assigned tt-loan-acct-main.acct} AND
            CAN-DO(vAcctTypeList,vAcctType) THEN
            tt-loan-acct-main.acct = vAcct.

         vH = GetProperty(iInstance,"loan-acct-cust:acct-type","").
         vAcctType = vH:BUFFER-VALUE.
         vH = GetProperty(iInstance,"loan-acct-cust:acct","").
         vAcct = vH:BUFFER-VALUE.
         IF {assigned vAcctType} AND
            NOT {assigned tt-loan-acct-cust.acct} AND
            CAN-DO(vAcctTypeList,vAcctType) THEN
            tt-loan-acct-cust.acct = vAcct.
      END.
      /* список допустимых значений для полей Сдвиг */
      RUN GetXAttr (tt-loan.class-code,"cred-offset",BUFFER xattr).
      mOffsetVld = xattr.Validation.   /* получить список допустимых значений полей "Сдвиг" */
      ENTRY(LOOKUP("",mOffsetVld),mOffsetVld) = mOffsetNone. /* вместо значения "" используем "--" */

      IF NUM-ENTRIES(iInstanceList,CHR(3)) GT 1
      THEN
         vProd = ENTRY(2,iInstanceList,CHR(3)).
      IF {assigned vProd}
      THEN DO:
         /* Форма установок параметра продукта */
         RUN cred-prod-cr.p (vProd,           /* Продукт */
                             gend-date,       /* На дату */
                             "",              /* Предустановка */
                             OUTPUT vProd).   /* Строка настроек продукта */
         IF NUM-ENTRIES(vProd, ";") GT 0 THEN
         DO:
            FIND LAST tmp-code WHERE
                         tmp-code.class      EQ "ПродЛин"
                  AND    tmp-code.code       EQ ENTRY( 1, vProd, ";")
                  AND    tmp-code.beg-date   LE tt-loan.open-date
                  AND   (tmp-code.end-date   GE tt-loan.open-date
                     OR  tmp-code.end-date   EQ ?)
            NO-LOCK NO-ERROR.


            vProdPogOD = GetRefVal ("ПродПог", gend-date, ENTRY( 1, vProd, ";") + "," + "ОД").
            vProdPogPr = GetRefVal ("ПродПог", gend-date, ENTRY( 1, vProd, ";") + "," + "%").

            /*Сначала  берем тип периода с конкретного продукта, затем с НП*/
            vProdType = IF AVAIL tmp-code AND CAN-DO("Д,М,Г",tmp-code.misc[8])
                        THEN tmp-code.misc[8]
                        ELSE FGetSetting("Продукты", "ТипПериода", "М").

            ASSIGN
               tt-loan.prodkod$        = ENTRY( 1, vProd, ";")
               tt-loan.currency        = ENTRY( 3, vProd, ";")
               tt-amount.amt-rub       = DEC(ENTRY( 2, vProd, ";"))
               vProdType               = IF NOT CAN-DO("Д,М,Г",vProdType) THEN "М" ELSE vProdType
               tt-loan-cond.NDays      = IF vProdType EQ "Д" THEN INT64(ENTRY( 4, vProd, ";")) ELSE tt-loan-cond.NDays
               tt-loan-cond.NMonthes   = IF vProdType EQ "М" THEN INT64(ENTRY( 4, vProd, ";")) ELSE tt-loan-cond.NMonthes
               tt-loan-cond.NYears     = IF vProdType EQ "Г" THEN INT64(ENTRY( 4, vProd, ";")) ELSE tt-loan-cond.NYears
               tt-loan-cond.prodtrf$   = ENTRY( 7, vProd, ";")
               tt-loan.cont-type       = ENTRY( 8, vProd, ";")
              .
               /* ОД */
            IF NUM-ENTRIES (vProdPogOD) GE 8 THEN
               ASSIGN
                  tt-loan-cond.cred-period  = ENTRY(1,vProdPogOD)
                  tt-loan-cond.cred-date    = INT64(ENTRY(2,vProdPogOD))
                  tt-loan-cond.cred-month   = INT64(ENTRY(3,vProdPogOD))
                  cred-offset_:SCREEN-VALUE IN FRAME fMain = ENTRY(4,vProdPogOD)
                  tt-loan-cond.cred-offset  = ENTRY(4,vProdPogOD)
                  tt-loan-cond.kollw#gtper$ = INT64(ENTRY(5,vProdPogOD))
                  tt-loan-cond.cred-mode    = ENTRY(6,vProdPogOD)
                  tt-loan-cond.delay1       = INT64(ENTRY(7,vProdPogOD))
                  delay-offset_             = ENTRY(8,vProdPogOD)
                  tt-loan-cond.delay-offset = ENTRY(8,vProdPogOD)
               .
               /* %% */
            IF NUM-ENTRIES (vProdPogPr) GE 8 THEN
               ASSIGN
                  tt-loan-cond.int-period       = ENTRY(1,vProdPogPr)
                  tt-loan-cond.int-date         = INT64(ENTRY(2,vProdPogPr))
                  tt-loan-cond.int-month        = INT64(ENTRY(3,vProdPogPr))
                  int-offset_:SCREEN-VALUE IN FRAME fMain = ENTRY(4,vProdPogPr)
                  tt-loan-cond.int-offset       = ENTRY(4,vProdPogPr)
                  tt-loan-cond.kollw#gtperprc$  = INT64(ENTRY(5,vProdPogPr))
                  tt-loan-cond.int-mode         = ENTRY(6,vProdPogPr)
                  tt-loan-cond.delay            = INT64(ENTRY(7,vProdPogPr))
                  delay-offset-int_             = ENTRY(8,vProdPogPr)
                  tt-loan-cond.delay-offset-int = ENTRY(8,vProdPogPr)
               .

            IF vProdType EQ "Д" 
            THEN
               tt-loan.end-date        = tt-loan.open-date + tt-loan-cond.Ndays.
            ELSE IF vProdType EQ "М" 
            THEN
            tt-loan.end-date        = GoMonth(tt-loan.open-date,tt-loan-cond.NMonthes).
            ELSE IF vProdType EQ "Г" 
            THEN DO:
               tt-loan.end-date = DATE(MONTH(tt-loan.open-date),
                                       DAY(tt-loan.open-date),
                                       YEAR(tt-loan.open-date) + tt-loan-cond.NYears) NO-ERROR.
               IF ERROR-STATUS:ERROR /* Если вдруги в этом году нет 29 февраля */
               THEN DO:
                  ASSIGN
                     tt-loan.end-date   = DATE(MONTH(tt-loan.open-date),
                                               DAY(tt-loan.open-date) + 1,
                                               YEAR(tt-loan.open-date) + tt-loan-cond.NYears)
                     tt-loan-cond.NDays = 1
                  .
               END.
            END.
               
            

            mNameCredPeriod = GetDomainCodeName(tt-loan-cond.class-code,
                                                "cred-period",
                                                tt-loan-cond.cred-period).
            mNameIntPeriod  = GetDomainCodeName(tt-loan-cond.class-code,
                                                "int-period",
                                                tt-loan-cond.int-period).

            /* Пока на форме не объявлены ДР "ПродКод" и "ПродТрф" пишем в набор данных */
            RUN SetInstanceProp(mInstance, "ПродКод", ENTRY( 1, vProd, ";"), OUTPUT vOk).
            vH = WIDGET-HANDLE(GetInstanceProp2(mInstance, "loan-cond")).
            IF VALID-HANDLE(vH) THEN
               RUN SetInstanceProp(vH, "ПродТрф", ENTRY( 7, vProd, ";"), OUTPUT vOk).

            /*НадеждаОД*/
            IF tt-loan.class-code = "loan_dbl_ann" 
                AND NUM-ENTRIES(vProd, ";") GE 18 THEN
            DO:
                ASSIGN
                    tt-loan-cond.PartAmount  = DEC(ENTRY(18 , vProd, ";"))
                    tt-loan-cond.FirstPeriod = INT(ENTRY(17 , vProd, ";"))
                    .
                RUN SetInstanceProp(mInstance, "InitPay", ENTRY( 10, vProd, ";"), OUTPUT vOk).
                RUN SetInstanceProp(mInstance, "rko11_price", ENTRY( 16, vProd, ";"), OUTPUT vOk).
            END.
         END.
      END.
   END.
   ELSE IF iMode = {&MOD_EDIT} 
   THEN DO:
      mNewEndDate = DATE(ENTRY(2,iInstanceList,CHR(3))) NO-ERROR.
   END.

   DO WITH FRAME {&MAIN-FRAME}:
      IF    tt-loan.open-date NE ?
        AND tt-loan.end-date  NE ?
        AND ( tt-loan-cond.NDays  EQ 0
        AND  tt-loan-cond.NMonth EQ 0
        AND  tt-loan-cond.NYears EQ 0 )
         OR ( tt-loan-cond.NDays EQ ?
         OR tt-loan-cond.NMonth EQ ?
         OR tt-loan-cond.NYears EQ ? ) THEN
      DO:
        RUN DMY_In_Per(tt-loan.open-date,
                        tt-loan.end-date,
                        OUTPUT mNDays,
                        OUTPUT mNMonth,
                        OUTPUT mNYear).
        ASSIGN
            tt-loan-cond.NDays  = mNDays
            tt-loan-cond.NMonth = mNMonth
            tt-loan-cond.NYears = mNYear
        .
      END.
   END.
      /* Свод */
   ASSIGN
      tt-loan.svodgrafik$ = IF tt-loan.svodgrafik$ EQ ? THEN NO ELSE tt-loan.svodgrafik$
      tt-loan.svodskonca$ = IF tt-loan.svodskonca$ EQ ? THEN NO ELSE tt-loan.svodskonca$
      tt-loan.svodgravto$ = IF tt-loan.svodgravto$ EQ ? THEN NO ELSE tt-loan.svodgravto$
      tt-loan.svodspostr$ = IF tt-loan.svodspostr$ EQ ? THEN NO ELSE tt-loan.svodspostr$
      mSvod               = tt-loan.svodgrafik$ OR tt-loan.svodskonca$ OR tt-loan.svodgravto$ OR tt-loan.svodspostr$
   .
   mSummaDog = DEC(GetXAttrValueEx("loan",tt-loan.contract + "," + tt-loan.cont-code,"СуммаДог","0")).
   IF     mSummaDog NE 0 
      AND mSummaDog NE ? THEN      
      tt-amount.amt-rub = mSummaDog.
   IF tt-loan-cond.grperiod$ EQ ? THEN
      tt-loan-cond.grperiod$ = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PostSetObject TERMINAL-SIMULATION
PROCEDURE PostSetObject :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

   DEFINE VARIABLE vH        AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vRow      AS ROWID      NO-UNDO.
   DEFINE VARIABLE vRecLoan  AS RECID      NO-UNDO.
   DEFINE VARIABLE vRecCond  AS RECID      NO-UNDO.
   DEFINE VARIABLE vAcctType AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vRet      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vRet1     AS CHARACTER  NO-UNDO.

   DEFINE VARIABLE vChangeSumm  AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE vChangePr    AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE vChangeDate  AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE vChangePer   AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE vGrRisk      AS INT64   NO-UNDO.
   DEFINE VARIABLE vListGrRiska AS CHARACTER NO-UNDO.

   DEFINE VARIABLE fl-error   AS INT64    NO-UNDO.
   DEFINE VARIABLE mObespTran AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vOk        AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE vCondCount AS INT64    NO-UNDO.
   DEFINE VARIABLE vCheckLimit  AS CHAR       NO-UNDO.

   DEFINE VARIABLE mGrRiskVn  AS INT64    NO-UNDO.
   DEFINE VARIABLE mMinRate   AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE vPayDateMove AS CHARACTER NO-UNDO. /* ДР РасчОкончСдвиг */

   DEFINE VARIABLE vAcctTypeList AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vCounter      AS INT64        NO-UNDO.
   DEFINE VARIABLE vPrefLimDate  AS DATE NO-UNDO .
   DEFINE VARIABLE vRetLim       AS CHARACTER NO-UNDO .
   DEFINE VARIABLE vLCRecNew     AS RECID NO-UNDO.
   DEFINE VARIABLE vLCSummNew    AS DEC   NO-UNDO.
   DEFINE VARIABLE vRaschInstr   AS CHARACTER NO-UNDO.

   DEFINE BUFFER loan       FOR loan.
   DEFINE BUFFER tloan      FOR loan.
   DEFINE BUFFER b-loan     FOR loan.
   DEFINE BUFFER loan-cond  FOR loan-cond. /* Локализация буфера. */
   DEFINE BUFFER tloan-cond FOR loan-cond.
   DEFINE BUFFER bcomm-rate FOR comm-rate.
   DEFINE BUFFER loan-acct  FOR loan-acct. /* Локализация буфера. */
   DEFINE BUFFER bloan-acct FOR loan-acct. /* Локализация буфера. */
   DEFINE BUFFER blimits    FOR limits.
   DEFINE BUFFER term-obl   FOR term-obl.

   /* Сохраняем сумму по договору */
   IF    iMode EQ {&MOD_ADD}
      OR iMode EQ {&MOD_EDIT} THEN
   DO:          
      UpdateSigns(tt-loan.Class-Code,
                  tt-loan.contract + "," + tt-loan.cont-code,
                  "СуммаДог",
                  STRING(mSummaDog),
                  ?).
   END.

   IF     AVAIL tt-Instance
      AND iMode EQ {&MOD_ADD} THEN /* копирование ДР с охватывающего договора */
      IF     tt-Instance.Cont-code EQ ENTRY(1, tt-loan.Cont-code, " ")
         AND tt-Instance.cont-type EQ "Течение" THEN 
      DO:
         mLstDR =  GetXAttrInit(tt-Instance.class-code, "СписНаслДР").
         RUN CopySignsEx(tt-Instance.class-code,
                         tt-loan.Contract + "," + tt-Instance.Cont-code,
                         tt-loan.class-code,
                         tt-loan.Contract + "," + tt-loan.Cont-code,
                         mLstDR,
                         "!*").
      END.

   IF iMode EQ {&MOD_ADD} THEN /* проверка на соответствие счетов клиенту */
   DO:
      vH = GetProperty(mInstance,"loan-acct-main:acct-type","__upid = 0").
      vAcctType = vH:BUFFER-VALUE.
      IF {assigned tt-loan-acct-main.acct} AND
         NOT CheckCliAcct(vAcctType,
                          tt-loan-acct-main.acct,
                          tt-loan.currency,
                          tt-loan.cust-cat,
                          tt-loan.cust-id) THEN
      DO:
         APPLY "ENTRY" TO tt-loan-acct-main.acct IN FRAME {&MAIN-FRAME}.
         RETURN ERROR "Счет не соответствует контрагенту или валюте".
      END.

      FIND loan WHERE loan.contract  EQ tt-loan.contract
                  AND loan.cont-code EQ tt-loan.cont-code
         NO-LOCK.
      IF {assigned tt-loan-acct-main.acct} THEN
      DO:
         FOR EACH acct WHERE
                  acct.acct     =  tt-loan-acct-main.acct
              AND acct.currency =  tt-loan.currency
         NO-LOCK:

            RUN SetKau IN h_loanx (RECID(acct),
                                   RECID(loan) ,
                                   tt-loan-acct-main.acct-type).
            LEAVE.
         END.
      END.

      vH = GetProperty(mInstance,"loan-acct-cust:acct-type","__upid = 0").
      vAcctType = vH:BUFFER-VALUE.
      IF {assigned tt-loan-acct-cust.acct} AND
         NOT CheckCliAcct(vAcctType,
                          tt-loan-acct-cust.acct,
                          tt-loan.currency,
                          tt-loan.cust-cat,
                          tt-loan.cust-id) THEN
      DO:
         APPLY "ENTRY" TO tt-loan-acct-cust.acct IN FRAME {&MAIN-FRAME}.
         RETURN ERROR "Счет не соответствует контрагенту или валюте".
      END.

         /* Создание коэф.резервирования */
      IF INDEX(tt-loan.cont-code, " ") EQ 0 THEN
         RUN CrResRate IN h_Loan (tt-loan.contract,
                                  tt-loan.cont-code,
                                  mRisk,
                                  tt-loan.open-date).
         IF AVAILABLE tt-instance THEN DO:
            vAcctTypeList = GetXattrEx(tt-instance.class-code,"acct-type-list","Initial").
            REPEAT vCounter = 1 TO NUM-ENTRIES(vAcctTypeList):
               FIND LAST bloan-acct WHERE
                        bloan-acct.contract  EQ tt-instance.contract
                     AND bloan-acct.cont-code EQ tt-instance.cont-code
                     AND bloan-acct.acct-type EQ ENTRY(vCounter, vAcctTypeList)
                     AND bloan-acct.since     LE tt-loan.open-date
               NO-LOCK NO-ERROR.
               IF NOT AVAIL bloan-acct THEN
                  NEXT.
               FIND FIRST loan-acct WHERE
                        loan-acct.contract  EQ tt-loan.contract
                     AND loan-acct.cont-code EQ tt-loan.cont-code
                     AND loan-acct.acct-type EQ bloan-acct.acct-type
                     AND loan-acct.since     EQ tt-loan.open-date
               NO-LOCK NO-ERROR.
               IF AVAIL loan-acct THEN
                  NEXT.
               CREATE loan-acct.
               BUFFER-COPY bloan-acct EXCEPT cont-code since TO loan-acct.
               ASSIGN
                  loan-acct.cont-code = tt-loan.cont-code
                  loan-acct.since     = tt-loan.open-date
               .
            END.
         END.
         /* Создание и привязка счетов */
      {sgn-acct.i &BufferLoan = "LOAN"
                  &OpenDate   = loan.open-date
                  &OUT-Error  = fl-error
      }
      IF fl-error EQ -1 THEN
         RETURN ERROR "Обработка прервана".
      mObespTran = GetXAttrInit(loan.class-code,"Op-Kind_Obesp").
      IF {assigned mObespTran} THEN
      DO:
         FIND FIRST Op-Kind WHERE
                    Op-Kind.Op-Kind = mObespTran
         NO-LOCK NO-ERROR.
         FIND FIRST loan-cond WHERE
                    loan-cond.contract  = loan.contract
                AND loan-cond.cont-code = loan.cont-code
         NO-LOCK NO-ERROR.

         IF AVAIL Op-Kind AND
            AVAIL loan-cond   THEN
         DO:
               /* Cначала запускаем браузер обеспечения */
            RUN browseld.p ("term-obl-gar",
                            "contract"         + CHR(1) + "cont-code"         + CHR(1) + "since",
                            loan-cond.contract + CHR(1) + loan-cond.cont-code + CHR(1) + STRING(loan-cond.since),
                            "",
                            ilevel + 1).
               /* ... и транзакцию создания счетов */
            RUN credacct.p (loan.open-date,
                            RECID(Op-Kind),
                            RECID(loan),
                            "РЕДАКТИРОВАНИЕ СЧЕТОВ ПО ДОГОВОРУ № " +
                            loan.doc-ref,
                            OUTPUT fl-Error).
         END.
      END.
      IF fl-error EQ -1 THEN
         RETURN ERROR "Обработка прервана".
      UpdateSignsEx(tt-loan-cond.class-code,
                    tt-loan.contract + ","
                  + tt-loan.cont-code + ","
                  + STRING (tt-loan-cond.since),
                    "CondEndDate",
                    STRING(tt-loan.end-date)
                    ) .
      /* определяем, надо ли учитывать сдвиг даты платежа 
      ** для расчета даты окончания пробега */
      IF tt-loan-cond.cred-mode = "ДатаОконч" AND 
         NOT tt-loan-cond.cred-curr-next 
      THEN DO:
         vPayDateMove = GetXattrInit(tt-loan-cond.class-code, "РасчОкончСдвиг").
         IF vPayDateMove NE ? AND
            vPayDateMove NE "" 
         THEN DO:
            UpdateSignsEx(tt-loan-cond.class-code,
                          tt-loan.contract + ","
                        + tt-loan.cont-code + ","
                        + STRING (tt-loan-cond.since),
                          "РасчОкончСдвиг",
                          vPayDateMove
                          ) .
         END.
      END.
   /* Сохранение лимитов */
      IF tt-loan.rewzim$:SCREEN-VALUE NE ? AND
         tt-loan.rewzim$:SCREEN-VALUE NE ""  AND
         tt-loan.LimitGrafDate EQ ?
      THEN DO:
         tt-loan.LimitGrafDate = tt-loan.end-date .
      END.
      CASE tt-loan.rewzim$:SCREEN-VALUE :

         WHEN "ЛимВыдЗад" THEN DO:
            RUN SaveLoanLimit (tt-loan.contract,tt-loan.cont-code,tt-loan.open-date,tt-loan.currency,"limit-l-distr",mLimit,OUTPUT vOk).
            IF NOT vOk THEN
               RUN Fill-SysMes IN h_tmess ("","","0","Возникла ошибка при сохранении лимита выдачи. Лимит не сохранен.").
         RUN SaveLoanLimitLastCond IN h_limit  (tt-loan.contract,tt-loan.cont-code,tt-loan.LimitGrafDate,tt-loan.currency,"limit-l-distr",OUTPUT vOk).
         IF NOT vOk THEN
            RUN Fill-SysMes IN h_tmess ("","","0","Возникла ошибка при сохранении последней записи лимита выдачи. Лимит не сохранен.").

         END.
         WHEN "ВозобнЛиния" THEN DO:
            RUN SaveLoanLimit (tt-loan.contract,tt-loan.cont-code,tt-loan.open-date,tt-loan.currency,"limit-l-debts",mLimit,OUTPUT vOk).
            IF NOT vOk THEN
               RUN Fill-SysMes IN h_tmess ("","","0","Возникла ошибка при сохранении лимита задолженности. Лимит не сохранен.").
            RUN SaveLoanLimitLastCond IN h_limit  (tt-loan.contract,tt-loan.cont-code,tt-loan.LimitGrafDate,tt-loan.currency,"limit-l-debts",OUTPUT vOk).
            IF NOT vOk THEN
               RUN Fill-SysMes IN h_tmess ("","","0","Возникла ошибка при сохранении последней записи лимита задолженности. Лимит не сохранен.").

         END.
         WHEN "НевозЛиния" THEN DO:
            RUN SaveLoanLimit (tt-loan.contract,tt-loan.cont-code,tt-loan.open-date,tt-loan.currency,"limit-l-distr",mLimit,OUTPUT vOk).
            IF NOT vOk THEN
               RUN Fill-SysMes IN h_tmess ("","","0","Возникла ошибка при сохранении лимита выдачи. Лимит не сохранен.").
            RUN SaveLoanLimitLastCond IN h_limit  (tt-loan.contract,tt-loan.cont-code,tt-loan.LimitGrafDate,tt-loan.currency,"limit-l-distr",OUTPUT vOk).
            IF NOT vOk THEN
               RUN Fill-SysMes IN h_tmess ("","","0","Возникла ошибка при сохранении последней записи лимита выдачи. Лимит не сохранен.").
         END.
      END CASE.
   END.

   IF iMode EQ {&MOD_EDIT} THEN
   DO:
         /* Изменение срока действия лимитов */
      IF tt-loan.rewzim$:SCREEN-VALUE NE ? AND
         tt-loan.rewzim$:SCREEN-VALUE NE ""  AND
         tt-loan.LimitGrafDate EQ ?
      THEN DO:
         tt-loan.LimitGrafDate = tt-loan.end-date .
      END.
      CASE tt-loan.rewzim$:SCREEN-VALUE :
         WHEN "ЛимВыдЗад" OR
         WHEN "НевозЛиния" THEN DO:
         RUN SaveLoanLimitLastCond IN h_limit  (tt-loan.contract,tt-loan.cont-code,tt-loan.LimitGrafDate,tt-loan.currency,"limit-l-distr",OUTPUT vOk).
         IF NOT vOk THEN
            RUN Fill-SysMes IN h_tmess ("","","0","Возникла ошибка при сохранении последней записи лимита выдачи. Лимит не сохранен.").

      END.
      WHEN "ВозобнЛиния" THEN DO:
         RUN SaveLoanLimitLastCond IN h_limit  (tt-loan.contract,tt-loan.cont-code,tt-loan.LimitGrafDate,tt-loan.currency,"limit-l-debts",OUTPUT vOk).
         IF NOT vOk THEN
            RUN Fill-SysMes IN h_tmess ("","","0","Возникла ошибка при сохранении последней записи лимита задолженности. Лимит не сохранен.").

         END.
      END CASE.

   END.

   IF iMode EQ {&MOD_ADD} OR iMode EQ {&MOD_EDIT} THEN
   DO:
      vH = GetProperty(mInstance,"__rowid"," __id = 0").
      vRow = vH:BUFFER-VALUE.
      vRecLoan = Rowid2Recid("Loan",vRow).
      vH = GetProperty(mInstance,"loan-cond:__rowid","__upid = 0 BY since DESC").
      vRow = vH:BUFFER-VALUE.
      IF vRow NE ? THEN
      DO:
         vRecCond = Rowid2Recid("Loan-Cond",vRow).
         RUN SetSysConf IN h_base(
            "ОБЯЗАТЕЛЬСТВА ПО ВОЗВРАТУ СДВИГ",
            STRING(LOOKUP(tt-loan-cond.cred-offset,tt-loan-cond.cred-offset:LIST-ITEMS))).
         RUN SetSysConf IN h_base(
            "ПЛАТЕЖИ ПО ПРОЦЕНТАМ СДВИГ",
            STRING(LOOKUP(tt-loan-cond.int-offset,tt-loan-cond.int-offset:LIST-ITEMS))).
         RUN SetSysConf IN h_base("СделкаММ","Да").

         IF iMode EQ {&MOD_EDIT} THEN
         DO:
            FIND LAST tt-loan-cond NO-ERROR.
            FOR FIRST tt-amount WHERE tt-amount.amt-rub NE 0 BY tt-amount.end-date:
               LEAVE.
            END.
         END.
         IF iMode EQ {&MOD_ADD} THEN ASSIGN
            vChangeSumm = YES
            vChangePr   = YES
            vChangeDate = YES
            vChangePer  = YES
         .
         ELSE ASSIGN
            vChangeSumm = mAmount NE mSumma-sd
            vChangePr   =
               mCredPeriod NE tt-loan-cond.Cred-Period OR
               mCredDate NE tt-loan-cond.Cred-Date OR
               mDelay1 NE tt-loan-cond.Delay1 OR
               mCredOffset NE tt-loan-cond.cred-offset OR
               mCountPer NE tt-loan-cond.kollw#gtper$
            vChangeDate = mEndDate NE tt-loan.end-date
            vChangePer =   mIntPeriod  NE tt-loan-cond.int-Period
                        OR mIntDate    NE tt-loan-cond.int-Date
         .
         
         IF tt-loan.class-code = "loan_dbl_ann" THEN
         DO:
            FIND FIRST loan WHERE RECID(loan) EQ vRecLoan NO-LOCK NO-ERROR .
            FIND FIRST loan-cond WHERE
                       loan-cond.contract  EQ loan.contract
                   AND loan-cond.cont-code EQ loan.cont-code 
            NO-LOCK NO-ERROR.
            IF     AVAIL loan 
               AND AVAIL loan-cond THEN 
            DO:  
                IF iMode EQ {&MOD_ADD} THEN 
                DO:
                   RUN set-pr.p(RECID(loan-cond),RECID(loan),1).
                   RUN pog-cr.p(RECID(loan-cond),RECID(loan),0,tt-loan.open-date,tt-loan.open-date + 1,
                                OUTPUT vFlag) NO-ERROR.
                   RUN Cr_Cond_DblAnn IN h_Loan (tt-loan.contract, 
                                                 tt-loan.cont-code, 
                                                 tt-loan.open-date, 
                                                 NO, 
                                                 YES,
                                                 ?,
                                                 OUTPUT vLCRecNew,  
                                                 OUTPUT vLCSummNew) NO-ERROR.
                END.
                RUN anps.p(tt-loan.since,0, BUFFER loan, BUFFER loan-cond).
            END.
         END.
         ELSE DO:
             FOR EACH loan-cond WHERE
                      loan-cond.contract  = tt-loan.contract
                  AND loan-cond.cont-code = tt-loan.cont-code
             NO-LOCK:
                vCondCount = vCondCount + 1.
             END.
    
             IF    tt-loan.class-code EQ "loan-transh-ann"
                OR tt-loan.class-code EQ "loan-tran-lin-ann" THEN
             DO:
                /* перенос графиков */
                RUN loansvodgr.p(tt-loan.contract,ENTRY(1,tt-loan.cont-code," "),tt-loan-cond.since,"get").
                /* для каждого транша */
                FOR EACH tloan WHERE (tloan.contract  EQ tt-loan.contract
                                  AND tloan.cont-code BEGINS ENTRY(1,tt-loan.cont-code, " ") + " "
                                  AND NUM-ENTRIES(tloan.cont-code," ") GT 1)
                                 OR  (tloan.contract  EQ tt-loan.contract
                                  AND tloan.cont-code EQ ENTRY(1,tt-loan.cont-code," "))
                    NO-LOCK,
                    
                    LAST tloan-cond WHERE tloan-cond.contract  EQ tloan.contract
                                      AND tloan-cond.cont-code EQ tloan.cont-code
                    NO-LOCK BY NUM-ENTRIES(tloan.cont-code," ") DESC:
    
                   /* считаем кол-во условий на течении */
                   vCondCount = 0.
                   FOR EACH loan-cond WHERE
                            loan-cond.contract  = tloan.contract
                        AND loan-cond.cont-code = tloan.cont-code
                   NO-LOCK:
                      vCondCount = vCondCount + 1.
                   END.
                   /* пересчет графиков */
                   IF NUM-ENTRIES(tloan.cont-code, " ") EQ 1 THEN
                      RUN SetSysConf IN h_Base("НЕ ВЫВОДИТЬ ГРАФИКИ НА ЭКРАН","ДА").
                   IF     NUM-ENTRIES(tloan.cont-code, " ") GT 1 
                      AND tloan.cont-code NE tt-loan.cont-code THEN
                      FIND FIRST term-obl OF tloan WHERE term-obl.idnt EQ 2 NO-ERROR.
                   RUN mm-to.p(RECID(tloan),
                               RECID(tloan-cond),
                               (IF tloan.cont-code EQ tt-loan.cont-code OR NOT AVAIL term-obl THEN tt-amount.amt-rub ELSE term-obl.amt-rub),
                               (IF tloan.cont-code EQ tt-loan.cont-code THEN iMode ELSE {&MOD_EDIT}),
                               vChangeSumm,
                               vChangePr  ,
                               vChangeDate,
                               vChangePer,
                               mRisk,
                               vCondCount) NO-ERROR.
                   IF NUM-ENTRIES(tloan.cont-code, " ") EQ 1 THEN
                      RUN DeleteOldDataProtocol IN h_Base("НЕ ВЫВОДИТЬ ГРАФИКИ НА ЭКРАН").
                   vRet = RETURN-VALUE.
                END.
                /* снова прячем наши графики и делаем сводные графики по %% и ОД, разноску по траншам */
                RUN loansvodgr.p(tt-loan.contract,ENTRY(1,tt-loan.cont-code," "),tt-loan-cond.since,"set").
                IF NUM-ENTRIES(tt-loan.cont-code, " ") GE 1 THEN
                DO:
                   /* ищем первый транш по договору */
                   FIND FIRST loan WHERE
                        loan.contract  EQ tt-loan.contract
                    AND loan.cont-code BEGINS ENTRY(1,tt-loan.cont-code," ") + " "
                    AND NUM-ENTRIES (loan.cont-code," ") EQ 2
                   NO-LOCK NO-ERROR.
                   /* если нашли, то ищем последующий транш */
                   IF AVAIL loan THEN
                   DO:
                      FIND NEXT loan WHERE
                           loan.contract  EQ tt-loan.contract
                       AND loan.cont-code BEGINS ENTRY(1,tt-loan.cont-code," ") + " "
                       AND NUM-ENTRIES (loan.cont-code," ") EQ 2
                      NO-LOCK NO-ERROR.

                      IF NOT AVAIL loan THEN 
                      tr:
                      DO TRANSACTION:
                         FIND FIRST loan-cond WHERE 
                                    loan-cond.contract  EQ tt-loan.contract
                                AND loan-cond.cont-code EQ ENTRY(1,tt-loan.cont-code," ") 
                         EXCLUSIVE-LOCK NO-ERROR.
                         IF AVAIL loan-cond THEN
                         DO:
                            ASSIGN
                              loan-cond.since = tt-loan-cond.since
                            NO-ERROR.
                            IF ERROR-STATUS:ERROR THEN 
                            DO:
                              RUN Fill-SysMes IN h_tmess ("","","1",ERROR-STATUS:GET-MESSAGE(1)).
                              UNDO,LEAVE tr.
                            END.
                         END.
                         ELSE 
                            RUN crCond IN h_loan(tt-loan.contract,ENTRY(1,tt-loan.cont-code," "),tt-loan-cond.since,"").
                      END.
                      ELSE 
                         RUN crCond IN h_loan(tt-loan.contract,ENTRY(1,tt-loan.cont-code," "),tt-loan-cond.since,""). 
                   END.
                END.
             END.
             ELSE
             DO:
                RUN mm-to.p(vRecLoan,
                            vRecCond,
                            tt-amount.amt-rub,
                            iMode,
                            vChangeSumm,
                            vChangePr  ,
                            vChangeDate,
                            vChangePer,
                            mRisk,
                            vCondCount) NO-ERROR.
                vRet = RETURN-VALUE.
             END.
         END.
         vRetLim = "".
         
         /* эти проверки, пришедшие из Связного отключаю, нужно разобраться с 
         ** требованиями и переписать всё заново, избавится от CheckAllLimit,
         ** реализовать каждое требование отдельно
         */
         IF GetXAttrValueEx("loan",
                            tt-loan.contract + "," + ENTRY(1,tt-loan.cont-code," "),
                            "Режим",
                             ?) NE ? THEN
         DO:
   
            /* Находим охватывающий договор */
            FIND FIRST loan WHERE loan.contract  EQ tt-loan.contract
                              AND loan.cont-code EQ ENTRY(1, tt-loan.cont-code, " " )
            NO-LOCK NO-ERROR.
               /* При добавлении транша нужно определить ДР на охватывающем */
            IF tt-loan.LimitGrafDate EQ ? THEN DO:
               tt-loan.LimitGrafDate = date(GetTempXAttrValueEx("loan",
                        loan.contract + "," + loan.cont-code,
                        "LimitGrafDate",
                        date(tt-loan.end-date:screen-value),
                        ?)).
            END.
            vCheckLimit = GetXAttrValueEx("loan",
                                          loan.contract + "," + loan.cont-code,
                                          "CheckLimit",
                                          ?).
            IF NOT {assigned vCheckLimit} THEN
               vCheckLimit = GetXattrInit(loan.class-code, "CheckLimit").
            IF vCheckLimit EQ ? THEN
               vCheckLimit = "Да".
               /* Если требуется, производим проверки лимита */
            IF vCheckLimit EQ "Да" THEN
            DO:
               RUN LimitControl IN h_limit
                  (loan.contract,
                   loan.cont-code,
                   tt-loan.open-date,
                   tt-loan.end-date,
                   OUTPUT vOk,
                   OUTPUT vCheckLimit).
               IF NOT vOk THEN
               DO:
                  RUN Fill-SysMes IN h_tmess ("", "", "-1", vCheckLimit).
                  RETURN ERROR "Ошибка сохранения условий".
               END.
            END.
         END.
         IF iMode EQ {&MOD_ADD} AND tt-loan.alt-contract EQ "mm" THEN
         DO:
            vH = GetProperty(mInstance,"__rowid","__id = 1").
            vRow = vH:BUFFER-VALUE.
            IF vRow NE ? THEN
            DO:
               vRecLoan = Rowid2Recid("Loan",vRow).
               vH = GetProperty(mInstance,"loan-cond:__rowid","__upid = 1 BY since DESC").
               vRow = vH:BUFFER-VALUE.
               vRecCond = Rowid2Recid("Loan-Cond",vRow).
               RUN mm-to.p(vRecLoan,
                           vRecCond,
                           tt-amount.amt-rub,
                           iMode,
                           YES,
                           YES,
                           YES,
                           YES,
                           mRisk,
                           vCondCount) NO-ERROR.
               vRet1 = RETURN-VALUE.
            END.
         END.

         RUN DeleteOldDataProtocol IN h_base("ПЛАТЕЖИ ПО ПРОЦЕНТАМ СДВИГ").
         RUN DeleteOldDataProtocol IN h_base("ОБЯЗАТЕЛЬСТВА ПО ВОЗВРАТУ СДВИГ").
         RUN DeleteOldDataProtocol IN h_base("СделкаММ").
         IF vRet EQ {&RET-ERROR} OR vRet1 EQ {&RET-ERROR} THEN
         DO:
            mRetVal = {&RET-ERROR}.
            RETURN ERROR "Ошибка сохранения условий".
         END.
      END.
      IF iMode EQ {&MOD_ADD} AND
         tt-loan.stream-show EQ YES AND
         tt-loan.cont-type EQ "Течение" THEN
      DO TRANS:
         RUN "loan(ch.p"(tt-loan.contract,tt-loan.cont-code,0,0,iLevel).
         IF LASTKEY EQ 27 THEN
         DO:
            READKEY PAUSE 0.
            MESSAGE "Прервать обработку?"
               VIEW-AS ALERT-BOX QUESTION
               BUTTONS YES-NO UPDATE vUndo AS LOG.
            IF vUndo EQ YES THEN
               RETURN ERROR "Обработка прервана".
         END.
      END.
      IF tt-loan.alt-contract EQ "mm" THEN
      DO:
         RUN mm-pay.p(?,?,
             GetInstanceProp(mInstance,"class-code"),
             GetInstanceProp(mInstance,"contract") + "," + GetInstanceProp(mInstance,"cont-code"),
             - iMode,0). /* - чтоб не сбился суррогат при MOD_ADD */
      END.

      RUN GET_COMM_LOAN_BUF IN h_Loan (tt-loan.contract,
                                       tt-loan.cont-code,
                                       "%Рез",
                                       tt-loan.since,
                                       BUFFER comm-rate).

      IF NOT AVAILABLE comm-rate
         AND NUM-ENTRIES (tt-loan.cont-code, " ") = 2
         AND NOT CAN-FIND (loan WHERE loan.contract  = tt-loan.contract
                                  AND loan.cont-code = tt-loan.cont-code
                                  AND loan.cont-type = "Течение"
                           NO-LOCK)
      THEN
          RUN GET_COMM_LOAN_BUF IN h_Loan (tt-loan.contract,
                                          ENTRY (1, tt-loan.cont-code, " "),
                                          "%Рез",
                                          tt-loan.since,
                                          BUFFER comm-rate).

      IF AVAILABLE comm-rate
      THEN
         UpdateSignsEx("comm-rate",
                       STRING(comm-rate.commission) + "," +
                       STRING(comm-rate.acct) + "," +
                       STRING(tt-loan.currency) + "," +
                       PushSurr(comm-rate.kau) + "," +
                       string(comm-rate.min-value) + "," +
                       STRING(comm-rate.period) + "," +
                       STRING(comm-rate.since),
                       "КатегорияКач",
                       STRING(mGrRiska)).

      FOR EACH tt-comm-rate NO-LOCK:

         msurrcr2 = STRING(tt-comm-rate.commission) + "," +
                    STRING(tt-comm-rate.acct) + "," +
                    STRING(tt-loan.currency) + "," +
                    PushSurr(STRING(tt-loan.contract) + "," + STRING(tt-loan.cont-code)) + "," +
                    string(tt-comm-rate.min-value) + "," +
                    STRING(tt-comm-rate.period) + "," +
                    STRING(tt-loan-cond.since)
               .

         UpdateSignsEx("comm-rate-loan",
                        msurrcr2,
                       "МинЗнач",
                       STRING(tt-comm-rate.min_value)
            ) .

         IF tt-comm-rate.commission EQ "%Рез"
         THEN DO:
            RUN LnGetRiskGrOnDate IN h_i254 (mRisk,
                                             tt-loan.open-date,
                                             OUTPUT vGrRisk).
            IF vGrRisk NE mGrRiska
            THEN DO:
               RUN LnGetRiskGrList IN h_i254 (mRisk,
                                              tt-loan.open-date,
                                              YES,
                                              OUTPUT vListGrRiska).
               IF CAN-DO(vListGrRiska,STRING(mGrRiska))
               THEN
                  UpdateSignsEx("comm-rate-loan",
                                msurrcr2,
                                "КатегорияКач",
                                STRING(mGrRiska)).

            END.
         END.
      END.

            /* Автоматическая простановка процента резервирования по внебалансу */
      IF     iMode EQ {&MOD_ADD}
         AND LOGICAL(FGetSetting("АвтоПроцРезВн","","Нет"),"Да/Нет")
      THEN
      BLK:
      DO ON ERROR  UNDO BLK, LEAVE BLK
         ON ENDKEY UNDO BLK, LEAVE BLK:
         RUN LnGetRiskGrOnDate IN h_i254 (mRisk,
                                          tt-loan.open-date,
                                          OUTPUT vGrRisk).
         RUN LnGetRiskGrList IN h_i254 (mRisk,
                                        tt-loan.open-date,
                                        YES,
                                        OUTPUT vListGrRiska).
         FIND LAST loan-acct WHERE loan-acct.contract  EQ tt-loan.contract
                               AND loan-acct.cont-code EQ tt-loan.cont-code
                               AND loan-acct.acct-type EQ "КредЛин"
                               AND loan-acct.since     LE tt-loan.open-date
         NO-LOCK NO-ERROR.
         IF NOT AVAIL loan-acct THEN
            FIND LAST loan-acct WHERE loan-acct.contract  EQ tt-loan.contract
                                  AND loan-acct.cont-code EQ tt-loan.cont-code
                                  AND loan-acct.acct-type EQ "КредН"
                                  AND loan-acct.since     LE tt-loan.open-date
            NO-LOCK NO-ERROR.

         IF     NOT AVAIL loan-acct
            OR (NOT FGetSetting("ИндПрРезВн","","Нет") BEGINS "Да"
            AND IF IsTemporal("acct","ИндПрРез")
                 THEN (GetTempXAttrValueEx("acct",loan-acct.acct + ',' + loan-acct.currency,"ИндПрРез",tt-loan.open-date,"Нет") NE "Да")
                 ELSE (GetXAttrValue("acct",loan-acct.acct + ',' + loan-acct.currency,"ИндПрРез") NE "Да"))
         THEN LEAVE BLK.

         FIND FIRST acct WHERE acct.acct     EQ loan-acct.acct
                           AND acct.currency EQ loan-acct.currency
         NO-LOCK NO-ERROR.
         IF NOT AVAIL acct THEN LEAVE BLK.

                  /* Если группа задана вручную и номер группы допустим, то используем его.
                  ** Иначе тот, который определил LnGetRiskGrList */
         mGrRiskVn = IF CAN-DO(vListGrRiska,STRING(mGrRiska)) THEN mGrRiska ELSE vGrRisk.
                  /* Определяем минимальное для устанавливаемой категории качества значение к-та резервирования */
         RUN LnGetPersRsrvOnDate IN h_i254 (mGrRiskVn,tt-loan.open-date,OUTPUT mMinRate).

                  /* если мин.ставка для кат.кач-ва и установленная на счету различаются */
         IF mMinRate NE GET_COMM("%Рез",RECID(acct),acct.currency,"",0,0,tt-loan.open-date) THEN
         BLK2:
         DO ON ERROR  UNDO BLK2, LEAVE BLK2
            ON ENDKEY UNDO BLK2, LEAVE BLK2:
                     /* Запрос подтверждения рассчитанной ставки или указания необходимой */
            PAUSE 0.
            UPDATE mMinRate FORMAT ">>>>>>>>9.9999"
                            LABEL "      Ставка коэффициента резервирования по внебалансу"
               WITH FRAME fRate COLOR messages
               TITLE "[ ПОДТВЕРДИТЕ СТАВКУ ИЛИ ЗАДАЙТЕ НЕОБХОДИМУЮ ]"
               OVERLAY CENTERED ROW 10 SIDE-LABELS.
            IF LAST-EVENT:FUNCTION EQ "END-ERROR" THEN LEAVE BLK2.

            FIND FIRST bcomm-rate WHERE bcomm-rate.commission EQ "%Рез"
                                    AND bcomm-rate.filial-id  EQ shfilial
                                    AND bcomm-rate.branch-id  EQ ""
                                    AND bcomm-rate.acct       EQ acct.acct
                                    AND bcomm-rate.currency   EQ acct.currency
                                    AND bcomm-rate.kau        EQ ""
                                    AND bcomm-rate.MIN-VALUE  EQ 0
                                    AND bcomm-rate.period     EQ 0
                                    AND bcomm-rate.since      EQ tt-loan.open-date
            EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAIL bcomm-rate THEN
               CREATE bcomm-rate.
            ASSIGN
               bcomm-rate.commission = "%Рез"
               bcomm-rate.acct       = acct.acct
               bcomm-rate.currency   = acct.currency
               bcomm-rate.kau        = ""
               bcomm-rate.MIN-VALUE  = 0
               bcomm-rate.period     = 0
               bcomm-rate.since      = tt-loan.open-date
               bcomm-rate.rate-comm  = mMinRate
               .
            IF IsTemporal("comm-rate","КатегорияКач") THEN
               UpdateTempSignsEx("comm-rate",                                
                                bcomm-rate.commission        + "," +
                                bcomm-rate.acct              + "," +
                                bcomm-rate.currency          + "," +
                                PushSurr(bcomm-rate.kau)     + "," +
                                STRING(bcomm-rate.min-value) + "," +
                                STRING(bcomm-rate.period)    + "," +
                                STRING(bcomm-rate.since),
                                "КатегорияКач",
                                tt-loan.open-date,
                                STRING(mGrRiskVn),
                                ?).
            ELSE
               UpdateSignsEx("comm-rate",
                             bcomm-rate.commission        + "," +
                             bcomm-rate.acct              + "," +
                             bcomm-rate.currency          + "," +
                             PushSurr(bcomm-rate.kau)     + "," +
                             STRING(bcomm-rate.min-value) + "," +
                             STRING(bcomm-rate.period)    + "," +
                             STRING(bcomm-rate.since),
                             "КатегорияКач",
                             STRING(mGrRiskVn)).
         END.
         HIDE FRAME fRate.
      END.

   END.
      /* Для сводных графиков */
   IF     iMode EQ {&MOD_ADD}
      AND AVAIL tt-instance THEN
   DO:
      FIND FIRST b-loan WHERE
                 b-loan.contract  EQ tt-loan.contract
         AND     b-loan.cont-code EQ ENTRY(1, tt-loan.cont-code, " ")
      NO-LOCK NO-ERROR.
      IF     AVAIL b-loan 
         AND b-loan.class-code NE "loan-transh-ann" THEN
      DO:
         IF GetXAttrValue("loan", b-loan.contract + "," + b-loan.cont-code, "СводГрАвто") EQ "Да" THEN
         DO:
               /* Проверка графика и формирование временных таблиц для разноски по траншам */
            RUN CheckTermCorr (tt-loan.contract,
                               ENTRY(1, tt-loan.cont-code, " "),
                               OUTPUT vOK).
               /* Если все ОК, тогда запускаем копирование разнесенного по траншам графика из временных
               ** таблиц в настоящие графики траншей. Предварительно с траншей удаляются старые графики */
            IF vOK THEN
            DO:
               RUN DividTermSumm (tt-loan.contract,
                                  ENTRY(1, tt-loan.cont-code, " "))
               NO-ERROR.
                  /* Обработка ошибок создания графиков */
               IF    ERROR-STATUS:ERROR
                  OR RETURN-VALUE NE "" THEN
                  RUN Fill-SysMes IN h_tmess ("", "", "-1", RETURN-VALUE).
               ELSE
                  RUN Fill-SysMes IN h_tmess ("", "", "0",
                                              "Разноска графика завершена.").
            END.
         END.
      END.
   END.  /* Для сводных графиков */
   
  /* Для ввода ПОС в новом договоре */
   IF     iMode EQ {&MOD_ADD}
          AND  mBag <> ""
   THEN DO:
      RUN bagadd.p (
         INPUT tt-loan.contract,
         INPUT tt-loan.cont-code,
         INPUT mBag,
         INPUT tt-loan.open-date,
         INPUT gEnd-date
         ) NO-ERROR .
         IF ERROR-STATUS :ERROR THEN DO:
            RUN Fill-SysMes IN h_tmess ("", "", "1", RETURN-VALUE).
         END.
   END.

   IF iMode EQ {&MOD_ADD} AND GetXAttrInit(tt-loan.class-code,"РасчЭПС") EQ "ДА"
   THEN
   DO:          
      UpdateSigns(
         tt-loan.Class-Code,
         tt-loan.contract + "," + tt-loan.cont-code,
         "пир_ЭПС",
         STRING(
            GetEpsLoan(
               tt-loan.contract, 
               tt-loan.cont-code,
               tt-loan.open-date) 
            * 100),
         ?).
   END.

   RUN DeleteOldDataProtocol IN h_base ("ОкруглениеДоРублей").

   vRaschInstr = GetXattrInit (tt-loan.Class-Code,"ВводРасчИнстр").
   
   FIND FIRST loan WHERE 
              loan.contract  EQ tt-loan.contract
          AND loan.cont-code EQ ENTRY(1,tt-loan.cont-code," ")
          NO-LOCK NO-ERROR.
   
   IF     (AVAIL loan) 
      AND (vRaschInstr EQ "Да") THEN
   DO:
      RUN Fill-SysMes IN h_tmess 
        ("","",4,"Возможен ввод сокращенной расчетной инструкции. Будем вводить?").
      IF pick-value EQ "yes" THEN
         RUN getsettl1.p(RECID(loan),loan.open-date).
   END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetTariffCommRate TERMINAL-SIMULATION
PROCEDURE SetTariffCommRate :
/*------------------------------------------------------------------------------
  Purpose:     Устанавливаем ставки по тарифу
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   DEF INPUT PARAM iTariffCode AS CHAR NO-UNDO.
   DEF BUFFER comm-rate FOR comm-rate.

      /* Если тариф найден, то заводим ставки по нему на договор */
   IF     iTariffCode NE ?
      AND iTariffCode NE ""
      AND iTariffCode NE "?" THEN
   DO:
         /* Тянем все ставки по коду тарифа */
      cc:
      FOR EACH xbcomm-rate WHERE
               xbcomm-rate.kau       EQ "ПродТрф," + iTariffCode
      BREAK BY commission:
         IF FIRST-OF(xbcomm-rate.commission) THEN
         DO:
            FIND LAST comm-rate WHERE               
                      comm-rate.kau        EQ xbcomm-rate.kau
                AND   comm-rate.commission EQ xbcomm-rate.commission
                AND   comm-rate.currency   EQ tt-loan.currency
                AND   comm-rate.since      LE tt-loan.open-date
            NO-LOCK NO-ERROR.
           IF   NOT AVAIL comm-rate 
             OR comm-rate.rate-comm LE 0 THEN
              NEXT cc.
 
            /* Если ставка уже есть, то "перекрываем" ее значение из тарифа */
            FIND FIRST tt-comm-rate WHERE
                       tt-comm-rate.commission EQ comm-rate.commission
            NO-ERROR.
            IF NOT AVAIL tt-comm-rate THEN
               CREATE tt-comm-rate.    /* - создаем */
               /* и перерекрываем, если нет */
            ASSIGN
               tt-comm-rate.commission      = comm-rate.commission
               tt-comm-rate.acct            = comm-rate.acct
               tt-comm-rate.currency        = comm-rate.currency
               tt-comm-rate.period          = comm-rate.period
               tt-comm-rate.rate-fixed      = comm-rate.rate-fixed
               tt-comm-rate.min-value       = comm-rate.min-value
               tt-comm-rate.since           = tt-loan-cond.since
               tt-comm-rate.rate-comm       = comm-rate.rate-comm
               tt-comm-rate.local__template = YES
               tt-comm-rate.local__id       = GetInstanceId("tt-comm-rate") + mI
               mI                           = mI + 1
            .
         END.
      END.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetTermObl TERMINAL-SIMULATION
PROCEDURE SetTermObl :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   /* Если только создаем договор, то дата может быть неверной,
   ** например, если сначало ввели месяцы исключ.,
   ** а потом поменяли дату открытия */
   IF iMode EQ {&MOD_ADD} THEN
       FOR EACH ttTermObl:
           ttTermObl.end-date = tt-loan-cond.since.
       END.

/* если месяцев исключения нет и не было, то на этом проверки завершены */
   IF NOT CAN-FIND(FIRST ttTermObl WHERE ttTermObl.idnt = 200 NO-LOCK)
      AND tt-monthout.contract = "" THEN .


   /*если были месяцы исключений, то нужно их обновить*/

   /* если месяцы исключений были. но теперь мы их удалили (все) */
   ELSE IF NOT CAN-FIND(FIRST ttTermObl WHERE ttTErmObl.idnt = 200 NO-LOCK)
       THEN DO:
       FOR EACH tt-monthout:
           tt-monthout.user__mode = {&MOD_DELETE}.
       END.
   END.

   ELSE DO:

      /* чистим таблицу меяцев исключения */
      FOR EACH tt-monthout:
         FIND FIRST ttTermObl WHERE
                    ttTermObl.contract = tt-monthout.contract
                AND ttTermObl.cont-code = tt-monthout.cont-code
                AND ttTermObl.end-date = tt-monthout.end-date
                AND ttTermObl.idnt = tt-monthout.idnt
                AND ttTermObl.nn = tt-monthout.nn
             NO-ERROR.

         IF NOT AVAIL ttTermObl THEN
            tt-monthout.user__mode = {&MOD_DELETE}.
      END.

       /* заполняем таблицу услуг данными из верменной таблицы */
       FOR EACH ttTermObl WHERE
                ttTermObl.contract = tt-loan.contract
            AND ttTermObl.cont-code = tt-loan.cont-code
            AND ttTermObl.idnt = 200:

          FIND FIRST tt-monthout WHERE
                     tt-monthout.contract = ttTermObl.contract
                 AND tt-monthout.cont-code = ttTermObl.cont-code
                 AND tt-monthout.end-date = ttTermObl.end-date
                 AND tt-monthout.idnt = ttTermObl.idnt
                 AND tt-monthout.nn = ttTermObl.nn
              NO-ERROR.


          IF NOT AVAIL tt-monthout THEN
          DO:

              CREATE tt-monthout.
              FOR EACH b-monthout BY b-monthout.Local__Id DESC:
                 LEAVE.
              END.
              ASSIGN
                 tt-monthout.Local__UpId = tt-loan.local__Id.
                 tt-monthout.Local__Id = IF AVAIL b-monthout THEN
                                        MAX(GetInstanceId("tt-monthout"),
                                            b-monthout.Local__Id) + 1
                                        ELSE GetInstanceId("tt-monthout") + 1.

          END.

          BUFFER-COPY ttTermObl TO tt-monthout.

          RELEASE tt-monthout.

       END.
   END.

   /* если особых месяцев нет и не было, то на этом проверки завершены */
   IF NOT CAN-FIND(FIRST ttTermObl WHERE ttTermObl.idnt = 201 NO-LOCK)
      AND tt-monthspec.contract = "" THEN .


   /*если были особые месяцы, то нужно их обновить*/

   /* если особые месяцы были, но теперь мы их удалили (все) */
   ELSE IF NOT CAN-FIND(FIRST ttTermObl WHERE ttTermObl.idnt = 201 NO-LOCK)
       THEN DO:
       FOR EACH tt-monthspec:
           tt-monthspec.user__mode = {&MOD_DELETE}.
       END.
   END.

   ELSE DO:

      /* чистим таблицу меяцев исключения */
      FOR EACH tt-monthspec:
         FIND FIRST ttTermObl WHERE
                    ttTermObl.contract = tt-monthspec.contract
                AND ttTermObl.cont-code = tt-monthspec.cont-code
                AND ttTermObl.idnt = tt-monthspec.idnt
                AND ttTermObl.nn = tt-monthspec.nn
             NO-ERROR.
         IF NOT AVAIL ttTermObl THEN
         tt-monthspec.user__mode = {&MOD_DELETE}.
      END.

       /* заполняем таблицу услуг данными из верменной таблицы */
       FOR EACH ttTermObl WHERE
                ttTermObl.contract = tt-loan.contract
            AND ttTermObl.cont-code = tt-loan.cont-code
            AND ttTermObl.idnt = 201:

          FIND FIRST tt-monthspec WHERE
                     tt-monthspec.contract = ttTermObl.contract
                 AND tt-monthspec.cont-code = ttTermObl.cont-code
                 AND tt-monthspec.end-date = ttTermObl.end-date
                 AND tt-monthspec.idnt = ttTermObl.idnt
                 AND tt-monthspec.nn = ttTermObl.nn
              NO-ERROR.

          IF NOT AVAIL tt-monthspec THEN
          DO:

              CREATE tt-monthspec.
              FOR EACH b-monthspec BY b-monthspec.Local__Id DESC:
                 LEAVE.
              END.
              ASSIGN
                 tt-monthspec.Local__UpId = tt-loan.local__Id.
                 tt-monthspec.Local__Id = IF AVAIL b-monthspec THEN
                                        MAX(GetInstanceId("tt-monthspec"),
                                            b-monthspec.Local__Id) + 1
                                        ELSE GetInstanceId("tt-montspec") + 1.

          END.

          BUFFER-COPY ttTermObl TO tt-monthspec.

          RELEASE tt-monthspec.

       END.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ModCommRate TERMINAL-SIMULATION
PROCEDURE ModCommRate:
/*------------------------------------------------------------------------------
  Purpose: Модификация ставок
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   DEF INPUT PARAM iProd AS CHAR NO-UNDO.   /* Продукт */

   DEF VAR vZnak AS CHAR NO-UNDO.

   DEF BUFFER comm-rate FOR comm-rate.

   FOR EACH tt-comm-rate:
      FIND LAST comm-rate WHERE
                comm-rate.kau        EQ "Модификатор," + iProd
            AND comm-rate.commission EQ tt-comm-rate.commission
            AND comm-rate.since      LE tt-loan.open-date
      NO-LOCK NO-ERROR.
      IF AVAIL comm-rate THEN DO:
         vZnak = GetXAttrValueEx("comm-rate",
                                 GetSurrogateBuffer("comm-rate",
                                                    (BUFFER comm-rate:HANDLE)
                                                    ),
                                 "ЗнакМод",
                                 "+").
         CASE vZnak:
            WHEN "+" THEN
               tt-comm-rate.rate-comm = tt-comm-rate.rate-comm + comm-rate.rate-comm.
            WHEN "-" THEN
               tt-comm-rate.rate-comm = tt-comm-rate.rate-comm - comm-rate.rate-comm.
         END CASE.
      END.
   END.
END PROCEDURE. /* ModCommRate */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CheckCliAcct TERMINAL-SIMULATION
FUNCTION CheckCliAcct RETURNS LOGICAL
  ( INPUT iAcctType AS CHAR,
    INPUT iAcct AS CHAR,
    INPUT iCurr AS CHAR,
    INPUT iCat AS CHAR,
    INPUT iId AS INT64 ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
   DEFINE VARIABLE vRet AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE vChk AS CHARACTER  NO-UNDO.
   vChk = GetBufferValue("code",
                         "where code.class = 'ТипСчДог' and code.parent = 'ТипСчДог'" +
                         "   and code.code = '" + iAcctType + "'",
                         "misc").
   vChk = ENTRY(1,vChk,CHR(1)).
   vRet = YES.
   IF CAN-DO("Да,Yes",vChk) THEN
      vRet =  GetBufferValue("acct",
                             "where acct = '" + iAcct + "'" +
                             "  and currency = '" + iCurr + "'" +
                             "  and cust-cat = '" + iCat + "'" +
                             "  and cust-id = " + STRING(iId),
                             "acct") EQ iAcct.
   RETURN vRet.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetQntPer TERMINAL-SIMULATION
FUNCTION GetQntPer RETURNS INT64 (
   INPUT iBegDate  AS DATE, /* дата открытия договора */
   INPUT iEndDate  AS DATE, /* зата закрытия договора */
   INPUT iPayDay   AS INT64,  /* число, кот. производ. операция (только М и К) */
   INPUT iGlInt    AS CHAR, /* интервал м/у плановыми операциями */
   INPUT iCondBegD AS DATE  /* дата начала условия, используется при расчете даты при К или ПГ
                             ** если ? то отрабатывать доп.проверка не будет */
):

   DEF VAR mCurDate     AS DATE   NO-UNDO. /* очередная дата платежа */
   DEF VAR mCurDateOld  AS DATE   NO-UNDO. /* Старая дата очередного платежа */
   DEF VAR mPerCnt      AS INT64    NO-UNDO. /* счетчик периодов */

   mCurDate = iBegDate.

      /* считаем число периодов */
   CNT:
   DO WHILE mCurDate < iEndDate:
      IF mCurDateOld EQ mCurDate
      THEN
         mCurDate = mCurDate + 1.
      mCurDateOld = mCurDate.
      mCurDate = FRST_DATE(mCurDate,
                           iEndDate,
                           iPayDay,
                           iGlInt,
                           iCondBegD).

      /* дата попадает в месяц без погашения */
      IF (CAN-FIND (FIRST ttTermObl WHERE ttTermObl.contract  EQ tt-loan.contract
                                     AND ttTermObl.cont-code EQ tt-loan.cont-code
                                     AND ttTermObl.idnt      EQ 200
                                     AND INT64(ttTermObl.amt)  EQ MONTH(mCurDate)
                                     AND ttTermObl.end-date  LE mCurDate
                   NO-LOCK)
         /* и месяца и года даты нет в списке ВКЛЮЧИТЬ */
         AND NOT CAN-FIND
                  (FIRST ttTermObl WHERE ttTermObl.contract   EQ tt-loan.contract
                                     AND ttTermObl.cont-code  EQ tt-loan.cont-code
                                     AND ttTermObl.idnt       EQ 201
                                     AND ttTermObl.sop-offbal EQ 1         /* ВКЛЮЧИТЬ */
                                     AND INT64(ttTermObl.amt)   EQ MONTH(mCurDate)
                                     AND INT64(ttTermObl.sop)   EQ YEAR (mCurDate)
                   NO-LOCK))
         /* или месяц и год даты есть в списке ИСКЛЮЧИТЬ */
         OR CAN-FIND
                  (FIRST ttTermObl WHERE ttTermObl.contract   EQ tt-loan.contract
                                     AND ttTermObl.cont-code  EQ tt-loan.cont-code
                                     AND ttTermObl.idnt       EQ 201
                                     AND ttTermObl.sop-offbal NE 1         /* ИСКЛЮЧИТЬ */
                                     AND INT64(ttTermObl.amt)   EQ MONTH(mCurDate)
                                     AND INT64(ttTermObl.sop)   EQ YEAR (mCurDate)
                   NO-LOCK)
      THEN NEXT CNT.    /* не считаем исключенные месяцы */
      mPerCnt = mPerCnt + 1.
   END.
   RETURN mPerCnt.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

