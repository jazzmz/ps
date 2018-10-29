/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: ree-113i.p
      Comment: '113-И Печать реестра по проведенным операциям'
   Parameters:
         Uses: 
      Used by:
      Created: 15.06.2004 0031886 ABKO
     Modified: 22/06/2004 kolal   Редактирование поля номера реестра. Заявка 32158.
     Modified: 04.07.2004 abko 0032166 + 0032274 + 0032304 + 0032371 + 0032652 .
     Modified: 15/07/2004 kolal   Использование станд. инструментов для получения 
                                  номера реестра. Заявка 32158.
     Modified: 10.08.2004 abko 0034008 исправлена дата реестра.
     Modified: 25.11.2005 kraw (0047185) возможность автонумерации при помощи Counters
     Modified: 28.11.2005 kraw (0054939) Код гражданства независимо от суммы
     Modified: 21.03.2006 kraw (0059487) Правильный отбор по "НазнСчКас"
     Modified: 13.10.2006 vasov(0065774) Отсев проводок по счетам комиссий;
                                         Отсев документов, уже распечатанных в другом реестре;
                                         Отключение автоматич.формирования номера реестра
*/

{globals.i}
{wordwrap.def}
{tmprecid.def}
{intrface.get xclass}
{intrface.get count}
{pir_anketa.fun}       /* Borisov A.V. - function Kladr */

DEFINE INPUT PARAM iParam AS CHAR NO-UNDO.

DEFINE VARIABLE mNumDate AS DATE NO-UNDO.

FIND FIRST tmprecid
   NO-LOCK NO-ERROR.

IF NOT AVAIL tmprecid
THEN DO:
   MESSAGE "Не выбраны документы" VIEW-AS ALERT-BOX.
   RETURN.
END.

{ree-113i.def}

DEFINE VARIABLE mAcctPer     AS CHARACTER      NO-UNDO.
DEFINE VARIABLE mBreakReport AS LOGICAL        NO-UNDO.
DEFINE VARIABLE mBreakFlag   AS LOGICAL        NO-UNDO.
DEFINE VARIABLE mReeNum      AS INTEGER INIT 1 NO-UNDO.
DEFINE VARIABLE mOpReeNum    AS CHARACTER      NO-UNDO.
DEFINE VARIABLE cReg         AS CHARACTER      NO-UNDO.

{tmprecid.def
   &PREF = "tt-"
   &NGSH = YES
}

DEF TEMP-TABLE tt-itog NO-UNDO
   FIELD vidop AS CHARACTER
   FIELD val5  AS CHARACTER
   FIELD val7  AS CHARACTER
   FIELD val11 AS CHARACTER
   FIELD sum6  AS DECIMAL
   FIELD sum8  AS DECIMAL
   FIELD sum12 AS DECIMAL
   .

DEFINE TEMP-TABLE ttBreakInfo
   FIELD m5     AS CHARACTER
   FIELD m7     AS CHARACTER
   FIELD sprate AS DECIMAL 
.

before:
DO TRANSACTION:
   /*********/
   ASSIGN
      mNaznSchKas = FGetSetting("НазнСчКас","","")
      mScetKomis  = FGetSetting("И113","СчетКомис","")
      mCodNVal    = FGetSetting("КодНацВал","","")
      mAcctPer    = FGetSetting ("И113","СчПереводов","")
      mOpGr15     = FGetSetting ("И113","ОпГр15","")
   .
   mSummKon113 = DEC(FGetSetting("И113","СуммаКон113","")) NO-ERROR.
   IF    ERROR-STATUS:ERROR 
      OR mSummKon113 EQ 0
   THEN
      mSummKon113 = 600000.

   mSumm1626 = DECIMAL(FGetSetting("И113","Сумма1626","")) NO-ERROR.
   IF    ERROR-STATUS:ERROR 
      OR mSumm1626 = 0
   THEN mSumm1626 = 600000.

   IF NUM-ENTRIES(iParam,";") >= 1
   THEN
      ASSIGN
         mParam[1]   = ENTRY(1,iParam,";")
         mBranchMask = mParam[1]
      .

   IF NUM-ENTRIES(iParam,";") >= 2
   THEN
      ASSIGN
         mParam[2] = ENTRY(2,iParam,";")
         mUserMask = mParam[2]
      .

   IF     NUM-ENTRIES(iParam,";")   GT 3
      AND TRIM(ENTRY(4,iParam,";")) EQ "ДА"
   THEN
      mPrintOpNum = TRUE. 

   IF     NUM-ENTRIES (iParam, ";") GE 5
      AND TRIM (ENTRY (5, iParam, ";")) EQ "Да"
   THEN
      mBreakReport = TRUE.

   /* сохраним наши документы */
   RUN rid-rest.p (OUTPUT TABLE tt-tmprecid).
   {empty tmprecid}

   FIND FIRST tt-tmprecid.
   FIND FIRST op
      WHERE RECID(op) EQ tt-tmprecid.id
      NO-LOCK NO-ERROR.

   DEFINE VARIABLE prefix AS CHARACTER.
   DEFINE VARIABLE in-end-date LIKE op.op-date.

   in-end-date = op.op-date.

   mNumDate = TODAY.

   IF AVAILABLE op
   THEN
      mNumDate = op.op-date.

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
      AND LASTKEY = 301
   THEN DO:
      RUN browseld.p ("branch",    /* Класс объекта. */
                      "parent-id", /* Поля для предустановки. */
                      "*",         /* Список значений полей. */
                      ?,           /* Поля для блокировки. */
                      4).          /* Строка отображения фрейма. */

      IF keyfunc(lastkey) NE "end-error"
      THEN DO:
         ASSIGN
            mBranchMask = pick-value
            mBranchMask:SCREEN-VALUE = pick-value.
            RELEASE branch.
         END.
      END.
      ELSE DO:
         IF     FRAME-FIELD EQ "mUserMask"
            AND LASTKEY = 301
         THEN DO:
            RUN browseld.p ("_user",   /* Класс объекта. */
                            "_userid", /* Поля для предустановки. */
                            "*",       /* Список значений полей. */
                            ?,         /* Поля для блокировки. */
                            6).        /* Строка отображения фрейма. */

            IF keyfunc(lastkey) NE "end-error"
            THEN DO:
               ASSIGN
                  mUserMask = pick-value
                  mUserMask:SCREEN-VALUE = pick-value
               .
               RELEASE _user.
            END.
         END.
         ELSE DO:
            IF LASTKEY EQ 27
            THEN DO:
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
      END.
   END.
   HIDE FRAME enter-cond.

   /* восстановим recid's на наши документы */
   {empty tmprecid}
   
   FOR EACH tt-tmprecid:
      CREATE tmprecid.
      tmprecid.id = tt-tmprecid.id.
   END.

   {get-bankname.i}

   ASSIGN
      mNameBank  = cBankName
      mREGN      = FGetSetting("REGN","","")
      mAdres-pch = FGetSetting("Адрес_пч","","")
   .

   IF mBranchMask EQ "*"
   THEN
      mAdres-kass = mAdres-pch.
   ELSE
      mAdres-kass = GetXAttrValueEx("branch", STRING(mBranchMask), "Адрес_юр", mAdres-pch).

END. /*before*/


/* ----------------------------------------------------------------------------------------------------------------------------------- */
prefix = "ree" + "_" + userid + "_" + STRING(mReeNum).

IF (mBranchMask EQ "00002")
THEN
   prefix ="ree_p".

{pirraproc.def}
{pirraproc.i &arch_file_name = ".txt" &prefix = "yes"}
{setdest.i &cols=242 &filename = arch_file_name}
{justamin}

mBreakFlag = FALSE.

RUN PrintHeader. /* Вывод заголовка */
ASSIGN
   mDocNum    = 1.

DEFINE BUFFER history1 FOR history.

FOR EACH tmprecid
   NO-LOCK,
   FIRST op
      WHERE RECID(op) EQ tmprecid.id
        AND CAN-DO(mUserMask,op.user-id)
      NO-LOCK,
   LAST history1
      WHERE history1.file-name EQ "op"
        AND history1.field-ref EQ STRING(op.op)
        AND history1.modify = "w"
        AND history1.field-value MATCHES "*op-status*"
      NO-LOCK,
   EACH op-entry OF op
      NO-LOCK
   BREAK BY history1.modif-time
         BY op.op
   :


   /*----------------------------------------------- Выборка ---------------------*/
   mOpReeNum = GetXattrValue("op", STRING (op.op), "НомерРеестра").

   IF     mOpReeNum NE ""
      AND mOpReeNum NE STRING(mReeNum) /* документ уже включен в другой реестр */
   THEN NEXT.

   {ree-113i.sel}

   IF NOT (   CAN-DO(mBranchMask,acct-cr.branch-id)
           OR CAN-DO(mBranchMask,acct-db.branch-id)
           )
   THEN NEXT.

   IF    CAN-DO(mScetKomis,op-entry.acct-cr)
      OR CAN-DO(mScetKomis,op-entry.acct-db)
   THEN NEXT.

   /* Получение данных
      Каждая строка отчета содержит информацию об отдельном документе и (полу)проводках, 
      связанных с ним. Если в документе есть две полупроводки, то анализируются обе. 
      Если их более двух, то анализируются первые проводки, в которых заполнены поля 
      дебет и кредит.
   */

   ASSIGN
      m5  = ""
      m6  = 0
      m7  = ""
      m8  = 0
      m10 = 0
      m11 = ""
      m12 = 0
      m13 = ""
      m15 = ""
      mFIO[1] = ""
      m17[1]  = ""
      mADR[1] = ""
      mDocId  = ""
   .

   IF (       CAN-DO(mNaznSchKas, acct-db.contract)
      AND NOT CAN-DO("20203*", acct-db.acct))
   THEN DO:
      IF (acct-db.currency EQ "")
      THEN
         ASSIGN
            m5 = mCodNVal
            m6 = op-entry1.amt-rub
         .
      ELSE
         ASSIGN
            m5 = acct-db.currency
            m6 = op-entry1.amt-cur
         .
   END.

   IF (    CAN-DO(mNaznSchKas, acct-cr.contract)
      AND NOT CAN-DO("20203*",acct-cr.acct))
   THEN DO:
      IF (acct-cr.currency EQ "")
      THEN
         ASSIGN
            m7 = mCodNVal
            m8 = op-entry2.amt-rub
         .
      ELSE
         ASSIGN
            m7 = acct-cr.currency
            m8 = op-entry2.amt-cur
         .
   END.

   IF (acct-db.acct BEGINS "20203")
   THEN DO:
      m10 = op-entry1.qty.

      IF (acct-db.currency EQ "")
      THEN
         ASSIGN
            m11 = mCodNVal
            m12 = op-entry1.amt-rub
         .
      ELSE
         ASSIGN
            m11 = acct-db.currency
            m12 = op-entry1.amt-cur
         .
   END.

   IF (acct-cr.acct BEGINS "20203")
   THEN DO:
      m10 = op-entry2.qty.

      IF (acct-cr.currency EQ "")
      THEN
         ASSIGN
            m11 = mCodNVal
            m12 = op-entry2.amt-rub
         .
      ELSE
         ASSIGN
            m11 = acct-cr.currency
            m12 = op-entry2.amt-cur
         .
   END.

   IF     NOT CAN-DO(mNaznSchKas, acct-cr.contract)
      AND acct-cr.cust-cat EQ "Ч"
   THEN
      m13  = acct-cr.acct.
   ELSE
      IF     NOT CAN-DO(mNaznSchKas, acct-db.contract)
         AND acct-db.cust-cat EQ "Ч"
      THEN
         m13 = acct-db.acct.

   IF CAN-DO (mAcctPer, m13) THEN
      m13 = "".

   IF acct-db.cust-cat EQ "ч"
   THEN
      FIND FIRST person
         WHERE (person.person-id EQ acct-db.cust-id)
         NO-LOCK NO-ERROR.
   ELSE
      IF acct-cr.cust-cat EQ "ч"
      THEN
         FIND FIRST person
            WHERE (person.person-id EQ acct-cr.cust-id)
            NO-LOCK NO-ERROR.

   m15 = "".
   IF    op-entry.amt-rub GE mSumm1626
      OR (   op-entry.amt-rub LT mSumm1626
         AND NOT CAN-DO(mOpGr15, mVidOpNalV))
   THEN DO:
                    
         m15 = GetXAttrValue("op", STRING(op-entry.op), "country-rec").

         IF m15 EQ ""
         THEN
            m15 = GetXAttrValue("op", STRING(op-entry.op), "country-send").

         IF m15 EQ ""
         THEN
            m15 = GetXAttrValue("op", STRING(op-entry.op), "country-pers").

		 IF m15 EQ "" AND  AVAILABLE person
		 THEN
      		m15 = GetXAttrValue("person", STRING(person.person-id), "country-id2").

         IF m15 EQ "" AND  AVAILABLE person
		 THEN
      		m15 = person.country-id.
      

      IF    m15 EQ "999"
         OR m15 EQ "nnn"
      THEN m15 = "".
   END.

   ASSIGN
      mFIO[1] = ""
      m17[1]  = ""
      mDocId  = ""
      mADR[1] = ""
   .

   IF    op-entry.amt-rub >= mSummKon113
      OR (   op-entry.amt-rub  < mSummKon113
         AND op-entry.amt-rub >= mSumm1626
         AND GetXattrValueEx("op",STRING(op.op),"Инф113","Нет") EQ "Да"
         )
      OR (   op-entry.amt-rub < mSummKon113
         AND NOT CAN-DO(mOpGr15,mVidOpNalV)
         )
   THEN DO:
      IF AVAILABLE person
      THEN DO:
/*
         FIND LAST cust-ident
            WHERE (cust-ident.cust-cat       EQ "Ч")
              AND (cust-ident.cust-id        EQ person.person-id)
              AND (cust-ident.class-code     EQ "p-cust-ident")
              AND (cust-ident.cust-code-type EQ "Паспорт")
            NO-LOCK NO-ERROR.
         IF NOT (AVAILABLE cust-ident)
         THEN DO:
            FIND LAST cust-ident
               WHERE (cust-ident.cust-cat       EQ "Ч")
                 AND (cust-ident.cust-id        EQ person.person-id)
                 AND (cust-ident.class-code     EQ "p-cust-ident")
               NO-LOCK NO-ERROR.
         END.

         IF (AVAILABLE cust-ident)
         THEN DO:
            mDocId = cust-ident.cust-code-type + ','
                   + cust-ident.cust-code      + ','
                   + STRING(cust-ident.cust-type-num).
            mDocId = GetXAttrValue("cust-ident", mDocId, "Подразд").
            m17[1] = ", N " + cust-ident.cust-code
                   + ", выдан " + STRING(cust-ident.open-date, "99.99.9999")
                   + ", " + cust-ident.issue
                   + (IF (mDocId EQ "") THEN "" ELSE (", К/П " + mDocId)).
            mDocId = GetCodeName("КодДокум", cust-ident.cust-code-type).
         END.
         ELSE
*/
            ASSIGN
               m17[1] = ", N " + person.document + ", выдан " 
                      + GetXAttrValue("person", STRING(person.person-id), "Document4Date_vid")
                      + ", " + person.issue
               mDocId = GetCodeName("КодДокум", person.document-id)
            .

         ASSIGN
            mFIO[1] = person.name-last + " " + person.first-names
                    + (IF (op-entry.amt-rub GE 600000)
                       THEN (" " + STRING(person.birthday, "99.99.9999"))
                       ELSE "")
            cReg    = GetXAttrValue("person", STRING(person.person-id), "country-id2") + ","
                    + GetXAttrValue("person", STRING(person.person-id), "КодРегГНИ")
            mADR[1] = Kladr(cReg, person.address[1] + person.address[2])
         .
      END.

      mFIO[1] = GetXAttrValueEx("op", STRING(op.op), "ФИО",         mFIO[1])
              + GetXAttrValueEx("op", STRING(op.op), "ДеньРожд",    "").
      mDocId  = GetXAttrValueEx("op", STRING(op.op), "document-id", mDocId).
      m17[1]  = GetXAttrValueEx("op", STRING(op.op), "Докум",       m17[1]).
      mADR[1] = GetXAttrValueEx("op", STRING(op.op), "Адрес",       mADR[1]).
   END.

   IF AVAILABLE person
   THEN
      RELEASE person.

   IF  m15 NE ""
   THEN DO:
      FIND FIRST country
         WHERE country.country-id EQ m15
         NO-LOCK NO-ERROR.

      IF AVAILABLE country
      THEN
         m15 = STRING(country.country-alt-id).
   END.

   msprate    = DECIMAL(GetXAttrValueEx("op", STRING(op-entry.op), "sprate", "0")) NO-ERROR.
   mDover     = GetXAttrValueEx("op", STRING(op-entry.op), "Довер", "Нет").
   mDover     = IF mDover NE "Нет"
                THEN "X"
                ELSE " ".
   m9         = IF ((mVidOpNalV EQ "16") OR (mVidOpNalV EQ "17"))
                THEN "X"
                ELSE " ".

   FIND LAST history
      WHERE history.file-name EQ "op" 
        AND history.field-ref EQ STRING(op.op)
        AND history.modify    EQ "W"
        AND history.field-value MATCHES "*op-status*"
        NO-LOCK NO-ERROR.

   IF AVAIL history 
   THEN
      mOpTime = STRING(history.modif-time,"HH:MM").
   ELSE
      mOpTime = "".

   m17[1] = mDocId + " " + m17[1].

   {wordwrap.i &s=mFIO &l=20 &n=10}
   {wordwrap.i &s=mADR &l=30 &n=10}
   {wordwrap.i &s=m17  &l=18 &n=10}

   IF mBreakReport
   THEN DO:
      /*  Проверить, нужно ли разбиение  */
      FIND FIRST ttBreakInfo
         WHERE (   m5 NE ""
               AND m7 NE ""
               AND ttBreakInfo.m5 EQ m5
               AND ttBreakInfo.m7 EQ m7
               )
            OR (   m5 NE ""
               AND m7 EQ ""
               AND ttBreakInfo.m5 EQ m5
               AND ttBreakInfo.m7 EQ m11
               )
            OR (   m5 EQ ""
               AND m7 NE ""
               AND ttBreakInfo.m5 EQ m11
               AND ttBreakInfo.m7 EQ m7
               )
         NO-LOCK NO-ERROR.

      IF NOT AVAIL ttBreakInfo
      THEN DO:
         CREATE ttBreakInfo.
         ASSIGN
            ttBreakInfo.m5     = IF (m5 NE "") THEN m5 ELSE m11
            ttBreakInfo.m7     = IF (m7 NE "") THEN m7 ELSE m11
            ttBreakInfo.sprate = msprate
         .
      END.
      ELSE
         mBreakFlag = msprate NE ttBreakInfo.sprate.
   END.

   IF mBreakFlag
   THEN DO:      /* начать новый реестр */
      RUN PrintTotals&Footer. /* Вывод итогов */
      /* Вычисление нового номера реестра*/
      ASSIGN
         mReeNum = mReeNum + 1
         mDocNum = 1
      .

      RUN PrintHeader.     /* вывод заголовка */

      {empty ttBreakInfo}
      CREATE ttBreakInfo.
      ASSIGN
         ttBreakInfo.m5        = IF (m5 NE "") THEN m5 ELSE m11
            ttBreakInfo.m7     = IF (m7 NE "") THEN m7 ELSE m11
            ttBreakInfo.sprate = msprate
      .
      {empty tt-itog}
      mBreakFlag = FALSE.
   END.

   RUN put-itog(mVidOpNalV).
   RUN put-itog("**").
   UpdateSigns("opb", STRING(op.op), "НомерРеестра", STRING(mReeNum), ?).

   IF mPrintOpNum
   THEN
       UpdateSigns("opb", STRING(op.op), "НомРеестр", op.doc-num, ?).
   ELSE
       UpdateSigns("opb", STRING(op.op), "НомРеестр", STRING(mDocNum), ?).

   PUT UNFORMATTED
       "╠══════╬══════╬═════╬════════════╬═════╬══════════════════╬═════╬══════════════════╬═════╬═════════╬═════╬══════════════════╬══════════════════════╬══════╬═══════╬══════════════════════╬════════════════════╬════════════════════════════════╣" SKIP
   .

   IF mPrintOpNum
   THEN
      PUT UNFORMATTED "║"   STRING(op.doc-num, "x(6)") .
   ELSE
      PUT UNFORMATTED "║"   STRING(mDocNum, ">>>>>9").

   PUT UNFORMATTED "║ " STRING(mOpTime, "x(5)") "║ "   STRING(mVidOpNalV, "x(2)")       "  ".
   IF msprate GT 0
   THEN
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
      "║  " STRING(m9, "x(1)")              "  " 
      "║"   STRING(m10, ">>>>,>>9")         " "
      "║ "  STRING(m11, "x(3)")             " "
      "║ "  STRING(m12, ">,>>>,>>>,>>9.99") " "
      "║ "  STRING(m13, "x(20)")            " "
      "║  " STRING(mDover, "x(1)")          "   " 
      "║  " STRING(m15, "x(3)")             "  "
      "║ "  STRING(mFIO[1], "x(20)")        " "
      "║ "  STRING(m17[1], "x(18)")         " "
      "║ "  STRING(mADR[1], "x(30)")        " "
      "║"   SKIP
   .

   DO mI = 2 to 10:
      IF    mADR[mI] NE "" 
         OR mFIO[mI] NE ""
         OR m17[mI]  NE ""
      THEN
         PUT UNFORMATTED
            "║      "
            "║      "
            "║     "
            "║            "
            "║     "
            "║                  "
            "║     "
            "║                  "
            "║     "
            "║         "
            "║     "
            "║                  "
            "║                      "
            "║      "
            "║       "
            "║ "   STRING(mFIO[mI], "x(20)") " "
            "║ "   STRING(m17[mI], "x(18)")  " "
            "║ "   STRING(mADR[mI], "x(30)") " "
            "║"    SKIP
         .
      ELSE LEAVE.
   END.

   /*
   1  - номер документа op.doc-num
   2  - время ввода документа в систему.
   3  - дополнительный реквизит документа "ВидОпНалВ".
   4  - значение дополнительного реквизита "sprate".
   5  - код получаемой валюты. Код валюты из проводки или полупроводки, в которой счет
        с назначением из настроечного параметра"НазнСчКас" стоит по дебету,
        за исключением счетов 20203*.
   6  - сумма получаемой валюты. Сумма в валюте поля 5 из проводки или полупроводки, 
        в которой счет с назначением из настроечного параметра"НазнСчКас" стоит по дебету,
        за исключением счетов 20203*.
   7  - код выдаваемой валюты. Код валюты из проводки или полупроводки, в которой счет
        с назначением из настроечного параметра"НазнСчКас" стоит по кредиту,
        за исключением счетов 20203*.
   8  - сумма выдаваемой валюты. Сумма в валюте поля 7 из проводки или полупроводки,
        в которой счет с назначением из настроечного параметра"НазнСчКас" стоит по кредиту,
        за исключением счетов 20203*.
   9  - поле не заполняется.
   10 - количество поле op-entry.qty из проводки у которой счет 20203* стоит по дебету
        или по кредиту.
   11 - код валюты из проводки у которой счет 20203* стоит по дебету или по кредиту.
   12 - сумма в валюте из поля 11 проводки у которой счет 20203* стоит по дебету или по кредиту.
   13 - если счет кассы корреспондирует в документе со счетом, который не является счетом кассы,
        то выводится этот корреспондирующий счет. Если оба счета являются счетами кассы,
        то в поле ничего не выводится.
   14 - значение дополнительного реквизита "Довер".
   15 - если счет кассы корреспондирует в документе со счетом, клиентом которого является 
        физическое лицо, то это поле person.country-id клиента, связанного со счетом.
        Иначе - значение заполненного дополнительного реквизита "country-rec" или "country-send".
   16 - если счет кассы корреспондирует в документе со счетом, клиентом которого является 
        физическое лицо, то это ФИО данного клиента. Иначе значение дополнительного реквизита "ФИО".
   17 - если счет кассы корреспондирует в документе со счетом, клиентом которого является
        физическое лицо, то это тип и номер документа данного клиента.
        Иначе значение дополнительного реквизита "Докум".
   18 - если счет кассы корреспондирует в документе со счетом, клиентом которого является
        физическое лицо, то это адрес данного клиента.
        Иначе значение дополнительного реквизита "Адрес".
   */

   mDocNum = mDocNum + 1.
END.

/* Последние итоги */
RUN PrintTotals&Footer.

{preview.i &filename=arch_file_name}

/* ---------------------------------------------------------------------------------------------------------------------------------- */
PROCEDURE PrintHeader:

   PAGE.

   DISP "Наименование уполномоченного банка                                 "
      mNameBank VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL
      "  (филиала уполномоченного банка)                                  " SKIP
      "Регистрационный номер уполномоченного банка                        "
      mREGN VIEW-AS EDITOR SIZE 35 BY 1 NO-LABEL         SKIP
      "/порядковый номер филиала уполномоченного банка                    " SKIP
      "Адрес уполномоченного банка                                        "
      mAdres-pch VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL    SKIP
      "(филиала уполномоченного банка)                                    " SKIP
      "Адрес операционной кассы                                           "
      mAdres-kass VIEW-AS EDITOR SIZE 50 BY 1 NO-LABEL   SKIP
      "Дата заполнения Реестра                                            "
      op.op-date   NO-LABEL                              SKIP
      "                                                                   День Месяц Год " SKIP
      "Порядковый номер Реестра в течение рабочего дня операционной кассы "
      STRING(mReeNum) NO-LABEL                           SKIP(1)
      WITH FRAME mA1 SIZE 160 BY 10.

   PUT UNFORMATTED 
      SPACE(50) "РЕЕСТР ОПЕРАЦИЙ С НАЛИЧНОЙ ВАЛЮТОЙ И ЧЕКАМИ" SKIP(1).

   PUT UNFORMATTED
      "╔══════╦══════╦═════╦════════════╦═════════════════════════════════════════════════╦═════╦══════════════════════════════════╦══════════════════════╦══════╦═══════╦══════════════════════╦════════════════════╦════════════════════════════════╗" SKIP
      "║Поряд-║Время ║ Код ║   Курс     ║            Наличные денежные средства           ║ Пла-║Принято (выдано) кассовым работни-║     Номер счета      ║ Дове-║  Код  ║ Ф.И.О. физического   ║ Документ, удостове-║ Адрес места жительства (место  ║" SKIP
      "║ковый ║совер-║ вида║(кросс-курс)╠════════════════════════╦════════════════════════╣ теж-║ком чеков (в том числе дорожных   ║                      ║ рен- ║страны ║         лица         ║   ряющий личность  ║ пребывания)                    ║" SKIP
      "║номер ║шения ║ опе-║  иност-    ║       Принято          ║         Выдано         ║ ная ║чеков), номинальная  стоимость ко-║                      ║ ность║ граж- ║                      ║                    ║                                ║" SKIP
      "║опера-║опера-║рации║  ранной    ║  кассовым работником   ║  кассовым работником   ║ кар-║торых указана в иностранной валюте║                      ║      ║данства║                      ║                    ║                                ║" SKIP
      "║ ции  ║ции   ║     ║  валюты    ╠═════╦══════════════════╬═════╦══════════════════╣ та  ╠═════════╦═════╦══════════════════╣                      ║      ║ физи- ║                      ║                    ║                                ║" SKIP
      "║      ║      ║     ║            ║ код ║      сумма       ║ код ║      сумма       ║     ║ Коли-   ║ код ║      сумма       ║                      ║      ║ческого║                      ║                    ║                                ║" SKIP
      "║      ║      ║     ║            ║валю-║                  ║валю-║                  ║     ║ чество  ║валю-║                  ║                      ║      ║ лица  ║                      ║                    ║                                ║" SKIP
      "║      ║      ║     ║            ║ ты  ║                  ║ ты  ║                  ║     ║  чеков  ║ ты  ║                  ║                      ║      ║       ║                      ║                    ║                                ║" SKIP
      "╠══════╬══════╬═════╬════════════╬═════╬══════════════════╬═════╬══════════════════╬═════╬═════════╬═════╬══════════════════╬══════════════════════╬══════╬═══════╬══════════════════════╬════════════════════╬════════════════════════════════╣" SKIP
      "║  1   ║  2   ║  3  ║      4     ║  5  ║         6        ║  7  ║         8        ║  9  ║   10    ║ 11  ║       12         ║          13          ║  14  ║   15  ║          16          ║         17         ║              18                ║" SKIP
   .

END PROCEDURE.


PROCEDURE PrintTotals&Footer:

   FOR EACH tt-itog:
      IF tt-itog.vidop EQ "**"
      THEN NEXT.

      PUT UNFORMATTED
         "╠══════╬══════╬═════╬════════════╬═════╬══════════════════╬═════╬══════════════════╬═════╬═════════╬═════╬══════════════════╬══════════════════════╬══════╬═══════╬══════════════════════╬════════════════════╬════════════════════════════════╣" SKIP
         "║ ИТОГИ║      "
         "║ "   STRING(tt-itog.vidop, "X(2)") "  "
         "║            "
         "║ "   STRING(tt-itog.val5, "x(3)")             " "
         "║ "   STRING(tt-itog.sum6, ">,>>>,>>>,>>9.99") " "
         "║ "   STRING(tt-itog.val7, "x(3)")             " "
         "║ "   STRING(tt-itog.sum8, ">,>>>,>>>,>>9.99") " "
         "║     "
         "║         "
         "║ "   STRING(tt-itog.val11, "x(3)")            " "
         "║ "   STRING(tt-itog.sum12, ">,>>>,>>>,>>9.99") " "
         "║ "   FILL(" " ,21)
         "║      " 
         "║       "
         "║ "   FILL(" " ,21)
         "║ "   FILL(" " ,19)
         "║ "   FILL(" " ,31)
         "║"    SKIP
      .
   END.

   PUT UNFORMATTED
      "╚══════╩══════╩═════╩════════════╩═════╩══════════════════╩═════╩══════════════════╩═════╩═════════╩═════╩══════════════════╩══════════════════════╩══════╩═══════╩══════════════════════╩════════════════════╩════════════════════════════════╝"
      SKIP(1)
   .

   IF     NUM-ENTRIES(iParam,";")   GT 2 
      AND TRIM(ENTRY(3,iParam,";")) EQ "ДА"
   THEN DO:

      PUT UNFORMATTED
         "            СВОДНЫЕ ИТОГИ" SKIP
         "╔══════╦══════╦═════╦════════════╦═════╦══════════════════╦═════╦══════════════════╦═════╦═════════╦═════╦══════════════════╦══════════════════════╦══════╦═══════╦══════════════════════╦════════════════════╦════════════════════════════════╗" SKIP
         "║  1   ║  2   ║  3  ║      4     ║  5  ║        6         ║  7  ║       8          ║  9  ║    10   ║ 11  ║        12        ║          13          ║  14  ║   15  ║          16          ║         17         ║              18                ║" SKIP
      .

      FOR EACH tt-itog
         WHERE tt-itog.vidop EQ "**":

         PUT UNFORMATTED
            "╠══════╬══════╬═════╬════════════╬═════╬══════════════════╬═════╬══════════════════╬═════╬═════════╬═════╬══════════════════╬══════════════════════╬══════╬═══════╬══════════════════════╬════════════════════╬════════════════════════════════╣" SKIP
            "║ ИТОГИ║      "
            "║ все "
            "║            "
            "║ "   STRING(tt-itog.val5, "x(3)")             " "
            "║ "   STRING(tt-itog.sum6, ">,>>>,>>>,>>9.99") " "
            "║ "   STRING(tt-itog.val7, "x(3)")             " "
            "║ "   STRING(tt-itog.sum8, ">,>>>,>>>,>>9.99") " "
            "║     "
            "║         "
            "║ "   STRING(tt-itog.val11, "x(3)")            " "
            "║ "   STRING(tt-itog.sum12, ">,>>>,>>>,>>9.99") " "
            "║ "   FILL(" " ,21)
            "║      " 
            "║       "
            "║ "   FILL(" " ,21)
            "║ "   FILL(" " ,19)
            "║ "   FILL(" " ,31)
            "║"    SKIP
         .
      END.

      PUT UNFORMATTED
         "╚══════╩══════╩═════╩════════════╩═════╩══════════════════╩═════╩══════════════════╩═════╩═════════╩═════╩══════════════════╩══════════════════════╩══════╩═══════╩══════════════════════╩════════════════════╩════════════════════════════════╝"
         SKIP(1)
      .
   END.

   {signatur.i &user-only=yes}
END PROCEDURE.

PROCEDURE put-itog:
   DEFINE INPUT PARAMETER iVidOpNalV AS CHAR.

   FIND FIRST tt-itog
      WHERE tt-itog.vidop EQ iVidOpNalV
        AND tt-itog.val5  EQ m5
        AND tt-itog.val7  EQ m7
        AND tt-itog.val11 EQ m11
      NO-ERROR.

   IF NOT AVAIL tt-itog
   THEN DO:
      CREATE tt-itog.
      ASSIGN
         tt-itog.vidop = iVidOpNalV
         tt-itog.val5  = m5
         tt-itog.val7  = m7
         tt-itog.val11 = m11
      .
   END.

   ASSIGN 
      tt-itog.sum6  = tt-itog.sum6  + m6
      tt-itog.sum8  = tt-itog.sum8  + m8
      tt-itog.sum12 = tt-itog.sum12 + m12
   .
   RELEASE tt-itog.
END PROCEDURE.
