{pirsavelog.p}

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
       FIELD nomerpp$ AS INTEGER /* НомерПП (Порядковый номер) */
       FIELD opisanie$ AS CHARACTER /* Описание (Описание предмета обеспечения) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INTEGER   /* Идентификатор записи     */
       FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
       
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-amount" "amount" }
       .
DEFINE TEMP-TABLE tt-broker NO-UNDO LIKE cust-role
       FIELD contract AS CHARACTER /* contract (Номер договора) */
       FIELD HiddenFields AS CHARACTER /* HiddenFields (Список скр. полей в завис. от Ver-format) */
       FIELD is_mandatory AS LOGICAL /* is_mandatory (Основная роль) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INTEGER   /* Идентификатор записи     */
       FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
       INDEX cust-role-id cust-role-id
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-broker" "broker" }
       .
DEFINE TEMP-TABLE tt-comm-rate NO-UNDO LIKE comm-rate
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INTEGER   /* Идентификатор записи     */
       FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
       INDEX local__id IS UNIQUE local__id
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-comm-rate" "loan-cond:comm-rate" }
       .
DEFINE TEMP-TABLE tt-commrate NO-UNDO LIKE comm-rate
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INTEGER   /* Идентификатор записи     */
       FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
       
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-commrate" "commrate" }
       .
DEFINE TEMP-TABLE tt-contragent NO-UNDO LIKE cust-role
       FIELD contract AS CHARACTER /* contract (Номер договора) */
       FIELD HiddenFields AS CHARACTER /* HiddenFields (Список скр. полей в завис. от Ver-format) */
       FIELD is_mandatory AS LOGICAL /* is_mandatory (Основная роль) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INTEGER   /* Идентификатор записи     */
       FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
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
       FIELD local__id       AS INTEGER   /* Идентификатор записи     */
       FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
       INDEX cust-role-id cust-role-id
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-dealer" "dealer" }
       .
DEFINE TEMP-TABLE tt-loan NO-UNDO LIKE loan
			 FIELD SafePlastType AS CHAR /* Тип пластиковой карты */
			 FIELD SafePlastLNum AS CHAR /* Номер договора пластиковой карты */
			 FIELD SafePlastLDate AS DATE /* Дата договора пластиковой карты */
			 FIELD clientCode AS CHARACTER /* Код клиента, полученный от внешней системы */
			 FIELD firstAgent AS CHARACTER /* Первое доверенное лицо */
			 FIELD firstAgntDate AS DATE /* Дата доверенности первого дов.лица */
			 FIELD secondAgent AS CHARACTER /* Второе доверенное лицо */
			 FIELD secondAgntDate AS DATE /* Дата доверенности второго дов.лица */
       FIELD SafePeriod AS CHARACTER /* Период аренды сейфовой ячейки */
       FIELD SafeNumber AS CHARACTER /* Номер сейфовой ячейки */
       FIELD akt_vzv$ AS CHARACTER /* Акт_взв (Активы взешенные с учетом риска) */
       FIELD grup_dog$ AS CHARACTER /* Груп_дог (Группа договора) */
       FIELD datasogl$ AS DATE /* ДатаСогл (Дата заключения кредитного договора) */
       FIELD data_uar$ AS CHARACTER /* Дата_УАР (Номер и дата подтверждения УАР) */
       FIELD dosroka$ AS CHARACTER /* ДоСРОКА (Нельзя снимать средства до срока) */
       FIELD cred-offset AS CHARACTER
       FIELD int-offset AS CHARACTER
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
       FIELD ovrpr$ AS INTEGER
       FIELD ovrstop$ AS INTEGER
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INTEGER   /* Идентификатор записи     */
       FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
       FIELD rate-list AS CHARACTER
       FIELD stream-show AS LOGICAL
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-loan" "" }
       .
DEFINE TEMP-TABLE tt-loan-acct NO-UNDO LIKE loan-acct
       FIELD class-code AS CHARACTER /* class-code (Класс loan-acct) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INTEGER   /* Идентификатор записи     */
       FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
       
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-loan-acct" "loan-acct" }
       .
DEFINE TEMP-TABLE tt-loan-acct-cust NO-UNDO LIKE loan-acct
       FIELD class-code AS CHARACTER /* class-code (Класс loan-acct) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INTEGER   /* Идентификатор записи     */
       FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
       
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-loan-acct-cust" "loan-acct-cust" }
       .
DEFINE TEMP-TABLE tt-loan-acct-main NO-UNDO LIKE loan-acct
       FIELD class-code AS CHARACTER /* class-code (Класс loan-acct) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INTEGER   /* Идентификатор записи     */
       FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
       
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-loan-acct-main" "loan-acct-main" }
       .
DEFINE TEMP-TABLE tt-loan-cond NO-UNDO LIKE loan-cond
       FIELD annuitplat$  AS DECIMAL /* АннуитПлат (Сумма аннуитетного платежа) */
       FIELD end-date AS DATE /* end-date (Дата окончания) */
       FIELD EndDateBeforeProl AS DATE /* EndDateBeforeProl (Дата окончания вклада до пролонгации) */
       FIELD kollw#gtper$ AS INTEGER /* КолЛьгтПер (Количество льготных периодов) */
       FIELD Prolong AS LOGICAL /* Prolong (Пролонгция вклада) */
       FIELD shemaplat$ AS LOGICAL /* СхемаПлат (Схема платежа) */
       FIELD Test01 AS CHARACTER /* Test01 (Test01) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INTEGER   /* Идентификатор записи     */
       FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
       
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-loan-cond" "loan-cond" }
       .
DEFINE TEMP-TABLE tt-percent NO-UNDO LIKE term-obl
       FIELD viddogob$ AS CHARACTER /* ВидДогОб (Вид договора обеспечения) */
       FIELD vidob$ AS CHARACTER /* ВидОб (Вид предмета обеспечения) */
       FIELD datapost$ AS DATE /* ДатаПост (Дата поступления) */
       FIELD dopinfo$ AS CHARACTER /* ДопИнфо (Дополнительная информация) */
       FIELD mestonahowzdenie$ AS CHARACTER /* Местонахождение (Местонахождение имущества) */
       FIELD nomdogob$ AS CHARACTER /* НомДогОб (Номер договора обеспечения) */
       FIELD nomerpp$ AS INTEGER /* НомерПП (Порядковый номер) */
       FIELD opisanie$ AS CHARACTER /* Описание (Описание предмета обеспечения) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INTEGER   /* Идентификатор записи     */
       FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
       
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
       FIELD nomerpp$ AS INTEGER /* НомерПП (Порядковый номер) */
       FIELD opisanie$ AS CHARACTER /* Описание (Описание предмета обеспечения) */
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INTEGER   /* Идентификатор записи     */
       FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
        
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
     Modified: 
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
**    8. Используйчте процедуру LocalSetObject, которая будет вызываться,
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
{intrface.get db2l}
{intrface.get fx}
{intrface.get mm}
{intrface.get i254}
{deal.def}
{loan.pro}

&GLOBAL-DEFINE BASE-TABLE tt-loan

DEFINE TEMP-TABLE tmp-loan NO-UNDO LIKE loan.

&GLOBAL-DEFINE InstanceFile loan

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define DISPLAYED-FIELDS tt-loan.cont-type tt-loan.SafePeriod tt-loan.SafeNumber tt-loan.cust-cat tt-loan.cust-id tt-loan.cont-code ~
tt-loan.open-date tt-loan.end-date tt-loan.close-date tt-loan.doc-num  /**tt-loan.currency*/ tt-loan.clientCode ~
tt-loan.SafePlastType tt-loan.SafePlastLNum tt-loan.SafePlastLDate
&Scoped-define DISPLAYED-TABLES tt-loan tt-amount tt-percent ~
tt-loan-acct-main tt-loan-acct-cust tt-loan-cond tt-dealer tt-broker
&Scoped-define FIRST-DISPLAYED-TABLE tt-loan
&Scoped-define SECOND-DISPLAYED-TABLE tt-amount
&Scoped-define THIRD-DISPLAYED-TABLE tt-percent
&Scoped-define FOURTH-DISPLAYED-TABLE tt-loan-acct-main
&Scoped-define FIFTH-DISPLAYED-TABLE tt-loan-acct-cust
&Scoped-define SIXTH-DISPLAYED-TABLE tt-loan-cond
&Scoped-define SEVENTH-DISPLAYED-TABLE tt-dealer
&Scoped-define EIGHTH-DISPLAYED-TABLE tt-broker
&Scoped-Define DISPLAYED-OBJECTS CustName1 SafeDetails SafePeriodDetails endRate firstAgentDetails secondAgentDetails

/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 tt-loan.cont-type tt-loan.SafeNumber tt-loan.cust-cat tt-loan.cust-id tt-loan.cont-code ~
		tt-loan.open-date tt-loan.open-date tt-loan.SafePeriod tt-loan.end-date tt-loan.close-date tt-loan.doc-num ~
		/**tt-loan.currency*/ tt-loan.firstAgent tt-loan.firstAgntDate tt-loan.secondAgent tt-loan.secondAgntDate ~
		tt-loan.clientCode endRate tt-loan.SafePlastType ~
		tt-loan.SafePlastLNum tt-loan.SafePlastLDate
&Scoped-define List-2 tt-loan.doc-num tt-loan.close-date
&Scoped-define List-3 tt-loan.SafeNumber tt-loan.doc-num tt-loan.cust-id ~
		tt-loan.SafePeriod tt-loan.firstAgent tt-loan.firstAgntDate tt-loan.secondAgent tt-loan.secondAgntDate tt-loan.clientCode
&Scoped-define List-4 /* btnGetAcct */
&Scoped-define List-5 CustName1 SafeDetails SafePeriodDetails endRate firstAgentDetails secondAgentDetails

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CheckCliAcct TERMINAL-SIMULATION 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE CustName1 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN 
     SIZE 41 BY 1 NO-UNDO.
/* Номер ячейки */

/** Временные переменные для вычисления даты окончания договора по 
 *  выбранному периоду
 */
DEF VAR tmpDate AS DATE NO-UNDO.
DEFINE VARIABLE countM AS INTEGER NO-UNDO.
DEFINE VARIABLE countW AS INTEGER NO-UNDO.
/** Переменные для хранения информации, с помощью которой 
 *  расчитывается сумма арендной платы за ячейку.
 */
DEF VAR baseRate AS DECIMAL NO-UNDO. /** базовая комиссия за ячейку, т.е. ком. за минимальный срок аренды */
DEF VAR ratio AS INTEGER NO-UNDO. /** коэффициент умножения базовой комиссии, находится из период */
/** Поле, в котором вычисляется и хранится значение арендной платы за ячейку. Доступно для редактирования 
 *  в случае ненулевого значения в поле tt-loan.SafePeriod 
 */
DEF VAR endRate AS DECIMAL FORMAT "->>>,>>9.99":U
	  VIEW-AS FILL-IN SIZE 11 BY 1 NO-UNDO.
/*	Текущее значение кол-ва оформленных договоров для ячейки,
		выбранной в поле tt-loan.SafeNumber
*/
DEFINE VARIABLE CountAgreeForSafe AS INTEGER NO-UNDO.
/* Поток вывода в файл для обмена с системой пластиковых карт */
DEFINE STREAM outStream.
/* Поток ввода из файла для обмена с системой	пластиковых карт */
DEFINE STREAM inStream.
/* Поток ввода содержимого каталога обмена */
DEFINE STREAM listDirExch.
/** Протокол обмена */
DEFINE STREAM logStream.
/* Имя файла без расширения для обмена с системой пластиковых карт */
DEFINE VAR fileName AS CHAR  NO-UNDO.
/* Расширение файла для отправки запроса к системе пластиковых карт */
DEFINE VAR outFileExt AS CHAR INITIAL "qry"  NO-UNDO.
/* Расширение файла для получения ответа на запрос к системе пластиковых карт */
DEFINE VAR inFileExt AS CHAR INITIAL "ans"  NO-UNDO.
/* Директория обмена с системой пластиковых карт */
DEFINE VAR dirExchange AS CHAR INITIAL "/home2/bis/quit41d/imp-exp/safe_plast"  NO-UNDO.
/* Флаг ответа от системы пластиковых карт */
DEF VAR flagAnswer AS LOGICAL NO-UNDO.
/* Время начала отправки запроса к системе пластиковых карт */
DEF VAR startTime AS INTEGER NO-UNDO.
/* Максимальное время ожидания ответа от системы пластиковых карт в секундах */
DEF VAR timeOut AS INTEGER INITIAL 70 NO-UNDO.
/* Код клиента пластиковых карт */
DEF VAR tmpClientCode AS CHAR NO-UNDO.
/* Временные переменные */
DEF VAR fileItem AS CHAR FORMAT "x(16)" NO-UNDO.
DEF VAR tmpStr1 AS CHAR NO-UNDO.
DEF VAR tmpStr2 AS CHAR NO-UNDO.
DEF VAR i AS INTEGER NO-UNDO.
/* Описание ячейки */
DEFINE VARIABLE SafeDetails AS CHAR FORMAT "X(256)":U
		VIEW-AS FILL-IN SIZE 41 BY 1 NO-UNDO.
DEFINE VARIABLE SafePeriodDetails AS CHAR FORMAT "X(256)":U
		VIEW-AS FILL-IN SIZE 15 BY 1 NO-UNDO.
DEFINE VARIABLE firstAgentDetails AS CHAR FORMAT "X(256)":U
		VIEW-AS FILL-IN SIZE 41 BY 1 NO-UNDO.
DEFINE VARIABLE secondAgentDetails AS CHAR FORMAT "X(256)":U
    VIEW-AS FILL-IN SIZE 41 BY 1 NO-UNDO. 
/* DEFINE BUTTON btnGetAcct LABEL "Получить...".*/

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     
     tt-loan.cont-type 
          AT ROW 1 COL 13 COLON-ALIGNED 
     			LABEL "Тип договора"
     			VIEW-AS COMBO-BOX LIST-ITEM-PAIRS "Физик","ИБСФз","Сделка","ИБССд","Юрик","ИБСЮр", "Хранение", "ИБСХр"	
     			SIZE 20 BY 1
     			     			     
     tt-loan.SafeNumber AT ROW 2 COL 12 COLON-ALIGNED LABEL "Номер сейфа"
     			VIEW-AS FILL-IN SIZE 10 BY 1
     SafeDetails AT ROW 2 COL 24 COLON-ALIGNED NO-LABEL
		 
		 /* Приходится отобразить это поле сейчас, чтобы сработали стандартные триггеры 
		    (будь они не ладны). Ниже все равно это поле сделаю VISIBLE = NO
		 */
		 tt-loan.doc-num
		 			AT ROW 3 COL 1 COLON-ALIGNED
		 			LABEL ""
		 			VIEW-AS FILL-IN SIZE 6 BY 1
		 
     tt-loan.cust-cat
          AT ROW 4 COL 7 COLON-ALIGNED
          LABEL "Клиент"
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 5 BY 1
     tt-loan.cust-id
          AT ROW 4 COL 18 COLON-ALIGNED
          LABEL "Код"
          VIEW-AS FILL-IN 
          SIZE 8 BY 1
     CustName1
          AT ROW 4 COL 27 COLON-ALIGNED
          NO-LABEL

     tt-loan.cont-code
          AT ROW 6 COL 15 COLON-ALIGNED
          FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 15 BY 1
     /**
     tt-loan.currency
     			AT ROW 6 COL 31 COLON-ALIGNED
     			FORMAT "x(3)"
     			VIEW-AS FILL-IN
     			SIZE 3 BY 1 
     */
     tt-loan.open-date
          AT ROW 6 COL 40 COLON-ALIGNED
          LABEL "С"
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
     tt-loan.SafePeriod
     			AT ROW 6 COL 60 COLON-ALIGNED
     			LABEL "Период"
     			VIEW-AS FILL-IN
     			SIZE 2 BY 1
     SafePeriodDetails
     			AT ROW 6 COL 63 COLON-ALIGNED
     			NO-LABEL
     			VIEW-AS FILL-IN
     			SIZE 15 BY 1
     tt-loan.end-date
          AT ROW 7 COL 40 COLON-ALIGNED
          LABEL "По"
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
     endRate
          AT ROW 7 COL 60 COLON-ALIGNED
          LABEL "Сумма"
          VIEW-AS FILL-IN
          SIZE 11 BY 1
     tt-loan.close-date
          AT ROW 8 COL 40 COLON-ALIGNED
          LABEL "Закрыт"
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
     tt-loan.SafePlastType
     			AT ROW 10 COL 10 COLON-ALIGNED
     			LABEL "Тип карты"
     			VIEW-AS FILL-IN
     			SIZE 1 BY 1
     /* btnGetAcct AT ROW 10 COL 17 COLON-ALIGNED */
     tt-loan.clientCode
     			AT ROW 12 COL 12 COLON-ALIGNED
     			LABEL "Код клиента"
     			VIEW-AS FILL-IN
     			SIZE 4 BY 1
     tt-loan.SafePlastLNum
     			AT ROW 12 COL 20
     			LABEL "Номер договора"
     			VIEW-AS FILL-IN
     			SIZE 12 BY 1
     tt-loan.SafePlastLDate
     			AT ROW 12 COL 52 
     			LABEL "от" 
     			VIEW-AS FILL-IN
     			SIZE 10 BY 1
     
		 tt-loan.firstAgent
          AT ROW 14 COL 13 COLON-ALIGNED
          LABEL "1-е дов.лицо"
          VIEW-AS FILL-IN 
          SIZE 6 BY 1
     firstAgentDetails
     			AT ROW 14 COL 20 COLON-ALIGNED
     			NO-LABEL
     			VIEW-AS FILL-IN
     			SIZE 31 BY 1
     tt-loan.firstAgntDate	
     		  AT ROW 14 COL 65 COLON-ALIGNED
     		  LABEL "Дата 1 дов."
     		  VIEW-AS FILL-IN
     		  SIZE 10 BY 1
		 tt-loan.secondAgent
          AT ROW 16 COL 13 COLON-ALIGNED
          LABEL "2-е дов.лицо"
          VIEW-AS FILL-IN 
          SIZE 6 BY 1
     secondAgentDetails
     			AT ROW 16 COL 20 COLON-ALIGNED
     			NO-LABEL
     			VIEW-AS FILL-IN
     			SIZE 31 BY 1
     tt-loan.secondAgntDate	
     		  AT ROW 16 COL 65 COLON-ALIGNED
     		  LABEL "Дата 2 дов."
     		  VIEW-AS FILL-IN
     		  SIZE 10 BY 1

    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 21
         TITLE "".

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
{&WINDOW-NAME} = CURRENT-WINDOW.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB TERMINAL-SIMULATION 
/* ************************* Included-Libraries *********************** */

{bis-tty.pro}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       CustName1:READ-ONLY IN FRAME fMain        = TRUE
       SafeDetails:READ-ONLY IN FRAME fMain				= TRUE
       /* btnGetAcct:VISIBLE IN FRAME fMain = NO */
       endRate:READ-ONLY IN FRAME fMain = TRUE
       clientCode:READ-ONLY IN FRAME fMain = TRUE
       SafePlastLNum:READ-ONLY IN FRAME fMain = TRUE
       SafePlastLDate:READ-ONLY IN FRAME fMain = TRUE.
       

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(TERMINAL-SIMULATION)
THEN TERMINAL-SIMULATION:HIDDEN = yes.
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fMain
/* Query rebuild information for FRAME fMain
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fMain */
&ANALYZE-RESUME


/* ************************  Control Triggers  ************************ */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK TERMINAL-SIMULATION 

&Scoped-define SELF-NAME tt-loan.cont-code
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.cont-code TERMINAL-SIMULATION
ON ENTRY OF tt-loan.cont-code IN FRAME fMain
	DO:
		tt-loan.cont-code:SCREEN-VALUE = 
		tt-loan.SafeNumber:SCREEN-VALUE + "/" + STRING(CountAgreeForSafe,"9999") + "/".
		IF tt-loan.cont-type:SCREEN-VALUE = "ИБСФз" THEN tt-loan.cont-code:SCREEN-VALUE = tt-loan.cont-code:SCREEN-VALUE + "Ф".
		IF tt-loan.cont-type:SCREEN-VALUE = "ИБСЮр" THEN tt-loan.cont-code:SCREEN-VALUE = tt-loan.cont-code:SCREEN-VALUE + "Ю".
		IF tt-loan.cont-type:SCREEN-VALUE = "ИБССд" THEN tt-loan.cont-code:SCREEN-VALUE = tt-loan.cont-code:SCREEN-VALUE + "С".
		IF tt-loan.cont-type:SCREEN-VALUE = "ИБСХр" THEN tt-loan.cont-code:SCREEN-VALUE = tt-loan.cont-code:SCREEN-VALUE + "Х".
	END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*
ON CHOOSE OF btnGetAcct IN FRAME fMain
	DO:
		btnGetAcct:VISIBLE IN FRAME {&MAIN-FRAME} = NO.
		tmpStr1 = STRING(TODAY,"99/99/99").
		tmpStr2 = STRING(TIME,"HH:MM:SS").
		fileName = ENTRY(1,tmpStr1,"/") + ENTRY(2,tmpStr1,"/") + ENTRY(3,tmpStr1,"/")
		  + ENTRY(1,tmpStr2,":") + ENTRY(2,tmpStr2,":") + ENTRY(3,tmpStr2,":").
		/** ФИО разбиваем для передачи символом ^ и в начало строки добавляем тип карты */
		tmpStr1 = CustName1:SCREEN-VALUE.
		tmpStr2 = SafePlastType:SCREEN-VALUE + "^" + ENTRY(1,tmpStr1," ") + "^" + ENTRY(2,tmpStr1," ").
		IF NUM-ENTRIES(tmpStr1," ") >= 3 THEN DO:
			tmpStr2 = tmpStr2 + "^".
			DO i = 3 TO NUM-ENTRIES(tmpStr1," "):
				tmpStr2 = tmpStr2 + ENTRY(i,tmpStr1," ") + " ".
			END.
			TRIM(tmpStr2).
		END.
		
		/** Открываем поток, и посылаем в него ФИО в кодировке win-1251 */
		OUTPUT STREAM outStream TO VALUE(dirExchange + "/" + fileName + "." + outFileExt).
		tmpStr2 = CODEPAGE-CONVERT(tmpStr2,"1251",SESSION:CHARSET).
		PUT STREAM outStream UNFORMATTED tmpStr2.
		OUTPUT STREAM outStream CLOSE.
		MESSAGE "Отправлен запрос к системе пластиковых карт. Ожидайте ответ...".
		
		/** Ожидаем ответ */
		
		flagAnswer = FALSE.
		startTime = TIME.
		
		REPEAT WHILE (NOT flagAnswer) AND (TIME - startTime <= timeOut) :
			INPUT STREAM listDirExch FROM OS-DIR (dirExchange) NO-ATTR-LIST.
			/** 
			 * Просматириваем список файлов до тех пор, пока из него не будет
			 * удален наш запрос. Это значит, что внешняя программ его обработала и
			 * сформировала ответ 
			 */
			flagAnswer = TRUE.
			REPEAT:
				IMPORT STREAM listDirExch fileItem.
				IF fileItem = fileName + "." + outFileExt THEN DO:
					flagAnswer = FALSE.
				END.
			END.
			INPUT STREAM listDirExch CLOSE.
		END.
		
		/** Если ответа нет, то предупредим об этом пользователя */
		IF NOT flagAnswer THEN DO:
			OS-DELETE VALUE(dirExchange + "/" + fileName + "." + outFileExt).
			MESSAGE "Нет ответа от системы пластиковых карт. Код клиента получить невозможно! Попробуйте снова через несколько секунд..." VIEW-AS ALERT-BOX.
			btnGetAcct:VISIBLE IN FRAME {&MAIN-FRAME} = YES.
		END.
			
		/** Если ответ есть, то прочитаем данные из файла */
		IF flagAnswer THEN DO:
			INPUT STREAM inStream FROM VALUE(dirExchange + "/" + fileName + "." + inFileExt).
			REPEAT:
				IMPORT STREAM inStream tmpClientCode.
			END.
			tt-loan.clientCode:SCREEN-VALUE = ENTRY(1,tmpClientCode,"^").
			tt-loan.SafePlastLNum:SCREEN-VALUE = ENTRY(2, tmpClientCode, "^").
			tt-loan.SafePlastLDate:SCREEN-VALUE = REPLACE(ENTRY(3, tmpClientCode, "^"),".","/").
			INPUT STREAM inStream CLOSE.
		END.
		
		IF flagAnswer THEN
			OS-DELETE VALUE(dirExchange + "/" + fileName + "." + inFileExt).
		
		MESSAGE "".
		MESSAGE "".
	END.
*/
	 
&Scoped-define SELF-NAME tt-loan.SafePeriod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.SafePeriod TERMINAL-SIMULATION
ON LEAVE OF tt-loan.SafePeriod IN FRAME fMain
	DO:
		countW = 0.
		FIND FIRST code WHERE
			code.class = "SafePeriod"
			and
			code.code = tt-loan.SafePeriod:SCREEN-VALUE
			NO-LOCK NO-ERROR.
		IF AVAIL code THEN
			DO:
				countW = INTEGER(ENTRY(1,code.val)).
				ratio = INTEGER(ENTRY(2,code.val)).
				SafePeriodDetails:SCREEN-VALUE = code.name.
			END.
		IF countW = 0 THEN 
			DO:
				endRate:READ-ONLY IN FRAME fMain = NO. 
			END.
		ELSE 
			DO:
				endRate:READ-ONLY IN FRAME fMain = YES.
				countM = TRUNCATE(countW / 4,0).
				countW = countW MODULO 4.
				tmpDate = GoMonth(DATE(tt-loan.open-date:SCREEN-VALUE), countM).
				/*
				Минус 1 нужен для того, чтобы соблюсти правильность расчета бухгалтерского периода.
				Т.е. если мы открываем договор 1.января.2006 года сроком на 1 месяц, то дата окончания
				не 1 февраля 2006 года, а 30 января 2006 года - 1 месяц минус 1 день.
				*/
				tmpDate = tmpDate + countW * 7 - 1.
				/*
				IF Holiday(tmpDate) THEN
					tmpDate = NextWorkDay(tmpDate).
				*/
				tt-loan.end-date:SCREEN-VALUE = STRING(tmpDate).
				RUN LocalCalcRent.
			END.
	END.
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan.firstAgent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.firstAgent TERMINAL-SIMULATION
ON LEAVE OF tt-loan.firstAgent IN FRAME fMain
	DO:
		FIND FIRST person WHERE person-id = INT(tt-loan.firstAgent:SCREEN-VALUE)
		  NO-LOCK NO-ERROR.
		IF AVAIL person THEN DO:
			firstAgentDetails:SCREEN-VALUE = person.name-last + " " + person.first-names.		
			/*tt-loan.firstAgntDate:VISIBLE IN FRAME fMain = YES.*/
			END.
		ELSE
			/*tt-loan.firstAgntDate:VISIBLE IN FRAME fMain = NO.*/
			
	END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan.secondAgent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.secondAgent TERMINAL-SIMULATION
ON LEAVE OF tt-loan.secondAgent IN FRAME fMain
	DO:
		FIND FIRST person WHERE person-id = INT(tt-loan.secondAgent:SCREEN-VALUE)
		  NO-LOCK NO-ERROR.
		IF AVAIL person THEN DO:
			secondAgentDetails:SCREEN-VALUE = person.name-last + " " + person.first-names.		
			/*tt-loan.secondAgntDate:VISIBLE IN FRAME fMain = YES.*/
			END.
		ELSE
			/*tt-loan.secondAgntDate:VISIBLE IN FRAME fMain = NO.*/
		
	END.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/**
 * Когда выбрали нужную ячейку, необходимо пометить ее, что она используется
 * И увеличить счетчик договоров
 */
&Scoped-define SELF-NAME tt-loan.SafeNumber
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.SafeNumber TERMINAL-SIMULATION
ON LEAVE OF tt-loan.SafeNumber IN FRAME fMain
	DO:
		IF NOT LAST-KEY = KEYCODE("ESC") AND NOT iMode EQ {&MOD_VIEW} THEN DO:
			FIND FIRST code WHERE
				code.class = "SafeList"
				AND
				code.code = tt-loan.SafeNumber:SCREEN-VALUE
				EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
			IF NOT AVAIL code THEN
				DO:
					IF LOCKED code THEN
						MESSAGE "Ячейка оформляется!" VIEW-AS ALERT-BOX.
					ELSE
						MESSAGE "Ячейка не найдена!" VIEW-AS ALERT-BOX.
					tt-loan.SafeNumber:SCREEN-VALUE = "".
					RETURN NO-APPLY.
				END.
			ELSE
				DO:
					IF code.val <> "" THEN 
						DO:
							MESSAGE "Ячейка занята, ее ключ не выдан кассиру или она находится в карантине!" VIEW-AS ALERT-BOX.
							tt-loan.SafeNumber:SCREEN-VALUE = "".
							RETURN NO-APPLY.
						END.
					ELSE
						DO:
							CountAgreeForSafe = INTEGER(ENTRY(1,code.description[1])).
							baseRate = DECIMAL(ENTRY(2,code.description[1])).
							CountAgreeForSafe = CountAgreeForSafe + 1.
							SafeDetails:SCREEN-VALUE = code.name.
						END.
				END.
		END.
	END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan.SafePlastType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.SafePlastType TERMINAL-SIMULATION
ON LEAVE OF tt-loan.SafePlastType IN FRAME fMain
	DO:
		IF NOT LAST-KEY = KEYCODE("ESC") THEN
			IF tt-loan.SafePlastType:SCREEN-VALUE = "" THEN 
				DO:
					MESSAGE "Укажите тип пластиковой карты!" VIEW-AS ALERT-BOX.
					RETURN NO-APPLY.
				END.
	END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/*
&Scoped-define SELF-NAME tt-loan-acct-main.acct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-acct-main.acct TERMINAL-SIMULATION
ON F1 OF tt-loan-acct-main.acct IN FRAME fMain /* Лицевой счет */
/*,tt-loan-acct-cust.acct */
DO:
   DEFINE VARIABLE vFields AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vFieldsValue AS CHARACTER  NO-UNDO.
   IF iMode EQ {&MOD_VIEW} THEN
      APPLY "F1" TO FRAME {&MAIN-FRAME}.
   ELSE 
   DO TRANS:
      vFields = 
         "acct-cat" + CHR(1) + 
         "cust-cat" + CHR(1) + 
         "cust-id" + CHR(1) + 
         "currency".
      vFieldsValue = 
         "b" + CHR(1) +
         tt-loan.cust-cat:SCREEN-VALUE + CHR(1) +
         STRING(tt-loan.cust-id:INPUT-VALUE) + CHR(1) +
         "" /**tt-loan.currency:SCREEN-VALUE*/.
      RUN browseld.p ("acct",
                vFields,
                vFieldsValue,
                "",
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
*/

&Scoped-define SELF-NAME tt-loan.cust-cat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.cust-cat TERMINAL-SIMULATION
ON LEAVE OF tt-loan.cust-cat
	DO:
		IF tt-loan.cust-cat:SCREEN-VALUE = "Ч" AND tt-loan.cont-type:SCREEN-VALUE = "ИБСФз" THEN 
			DO:
					/* btnGetAcct:VISIBLE IN FRAME fMain = YES.
					ENABLE btnGetAcct WITH FRAME fMain. */
					clientCode:VISIBLE IN FRAME fMain = YES.
					SafePlastLNum:VISIBLE IN FRAME fMain = YES.
					SafePlastLDate:VISIBLE IN FRAME fMain = YES.
				tt-loan.SafePlastType:VISIBLE IN FRAME fMain = YES.
			END.
		ELSE
			DO:
				tt-loan.clientCode:VISIBLE IN FRAME fMain = NO.
				/* btnGetAcct:VISIBLE IN FRAME fMain = NO. */
				tt-loan.SafePlastType:VISIBLE IN FRAME fMain = NO.
				tt-loan.SafePlastLNum:VISIBLE IN FRAME fMain = NO.
				tt-loan.SafePlastLDate:VISIBLE IN FRAME fMain = NO.
			END.
	END.

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
   mRetVal = IF mOnlyForm THEN
      {&RET-ERROR}
      ELSE 
         "".
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

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

/* Commented by KSV: Читаем данные */
   RUN GetObject.

   /* Заполняем COMBO-BOX'ы данными из метасхемы */
   RUN FillComboBox(FRAME {&MAIN-FRAME}:HANDLE).

   /* Commented by KSV: Показываем экранную форму */
   STATUS DEFAULT "".
   RUN enable_UI.

   /* Commented by KSV: Открываем те поля, которые разрешено изменять
   ** в зависимости от режима открытия */
   RUN EnableDisable.

   IF NOT THIS-PROCEDURE:PERSISTENT THEN
      WAIT-FOR CLOSE OF THIS-PROCEDURE.
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
  DISPLAY SafeDetails endRate WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  
  IF AVAILABLE tt-loan THEN 
    DISPLAY tt-loan.SafeNumber tt-loan.cust-cat tt-loan.cust-id tt-loan.doc-num 
    				tt-loan.cont-code /**tt-loan.currency*/ tt-loan.open-date tt-loan.SafePeriod tt-loan.end-date
    				tt-loan.close-date tt-loan.SafePlastType tt-loan.clientCode tt-loan.SafePlastLNum tt-loan.SafePlastLDate 
    				tt-loan.firstAgent tt-loan.firstAgntDate tt-loan.secondAgent tt-loan.secondAgntDate
    				WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
 	
 	/*IF AVAILABLE tt-loan-acct-main THEN
 		DISPLAY tt-loan-acct-main.acct 
 						WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.*/

	VIEW FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  VIEW TERMINAL-SIMULATION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LocalEnableDisable TERMINAL-SIMULATION 
PROCEDURE LocalEnableDisable :
	DEFINE VARIABLE vNextStream AS INTEGER    NO-UNDO.
  IF AVAIL tt-instance AND iMode EQ {&MOD_ADD} THEN
  DO:
     vNextStream = INT(ENTRY(2,
        GetBuffersValue(
           "loan",
           "FOR EACH loan WHERE 
                loan.contract EQ '" + tt-instance.contract + "' AND 
                loan.cont-code BEGINS '" + tt-instance.cont-code + " ' AND 
                NUM-ENTRIES(loan.cont-code,' ') EQ 2 NO-LOCK BY INT(ENTRY(2,loan.cont-code,' ')) DESC",
          "loan.cont-code"),
        " ")) NO-ERROR.
     vNextStream = IF vNextStream EQ ? THEN 1 ELSE vNextStream + 1.
     tt-loan.cont-code = tt-instance.cont-code + " " + STRING(vNextStream).
     tt-loan.cont-code:SCREEN-VALUE IN FRAME {&MAIN-FRAME} = tt-loan.cont-code.
     IF tt-loan.cust-cat:VISIBLE THEN ASSIGN
        tt-loan.cust-cat:SCREEN-VALUE = tt-instance.cust-cat.
    IF tt-loan.cust-id:VISIBLE THEN ASSIGN
        tt-loan.cust-id:SCREEN-VALUE = STRING(tt-instance.cust-id).
     APPLY "leave" TO tt-loan.cust-id.
     RUN BT_HiddOrDisableField(tt-loan.cont-code:HANDLE,NO,YES).
     RUN BT_HiddOrDisableField(tt-loan.cust-cat:HANDLE,NO,YES).
     RUN BT_HiddOrDisableField(tt-loan.cust-id:HANDLE,NO,YES).
   END.

	IF iMode EQ {&MOD_VIEW} OR iMode EQ {&MOD_EDIT} AND tt-loan.cust-cat EQ "Ч" THEN
		DO:
		  tt-loan.clientCode:VISIBLE IN FRAME fMain = YES.
  		tt-loan.SafePlastType:VISIBLE IN FRAME fMain = YES.
  		tt-loan.SafePlastLNum:VISIBLE IN FRAME fMain = YES.
		  tt-loan.SafePlastLDate:VISIBLE IN FRAME fMain = YES.
		END.
	ELSE
		DO:
		  tt-loan.clientCode:VISIBLE IN FRAME fMain = NO.
  		tt-loan.SafePlastType:VISIBLE IN FRAME fMain = NO.
  		tt-loan.SafePlastLNum:VISIBLE IN FRAME fMain = NO.
		  tt-loan.SafePlastLDate:VISIBLE IN FRAME fMain = NO.
		END.

	/*
	IF iMode EQ {&MOD_VIEW} OR iMode EQ {&MOD_EDIT} AND tt-loan.firstAgent <> "" THEN
		tt-loan.firstAgntDate:VISIBLE IN FRAME fMain = YES.
	ELSE
		tt-loan.firstAgntDate:VISIBLE IN FRAME fMain = NO.

	IF iMode EQ {&MOD_VIEW} OR iMode EQ {&MOD_EDIT} AND tt-loan.secondAgent <> "" THEN
		tt-loan.secondAgntDate:VISIBLE IN FRAME fMain = YES.
	ELSE
		tt-loan.secondAgntDate:VISIBLE IN FRAME fMain = NO.
	*/

	tt-loan.doc-num:VISIBLE IN FRAME {&MAIN-FRAME} = NO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LocalSetObject TERMINAL-SIMULATION 
PROCEDURE LocalSetObject :

	 IF iMode EQ {&MOD_ADD} OR iMode EQ {&MOD_EDIT} THEN
 		 FIND FIRST code WHERE
   			code.class = "SafeList"
   			AND
   			code.code = tt-loan.SafeNumber
   			EXCLUSIVE-LOCK.

   IF iMode EQ {&MOD_ADD} THEN
   DO:
   		ENTRY(1,code.description[1]) = STRING(CountAgreeForSafe).
   		code.val = "Используется".

   		/*
   		MESSAGE STRING(tt-loan.open-date) VIEW-AS ALERT-BOX.
   		ASSIGN
   			tt-loan.firstAgntDate = tt-loan.open-date
   			tt-loan.secondAgntDate = tt-loan.open-date.
   		*/
   		
      tt-loan.since = tt-loan.open-date.
      tt-loan-cond.since = tt-loan.open-date.
      IF tt-loan.cont-code EQ "" THEN
         tt-loan.cont-code = ?.
      /*
      IF {assigned tt-loan-acct-main.acct} THEN ASSIGN
         tt-loan-acct-main.currency = tt-loan.currency
         tt-loan-acct-main.since = tt-loan.open-date.
      */
      /** Вычислим и сохраним комиссии */
      /** CREATE tt-comm-rate. */
      ASSIGN tt-comm-rate.commission = "SafeRent"
      			 tt-comm-rate.acct = "0"
      			 tt-comm-rate.since = tt-loan-cond.since
      			 tt-comm-rate.rate-comm = DECIMAL(endRate:SCREEN-VALUE IN FRAME fMain)
      			 tt-comm-rate.kau = "Депоз," + tt-loan.cont-code
      			 tt-comm-rate.rate-fixed = YES. /** YES это '=' */
   END.
   
   IF iMode EQ {&MOD_EDIT} THEN 
   DO:
   		IF tt-loan.close-date = ? THEN
   			DO:
   				IF code.val = "" THEN code.val = "Используется".
   			END.
   		ELSE
   			DO:
   				IF code.val <> "" THEN code.val = "".
   				/**
   				 * В случае, если дата закрытия устанавливается вручную, то
   				 * статус договора не меняем. Посмотрим, возможно, это 
   				 * поможет избежать больших проблем при возникновении 
   				 * пользовательских некорректных действий
   				 *
   				tt-loan.loan-status = "ЗАКР".
   				 */
   			END.
   END.			

   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PostGetObject TERMINAL-SIMULATION 
PROCEDURE PostGetObject :
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PostSetObject TERMINAL-SIMULATION 
PROCEDURE PostSetObject :
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LocalCalcRent TERMINAL-SIMULATION 
PROCEDURE LocalCalcRent :
	endRate:SCREEN-VALUE IN FRAME fMain = STRING(ROUND(ratio * baseRate,2),">>>,>>9.99").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/* ************************  Function Implementations ***************** */

