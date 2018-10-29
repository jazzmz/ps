/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2008 ЗАО "Банковские информационные системы"
     Filename: cashord.p
      Comment: "Кассовый ордер 1433-У"
   Parameters:
         Uses:
      Used by:
      Created: 22.06.2004 10:58 sadm    
     Modified: 22.06.2004 19:35 sadm 
     Modified: 05.08.2004 11:42 sadm 0033333: спрашивать тип ордера, если не автоопределился
     Modified: 11.08.2004 17:46 sadm 0033936: определение назв. удост.личности по классиф.     
     Modified: 30.10.2004 14:47 ligp 0032409: Доработка для печати по документам ВОК.
     Modified: 22.09.2005 kraw (049985) Совместимость с oracle
     Modified: 14.10.2005 kraw (0052810) Ошибка печати нескольких экземпляров
     Modified  21.10.2010 HERZ (0135373) Для приходно-расходных кассовых
                                         документов Дб 20202(07) - Кр 20202(07)
                                         добавлен механизм на получение 
                                         приходного/расходного символа
                                         из НП "КасСимволы"
     Modified: 02/02/2011 kraw (0127446) Если в расходном более 3-х символов
 
*/
&SCOP OFFsigns YES
{globals.i}
{intrface.get xclass}
{intrface.get acct}
{intrface.get cust}
{intrface.get tmcod}
{intrface.get db2l}
{parsin.def}
{chkacces.i}
{get-bankname.i}

DEFINE INPUT PARAMETER RID AS RECID NO-UNDO.

DEFINE VARIABLE mdeDocSum    AS DECIMAL NO-UNDO.
DEFINE VARIABLE mdeNatSum    AS DECIMAL NO-UNDO.
DEFINE VARIABLE mdeSymSumIn  AS DECIMAL EXTENT 6 NO-UNDO.
DEFINE VARIABLE mdeSymSumOut AS DECIMAL EXTENT 6 NO-UNDO.
DEFINE VARIABLE mchSymCodIn  AS CHARACTER EXTENT 6 NO-UNDO.
DEFINE VARIABLE mchSymCodOut AS CHARACTER EXTENT 6 NO-UNDO.
DEFINE VARIABLE minCount       AS INT64    NO-UNDO.
DEFINE VARIABLE mchPayer       AS CHARACT EXTENT 3 INIT "" NO-UNDO.
DEFINE VARIABLE mchReceiver    AS CHARACT EXTENT 3 INIT "" NO-UNDO.
DEFINE VARIABLE mchRecBank     AS CHARACTER EXTENT 2 NO-UNDO.
DEFINE VARIABLE AcctCr         LIKE op-entry.acct-cr  NO-UNDO.
DEFINE VARIABLE AcctDb         LIKE op-entry.acct-db  NO-UNDO.
DEFINE VARIABLE AcctDbCur      LIKE op-entry.currency NO-UNDO.
DEFINE VARIABLE AcctCrCur      LIKE op-entry.currency NO-UNDO.
DEFINE VARIABLE AcctKomis      LIKE op-entry.acct-db NO-UNDO.
DEFINE VARIABLE DocCur         LIKE op-entry.currency NO-UNDO.
DEFINE VARIABLE TmpSymbol      LIKE op-entry.symbol   NO-UNDO.
DEFINE VARIABLE mdtDateDoc     AS DATE       NO-UNDO.
DEFINE VARIABLE mchOrdTypeDb   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchOrdTypeCr   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchIdentCard   AS CHARACTER NO-UNDO.
DEFINE VARIABLE CrCustCat      LIKE acct.cust-cat NO-UNDO.
DEFINE VARIABLE CrCustCat1     LIKE acct.cust-cat NO-UNDO.
DEFINE VARIABLE DbCustCat      LIKE acct.cust-cat NO-UNDO.
DEFINE VARIABLE DbCustCat1     LIKE acct.cust-cat NO-UNDO.
DEFINE VARIABLE CrContract     LIKE acct.contract NO-UNDO.
DEFINE VARIABLE mchBankName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchBankBIK     AS CHARACTER NO-UNDO.
DEFINE VARIABLE mlgChoise      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mchBankSity    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mVOKDprID      AS CHARACTER NO-UNDO. /* ИД смены ВОК в документе */
DEFINE VARIABLE mDocument-id   AS CHARACTER NO-UNDO. /* Тип документа */
DEFINE VARIABLE mDocCodName    AS CHARACTER NO-UNDO. /* Код документа */
DEFINE VARIABLE mDetails       AS CHARACTER NO-UNDO.
DEFINE VARIABLE mPersonId      AS INT64   NO-UNDO.
DEFINE VARIABLE mIdCustAttr    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mCustTable1    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mINN           AS CHARACTER NO-UNDO.
DEFINE VARIABLE mDbBranchNam   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mCrBranchOKATO AS CHARACTER NO-UNDO.
DEFINE VARIABLE mCrBranchNam   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mTmpStr        AS CHARACTER NO-UNDO.
DEFINE VARIABLE mDocDate       AS CHARACTER NO-UNDO. /* Дата выдачи документа */
DEFINE VARIABLE mDocNum        AS CHARACTER NO-UNDO.
DEFINE VARIABLE mPassKP        AS CHARACTER NO-UNDO.
DEFINE VARIABLE mCustDocWho    AS CHARACTER EXTENT 2 NO-UNDO.
DEFINE VARIABLE mKasSchPol     AS CHARACTER NO-UNDO.
DEFINE VARIABLE mInnKas        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mRecINN        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mRecKPP        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mRecOKATO      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mRecAcct       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mPayBank       AS CHARACTER EXTENT 2 NO-UNDO.
DEFINE VARIABLE mPayBankBik    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mchFIO         AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchWorkerBuh   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchWorkerKont  AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchWorkerKas   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mIsPrtCity     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mAgentID       AS CHARACTER NO-UNDO.
DEFINE VARIABLE mProxyCode     AS CHARACTER NO-UNDO.
DEFINE VARIABLE mDrowerID      AS CHARACTER NO-UNDO.
DEFINE VARIABLE mchSymFromNP   AS CHARACTER NO-UNDO. 
DEFINE VARIABLE mIsInOut       AS LOGICAL INITIAL FALSE NO-UNDO. 

&IF DEFINED(ORACLE) <> 0 &THEN
DEFINE VARIABLE mRwd           AS ROWID     NO-UNDO.
&ENDIF
DEFINE BUFFER komis-op-entry FOR op-entry.
DEFINE BUFFER xhistory       FOR history.
DEFINE BUFFER xcust-ident    FOR cust-ident.
DEFINE BUFFER bProxy         FOR loan.
DEFINE BUFFER bAgent         FOR person.
DEFINE BUFFER bCustIdent     FOR cust-ident.
DEFINE BUFFER bDrower        FOR person.

&IF DEFINED(LAW_318p) <> 0 &THEN
FUNCTION LocalGetRAcct RETURNS CHAR PRIVATE (INPUT iCustCat AS CHAR, INPUT iCustId AS INT64, INPUT iOpOp AS INT64, INPUT iOpDate AS DATE):
   DEFINE BUFFER recacct FOR acct.
   FIND FIRST recacct WHERE recacct.cust-cat = iCustCat
                        AND recacct.cust-id  = iCustId
                        AND recacct.acct-cat = "b"
                        AND recacct.contract = "Расчет"
                        AND CAN-FIND(FIRST op-entry WHERE op-entry.op = iOpOp
                                                      AND (   op-entry.acct-db = recacct.acct
                                                           OR op-entry.acct-cr = recacct.acct) NO-LOCK)
   NO-LOCK NO-ERROR.
   IF NOT AVAIL recacct
      THEN FIND FIRST recacct WHERE recacct.cust-cat   = iCustCat
                                AND recacct.cust-id    = iCustId
                                AND recacct.acct-cat   = "b"
                                AND recacct.contract   = "Расчет"
                                AND recacct.open-date <= op.op-date
                                AND (   recacct.close-date = ?
                                     OR recacct.close-date > iOpDate)
           NO-LOCK NO-ERROR.
   IF AVAIL recacct THEN RETURN STRING(recacct.number, GetAcctFmt(recacct.acct-cat)).
   RETURN "".
END FUNCTION.
&ENDIF

FIND FIRST op WHERE RECID(op) = RID NO-LOCK NO-ERROR.

/* определяем счет дебета */
FIND FIRST op-entry OF op WHERE op-entry.acct-db <> ? NO-LOCK NO-ERROR.
IF NOT AVAIL(op-entry) THEN
   DO:
      MESSAGE "Проводок по дебету по документу не найдено" VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.
ELSE
   AcctDb = op-entry.acct-db.

IF NOT type-curracct THEN
   {find-act.i &fila=LAST &acct=AcctDb &curr=op-entry.currency}
ELSE
   FIND acct WHERE acct.acct EQ AcctDb
               AND acct.currency EQ op-entry.currency
      NO-LOCK NO-ERROR.

IF AVAIL acct THEN
   DO:
      IF acct.contract BEGINS "Касса" THEN
         mchOrdTypeDb = "приходный".
      AcctDbCur = acct.currency.
      DbCustCat = acct.cust-cat.
      FOR FIRST branch WHERE branch.branch-id EQ acct.branch-id NO-LOCK:
         mDbBranchNam   = branch.name.
      END.
     mDbBranchNam = cBankname.
   END.
ELSE DO:
   MESSAGE "Счет по дебету " + AcctDb + " не найден"
      VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

/* определяем счет кредита */
FIND FIRST op-entry OF op WHERE op-entry.acct-cr <> ? NO-LOCK NO-ERROR.
IF NOT AVAIL(op-entry) THEN DO:
   MESSAGE "Проводок по кредиту по документу не найдено" VIEW-AS ALERT-BOX ERROR.
   RETURN.
   END.
ELSE
   AcctCr = op-entry.acct-cr.

IF NOT type-curracct THEN
   {find-act.i &fila=LAST &acct=AcctCr &curr=op-entry.currency}
ELSE
   FIND acct WHERE acct.acct EQ AcctCr
               AND acct.currency EQ op-entry.currency
     NO-LOCK NO-ERROR.

IF AVAIL acct THEN
   DO:
      IF acct.contract BEGINS "Касса" THEN
         mchOrdTypeCr = "расходный".
      AcctCrCur = acct.currency.
      CrCustCat = acct.cust-cat.
      CrContract = acct.contract.
      FOR FIRST branch WHERE branch.branch-id EQ acct.branch-id NO-LOCK:
         mCrBranchNam  = branch.name.
	 mCrBranchNam = cBankName.
         mCrBranchOKATO = GetXAttrValueEx("branch",acct.branch-id,"ОКАТО-НАЛОГ","").
      END.
   END.
ELSE DO:
   MESSAGE "Счет по кредиту " + AcctCr + " не найден"
      VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

&IF DEFINED(LAW_318p) <> 0 &THEN
   IF  AcctDbCur    EQ AcctCrCur
   AND mchOrdTypeDb EQ "приходный"
   AND mchOrdTypeCr EQ "расходный" THEN DO:
      ASSIGN
         mlgChoise = TRUE
         mIsInOut  = TRUE
      .
      MESSAGE "Печатать документ" op.doc-num "как ПРИХОДНО-РАСХОДНЫЙ ордер?"
         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mlgChoise.
      IF mlgChoise THEN ASSIGN
         mchOrdTypeDb = "приходно─расходный"
         mchOrdTypeCr = "приходно─расходный"
      .
   END.
&ENDIF

/* 0033333: Если ни один из корреспондирующих счетов не имеет признак "касса" */
/* и оба в одинаковой валюте, то придется спросить какой ордер нужен */
mlgChoise = TRUE.
IF  AcctDbCur EQ AcctCrCur
AND (   (    mchOrdTypeCr EQ ""
         AND mchOrdTypeDb EQ "")
     OR (    mchOrdTypeDb EQ "приходный"
         AND mchOrdTypeCr EQ "расходный")
    )
   THEN DO:
      MESSAGE "Печатать документ" op.doc-num "как ПРИХОДНЫЙ ордер?"
         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mlgChoise.
      IF mlgChoise THEN DO:
         mchOrdTypeDb = "приходный".
         mchOrdTypeCr = "".
      END.
      ELSE DO:
         mchOrdTypeCr = "расходный".
         mchOrdTypeDb = "".
      END.
   END.

mdtDateDoc = IF op.doc-date = ? THEN op.op-date ELSE op.doc-date.

ASSIGN
   mchBankName = cBankName
   mchBankBIK  = FGetSetting("БанкМФО", ?,"")
   mchBankSity = ", " + FGetSetting("БанкГород", ?,"")
   mKasSchPol  = FGetSetting("КасСчПол", "","")
   mInnKas     = FGetSetting("ПлатДок", "ВывИННКас","")
   &IF DEFINED(LAW_318p) <> 0 &THEN
      mIsPrtCity = (FGetSetting("ПлатДок", "ВыводМест","Да") = "Да")
   &ELSE
      mIsPrtCity = YES
   &ENDIF
.

IF op-entry.symbol NE "" AND mIsInOut THEN
DO:

   IF GetTCodeFld
      ("val",
       "КасСимволы",
       op-entry.symbol,
       op-entry.op-date)

   BEGINS "прих"
   THEN
      mchSymFromNP = FGetSetting("КасСимволы", "прих-" + op-entry.symbol,"").
   ELSE
      mchSymFromNP = FGetSetting("КасСимволы", "расх-" + op-entry.symbol ,"").

END.

{strtout3.i &cols=98 &option=Paged}

IF mchOrdTypeDb = "приходный" THEN DO:
   &IF DEFINED(LAW_318p) <> 0 &THEN
      FIND FIRST komis-op-entry OF op WHERE komis-op-entry.acct-db  = AcctDb
                                        AND komis-op-entry.acct-cr <> AcctCr
                                        AND CAN-FIND(FIRST code WHERE code.class = "ПрСуммы"
                                                                  AND CAN-DO(code.val,komis-op-entry.acct-cr))
         NO-LOCK NO-ERROR.
      IF AVAIL komis-op-entry
         THEN AcctKomis = komis-op-entry.acct-cr.
         ELSE AcctKomis = "".
   &ENDIF

/*Ермилов В.Н. Наименование банка вносителя-получателя в ПКО берется без города - кажется, БИС исправил*/
   mchRecBank[1] = mchBankName /*+ mchBankSity */ .
   mchRecBank[1] = mchBankName.

   IF mIsPrtCity THEN mchRecBank[1] = mchRecBank[1] + mchBankSity.

/*PIR Исправление внес Маслов Д. А. .
БЫЛО: При печати расходного или приходного ордера в качестве плательщика бралось значение ФИО  из доп. реквизитов документа (доп. реквизит для 113-И), в случае 
если оно не заполнено, то берем значение плательщика из документа.
СТАЛО: Наоборот сначала плательщик из документа, затем ФИО из доп. реквизитов. 
    mchPayer[1] = GetXAttrValueEx("op", STRING(op.op), "ФИО", "").
   IF mchPayer[1] = "" THEN
      mchPayer[1] = IF op.name-ben = ? THEN "" ELSE op.name-ben.   */

   IF op.name-ben = ? OR op.name-ben EQ ""
   THEN mchPayer[1] = GetXAttrValueEx("op", STRING(op.op), "ФИО", "").
   ELSE mchPayer[1] = op.name-ben.
/*PIR end */

   IF mchPayer[1] = "" THEN DO:
      {find-act.i &acct=AcctCr &curr=AcctCrCur}
      mchPayer[1] = "".
      {getcust.i &name=mchPayer}
      mchPayer[1] = mchPayer[1] + " " + mchPayer[2].
      IF CAN-DO(FGetSetting("КассСчИНН","",?), SUBSTR(acct.acct,1,5))
      OR GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "bank-inn", ?) = "Да" THEN DO:
         mINN        = IF FGetSetting("ИНН",?,?) <> "" THEN FGetSetting("ИНН",?,?) ELSE "000000000000".
         mchPayer[1] = (IF mINN <> "000000000000" THEN "ИНН " + mINN + " " ELSE "").
         mchPayer[1] = mchPayer[1] + mchBankName.
      END.
   END.

   IF INDEX(mchPayer[1],"ИНН  ") = 1 THEN
      mchPayer[1] = SUBSTR(mchPayer[1],6,LENGTH(mchPayer[1])).

   IF CAN-DO(mInnKas,SUBSTR(acct.acct,1,5)) AND INDEX(mchPayer[1],"ИНН ") = 1 THEN
      mchPayer[1] = TRIM(SUBSTRING(mchPayer[1],INDEX(mchPayer[1]," ",5))).

   /* пасп данные плательщика */
   IF fGetSetting ("ПлатДок", "ВыводПасп", "") EQ "Да" THEN
   DO:
      /* идент.типа документа */
      mchIdentCard = GetXAttrValueEx("op", STRING(op.op), "document-id", "").
      /* тип документа из классиф. КодДокум */
      mchIdentCard = IF mchIdentCard NE "" THEN GetCodeName("КодДокум", mchIdentCard) ELSE "".

      /* сливаем тип документа со значением ДР Докум (там обычно номер и кем выдан) */
      mchIdentCard = TRIM(mchIdentCard +
                          " " +
                          GetXAttrValueEx("op", STRING(op.op), "Докум", "")).

      mchPayer[1] = mchPayer[1] + " " + mchIdentCard.
   END.

   &IF DEFINED(LAW_318p) <> 0 &THEN
      mRecINN   = FGetSetting("ИНН",?,"").
      mRecKPP   = FGetSetting("БанкКПП",?,"").
      mRecOKATO = FGetSetting("БанкОКАТО",?,"").
      IF {assigned mCrBranchOKATO}
         THEN mRecOKATO = mCrBranchOKATO.
   &ENDIF
   mchReceiver[1] = mchBankName.

   CASE CrCustCat:
      WHEN "В" THEN DO: /* внутрибанк */
         mTmpStr = FGetSetting("КасОрдНС",?,"").
         IF mTmpStr EQ "банк" THEN DO:
            IF {assigned TRIM(mDbBranchNam)}
               THEN mchReceiver[1] = mDbBranchNam.
         END.
         ELSE IF mTmpStr EQ "счет" THEN DO:
            {find-act.i &acct=AcctCr &curr=AcctCrCur}
            IF AVAIL acct THEN
               mchReceiver[1] = acct.Details.
         END.
         ELSE DO:
            RUN GetCustIdCli IN h_acct (INPUT  AcctCr + "," + AcctCrCur,
                                        OUTPUT CrCustCat1,
                                        OUTPUT mIdCustAttr).
            RUN GetCustName IN h_base (CrCustCat1, mIdCustAttr, ?,
                                       OUTPUT mchReceiver[1],
                                       OUTPUT mchReceiver[2],
                                       INPUT-OUTPUT mINN).
            mchReceiver[1] = mchReceiver[1] + " " + mchReceiver[2].
            IF NOT {assigned mchReceiver[1]} THEN DO:
               IF {assigned mDbBranchNam}
               THEN mchReceiver[1] = mDbBranchNam.
               ELSE mchReceiver[1] = mchBankName.
            END.
            ELSE DO:
               &IF DEFINED(LAW_318p) <> 0 &THEN
                  CASE CrCustCat1:
                     WHEN "Ю" THEN mCustTable1 = "cust-corp".
                     WHEN "Ч" THEN mCustTable1 = "person".
                     WHEN "Б" THEN mCustTable1 = "banks".
                  END CASE.
                  IF  mCustTable1 <> ""
                  AND {assigned mIdCustAttr} THEN DO:
                     mRecKPP   = GetXAttrValueEx(mCustTable1, mIdCustAttr, "КПП", "").
                     mRecOKATO = GetXAttrValueEx(mCustTable1, mIdCustAttr, "ОКАТО-НАЛОГ", "").
                     mRecAcct  = LocalGetRAcct(CrCustCat1, INT64(mIdCustAttr), op.op, op.op-date).
                  END.
                  ELSE ASSIGN
                     mRecKPP   = ""
                     mRecOKATO = ""
                     mRecAcct  = ""
                  .
               &ENDIF
            END.
         END.
      END.
      WHEN "Ю" OR WHEN "Ч" OR WHEN "Б" THEN DO: /* юр, физлица и банки */
         IF CAN-DO(mKasSchPol,SUBSTR(AcctCr,1,5)) THEN DO:
            mchReceiver[1] = mDbBranchNam.
            IF TRIM(mchReceiver[1]) EQ "" THEN
               mchReceiver[1] = mchBankName.
         END.
         ELSE DO:
            ASSIGN
               mchReceiver[1] = ""
               mRecKPP        = ""
               mRecOKATO      = ""
               mRecAcct       = ""
            .
            IF  AcctCr <> ""
            AND AcctCr <> ? THEN DO:
               {find-act.i &acct=AcctCr &curr=AcctCrCur}
               &IF DEFINED(LAW_318p) <> 0 &THEN
                  {getcust.i &name=mchReceiver &OFFinn=yes &inn=mRecInn &findcust=YES}
               &ELSE
                  {getcust.i &name=mchReceiver}
               &ENDIF
               mchReceiver[1] = mchReceiver[1] + " " + mchReceiver[2].
               &IF DEFINED(LAW_318p) <> 0 &THEN
                  IF  CrCustCat = "Ч"
                  AND AVAIL person THEN DO:
                     mRecKPP   = GetXAttrValueEx("person", STRING(person.person-id), "КПП", "").
                     mRecOKATO = GetXAttrValueEx("person", STRING(person.person-id), "ОКАТО-НАЛОГ", "").
                     mRecAcct  = LocalGetRAcct(CrCustCat, person.person-id, op.op, op.op-date).
                  END.
                  IF  CrCustCat = "Ю"
                  AND AVAIL cust-corp THEN DO:
                     mRecKPP   = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "КПП", "").
                     mRecOKATO = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОКАТО-НАЛОГ", "").
                     mRecAcct  = LocalGetRAcct(CrCustCat, cust-corp.cust-id, op.op, op.op-date).
                  END.
                  IF  CrCustCat = "Б"
                  AND AVAIL banks THEN DO:
                     mRecKPP   = GetXAttrValueEx("banks", STRING(banks.bank-id), "КПП", "").
                     mRecOKATO = GetXAttrValueEx("banks", STRING(banks.bank-id), "ОКАТО-НАЛОГ", "").
                     mRecAcct  = LocalGetRAcct(CrCustCat, banks.bank-id, op.op, op.op-date).
                  END.
               &ENDIF
            END.
         END.
      END.
   END CASE.
   IF mRecINN = ? THEN mRecINN = "".

   IF INDEX(mchReceiver[1],"ИНН  ") = 1 THEN
      mchReceiver[1] = SUBSTR(mchReceiver[1],6,LENGTH(mchReceiver[1])).

   IF CAN-DO(mInnKas,SUBSTR(acct.acct,1,5)) AND INDEX(mchReceiver[1],"ИНН ") = 1 THEN
      mchReceiver[1] = TRIM(SUBSTRING(mchReceiver[1],INDEX(mchReceiver[1]," ",5))).

   ASSIGN
      DocCur    = AcctDbCur
      minCount  = 0
      mdeDocSum = 0
      mdeNatSum = 0
   .
   _symbin:
   FOR EACH op-entry OF op WHERE op-entry.acct-db = AcctDb NO-LOCK:
       IF DocCur = "" THEN
           mdeDocSum = mdeDocSum + op-entry.amt-rub.
       ELSE
           ASSIGN
               mdeNatSum = mdeNatSum + op-entry.amt-rub
               mdeDocSum = mdeDocSum + op-entry.amt-cur
           .
       TmpSymbol = IF mIsInOut THEN mchSymFromNP ELSE op-entry.symbol.
       IF TmpSymbol <> "" THEN DO:
           IF NOT GetTCodeFld("val",
                              "КасСимволы",
                              TmpSymbol,
                              op-entry.op-date) BEGINS "прих"
           THEN
               NEXT _symbin.
           IF minCount = EXTENT(mdeSymSumIn) THEN DO:
               MESSAGE
                   "Не могу обработать более"
                   STRING(EXTENT(mdeSymSumIn))
                   "символов"
               VIEW-AS ALERT-BOX.
               LEAVE.
           END.
           ASSIGN
               minCount              = minCount + 1
               mchSymCodIn[minCount] = TmpSymbol
               mdeSymSumIn[minCount] = IF DocCur = "" THEN op-entry.amt-rub
                                                      ELSE op-entry.amt-cur
           .
       END.
   END.
   mDetails = GetXAttrValueEx("op", STRING(op.op), "Основание", "").
   mDetails = (IF LENGTH(mDetails) GT 2 THEN mDetails + "~n" ELSE "") +
              op.Details
   .

   &IF DEFINED(LAW_318p) <> 0 &THEN
      ASSIGN
         mPayBank[1] = mchRecBank[1]
         mPayBankBik = mchBankBIK
      .
      IF CAN-DO(FGetSetting("ПлатДок", "ВывИННПол",""), SUBSTR(acct.acct,1,5)) THEN ASSIGN
         mRecInn   = ""
         mRecKPP   = ""
         mRecOKATO = ""
         mRecAcct  = ""
      .

      mTmpStr = GetXAttrValueEx("op", STRING(op.op), "name-rec", "").
      IF {assigned mTmpStr} THEN DO:
         mchReceiver = mTmpStr.
         mRecINN     = GetXAttrValueEx("op", STRING(op.op), "INN-rec", "").
         mRecKPP     = GetXAttrValueEx("op", STRING(op.op), "KPP-rec", "").
         mRecOKATO   = GetXAttrValueEx("op", STRING(op.op), "OKATO-rec", "").
      END.

      IF   {assigned op.ben-acct}
      THEN mRecAcct = op.ben-acct.

      FIND op-bank OF op NO-LOCK NO-ERROR.
      IF AMBIGUOUS op-bank
      THEN FIND op-bank OF op WHERE op-bank.op-bank-type = "" NO-LOCK NO-ERROR.
      IF AVAIL op-bank THEN ASSIGN
         mchRecBank[1] = op-bank.bank-name
         mchBankBIK    = op-bank.bank-code
      .

   &ENDIF

   {docform.i
      &cashord      = ""приходный""
      &docdate      = mdtDateDoc
      &docnum       = op.doc-num
      &payer        = mchPayer
      &receiver     = mchReceiver
      &recbank      = mchRecBank
      &dbacct       = AcctDb
      &cracct       = AcctCr
      &docsum       = mdeDocSum
      &doccur       = DocCur
      &symsumin     = mdeSymSumIn
      &symsumout    = mdeSymSumOut
      &natsum       = mdeNatSum
      &symcodin     = mchSymCodIn
      &symcodout    = mchSymCodOut
      &details      = mDetails
      &identcard    = mchIdentCard
      &documentid   = mDocCodName
      &documentnum  = mDocNum
      &documentwho  = mCustDocWho
      &documentdate = mDocDate
      &recinn       = mRecInn
      &recbankbik   = mchBankBIK
      &reckpp       = mRecKPP
      &recokato     = mRecOKATO
      &recacct      = mRecAcct
      &paybank      = mPayBank
      &paybankbik   = mPayBankBik
      &acctkomis    = AcctKomis
      &inc_part_fio = mchFIO
      &worker_buh   = mchWorkerBuh
      &worker_kont  = mchWorkerKont
      &worker_kas   = mchWorkerKas
   }
END.

IF mchOrdTypeCr = "расходный" THEN DO:
   IF FGetSetting("КасОрдНС",?,"") EQ "счет" THEN DO:
      {find-act.i &acct=AcctCr &curr=AcctCrCur}
      IF AVAIL acct THEN 
         mchPayer[1] = acct.Details.
   END.
   ELSE
       mchPayer[1] = "".

   mchRecBank[1] = mchBankName.
   IF mIsPrtCity THEN mchRecBank[1] = mchRecBank[1] + mchBankSity.

   /* получатель */
   /*
      Маслов Д. А.
      Изменяем приоритет основного реквизита над долонительным.
      Необходимо для расходного кассового ордера по валюте.
      Было:
           mchReceiver[1] = GetXAttrValueEx("op", STRING(op.op), "ФИО", "").
            IF mchReceiver[1] = "" THEN
            mchReceiver[1] = IF op.name-ben = ? THEN "" ELSE op.name-ben.
      Стало: <см. в коде ниже>
    */

   IF (op.name-ben = ?) OR (op.name-ben = "")
   THEN mchReceiver[1] = GetXAttrValueEx("op", STRING(op.op), "ФИО", "").
   ELSE mchReceiver[1] = op.name-ben.
/*PIR end */

   IF mchReceiver[1] = "" THEN DO:
      IF DbCustCat EQ "В" THEN DO:
         RUN GetCustIdCli IN h_acct (INPUT  AcctDb + "," + AcctDbCur,
                                     OUTPUT DbCustCat1,
                                     OUTPUT mIdCustAttr).
         RUN GetCustName IN h_base (DbCustCat1, mIdCustAttr, ?,
                                    OUTPUT mchReceiver[1],
                                    OUTPUT mchReceiver[2],
                                    INPUT-OUTPUT mINN
         ).
         mchReceiver[1] = mchReceiver[1] + " " + mchReceiver[2].
      END.
      IF TRIM(mchReceiver[1]) EQ "" THEN DO:
         {getcust2.i AcctDb mchReceiver}
         mchReceiver[1] = mchReceiver[1] + " " + mchReceiver[2].
      END.
   END.

   IF INDEX(mchReceiver[1],"ИНН  ") = 1 THEN
      mchReceiver[1] = SUBSTR(mchReceiver[1],6,LENGTH(mchReceiver[1])).

   IF CAN-DO(mInnKas,SUBSTR(AcctDb,1,5)) AND INDEX(mchReceiver[1],"ИНН ") = 1 THEN
      mchReceiver[1] = TRIM(SUBSTRING(mchReceiver[1],INDEX(mchReceiver[1]," ",5))).

   mVOKDprID    = GetXAttrValueEx("op", STRING(op.op), "dpr-id",""). /* код смены ВОК */

   mDocument-id = GetXAttrValueEx("op",STRING(Op.op),"document-id","").
   mDocNum      = GetXAttrValueEx("op",STRING(op.op), "Докум", "").
   RUN ParseDocum (INPUT-OUTPUT mDocument-id, INPUT-OUTPUT mDocNum, OUTPUT mDocCodName, OUTPUT mCustDocWho[1], OUTPUT mDocDate, OUTPUT mPassKP).
   mCustDocWho[1] = GetXAttrValueEx("op",STRING(Op.op),"cust-doc-who",mCustDocWho[1]).
   mDocDate       = GetXAttrValueEx("op",STRING(Op.op),"Document4Date_vid",mDocDate).
   IF mVOKDprID NE "" THEN /* документ не созданный ВОК */
   /* документ, созданный в ВОК */
   DO:
      mchIdentCard = (IF mDocCodName NE ? 
                         THEN mDocCodName 
                         ELSE mDocument-id) +
                     (IF mDocNum NE ""
                         THEN " № " + mDocNum
                         ELSE "") +
                     (IF mCustDocWho[1] NE ""
                         THEN "~nВыдан " + mCustDocWho[1]
                         ELSE "") +
                     IF mDocDate NE "" THEN (", дата выдачи:" + mDocDate) ELSE "".
   END. /* документ, созданный в ВОК */
   ELSE
   DO:
   /* пасп данные получателя */
   /* идент.типа документа */
      /* тип документа из классиф. КодДокум */
      /* сливаем тип документа со значением ДР Докум (там обычно номер и кем выдан) */
      mchIdentCard = TRIM(mDocCodName + " " + GetXAttrValueEx("op", STRING(op.op), "Докум", "")).
   END.
   IF NOT {assigned mchIdentCard} THEN DO:
      /* доп.рек. Докум не указан */
      mchIdentCard = GetXAttrValueEx("op", STRING(op.op), "Passport", "").
      IF {assigned mchIdentCard} THEN DO:
         /* доп.рек. Passport указан */
         ASSIGN
            mDocument-id = ""
            mDocNum      = mchIdentCard
         .
         RUN ParseDocum (INPUT-OUTPUT mDocument-id, INPUT-OUTPUT mDocNum, OUTPUT mDocCodName, OUTPUT mCustDocWho[1], OUTPUT mDocDate, OUTPUT mPassKP).
      END.
      ELSE DO:
         /* доп.рек. Passport не указан */
         FIND FIRST acct WHERE acct.acct = AcctDb NO-LOCK NO-ERROR.
         IF AVAILABLE acct THEN DO:
            mPersonId = IF acct.cust-cat = "Ч" THEN /* клиента будем искать по cust-id счета */
                           acct.cust-id
                        ELSE IF acct.cust-cat = "В" AND
                                GetXattrValueEx("acct", AcctDb + "," + AcctDbCur, "ТипКл", "") EQ "Ч"
                             THEN /* клиента будем искать по д.р. IDCust счета */
                                INT64(GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "IDCust", ?))
                        ELSE
                           ?
            .
            IF mPersonId NE ? THEN DO:
               FIND FIRST person WHERE person.person-id = mPersonId NO-LOCK NO-ERROR.
               IF AVAILABLE person THEN DO:
                  mDocCodName    = GetCodeName("КодДокум", person.document-id).
                  mDocNum        = person.document.
                  IF  {assigned mDocCodName}
                  AND {assigned mDocNum} THEN DO:
                  END.
                  FIND FIRST xcust-ident WHERE xcust-ident.cust-cat       = "Ч"
                                           AND xcust-ident.cust-id        = person.person-id
                                           AND xcust-ident.cust-code-type = person.document-id
                                           AND xcust-ident.cust-code      = person.document
                  NO-LOCK NO-ERROR.
                  IF AVAIL xcust-ident THEN DO:
                     IF {assigned xcust-ident.issue}
                     THEN mCustDocWho[1] = xcust-ident.issue.
                     ELSE mCustDocWho[1] = person.issue.
                     IF xcust-ident.open-date <> ?
                     THEN mDocDate = STRING(xcust-ident.open-date,"99/99/9999").
                     ELSE mDocDate = GetXattrValueEx("person", STRING(person.person-id), "Document4Date_Vid", "").
                     mPassKP = GetXattrValueEx("cust-ident",
                                               GetSurrogateBuffer("cust-ident",(BUFFER xcust-ident:HANDLE)),
                                               "Подразд",
                                               "").
                  END.
                  ELSE DO:
                     mCustDocWho[1] = person.issue.
                     mDocDate       = GetXattrValueEx("person", STRING(person.person-id), "Document4Date_Vid", "").
                  END.
                  mchIdentCard = (IF mDocCodName NE ? THEN mDocCodName ELSE person.document-id)
                               + " N " + mDocNum + ", выдан "
                               + TRIM(person.issue + " " + mDocDate).
                  IF  {assigned mCustDocWho[1]}
                  AND {assigned mPassKP} THEN DO:
                     IF  NUM-ENTRIES(mCustDocWho[1]) >= 2
                     AND TRIM(ENTRY(NUM-ENTRIES(mCustDocWho[1]),mCustDocWho[1])) = TRIM(mPassKP)
                     THEN ASSIGN
                        ENTRY(NUM-ENTRIES(mCustDocWho[1]),mCustDocWho[1]) = ""
                        mCustDocWho[1] = TRIM(mCustDocWho[1],",")
                     .
                  END.
               END.
            END.
         END.
      END.
   END.

   IF  {assigned mPassKP}
   AND INDEX(mCustDocWho[1]," к/п ") = 0
   THEN ASSIGN mCustDocWho[1] = mCustDocWho[1] + " к/п " + mPassKP.

   IF {assigned mDocDate}
      THEN mDocDate = term2str(DATE(mDocDate),DATE(mDocDate)) NO-ERROR.

   DO mInCount = 1 TO EXTENT(mdeSymSumOut):
      /* чистим массивы после печати прих.ордера */
      mdeSymSumOut[mInCount] = 0.
      mchSymCodOut[mInCount] = "".
   END.
   ASSIGN
      DocCur    = AcctCrCur
      mdeNatSum = 0
      minCount  = 0
      mdeDocSum = 0
   .

   mProxyCode = GetXAttrValue ("op",
                               STRING(op.op),
                               "proxy-code").
   IF {assigned mProxyCode} THEN
   DO:
      FIND FIRST bProxy WHERE bProxy.contract   EQ "proxy"
                          AND bProxy.cont-code  EQ mProxyCode
         NO-LOCK NO-ERROR.
      IF AVAIL bProxy THEN
      DO:
         mAgentID = GetXAttrValue ("loan",
                                   bProxy.contract + "," + bProxy.cont-code,
                                   "agent-id").
         IF {assigned mAgentID} THEN
         DO:
            FIND FIRST bAgent WHERE bAgent.person-id EQ INT64(mAgentID)
               NO-LOCK NO-ERROR.
            IF AVAIL bAgent THEN
            DO:
               mDrowerID = GetXAttrValue ("loan",
                                          bProxy.contract + "," + bProxy.cont-code,
                                          "drower-id").
               IF {assigned mDrowerID} THEN                  
                  FIND FIRST bDrower WHERE bDrower.person-id EQ INT64(mDrowerID)
                     NO-LOCK NO-ERROR.

               ASSIGN
                  mchReceiver[1]  = bAgent.name-last + " " + bAgent.first-names.

               IF FGetSetting("КасОрдНП",?,"") EQ "Да" THEN
                  mchDetails[1] = "Выдача денежной наличности по доверенности от " 
                                       + STRING(bProxy.open-date) 
                                       + (IF {assigned bProxy.doc-num} THEN " N " + bProxy.doc-num
                                                                       ELSE "")
                                       + " за " + (IF AVAIL bDrower THEN bDrower.name-last + " " + bDrower.first-names
                                                                                               ELSE "").
               ELSE
                  mchDetails[1] = op.details.

               FIND FIRST bCustIdent WHERE bCustIdent.class-code     EQ "p-cust-ident"
                                       AND bCustIdent.cust-code-type EQ bAgent.document-id
                                       AND bCustIdent.cust-cat       EQ "Ч"
                                       AND bCustIdent.cust-id        EQ bAgent.person-id
                                       AND (   bCustIdent.close-date EQ ?
                                            OR bCustIdent.close-date LE gend-date)
                  NO-LOCK NO-ERROR.
               IF AVAIL bCustIdent THEN
               DO:
                  mDocument-id = GetXAttrValueEx("op",STRING(Op.op),"document-id",""). 
                  mDocNum      = GetXAttrValueEx("op",STRING(op.op), "Докум", "").
                  IF {assigned mDocNum} THEN
                  DO:
                     RUN ParseDocum (INPUT-OUTPUT mDocument-id, INPUT-OUTPUT mDocNum, OUTPUT mDocCodName, OUTPUT mCustDocWho[1], OUTPUT mDocDate, OUTPUT mPassKP).

                     IF  {assigned mPassKP}
                     AND INDEX(mCustDocWho[1]," к/п ") = 0
                     THEN ASSIGN mCustDocWho[1] = mCustDocWho[1] + " к/п " + mPassKP.
                  END.
                  ELSE
                     ASSIGN
                        mDocCodName    = GetCodeName ("КодДокум", bAgent.document-id)
                        mDocNum        = bCustIdent.cust-code
                        mCustDocWho[1] = bCustIdent.issue
                        mDocDate       = STRING(bCustIdent.open-date, "99/99/9999")
                     .
               END.
            END.
            
         END.
      END.
   END.
   ELSE
      mChDetails[1] = op.details.

   _symbout:
   FOR EACH op-entry OF op WHERE op-entry.acct-cr = AcctCr NO-LOCK:
       IF DocCur = "" THEN
           mdeDocSum = mdeDocSum + op-entry.amt-rub.
       ELSE
           ASSIGN
               mdeNatSum = mdeNatSum + op-entry.amt-rub
               mdeDocSum = mdeDocSum + op-entry.amt-cur
           .
       TmpSymbol = IF mIsInOut THEN mchSymFromNP ELSE op-entry.symbol.
       IF TmpSymbol <> "" THEN DO:
           IF NOT GetTCodeFld("val",
                              "КасСимволы",
                              TmpSymbol,
                              op-entry.op-date) BEGINS "расх"
           THEN
               NEXT _symbout.
           IF minCount = EXTENT(mdeSymSumOut) THEN DO:
               MESSAGE
                   "Не могу обработать более"
                   STRING(EXTENT(mdeSymSumOut))
                   "символов"
               VIEW-AS ALERT-BOX.
               LEAVE.
           END.
           ASSIGN
               minCount               = minCount + 1
               mchSymCodOut[minCount] = TmpSymbol
               mdeSymSumOut[minCount] = IF DocCur = "" THEN op-entry.amt-rub
                                                       ELSE op-entry.amt-cur
           .
       END.
   END.
   {docform.i
      &cashord      = ""расходный""
      &nodef        = yes
      &docdate      = mdtDateDoc
      &docnum       = op.doc-num
      &payer        = mchPayer
      &receiver     = mchReceiver
      &recbank      = mchRecBank
      &dbacct       = AcctDb
      &cracct       = AcctCr
      &docsum       = mdeDocSum
      &doccur       = DocCur
      &symsumin     = mdeSymSumIn
      &symsumout    = mdeSymSumOut
      &natsum       = mdeNatSum
      &symcodin     = mchSymCodIn
      &symcodout    = mchSymCodOut
      &details      = mChDetails[1]
      &identcard    = mchIdentCard
      &documentid   = mDocCodName
      &documentnum  = mDocNum
      &documentwho  = mCustDocWho
      &documentdate = mDocDate
      &recinn       = mRecInn
      &recbankbik   = mchBankBIK
      &reckpp       = mRecKPP
      &recokato     = mRecOKATO
      &recacct      = mRecAcct
      &paybank      = mPayBank
      &paybankbik   = mPayBankBik
      &acctkomis    = AcctKomis
      &inc_part_fio = mchFIO
      &worker_buh   = mchWorkerBuh
      &worker_kont  = mchWorkerKont
      &worker_kas   = mchWorkerKas
   }
END.

&IF DEFINED(LAW_318p) <> 0 &THEN
   IF mchOrdTypeCr = "приходно─расходный" THEN DO:

      ASSIGN
         mchRecBank[1] = mDbBranchNam
         mPayBank[1]   = mCrBranchNam
      .

      mchPayer[1] = GetXAttrValueEx("op", STRING(op.op), "name-send", "").
      IF NOT {assigned mchPayer[1]} THEN DO:
         mchPayer[1] = GetXAttrValueEx("op", STRING(op.op), "ФИО", "").
         IF mchPayer[1] = "" THEN
            mchPayer[1] = IF op.name-ben = ? THEN "" ELSE op.name-ben.
         IF mchPayer[1] = "" THEN DO:
            {getcust2.i AcctCr mchPayer}
            mchPayer[1] = mchPayer[1] + mchPayer[2].
            IF CAN-DO(FGetSetting("КассСчИНН","",?), SUBSTR(acct.acct,1,5))
            OR GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "bank-inn", ?) = "Да" THEN DO:
               mINN        = IF FGetSetting("ИНН",?,?) <> "" THEN FGetSetting("ИНН",?,?) ELSE "000000000000".
               mchPayer[1] = (IF mINN <> "000000000000" THEN "ИНН " + mINN + " " ELSE "").
               mchPayer[1] = mchPayer[1] + mchBankName.
            END.
         END.
         /* пасп данные плательщика */
         IF fGetSetting ("ПлатДок", "ВыводПасп", "") EQ "Да" THEN
         DO:
            /* идент.типа документа */
            mchIdentCard = GetXAttrValueEx("op", STRING(op.op), "document-id", "").
            /* тип документа из классиф. КодДокум */
            mchIdentCard = IF mchIdentCard NE "" THEN GetCodeName("КодДокум", mchIdentCard) ELSE "".
            /* сливаем тип документа со значением ДР Докум (там обычно номер и кем выдан) */
            mchIdentCard = TRIM(mchIdentCard + " " +
                                GetXAttrValueEx("op", STRING(op.op), "Докум", "")).
            mchPayer[1] = mchPayer[1] + " " + mchIdentCard.
         END.
      END.

      IF INDEX(mchPayer[1],"ИНН  ") = 1 THEN
         mchPayer[1] = SUBSTR(mchPayer[1],6,LENGTH(mchPayer[1])).

      IF CAN-DO(mInnKas,SUBSTR(acct.acct,1,5)) AND INDEX(mchPayer[1],"ИНН ") = 1 THEN
         mchPayer[1] = TRIM(SUBSTRING(mchPayer[1],INDEX(mchPayer[1]," ",5))).

      /* получатель */
      mchFIO = GetXAttrValueEx("op", STRING(op.op), "ФИО", "").
      mchReceiver[1] = mchFIO.
      IF mchReceiver[1] = "" THEN
         mchReceiver[1] = IF op.name-ben = ? THEN "" ELSE op.name-ben.
      IF mchReceiver[1] = "" THEN DO:
         IF DbCustCat EQ "В" THEN DO:
            RUN GetCustIdCli IN h_acct (INPUT  AcctDb + "," + AcctDbCur,
                                        OUTPUT DbCustCat1,
                                        OUTPUT mIdCustAttr).
            RUN GetCustName IN h_base (DbCustCat1, mIdCustAttr, ?,
                                       OUTPUT mchReceiver[1],
                                       OUTPUT mchReceiver[2],
                                       INPUT-OUTPUT mINN
            ).
            mchReceiver[1] = mchReceiver[1] + " " + mchReceiver[2].
         END.
         IF TRIM(mchReceiver[1]) EQ "" THEN DO:
            {getcust2.i AcctDb mchReceiver}
            mchReceiver[1] = mchReceiver[1] + " " + mchReceiver[2].
         END.
      END.

      IF INDEX(mchReceiver[1],"ИНН  ") = 1 THEN
         mchReceiver[1] = SUBSTR(mchReceiver[1],6,LENGTH(mchReceiver[1])).

      IF CAN-DO(mInnKas,SUBSTR(AcctDb,1,5)) AND INDEX(mchReceiver[1],"ИНН ") = 1 THEN
         mchReceiver[1] = TRIM(SUBSTRING(mchReceiver[1],INDEX(mchReceiver[1]," ",5))).

      mVOKDprID    = GetXAttrValueEx("op", STRING(op.op), "dpr-id",""). /* код смены ВОК */

      mDocument-id = GetXAttrValueEx("op",STRING(Op.op),"document-id","").
      mDocNum      = GetXAttrValueEx("op",STRING(op.op), "Докум", "").
      RUN ParseDocum (INPUT-OUTPUT mDocument-id, INPUT-OUTPUT mDocNum, OUTPUT mDocCodName, OUTPUT mCustDocWho[1], OUTPUT mDocDate, OUTPUT mPassKP).
      mCustDocWho[1] = GetXAttrValueEx("op",STRING(Op.op),"cust-doc-who",mCustDocWho[1]).
      mDocDate       = GetXAttrValueEx("op",STRING(Op.op),"Document4Date_vid",mDocDate).
      IF mVOKDprID NE "" THEN /* документ не созданный ВОК */
      /* документ, созданный в ВОК */
      DO:
         mchIdentCard = (IF mDocCodName NE ? 
                            THEN mDocCodName 
                            ELSE mDocument-id) +
                        (IF mDocNum NE ""
                            THEN " № " + mDocNum
                            ELSE "") +
                        (IF mCustDocWho[1] NE ""
                            THEN "~nВыдан " + mCustDocWho[1]
                            ELSE "") +
                        IF mDocDate NE "" THEN (", дата выдачи:" + mDocDate) ELSE "".
      END. /* документ, созданный в ВОК */
      ELSE
      DO:
      /* пасп данные получателя */
      /* идент.типа документа */
         /* тип документа из классиф. КодДокум */
         /* сливаем тип документа со значением ДР Докум (там обычно номер и кем выдан) */
         mchIdentCard = TRIM(mDocCodName + " " + GetXAttrValueEx("op", STRING(op.op), "Докум", "")).
      END.
      IF NOT {assigned mchIdentCard} THEN DO:
         /* доп.рек. Докум не указан */
         mchIdentCard = GetXAttrValueEx("op", STRING(op.op), "Passport", "").
         IF {assigned mchIdentCard} THEN DO:
            /* доп.рек. Passport указан */
            ASSIGN
               mDocument-id = ""
               mDocNum      = mchIdentCard
            .
            RUN ParseDocum (INPUT-OUTPUT mDocument-id, INPUT-OUTPUT mDocNum, OUTPUT mDocCodName, OUTPUT mCustDocWho[1], OUTPUT mDocDate, OUTPUT mPassKP).
         END.
         ELSE DO:
            FIND FIRST acct WHERE acct.acct = AcctDb NO-LOCK NO-ERROR.
            IF AVAILABLE acct THEN DO:
               mPersonId = IF acct.cust-cat = "Ч" THEN /* клиента будем искать по cust-id счета */
                              acct.cust-id
                           ELSE IF acct.cust-cat = "В" AND
                                   GetXattrValueEx("acct", AcctDb + "," + AcctDbCur, "ТипКл", "") EQ "Ч"
                                THEN /* клиента будем искать по д.р. IDCust счета */
                                   INT64(GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "IDCust", ?))
                           ELSE
                              ?
               .
               IF mPersonId NE ? THEN DO:
                  FIND FIRST person WHERE person.person-id = mPersonId NO-LOCK NO-ERROR.
                  IF AVAILABLE person THEN DO:
                     mDocCodName    = GetCodeName("КодДокум", person.document-id).
                     mDocNum        = person.document.
                     FIND FIRST xcust-ident WHERE xcust-ident.cust-cat       = "Ч"
                                              AND xcust-ident.cust-id        = person.person-id
                                              AND xcust-ident.cust-code-type = person.document-id
                                              AND xcust-ident.cust-code      = person.document
                     NO-LOCK NO-ERROR.
                     IF AVAIL xcust-ident THEN DO:
                        IF {assigned xcust-ident.issue}
                        THEN mCustDocWho[1] = xcust-ident.issue.
                        ELSE mCustDocWho[1] = person.issue.
                        IF xcust-ident.open-date <> ?
                        THEN mDocDate = STRING(xcust-ident.open-date,"99/99/9999").
                        ELSE mDocDate = GetXattrValueEx("person", STRING(person.person-id), "Document4Date_Vid", "").
                        mPassKP = GetXattrValueEx("cust-ident",
                                                  GetSurrogateBuffer("cust-ident",(BUFFER xcust-ident:HANDLE)),
                                                  "Подразд",
                                                  "").
                     END.
                     ELSE DO:
                        mCustDocWho[1] = person.issue.
                        mDocDate       = GetXattrValueEx("person", STRING(person.person-id), "Document4Date_Vid", "").
                     END.
                     mchIdentCard = (IF mDocCodName NE ? THEN mDocCodName ELSE person.document-id)
                                  + " N " + mDocNum + ", выдан "
                                  + TRIM(person.issue + " " + mDocDate).
                     IF  {assigned mCustDocWho[1]}
                     AND {assigned mPassKP} THEN DO:
                        IF  NUM-ENTRIES(mCustDocWho[1]) >= 2
                        AND TRIM(ENTRY(NUM-ENTRIES(mCustDocWho[1]),mCustDocWho[1])) = TRIM(mPassKP)
                        THEN ASSIGN
                           ENTRY(NUM-ENTRIES(mCustDocWho[1]),mCustDocWho[1]) = ""
                           mCustDocWho[1] = TRIM(mCustDocWho[1],",")
                        .
                     END.
                  END.
               END.
            END.
         END.
      END.

      IF  {assigned mPassKP}
      AND INDEX(mCustDocWho[1]," к/п ") = 0
      THEN ASSIGN mCustDocWho[1] = mCustDocWho[1] + " к/п " + mPassKP.

      mchIdentCard = TRIM(mDocCodName + " N " + mDocNum + ", выдан " + TRIM(mCustDocWho[1] + " " + mDocDate)).

      DocCur = AcctCrCur.
      DO mInCount = 1 TO EXTENT(mdeSymSumIn):
         /* чистим массивы после печати прих. ордера */
         ASSIGN
            mdeSymSumIn[mInCount]  = 0
            mchSymCodIn[mInCount]  = ""
         .
      END.
      DO mInCount = 1 TO EXTENT(mdeSymSumOut):
         /* чистим массивы после печати расх. ордера */
         ASSIGN
            mdeSymSumOut[mInCount] = 0
            mchSymCodOut[mInCount] = ""
         .
      END.
      minCount = 0.
      _symbin1:
      FOR EACH op-entry OF op WHERE op-entry.acct-db = AcctDb NO-LOCK:
          TmpSymbol = IF mIsInOut THEN mchSymFromNP ELSE op-entry.symbol.
          IF TmpSymbol <> "" THEN DO:
              IF NOT GetTCodeFld("val",
                                 "КасСимволы",
                                 TmpSymbol,
                                 op-entry.op-date) BEGINS "прих"
              THEN
                  NEXT _symbin1.
              IF minCount = EXTENT(mdeSymSumIn) THEN DO:
                  MESSAGE
                      "Не могу обработать более"
                      STRING(EXTENT(mdeSymSumIn))
                      "символов"
                  VIEW-AS ALERT-BOX.
                  LEAVE.
              END.
              ASSIGN
                  minCount              = minCount + 1
                  mchSymCodIn[minCount] = TmpSymbol
                  mdeSymSumIn[minCount] = IF DocCur = "" THEN op-entry.amt-rub
                                                         ELSE op-entry.amt-cur
              .
          END.
      END.
      ASSIGN
         minCount  = 0
         mdeDocSum = 0
         mdeNatSum = 0
      .
      _symbout1:
      FOR EACH op-entry OF op WHERE op-entry.acct-cr = AcctCr NO-LOCK:
          IF DocCur = "" THEN
              mdeDocSum = mdeDocSum + op-entry.amt-rub.
          ELSE
              ASSIGN
                  mdeNatSum = mdeNatSum + op-entry.amt-rub
                  mdeDocSum = mdeDocSum + op-entry.amt-cur
              .
          TmpSymbol = IF mIsInOut THEN mchSymFromNP ELSE op-entry.symbol.
          IF TmpSymbol <> "" THEN DO:
              IF NOT GetTCodeFld("val",
                                 "КасСимволы",
                                 TmpSymbol,
                                 op-entry.op-date) BEGINS "расх"
              THEN
                  NEXT _symbout1.
              IF minCount = EXTENT(mdeSymSumOut) THEN DO:
                  MESSAGE
                      "Не могу обработать более"
                      STRING(EXTENT(mdeSymSumOut))
                      "символов"
                  VIEW-AS ALERT-BOX.
                  LEAVE.
              END.
              ASSIGN
                  minCount               = minCount + 1
                  mchSymCodOut[minCount] = TmpSymbol
                  mdeSymSumOut[minCount] = IF DocCur = "" THEN op-entry.amt-rub
                                                          ELSE op-entry.amt-cur
              .
          END.
      END.

      FIND FIRST xhistory WHERE xhistory.file-name = "op"
                            AND xhistory.field-ref = STRING(op.op)
                            AND xhistory.modify    = "C"
         NO-LOCK NO-ERROR.
      IF AVAIL xhistory THEN DO:
         FIND FIRST _user WHERE _user._userid = xhistory.user-id NO-LOCK NO-ERROR.
         IF AVAIL _user
            THEN mchWorkerBuh = _user._user-name.
      END.

      &IF DEFINED(ORACLE) <> 0 &THEN
      mRwd = ?.
      FOR EACH xhistory WHERE xhistory.file-name = "op"
                          AND xhistory.field-ref = STRING(op.op)
                          AND xhistory.modify    = "W"
      NO-LOCK:
         IF CAN-DO(xhistory.field-value,"op-status") = TRUE
         THEN mRwd = ROWID(xhistory).
      END.
      IF mRwd <> ? THEN FIND FIRST xhistory WHERE ROWID(xhistory) = mRwd NO-LOCK NO-ERROR.
      &ELSE
      FIND LAST xhistory WHERE xhistory.file-name = "op"
                           AND xhistory.field-ref = STRING(op.op)
                           AND xhistory.modify    = "W"
                           AND CAN-DO(xhistory.field-value,"op-status") = TRUE
         NO-LOCK NO-ERROR.
      &ENDIF
      IF AVAIL xhistory THEN DO:
         FIND FIRST _user WHERE _user._userid = xhistory.user-id NO-LOCK NO-ERROR.
         IF AVAIL _user
            THEN ASSIGN
               mchWorkerKont = _user._user-name
               mchWorkerKas  = _user._user-name
            .
      END.
      
      {docform.i
         &cashord      = ""приходно─расходный""
         &nodef        = yes
         &docnum       = op.doc-num
         &docdate      = mdtDateDoc
         &payer        = mchPayer
         &receiver     = mchReceiver
         &recbank      = mchRecBank
         &dbacct       = AcctDb
         &cracct       = AcctCr
         &docsum       = mdeDocSum
         &doccur       = DocCur
         &symsumin     = mdeSymSumIn
         &symsumout    = mdeSymSumOut
         &natsum       = mdeNatSum
         &symcodin     = mchSymCodIn
         &symcodout    = mchSymCodOut
         &details      = op.details
         &identcard    = mchIdentCard
         &documentid   = mDocCodName
         &documentnum  = mDocNum
         &documentwho  = mCustDocWho
         &documentdate = mDocDate
         &recinn       = mRecInn
         &recbankbik   = mchBankBIK
         &reckpp       = mRecKPP
         &recokato     = mRecOKATO
         &recacct      = mRecAcct
         &paybank      = mPayBank
         &paybankbik   = mPayBankBik
         &acctkomis    = AcctKomis
         &inc_part_fio = mchFIO
         &worker_buh   = mchWorkerBuh
         &worker_kont  = mchWorkerKont
         &worker_kas   = mchWorkerKas
      }
   END.
&ENDIF
{endout3.i &nofooter=yes}

PROCEDURE ParseDocum:
   DEFINE INPUT-OUTPUT PARAMETER ioDocument-id AS CHAR NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER ioDocNum      AS CHAR NO-UNDO.
   DEFINE       OUTPUT PARAMETER oDocCodName   AS CHAR NO-UNDO.
   DEFINE       OUTPUT PARAMETER oCustDocWho   AS CHAR NO-UNDO.
   DEFINE       OUTPUT PARAMETER oDocDate      AS CHAR NO-UNDO.
   DEFINE       OUTPUT PARAMETER oPaspKP       AS CHAR NO-UNDO.
   DEFINE BUFFER xxcode FOR code.

   ioDocNum = TRIM(ioDocNum).
   IF  NOT {assigned ioDocument-id}
   AND     {assigned ioDocNum} THEN DO:
      IF ioDocNum BEGINS "Паспорт серии" THEN _dr_passport: DO:
         ioDocNum = TRIM(SUBSTR(ioDocNum,14)).
         /* Возможно Паспорт гражданина РФ */
         INT64(ENTRY(1,ioDocNum," ")) NO-ERROR.
         IF NOT ERROR-STATUS:ERROR THEN DO:
            FOR EACH xxcode WHERE xxcode.class = "КодДокум"
                              AND xxcode.name  MATCHES "*паспорт* РФ*"
            NO-LOCK BY (xxcode.code = "Паспорт") DESCENDING BY xxcode.name MATCHES "Паспорт*гражданина*" DESCENDING:
               ioDocument-id = xxcode.code.
               LEAVE _dr_passport.
            END.
         END.
         /* Возможно Паспорт гражданина СССР */
         IF ioDocNum BEGINS "I"
         OR ioDocNum BEGINS "V"
         OR ioDocNum BEGINS "X"
         OR ioDocNum BEGINS "L"
         OR ioDocNum BEGINS "C"
         OR ioDocNum BEGINS "D"
         OR ioDocNum BEGINS "M" THEN DO:
            FOR EACH xxcode WHERE xxcode.class = "КодДокум"
                              AND xxcode.name  MATCHES "*паспорт*СССР*"
            NO-LOCK BY (xxcode.code = "Документ") DESCENDING BY xxcode.name MATCHES "Паспорт*гражданина*" DESCENDING:
               ioDocument-id = xxcode.code.
               LEAVE _dr_passport.
            END.
         END.
         /* Значит какой-то любой паспорт */
         FOR EACH xxcode WHERE xxcode.class = "КодДокум"
                           AND xxcode.name  MATCHES "*паспорт*"
         NO-LOCK BY (xxcode.code = "Паспорт") DESCENDING BY (xxcode.code = "Документ") DESCENDING BY xxcode.name MATCHES "Паспорт*гражданина*" DESCENDING:
            ioDocument-id = xxcode.code.
            LEAVE _dr_passport.
         END.
      END.
      ELSE DO:
         _try_assign:
         FOR EACH xxcode WHERE xxcode.class = "КодДокум"
                           AND ioDocNum BEGINS xxcode.name
         NO-LOCK BY LENGTH(xxcode.name) DESCENDING:
            ASSIGN
               ioDocument-id = xxcode.code
               ioDocNum      = TRIM(SUBSTR(ioDocNum,LENGTH(xxcode.name) + 1))
            .
            LEAVE _try_assign.
         END.
      END.
   END.
   oDocCodName = IF   {assigned ioDocument-id}
                 THEN GetCodeName("КодДокум", ioDocument-id)
                 ELSE ""
   .
   ASSIGN
      oDocDate    = ""
      oCustDocWho = ""
   .
   IF INDEX(ioDocNum,"выдан ") > 0 THEN DO:
      ASSIGN
         oCustDocWho = TRIM(SUBSTR(ioDocNum,INDEX(ioDocNum,"выдан ") + 6))
         ioDocNum    = TRIM(SUBSTR(ioDocNum,1,INDEX(ioDocNum,"выдан ") - 2))
      .
      /* "... выдан ОВД Городское 01.01.2001 к/п 001-002 */
      /* "... выдан 01.01.2001 ОВД Городское к/п 001-002 */
      /* "... выдан ОВД Городское к/п 001-002 01.01.2001 */
      IF INDEX(oCustDocWho,"к/п ") > 0 THEN ASSIGN
         oPaspKP     = TRIM(SUBSTR(oCustDocWho,INDEX(oCustDocWho,"к/п ") + 4))
         oCustDocWho = TRIM(SUBSTR(oCustDocWho,1,INDEX(oCustDocWho,"к/п ") - 2))
      .
      /* "... выдан ОВД Городское 01.01.2001 */
      oDocDate = STRING(DATE(ENTRY(NUM-ENTRIES(oCustDocWho," "),oCustDocWho," "))) NO-ERROR.
      IF  oDocDate <> ?
      AND NOT ERROR-STATUS:ERROR THEN ASSIGN
         oDocDate = ENTRY(NUM-ENTRIES(oCustDocWho," "),oCustDocWho," ")
         ENTRY(NUM-ENTRIES(oCustDocWho," "),oCustDocWho," ") = ""
         oCustDocWho = TRIM(oCustDocWho)
      .
      /* "... выдан 01.01.2001 ОВД Городское */
      ELSE DO:
         oDocDate = STRING(DATE(ENTRY(1,oCustDocWho," "))) NO-ERROR.
         IF  oDocDate <> ?
         AND NOT ERROR-STATUS:ERROR THEN ASSIGN
            oDocDate = ENTRY(1,oCustDocWho," ")
            ENTRY(1,oCustDocWho," ") = ""
            oCustDocWho = TRIM(oCustDocWho)
         .
         /* "... 001-002 01.01.2001 */
         ELSE IF  {assigned oPaspKP}
              AND NUM-ENTRIES(oPaspKP," ") >= 2 THEN DO:
            oDocDate = STRING(DATE(ENTRY(NUM-ENTRIES(oPaspKP," "),oPaspKP," "))) NO-ERROR.
            IF  oDocDate <> ?
            AND NOT ERROR-STATUS:ERROR THEN ASSIGN
               oDocDate = ENTRY(NUM-ENTRIES(oPaspKP," "),oPaspKP," ")
               ENTRY(NUM-ENTRIES(oPaspKP," "),oPaspKP," ") = ""
               oPaspKP = TRIM(oPaspKP)
            .
         END.
      END.
   END.
   RETURN.
END PROCEDURE.

{intrface.del}
