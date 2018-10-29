{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1997 ТОО "Банковские информационные системы"
     Filename: oc-nps.p
      Comment: Процедура печати справки об осуществлении операций
               с наличной валютой и чеками.
               (Открытая система печати)
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: 
      Used by:
      Created: 17/06/2004 kraw (0032005)
     Modified: 13.09.2004 17:36 ligp     31278: Доработка в модуле ВОК в свете Инструкции 113-И
                                         (замена справки)
     Modified:      
*/
{globals.i}                                 /* глобальные переменные         */
{get-bankname.i}

DEFINE INPUT PARAMETER iRID AS RECID NO-UNDO.

DEFINE VARIABLE mOpCurrCode AS CHARACTER NO-UNDO.
DEFINE VARIABLE mContrAct   AS CHARACTER NO-UNDO.

DEFINE VARIABLE mFIO        AS CHARACTER NO-UNDO.
DEFINE VARIABLE mDocum      AS CHARACTER NO-UNDO.
DEFINE VARIABLE mDocId      AS CHARACTER NO-UNDO.
DEFINE VARIABLE mCodNVal    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mCurrCode   AS CHARACTER INITIAL "---" NO-UNDO.
DEFINE VARIABLE mAmt        AS CHARACTER INITIAL "---" NO-UNDO.
DEFINE VARIABLE mCurrCodeC  AS CHARACTER INITIAL "---" NO-UNDO.
DEFINE VARIABLE mAmtC       AS CHARACTER INITIAL "---" NO-UNDO.
DEFINE VARIABLE mCurrCode1  AS CHARACTER INITIAL "---" NO-UNDO.
DEFINE VARIABLE mAmt1       AS CHARACTER INITIAL "---" NO-UNDO.
DEFINE VARIABLE mCurrCodeC1 AS CHARACTER INITIAL "---" NO-UNDO.
DEFINE VARIABLE mAmtC1      AS CHARACTER INITIAL "---" NO-UNDO.
DEFINE VARIABLE mRid        AS RECID                   NO-UNDO.
DEFINE VARIABLE mIsp        AS LOGICAL   INITIAL TRUE  NO-UNDO.

{prn-doc.def &with_proc=YES}
{intrface.get xclass}

   mRid = INTEGER(GetSysConf("user-proc-id")).

   FIND FIRST user-proc WHERE RECID(user-proc) EQ mRid
      NO-LOCK NO-ERROR.
   IF AVAILABLE user-proc THEN
      mIsp = GetXAttrValueEx("user-proc",
                             STRING(user-proc.public-number),
                             "Подписи",
                             "Инс") BEGINS "Исп".
   ELSE
   DO:
      MESSAGE "Неправильно запущена процедура"
         VIEW-AS ALERT-BOX ERROR. 
      RETURN.
   END.

FIND FIRST op WHERE RECID(op) EQ iRID NO-LOCK NO-ERROR.

IF NOT AVAILABLE op THEN 
DO:
   MESSAGE "Документ не найден"
   VIEW-AS ALERT-BOX ERROR. 
END.

mCodNVal = FGetSetting("КодНацВал",?,"810").

RUN Insert_TTName("Bank",    cBankName).
RUN Insert_TTName("Regn",    FGetSetting("REGN",     ?, "*не установлен*")).
RUN Insert_TTName("Address", FGetSetting("Адрес_пч", ?, "*не установлен*")).
RUN Insert_TTName("op-date", STRING(op.op-date)).

FIND LAST history WHERE history.file-name EQ "op"
                    AND history.field-ref EQ STRING(op.op)
                    AND history.modify EQ "C"
   NO-LOCK NO-ERROR.

IF AVAILABLE history THEN
   RUN Insert_TTName("op-time", STRING(history.modif-time,"HH:MM:SS")).

RUN Insert_TTName("doc-num", TRIM(op.doc-num)).

mOpCurrCode = GetXAttrValueEx("op", STRING(op.op), "ВидОпНалВ", "").

RUN Insert_TTName("OpCurrCode", mOpCurrCode).
RUN Insert_TTName("OpCurrName", GetCodeName("ВидОпНалВ", mOpCurrCode)).

ASSIGN
   mFIO   = GetXAttrValueEx("op", STRING(op.op), "ФИО", "")
   mDocum = GetXAttrValueEx("op", STRING(op.op), "Докум", "")
   mDocId = GetXAttrValueEx("op", STRING(op.op), "document-id", "")
.
IF    mDocum EQ ""
   OR mDocId EQ ""
   OR mFIO   EQ "" THEN
DO:
   FOR EACH op-entry OF op NO-LOCK:
      FIND FIRST acct WHERE acct.acct EQ op-entry.acct-db
                        AND acct.cust-cat EQ "Ч" NO-LOCK NO-ERROR.
      IF AVAIL acct THEN
         FIND FIRST person WHERE person.person-id EQ acct.cust-id NO-LOCK NO-ERROR.
      IF AVAIL person THEN LEAVE.
      FIND FIRST acct WHERE acct.acct EQ op-entry.acct-cr
                        AND acct.cust-cat EQ "Ч" NO-LOCK NO-ERROR.
      IF AVAIL acct THEN
         FIND FIRST person WHERE person.person-id EQ acct.cust-id NO-LOCK NO-ERROR.
      IF AVAIL person THEN LEAVE.
   END.
   IF AVAIL person THEN
      ASSIGN
         mDocum = IF mDocum EQ "" THEN person.document  ELSE mDocum
         mDocId = IF mDocId EQ "" THEN person.document-id ELSE mDocId
         mFIO   = IF mFIO   EQ "" THEN person.name-last + " " + person.first-names ELSE mFIO
      .
END.

FIND FIRST code WHERE code.class EQ "ВидДок"
                  AND code.code  EQ mDocId NO-LOCK NO-ERROR.
IF AVAIL code THEN
   mDocId = code.name.

mDocum = mDocId + " " + mDocum.
RUN Insert_TTName("FIO",    mFIO).
RUN Insert_TTName("docum",  mDocum).
RUN Insert_TTName("sprate", GetXAttrValueEx("op", STRING(op.op), "sprate", "")).

mContrAct = FGetSetting("НазнСчКас", ?, "Касса").

FIND FIRST op-entry OF op WHERE NOT (op-entry.acct-db BEGINS "20203") NO-LOCK NO-ERROR.
IF AVAIL op-entry THEN DO:
   FIND FIRST acct WHERE acct.acct     EQ op-entry.acct-db
                     AND CAN-DO(mContrAct, acct.contract) NO-LOCK NO-ERROR.
   IF AVAIL acct THEN DO:     
      ASSIGN
        mCurrCode = acct.currency
        mAmt      = STRING((IF acct.currency EQ ""
                         THEN op-entry.amt-rub 
                         ELSE op-entry.amt-cur), ">>>,>>>,>>9.99") 
      .

      FIND FIRST currency WHERE currency.currency = mCurrCode NO-LOCK NO-ERROR.

      IF AVAILABLE currency THEN
         RUN Insert_TTName("CurrName", currency.name-currenc).
      IF acct.currency EQ "" THEN
         mCurrCode = mCodNVal.
   END.	 
END.

FIND FIRST op-entry OF op WHERE op-entry.acct-db BEGINS "20203" NO-LOCK NO-ERROR.

IF AVAILABLE op-entry THEN
DO:
   FIND FIRST acct WHERE acct.acct EQ op-entry.acct-db NO-LOCK.
   ASSIGN
      mCurrCodeC = acct.currency
      mAmtC      = STRING((IF acct.currency EQ ""
                          THEN op-entry.amt-rub 
                          ELSE op-entry.amt-cur), ">>>,>>>,>>9.99") 
                 + "   " + STRING(op-entry.qty)
   .

   FIND FIRST currency WHERE currency.currency = mCurrCodeC NO-LOCK NO-ERROR.

   IF AVAILABLE currency THEN
      RUN Insert_TTName("CurrNameC", currency.name-currenc).
   IF acct.currency EQ "" THEN
      mCurrCodeC = mCodNVal.
END.

FIND FIRST op-entry OF op WHERE NOT (op-entry.acct-cr BEGINS "20203") NO-LOCK NO-ERROR.
IF AVAIL op-entry THEN DO:
   FIND FIRST acct WHERE acct.acct     EQ op-entry.acct-cr
                     AND CAN-DO(mContrAct, acct.contract) NO-LOCK NO-ERROR.

   IF AVAIL acct THEN DO:
      ASSIGN
        mCurrCode1 = acct.currency
        mAmt1      = STRING((IF acct.currency EQ ""
                          THEN op-entry.amt-rub 
                          ELSE op-entry.amt-cur), ">>>,>>>,>>9.99")
      .

      FIND FIRST currency WHERE currency.currency = mCurrCode1 NO-LOCK NO-ERROR.

      IF AVAILABLE currency THEN
         RUN Insert_TTName("CurrName1", currency.name-currenc).
      IF acct.currency EQ "" THEN
         mCurrCode1 = mCodNVal.
   END.	 
END.
FIND FIRST op-entry OF op WHERE op-entry.acct-cr BEGINS "20203" NO-LOCK NO-ERROR.

IF AVAILABLE op-entry THEN
DO:
   FIND FIRST acct WHERE acct.acct EQ op-entry.acct-cr NO-LOCK.
   ASSIGN
      mCurrCodeC1 = acct.currency
      mAmtC1      = STRING((IF acct.currency EQ ""
                          THEN op-entry.amt-rub 
                          ELSE op-entry.amt-cur), ">>>,>>>,>>9.99")
                  + "   " + STRING(op-entry.qty)
   .

   FIND FIRST currency WHERE currency.currency = mCurrCodeC1 NO-LOCK NO-ERROR.

   IF AVAILABLE currency THEN
      RUN Insert_TTName("CurrNameC1", currency.name-currenc).
   IF acct.currency EQ "" THEN
      mCurrCodeC1 = mCodNVal.
END.

RUN Insert_TTName("CurrCode",   mCurrCode).
RUN Insert_TTName("Amt",        mAmt).
RUN Insert_TTName("CurrCodeC",  mCurrCodeC).
RUN Insert_TTName("AmtC",       mAmtC).
RUN Insert_TTName("CurrCode1",  mCurrCode1).
RUN Insert_TTName("Amt1",       mAmt1).
RUN Insert_TTName("CurrCodeC1", mCurrCodeC1).
RUN Insert_TTName("AmtC1",       mAmtC1).

IF mIsp THEN
   FIND FIRST _user WHERE _user._userid EQ op.user-id NO-LOCK NO-ERROR.
ELSE
   FIND FIRST _user WHERE _user._userid EQ op.user-inspector NO-LOCK NO-ERROR.
IF AVAILABLE _user THEN
DO:
   RUN Insert_TTName("post", "Кассир").
   RUN Insert_TTName("user", _user._user-name).
   RUN Insert_TTName("empty", FILL(" ",LENGTH("Кассир " + _user._user-name))).
END.
   


RUN printvd.p("СООНВЧ",
               INPUT TABLE ttnames
             ).

