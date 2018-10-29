{pirsavelog.p}

/*
                Банковская интегрированная система БИСквит
    Copyright:  (C) 1992-2002 ТОО "Банковские информационные системы"
     Filename:  FORM_PC.P
      Comment:  Использование из модуля Экономического Анализа:
                Расчет для анкет физ. и юр. лиц.
      Created:  09/04/02 YUSS
      Modify:   31/05/02 YUSS Расчет для банк-клиентов.
      Modified: 15/10/2002 kraw (0008664) - переведено на динамические фильтры
      Modified: 14/03/2005 kraw (0042829) - Снято ограничение в 700 зн. на "УчредОрг"
*/
Form "~n@(#) FORM_PC.P YUSS 09/04/02"
with frame sccs-id stream-io width 250.

DEF INPUT PARAM cInParams AS CHAR NO-UNDO.

{globals.i}
{sh-defs.i}
{intrface.get comm}
{intrface.get acct}
{intrface.get xclass}
{intrface.get strng}
{intrface.get ps}
{intrface.get re}
{intrface.get tmess}
{intrface.get cust}

{intrface.get flt}      /* Работа с фильтром объектов */
{parsin.def}
{tmprecid.def}        /** Используем информацию из броузера */

def var in-acct-cat like acct.acct-cat no-undo.
def var in-bal-acct like acct.bal-acct init ? no-undo.
def var in-currency like acct.currency init ? no-undo.
def var in-cust-cat like acct.cust-cat init ? no-undo.
def var in-cust-id  like acct.cust-id  init ? no-undo.
def var n-oqry      as int initial 0 no-undo.
def var n-qry       as int initial 0 no-undo.
DEFINE VAR i         AS INTEGER   NO-UNDO.
DEFINE VAR mFiltAcct AS CHARACTER NO-UNDO.
DEFINE BUFFER b-acct FOR acct.

def var mItem       as int initial 0 no-undo.
def var mStrTMP1    as char no-undo.

def var cMasterId as character init "" no-undo.
def var cSlaveId  as character init "" no-undo.
def var nCntCol   as integer init 0 no-undo.
def var nFirstPrtCol as integer init 0 no-undo.
def var nColWigth as integer EXTENT 5 init 0 no-undo.
def var nCntParam as integer init 0 no-undo.
def var cTmpRow1  as character init "" no-undo.
def var cTabl1    as character init "" no-undo.
def var cField    as character init "" no-undo.
def var nInPar    as integer init 0 no-undo.
def var nInParams as integer init 0 no-undo.
def var dDateIn   as date format "99/99/9999" no-undo.
def var cSrokSave as character init "" no-undo.
def var cUserFlt  as character init "" no-undo.
def var cNameFlt  as character init "" no-undo.
def var cTypeCli  as character init "" no-undo.
def var nTotalRecords as integer init 0 no-undo.
def var dBegDate as date no-undo.
def var dEndDate as date no-undo.
DEF VAR c1Char     AS CHARACTER NO-UNDO INIT "│".
DEF VAR vFormL1Log AS LOGICAL NO-UNDO.
DEF VAR vIndxInt   AS INTEGER INIT 0 NO-UNDO.
DEF VAR vRepWidthInt AS INTEGER NO-UNDO.
DEF VAR cVerBankChar  as character init "" no-undo. /* Версия анкеты для банка : */
                                                    /*  ""  - Стандарт           */
                                                    /*  "1" - RSHB               */
DEF VAR cParamChar as character no-undo.

def var j         as integer init 0 no-undo.
def var nKv       as integer init 0 no-undo.



DEFINE VARIABLE mClientType   AS CHARACTER INITIAL "Клиент" NO-UNDO.

DEFINE VARIABLE mIsPrintDummy AS LOGICAL   INITIAL NO  NO-UNDO.
DEFINE VARIABLE mDateRenewal  AS DATE                  NO-UNDO.
DEFINE VARIABLE mParRenewal   AS INTEGER               NO-UNDO.
DEFINE VARIABLE mSigner       AS CHARACTER             NO-UNDO.
DEFINE VARIABLE mParSigner    AS CHARACTER             NO-UNDO.
DEFINE VARIABLE mTabl         AS CHARACTER             NO-UNDO.
DEFINE VARIABLE mDateIn       AS CHARACTER             NO-UNDO.
DEFINE VARIABLE mSVL          AS CHARACTER             NO-UNDO.
DEFINE VARIABLE mStrTMP       AS CHARACTER             NO-UNDO.

DEFINE VARIABLE mIsDocumFromClass AS LOGICAL NO-UNDO.

DEFINE VARIABLE mFullName AS CHARACTER NO-UNDO.
DEFINE VARIABLE mStatus   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mVD       AS CHARACTER NO-UNDO.
DEFINE VARIABLE mOKVEDS   AS CHARACTER NO-UNDO.
DEFINE VARIABLE mI        AS INTEGER   NO-UNDO.

def buffer b-cust-corp for cust-corp.
def buffer b-person    for person.


   {tmprecid.def
      &NGSH = "LOCAL"   
      &PREF = "acct_"
   }          /* Таблица для выбора счетов. */
   {tmprecid.def
      &NGSH = "LOCAL"   
      &PREF = "cust_"
   }          /* Таблица для выбора счетов. */
   RUN rid-rest.p (OUTPUT TABLE cust_tmprecid).


/*** кол-во колонок в таблице и их ширина (без учета границ) ***/
/*** Max = 5 ***/
/*** form_tabl ("41,35") ***/
PROCEDURE form_tabl:
   DEFINE INPUT PARAMETER  cValue   as CHARACTER.
   nColWigth = 0.
   do i = 1 to 5:
      run DeleteOldDataProtocol in h_base (input "Colon" + string(i)).
   end.
   if cValue > "" then do:
      nCntCol = NUM-ENTRIES(cValue).
      do i = 1 to nCntCol:
         nColWigth [i] = integer(ENTRY(i,cValue)).
      end.
   end.
END PROCEDURE.

/*** значения осн. поля таблицы ***/
/*** form_main (2,0,string(cust-corp.name-corp)) ***/
PROCEDURE form_main:
   DEFINE INPUT PARAMETER  nCol     as INTEGER no-undo.
   DEFINE INPUT PARAMETER  nNextCol as INTEGER no-undo.
   DEFINE INPUT PARAMETER  cValue   as CHARACTER no-undo.

   if nFirstPrtCol = 0 then nFirstPrtCol = nCol.

   if cValue > "" or nNextCol = 9 then do:
      if cValue = ? then cValue = "?".
      run form_word (input nCol,
                     input "",
                     input cValue).
   end.

   if nNextCol = 9 then run form_put (false,c1Char).

END PROCEDURE.

FUNCTION fMaxLen RETURNS CHARACTER
   (INPUT  iCntInt  as INTEGER,
    INPUT  iTxtChar as CHARACTER
   ).
   RETURN FILL("x",MAX(iCntInt,LENGTH(iTxtChar))).

END FUNCTION.

/*** значения доп. поля таблицы ***/
/*** form_dopf (2,0,"cust-corp","e-mail") ***/
FUNCTION form_dopf RETURNS CHARACTER
   (INPUT  cTabl    as CHARACTER,
    INPUT  cField   as CHARACTER,
    INPUT  iMaxLen  as INTEGER
   ).

   def var cValue as character init "" no-undo.

   cValue = string(GetXattrValue (cTabl,if cSlaveId = "" then cMasterId else cSlaveId,cField)).

   if cValue = ? then cValue = "?".
   IF iMaxLen NE ? THEN
      cValue = STRING(cValue,fMaxLen(iMaxLen,cValue)).

   RETURN cValue.
END FUNCTION.

/*** значения доп. поля таблицы ***/
/*** form_dop (2,0,"cust-corp","e-mail") ***/
PROCEDURE form_dop:
   DEFINE INPUT PARAMETER  nCol     as INTEGER no-undo.
   DEFINE INPUT PARAMETER  nNextCol as INTEGER no-undo.
   DEFINE INPUT PARAMETER  cTabl    as CHARACTER no-undo.
   DEFINE INPUT PARAMETER  cField   as CHARACTER no-undo.

   def var cValue as character init "" no-undo.

   if nFirstPrtCol = 0 then nFirstPrtCol = nCol.

   cValue = string(GetXattrValue (cTabl,if cSlaveId = "" then cMasterId else cSlaveId,cField)).
   if cField = "okpo" and not (cValue = ?) then
      cValue = "ОКПО " + cValue.

   if cValue > "" or nNextCol = 9 then do:
      if cValue = ? then cValue = "?".
      run form_word (input nCol,
                     input "|",
                     input cValue).
   end.

   if nNextCol = 9 then run form_put (false,c1Char).

END PROCEDURE.

FUNCTION form_nsif RETURNS CHARACTER
   (INPUT  cTabl    as CHARACTER,
    INPUT  cField   as CHARACTER,
    INPUT  cNsi     as CHARACTER,
    INPUT  iMaxLen  as INTEGER
   ).

   def var cValue as character init "" no-undo.

   /* значение поля */
   cValue = string(GetXattrValue (cTabl,if cSlaveId = "" then cMasterId else cSlaveId,cField)).

   /* значение справочника */
   cValue = string(GetCodeName (cNsi,cValue)).

   if cValue = ? then cValue = "?".
   IF iMaxLen NE ? THEN
      cValue = STRING(cValue,fMaxLen(iMaxLen,cValue)).

   RETURN cValue.
END FUNCTION.

/*** значения доп. поля таблицы по справочнику ***/
/*** form_nsi (2,0,"banks","bank-stat","КодПредп") ***/
PROCEDURE form_nsi:
   DEFINE INPUT PARAMETER  nCol     as INTEGER no-undo.
   DEFINE INPUT PARAMETER  nNextCol as INTEGER no-undo.
   DEFINE INPUT PARAMETER  cTabl    as CHARACTER no-undo.
   DEFINE INPUT PARAMETER  cField   as CHARACTER no-undo.
   DEFINE INPUT PARAMETER  cNsi     as CHARACTER no-undo.

   def var cValue as character init "" no-undo.

   if nFirstPrtCol = 0 then nFirstPrtCol = nCol.

   /* значение поля */
   cValue = string(GetXattrValue (cTabl,if cSlaveId = "" then cMasterId else cSlaveId,cField)).

   /* значение справочника */
   cValue = string(GetCodeName (cNsi,cValue)).

   if cValue > "" or nNextCol = 9 then do:
      if cValue = ? then cValue = "?".
      run form_word (input nCol,
                     input "",
                     input cValue).
   end.

   if nNextCol = 9 then run form_put (false,c1Char).

END PROCEDURE.

/*** Идентификаторы банка - клиента ***/
/*** form_bankf ('REGN') ***/
FUNCTION form_bankf RETURNS CHARACTER
   (INPUT  cField   as CHARACTER,
    INPUT  iMaxLen  as INTEGER
   ).

   def var cValue as character init "" no-undo.

   find first banks-code
        where banks-code.bank-id = banks.bank-id
          and banks-code.bank-code-type = cField no-lock no-error.

   cValue = if not avail banks-code
               then "?"
               else banks-code.bank-code.

   if cValue = ? then cValue = "?".
   IF iMaxLen NE ? THEN
      cValue = STRING(cValue,fMaxLen(iMaxLen,cValue)).

   RETURN cValue.
END FUNCTION.

/*** Идентификаторы банка - клиента ***/
/*** form_bank (2,0,'REGN') ***/
PROCEDURE form_bank:
   DEFINE INPUT PARAMETER  nCol     as INTEGER no-undo.
   DEFINE INPUT PARAMETER  nNextCol as INTEGER no-undo.
   DEFINE INPUT PARAMETER  cField   as CHARACTER no-undo.

   def var cValue as character init "" no-undo.

   if nFirstPrtCol = 0 then nFirstPrtCol = nCol.

   IF cField NE "ИНН" THEN
   DO:
      find first banks-code
           where banks-code.bank-id = banks.bank-id
             and banks-code.bank-code-type = cField no-lock no-error.

      cValue = if not avail banks-code
                  then "?"
                  else banks-code.bank-code.
   END.
   ELSE
      cValue = GetBankInn ("bank-id", STRING(banks.bank-id)).

   if cValue > "" or nNextCol = 9 then do:
      if cValue = ? then cValue = "?".
      run form_word (input nCol,
                     input "",
                     input cValue).
   end.

   if nNextCol = 9 then run form_put (false,c1Char).

END PROCEDURE.


/*** значения текста таблицы ***/
/*** form_text (1,1,"текст") ***/
PROCEDURE form_text:
   DEFINE INPUT PARAMETER  nCol  as INTEGER no-undo.
   DEFINE INPUT PARAMETER  nNextCol as INTEGER no-undo.
   DEFINE INPUT PARAMETER  cValue   as CHARACTER no-undo.

   if nFirstPrtCol = 0 then nFirstPrtCol = nCol.
   /*** символ "|" в тексте означает принудительный преревод на след.строку ***/
   run form_word (input nCol,
                  input "|",
                  input cValue).
   if nNextCol = 9 then run form_put (false,c1Char).

END PROCEDURE.

/*** Обработка счетов ***/
/*** form_acct (1,"СотрУтвСч") ***/
PROCEDURE form_acct:
   DEFINE INPUT PARAMETER  nCol     as INTEGER no-undo.
   DEFINE INPUT PARAMETER  cField   as CHARACTER no-undo.

   def var cValue1  as character init "" no-undo.
   def var cValue2  as character init "" no-undo.
   def var cUserId  as character init "" no-undo.
   def var cUserCat as character init "" no-undo.
   def var cMinDateOpen as character init "" no-undo.
   def var nCntAcct as integer init 0 no-undo.
   def var nCntParm as integer init 0 no-undo.
   def var lDoverOpenAcct as logical no-undo.
   def var nSunDtCt as decimal init 0 no-undo.
   def var nCntDtCt as integer init 0 no-undo.

   def var cField2  as character no-undo.
   def var cField3  as character no-undo.

   DEFINE VARIABLE vAcctNumber AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vAcctAcct   AS CHARACTER NO-UNDO.

   IF NUM-ENTRIES(cField) > 1 THEN
      cField2 = ENTRY(2,cField).

   IF NUM-ENTRIES(cField) > 2 THEN
      cField3 = ENTRY(3,cField).

   cField = ENTRY(1,cField).

   /* Минимальная дата открытия счетов */
   if cField = "MinDateOpen" then do:
      find first b-acct
         where b-acct.cust-cat = in-cust-cat
           and b-acct.cust-id  = in-cust-id
         USE-INDEX open-date no-lock no-error .

      if avail b-acct
         then cMinDateOpen = string(b-acct.open-date,"99/99/9999").

      run form_word (input nCol,input "",input cMinDateOpen).
      nFirstPrtCol = nCol.
      run form_put (false,c1Char).
   end.
   else do:
      FOR EACH acct_tmprecid,
         FIRST b-acct WHERE RECID(b-acct) = acct_tmprecid.id 
         NO-LOCK BY b-acct.acct-cat
                 BY b-acct.bal-acct 
                 BY b-acct.acct 
                 BY b-acct.currency:
         assign
            nCntAcct = nCntAcct + 1
            cValue1 = ""
            cValue2 = ""
            cUserId = ""
            cUserCat = ""
            nFirstPrtCol = (if nCntAcct = 1 then nCol else 1)
            lDoverOpenAcct = false.


         IF cField = "ДоверОткрСч" then do:
            cValue1 = b-acct.acct.
            vAcctNumber = b-acct.number.
            vAcctAcct   = b-acct.acct.
            cValue2 = GetXattrValue ("acct",b-acct.acct + "," + b-acct.currency,"ДоверОткрСч").
            nCntParm = NUM-ENTRIES(cValue2).

            if nCntParm > 0 then do:
               do i = 1 to nCntParm:
                  if i = 1 then do:
                     cUserCat = string(ENTRY(i,cValue2)).
                  end.
                  if i = 2 then do:
                     cUserId = string(ENTRY(i,cValue2)).
                  end.
               end.
            end.

            if cUserCat = "Ю" AND
               (cField2  = "" OR
                cField2  = "Ю")  then do:
               find first b-cust-corp where b-cust-corp.cust-id = integer(cUserId)
               no-lock no-error.
               if avail b-cust-corp then do:
                  cSlaveId = cUserId.
                  lDoverOpenAcct = true.
                  IF NOT vFormL1Log THEN
                  DO:
                     run form_main (nCol + 1,0,string(b-cust-corp.name-corp)).
                     run form_dop  (nCol + 1,0,"cust-corp","RegNum").
                     run form_dop  (nCol + 1,0,"cust-corp","RegPlace").
                     run form_dop  (nCol + 1,0,"cust-corp","Country-id2").
                     run form_main (nCol + 1,0,string(b-cust-corp.Addr-of-low[1] + " " + b-cust-corp.Addr-of-low[2] )).
                     run form_main (nCol + 1,0,string(b-cust-corp.Country-ID)).
                     run form_dop  (nCol + 1,0,"cust-corp","АдресП").
                     run form_main (nCol + 1,0,string(b-cust-corp.okonx)).
                     run form_main (nCol + 1,0,string(b-cust-corp.okpo)).
                  END.
                  ELSE
                  DO:
                     put unformatted SKIP(1).
                     run form_main (nCol,9, "Счет : " + vAcctNumber).
                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + cField3 + " "
                                            ELSE "")
                                            + "Наименование " + string(b-cust-corp.name-corp)).
                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + STRING(INTEGER(cField3) + 1) + " "
                                            ELSE "")
                                            + "Организационно-правовая форма "
                                            + string(b-cust-corp.cust-stat)).
                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + STRING(INTEGER(cField3) + 2) + " "
                                            ELSE "")
                                            + "Регистрационный номер "
                                            + form_dopf ("cust-corp","RegNum",?)).
                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + STRING(INTEGER(cField3) + 3) + " "
                                            ELSE "")
                                            + "Дата гос. регистрации "
                                            + form_dopf ("cust-corp","RegDate",?)).
                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + STRING(INTEGER(cField3) + 4) + " "
                                            ELSE "")
                                            + "Место гос. регистрации "
                                            + form_dopf ("cust-corp","RegPlace",?)).
                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + STRING(INTEGER(cField3) + 5) + " "
                                            ELSE "")
                                            + "Адрес места нахождения "
                                            + form_dopf ("cust-corp","АдресП",?)).
                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + STRING(INTEGER(cField3) + 6) + " "
                                            ELSE "")
                                            + "Юридический адрес "
                                            + string(b-cust-corp.Addr-of-low[1] + " " + b-cust-corp.Addr-of-low[2])).
                     IF cField3 <> "" THEN
                     DO:
                        run form_main (nCol,9,"1." + STRING(INTEGER(cField3) + 7) + " "
                                             + " Тел. Руководителя " + form_dopf ("cust-corp","Tel",?)).
                        put unformatted   "      Тел. Гл. Бухгалт. "  SKIP
                                          "      Тел. Секретариата                 "
                                          "Факс " + b-cust-corp.Fax      SKIP.
                     END.
                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + STRING(INTEGER(cField3) + 8) + " "
                                            ELSE "")
                                            + "ИНН "
                                            + IF b-cust-corp.inn = ? THEN "" ELSE string(b-cust-corp.inn)).
                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + STRING(INTEGER(cField3) + 9) + " "
                                            ELSE "")
                                            + "Код ОКПО " + string(b-cust-corp.okpo,fMaxLen(25,b-cust-corp.okpo)) + " "
                                            + "Коды ОКВЭД " + form_dopf ("cust-corp","ОКВЭД",?)).
                  END.
               end.
            end.
            if cUserCat begins "Ч" AND
               (cField2  = "" OR
                cField2  = "Ч")  then do:
               find first b-person where b-person.person-id = integer(cUserId)
               no-lock no-error.
               if avail b-person then do:
                  lDoverOpenAcct = true.
                  cSlaveId = cUserId.
                  IF NOT vFormL1Log THEN
                  DO:
                     run form_main (nCol + 1,0,string(b-person.name-last)).
                     run form_main (nCol + 1,0,string(b-person.first-names)).
                     run form_main (nCol + 1,0,string(b-person.birthday)).
                     run form_dop  (nCol + 1,0,"person","BirthPlace").
                     run form_main (nCol + 1,0,string(b-person.country-id + ","
                      + fGetStrAdr(b-person.Address[1] + " " + b-person.Address[2]))).
                     run form_dop  (nCol + 1,0,"person","country-id2").
                     run form_dop  (nCol + 1,0,"person","PlaceOfStay").

                     mStrTMP = b-person.document-id.

                     IF mIsDocumFromClass THEN
                        mStrTMP = GetCodeName("КодДокум", mStrTMP).

                     RUN form_main (nCol + 1,0,STRING(mStrTMP)).
                     run form_main (nCol + 1,0,string(b-person.Document)).
                     run form_main (nCol + 1,0,string(b-person.Issue)).
                     run form_dop  (nCol + 1,0,"person","Document4Date_vid").
                     if not (b-person.inn = "" )
                     then run form_main (nCol + 1,0,"ИНН " + string(b-person.inn)).
                  END.
                  ELSE
                  DO:

                     vIndxInt = INDEX(b-person.first-names," ").

                     put unformatted SKIP(1).
                     run form_main (nCol,9, "Счет : " + vAcctNumber).
                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + cField3 + " "
                                            ELSE "")
                                            + "Фамилия " + string(b-person.name-last,fMaxLen(20,b-person.name-last)) + " "
                                            + "Имя " + string(IF vIndxInt > 0
                                                              THEN SUBSTR(b-person.first-names,1,vIndxInt)
                                                              ELSE b-person.first-names) + "     "
                                            + "Отчество " + string(IF vIndxInt > 0
                                                                   THEN substr(b-person.first-names,vIndxInt + 1)
                                                                   ELSE "")).
                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + STRING(INTEGER(cField3) + 1) + " "
                                            ELSE "")
                                            + "Дата рождения " + string(string(b-person.birthday),"x(14)") + " "
                                            + "Место рождения " + form_dopf ("person","BirthPlace",?)).
                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + STRING(INTEGER(cField3) + 2) + " "
                                            ELSE "")
                                            + "Место прописки (регистрации) " + string(b-person.country-id + ","
                                            + fGetStrAdr(b-person.Address[1] + " " + b-person.Address[2]))).
                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + STRING(INTEGER(cField3) + 3) + " "
                                            ELSE "")
                                            + "Место проживания (нахождения) "
                                            + form_dopf ("person","country-id2",?) + " "
                                            + form_dopf ("person","PlaceOfStay",?)).

                     mStrTMP = b-person.document-id.

                     IF mIsDocumFromClass THEN
                        mStrTMP = GetCodeName("КодДокум", mStrTMP).

                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + STRING(INTEGER(cField3) + 4) + " "
                                            ELSE "")
                                            + "Документ, удостоверяющий личность "
                                            + string(mStrTMP,fMaxLen(15,mStrTMP)) + " "
                                            + "серия " + string(b-person.Document) + " ").
                     run form_main (nCol,9,   "дата выдачи " + form_dopf ("person","Document4Date_vid",10) + " "
                                            + "место выдачи " + string(b-person.Issue)).
                     run form_main (nCol,9,(IF cField3 <> ""
                                            THEN "1." + STRING(INTEGER(cField3) + 5) + " "
                                            ELSE "")
                                            + "ИНН (если имеется) "
                                            + IF b-person.inn = ? THEN "" ELSE string(b-person.inn)).
                  END.
               end.
            end.
            cSlaveId = "".
         end.
         IF cField = "ХарОпер" then
            cValue1 = b-acct.number
                    + ": "
                    + GetXattrValue ("acct",b-acct.acct + "," + b-acct.currency,"ХарОпер").
         if cField = "curator" then do:
            cValue1 = b-acct.acct.
            vAcctAcct   = b-acct.acct.
            vAcctNumber = b-acct.number.
            cUserId = b-acct.user-id .
         end.
         if cField = "СотрУтвСч" then do:
            cValue1 = b-acct.acct.
            vAcctAcct   = b-acct.acct.
            vAcctNumber = b-acct.number.
            cUserId = GetXattrValue ("acct",b-acct.acct + "," + b-acct.currency,cField).
         end.
         if cField = "СотрОткрСч" then do:
            cValue1 = b-acct.acct.
            vAcctAcct   = b-acct.acct.
            vAcctNumber = b-acct.number.
            cUserId = AcctWhoCreated (b-acct.acct,b-acct.currency).
         end.
         if cField = "ОперПоСч" then do:

            /* Сумма проводок по Дт и Кт за квартал */
            run acct-pos in h_base (b-acct.acct, b-acct.currency, dBegDate, dEndDate, gop-status).
            ASSIGN
               nSunDtCt = if b-acct.currency =  ""
                          then abs(sh-db)  + abs(sh-cr)
                          else abs(sh-vdb) + abs(sh-vcr)
               nCntDtCt = 0
               cValue1 = b-acct.acct
               cValue2 = b-acct.currency.
               vAcctAcct   = b-acct.acct.
               vAcctNumber = b-acct.number.

            /* Кол-во проводок за квартал */
            if nSunDtCt > 0 then do:
               for each op-entry where  op-entry.acct-cr = cValue1
                                    and op-entry.currency begins cValue2
                                    and op-date >= dBegDate
                                    and op-date <= dEndDate
                                    and op-status >= gop-status no-lock :
                  nCntDtCt = nCntDtCt + 1.
               end.
               for each op-entry where  op-entry.acct-db = cValue1
                                    and op-entry.currency begins cValue2
                                    and op-date >= dBegDate
                                    and op-date <= dEndDate
                                    and op-status >= gop-status no-lock :
                  nCntDtCt = nCntDtCt + 1.
               end.
               run form_word (input nCol + 1,input "",input string(nCntDtCt)) .
               run form_word (input nCol + 2,input "",input string(nSunDtCt)) .
            end.
            else do:
               cValue2 = GetXattrValue ("acct",cValue1 + "," + cValue2,cField).
               if cValue2 = ? then cValue2 = "".
               nCntParm = MINIMUM(NUM-ENTRIES(cValue2),2).
               if nCntParm > 0 then
                  do i = 1 to nCntParm:
                     run form_word (input nCol + i,input "",input string(ENTRY(i,cValue2))) .
                  end.
       end.
         end.
         if cField = "ИстПоступл" then do:
            cValue2 = GetXattrValue ("acct",b-acct.acct + "," + b-acct.currency,cField).
            nCntParm = MINIMUM(NUM-ENTRIES(cValue2),3).
            cValue1 = b-acct.number + " : "
          + if nCntParm > 0 then string(ENTRY(1,cValue2)) else "".

            if nCntParm > 1 then
               do i = 2 to nCntParm:
                  run form_word (input nCol + i - 1,input "",input string(ENTRY(i,cValue2))) .
               end.
    end.
         if cField = "curator" or cField = "СотрУтвСч" or cField = "СотрОткрСч" then do:
            find first _user where _user._userid = cUserId no-lock no-error .
            if avail _user then do:
               cValue2 = _User._User-Name
                       + " "
                       + string(GetXattrValue ("_user",_user._userid,"Должность")).
            end.
            if cValue2 = ? then cValue2 = "?".
            run form_word (input nCol + 1,input "",input cValue2) .
         end.

         if not (cField = "ДоверОткрСч") or lDoverOpenAcct then do:
            if cValue1 = ? then cValue1 = "?".
            IF vFormL1Log AND
               cField = "ДоверОткрСч" THEN .
            ELSE
            DO:
               IF LENGTH(vAcctAcct) GT 0 THEN
                  cValue1 = REPLACE(cValue1, vAcctAcct, vAcctNumber).
               run form_word (input nCol,input "",input cValue1) .
               run form_put (true,c1Char).
            END.
         end.
         else nFirstPrtCol = 0.

      END.
   end.

END PROCEDURE.

/*** перенос слов в колонке таблицы ***/
/*** form_word (2,"|","текст") ***/
PROCEDURE form_word:

   {wordwrap.def}

   DEFINE INPUT PARAMETER nCol AS INTEGER NO-UNDO.
   DEFINE INPUT PARAMETER cVar AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER wws1 AS CHARACTER NO-UNDO.
   /*** cVar - символ "|" в тексте означает принудительный преревод на след.строку ***/

   &SCOPED-DEFINE ext 100

   DEFINE  VARIABLE s    AS CHARACTER EXTENT {&ext}  NO-UNDO.
   DEFINE  VARIABLE wwj1 AS INTEGER   INITIAL -1 NO-UNDO.
   DEFINE  VARIABLE i    AS INTEGER              NO-UNDO.

   s[1] = wws1.
   {wordwrap.i &s=s &n={&ext} &l=nColWigth[nCol] &d=cVar}
   DO i = 1 TO {&ext}:
      IF i =1 OR TRIM(s[i]) <> '' THEN
         RUN SaveDataProtocol IN h_base (INPUT "Colon" + STRING(nCol),
            INPUT SUBSTRING(s[i],1,nColWigth[nCol])).
   END.

END PROCEDURE.

/*** сборка колонок и вывод ***/
PROCEDURE form_put:
   /*** il1Char : - false - не добавлять левую границу строки ***/
   /****         - true  - добавить символ "│" в 1 строку слева . ***/
   DEFINE INPUT PARAMETER  il1Char  as logical.
   DEFINE INPUT PARAMETER  ic1Char  as CHARACTER.

   def var lPrEnd   as logical init FALSE no-undo.
   def var cPrtRow  as character init "" no-undo.
   def var cTextCol as character init "" no-undo.
   i = 0.
   do while (lPrEnd = FALSE) :
      lPrEnd = TRUE.
      i = i + 1.
      cPrtRow = (if i = 1 and not il1Char then "" else ic1Char).
      do j = nFirstPrtCol to nCntCol:
         run GetDataFromProtocol in h_base ("Colon" + string(j),input i, output cTextCol).
         lPrEnd = lPrEnd and (cTextCol = "EndProtocol").
         cPrtRow = cPrtRow
                 + SUBSTRING((if cTextCol = "EndProtocol" then "" else cTextCol)
                          + FILL(" ",nColWigth[j]),1,nColWigth[j])
                 + ic1Char.
      end.
      if not lPrEnd then put unformatted cPrtRow skip.
      nFirstPrtCol = 1.
   end.

   do i = 1 to 5:
      run DeleteOldDataProtocol in h_base (input "Colon" + string(i)).
   end.

   nFirstPrtCol = 0.

END PROCEDURE.

/*!!!*/

/* Выбор счетов настройке */
PROCEDURE GET_RID_ACCT.
    DEFINE INPUT  param iFiltAcct AS CHARACTER no-undo. /* наличие фильтра для счетов */
    DEFINE OUTPUT param total_records as int no-undo. /* Кол-во выбранных записей */
   
    total_records = 0.

    if iFiltAcct NE "" then do:
       RUN SelectFltObject("acct",
                           "MustOffLdFlt|UserConf~001cust-cat~001cust-id",
                           "YES|" + iFiltAcct + "~001" + in-cust-cat + "~001" + STRING (in-cust-id),
                           "cust-cat~001cust-id").       
       RUN rid-rest.p (OUTPUT TABLE acct_tmprecid).
    end.
    ELSE DO:
       RUN SelectFltObject("acct",
                           "MustOffLdFlt|cust-cat~001cust-id~001close-date1~001close-date2",
                           "YSE|" + in-cust-cat + CHR(1) + STRING (in-cust-id) + "~001~001",
                           "").
       RUN rid-rest.p (OUTPUT TABLE acct_tmprecid).

    end.

END PROCEDURE.


FUNCTION vGetDateHist RETURNS DATE (INPUT iPar      AS INTEGER,
                                    INPUT iTypeCli  AS CHARACTER,
                                    INPUT iDate     AS DATE,
                                    INPUT iMasterId AS CHARACTER,
                                    INPUT iTabl     AS CHARACTER
):

   DEFINE VARIABLE vDate AS DATE      NO-UNDO.

   vDate = iDate.

   IF     iPar     LE     1
      AND iTypeCli BEGINS "Ю" THEN
      vDate = cust-corp.date-in.

   IF     iPar     LE     1
      AND iTypeCli BEGINS "Ч" THEN
      vDate = DATE(GetXattrValue ("person",iMasterId,"date-in")).

   IF    (iPar LE 1 AND vDate EQ ?)
      OR iPar EQ 5 THEN
   DO:
      FIND LAST history WHERE history.file-name EQ iTabl
                          AND history.field-ref EQ iMasterId
         NO-LOCK NO-ERROR.

      IF AVAILABLE history THEN
         vDate = history.modif-date.
   END.
   RETURN vDate.
END FUNCTION.

/***********************************************************************/

nInParams = NUM-ENTRIES(cInParams).

/* Тип клиента Ю,Б,Ч */
if nInParams >= 1 then do:
   ASSIGN
      cTypeCli   = GetEntries(1,cInParams,",","")
      vFormL1Log = (INDEX(cTypeCli,"Л-1") > 0)
   .
   if not (cTypeCli begins "Ю" or cTypeCli begins "Б" or cTypeCli begins "Ч") then do:
      message "В параметрах отчета неверный тип клиента" + cTypeCli
      view-as alert-box error .
      return "error".
   end.
end.

/* Дата заполнения анкеты */
/* 1 - cust-corp.date-in или дата последнего изменения по History.
   2 - Системная дата.
   3 - Произвольная дата, вводимая пользователем с клавиатуры. */

nInPar = DECIMAL(GetEntries(2,cInParams,",","")).
   /* 2 - Системная дата. */
   /* 3 - Произвольная дата, вводимая пользователем с клавиатуры. */
   if nInPar = 2 or nInPar = 3 then dDateIn = today.
   if nInPar = 3 then message "Введите дату заполнения анкеты " update dDateIn .

   /* 4 - Дату брать из date-in, если не заполнено, то пусто */
/*   IF nInPar = 4 THEN
      dDateIn = mDateIn.*/

   /* 5 - Дату брать из журнала изменений, если он пуст, то пусто */
/*   IF nInPar = 5 THEN
   DO:
   END. */

/* Срок хранения анкеты */
cSrokSave = GetEntries(3,cInParams,",","").

/* Наличие фильтра для счетов */
if (cTypeCli begins "Ю" or cTypeCli begins "Ч") then do:
   /* Идентификатор пользователя, создавшего фильтр для счетов */
   cUserFlt = GetEntries(4,cInParams,",","").
   /* Идентификатор фильтра для счетов */
   cNameFlt = GetEntries(5,cInParams,",","").
end.

cParamChar = TRIM(GetEntries(6,cInParams,",","1")).
IF cParamChar <> "" THEN
DO:
   IF cParamChar EQ "1" THEN
      mClientType = "Клиент".
   ELSE
      mClientType = "Выгодоприобретатель".
END.

cParamChar = TRIM(GetEntries(7,cInParams,",","")).
IF cParamChar EQ "Да" AND
   mClientType EQ "Клиент" THEN
   mIsPrintDummy = YES.

cParamChar = TRIM(GetEntries(8,cInParams,",","")).
IF cParamChar <> "" THEN
DO:
   mParRenewal = INTEGER(cParamChar).
   CASE mParRenewal:

      WHEN 1 THEN
      DO:
      /* Из истории (сначала) или data-in (если нет записей в history) */
      END.

      WHEN 2 THEN
      DO:
      /* системная дата */
         mDateRenewal = TODAY.
      END.

      WHEN 3 THEN
      DO:
      /* Произвольная дата, вводимая с клавиатуры */
       MESSAGE
          "Дата обновления анкеты неизвестна, введите дату :" UPDATE mDateRenewal .

      END.

/*      WHEN 4 THEN
      DO:
      /* дата формирования - дату брать из date-in если не заполнено, то пусто */
      END.*/

/*      WHEN 5 THEN
      DO:
      /* Дату брать на основе даты последнего изменения или создания клиента из
         журнала изменений, если журнал изменений пуст, то пусто */
      END.*/
   END CASE.
END.

mParSigner = TRIM(GetEntries(9,cInParams,",","")).
cVerBankChar = TRIM(GetEntries(10,cInParams,",","")). /* Версия анкеты для банка : */
                                                      /*  ""  - Стандарт           */
                                                      /*  "1" - RSHB               */

vRepWidthInt = IF cTypeCli BEGINS "Ч" THEN 120 ELSE 80.

{setdest.i &cols=" + vRepWidthInt"}

/*** Найти фильтр для анкет ***/
if not (cNameFlt = "") then do:

   find last user-config where
       user-config.user-id   eq cUserFlt
   and user-config.proc-name eq "acct.p"
   and user-config.sub-code  eq user-config.sub-code
   and user-config.descr     eq cNameFlt
   no-lock no-error.

   if avail user-config then 
      mFiltAcct = cUserFlt + ",acct.p," + cNameFlt + ",b".
   ELSE 
      mFiltAcct = "".
end.

/*** Переопределение параметров qry ***/
in-cust-cat       = substr(cTypeCli,1,1).

for each cust_tmprecid no-lock :
    if cTypeCli begins "Ю" then do:
       find first cust-corp where recid(cust-corp) =cust_tmprecid.id no-lock no-error.
       if avail cust-corp then do:
          assign
             cMasterId = string(cust-corp.cust-id)
             /*** Переопределение параметров qry ***/
             in-cust-id  = cust-corp.cust-id.
       end.
    end.
    if cTypeCli begins "Б" then do:
       find first banks where recid(banks) =cust_tmprecid.id no-lock no-error.
       if avail banks then do:
          assign
             cMasterId = string(banks.bank-id)
             /*** Переопределение параметров qry ***/
             in-cust-id  = banks.bank-id.
       end.
    end.
    if cTypeCli begins "Ч" then do:
       find first person where recid(person) =cust_tmprecid.id no-lock no-error.
       if avail person then do:

          assign
          cMasterId     = string(person.person-id)
          /*** Переопределение параметров qry ***/
          in-cust-id  = person.person-id.

          if GetXattrValue ("person",cMasterId,"Предпр") = "" /* доп.рекв. отсутствует */
          then do: if cTypeCli = "ЧП" then next. end.
          else do: if cTypeCli = "ЧЛ" then next. end.

       end.
   end.

   IF mIsPrintDummy AND NOT CAN-FIND(FIRST acct WHERE acct.cust-cat EQ SUBSTRING(cTypeCli,1,1) 
                                                  AND acct.cust-id  EQ in-cust-id) THEN
      NEXT.

    /* выбор счетов клиента */
    run GET_RID_ACCT (input mFiltAcct, output nTotalRecords).
    /* Определение периода для операций */
    /* квартала */


    IF cTypeCli BEGINS "Ю" THEN
    DO:
       mDateIn = STRING(cust-corp.date-in).
       mTabl   = "cust-corp".
       mSVL    = GetXAttrValueEx("cust-corp",
                                 STRING(cust-corp.cust-id),
                                 "СведВыгЛица",
                                 "").
       /* получение полного наименвания */
       mFullName = cust-corp.name-corp.
       IF cust-corp.cust-stat NE "" THEN DO:
          mStatus = GetCodeName("КодПредп", GetCodeVal("КодПредп", cust-corp.cust-stat)).
          IF mStatus EQ ? THEN
             mStatus = "".
       END.
       mFullName = TRIM (mStatus + " " + mFullName).
    END.
    ELSE IF cTypeCli BEGINS "Б" THEN
    DO:
       mDateIn = GetXAttrValueEx("banks",
                                 STRING(banks.bank-id),
                                 "date-in",
                                 "").
       mTabl   = "banks".
       mSVL    = GetXAttrValueEx("banks",
                                 STRING(banks.bank-id),
                                 "СведВыгЛица",
                                 "").
    END.
    ELSE IF cTypeCli BEGINS "Ч" THEN
    DO:
       mDateIn = GetXAttrValueEx("person",
                                 STRING(person.person-id),
                                 "date-in",
                                 "").
       mTabl   = "person".
       mSVL    = GetXAttrValueEx("person",
                                 STRING(person.person-id),
                                 "СведВыгЛица",
                                 "").
       mVD = GetXAttrValueEx("person", STRING(person.person-id), "ОснВидыДеят", "").
       IF mVD EQ "" THEN DO:
          mOKVEDs = GetXAttrValueEx ("person", STRING(person.person-id), "ОКВЭД", "").
          DO mI = 1 TO NUM-ENTRIES (mOKVEDs):
             mVD = mVD + GetCodeName ("ОКВЭД", ENTRY (mI,mOKVEDs)) + ". ".
          END.
       END.
    END.

    dDateIn      = vGetDateHist (nInPar,      cTypeCli, dDateIn,      cMasterId, mTabl).
    mDateRenewal = vGetDateHist (mParRenewal, cTypeCli, mDateRenewal, cMasterId, mTabl).

    IF mParRenewal EQ 4 THEN
       mDateRenewal = DATE(mDateIn).

    CASE mParSigner:

       WHEN "1" THEN
       DO:
      /* По журналу изменений, запись с типом "создание" */
          FIND LAST history WHERE history.file-name EQ mTabl
                              AND history.field-ref EQ cMasterId
                              AND history.modify    EQ "С"
              NO-LOCK NO-ERROR.

          IF AVAILABLE history THEN
             mSigner = history.user-id.
       END.

       WHEN "2" THEN
       DO:
      /* По журналу изменений, запись с типом "изменение" */
          FIND LAST history WHERE history.file-name EQ mTabl
                              AND history.field-ref EQ cMasterId
                              AND history.modify    EQ "W"
              NO-LOCK NO-ERROR.

          IF AVAILABLE history THEN
             mSigner = history.user-id.
       END.

       WHEN "3" THEN
       DO:
      /* Текущий */
          mSigner = userId("bisquit").
       END.
    END CASE.

    IF nInPar EQ 4 THEN
       dDateIn = DATE(mDateIn).

    IF dDateIn EQ ? AND nInPar LT 4 THEN
       MESSAGE
          "Дата заполнения анкеты неизвестна, введите дату :" UPDATE dDateIn .

    if nInPar <= 1 or nKv = 0 then do:
       nKv = TRUNCATE(month(dDateIn) / 3.1,0) + 1.
       dBegDate = DATE(3 * (nKv - 1) + 1,01,YEAR(dDateIn)).
       dEndDate = DATE((if nKv = 4 then 0 else (3 * nKv)) + 1,
                      01,
                      YEAR(dDateIn) + (if nKv = 4 then 1 else 0)) - 1.
    end.

    FUNCTION vFStrDate RETURNS CHARACTER ( iDate AS DATE):
       RETURN IF iDate NE ? THEN STRING(iDate,"99/99/9999") ELSE "          ".
    END.

    /***** Юр.лица ******/
    if cTypeCli = "Ю" then do:

       PAGE.
       put unformatted "                                                                               " skip.

       IF mClientType EQ "Клиент" THEN
          PUT UNFORMATTED "АНКЕТА КЛИЕНТА-ЮРИДИЧЕСКОГО ЛИЦА                                               " SKIP.
       ELSE
          PUT UNFORMATTED "АНКЕТА ВЫГОДОПРИОБРЕТАТЕЛЯ-ЮРИДИЧЕСКОГО ЛИЦА                                   " SKIP.
       put unformatted "(не являющегося кредитной организацией)                                        " skip.

       IF mClientType EQ "Выгодоприобретатель" THEN
          PUT UNFORMATTED "Сведения об основаниях, свидетельствующих о том, что клиент действует" SKIP
                          "к выгоде другого лица при проведении банковских операций и иных сделок" SKIP
                          mSVL SKIP(1).

       put unformatted " Часть 1 (табличная)                                                            " skip.
        run form_tabl ("41,35").
       put unformatted "┌─────────────────────────────────────────┬───────────────────────────────────┐" skip.
       put unformatted "│".
        run form_text (1,0,"Полное и (в случае, если имеется)|сокращенное наименование, в том числе|фирменное наименование").
        IF cust-corp.name-short <> "" THEN DO:
           run form_text (2,9,string(cust-corp.name-corp + "|" + cust-corp.name-short)).
        END.
        ELSE DO:
           run form_main (2,9,string(cust-corp.name-corp)).
        END.
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Организационно-правовая форма            │". run form_main (2,9,string(cust-corp.cust-stat)).
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Регистрационный номер                    │". run form_dop (2,9,"cust-corp","RegNum").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│".
        run form_text (1,0,"Основной государственный регистрационный|"
                         + "номер (ОГРН)").
        run form_dop (2,9,"cust-corp","ОГРН").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Дата государственной регистрации         │". run form_dop (2,9,"cust-corp","RegDate").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Место государственной регистрации        │". run form_dop (2,0,"cust-corp","RegPlace").
                                                                      run form_dop (2,9,"cust-corp","Country-id2").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Адрес местонахождения                    │". run form_main (2,0,string(cust-corp.Addr-of-low[1] + " " + cust-corp.Addr-of-low[2])).
                                                                      run form_main (2,9,string(cust-corp.Country-ID)).
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Почтовый адрес                           │". run form_dop (2,9,"cust-corp","АдресП").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Номера контактных телефонов и факсов     │". run form_main (2,9,string(cust-corp.Fax)).
       put unformatted "│                                         │". run form_dop (2,9,"cust-corp","Tel").
/*       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Адрес электронной почты                  │". run form_dop (2,9,"cust-corp","e-mail").*/
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Идентификационный номер налогоплательщика│". run form_main (2,9,string(cust-corp.inn)).
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Kоды форм федерального государственного  │". run form_main (2,9,"ОКОНХ " + string(cust-corp.okonx) + " " + GetCodeName("ОКОНХ", string(cust-corp.okonx))).
       put unformatted "│статистического наблюдения               │". run form_main (2,9," ОКПО " + string(cust-corp.okpo)).
       put unformatted "│                                         │". run form_main (2,9,"ОКВЭД :"). 

       mStrTMP1 = GetXAttrValueEx("cust-corp", 
                                   STRING(cust-corp.cust-id), 
                                   "ОКВЭД", 
                                   "").

         DO mItem =1 TO 6:
            IF mItem GT NUM-ENTRIES(mStrTMP1) THEN
               LEAVE.
            mStrTMP = ENTRY(mItem,mStrTMP1).
/*            put unformatted "│                                         │". run form_text (2,9,mStrTMPform_dopf ("cust-corp","ОКВЭД",?) + " " + GetCodeName("ОКВЭД", form_dopf ("cust-corp","ОКВЭД",?))).*/
            put unformatted "│                                         │". run form_text (2,9,mStrTMP + " " + " " + GetCodeName("ОКВЭД", mStrTmp)).
         END.

       
/* IF cVerBankChar = "1" THEN  "1" - RSHB: добавл. 2.1 */
/* DO: */
/* 2.1 */ /*  put unformatted "│                                         │". run form_main (2,9,"ОКВЭД " + form_dopf ("cust-corp","ОКВЭД",?)). */
/* END. */
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
/*       put unformatted "│Сведения о лице, открывающем счет для    │                                   │" skip.
       put unformatted "│юридического лица (вносящем вклад в      │                                   │" skip.
       put unformatted "│пользу юридического лица) (в случае      │                                   │" skip.
       put unformatted "│открытия счета (внесения вклада) не самим│                                   │" skip.
       put unformatted "│юридическим лицом)                       │                                   │" skip.
        run form_acct (1,"ДоверОткрСч"). 
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.*/
       put unformatted "│Уровень риска                            │". run form_dop (2,9,"cust-corp","РискОтмыв").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Дата открытия первого счета.             │".
        run form_acct (2,"MinDateOpen").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Kуратор счета :                          │                                   │" skip.
        run form_acct (1,"curator").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
/*       put unformatted "│Резервный куратор счета(если существует):│                                   │" skip.
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.*/
/*       put unformatted "│Сотрудник, утвердивший открытие счета    │                                   │" skip.
        run form_acct (1,"СотрУтвСч").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.*/
       put unformatted "│Дата заполнения Анкеты клиента           │" + vFStrDate(dDateIn) + FILL(" ",25) + "│" skip.
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       PUT UNFORMATTED "│Дата обновления Анкеты клиента           │" + vFStrDate(mDateRenewal) + FILL(" ",25) + "│" SKIP.
       PUT UNFORMATTED "├─────────────────────────────────────────┼───────────────────────────────────┤" SKIP.
       put unformatted "│Срок хранения Анкеты клиента             │" + substr(string(cSrokSave) + FILL(" ",35),1,35) + "│" skip.
       put unformatted "└─────────────────────────────────────────┴───────────────────────────────────┘" skip.

       if page-size - line-counter < (7) then do:
          down(1) .
          page .
       end.

       put unformatted "                                                                               " skip.
       put unformatted " Часть 2 (текстовая)                                                           " skip.
       put unformatted "┌─────────────────────────────────────────┬───────────────────────────────────┐" skip.
/*       put unformatted "│".*/
IF cVerBankChar = "1" THEN /* 1 - RSHB: изм. 2.2  */
DO:
/* 2.2 */  run form_text (1,0,"Сведения об учредителях, собственниках|"
                         + "имущества юридического лица, лицах,|"
                         + "которые имеют право давать обязательные|"
                         + "для юридического лица указания либо|"
                         + "иным образом  имеют возможность опреде-|"
                         + "лять его решения, в том числе сведения|"
                         + "об основном обществе или преобладающем,|"
                         + "участвующем обществе (для дочерних|"
                         + "или зависимых обществ), холдинговой ком-|"
                         + "пании или финансово-промышленной|"
                         + "группе (если клиент в ней  участвует)").
END.
ELSE
DO:
/*        run form_text (1,0,"Сведения об учредителях, собственниках|"
                         + "имущества юридического лица, лицах,|"
                         + "которые имеют право давать обязательные|"
                         + "для юридического лица указания либо|"
                         + "иным образом  имеют возможность опреде-|"
                         + "лять его решения, в том числе сведения|"
                         + "об основном обществе или преобладающем,|"
                         + "участвующем обществе (для дочерних|"
                         + "или зависимых обществ), холдинговой ком-|"
                         + "пании или финансово-промышленной|"
                         + "группе (если клиент в ней  участвует)|"
                         + "(заполняется с учетом подпунктов 2.2.3|"
                         + "и 2.2.4 настоящих Рекомендаций)").*/
END.
/*        run form_dop (2,9,"cust-corp","УчредОрг"). */
/*       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.*/
       put unformatted "│".
        run form_text (1,0,"Сведения о наличии лицензий (разрешений)|"
                         + "на осуществление определенного|"
                         + "вида деятельности или операций|"
                         + "(номер лицензии (разрешения), когда, кем|"
                         + "и на осуществление какого вида|"
                         + "деятельности (операции) выдана)").
        run form_dop (2,9,"cust-corp","ЛицензОрг").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       PUT UNFORMATTED "│".
        RUN form_text (1,0,"Сведения о величине зарегистрированного|"
                         + "и оплаченного уставного (складочного)|"
                         + "капитала или величине уставного фонда,|"
                         + "имущества").
        RUN form_dop (2,9,"cust-corp","УставКап").
       PUT UNFORMATTED "├─────────────────────────────────────────┼───────────────────────────────────┤" SKIP.
       put unformatted "│".
IF cVerBankChar = "1" THEN /* 1 - RSHB: изм. 2.3  */
DO:
/* 2.3 */  run form_text (1,0,"Сведения об органах юридического лица|"
                         + "(структура органов управления юридичес-|"
                         + "кого лица и сведения о физических|"
                         + "лицах, входящих в состав исполнительных|"
                         + "органов юридического лица)").
END.
ELSE
DO:
        run form_text (1,0,"Сведения об органах юридического лица|"
                         + "(структура органов управления юридичес-|"
                         + "кого лица и сведения о физических|"
                         + "лицах, входящих в состав исполнительных|"
                         + "органов юридического лица)").
/*", с учетом|"
                         + "подпунктов 2.2.3 и 2.2.4 настоящих|"
                         + "Рекомендаций)").*/
END.
        run form_dop (2,9,"cust-corp","СтруктОрг").
 
        put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
        put unformatted "│".
        run form_text (1,0,"Сведения о присутствии по своему |"
                         + "местонахождению постоянно действующего|"
                         + " органа управления").
        run form_dop (2,9,"cust-corp","ПрисутОргУправ").

/*       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
        put unformatted "│".
        run form_text (1,0,"Обособленные подразделения (если имеются|"
                         + "и сведения о них известны|"
                         + "кредитной организации)").
        run form_dop (2,9,"cust-corp","ОбособПодр").*/
/*       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│".
        run form_text (1,0,"Основные виды деятельности|"
                         + "(в том числе производимые товары,|"
                         + "выполняемые работы, предоставляемые|"
                         + "услуги)").
        run form_dop (2,9,"cust-corp","ОснВидыДеят").*/
IF cVerBankChar = "1" THEN . /* 1 - RSHB : искл. 2.4; 2.5 */
ELSE
DO:
/*       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Сведения о постоянных контрагентах       │". run form_dop (2,9,"cust-corp","ПостКонтраг").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│".
        run form_text (1,0,"История, репутация, сектор рынка и|"
                         + "конкуренция (сведения о реорганизации,|"
                         + "изменения в характере деятельности,|"
                         + "прошлые финансовые проблемы, репутация|"
                         + "на национальном и зарубежных рынках,|"
                         + "основные обслуживаемые рынки, присут-|"
                         + "ствие на рынках, основная доля в|"
                         + "конкуренции и на рынке)").
        run form_dop (2,9,"cust-corp","ИсторияКл").*/
END.
       put unformatted "└─────────────────────────────────────────┴───────────────────────────────────┘" skip.

       run form_tabl ("49,14,12").

       if page-size - line-counter < (7) then do:
          down(1) .
          page .
       end.

       put unformatted "                                                                               " skip.
  /*     put unformatted " Часть 3 (в виде таблицы)                                                      " skip.
       put unformatted "┌─────────────────────────────────────────────────┬──────────────┬────────────┐" skip.
       put unformatted "│Операции, проводимые по счету                    │Число операций│Общая сумма │" skip.
       put unformatted "│(предполагаемые клиентом, если клиент ранее не   │ (за квартал) │(за квартал)│" skip.
       put unformatted "│ обслуживался)                                   │              │            │" skip.
        run form_acct (1,"ОперПоСч").
       put unformatted "├─────────────────────────────────────────────────┼──────────────┼────────────┤" skip.
       put unformatted "│Источники поступления денежных средств           │Число операций│Общая сумма │" skip.
       put unformatted "│(ожидаемые клиентом, если клиент ранее не        │ (за квартал) │(за квартал)│" skip.
       put unformatted "│обслуживался)                                    │              │            │" skip.
        run form_acct (1,"ИстПоступл").
       put unformatted "└─────────────────────────────────────────────────┴──────────────┴────────────┘" skip.

       run form_tabl ("77").

       if page-size - line-counter < (7) then do:
          down(1) .
          page .
       end.

       put unformatted "                                                                               " skip.
       put unformatted " Часть 4 (текстовая)                                                           " skip.
       put unformatted "┌─────────────────────────────────────────────────────────────────────────────┐" skip.
       put unformatted "│Характеристика операций                                                      │" skip.
       put unformatted "│(оценка соотношения операций с деятельностью клиента, реальных оборотов      │" skip.
       put unformatted "│по счету заявленным и т.д.)                                                  │" skip.
        run form_acct (1,"ХарОпер").
       put unformatted "└─────────────────────────────────────────────────────────────────────────────┘" skip(1).
       if page-size - line-counter < (7) then do:
          down(1) .
          page .
       end.
       put unformatted "                                                                               " skip.
       put unformatted " Часть 5 (текстовая)                                                           " skip.
       put unformatted "┌─────────────────────────────────────────────────────────────────────────────┐" skip.
       put unformatted "│Оценка риска осуществления клиентом легализации (отмывания) доходов,         │" skip.
       put unformatted "│полученных преступным путем и финансирования терроризма                      │" skip.
       put unformatted "│(обоснование оценки в соответствии с критериями, разработанными     кредитной│" skip.
       put unformatted "│организацией)                                                                │" skip.
       put unformatted "│". run form_dop (1,9,"cust-corp","ОценкаРиска").
       put unformatted "└─────────────────────────────────────────────────────────────────────────────┘" skip(1).*/

       find _user where _user._userid eq userid("bisquit") no-lock no-error.

       put unformatted "Фамилия,имя,отчество,должность сотрудника," SKIP.
       put unformatted "утвердившего открытие счета               ____________________________" SKIP(1).

       put unformatted "Фамилия,имя,отчество,должность лица," SKIP.
       put unformatted "заполнившего анкету в электронном виде    " + _User._User-Name  SKIP.
       put unformatted "                                          " + string(GetXattrValue ("_user",_user._userid,"Должность")) SKIP.

       put unformatted "Фамилия,имя,отчество,должность,а также подпись" SKIP.
       put unformatted "уполномоченного сотрудника банка          Юдакова С.Л. Начальник управления" SKIP.
       put unformatted "                                          открытия и регистрации счетов" SKIP(2).

       put unformatted "Оценка риска              _____________________________________________________" SKIP.

    end. /* Юр.лица */

    /***** Юр.лица (ф.ЮЛ-1) ******/
    if cTypeCli BEGINS "ЮЛ-1" then do:
       c1Char = "".

       PAGE.
       run form_tabl ("78").
       put unformatted "ф." + cTypeCli at 60 skip (2).

       CASE cTypeCli:
         WHEN "ЮЛ-1.1" OR WHEN "ЮЛ-1.2" THEN

          IF mClientType EQ "Клиент" THEN
             PUT UNFORMATTED "          ДОПОЛНЕНИЕ К П."
                           + form_dopf ("cust-corp","НомДоп",?) + " "
                           + "АНКЕТЫ КЛИЕНТА - ЮРИДИЧЕСКОГО ЛИЦА " SKIP.
          ELSE
             PUT UNFORMATTED "    ДОПОЛНЕНИЕ К П."
                           + form_dopf ("cust-corp","НомДоп",?) + " "
                           + "АНКЕТЫ ВЫГОДОПРИОБРЕТАТЕЛЯ - ЮРИДИЧЕСКОГО ЛИЦА " SKIP.
         OTHERWISE

            IF mClientType EQ "Клиент" THEN
               PUT UNFORMATTED "                       АНКЕТА КЛИЕНТА - ЮРИДИЧЕСКОГО ЛИЦА    " SKIP.
            ELSE
               PUT UNFORMATTED "                 АНКЕТА ВЫГОДОПРИОБРЕТАТЕЛЯ - ЮРИДИЧЕСКОГО ЛИЦА" SKIP.
       END CASE.

       IF mClientType EQ "Выгодоприобретатель" THEN
          PUT UNFORMATTED "Сведения об основаниях, свидетельствующих о том, что клиент действует" SKIP
                          "к выгоде другого лица при проведении банковских операций и иных сделок" SKIP
                          mSVL SKIP(1).


       put unformatted "                       (не являющегося кредитной организацией)    " skip (1).

       IF cTypeCli = "ЮЛ-1.1" OR
          cTypeCli = "ЮЛ-1.2" THEN
       DO:
         put unformatted  "Наименование: "     + cust-corp.name-corp AT 11 SKIP(1).
         run form_main (1,9,"1.1  Причина внесения " + form_dopf ("cust-corp","ПричВнес",?)).
       END.

       IF cTypeCli = "ЮЛ-1" THEN
       DO:
         run form_main (1,9,"1.1  Полное наименование "            + cust-corp.name-corp).
         run form_main (1,9,"1.2  Краткое наименование "           + cust-corp.name-short).
         run form_main (1,9,"1.3. Фирменное наименование " + form_dopf ("cust-corp","brand-name",?)).
         run form_main (1,9,"1.4. Организационно-правовая форма " + cust-corp.cust-stat).
         run form_main (1,9,"1.5. Регистрационный номер "         + form_dopf ("cust-corp","RegNum",?)).
         run form_main (1,9,"1.6. Дата гос. регистрации "         + form_dopf ("cust-corp","RegDate",?)).
         run form_main (1,9,"1.7. Место гос. регистрации "        + form_dopf ("cust-corp","RegPlace",?)).
         run form_main (1,9,"1.8. Адрес места нахождения "        + form_dopf ("cust-corp","АдресП",?)).
         run form_main (1,9,"1.9. Юридический адрес " + string(cust-corp.Addr-of-low[1] + " " + cust-corp.Addr-of-low[2])).
         run form_main (1,9,"1.10.  Тел. Руководителя "    + form_dopf ("cust-corp","Tel",?)).
            put unformatted "       Тел. Гл. Бухгалт. " SKIP
                            "       Тел. Секретариата                 "
                            "Факс " + cust-corp.Fax SKIP.
         run form_main (1,9,"1.11. ИНН "       + string(cust-corp.inn)).
         run form_main (1,9,"1.12. Код ОКПО "  + string(cust-corp.okpo,fMaxLen(25,cust-corp.okpo))
                        + " Коды ОКВЭД " + form_dopf ("cust-corp","ОКВЭД",?)).
         run form_text (1,9,"1.13. Сведения о лице, открывающем счет для юридического лица (вносящем вклад в пользу юридического лица) [заполняется в случае открытия счета (внесения вклада) не самим юридическим лицом]:").
       END.

       IF cTypeCli = "ЮЛ-1" THEN
       DO:
         run form_main (1,9,"- физическое лицо: ").
       END.

       IF cTypeCli = "ЮЛ-1" OR
          cTypeCli = "ЮЛ-1.2" THEN
       DO:
         run form_acct (1,"ДоверОткрСч,Ч" + IF cTypeCli = "ЮЛ-1.2" THEN ",2" ELSE "").
       END.

       IF cTypeCli = "ЮЛ-1" THEN
       DO:
         run form_main (1,9,"- юридическое лицо: ").
       END.

       IF cTypeCli = "ЮЛ-1" OR
          cTypeCli = "ЮЛ-1.1" THEN
       DO:
         run form_acct (1,"ДоверОткрСч,Ю" + IF cTypeCli = "ЮЛ-1.1" THEN ",3" ELSE "").
       END.

       IF cTypeCli = "ЮЛ-1" THEN
       DO:
         run form_main (1,9,"1.14. Уровень риска " + form_dopf ("cust-corp","РискОтмыв",?)).
         put unformatted "1.15. Дата открытия первого счета ".
         run form_tabl ("35,44").
         run form_acct (1,"MinDateOpen").
         run form_tabl ("25,54").
         put unformatted "1.16. Куратор счета" skip.
         run form_acct (1,"curator").
         put unformatted "1.17. Резервный куратор счета (если существует) " SKIP.
         put unformatted "1.18. Сотрудник Банка, утвердивший открытие счета " SKIP.
         run form_acct (1,"СотрУтвСч").

         run form_tabl ("78").

         run form_main (1,9,"1.19. Дата заполнения анкеты клиента " + vFStrDate(dDateIn)).
         RUN form_main (1,9,"1.20. Дата обновления анкеты клиента " + vFStrDate(mDateRenewal)).
         RUN form_main (1,9,"1.21. Срок хранения анкеты клиента " + SUBSTRING(STRING(cSrokSave),1,35)).
         run form_main (1,9,"2.1.Сведения об учредителях (участниках), собственниках имущества"
                          + " юридического лица, лицах, которые имеют право давать обязательные"
                          + " для юридического лица указания либо иным образом имеют возможность"
                          + " определять его решения, в том числе сведения об основном обществе"
                          + " или преобладающем, участвующем обществе (для дочерних или зависимых"
                          + " обществ), холдинговой компании или финансово-промышленной группе"
                          + " (если клиент в ней участвует). (Прим.: для физических лиц заполняется"
                          + " форма ЮЛ-1.2., для юридических лиц заполняется форма ЮЛ-1.1.,"
                          + " заполненные формы прикладываются после настоящего листа.)").
         run form_main (1,9,"2.2. Сведения о наличии лицензий (разрешений) на осуществление"
                          + " определенного вида деятельности или операций:").
         run form_main (1,9,"номер лицензии "
                          + form_dopf ("cust-corp","ЛицензОрг",20)
                          + " Дата выдачи "
                          + form_dopf ("cust-corp","ЛицДатаН",?)
                          ).
         run form_main (1,9,"полное наименование органа, выдавшего лицензию "
                          + form_dopf ("cust-corp","ЛицВыдНаим",?)).
         run form_main (1,9,"перечислите виды деятельности (операции), на которые выдана лицензия "
                          + form_dopf ("cust-corp","ВидДеят",?)).
         run form_main (1,9,"дата окончания действия лицензии "
                          + form_dopf ("cust-corp","ЛицДатаО",?)).
         run form_main (1,9,"2.3. Сведения об органах юридического лица(структура органов"
                          + " управления юридического лица и сведения о физических лицах,"
                          + " входящих в состав исполнительных органов юридического лица."
                          + "(Прим.: для физических лиц заполняется форма ЮЛ-1.2.)"
                          + form_dopf ("cust-corp","СтрукОрг",?)).
         run form_main (1,9,"2.4. Обособленные подразделения "
                          + form_dopf ("cust-corp","ОбособПодр",?)).
         run form_main (1,9,"2.5. Основные виды деятельности (укажите зашифрованные в ОКВЭД) "
                          + form_dopf ("cust-corp","ОснВидыДеят",?)).

         run form_tabl ("49,14,12").

         put unformatted "" SKIP.
         put unformatted "2.6. Расходные операции, проводимые по счету.  Число операций Общая сумма " skip.
         put unformatted "(предполагаемые клиентом, если клиент ранее не  (за квартал)  (за квартал)" skip.
         put unformatted " обслуживался)                                                            " skip.
          run form_acct (1,"ОперПоСч").
         put unformatted "" SKIP.
         put unformatted "2.7. Источники поступления денежных средств.   Число операций Общая сумма " skip.
         put unformatted "(ожидаемые клиентом, если клиент ранее не       (за квартал)  (за квартал)" skip.
         put unformatted "обслуживался)                                                               " skip.
         run form_acct (1,"ИстПоступл").

         run form_tabl ("78").

         put unformatted "" SKIP.
         run form_main (1,9," 2.8. Характеристика операций (оценка соотношения"
                          + " операций с деятельностью клиента, реальных оборотов"
                          + " по счету заявленным и т.д.) (заполняется в процессе деятельности"
                          + " клиента.)").
         run form_acct (1,"ХарОпер").

         run form_main (1,9,"2.9. Оценка риска осуществления клиентом легализации (отмывания)"
                          + " доходов, полученных преступным путем (обоснование оценки "
                          + "в соответствии с критериями, разработанными Банком)"
                          + form_dopf ("cust-corp","ОценкаРиска",?)).

      END.  /* cTypeCli <> "ЮЛ-1.1" */

      put unformatted "" skip (1).
      put unformatted "        Куратор счета                  /_____________________/ " skip (1).

      PUT UNFORMATTED "        Руководитель подразделения     /_____________________/ " SKIP(1).
      PUT UNFORMATTED "        Заполнил                       _________________ " mSigner SKIP.


    end. /* Юр.лица  (ф.ЮЛ-1) */

    /***** Физ.лица ******/
    if cTypeCli begins "Ч" AND
       NOT vFormL1Log then do:

       PAGE.
       put unformatted "                                                                               " skip.

       IF mClientType EQ "Клиент" THEN
          PUT UNFORMATTED "АНКЕТА КЛИЕНТА-ФИЗИЧЕСКОГО ЛИЦА ".
       ELSE
          PUT UNFORMATTED "АНКЕТА ВЫГОДОПРИОБРЕТАТЕЛЯ-ФИЗИЧЕСКОГО ЛИЦА ".
       PUT UNFORMATTED (if cTypeCli = "ЧП"
                        then "(ИНДИВИДУАЛЬНОГО ПРЕДПРИНИМАТЕЛЯ)"
                        else
                           if cTypeCli = "ЧЛ"
                           then "(НЕ ПРЕДПРИНИМАТЕЛЯ)"
                           else "")                                                                       skip.

       IF mClientType EQ "Выгодоприобретатель" THEN
          PUT UNFORMATTED "Сведения об основаниях, свидетельствующих о том, что клиент действует" SKIP
                          "к выгоде другого лица при проведении банковских операций и иных сделок" SKIP
                          mSVL SKIP(1).

       put unformatted " Часть 1 (табличная)                                                            " skip.
       run form_tabl ("51,61").
       put unformatted "┌───────────────────────────────────────────────────┬─────────────────────────────────────────────────────────────┐" skip.
       put unformatted "│Фамилия, имя и (если имеется) отчество             │". run form_main (2,0,string(person.name-last)).
                                                                                run form_main (2,9,string(person.first-names)).
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       put unformatted "│Дата рождения                                      │". run form_main (2,9,string(person.birthday)).
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       put unformatted "│Место рождения                                     │". run form_dop (2,9,"person","BirthPlace").
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       put unformatted "│Гражданство (подданство)                           │". run form_main (2,9,string(person.Country-id)).
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
IF cVerBankChar = "1" THEN /* 1 - RSHB: изм. 3.1; 3.2 */
DO:
/* 3.1 */       put unformatted "│Место прописки (регистрации)                       │". run form_main (2,9,string(fGetStrAdr(person.Address[1] + " " + person.Address[2]))).
                put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
/* 3.2 */       put unformatted "│Место проживания (нахождения)                      │". run form_main (2,9,string(fGetStrAdr(person.Address[1] + " " + person.Address[2]))).
END.
ELSE
DO:
       put unformatted "│Место жительства (регистрации)                     │". run form_main (2,9,string(fGetStrAdr(person.Address[1] + " " + person.Address[2]))).
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       PUT UNFORMATTED "│Место пребывания на территории РФ                  │".
                       RUN form_main (2,9,STRING(fGetStrAdr(GetXAttrValueEx(
                                                                            "person",
                                                                             STRING(person.person-id),
                                                                            "PlaceOfStay",
                                                                            "")
                                                              ))).
       PUT UNFORMATTED "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" SKIP.
END.

       IF cTypeCli EQ "Ч" OR cTypeCli EQ "ЧП" THEN
       DO:
          PUT UNFORMATTED
                       "│Адрес почтовый                                     │".
                       RUN form_main (2,9,STRING(fGetStrAdr(person.address[1] + " " + person.address[2]))).
          PUT UNFORMATTED "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" SKIP.
       END.
       put unformatted "│Сведения о лице, открывающем счет для физического  │                                                             │" skip.
       put unformatted "│лица (вносящем вклад в пользу физического лица)    │                                                             │" skip.
       put unformatted "│(в случае открытия счета (внесения вклада) не самим│                                                             │" skip.
       put unformatted "│физическим лицом)                                  │                                                             │" skip.
        run form_acct (1,"ДоверОткрСч").
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       put unformatted "│Сведения о документе, удостоверяющем личность      │". run form_main (2,9,string(person.Document-id)).
       put unformatted "│(наименование, серия и номер, орган, выдавший      │". run form_main (2,9,string(person.Document)).
       put unformatted "│документ, дата выдачи документа)                   │". run form_main (2,9,string(person.Issue)).
       put unformatted "│                                                   │". run form_dop (2,9,"person","Document4Date_vid").
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       put unformatted "│".
        run form_text (1,0,"Сведения о въездной визе (для лиц, не являющихся|"
                         + "гражданами Российской Федерации, если|"
                         + "международным договором Российской Федерации не|"
                         + "предусмотрен безвизовый въезд на территорию|"
                         + "Российской Федерации) (в том числе срок, на который|"
                         + "выдана виза)").
        run form_dop (2,9,"person","Visa").
       PUT UNFORMATTED "│".
        RUN form_text (1,0,"Данные миграционной карты").
        RUN form_dop (2,9,"person","МигрКарт").
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.

       if cTypeCli = "Ч" or cTypeCli = "ЧП" then do:
          put unformatted "│".
          run form_text (1,0,"Сведения о свидетельстве о регистрации в качестве|"
                            + "индивидуального предпринимателя (для|"
                            + "индивидуальных предпринимателей)|"
                            + "(номер свидетельства, дата и место выдачи, орган,|"
                            + "выдавший свидетельство, срок, на который выдано|"
                            + "свидетельство)").
          run form_dop (2,9,"person","СведРегПред").
          put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
          put unformatted "│".
          run form_text (1,0,"Вид предпринимательской деятельности (для|"
                            + "индивидуальных предпринимателей)|"
                            + "(в том числе производимые товары, выполняемые|"
                            + "работы, оказываемые услуги)").
          run form_dop (2,9,"person","ОснВидыДеят").
          put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
IF cVerBankChar = "1" THEN . /* 1 - RSHB: искл. 3.3 */
ELSE
DO:
          put unformatted "│".
          run form_text (1,0,"Вид предпринимательской деятельности (для|"
                            + "индивидуальных предпринимателей)|"
                            + "(в том числе производимые товары, выполняемые|"
                            + "работы, оказываемые услуги)").
          run form_dop (2,9,"person","ОснВидыДеят").
          put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
END.
          PUT UNFORMATTED "│".
          RUN form_text (1,0,"Сведения о наличии лицензий (разрешений) на |"
                            + "осуществление определенного вида деятельности|"
                            + "или операций (номер лицензии(разрешения), когда,|"
                            + "кем и на осуществление какого вида деятельности|"
                            + " (операции) выдана").
          RUN form_dop (2,9,"person","ЛицензОрг").
          PUT UNFORMATTED "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" SKIP.
       end.

       put unformatted "│Место работы и занимаемая должность                │". run form_dop (2,9,"person","Работа").
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       put unformatted "│Идентификационный номер налогоплательщика (при     │". run form_main (2,9,string(person.Inn)).
       put unformatted "│его наличии)                                       │                                                             │" skip.
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       put unformatted "│Номера контактных телефонов и факсов               │". run form_main (2,9,string(person.Phone[1])).
       put unformatted "│                                                   │". run form_main (2,9,string(person.Fax)).
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       put unformatted "│Адрес электронной почты                            │". run form_dop (2,9,"person","E-mail").
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       put unformatted "│Уровень риска                                      │". run form_dop (2,9,"person","РискОтмыв").
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       put unformatted "│Дата открытия первого счета.                       │".
        run form_acct (2,"MinDateOpen").
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       put unformatted "│Сотрудник, открывший счет                          │                                                             │" skip.
        run form_acct (1,"СотрОткрСч").
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       put unformatted "│Сотрудник, утвердивший открытие счета              │                                                             │" skip.
        run form_acct (1,"СотрУтвСч").
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       put unformatted "│Дата заполнения Анкеты клиента                     │" + vFStrDate(dDateIn) + FILL(" ",51)           + "│" skip.
       put unformatted "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" skip.
       PUT UNFORMATTED "│Дата обновления Анкеты клиента                     │" + vFStrDate(mDateRenewal) + FILL(" ",51)           + "│" SKIP.
       PUT UNFORMATTED "├───────────────────────────────────────────────────┼─────────────────────────────────────────────────────────────┤" SKIP.
       put unformatted "│Срок хранения Анкеты клиента                       │" + substr(string(cSrokSave) + FILL(" ",61),1,61)         + "│" skip.
       put unformatted "└───────────────────────────────────────────────────┴─────────────────────────────────────────────────────────────┘" skip.

       run form_tabl ("49,14,12").

       if page-size - line-counter < (7) then do:
          down(1) .
          page .
       end.

       put unformatted "                                                                               " skip.
       put unformatted " Часть 2 (в виде таблицы)                                                 " skip.
       put unformatted "┌─────────────────────────────────────────────────┬──────────────┬────────────┐" skip.
       put unformatted "│Операции, проводимые по счету                    │Число операций│Общая сумма │" skip.
       put unformatted "│(предполагаемые клиентом, если клиент ранее не   │ (за квартал) │(за квартал)│" skip.
       put unformatted "│ обслуживался)                                   │              │            │" skip.
        run form_acct (1,"ОперПоСч").
       put unformatted "├─────────────────────────────────────────────────┼──────────────┼────────────┤" skip.
       put unformatted "│Источники поступления денежных средств           │Число операций│Общая сумма │" skip.
       put unformatted "│(ожидаемые клиентом, если клиент ранее не        │ (за квартал) │(за квартал)│" skip.
       put unformatted "│обслуживался)                                    │              │            │" skip.
        run form_acct (1,"ИстПоступл").
       put unformatted "└─────────────────────────────────────────────────┴──────────────┴────────────┘" skip.

        run form_tabl ("99").

       if page-size - line-counter < (7) then do:
          down(1) .
          page .
       end.

       put unformatted "                                                                               " skip.
       put unformatted " Часть 3 (текстовая)                                                                            " skip.
       put unformatted "┌───────────────────────────────────────────────────────────────────────────────────────────────────┐" skip.
       put unformatted "│Характеристика операций                                                                            │" skip.
       put unformatted "│(оценка соотношения операций с деятельностью клиента, реальных оборотов по счету заявленным и т.д.)│" skip.
        run form_acct (1,"ХарОпер").
       put unformatted "└───────────────────────────────────────────────────────────────────────────────────────────────────┘" skip.

       if page-size - line-counter < (7) then do:
          down(1) .
          page .
       end.
       put unformatted "                                                                                                     " skip.
       put unformatted " Часть 4 (текстовая)                                                                            " skip.
       put unformatted "┌───────────────────────────────────────────────────────────────────────────────────────────────────┐" skip.
       put unformatted "│Оценка риска осуществления клиентом легализации (отмывания) доходов, полученных преступным путем,  │" skip.
       put unformatted "│финансирования терроризма (обоснование оценки в соответствии с критериями, разработанными кредитной│" skip.
       put unformatted "│организацией)                                                                                      │" skip.
       put unformatted "│". run form_dop (1,9,"person","ОценкаРиска").
       put unformatted "└───────────────────────────────────────────────────────────────────────────────────────────────────┘" skip(1).
       put unformatted "        ____________________________        _________________________                                " skip.
       PUT UNFORMATTED "        Сотрудник, открывший счет           Руководитель подразделения                               " SKIP(1).
       PUT UNFORMATTED "Заполнил  _________________ " mSigner SKIP.

    end. /* физ.лица */

    /***** Физ.лица ф.ЧЛ-1 ******/
    if cTypeCli = "ЧЛ-1" then do:

       c1Char = "".

       PAGE.
       run form_tabl ("78").
       PUT UNFORMATTED "ф." + REPLACE(cTypeCli,"Ч","Ф") AT 60 SKIP (2).

       IF mClientType EQ "Клиент" THEN
          PUT UNFORMATTED "                       АНКЕТА КЛИЕНТА-ФИЗИЧЕСКОГО ЛИЦА " SKIP (1).
       ELSE
          PUT UNFORMATTED "                 АНКЕТА ВЫГОДОПРИОБРЕТАТЕЛЯ-ФИЗИЧЕСКОГО ЛИЦА " SKIP (1).


       IF mClientType EQ "Выгодоприобретатель" THEN
          PUT UNFORMATTED "Сведения об основаниях, свидетельствующих о том, что клиент действует" SKIP
                          "к выгоде другого лица при проведении банковских операций и иных сделок" SKIP
                          mSVL SKIP(1).

       vIndxInt = INDEX(person.first-names," ").

       run form_main (1,9,"1.1. Фамилия " + string(person.name-last,fMaxLen(20,person.name-last)) + " "
                        + "Имя " + string(IF vIndxInt > 0
                                          THEN SUBSTR(person.first-names,1,vIndxInt)
                                          ELSE person.first-names) + "     "
                        + "Отчество " + string(IF vIndxInt > 0
                                               THEN substr(person.first-names,vIndxInt + 1)
                                               ELSE "")).
       run form_main (1,9,"1.2. Дата рождения " + string(string(person.birthday),"x(14)") + " "
                        + "1.3. Место рождения " + form_dopf ("person","BirthPlace",?)).
       run form_main (1,9,"1.4. Гражданство (подданство) " + person.Country-id ).
       run form_main (1,9,"1.5. Место прописки (регистрации) "
        + string(fGetStrAdr(person.Address[1] + " " + person.Address[2]))).
       RUN form_main (1,9,"1.6. Место пребывания на территории РФ " + STRING(fGetStrAdr(GetXAttrValueEx(
                                                                            "person",
                                                                             STRING(person.person-id),
                                                                            "PlaceOfStay",
                                                                            "")
                                                              ))).
       run form_main (1,9,"1.7. Место проживания (нахождения) "
                           + form_dopf ("person","country-id2",?) + " "
                           + form_dopf ("person","PlaceOfStay",?)).
       run form_main (1,9,"1.8. ИНН (если имеется) "
                            + IF person.inn = ? THEN "" ELSE string(person.inn)).
       run form_main (1,9,"1.9. Документ, удостоверяющий личность "
                           + string(person.Document-id,fMaxLen(15,person.Document-id)) + " "
                           + "серия " + string(person.Document) + " ").
       run form_main (1,9,"дата выдачи " + form_dopf ("person","Document4Date_vid",10) + " "
                        + "место выдачи " + string(person.Issue)).
       run form_main (1,9,"1.10. Сведения о въездной визе (для лиц, не являющихся "
                         + "гражданами Российской Федерации, если "
                         + "международным договором Российской Федерации не "
                         + "предусмотрен безвизовый въезд на территорию "
                         + "Российской Федерации)").
       run form_main (1,9,"Срок, на который выдана виза " + form_dopf ("person","Visa",?)).
       run form_main (1,9,"Снимите копию визы, либо страницы паспорта, содержащие "
                        + "соответствующие отметки, приобщите копию в качестве приложения.").
       RUN form_main (1,9,"1.11. Данные миграционной карты " + form_dopf ("person","МигрКарт",?)).
       run form_main (1,9,"1.12. Сведения о лице, открывающем счет для физического лица "
                        + "(вносящем вклад):").
       run form_main (1,9,"- физическое лицо: ").
       run form_acct (1,"ДоверОткрСч,Ч").
       run form_main (1,9,"- юридическое лицо: ").
       run form_acct (1,"ДоверОткрСч,Ю").

       run form_main (1,9,"1.13. Сведения о свидетельстве о регистрации в качестве "
                         + "индивидуального предпринимателя (для "
                         + "индивидуальных предпринимателей):").
       put unformatted    "      Номер свидетельства "
                        + form_dopf ("person","СведРегПред",20)
                        + " Дата выдачи "
                        + form_dopf ("person","ДатаВПред",10) SKIP.
       put unformatted    "      Орган, выдавший свидетельство "
                        + form_dopf ("person","ОргСведПред",?) SKIP.
       put unformatted    "      Место выдачи свидетельства "
                        + form_dopf ("person","МестСведПред",?) SKIP.
       put unformatted    "      Дата окончания действия свидетельства "
                        + form_dopf ("person","ДатаОкПред",?) SKIP.
       run form_main (1,9,"1.14. Место работы "
                        + form_dopf ("person","Работа",?)).
       run form_main (1,9,"Адрес места работы "
                        + form_dopf ("person","РаботаАдр",?)).
       run form_main (1,9,"Занимаемая должность "
                        + form_dopf ("person","Долж",?)).
       run form_main (1,9,"ИНН (если имеется) " + person.Inn).
       run form_main (1,9,"1.15. Тел.дом. " + STRING(person.phone[1],"x(15)") + " "
                        + "Тел.раб. " + STRING(person.phone[2],"x(15)")).
       put unformatted "      ".
       run form_main (1,9,"Тел.моб. " + STRING(" ","x(16)")
                        + "Факс     " + STRING(person.fax,"x(15)")).
       run form_main (1,9,"1.16. Уровень риска " + form_dopf ("person","РискОтмыв",?)).
       put unformatted "1.17. Дата открытия первого счета ".
       run form_tabl ("35,44").
       run form_acct (1,"MinDateOpen").
       run form_tabl ("25,54").
       put unformatted "1.18. Сотрудник, открывший счет" skip.
       run form_acct (1,"СотрОткрСч").
       put unformatted "1.19. Сотрудник Банка, утвердивший открытие счета " skip.
       run form_acct (1,"СотрУтвСч").
       run form_tabl ("78").
       run form_main (1,9,"1.20. Дата заполнения анкеты клиента " + vFStrDate(dDateIn)).
       RUN form_main (1,9,"1.21. Дата обновления анкеты клиента " + vFStrDate(mDateRenewal)).
       RUN form_main (1,9,"1.22. Срок хранения анкеты клиента " + SUBSTRING(STRING(cSrokSave),1,35)).

       run form_tabl ("49,14,12").

       put unformatted "" SKIP.
       put unformatted "2.1. Расходные операции, проводимые по счету.  Число операций Общая сумма " skip.
       put unformatted "(предполагаемые клиентом, если клиент ранее не  (за квартал)  (за квартал)" skip.
       put unformatted " обслуживался)                                                            " skip.
        run form_acct (1,"ОперПоСч").
       put unformatted "" SKIP.
       put unformatted "2.2. Источники поступления денежных средств.   Число операций Общая сумма " skip.
       put unformatted "(ожидаемые клиентом, если клиент ранее не       (за квартал)  (за квартал)" skip.
       put unformatted "обслуживался)                                                               " skip.
       run form_acct (1,"ИстПоступл").

       run form_tabl ("78").

       put unformatted "" SKIP.
       run form_main (1,9,"3.1. Характеристика операций (оценка соотношения"
                        + " операций с деятельностью клиента, реальных оборотов"
                        + " по счету заявленным и т.д.) (заполняется в процессе деятельности"
                        + " клиента.)").
       run form_acct (1,"ХарОпер").

       run form_main (1,9,"4.1. Оценка риска осуществления клиентом легализации (отмывания)"
                        + " доходов, полученных преступным путем (обоснование оценки "
                        + "в соответствии с критериями, разработанными Банком)"
                        + form_dopf ("cust-corp","ОценкаРиска",?)).

      put unformatted "" skip (1).
      put unformatted "        Куратор счета                  /_____________________/ " skip (1).

      put unformatted "        Руководитель подразделения     /_____________________/ " skip.

    end. /* физ.лица : cTypeCli = "ЧЛ-1" */

    /***** Банки ******/
    if cTypeCli = "Б" then do:
       PAGE.

       IF mClientType EQ "Клиент" THEN
          PUT UNFORMATTED "АНКЕТА КЛИЕНТА-КРЕДИТНОЙ ОРГАНИЗАЦИИ                                           " SKIP.
       ELSE
          PUT UNFORMATTED "АНКЕТА ВЫГОДОПРИОБРЕТАТЕЛЯ-КРЕДИТНОЙ ОРГАНИЗАЦИИ                               " SKIP.

       IF mClientType EQ "Выгодоприобретатель" THEN
          PUT UNFORMATTED "Сведения об основаниях, свидетельствующих о том, что клиент действует" SKIP
                          "к выгоде другого лица при проведении банковских операций и иных сделок" SKIP
                          mSVL SKIP(1).

       put unformatted " Часть 1 (табличная)                                                            " skip.
        run form_tabl ("41,35").
       put unformatted "┌─────────────────────────────────────────┬───────────────────────────────────┐" skip.
       put unformatted "│".
        run form_text (1,0,"Фирменное (полное официальное) и|"
                         + "(в случае,если имеется) сокращенное|"
                         + "наименование и наименование на|"
                         + "иностранном языке").
        run form_main (2,0,string(banks.name)).
        run form_main (2,9,string(banks.short-name)).
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Организационно-правовая форма            │". run form_nsi (2,9,"banks","bank-stat","КодПредп").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Регистрационный номер                    │". run form_dop (2,9,"banks","RegNum").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Дата государственной регистрации         │". run form_dop (2,9,"banks","RegDate").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Место государственной регистрации        │". run form_dop (2,0,"banks","RegPlace").
                                                                      run form_dop (2,9,"banks","Country-id2").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│".
        run form_text (1,0,"Вид лицензии на осуществление банковских|"
                         + "операций").
        run form_nsi (2,9,"banks","ВидБанкЛиц","ВидБанкЛиц").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Номер лицензии                           │". run form_bank (2,9,"RegN").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Дата выдачи лицензии                     │". run form_dop (2,9,"banks","DataLic").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Адрес местонахождения                    │". run form_main (2,0,string(banks.law-address)).
                                                                      run form_main (2,9,string(banks.Country-ID)).
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Почтовый адрес                           │". run form_main (2,9,string(banks.mail-address)).
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Номера контактных телефонов и факсов     │". run form_dop (2,9,"banks","Tel").
       put unformatted "│                                         │". run form_dop (2,9,"banks","Fax").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Адрес электронной почты                  │". run form_dop (2,9,"banks","e-mail").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Банковский идентификационный код         │". run form_bank (2,9,"МФО-9").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Идентификационный номер налогоплательщика│".
                        if banks.country-id = "RUS" or banks.country-id = ""  /* резидент */
                           then run form_bank (2,9,"ИНН").
                           else run form_dop (2,9,"banks","ИИН").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Kоды форм федерального государственного  │". run form_dop (2,9,"banks","okpo").
IF cVerBankChar = "1" THEN /* 1 - RSHB: добавл. 1.1 */
DO:
/* 1.1 */  put unformatted "│статистического наблюдения               │". run form_main (2,9,"ОКВЭД " + form_dopf ("banks","ОКВЭД",?)).  /* run form_dop (2,9,"banks","okonx"). */
END.
ELSE
DO:
       put unformatted "│статистического наблюдения               │                                   │" skip.
END.
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Уровень риска                            │". run form_dop (2,9,"banks","РискОтмыв").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Дата открытия первого счета.             │".
        run form_acct (2,"MinDateOpen").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Kуратор счета :                          │                                   │" skip.
        run form_acct (1,"curator").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Резервный куратор счета (если существует)│нет                                │" skip.
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Сотрудник, утвердивший открытие счета    │                                   │" skip.
        run form_acct (1,"СотрУтвСч").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Дата заполнения Анкеты клиента           │" + vFStrDate(dDateIn) + FILL(" ",25) + "│" skip.
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       PUT UNFORMATTED "│Дата обновления Анкеты клиента           │" + vFStrDate(mDateRenewal) + FILL(" ",25) + "│" SKIP.
       PUT UNFORMATTED "├─────────────────────────────────────────┼───────────────────────────────────┤" SKIP.
       put unformatted "│Срок хранения Анкеты клиента             │" + substr(string(cSrokSave) + FILL(" ",35),1,35) + "│" skip.
       put unformatted "└─────────────────────────────────────────┴───────────────────────────────────┘" skip.
       put unformatted "                                                                               " skip.

       if page-size - line-counter < (7) then do:
          down(1) .
          page .
       end.

       put unformatted " Часть 2 (текстовая)                                                           " skip.
       put unformatted "┌─────────────────────────────────────────┬───────────────────────────────────┐" skip.
/*       put unformatted "│".*/
IF cVerBankChar = "1" THEN /* 1 - RSHB: изм. 1.2 */
DO:
/* 1.2 */  run form_text (1,0,"Сведения об учредителях, лицах, которые|"
                         + "имеют право давать обязательные для|"
                         + "клиента указания либо иным образом|"
                         + "имеют возможность определять его|"
                         + "действия, в том числе сведения об|"
                         + "основном обществе или преобладающем|"
                         + "участвующем обществе (для дочерних или|"
                         + "зависимых обществ), холдинговой или|"
                         + "финансово-промышленной группе (если|"
                         + "клиент в ней участвует)").
END.
ELSE
DO:
/*        run form_text (1,0,"Сведения об учредителях, лицах, которые|"
                         + "имеют право давать обязательные для|"
                         + "клиента указания либо иным образом|"
                         + "имеют возможность определять его|"
                         + "действия, в том числе сведения об|"
                         + "основном обществе или преобладающем|"
                         + "участвующем обществе (для дочерних или|"
                         + "зависимых обществ), холдинговой или|"
                         + "финансово-промышленной группе (если|"
                         + "клиент в ней участвует) (заполняется с|"
                         + "учетом подпунктов 2.2.3 и 2.2.4|"
                         + "настоящих Рекомендаций)").*/
END.
/*       run form_dop (2,9,"banks","УчредОрг").*/
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│".
IF cVerBankChar = "1" THEN /* 1 - RSHB: изм. 1.3 */
DO:
/* 1.3 */  run form_text (1,0,"Сведения об органах клиента (структура|"
                         + "органов управления юридического лица и|"
                         + "сведения о физических лицах, входящих |"
                         + "в состав исполнительных органов|"
                         + "юридического лица").
END.
ELSE
DO:
        run form_text (1,0,"Сведения об органах клиента (структура|"
                         + "органов управления юридического лица и|"
                         + "сведения о физических лицах, входящих |"
                         + "в состав исполнительных органов|"
                         + "юридического лица, с учетом подпунктов|"
                         + "2.2.3 и 2.2.4 настоящих Рекомендаций)").
END.
       run form_dop (2,9,"banks","СтруктОрг").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│".
        run form_text (1,0,"Обособленные подразделения (если имеются|"
                         + "и сведения о них известны|"
                         + "кредитной организации)").
        run form_dop (2,9,"banks","ОбособПодр").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│Сведения о корреспондентах клиента       │". run form_dop (2,9,"banks","ПостКорресп").
       put unformatted "├─────────────────────────────────────────┼───────────────────────────────────┤" skip.
       put unformatted "│".
        run form_text (1,0,"История, репутация, сектор рынка и|"
                         + "конкуренция (сведения, подтверждающие|"
                         + "существование кредитной организации|"
                         + "(например, ссылка на Bankers Almanac),|"
                         + "сведения о реорганизации, изменения в|"
                         + "характере деятельности, прошлые|"
                         + "финансовые проблемы, репутация на|"
                         + "национальном и зарубежных рынках,|"
                         + "присутствие на рынках, основная доля|"
                         + "в конкуренции и на рынке, специализация|"
                         + "по банковским продуктам и пр.)").
        run form_dop (2,9,"banks","ИсторияКл").
       put unformatted "└─────────────────────────────────────────┴───────────────────────────────────┘" skip.

       run form_tabl ("49,14,12").

       if page-size - line-counter < (7) then do:
          down(1) .
          page .
       end.

       put unformatted " Часть 3 (в виде таблицы)                                                 " skip.
       put unformatted "┌─────────────────────────────────────────────────┬──────────────┬────────────┐" skip.
       put unformatted "│Операции, проводимые по счету                    │Число операций│Общая сумма │" skip.
       put unformatted "│(предполагаемые клиентом, если клиент ранее не   │ (за квартал) │(за квартал)│" skip.
       put unformatted "│ обслуживался)                                   │              │            │" skip.
        run form_acct (1,"ОперПоСч").
       put unformatted "├─────────────────────────────────────────────────┼──────────────┼────────────┤" skip.
       put unformatted "│Источники поступления денежных средств           │Число операций│Общая сумма │" skip.
       put unformatted "│(ожидаемые клиентом, если клиент ранее не        │ (за квартал) │(за квартал)│" skip.
       put unformatted "│обслуживался)                                    │              │            │" skip.
        run form_acct (1,"ИстПоступл").
       put unformatted "└─────────────────────────────────────────────────┴──────────────┴────────────┘" skip.
       put unformatted "                                                                               " skip.

       run form_tabl ("77").

       if page-size - line-counter < (7) then do:
          down(1) .
          page .
       end.

       put unformatted " Часть 4 (текстовая)                                                           " skip.
       put unformatted "┌─────────────────────────────────────────────────────────────────────────────┐" skip.
       put unformatted "│Характеристика операций (оценка соотношения операций с деятельностью клиента,│" skip.
       put unformatted "│реальных оборотов по счету заявленным и т.д.)                                │" skip.
       put unformatted "│                                                                             │" skip.
        run form_acct (1,"ХарОпер").
       put unformatted "└─────────────────────────────────────────────────────────────────────────────┘" skip.
       put unformatted "                                                                               " skip.
       put unformatted " Часть 5 (текстовая)                                                           " skip.
       put unformatted "┌─────────────────────────────────────────────────────────────────────────────┐" skip.
       put unformatted "│Оценка риска осуществления клиентом легализации (отмывания) доходов,         │" skip.
       put unformatted "│полученных преступным путем и финансирования терроризма,                     │" skip.
       put unformatted "│(обоснование оценки всоответствии с критериями, разработанными кредитной     │" skip.
       put unformatted "│организацией)                                                                │" skip.
       put unformatted "│". run form_dop (1,9,"banks","ОценкаРиска").
       put unformatted "└─────────────────────────────────────────────────────────────────────────────┘" skip(1).
       put unformatted "        ____________________________        _________________________          " skip.
       PUT UNFORMATTED "        Куратор счета                       Руководитель подразделения         " SKIP(1).
       PUT UNFORMATTED "        Заполнил  _________________ " mSigner SKIP.

    end. /***** Банки ******/

    /***** Банки (ф.ЮЛКО-1) ******/

    if cTypeCli = "БЛ-1" then do:

       c1Char = "".

       PAGE.
       run form_tabl ("78").
       put unformatted "ф. ЮЛКО-1" at 60 skip (2).

       IF mClientType EQ "Клиент" THEN
          PUT UNFORMATTED "                       АНКЕТА КЛИЕНТА-КРЕДИТНОЙ ОРГАНИЗАЦИИ" SKIP(1).
       ELSE
          PUT UNFORMATTED "                 АНКЕТА ВЫГОДОПРИОБРЕТАТЕЛЯ-КРЕДИТНОЙ ОРГАНИЗАЦИИ" SKIP(1).

       IF mClientType EQ "Выгодоприобретатель" THEN
          PUT UNFORMATTED "Сведения об основаниях, свидетельствующих о том, что клиент действует" SKIP
                          "к выгоде другого лица при проведении банковских операций и иных сделок" SKIP
                          mSVL SKIP(1).


       run form_main (1,9,"1.1  Полное наименование "            + banks.name).
       run form_main (1,9,"1.2  Краткое наименование "           + banks.short-name).
       run form_main (1,9,"1.3. Фирменное наименование " + form_dopf ("banks","brand-name",?)).
       run form_main (1,9,"1.4. Наименование на иностранном языке (если имеется) "
                        + form_dopf ("banks","swift-name",?)).
       put unformatted "1.5. Организационно-правовая форма ".
       run form_nsi  (1,9,"banks","bank-stat","КодПредп").
       run form_main (1,9,"1.6. Регистрационный номер "         + form_dopf ("banks","RegNum",?)).
       run form_main (1,9,"1.7. Дата гос. регистрации "         + form_dopf ("banks","RegDate",?)).
       run form_main (1,9,"1.8. Место гос. регистрации "        + form_dopf ("banks","RegPlace",?)).
       run form_main (1,9,"1.9. Вид лицензии на осуществление банковских операций "
                        + form_nsif  ("banks","ВидБанкЛиц","ВидБанкЛиц",?)).
       put unformatted "1.10. Номер лицензии " + form_bankf ("RegN",19)
                     + "1.11. Дата выдачи лицензии " + form_dopf ("banks","DataLic",?) SKIP.


       run form_main (1,9,"1.12. Адрес места нахождения "
                         + banks.mail-address + " "
                         + banks.Country-ID).
       run form_main (1,9,"1.13. Юридический адрес "
                         + banks.law-address + " "
                         + banks.Country-ID).
       run form_main (1,9,"1.14.  Тел. Руководителя "
                        + form_dopf ("banks","Tel",15)
                        + "e-mail "
                        + form_dopf ("banks","e-mail",?)).
       put unformatted "       Тел. Гл. Бухгалт.                e-mail" SKIP
                       "       Тел. Секретариата                "
                       "Факс " + form_dopf ("banks","Fax",?) SKIP.
       put unformatted "1.15. БИК ".
       run form_bank (1,9,"МФО-9").
       run form_main (1,9,"1.16. ИНН "       + IF banks.inn = ?
                                               THEN ""
                                               ELSE string(banks.inn)).
       run form_main (1,9,"1.17. Код ОКПО "  + form_dopf ("banks","okpo",25)
                      + " Коды ОКВЭД " + form_dopf ("banks","ОКВЭД",?)).
       run form_main (1,9,"1.18. Уровень риска " + form_dopf ("banks","РискОтмыв",?)).
       put unformatted "1.19. Дата открытия первого счета ".
       run form_tabl ("35,44").
       run form_acct (1,"MinDateOpen").
       run form_tabl ("25,54").
       put unformatted "1.20. Куратор счета" skip.
       run form_acct (1,"curator").

       run form_tabl ("78").

       put unformatted "1.21. Резервный куратор счета (если существует) " SKIP.
       put unformatted "1.22. Сотрудник Банка, утвердивший открытие счета " SKIP.
       run form_acct (1,"СотрУтвСч").
       run form_main (1,9,"1.23. Дата заполнения анкеты клиента " + vFStrDate(dDateIn)).
       RUN form_main (1,9,"1.24. Дата обновления анкеты клиента " + vFStrDate(mDateRenewal)).
       RUN form_main (1,9,"1.25. Срок хранения анкеты клиента " + SUBSTRING(STRING(cSrokSave),1,35)).

       run form_main (1,9,"2.1. Сведения об учредителях (участниках), собственниках"
                        + " имущества юридического лица, лицах, которые имеют право"
                        + " давать обязательные для юридического лица указания либо"
                        + " иным образом имеют возможность определять его решения,"
                        + " в том числе сведения об основном обществе или преобладающем,"
                        + " участвующем обществе (для дочерних или зависимых обществ),"
                        + " холдинговой компании или финансово-промышленной группе"
                        + " (если клиент в ней участвует). "
                        + form_dopf ("banks","УчредОрг",?)).
       run form_main (1,9,"2.2. Сведения об органах юридического лица"
                        + " (структура органов управления юридического лица и сведения"
                        + " о физических лицах, входящих в состав исполнительных органов"
                        + " юридического лица). "
                        + form_dopf ("banks","СтруктОрг",?)).
       run form_main (1,9,"2.3. Обособленные подразделения "
                        + form_dopf ("banks","ОбособПодр",?)).
       run form_main (1,9,"2.4. Сведения о корреспондентах клиента (недавно начавшие"
                        + " деятельность клиенты, указывают предполагаемых корреспондентов,"
                        + "если таковые имеются). " + form_dopf ("banks","ПостКорресп",?)).
       run form_main (1,9,"2.5. История, репутация, сектор рынка и конкуренция"
                        + " (сведения, подтверждающие существование кредитной организации"
                        + " (например, ссылка на Bankers Almanac), сведения о реорганизации,"
                        + " изменения в характере деятельности, прошлые финансовые проблемы,"
                        + " репутация на национальном и зарубежных рынках, основные обслуживаемые"
                        + " рынки, присутствие на рынках, основная доля в конкуренции на рынке,"
                        + " специализация по банковским продуктам и пр.) (ненужное зачеркнуть). "
                        + form_dopf ("banks","ИсторияКл",?)).
       run form_main (1,9,"   - информация клиентом не предоставлена.").
       run form_main (1,9,"   - информация клиентом предоставлена, приложение приобщено к анкете.").
       run form_main (1,9,"Данная информация подается клиентом, при ее наличии, в свободном виде"
                        + " и приобщается к анкете в качестве приложения.").

       run form_tabl ("49,14,12").

       put unformatted "" SKIP.
       put unformatted "3.1. Расходные операции, проводимые по счету.  Число операций Общая сумма " skip.
       put unformatted "(предполагаемые клиентом, если клиент ранее не  (за квартал)  (за квартал)" skip.
       put unformatted " обслуживался)                                                            " skip.
        run form_acct (1,"ОперПоСч").
       put unformatted "" SKIP.
       put unformatted "3.2. Источники поступления денежных средств.   Число операций Общая сумма " skip.
       put unformatted "(ожидаемые клиентом, если клиент ранее не       (за квартал)  (за квартал)" skip.
       put unformatted "обслуживался)                                                               " skip.
       run form_acct (1,"ИстПоступл").

       run form_tabl ("78").

       put unformatted "" SKIP.
       run form_main (1,9," 4.1. Характеристика операций (оценка соотношения"
                        + " операций с деятельностью клиента, реальных оборотов"
                        + " по счету заявленным и т.д.) (заполняется в процессе деятельности"
                        + " клиента.)").
       run form_acct (1,"ХарОпер").

       run form_main (1,9,"5.1. Оценка риска осуществления клиентом легализации (отмывания)"
                        + " доходов, полученных преступным путем (обоснование оценки "
                        + "в соответствии с критериями, разработанными Банком). "
                        + form_dopf ("banks","ОценкаРиска",?)).


       put unformatted "" skip (1).
       put unformatted "        Куратор счета                  /_____________________/ " skip (1).

       PUT UNFORMATTED "        Руководитель подразделения     /_____________________/ " SKIP(1).
       PUT UNFORMATTED "        Заполнил                        _________________ " mSigner SKIP.


      END.  /* cTypeCli =  "БЛ-1" */

    run form_tabl ("").

    run DEL_RID_ACCT.

end.

{intrface.del comm}
{intrface.del xclass}
{preview.i}

