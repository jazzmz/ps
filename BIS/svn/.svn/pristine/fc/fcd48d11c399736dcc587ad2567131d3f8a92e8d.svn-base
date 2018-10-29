/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2010 ТОО "Банковские информационные системы"
     Filename: ree-136i.p
      Comment: Кассовая инструкция 136-И
   Parameters:
         Uses: 
      Used by:
      Created: 20.10.2010 MUTA 0134850: Кассовая инструкция 136-И

*/

{globals.i}
{tmprecid.def}
{intrface.get xclass} 
{intrface.get count} 

{get-bankname.i}


/*******************************
 * Получаем счетчик 	       *
 * для электронного архива.    *
 *******************************
 * Автор: Маслов Д. А.         *
 * Дата создания: 06.03.2012   *
 * Заявка: #862                *
 *******************************/
&GLOBAL-DEFINE arch2 1
&GLOBAL-DEFINE notCheckAuthorInspector 1

{pir-out2arch.i}

DEFINE INPUT PARAM iParam AS CHAR NO-UNDO.

FIND FIRST tmprecid NO-LOCK NO-ERROR.
IF NOT AVAIL tmprecid THEN
DO:
   MESSAGE "Не выбраны документы" VIEW-AS ALERT-BOX.
   RETURN.
END.
{ree-113i.def}
{wordwrap.def}

DEFINE VARIABLE mAcctPer  AS CHARACTER        NO-UNDO.
DEFINE VARIABLE mReeNum   AS INT64 INIT 1     NO-UNDO.
DEFINE VARIABLE mOpReeNum AS CHARACTER        NO-UNDO.
DEFINE VARIABLE mIsEmpty  AS LOGICAL INIT YES NO-UNDO.
DEFINE VARIABLE mAdrK     AS CHARACTER   NO-UNDO EXTENT 2.
DEFINE VAR Stamp_YN AS LOGICAL NO-UNDO INIT NO.

DEF BUFFER op-entry3 FOR op-entry.

{tmprecid.def &PREF = "tt-"
              &NGSH = YES
}

DEF TEMP-TABLE tt-itog NO-UNDO
   FIELD vidop AS CHAR
   FIELD val5  AS CHAR
   FIELD val7  AS CHAR
   FIELD val11 AS CHAR
   FIELD sum6  AS DEC
   FIELD sum8  AS DEC
   FIELD sum12 AS DEC
   FIELD sprate AS DEC
   .

before:
DO TRANSACTION:

ASSIGN
   mNaznSchKas = FGetSetting("НазнСчКас","","")
   mScetKomis  = FGetSetting("И113","СчетКомис","")
   mCodNVal    = FGetSetting("КодНацВал","","")
   mAcctPer    = FGetSetting ("И113","СчПереводов","")
.

IF NUM-ENTRIES(iParam,";") >= 1 THEN
   ASSIGN
      mParam[1]   = ENTRY(1,iParam,";")
      mBranchMask = mParam[1]
   .
IF NUM-ENTRIES(iParam,";") >= 2 THEN
   ASSIGN
      mParam[2] = ENTRY(2,iParam,";")
      mUserMask = mParam[2]
   .
IF NUM-ENTRIES(iParam,";")   GT 3
   AND TRIM(ENTRY(4,iParam,";")) EQ "ДА" THEN
   mPrintOpNum = TRUE. 

/* сохраним наши документы */
RUN rid-rest.p (OUTPUT TABLE tt-tmprecid).
{empty tmprecid}

FIND FIRST tt-tmprecid.        
FIND FIRST op WHERE RECID(op) EQ tt-tmprecid.id NO-LOCK NO-ERROR.

/* запрос подразделений и пользователей */
PAUSE 0.
   UPDATE 
      mBranchMask
      mUserMask
      mReeNum LABEL "Номер реестра     "
   WITH FRAME enter-cond
      WIDTH 60
      SIDE-LABELS
      CENTERED
      ROW 10
      TITLE "[ Выберете подразделение и пользователя ]"
      OVERLAY
   EDITING:
         READKEY.
         IF    FRAME-FIELD EQ "mBranchMask"
           AND LASTKEY = 301 THEN 
         DO:
            RUN browseld.p ("branch",
                            "parent-id",
                            "*",
                            ?,
                            4).
            if keyfunc(lastkey) NE "end-error" then
            DO:
               ASSIGN
                  mBranchMask = pick-value
                  mBranchMask:SCREEN-VALUE = pick-value.
               RELEASE branch.
            END.
         END.
         ELSE IF    FRAME-FIELD EQ "mUserMask"
                AND LASTKEY = 301 THEN 
         DO:
            RUN browseld.p ("_user", /* Класс объекта. */
                            "_userid",     /* Поля для предустановки. */
                            "*" ,      /* Список значений полей. */
                            ?,      /* Поля для блокировки. */
                            6). /* Строка отображения фрейма. */
            if keyfunc(lastkey) NE "end-error" then
            DO:
               ASSIGN
                  mUserMask = pick-value
                  mUserMask:SCREEN-VALUE = pick-value.
               RELEASE _user.
            END.
         END.
         ELSE IF LASTKEY EQ 27 THEN
         DO:
            /* восстановим recid's на наши документы */
            {empty tmprecid}
            
            FOR EACH tt-tmprecid:
               CREATE tmprecid.
               tmprecid.id = tt-tmprecid.id.
            END.
            HIDE FRAME enter-cond.
            RETURN.
         END.
         ELSE
            APPLY LASTKEY.
   END.
   HIDE FRAME enter-cond.

/* восстановим recid's на наши документы */
   {empty tmprecid}
   
   FOR EACH tt-tmprecid:
      CREATE tmprecid.
      tmprecid.id = tt-tmprecid.id.
   END.
 
ASSIGN
   mNameBank  = cBankName
   mREGN      = FGetSetting("REGN","","")
   mAdres-pch = FGetSetting("Адрес_пч","","")
.
IF mBranchMask EQ "*" THEN
   mAdres-kass = TRIM(mNameBank + " " + mAdres-pch).
ELSE DO:
   FIND FIRST branch WHERE branch.Branch-Id EQ mBranchMask NO-LOCK NO-ERROR.
   mAdres-kass = (IF AVAIL(branch)  THEN (branch.name + " ") ELSE "") + 
                 GetXAttrValueEx("branch",
                                 STRING(mBranchMask),
                                 "Адрес_юр",
                                 mAdres-pch).
   END.

mAdrK[1] = madres-kass.

{wordwrap.i
  &s = mAdrK
  &n = 2
  &l = 50
}

END. /*before*/


/* ----------------------------------------------------------------------------------------------------------------------------------- */
/* PIR arhiv */
DEFINE VARIABLE prefix      AS CHARACTER NO-UNDO.
DEFINE VARIABLE in-end-date LIKE op.op-date NO-UNDO.
DEFINE BUFFER history1 FOR history.

in-end-date = gend-date.
prefix = "ree" + "_" + userid + "_" + STRING(mReeNum).

IF (mBranchMask EQ "00002")
THEN
   prefix ="ree_p".

{pirraproc.def}
{pirraproc.i &arch_file_name = ".txt" &prefix = "yes"}
{setdest.i &cols=178}
/* Konec vstavki PIR ------------------------------------
{setdest.i &cols=178} */
{justamin}

ASSIGN
   mDocNum    = 1.

FOR EACH tmprecid NO-LOCK,
   FIRST op WHERE RECID(op) EQ tmprecid.id
              AND CAN-DO(mUserMask,op.user-id)
              AND (op.op-status EQ "√√")
         NO-LOCK,
   LAST history1
      WHERE history1.file-name EQ "op"
        AND history1.field-ref EQ STRING(op.op)
        AND history1.modify    EQ "W"
        AND history1.field-value MATCHES "*op-status*"
      NO-LOCK,
   EACH op-entry OF op NO-LOCK
   BREAK BY history1.modif-time
         BY op.op
:

/*----------------------------------------------- Выборка ----------------------------------------------------------------------*/
   mOpReeNum = GetXattrValueEx ("op",
                                STRING (op.op),
                                "НомерРеестра",
                                "").
   IF mOpReeNum NE "" AND         /* документ уже включен в другой реестр */
      mOpReeNum NE STRING (mReeNum) THEN
      NEXT.

   {ree-113i.sel}

   IF NOT (   CAN-DO(mBranchMask,acct-cr.branch-id)
           OR CAN-DO(mBranchMask,acct-db.branch-id)
           ) THEN NEXT.

   IF CAN-DO(mScetKomis,op-entry.acct-cr) OR 
      CAN-DO(mScetKomis,op-entry.acct-db) THEN
      NEXT.

/* Получение данных
Каждая строка отчета содержит информацию об отдельном документе и (полу)проводках, 
   связанных с ним. Если в документе есть две полупроводки, то анализируются обе. 
   Если их более двух, то анализируются первые проводки, в которых заполнены поля 
   дебет и кредит.
*/

   IF mIsEmpty THEN DO:
      mIsEmpty = NO.
/***
      RUN PrintHeader. /* Вывод заголовка */
***/
/*********************************************************************/
/***  03.08.2012 г. tvv   ***/
      &IF DEFINED(nomess)=0 &THEN
        MESSAGE " Обслуживание в послеоперационное время? " VIEW-AS ALERT-BOX BUTTONS YES-NO TITLE " Запрос печати штампа " SET Stamp_YN.
      &ENDIF
      IF Stamp_YN THEN
        RUN PrintHeader_Stamp.  /* Печать штампа */
      ELSE
        RUN PrintHeader.       /* Печать Без штампа */
/*********************************************************************/

   END.

   ASSIGN
      m5 = ""
      m6 = 0
      m7 = ""
      m8 = 0
      m10 = 0
      m11 = ""
      m12 = 0
      m13 = ""
      m15 = ""
      mDocId = ""
   .
   IF(    CAN-DO(mNaznSchKas, acct-db.contract)
      AND NOT CAN-DO("20203*",acct-db.acct)) THEN
   DO:

      IF(acct-db.currency EQ "") THEN 
         ASSIGN m5 = mCodNVal
                m6 = op-entry1.amt-rub
         .
      ELSE
      DO:

         ASSIGN m5 = acct-db.currency
         .

	   /* #2510 */
	 IF acct-cr.acct BEGINS "4091" THEN
	   FOR EACH op-entry3 OF op NO-LOCK:
		m6 = m6 + op-entry3.amt-cur .
	   END.
	 ELSE 
		m6 = op-entry1.amt-cur .

      END.
   END.
   IF(    CAN-DO(mNaznSchKas, acct-cr.contract)
      AND NOT CAN-DO("20203*",acct-cr.acct)) THEN 
   DO:
      IF(acct-cr.currency EQ "") THEN 
         ASSIGN m7 = mCodNVal
                m8 = op-entry2.amt-rub
         .
      ELSE
         ASSIGN m7 = acct-cr.currency
                m8 = op-entry2.amt-cur
         .
   END.
   IF (acct-db.acct BEGINS "20203") THEN
   DO:
      m10 = op-entry1.qty.
      IF(acct-db.currency EQ "") THEN 
         ASSIGN m11 = mCodNVal
                m12 = op-entry1.amt-rub
         .
      ELSE
         ASSIGN m11 = acct-db.currency
                m12 = op-entry1.amt-cur
         .
   END.
   IF (acct-cr.acct BEGINS "20203") THEN
   DO:
      m10 = op-entry2.qty.
      IF(acct-cr.currency EQ "") THEN 
         ASSIGN m11 = mCodNVal
                m12 = op-entry2.amt-rub
         .
      ELSE
         ASSIGN m11 = acct-cr.currency
                m12 = op-entry2.amt-cur
         .
   END.

   IF     NOT CAN-DO(mNaznSchKas, acct-cr.contract)
      AND acct-cr.cust-cat EQ "Ч" THEN
      m13  = acct-cr.acct.
   ELSE IF     NOT CAN-DO(mNaznSchKas, acct-db.contract) 
           AND acct-db.cust-cat EQ "Ч" THEN
      m13 = acct-db.acct.

   IF CAN-DO (mAcctPer, m13) THEN
      m13 = "".

   IF acct-db.cust-cat EQ "ч" THEN
      FIND FIRST person WHERE person.person-id EQ acct-db.cust-id NO-LOCK NO-ERROR.
   ELSE IF acct-cr.cust-cat EQ "ч" THEN
      FIND FIRST person WHERE person.person-id EQ acct-cr.cust-id NO-LOCK NO-ERROR.

   m15 = "".
/* ========================================================================== */

   IF NOT ((op-entry1.amt-rub LE 15000.0)
       AND ((mVidOpNalV EQ "01")
         OR (mVidOpNalV EQ "02")
         OR (mVidOpNalV EQ "03")))
   THEN DO:

         IF m15 EQ "" THEN 
            m15 = GetXAttrValueEx("op",
                                  STRING(op-entry.op),
                                  "Гражданство","").

         IF m15 EQ "" THEN
            m15 = GetXAttrValueEx("op",
                               STRING(op-entry.op),
                               "country-rec",
                               "").
         IF m15 EQ "" THEN
            m15 = GetXAttrValueEx("op",
                                  STRING(op-entry.op),
                                  "country-send",
                                  "").

         IF m15 EQ "" THEN
            m15 = GetXAttrValueEx("op",
                                  STRING(op-entry.op),
                                  "country-pers",
                                  "").

         IF (AVAILABLE person) AND (m15 EQ "") THEN
            m15 = person.country-id.

         IF  m15 NE "" THEN
         DO:
            FIND FIRST country WHERE country.country-id EQ m15 NO-LOCK NO-ERROR.

            IF AVAIL country THEN
               m15 = STRING(country.country-alt-id).
         END.
   END.


 /**********************************
  *				   *
  * В случае, если у лица          *
  * нет гражданства, то в реестр   *
  * подставляется пусто.           *
  *                                *
  **********************************
  * Автор: Маслов Д. А.            *
  * Дата создания: 06.03.2012      *
  * Заявка: #862                   *
  **********************************/

  m15 = REPLACE(m15,"-","").
  IF m15 EQ "999" OR m15 EQ "nnn" THEN m15 = "".
/* ========================================================================== */

   msprate    = DECIMAL(GetXAttrValueEx("op",
                                STRING(op-entry.op),
                                "sprate",
                                "0")) NO-ERROR.
   mDover     = GetXAttrValueEx("op",
                                STRING(op-entry.op),
                                "Довер",
                                "Нет").
   mDover = IF mDover NE "Нет"
            THEN "X"
            ELSE " ".
	    
   m9 = IF mVidOpNalV EQ "16" OR mVidOpNalV EQ "17" OR mVidOpNalV EQ "14"
           THEN "X"
           ELSE " ".	    
/*
   FIND LAST history WHERE history.file-name  EQ "op" 
                       AND history.field-ref  EQ STRING(op.op)
                       AND history.field-value MATCHES "*op-status*"
                       AND history.modify     EQ "W" NO-LOCK NO-ERROR.
   IF AVAIL history 
   THEN mOpTime = REPLACE(STRING(history.modif-time,"HH:MM"),":",".").
   ELSE mOpTime = "".
*/
   mOpTime = REPLACE(STRING(history1.modif-time,"HH:MM"),":",".").

   RUN put-itog(mVidOpNalV).
   RUN put-itog("**").
   UpdateSigns("opb", STRING(op.op), "НомерРеестра", STRING(mReeNum), ?).
   IF mPrintOpNum THEN
       UpdateSigns("opb", STRING(op.op), "НомРеестр", op.doc-num, ?).
   ELSE
       UpdateSigns("opb", STRING(op.op), "НомРеестр", STRING(mDocNum), ?).

   PUT UNFORMATTED
       "╠═════════╬══════╬═════╬════════════╬═════╬══════════════════╬═════╬══════════════════╬═════════╬═════════╬═════╬══════════════════╬══════════════════════╬═════════╬═══════════╣" SKIP
   .

   IF mPrintOpNum THEN
      PUT UNFORMATTED "║"   STRING(op.doc-num, "x(9)") .
   ELSE
      PUT UNFORMATTED "║"   STRING(mDocNum, ">>>>>>>>9").
   PUT UNFORMATTED "║ " STRING(mOpTime, "x(5)") "║ "   STRING(mVidOpNalV, "x(2)")       "  ".
IF msprate GT 0 THEN 
   PUT UNFORMATTED
"║ "   STRING(msprate, ">,>>9.9999")    " "
   .
ELSE
   PUT UNFORMATTED
"║            "
   . 
   PUT UNFORMATTED
"║ "  STRING(m5, "x(3)")              " "
"║ "  STRING(m6, ">,>>>,>>>,>>9.99")  " "
"║ "  STRING(m7, "x(3)")              " "
"║ "  STRING(m8, ">,>>>,>>>,>>9.99")  " "
"║  " STRING(m9, "x(6)")              " " 
"║"   (IF m10 <> 0.00 THEN STRING(m10, ">>>>,>>9") ELSE "        ")         " "
"║ "  STRING(m11, "x(3)")             " "
"║ "  (IF m12 <> 0.00 THEN STRING(m12, ">,>>>,>>>,>9.99") ELSE FILL(" ",16)) " "
"║ "  STRING(m13, "x(20)")            " "
"║  " STRING(mDover, "x(4)")          "   " 
"║  " STRING(m15, "x(7)")             "  ║" SKIP  
   .

/*
1    - номер документа op.doc-num
2	- время ввода документа в систему.
3	- дополнительный реквизит документа "ВидОпНалВ".
4	- значение дополнительного реквизита "sprate".
5	- код получаемой валюты. Код валюты из проводки или полупроводки, в которой счет
       с назначением из настроечного параметра"НазнСчКас" стоит по дебету,
       за исключением счетов 20203*.
6	- сумма получаемой валюты. Сумма в валюте поля 5 из проводки или полупроводки, 
       в которой счет с назначением из настроечного параметра"НазнСчКас" стоит по дебету,
       за исключением счетов 20203*.
7	- код выдаваемой валюты. Код валюты из проводки или полупроводки, в которой счет
       с назначением из настроечного параметра"НазнСчКас" стоит по кредиту,
       за исключением счетов 20203*.
8	- сумма выдаваемой валюты. Сумма в валюте поля 7 из проводки или полупроводки,
       в которой счет с назначением из настроечного параметра"НазнСчКас" стоит по кредиту,
       за исключением счетов 20203*.
9	- поле не заполняется.
10	- количество поле op-entry.qty из проводки у которой счет 20203* стоит по дебету
       или по кредиту.
11	- код валюты из проводки у которой счет 20203* стоит по дебету или по кредиту.
12	- сумма в валюте из поля 11 проводки у которой счет 20203* стоит по дебету или по кредиту.
13	- если счет кассы корреспондирует в документе со счетом, который не является счетом кассы,
       то выводится этот корреспондирующий счет. Если оба счета являются счетами кассы,
       то в поле ничего не выводится.
14	- значение дополнительного реквизита "Довер".
15	- если счет кассы корреспондирует в документе со счетом, клиентом которого является 
       физическое лицо, то это поле person.country-id клиента, связанного со счетом.
       Иначе - значение заполненного дополнительного реквизита "country-rec" или "country-send".
16	- если счет кассы корреспондирует в документе со счетом, клиентом которого является 
       физическое лицо, то это ФИО данного клиента. Иначе значение дополнительного реквизита "ФИО".
17	- если счет кассы корреспондирует в документе со счетом, клиентом которого является
       физическое лицо, то это тип и номер документа данного клиента.
       Иначе значение дополнительного реквизита "Докум".
18	- если счет кассы корреспондирует в документе со счетом, клиентом которого является
       физическое лицо, то это адрес данного клиента.
       Иначе значение дополнительного реквизита "Адрес".
*/

   mDocNum = mDocNum + 1.
END.
IF mIsEmpty THEN DO:

/***
   RUN PrintHeader. /* Вывод заголовка */
***/
/*********************************************************************/
/***  03.08.2012 г. tvv   ***/
      &IF DEFINED(nomess)=0 &THEN
        MESSAGE " Обслуживание в послеоперационное время? " VIEW-AS ALERT-BOX BUTTONS YES-NO TITLE " Запрос печати штампа " SET Stamp_YN.
      &ENDIF
      IF Stamp_YN THEN
        RUN PrintHeader_Stamp.  /* Печать штампа */
      ELSE
        RUN PrintHeader.       /* Печать Без штампа */
/*********************************************************************/
END.


/* Последние итоги */
RUN PrintTotals&Footer.

{preview.i}

/*************************************
 *				     *
 * Выгрузка в электронный архив.     *
 *				     *
 *************************************
 * Заявка: #935			     *
 * Автор : Маслов Д. А. Maslov D. A. *
 * Дата  : 12:22 03.05.2012	     *
 *************************************/
curr-user-id        = USERID("bisquit").
curr-user-inspector = USERID("bisquit").

{send2arch.i &notmark=1}
 

{intrface.del}
/* ---------------------------------------------------------------------------------------------------------------------------------- */
PROCEDURE PrintHeader:

   DEFINE VARIABLE mDate AS CHARACTER   NO-UNDO.
   mDate =  STRING(OP.op-date,"99.99.9999").

       DISP "Полное (сокращенное) фирменное наименование                        "
            mNameBank VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL   SKIP
            "уполномоченного банка                                              " SKIP
            "(наименование филиала)                                             " SKIP
            "Регистрационный номер уполномоченного банка/                       "
            mREGN VIEW-AS EDITOR SIZE 35 BY 1 NO-LABEL         SKIP
            "(порядковый номер филиала)                                         " SKIP
            "Местонахождение (адрес) уполномоченного банка                      "
            mAdres-pch VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL    SKIP
            "(филиала)                                                          " SKIP
            "Наименование внутреннего структурного подразделения                "
            mAdrK[1] VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL   SKIP
            "уполномоченного банка и его местонахождение (адрес)                " mAdrK[2] VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL   SKIP
                WITH FRAME mA1 SIZE 160 BY 10.
       PUT UNFORMATTED "Дата заполнения " (IF mIsEmpty THEN "справки" ELSE "Реестра") "                                             "  mDate SKIP
                       "                                                                   День Месяц Год " SKIP.
       IF NOT mIsEmpty THEN
       PUT UNFORMATTED "Порядковый номер Реестра в течение рабочего дня                     " STRING(mReeNum) SKIP(1).

       IF mIsEmpty  THEN
       PUT UNFORMATTED SKIP (1)
             SPACE(50) "СПРАВКА ОБ ОТСУТСТВИИ ОПЕРАЦИЙ С НАЛИЧНОЙ ВАЛЮТОЙ И ЧЕКАМИ" SKIP(1).
       ELSE PUT UNFORMATTED 
             SPACE(50) "РЕЕСТР ОПЕРАЦИЙ С НАЛИЧНОЙ ВАЛЮТОЙ И ЧЕКАМИ" SKIP(1).
       PUT UNFORMATTED
       "╔═════════╦══════╦═════╦════════════╦═════════════════════════════════════════════════╦═════════╦══════════════════════════════════╦══════════════════════╦═════════╦═══════════╗" SKIP
       "║ Порядко-║Время ║ Код ║   Курс     ║            Наличные денежные средства           ║Платежная║Принято (выдано) кассовым работни-║     Номер счета      ║ Доверен-║Гражданство║" SKIP
       "║вый номер║совер-║ вида║иностранной ╠════════════════════════╦════════════════════════╣  карта  ║ком чеков (в том числе дорожных   ║                      ║  ность  ║физического║" SKIP
       "║операции ║шения ║ опе-║  валюты    ║       Принято          ║         Выдано         ║         ║чеков), номинальная  стоимость ко-║                      ║         ║   лица    ║" SKIP
       "║         ║опера-║рации║  (кросс-   ║  кассовым работником   ║  кассовым работником   ║         ║торых указана в иностранной валюте║                      ║         ║           ║" SKIP
       "║         ║ции   ║     ║  курс) по  ╠═════╦══════════════════╬═════╦══════════════════╣         ╠═════════╦═════╦══════════════════╣                      ║         ║           ║" SKIP
       "║         ║ЧЧ.ММ ║     ║  операции  ║ код ║      сумма       ║ код ║      сумма       ║         ║ Коли-   ║ код ║      сумма       ║                      ║         ║           ║" SKIP
       "║         ║      ║     ║            ║валю-║                  ║валю-║                  ║         ║ чество  ║валю-║                  ║                      ║         ║           ║" SKIP
       "║         ║      ║     ║            ║ ты  ║                  ║ ты  ║                  ║         ║ чеков   ║ ты  ║                  ║                      ║         ║           ║" SKIP
       "║         ║      ║     ║            ║     ║                  ║     ║                  ║         ║ серия   ║     ║                  ║                      ║         ║           ║" SKIP
       "║         ║      ║     ║            ║     ║                  ║     ║                  ║         ║ номера  ║     ║                  ║                      ║         ║           ║" SKIP
       "╠═════════╬══════╬═════╬════════════╬═════╬══════════════════╬═════╬══════════════════╬═════════╬═════════╬═════╬══════════════════╬══════════════════════╬═════════╬═══════════╣" SKIP
       "║    1    ║  2   ║  3  ║      4     ║  5  ║         6        ║  7  ║         8        ║     9   ║   10    ║ 11  ║       12         ║          13          ║    14   ║    15     ║" SKIP
       .

END PROCEDURE.


PROCEDURE PrintHeader_Stamp:

   DEFINE VARIABLE mDate AS CHARACTER   NO-UNDO.
   mDate =  STRING(OP.op-date,"99.99.9999").

       DISP "Полное (сокращенное) фирменное наименование                        "
            mNameBank VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL   SKIP
            "уполномоченного банка                                              " SKIP
            "(наименование филиала)                                             " SKIP
            "Регистрационный номер уполномоченного банка/                       "
            mREGN VIEW-AS EDITOR SIZE 35 BY 1 NO-LABEL         SKIP
            "(порядковый номер филиала)                                         " SKIP
            "Местонахождение (адрес) уполномоченного банка                      "
            mAdres-pch VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL    SKIP
            "(филиала)                                                          " SKIP
            "Наименование внутреннего структурного подразделения                "
            mAdrK[1] VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL   SKIP
            "уполномоченного банка и его местонахождение (адрес)                " mAdrK[2] VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL   SKIP
                WITH FRAME mA1 SIZE 160 BY 10.
       PUT UNFORMATTED
            SPACE(140) "╔══════════════════════╗" SKIP
            SPACE(140) "║ ОБСЛУЖИВАНИЕ В       ║" SKIP
            SPACE(140) "║ ПОСЛЕОПЕРАЦИОННОЕ    ║" SKIP
            SPACE(140) "║ ВРЕМЯ                ║" SKIP
            SPACE(140) "║                      ║" SKIP
            SPACE(140) "╚══════════════════════╝" SKIP
       .

       PUT UNFORMATTED "Дата заполнения " (IF mIsEmpty THEN "справки" ELSE "Реестра") "                                             "  mDate SKIP
                       "                                                                   День Месяц Год "  SKIP.
       IF NOT mIsEmpty THEN
       PUT UNFORMATTED "Порядковый номер Реестра в течение рабочего дня                     " STRING(mReeNum) SKIP.

       IF mIsEmpty  THEN
       PUT UNFORMATTED SKIP (1)
             SPACE(50) "СПРАВКА ОБ ОТСУТСТВИИ ОПЕРАЦИЙ С НАЛИЧНОЙ ВАЛЮТОЙ И ЧЕКАМИ" SKIP(1).
       ELSE PUT UNFORMATTED 
             SPACE(50) "РЕЕСТР ОПЕРАЦИЙ С НАЛИЧНОЙ ВАЛЮТОЙ И ЧЕКАМИ" SKIP.
       PUT UNFORMATTED SPACE(127)  SKIP.
       PUT UNFORMATTED SPACE(127)  SKIP(1).

       PUT UNFORMATTED
       "╔═════════╦══════╦═════╦════════════╦═════════════════════════════════════════════════╦═════════╦══════════════════════════════════╦══════════════════════╦═════════╦═══════════╗" SKIP
       "║ Порядко-║Время ║ Код ║   Курс     ║            Наличные денежные средства           ║Платежная║Принято (выдано) кассовым работни-║     Номер счета      ║ Доверен-║Гражданство║" SKIP
       "║вый номер║совер-║ вида║иностранной ╠════════════════════════╦════════════════════════╣  карта  ║ком чеков (в том числе дорожных   ║                      ║  ность  ║физического║" SKIP
       "║операции ║шения ║ опе-║  валюты    ║       Принято          ║         Выдано         ║         ║чеков), номинальная  стоимость ко-║                      ║         ║   лица    ║" SKIP
       "║         ║опера-║рации║  (кросс-   ║  кассовым работником   ║  кассовым работником   ║         ║торых указана в иностранной валюте║                      ║         ║           ║" SKIP
       "║         ║ции   ║     ║  курс) по  ╠═════╦══════════════════╬═════╦══════════════════╣         ╠═════════╦═════╦══════════════════╣                      ║         ║           ║" SKIP
       "║         ║ЧЧ.ММ ║     ║  операции  ║ код ║      сумма       ║ код ║      сумма       ║         ║ Коли-   ║ код ║      сумма       ║                      ║         ║           ║" SKIP
       "║         ║      ║     ║            ║валю-║                  ║валю-║                  ║         ║ чество  ║валю-║                  ║                      ║         ║           ║" SKIP
       "║         ║      ║     ║            ║ ты  ║                  ║ ты  ║                  ║         ║ чеков   ║ ты  ║                  ║                      ║         ║           ║" SKIP
       "║         ║      ║     ║            ║     ║                  ║     ║                  ║         ║ серия   ║     ║                  ║                      ║         ║           ║" SKIP
       "║         ║      ║     ║            ║     ║                  ║     ║                  ║         ║ номера  ║     ║                  ║                      ║         ║           ║" SKIP
       "╠═════════╬══════╬═════╬════════════╬═════╬══════════════════╬═════╬══════════════════╬═════════╬═════════╬═════╬══════════════════╬══════════════════════╬═════════╬═══════════╣" SKIP
       "║    1    ║  2   ║  3  ║      4     ║  5  ║         6        ║  7  ║         8        ║     9   ║   10    ║ 11  ║       12         ║          13          ║    14   ║    15     ║" SKIP
       .

END PROCEDURE.


PROCEDURE PrintTotals&Footer:
    
    FOR EACH tt-itog:
       IF tt-itog.vidop EQ "**" THEN NEXT.
       PUT UNFORMATTED
    "╠═════════╬══════╬═════╬════════════╬═════╬══════════════════╬═════╬══════════════════╬═════════╬═════════╬═════╬══════════════════╬══════════════════════╬═════════╬═══════════╣" SKIP

    "║ ИТОГИ   ║      "
    "║ "   STRING(tt-itog.vidop, "X(2)") "  ║ "
    (IF tt-itog.sprate GT 0 THEN  (STRING(tt-itog.sprate, ">,>>9.9999")) ELSE "          ") 
    " ║ "   STRING(tt-itog.val5, "x(3)")             " "
    "║ "   STRING(tt-itog.sum6, ">,>>>,>>>,>>9.99") " "
    "║ "   STRING(tt-itog.val7, "x(3)")             " "
    "║ "   STRING(tt-itog.sum8, ">,>>>,>>>,>>9.99") " "
    "║         "
    "║         "
    "║ "   STRING(tt-itog.val11, "x(3)")            " "
    "║ "   (IF tt-itog.sum12 NE 0.00 THEN  STRING(tt-itog.sum12, ">,>>>,>>>,>>9.99") ELSE FILL(" ",16)) " "
    "║ "   FILL(" " ,21)
    "║         " 
    "║           "
    "║"    SKIP
       .
    END.
       PUT UNFORMATTED
    "╚═════════╩══════╩═════╩════════════╩═════╩══════════════════╩═════╩══════════════════╩═════════╩═════════╩═════╩══════════════════╩══════════════════════╩═════════╩═══════════╝"
    SKIP(1)
    .

    IF NUM-ENTRIES(iParam,";")   GT 2 
       AND TRIM(ENTRY(3,iParam,";")) EQ "ДА"
       THEN DO:

    PUT UNFORMATTED
    "            СВОДНЫЕ ИТОГИ" SKIP
    "╔═════════╦══════╦═════╦════════════╦═════╦══════════════════╦═════╦══════════════════╦═════════╦═════════╦═════╦══════════════════╦══════════════════════╦═════════╦═══════════╗" SKIP
    "║    1    ║  2   ║  3  ║      4     ║  5  ║         6        ║  7  ║         8        ║     9   ║   10    ║ 11  ║       12         ║          13          ║    14   ║    15     ║" SKIP
    .
    FOR EACH tt-itog WHERE tt-itog.vidop EQ "**":
       PUT UNFORMATTED
    "╠═════════╬══════╬═════╬════════════╬═════╬══════════════════╬═════╬══════════════════╬═════════╬═════════╬═════╬══════════════════╬══════════════════════╬═════════╬═══════════╣" SKIP
    "║ ИТОГИ   ║      "
    "║ все "
    "║            "
    "║ "   STRING(tt-itog.val5, "x(3)")             " "
    "║ "   STRING(tt-itog.sum6, ">,>>>,>>>,>>9.99") " "
    "║ "   STRING(tt-itog.val7, "x(3)")             " "
    "║ "   STRING(tt-itog.sum8, ">,>>>,>>>,>>9.99") " "
    "║         "
    "║         "
    "║ "   STRING(tt-itog.val11, "x(3)")            " "
    "║ "   (IF tt-itog.sum12 NE 0.00 THEN  STRING(tt-itog.sum12, ">,>>>,>>>,>>9.99") ELSE FILL(" ",16)) " "
    "║ "   FILL(" " ,21)
    "║         " 
    "║           "
    "║"    SKIP
       .
    END.
       PUT UNFORMATTED
          "╚═════════╩══════╩═════╩════════════╩═════╩══════════════════╩═════╩══════════════════╩═════════╩═════════╩═════╩══════════════════╩══════════════════════╩═════════╩═══════════╝"
    SKIP(1)
    .
    END.
    FIND FIRST _User WHERE _user._Userid EQ USERID("BISQUIT") NO-LOCK NO-ERROR.
    PUT UNFORMATTED "Кассовый работник                            " (IF AVAIL(_user) THEN _user._User-Name ELSE "")  SKIP.
    PUT UNFORMATTED "                    ───────────────────     ─────────────────────────────"  SKIP.
    PUT UNFORMATTED "                        (подпись)             (фамилия и инициалы)"           SKIP.

END PROCEDURE.

PROCEDURE put-itog:

   DEFINE INPUT PARAMETER iVidOpNalV AS CHAR.
   
   IF iVidOpNalV  NE "**" THEN
   FIND FIRST tt-itog WHERE tt-itog.vidop EQ iVidOpNalV
                        AND tt-itog.val5  EQ m5
                        AND tt-itog.val7  EQ m7
                        AND tt-itog.val11 EQ m11 
                        AND tt-itog.sprate EQ msprate NO-ERROR.
   ELSE
   FIND FIRST tt-itog WHERE tt-itog.vidop EQ iVidOpNalV
                        AND tt-itog.val5  EQ m5
                        AND tt-itog.val7  EQ m7
                        AND tt-itog.val11 EQ m11 NO-ERROR.

   IF NOT AVAIL tt-itog THEN
   DO:
      CREATE tt-itog.
      ASSIGN
         tt-itog.vidop = iVidOpNalV
         tt-itog.val5  = m5
         tt-itog.val7  = m7
         tt-itog.val11 = m11
         tt-itog.sprate = (IF iVidOpNalV  NE "**" THEN msprate ELSE 0.00)
      .
   END.
   ASSIGN 
      tt-itog.sum6 = tt-itog.sum6 + m6
      tt-itog.sum8 = tt-itog.sum8 + m8
      tt-itog.sum12 = tt-itog.sum12 + m12
   . 
   RELEASE tt-itog.
END PROCEDURE.
  
