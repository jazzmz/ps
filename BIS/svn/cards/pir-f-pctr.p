&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 Character
&ANALYZE-RESUME
/* Connected Databases 
          bisquit          PROGRESS
*/
&Scoped-define WINDOW-NAME TERMINAL-SIMULATION


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-pc-trans NO-UNDO LIKE pc-trans
       FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
       FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
       FIELD local__id       AS INTEGER   /* Идентификатор записи     */
       FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
       FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
       FIELD eq-type         AS CHARACTER /* Тип устройства в ПЦ */
       /* Additional fields you should place here                      */
       
       /* Записываем ссылку на временную таблицу в специальную таблицу */
       {ln-tthdl.i "tt-pc-trans" "" }
       .



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS TERMINAL-SIMULATION 
/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2007 ЗАО "Банковские информационные системы"
     Filename: pctr-ed.p
      Comment: <comment>
   Parameters:
         Uses:
      Used by:
      Created:
     Modified:
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
**   11. Описание TEMP-TABLов
*/
{globals.i}
&IF DEFINED(SESSION-REMOTE) EQ 0 &THEN
CREATE WIDGET-POOL.
&ENDIF
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

/* Для просмотра полученной mInstance в GetObject */
/* &GLOBAL-DEFINE DEBUG-INSTANCE-GET */

/* Для просмотра mInstance перед записью в базу в SetObject */
/* &GLOBAL-DEFINE DEBUG-INSTANCE-SET */

/* Безусловное включение\отключение вызова xattr-ed 
(иначе он вызывается при наличие незаполненных обязательных реквизитов */
/*
&GLOBAL-DEFINE XATTR-ED-OFF
&GLOBAL-DEFINE XATTR-ED-ON 
*/

{intrface.get strng}

{ttretval.def}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-pc-trans

/* Definitions for FRAME fMain                                          */
&Scoped-define FIELDS-IN-QUERY-fMain tt-pc-trans.processing ~
tt-pc-trans.pl-sys tt-pc-trans.pctr-id tt-pc-trans.pctr-status ~
tt-pc-trans.cont-date tt-pc-trans.user-id tt-pc-trans.num-card ~
tt-pc-trans.card-country tt-pc-trans.num-equip tt-pc-trans.eq-country ~
tt-pc-trans.eq-city tt-pc-trans.eq-location tt-pc-trans.mcc ~
tt-pc-trans.eq-type tt-pc-trans.inpc-stan tt-pc-trans.inpc-arn ~
tt-pc-trans.inpc-irn tt-pc-trans.inpc-rrn tt-pc-trans.inpc-trans-id ~
tt-pc-trans.inpc-code tt-pc-trans.auth-code tt-pc-trans.acct-pc ~
tt-pc-trans.inpc-result tt-pc-trans.proc-date tt-pc-trans.user-id-p ~
tt-pc-trans.pctr-result 
&Scoped-define ENABLED-FIELDS-IN-QUERY-fMain tt-pc-trans.processing ~
tt-pc-trans.pl-sys tt-pc-trans.pctr-id tt-pc-trans.pctr-status ~
tt-pc-trans.cont-date tt-pc-trans.user-id tt-pc-trans.num-card ~
tt-pc-trans.card-country tt-pc-trans.num-equip tt-pc-trans.eq-country ~
tt-pc-trans.eq-city tt-pc-trans.eq-location tt-pc-trans.mcc ~
tt-pc-trans.eq-type tt-pc-trans.inpc-stan tt-pc-trans.inpc-arn ~
tt-pc-trans.inpc-irn tt-pc-trans.inpc-rrn tt-pc-trans.inpc-trans-id ~
tt-pc-trans.inpc-code tt-pc-trans.auth-code tt-pc-trans.acct-pc ~
tt-pc-trans.inpc-result tt-pc-trans.proc-date tt-pc-trans.user-id-p ~
tt-pc-trans.pctr-result 
&Scoped-define ENABLED-TABLES-IN-QUERY-fMain tt-pc-trans
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-fMain tt-pc-trans
&Scoped-define QUERY-STRING-fMain FOR EACH tt-pc-trans SHARE-LOCK
&Scoped-define OPEN-QUERY-fMain OPEN QUERY fMain FOR EACH tt-pc-trans SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-fMain tt-pc-trans
&Scoped-define FIRST-TABLE-IN-QUERY-fMain tt-pc-trans


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-pc-trans.processing tt-pc-trans.pl-sys ~
tt-pc-trans.pctr-id tt-pc-trans.pctr-status tt-pc-trans.cont-date ~
tt-pc-trans.user-id tt-pc-trans.num-card tt-pc-trans.card-country ~
tt-pc-trans.num-equip tt-pc-trans.eq-country tt-pc-trans.eq-city ~
tt-pc-trans.eq-location tt-pc-trans.mcc tt-pc-trans.eq-type ~
tt-pc-trans.inpc-stan tt-pc-trans.inpc-arn tt-pc-trans.inpc-irn ~
tt-pc-trans.inpc-rrn tt-pc-trans.inpc-trans-id tt-pc-trans.inpc-code ~
tt-pc-trans.auth-code tt-pc-trans.acct-pc tt-pc-trans.inpc-result ~
tt-pc-trans.proc-date tt-pc-trans.user-id-p tt-pc-trans.pctr-result 
&Scoped-define ENABLED-TABLES tt-pc-trans
&Scoped-define FIRST-ENABLED-TABLE tt-pc-trans
&Scoped-Define ENABLED-OBJECTS mNamePlSys mSurLoanSps mType mDir mContTime ~
mCardOur mCardSponsor mCardAlien mSurLoanCard mEquipOur mEquipSponsor ~
mEquipAlien mSurLoanAcq mProcTime mSeparator1 mSeparator2 mSeparator3 ~
mSeparator4 mSeparator5 mSeparator6 mSeparator7 mSeparator8 mSeparator9 ~
mSeparator10 mSeparator11 mSeparator12 mSeparator13 
&Scoped-Define DISPLAYED-FIELDS tt-pc-trans.processing tt-pc-trans.pl-sys ~
tt-pc-trans.pctr-id tt-pc-trans.pctr-status tt-pc-trans.cont-date ~
tt-pc-trans.user-id tt-pc-trans.num-card tt-pc-trans.card-country ~
tt-pc-trans.num-equip tt-pc-trans.eq-country tt-pc-trans.eq-city ~
tt-pc-trans.eq-location tt-pc-trans.mcc tt-pc-trans.eq-type ~
tt-pc-trans.inpc-stan tt-pc-trans.inpc-arn tt-pc-trans.inpc-irn ~
tt-pc-trans.inpc-rrn tt-pc-trans.inpc-trans-id tt-pc-trans.inpc-code ~
tt-pc-trans.auth-code tt-pc-trans.acct-pc tt-pc-trans.inpc-result ~
tt-pc-trans.proc-date tt-pc-trans.user-id-p tt-pc-trans.pctr-result 
&Scoped-define DISPLAYED-TABLES tt-pc-trans
&Scoped-define FIRST-DISPLAYED-TABLE tt-pc-trans
&Scoped-Define DISPLAYED-OBJECTS mNamePlSys mSurLoanSps mType mDir ~
mContTime mCardOur mCardSponsor mCardAlien mSurLoanCard mEquipOur ~
mEquipSponsor mEquipAlien mSurLoanAcq mProcTime mSeparator1 mSeparator2 ~
mSeparator3 mSeparator4 mSeparator5 mSeparator6 mSeparator7 mSeparator8 ~
mSeparator9 mSeparator10 mSeparator11 mSeparator12 mSeparator13 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 tt-pc-trans.pl-sys mType tt-pc-trans.pctr-status ~
tt-pc-trans.cont-date mContTime tt-pc-trans.user-id mCardOur mCardSponsor ~
mCardAlien tt-pc-trans.num-card tt-pc-trans.card-country mEquipOur ~
mEquipSponsor mEquipAlien tt-pc-trans.num-equip tt-pc-trans.eq-country ~
tt-pc-trans.eq-city tt-pc-trans.eq-location tt-pc-trans.mcc ~
tt-pc-trans.eq-type tt-pc-trans.inpc-stan tt-pc-trans.inpc-arn ~
tt-pc-trans.inpc-irn tt-pc-trans.inpc-rrn tt-pc-trans.inpc-trans-id ~
tt-pc-trans.inpc-code tt-pc-trans.auth-code tt-pc-trans.acct-pc ~
tt-pc-trans.inpc-result tt-pc-trans.proc-date mProcTime ~
tt-pc-trans.user-id-p tt-pc-trans.pctr-result 
&Scoped-define List-2 tt-pc-trans.pl-sys mType tt-pc-trans.pctr-status ~
tt-pc-trans.cont-date mContTime tt-pc-trans.user-id mCardOur mCardSponsor ~
mCardAlien tt-pc-trans.num-card tt-pc-trans.card-country mEquipOur ~
mEquipSponsor mEquipAlien tt-pc-trans.num-equip tt-pc-trans.eq-country ~
tt-pc-trans.eq-city tt-pc-trans.eq-location tt-pc-trans.mcc ~
tt-pc-trans.eq-type tt-pc-trans.inpc-stan tt-pc-trans.inpc-arn ~
tt-pc-trans.inpc-irn tt-pc-trans.inpc-rrn tt-pc-trans.inpc-trans-id ~
tt-pc-trans.inpc-code tt-pc-trans.auth-code tt-pc-trans.acct-pc ~
tt-pc-trans.inpc-result tt-pc-trans.proc-date mProcTime ~
tt-pc-trans.user-id-p tt-pc-trans.pctr-result 
&Scoped-define List-3 tt-pc-trans.processing mSurLoanSps tt-pc-trans.pl-sys ~
mType tt-pc-trans.pctr-id tt-pc-trans.pctr-status tt-pc-trans.cont-date ~
mContTime tt-pc-trans.user-id mCardOur mCardSponsor mCardAlien ~
tt-pc-trans.num-card tt-pc-trans.card-country mSurLoanCard mEquipOur ~
mEquipSponsor mEquipAlien tt-pc-trans.num-equip tt-pc-trans.eq-country ~
tt-pc-trans.eq-city tt-pc-trans.eq-location tt-pc-trans.mcc mSurLoanAcq ~
tt-pc-trans.eq-type tt-pc-trans.inpc-stan tt-pc-trans.inpc-arn ~
tt-pc-trans.inpc-irn tt-pc-trans.inpc-rrn tt-pc-trans.inpc-trans-id ~
tt-pc-trans.inpc-code tt-pc-trans.auth-code tt-pc-trans.acct-pc ~
tt-pc-trans.inpc-result tt-pc-trans.proc-date mProcTime ~
tt-pc-trans.user-id-p tt-pc-trans.pctr-result 
&Scoped-define List-4 mSurLoanSps mType mDir mContTime mCardOur ~
mCardSponsor mCardAlien mSurLoanCard mEquipOur mEquipSponsor mEquipAlien ~
mSurLoanAcq mProcTime tt-pc-trans.eq-type 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE mType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Тип" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 12 BY 1
     &ELSE SIZE 12 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mContTime AS CHARACTER FORMAT "xx:xx":U 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 5 BY 1
     &ELSE SIZE 5 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mDir AS CHARACTER FORMAT "X(256)":U INITIAL "Прямая" 
     LABEL "Направление" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
     &ELSE SIZE 10 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mNamePlSys AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 35 BY 1
     &ELSE SIZE 35 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mProcTime AS CHARACTER FORMAT "xx:xx":U 
     LABEL "Время" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 5 BY 1
     &ELSE SIZE 5 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSeparator1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 78 BY 1
     &ELSE SIZE 78 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSeparator10 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 1 BY 1
     &ELSE SIZE 1 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSeparator11 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 1 BY 1
     &ELSE SIZE 1 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSeparator12 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 1 BY 1
     &ELSE SIZE 1 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSeparator13 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 78 BY 1
     &ELSE SIZE 78 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSeparator2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 1 BY 1
     &ELSE SIZE 1 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSeparator3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 1 BY 1
     &ELSE SIZE 1 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSeparator4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 1 BY 1
     &ELSE SIZE 1 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSeparator5 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 1 BY 1
     &ELSE SIZE 1 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSeparator6 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 1 BY 1
     &ELSE SIZE 1 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSeparator7 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 78 BY 1
     &ELSE SIZE 78 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSeparator8 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 1 BY 1
     &ELSE SIZE 1 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSeparator9 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 1 BY 1
     &ELSE SIZE 1 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSurLoanAcq AS CHARACTER FORMAT "X(19)":U 
     LABEL "Договор" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 19 BY 1
     &ELSE SIZE 19 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSurLoanCard AS CHARACTER FORMAT "X(19)":U 
     LABEL "Договор" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 19 BY 1
     &ELSE SIZE 19 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSurLoanSps AS CHARACTER FORMAT "X(30)":U 
     LABEL "Договор со спонсором" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 30 BY 1
     &ELSE SIZE 30 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mCardAlien AS LOGICAL INITIAL no 
     LABEL "Чужая" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mCardOur AS LOGICAL INITIAL yes 
     LABEL "Наша" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mCardSponsor AS LOGICAL INITIAL no 
     LABEL "Спонсора" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mEquipAlien AS LOGICAL INITIAL no 
     LABEL "Чужое" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mEquipOur AS LOGICAL INITIAL yes 
     LABEL "Наше" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mEquipSponsor AS LOGICAL INITIAL no 
     LABEL "Спонсора" 
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY 1 &ENDIF NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY fMain FOR 
      tt-pc-trans SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     tt-pc-trans.processing
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 11 COLON-ALIGNED
          &ELSE AT ROW 1 COL 11 COLON-ALIGNED &ENDIF HELP
          "Код процессинга"
          LABEL "Процессинг" FORMAT "x(6)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
     mNamePlSys
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 42 COLON-ALIGNED
          &ELSE AT ROW 9 COL 42 COLON-ALIGNED &ENDIF NO-LABEL
     mSurLoanSps
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 47 COLON-ALIGNED
          &ELSE AT ROW 1 COL 47 COLON-ALIGNED &ENDIF HELP
          "Номер договора со спонсором"
     tt-pc-trans.pl-sys
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 2 COL 11 COLON-ALIGNED
          &ELSE AT ROW 2 COL 11 COLON-ALIGNED &ENDIF HELP
          "Код платежной системы"
          LABEL "Плат.сист." FORMAT "x(16)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 16 BY 1
          &ELSE SIZE 16 BY 1 &ENDIF
     mType
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 11 COLON-ALIGNED
          &ELSE AT ROW 3 COL 11 COLON-ALIGNED &ENDIF HELP
          "Тип транзакции"
     mDir
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 37 COLON-ALIGNED
          &ELSE AT ROW 3 COL 37 COLON-ALIGNED &ENDIF HELP
          "Направление транзакции"
     tt-pc-trans.pctr-id
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 67 COLON-ALIGNED
          &ELSE AT ROW 3 COL 67 COLON-ALIGNED &ENDIF HELP
          "Идентификатор транзакции в БИСквит"
          LABEL "Внутр.код" FORMAT "9999999999"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-pc-trans.pctr-status
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 11 COLON-ALIGNED
          &ELSE AT ROW 4 COL 11 COLON-ALIGNED &ENDIF HELP
          "Статус транзакции"
          LABEL "Статус" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 12 BY 1
          &ELSE SIZE 12 BY 1 &ENDIF
     tt-pc-trans.cont-date
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 37 COLON-ALIGNED
          &ELSE AT ROW 4 COL 37 COLON-ALIGNED &ENDIF HELP
          "Дата обработки транзакции в банке"
          LABEL "Выполнена" FORMAT "99/99/99"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
     mContTime
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 46 COLON-ALIGNED
          &ELSE AT ROW 4 COL 46 COLON-ALIGNED &ENDIF HELP
          "Время выполнения транзакции" NO-LABEL
     tt-pc-trans.user-id
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 67 COLON-ALIGNED
          &ELSE AT ROW 4 COL 67 COLON-ALIGNED &ENDIF HELP
          "Пользователь, загрузивший транзакцию"
          LABEL "Загрузил" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
     mCardOur
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 1
          &ELSE AT ROW 6 COL 1 &ENDIF HELP
          "Принадлежность карты"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2
         SIZE 80 BY 20.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     mCardSponsor
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 9
          &ELSE AT ROW 6 COL 9 &ENDIF HELP
          "Принадлежность карты"
     mCardAlien
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 21
          &ELSE AT ROW 6 COL 21 &ENDIF HELP
          "Принадлежность карты"
     tt-pc-trans.num-card
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 7 COL 8 COLON-ALIGNED
          &ELSE AT ROW 7 COL 8 COLON-ALIGNED &ENDIF HELP
          "Номер карты"
          LABEL "Номер" FORMAT "x(18)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 18 BY 1
          &ELSE SIZE 18 BY 1 &ENDIF
     tt-pc-trans.card-country
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 8 COL 8 COLON-ALIGNED
          &ELSE AT ROW 8 COL 8 COLON-ALIGNED &ENDIF HELP
          "Страна карты"
          LABEL "Страна" FORMAT "x(18)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 18 BY 1
          &ELSE SIZE 18 BY 1 &ENDIF
     mSurLoanCard
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 10 COL 8 COLON-ALIGNED
          &ELSE AT ROW 10 COL 8 COLON-ALIGNED &ENDIF HELP
          "Договор на обслуживание карт"
     mEquipOur
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 30
          &ELSE AT ROW 6 COL 30 &ENDIF HELP
          "Принадлежность устройства"
     mEquipSponsor
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 38
          &ELSE AT ROW 6 COL 38 &ENDIF HELP
          "Принадлежность устройства"
     mEquipAlien
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 50
          &ELSE AT ROW 6 COL 50 &ENDIF HELP
          "Принадлежность устройства"
     tt-pc-trans.num-equip
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 7 COL 37 COLON-ALIGNED
          &ELSE AT ROW 7 COL 37 COLON-ALIGNED &ENDIF HELP
          "Номер устройства"
          LABEL "Номер" FORMAT "x(16)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-pc-trans.eq-country
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 7 COL 57 COLON-ALIGNED
          &ELSE AT ROW 7 COL 57 COLON-ALIGNED &ENDIF HELP
          "Страна устройства"
          LABEL "Страна" FORMAT "x(18)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-pc-trans.eq-city
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 7 COL 69 COLON-ALIGNED
          &ELSE AT ROW 7 COL 69 COLON-ALIGNED &ENDIF HELP
          "Город устройства"
          LABEL "Город" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
     tt-pc-trans.eq-location
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 8 COL 37 COLON-ALIGNED
          &ELSE AT ROW 8 COL 37 COLON-ALIGNED &ENDIF HELP
          "Место проведения транзакции"
          LABEL "Место" FORMAT "x(40)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 40 BY 1
          &ELSE SIZE 40 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2
         SIZE 80 BY 20.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     tt-pc-trans.mcc
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 37 COLON-ALIGNED
          &ELSE AT ROW 9 COL 37 COLON-ALIGNED &ENDIF HELP
          "Кaтeгория мерчанта"
          LABEL "MCC" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 4 BY 1
          &ELSE SIZE 4 BY 1 &ENDIF
     mSurLoanAcq
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 10 COL 37 COLON-ALIGNED
          &ELSE AT ROW 10 COL 37 COLON-ALIGNED &ENDIF HELP
          "Договор эквайринга"
     tt-pc-trans.eq-type
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 10 COL 65 COLON-ALIGNED
          &ELSE AT ROW 10 COL 65 COLON-ALIGNED &ENDIF HELP
          ""
          LABEL "Тип" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-pc-trans.inpc-stan
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 6 COLON-ALIGNED
          &ELSE AT ROW 12 COL 6 COLON-ALIGNED &ENDIF HELP
          "Код транзакции в процессинге"
          LABEL "STAN" FORMAT "x(20)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-pc-trans.inpc-arn
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 6 COLON-ALIGNED
          &ELSE AT ROW 13 COL 6 COLON-ALIGNED &ENDIF HELP
          "Идентификатор транзакции у эквайрера"
          LABEL "ARN" FORMAT "x(20)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-pc-trans.inpc-irn
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 6 COLON-ALIGNED
          &ELSE AT ROW 14 COL 6 COLON-ALIGNED &ENDIF HELP
          "Идентификатор транзакции у эмитента"
          LABEL "IRN" FORMAT "x(20)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-pc-trans.inpc-rrn
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 6 COLON-ALIGNED
          &ELSE AT ROW 15 COL 6 COLON-ALIGNED &ENDIF HELP
          "Номер транзакции в процессинге"
          LABEL "RRN" FORMAT "x(20)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-pc-trans.inpc-trans-id
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 6 COLON-ALIGNED
          &ELSE AT ROW 16 COL 6 COLON-ALIGNED &ENDIF HELP
          "Идентификатор транзакции в процессинге"
          LABEL "PC ID" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-pc-trans.inpc-code
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 39 COLON-ALIGNED
          &ELSE AT ROW 12 COL 39 COLON-ALIGNED &ENDIF HELP
          "Тип транзакции в процессинге"
          LABEL "Тип" FORMAT "x(20)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2
         SIZE 80 BY 20.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     tt-pc-trans.auth-code
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 39 COLON-ALIGNED
          &ELSE AT ROW 13 COL 39 COLON-ALIGNED &ENDIF HELP
          "Код авторизации"
          LABEL "Код авт." FORMAT "x(20)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-pc-trans.acct-pc
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 39 COLON-ALIGNED
          &ELSE AT ROW 14 COL 39 COLON-ALIGNED &ENDIF HELP
          "Счет процессинга"
          LABEL "Счет ПЦ" FORMAT "x(20)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-pc-trans.inpc-result
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 39 COLON-ALIGNED
          &ELSE AT ROW 15 COL 39 COLON-ALIGNED &ENDIF HELP
          "Результат транзакции в процессинге"
          LABEL "Результат" FORMAT "x(20)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-pc-trans.proc-date
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 6 COLON-ALIGNED
          &ELSE AT ROW 18 COL 6 COLON-ALIGNED &ENDIF HELP
          "Дата выполнения транзакции"
          LABEL "Дата" FORMAT "99/99/99"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
     mProcTime
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 22 COLON-ALIGNED
          &ELSE AT ROW 18 COL 22 COLON-ALIGNED &ENDIF HELP
          "Время обработки транзакции в банке"
     tt-pc-trans.user-id-p
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 39 COLON-ALIGNED
          &ELSE AT ROW 18 COL 39 COLON-ALIGNED &ENDIF HELP
          "Пользователь, загрузивший транзакцию"
          LABEL "Обработал" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
     tt-pc-trans.pctr-result
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 59 COLON-ALIGNED
          &ELSE AT ROW 18 COL 59 COLON-ALIGNED &ENDIF HELP
          "Результат обработки транзакции в банке"
          LABEL "Результат" FORMAT "x(18)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 18 BY 1
          &ELSE SIZE 18 BY 1 &ENDIF
     mSeparator1
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 1
          &ELSE AT ROW 5 COL 1 &ENDIF NO-LABEL
     mSeparator2
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 27 COLON-ALIGNED
          &ELSE AT ROW 6 COL 27 COLON-ALIGNED &ENDIF NO-LABEL
     mSeparator3
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 7 COL 27 COLON-ALIGNED
          &ELSE AT ROW 7 COL 27 COLON-ALIGNED &ENDIF NO-LABEL
     mSeparator4
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 8 COL 27 COLON-ALIGNED
          &ELSE AT ROW 8 COL 27 COLON-ALIGNED &ENDIF NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2
         SIZE 80 BY 20.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     mSeparator5
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 27 COLON-ALIGNED
          &ELSE AT ROW 9 COL 27 COLON-ALIGNED &ENDIF NO-LABEL
     mSeparator6
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 10 COL 29
          &ELSE AT ROW 10 COL 29 &ENDIF NO-LABEL
     mSeparator7
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 11 COL 1
          &ELSE AT ROW 11 COL 1 &ENDIF NO-LABEL
     mSeparator8
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 27 COLON-ALIGNED
          &ELSE AT ROW 12 COL 27 COLON-ALIGNED &ENDIF NO-LABEL
     mSeparator9
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 29
          &ELSE AT ROW 13 COL 29 &ENDIF NO-LABEL
     mSeparator10
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 29
          &ELSE AT ROW 14 COL 29 &ENDIF NO-LABEL
     mSeparator11
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 27 COLON-ALIGNED
          &ELSE AT ROW 15 COL 27 COLON-ALIGNED &ENDIF NO-LABEL
     mSeparator12
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 27 COLON-ALIGNED
          &ELSE AT ROW 16 COL 27 COLON-ALIGNED &ENDIF NO-LABEL
     mSeparator13
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 1
          &ELSE AT ROW 17 COL 1 &ENDIF NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2
         SIZE 80 BY 20
        TITLE "".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Temp-Tables and Buffers:
      TABLE: tt-pc-trans T "?" NO-UNDO bisquit pc-trans
      ADDITIONAL-FIELDS:
          FIELD local__template AS LOGICAL   /* Признак шаблон/не шаблон */
          FIELD local__rowid    AS ROWID     /* ROWID записи в БД        */
          FIELD local__id       AS INTEGER   /* Идентификатор записи     */
          FIELD local__upid     AS INTEGER   /* Ссылка на запись в аггрегирующей таблице */
          FIELD user__mode      AS INTEGER   /* Флаг управления записью в БД */
          FIELD eq-type         AS CHARACTER /* Тип устройства в ПЦ */
          /* Additional fields you should place here                      */
          
          /* Записываем ссылку на временную таблицу в специальную таблицу */
          {ln-tthdl.i "tt-pc-trans" "" }
          
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW TERMINAL-SIMULATION ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 21
         WIDTH              = 80
         MAX-HEIGHT         = 21
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 21
         VIRTUAL-WIDTH      = 80
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = yes
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB TERMINAL-SIMULATION 
/* ************************* Included-Libraries *********************** */

{bis-tty.pro}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME fMain
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN tt-pc-trans.acct-pc IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.auth-code IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.card-country IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.cont-date IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.eq-city IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.eq-country IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.eq-location IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.eq-type IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.inpc-arn IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.inpc-code IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.inpc-irn IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.inpc-result IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.inpc-rrn IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.inpc-stan IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.inpc-trans-id IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR TOGGLE-BOX mCardAlien IN FRAME fMain
   1 2 3 4                                                              */
/* SETTINGS FOR TOGGLE-BOX mCardOur IN FRAME fMain
   1 2 3 4                                                              */
/* SETTINGS FOR TOGGLE-BOX mCardSponsor IN FRAME fMain
   1 2 3 4                                                              */
/* SETTINGS FOR FILL-IN tt-pc-trans.mcc IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN mContTime IN FRAME fMain
   1 2 3 4                                                              */
/* SETTINGS FOR FILL-IN mDir IN FRAME fMain
   4                                                                    */
/* SETTINGS FOR TOGGLE-BOX mEquipAlien IN FRAME fMain
   1 2 3 4                                                              */
/* SETTINGS FOR TOGGLE-BOX mEquipOur IN FRAME fMain
   1 2 3 4                                                              */
/* SETTINGS FOR TOGGLE-BOX mEquipSponsor IN FRAME fMain
   1 2 3 4                                                              */
/* SETTINGS FOR FILL-IN mProcTime IN FRAME fMain
   1 2 3 4                                                              */
/* SETTINGS FOR FILL-IN mSeparator1 IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN mSeparator10 IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN mSeparator13 IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN mSeparator6 IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN mSeparator7 IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN mSeparator9 IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN mSurLoanAcq IN FRAME fMain
   3 4                                                                  */
/* SETTINGS FOR FILL-IN mSurLoanCard IN FRAME fMain
   3 4                                                                  */
/* SETTINGS FOR FILL-IN mSurLoanSps IN FRAME fMain
   3 4                                                                  */
/* SETTINGS FOR COMBO-BOX mType IN FRAME fMain
   1 2 3 4                                                              */
/* SETTINGS FOR FILL-IN tt-pc-trans.num-card IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.num-equip IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.pctr-id IN FRAME fMain
   3 EXP-LABEL EXP-FORMAT EXP-HELP                                      */
/* SETTINGS FOR FILL-IN tt-pc-trans.pctr-result IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.pctr-status IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.pl-sys IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.proc-date IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.processing IN FRAME fMain
   3 EXP-LABEL EXP-FORMAT EXP-HELP                                      */
/* SETTINGS FOR FILL-IN tt-pc-trans.user-id IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-pc-trans.user-id-p IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(TERMINAL-SIMULATION)
THEN TERMINAL-SIMULATION:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fMain
/* Query rebuild information for FRAME fMain
     _TblList          = "Temp-Tables.tt-pc-trans"
     _Query            is NOT OPENED
*/  /* FRAME fMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME tt-pc-trans.card-country
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pc-trans.card-country TERMINAL-SIMULATION
ON U1 OF tt-pc-trans.card-country IN FRAME fMain /* Страна */
DO:
   DEF BUFFER country FOR country.

   FOR FIRST country             WHERE
             country.country-alt-id EQ INT(ENTRY(2, pick-value))
      NO-LOCK:
      pick-value = country-engl-name.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-pc-trans.eq-country
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pc-trans.eq-country TERMINAL-SIMULATION
ON U1 OF tt-pc-trans.eq-country IN FRAME fMain /* Страна */
DO:
   DEF BUFFER country FOR country.

   FOR FIRST country             WHERE
             country.country-alt-id EQ INT(ENTRY(2, pick-value))
      NO-LOCK:
      pick-value = country-engl-name.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mCardAlien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mCardAlien TERMINAL-SIMULATION
ON VALUE-CHANGED OF mCardAlien IN FRAME fMain /* Чужая */
DO:
   ASSIGN
      mCardAlien
      mCardOur     = IF mCardAlien
                     THEN NOT mCardAlien
                     ELSE NO
      mCardSponsor = IF mCardAlien
                     THEN NOT mCardAlien
                     ELSE NO

      mCardOur    :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(mCardOur)
      mCardSponsor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(mCardSponsor)

      mCardOur    :SENSITIVE                           = YES
      mCardSponsor:SENSITIVE                           = YES
      mCardAlien  :SENSITIVE                           = NO

      mSurLoanCard:HIDDEN                              = YES

      tt-pc-trans.sur-card                             = ""
      tt-pc-trans.sur-loan-card                        = ""
   .
   APPLY "ENTRY" TO tt-pc-trans.num-card.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mCardOur
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mCardOur TERMINAL-SIMULATION
ON VALUE-CHANGED OF mCardOur IN FRAME fMain /* Наша */
DO:
   ASSIGN
      mCardOur
      mCardAlien    = IF mCardOur
                      THEN NOT mCardOur
                      ELSE NO
      mCardSponsor  = IF mCardOur
                      THEN NOT mCardOur
                      ELSE NO

      mCardAlien  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(mCardAlien)
      mCardSponsor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(mCardSponsor)

      mCardOur    :SENSITIVE                           = NO
      mCardSponsor:SENSITIVE                           = YES
      mCardAlien  :SENSITIVE                           = YES

      mSurLoanCard:HIDDEN                              = NO
   .
   APPLY "ENTRY" TO tt-pc-trans.num-card.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mCardSponsor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mCardSponsor TERMINAL-SIMULATION
ON VALUE-CHANGED OF mCardSponsor IN FRAME fMain /* Спонсора */
DO:
   ASSIGN
      mCardSponsor
      mCardAlien    = IF mCardSponsor
                      THEN NOT mCardSponsor
                      ELSE NO
      mCardOur      = IF mCardSponsor
                      THEN NOT mCardSponsor
                      ELSE NO
      mCardAlien  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(mCardAlien)
      mCardOur    :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(mCardOur)

      mCardOur    :SENSITIVE                           = YES
      mCardSponsor:SENSITIVE                           = NO
      mCardAlien  :SENSITIVE                           = YES

      mSurLoanCard:HIDDEN                              = YES

      tt-pc-trans.sur-card                             = ""
      tt-pc-trans.sur-loan-card                        = ""
   .
   APPLY "ENTRY" TO tt-pc-trans.num-card.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-pc-trans.mcc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pc-trans.mcc TERMINAL-SIMULATION
ON F1 OF tt-pc-trans.mcc IN FRAME fMain /* MCC */
DO:
   RUN Fillmcc.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pc-trans.mcc TERMINAL-SIMULATION
ON LEAVE OF tt-pc-trans.mcc IN FRAME fMain /* MCC */
DO:
   {&BEG_BT_LEAVE}
   RUN Fillmcc.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mEquipAlien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mEquipAlien TERMINAL-SIMULATION
ON VALUE-CHANGED OF mEquipAlien IN FRAME fMain /* Чужое */
DO:
   ASSIGN
      mEquipAlien
      mEquipOur     = IF mEquipAlien
                      THEN NOT mEquipAlien
                      ELSE NO
      mEquipSponsor = IF mEquipAlien
                      THEN NOT mEquipAlien
                      ELSE NO
      mEquipOur    :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(mEquipOur)
      mEquipSponsor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(mEquipSponsor)

      mSurLoanAcq  :HIDDEN                              = YES

      mEquipOur    :SENSITIVE                           = YES
      mEquipSponsor:SENSITIVE                           = YES
      mEquipAlien  :SENSITIVE                           = NO

      tt-pc-trans.sur-equip                             = ""
      tt-pc-trans.sur-loan-acq                          = ""
   .
   APPLY "ENTRY" TO tt-pc-trans.num-equip.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mEquipOur
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mEquipOur TERMINAL-SIMULATION
ON VALUE-CHANGED OF mEquipOur IN FRAME fMain /* Наше */
DO:
   ASSIGN
      mEquipOur
      mEquipAlien   = IF mEquipOur
                      THEN NOT mEquipOur
                      ELSE NO
      mEquipSponsor = IF mEquipOur
                      THEN NOT mEquipOur
                      ELSE NO

      mEquipAlien  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(mEquipAlien)
      mEquipSponsor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(mEquipSponsor)

      mSurLoanAcq  :HIDDEN                              = NO

      mEquipOur    :SENSITIVE                           = NO
      mEquipSponsor:SENSITIVE                           = YES
      mEquipAlien  :SENSITIVE                           = YES
   .
   APPLY "ENTRY" TO tt-pc-trans.num-equip.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mEquipSponsor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mEquipSponsor TERMINAL-SIMULATION
ON VALUE-CHANGED OF mEquipSponsor IN FRAME fMain /* Спонсора */
DO:
   ASSIGN
      mEquipSponsor
      mEquipAlien = IF mEquipSponsor
                    THEN NOT mEquipSponsor
                    ELSE NO
      mEquipOur   = IF mEquipSponsor
                    THEN NOT mEquipSponsor
                    ELSE NO

      mEquipAlien  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(mEquipAlien)
      mEquipOur    :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(mEquipOur)

      mSurLoanAcq  :HIDDEN                              = YES

      mEquipOur    :SENSITIVE                           = YES
      mEquipSponsor:SENSITIVE                           = NO
      mEquipAlien  :SENSITIVE                           = YES

      tt-pc-trans.sur-equip                             = ""
      tt-pc-trans.sur-loan-acq                          = ""
   .
   APPLY "ENTRY" TO tt-pc-trans.num-equip.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mType TERMINAL-SIMULATION
ON LEAVE OF mType IN FRAME fMain /* Тип */
DO:
   {&BT_LEAVE}

   IF NOT {assigned mType:SCREEN-VALUE}
   THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0",
         "Поле тип транзакции должно быть заполнено.").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mType TERMINAL-SIMULATION
ON VALUE-CHANGED OF mType IN FRAME fMain /* Тип */
DO:
   DEF BUFFER code FOR code.

   ASSIGN
      mType
   .

   FOR FIRST code     WHERE
             code.class  EQ "op-int"
         AND code.code   EQ mType
      NO-LOCK:
      mDir:SCREEN-VALUE = code.misc[1].
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-pc-trans.num-card
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pc-trans.num-card TERMINAL-SIMULATION
ON F1 OF tt-pc-trans.num-card IN FRAME fMain /* Номер */
DO:
   DEF BUFFER loan FOR loan.

   IF   (iMode EQ {&MOD_ADD}
      OR iMode EQ {&MOD_EDIT})
     AND mCardOur
   THEN DO:
      {empty ttRetVal}
      RUN browseld.p("card"
                     ,
                     "RetRcp"                             + CHR(1) +
                     "RetFld"                             + CHR(1) +
                     "RetType"
                     ,
                     STRING(TEMP-TABLE ttRetVal:HANDLE)   + CHR(1) +
                     "ROWID"                              + CHR(1) +
                     "Singl"
                     ,
                     ""
                     ,
                     iLevel + 1
      ).
      FOR FIRST ttRetVal,
         FIRST loan     WHERE
         ROWID(loan)       EQ TO-ROWID(ttRetVal.pickvalue)
         NO-LOCK:
         ASSIGN
            tt-pc-trans.sur-card              = loan.contract + "," + loan.cont-code
            tt-pc-trans.sur-loan-card         = loan.parent-contract + "," + loan.parent-cont-code
            mSurLoanCard        :SCREEN-VALUE = loan.parent-cont-code
            tt-pc-trans.num-card:SCREEN-VALUE = loan.doc-num
         .
      END.
   END.

   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pc-trans.num-card TERMINAL-SIMULATION
ON LEAVE OF tt-pc-trans.num-card IN FRAME fMain /* Номер */
DO:
   {&BT_LEAVE}
   DEF BUFFER code FOR code.

   IF    (iMode EQ {&MOD_ADD}
      OR  iMode EQ {&MOD_EDIT})
      AND mCardOur
   THEN DO:
      ASSIGN tt-pc-trans.num-card.

      FIND FIRST loan       WHERE
                 loan.contract EQ "card"
             AND loan.doc-num  EQ tt-pc-trans.num-card
         NO-LOCK NO-ERROR.
      IF NOT AVAIL loan
      THEN DO:
         RUN Fill-SysMes IN h_tmess ("", "", "0",
            "Такой карты нет в системе").
         RETURN NO-APPLY {&RET-ERROR}.
      END.

      ELSE DO:
         FIND FIRST code     WHERE
                    code.class  EQ "КартыБанка"
                AND code.code   EQ loan.sec-code
            NO-LOCK NO-ERROR.
         IF NOT AVAIL code
         THEN DO:
            RUN Fill-SysMes IN h_tmess ("", "", "0",
               "Не найдена запись [ " + (IF loan.sec-code NE ? THEN loan.sec-code ELSE '')
               + " ] в классификаторе КартыБанка.").
            RETURN NO-APPLY {&RET-ERROR}.
         END.
         ELSE DO:
            IF code.misc[2] NE tt-pc-trans.processing
            THEN DO:
               RUN Fill-SysMes IN h_tmess ("", "", "0",
                  "Процессинг карты [ " + code.misc[2] + " ]"
                 + "~nне соответствует процессингу транзакции [ "
                 + tt-pc-trans.processing + " ]").
               RETURN NO-APPLY {&RET-ERROR}.
            END.            
         END.

         ASSIGN
            tt-pc-trans.sur-card      = loan.contract + "," + loan.cont-code
            tt-pc-trans.sur-loan-card = loan.parent-contract + "," + loan.parent-cont-code
            mSurLoanCard:SCREEN-VALUE = loan.parent-cont-code
         .
      END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-pc-trans.num-equip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pc-trans.num-equip TERMINAL-SIMULATION
ON F1 OF tt-pc-trans.num-equip IN FRAME fMain /* Номер */
DO:
   DEF BUFFER loan FOR loan.

   IF   (iMode EQ {&MOD_ADD}
      OR iMode EQ {&MOD_EDIT})
     AND mEquipOur
   THEN DO:
      {empty ttRetVal}
      RUN browseld.p("card-equip"
                     ,
                     "RetRcp"                             + CHR(1) +
                     "RetFld"                             + CHR(1) +
                     "RetType"
                     ,
                     STRING(TEMP-TABLE ttRetVal:HANDLE)   + CHR(1) +
                     "ROWID"                              + CHR(1) +
                     "Singl"
                     ,
                     ""
                     ,
                     iLevel + 1
      ).
      FOR FIRST ttRetVal,
         FIRST loan     WHERE
         ROWID(loan)       EQ TO-ROWID(ttRetVal.pickvalue)
         NO-LOCK:
         ASSIGN
            tt-pc-trans.sur-equip              = loan.contract + "," + loan.cont-code
            tt-pc-trans.sur-loan-acq           = loan.parent-contract + "," + loan.parent-cont-code
            mSurLoanAcq          :SCREEN-VALUE = loan.parent-cont-code
            tt-pc-trans.num-equip:SCREEN-VALUE = loan.doc-num
         .
      END.
   END.

   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pc-trans.num-equip TERMINAL-SIMULATION
ON LEAVE OF tt-pc-trans.num-equip IN FRAME fMain /* Номер */
DO:
   {&BT_LEAVE}

   IF    (iMode EQ {&MOD_ADD}
       OR iMode EQ {&MOD_EDIT})
      AND mEquipOur
   THEN DO:
      ASSIGN tt-pc-trans.num-equip.

      FIND FIRST loan       WHERE
                 loan.contract EQ "card-equip"
             AND loan.doc-num  EQ tt-pc-trans.num-equip
         NO-LOCK NO-ERROR.
      IF NOT AVAIL loan
      THEN DO:
         RUN Fill-SysMes IN h_tmess ("", "", "0",
            "Такого устройства нет в системе.").
         RETURN NO-APPLY {&RET-ERROR}.
      END.

      ELSE DO:
         IF loan.trade-sys NE tt-pc-trans.processing:SCREEN-VALUE
         THEN DO:
            RUN Fill-SysMes IN h_tmess ("", "", "0",
               "Процессинг устройства [ "
               + (IF loan.trade-sys NE ? THEN loan.trade-sys ELSE '')
               + " ]~nне соответствует процессингу транзакции [ "
               + tt-pc-trans.processing:SCREEN-VALUE + " ]."
            ).
            RETURN NO-APPLY {&RET-ERROR}.
         END.

         IF NOT CAN-DO(loan.cont-cli, tt-pc-trans.pl-sys:SCREEN-VALUE)
         THEN DO:
            RUN Fill-SysMes IN h_tmess ("", "", "0",
               "Код платежной системы транзакции [ "
               + tt-pc-trans.pl-sys:SCREEN-VALUE
               + " ]~nне соответствует ни одному из кодов платежной системы устройства~n[ "
               + (IF loan.cont-cli NE ? THEN loan.cont-cli ELSE '') + " ]."
            ).
            RETURN NO-APPLY {&RET-ERROR}.
         END.

         ASSIGN
            tt-pc-trans.sur-equip    = loan.contract + "," + loan.cont-code
            tt-pc-trans.sur-loan-acq = loan.parent-contract + "," + loan.parent-cont-code
            mSurLoanAcq:SCREEN-VALUE = loan.parent-cont-code
         .
      END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK TERMINAL-SIMULATION 


/* ***************************  Main Block  *************************** */
&IF DEFINED(SESSION-REMOTE) EQ 0 &THEN
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
ON ENDKEY, END-ERROR, F9 OF FRAME fMain ANYWHERE DO:
   mRetVal = IF mOnlyForm THEN
      {&RET-ERROR}
      ELSE 
         "".
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.
&ENDIF
/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

RUN StartBisTTY.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

   /** Pir ПИР Buryagin:
       Проверка, может ли пользователь вручную создавать или изменять 
       объекты с помощью данной формы 
   */
   IF iMode EQ {&MOD_ADD} THEN DO:
     {pir-brw.acc &file="pir-pctr-brw" &action="ins" &cannot="LEAVE MAIN-BLOCK."}
   END.
   IF iMode EQ {&MOD_EDIT} THEN DO:
   	 {pir-brw.acc &file="pir-pctr-brw" &action="f9" &cannot="LEAVE MAIN-BLOCK."}
   END.
   
   /* Commented by KSV: Инициализация системных сообщений */
   RUN Init-SysMes("","","").

   /* Commented by KSV: Корректируем вертикальную позицию фрейма */
   iLevel = GetCorrectedLevel(FRAME fMain:HANDLE,iLevel).
   FRAME fMain:ROW = iLevel.

   /* Commented by KSV: Читаем данные */
   RUN GetObject.

   /* Заполняем COMBO-BOX'ы данными из метасхемы */
   RUN FillComboBox(FRAME {&MAIN-FRAME}:HANDLE).

   /* Подсветка полей из LIST-5 (настроить для себя )*/
   RUN SetColorList(FRAME {&MAIN-FRAME}:HANDLE,
                    REPLACE("{&LIST-5}"," ",","),
                    "bright-green").

   /* Commented by KSV: Показываем экранную форму */
   STATUS DEFAULT "".
&IF DEFINED(SESSION-REMOTE) EQ 0 &THEN
   RUN enable_UI.
&ENDIF
   /* Commented by KSV: Открываем те поля, которые разрешено изменять
   ** в зависимости от режима открытия */
   RUN EnableDisable.
&IF DEFINED(SESSION-REMOTE) &THEN
   LEAVE MAIN-BLOCK.
&ENDIF

   /* Commented by KSV: Рисуем разделители. Разделители задаются как FILL-IN
   ** с идентификатором SEPARATOR# с атрибутом VIES-AS TEXT */
   RUN Separator(FRAME fMain:HANDLE,"1").

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE FOCUS mFirstTabItem.
END.

/* Commented by KSV: Закрываем службу системных сообщений */
RUN End-SysMes.

&IF DEFINED(SESSION-REMOTE) = 0 &THEN
RUN disable_ui.
&ENDIF

RUN EndBisTTY.

/* Commented by KSV: Выгружаем библиотеки */
{intrface.del}

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
  DISPLAY mNamePlSys mSurLoanSps mType mDir mContTime mCardOur mCardSponsor 
          mCardAlien mSurLoanCard mEquipOur mEquipSponsor mEquipAlien 
          mSurLoanAcq mProcTime mSeparator1 mSeparator2 mSeparator3 mSeparator4 
          mSeparator5 mSeparator6 mSeparator7 mSeparator8 mSeparator9 
          mSeparator10 mSeparator11 mSeparator12 mSeparator13 
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-pc-trans THEN 
    DISPLAY tt-pc-trans.processing tt-pc-trans.pl-sys tt-pc-trans.pctr-id 
          tt-pc-trans.pctr-status tt-pc-trans.cont-date tt-pc-trans.user-id 
          tt-pc-trans.num-card tt-pc-trans.card-country tt-pc-trans.num-equip 
          tt-pc-trans.eq-country tt-pc-trans.eq-city tt-pc-trans.eq-location 
          tt-pc-trans.mcc tt-pc-trans.eq-type tt-pc-trans.inpc-stan 
          tt-pc-trans.inpc-arn tt-pc-trans.inpc-irn tt-pc-trans.inpc-rrn 
          tt-pc-trans.inpc-trans-id tt-pc-trans.inpc-code tt-pc-trans.auth-code 
          tt-pc-trans.acct-pc tt-pc-trans.inpc-result tt-pc-trans.proc-date 
          tt-pc-trans.user-id-p tt-pc-trans.pctr-result 
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  ENABLE tt-pc-trans.processing mNamePlSys mSurLoanSps tt-pc-trans.pl-sys mType 
         mDir tt-pc-trans.pctr-id tt-pc-trans.pctr-status tt-pc-trans.cont-date 
         mContTime tt-pc-trans.user-id mCardOur mCardSponsor mCardAlien 
         tt-pc-trans.num-card tt-pc-trans.card-country mSurLoanCard mEquipOur 
         mEquipSponsor mEquipAlien tt-pc-trans.num-equip tt-pc-trans.eq-country 
         tt-pc-trans.eq-city tt-pc-trans.eq-location tt-pc-trans.mcc 
         mSurLoanAcq tt-pc-trans.eq-type tt-pc-trans.inpc-stan 
         tt-pc-trans.inpc-arn tt-pc-trans.inpc-irn tt-pc-trans.inpc-rrn 
         tt-pc-trans.inpc-trans-id tt-pc-trans.inpc-code tt-pc-trans.auth-code 
         tt-pc-trans.acct-pc tt-pc-trans.inpc-result tt-pc-trans.proc-date 
         mProcTime tt-pc-trans.user-id-p tt-pc-trans.pctr-result mSeparator1 
         mSeparator2 mSeparator3 mSeparator4 mSeparator5 mSeparator6 
         mSeparator7 mSeparator8 mSeparator9 mSeparator10 mSeparator11 
         mSeparator12 mSeparator13 
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW TERMINAL-SIMULATION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Fillmcc TERMINAL-SIMULATION 
PROCEDURE Fillmcc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR vPlSys AS CHAR NO-UNDO.

   DEF BUFFER code1 FOR code.
   DEF BUFFER code2 FOR code.

   /* ищем ДР платежной системы */
   FIND FIRST code1 WHERE code1.class EQ "платсистемы"
                      AND code1.code  EQ tt-pc-trans.pl-sys:SCREEN-VALUE IN FRAME {&MAIN-FRAME}
   NO-LOCK NO-ERROR.

   IF AVAIL code1 THEN
   DO TRANS:
      ASSIGN
         pick-value = ""
         vPlSys     = GetXattrValue("code", code1.class + "," + code1.code, "mcc_code")
      .

      IF    (iMode   EQ {&MOD_ADD}
          OR iMode   EQ {&MOD_EDIT})
         AND LASTKEY EQ KEYCODE("F1")
         AND tt-pc-trans.mcc:HANDLE IN FRAME {&MAIN-FRAME} EQ FOCUS THEN
      DO:
         RUN browseld.p ("code"
                         ,
                         "class"                                         + CHR(1) +
                         "parent"
                         ,
                         vPlSys                                          + CHR(1) +
                         vPlSys
                         ,
                         "class"                                         + CHR(1) +
                         "parent"
                         ,
                         4).
      END.
      ELSE
         pick-value = tt-pc-trans.mcc:SCREEN-VALUE IN FRAME {&MAIN-FRAME}.

      IF pick-value NE "" THEN
         FIND FIRST code2 WHERE code2.class EQ vPlSys
                            AND code2.code  EQ pick-value
         NO-LOCK NO-ERROR.
   END.

   IF     AVAIL code1
      AND AVAIL code2 THEN
      ASSIGN
         tt-pc-trans.mcc:SCREEN-VALUE IN FRAME {&MAIN-FRAME} = pick-value WHEN iMode EQ {&MOD_ADD} OR iMode EQ {&MOD_EDIT}
         mNamePlSys     :SCREEN-VALUE IN FRAME {&MAIN-FRAME} = code2.name
      .
   ELSE 
      mNamePlSys     :SCREEN-VALUE IN FRAME {&MAIN-FRAME} = "=Не найдено=".

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
   DEF BUFFER xattr FOR xattr.

   IF iMode EQ {&MOD_ADD} THEN
      ASSIGN
         mCardOur                 :SENSITIVE    IN FRAME {&MAIN-FRAME} = NO
         mEquipOur                :SENSITIVE    IN FRAME {&MAIN-FRAME} = NO
         mProcTime                :SCREEN-VALUE IN FRAME {&MAIN-FRAME} = ""

         mContTime                :SCREEN-VALUE IN FRAME {&MAIN-FRAME} = STRING(TIME, "HH:MM")

         tt-pc-trans.cont-date    :SCREEN-VALUE IN FRAME {&MAIN-FRAME} = STRING(TODAY)

         tt-pc-trans.card-country :SCREEN-VALUE IN FRAME {&MAIN-FRAME} = "RUS"

         tt-pc-trans.eq-country   :SCREEN-VALUE IN FRAME {&MAIN-FRAME} = "RUS"
      .
   ELSE DO:
      ASSIGN
         mContTime   :SCREEN-VALUE = IF    tt-pc-trans.cont-time EQ 0
                                        OR tt-pc-trans.cont-time EQ ?
                                     THEN ""
                                     ELSE STRING(tt-pc-trans.cont-time, "HH:MM")
         mProcTime   :SCREEN-VALUE = IF    tt-pc-trans.proc-time EQ 0
                                        OR tt-pc-trans.proc-time EQ ?
                                     THEN ""
                                     ELSE STRING(tt-pc-trans.proc-time, "HH:MM")

         mSurLoanSps :SCREEN-VALUE = GetEntries(2, tt-pc-trans.sur-loan-sps , ",", "")
         mSurLoanCard:SCREEN-VALUE = GetEntries(2, tt-pc-trans.sur-loan-card, ",", "")
         mSurLoanAcq :SCREEN-VALUE = GetEntries(2, tt-pc-trans.sur-loan-acq , ",", "")
         mDir        :SCREEN-VALUE = IF tt-pc-trans.dir
                                     THEN "Прямая"
                                     ELSE "Обратная"
      .

      CASE GetEntries(2, tt-pc-trans.pctr-code, CHR(1) , "1"):
         WHEN "0" THEN
            ASSIGN
               mCardAlien   :SENSITIVE     = NO
               mCardAlien   :SCREEN-VALUE  = "YES"
               mCardSponsor :SCREEN-VALUE  = "NO"
               mCardOur     :SCREEN-VALUE  = "NO"
               mCardAlien  
               mCardSponsor
               mCardOur    
               mSurLoanCard :HIDDEN        = YES
               tt-pc-trans.sur-card        = ""
               tt-pc-trans.sur-loan-card   = ""

            .
         WHEN "2" THEN
            ASSIGN
               mCardSponsor :SENSITIVE     = NO
               mCardSponsor :SCREEN-VALUE  = "YES"
               mCardAlien   :SCREEN-VALUE  = "NO"
               mCardOur     :SCREEN-VALUE  = "NO"
               mCardAlien  
               mCardSponsor
               mCardOur    
               mSurLoanCard :HIDDEN        = YES
               tt-pc-trans.sur-card        = ""
               tt-pc-trans.sur-loan-card   = ""
            .
         OTHERWISE
            ASSIGN
               mCardOur     :SENSITIVE     = NO
               mCardOur     :SCREEN-VALUE  = "YES"
               mCardSponsor :SCREEN-VALUE  = "NO"
               mCardAlien   :SCREEN-VALUE  = "NO"
               mCardAlien  
               mCardSponsor
               mCardOur    
               mSurLoanCard :HIDDEN        = NO

            .
      END CASE.

      CASE GetEntries(3, tt-pc-trans.pctr-code, CHR(1) , "1"):
         WHEN "0" THEN
            ASSIGN
               mEquipAlien  :SENSITIVE      = NO
               mEquipAlien  :SCREEN-VALUE   = "YES"
               mEquipSponsor:SCREEN-VALUE   = "NO"
               mEquipOur    :SCREEN-VALUE   = "NO"
               mEquipAlien  
               mEquipSponsor
               mEquipOur    
               mSurLoanAcq  :HIDDEN         = YES
               tt-pc-trans.sur-equip        = ""
               tt-pc-trans.sur-loan-acq     = ""
            .
         WHEN "2" THEN
            ASSIGN
               mEquipSponsor:SENSITIVE      = NO
               mEquipSponsor:SCREEN-VALUE   = "YES"
               mEquipAlien  :SCREEN-VALUE   = "NO"
               mEquipOur    :SCREEN-VALUE   = "NO"
               mEquipAlien  
               mEquipSponsor
               mEquipOur    
               mSurLoanAcq  :HIDDEN         = YES
               tt-pc-trans.sur-equip        = ""
               tt-pc-trans.sur-loan-acq     = ""

            .
         OTHERWISE
            ASSIGN
               mEquipOur    :SENSITIVE      = NO
               mEquipOur    :SCREEN-VALUE   = "YES"
               mEquipSponsor:SCREEN-VALUE   = "NO"
               mEquipAlien  :SCREEN-VALUE   = "NO"
               mEquipAlien  
               mEquipSponsor
               mEquipOur    
               mSurLoanAcq  :HIDDEN         = NO
            .
      END CASE.
   END.

   FOR FIRST xattr         WHERE
             xattr.data-type  NE "class"
         AND xattr.Class-Code EQ tt-pc-trans.class-code
         AND xattr.Xattr-Code EQ "pctr-code"
      NO-LOCK:
      mType:LIST-ITEMS IN FRAME fMain = Xattr.Validation.
   END.

   mType:SCREEN-VALUE = GetEntries(1, tt-pc-trans.pctr-code, CHR(1) , "").

   IF iMode EQ {&MOD_VIEW} THEN
      ASSIGN
         mCardOur     :SENSITIVE = NO
         mCardSponsor :SENSITIVE = NO
         mCardAlien   :SENSITIVE = NO
         mEquipOur    :SENSITIVE = NO
         mEquipSponsor:SENSITIVE = NO
         mEquipAlien  :SENSITIVE = NO
      .

   RUN GetXAttr(tt-pc-trans.class-code,"eq-type",BUFFER Xattr).
   ASSIGN
      tt-pc-trans.eq-type:SENSITIVE = AVAIL Xattr
      tt-pc-trans.eq-type:VISIBLE   = AVAIL Xattr
   .


   RUN Fillmcc.
   RETURN.
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

   ASSIGN FRAME fMain mContTime mProcTime.

   IF TRIM(mContTime, "0123456789") NE ""   THEN
      RETURN ERROR "Реквизит ""Время выполнения"" может содержать только цифры.".

   IF INT(SUBSTRING(mContTime, 1, 2)) GT 23 THEN
      RETURN ERROR "Количество часов в поле ""Время выполнения"" не может быть больше 23. Указано: "
    + SUBSTRING(mContTime, 1,2).

   IF INT(SUBSTRING(mContTime, 3, 2)) GT 59 THEN
      RETURN ERROR "Количество минут в поле ""Время выполнения"" не может быть больше 59. Указано: "
       + SUBSTRING(mContTime, 3,2).

   IF mContTime EQ ""
   THEN tt-pc-trans.cont-time = 0.
   ELSE tt-pc-trans.cont-time = INT(SUBSTRING(mContTime,1,2)) * 3600 + 
                                    INT(SUBSTRING(mContTime,3,2)) * 60.

   IF TRIM(mProcTime, "0123456789") NE ""   THEN
      RETURN ERROR "Реквизит ""Время обработки"" может содержать только цифры.".

   IF INT(SUBSTRING(mProcTime, 1, 2)) GT 23 THEN
      RETURN ERROR "Количество часов в поле ""Время обработки"" не может быть больше 23. Указано: "
    + SUBSTRING(mProcTime, 1,2).

   IF INT(SUBSTRING(mProcTime, 3, 2)) GT 59 THEN
      RETURN ERROR "Количество минут в поле ""Время обработки"" не может быть больше 59. Указано: "
       + SUBSTRING(mProcTime, 3,2).
       
   IF mProcTime EQ ""
   THEN tt-pc-trans.proc-time = 0.
   ELSE tt-pc-trans.proc-time = INT(SUBSTRING(mProcTime,1,2)) * 3600 + 
                                    INT(SUBSTRING(mProcTime,3,2)) * 60.

   ASSIGN
      tt-pc-trans.pctr-code = mType:SCREEN-VALUE + CHR(1)
         + (IF mCardOur  THEN "1" ELSE IF mCardSponsor  THEN "2" ELSE "0") + CHR(1)
         + (IF mEquipOur THEN "1" ELSE IF mEquipSponsor THEN "2" ELSE "0")

      tt-pc-trans.dir = IF mDir:SCREEN-VALUE EQ "Прямая"
                        THEN YES
                        ELSE NO
   .

   RETURN.
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

   DEF BUFFER code FOR code.

   IF iMode EQ {&MOD_ADD}
   THEN DO:
/* Договор со спонсором - заполняется значением договора из классификатора Процессинги,
** соответствующим выбранному процессингу */
      FIND FIRST code     WHERE
                 code.class  EQ "Процессинги"
             AND code.parent EQ "Процессинги"
             AND code.code   EQ tt-pc-trans.processing
         NO-LOCK NO-ERROR.
      IF AVAIL code THEN
         ASSIGN
            mSurLoanSps:SCREEN-VALUE IN FRAME {&MAIN-FRAME} = code.misc[1]
            tt-pc-trans.sur-loan-sps                        = "card-sps," + code.misc[1]
         .
      ELSE DO:
         RUN Fill-SysMes IN h_tmess ("", "", "0",
            "Не найден процессинг [ " + tt-pc-trans.processing
          + " ] в справочнике процессингов!").
         RETURN ERROR.
      END.
   END.

   ASSIGN
      mSeparator1  = "── Карта ───────────────────┬─ Устройство ────────────────────────────────────"
      mSeparator2  = "│"
      mSeparator3  = "│"
      mSeparator4  = "│"
      mSeparator5  = "│"
      mSeparator6  = "│"
      mSeparator7  = "── Номера в ПЦ ─────────────┼─ Значения в ПЦ ─────────────────────────────────"
      mSeparator8  = "│"
      mSeparator9  = "│"
      mSeparator10 = "│"
      mSeparator11 = "│"
      mSeparator12 = "│"
      mSeparator13 = "── Обработка ───────────────┴─────────────────────────────────────────────────"
   .

   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

