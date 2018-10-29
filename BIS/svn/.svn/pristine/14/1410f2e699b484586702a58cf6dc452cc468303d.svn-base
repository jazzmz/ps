/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1998 ТОО "Банковские информационные системы"
     Filename: pp-new1.prg
      Comment: Библиотека процедур используемых при печати платежного поручения
   Parameters:
         Uses: banknm.lf bankct.lf x-amtstr.p wordwrap.i
      Used by: pp-new1.p
      Created: 20.12.1999 Kostik
     Modified: 09.02.2000 Kostik Добавлена новая ветка
                                                       (счет плательщика = счету дебета
                                                        счет получателя  = счету кредита)
     Modified: 28.07.2003 Guva заявка 15378 добавлено поле дата перечисления платежа
     Modified: 25/07/2003 kraw (0018163) Если нет счета в банке, то брать из реквизита получателя
     Modified: 13/08/2003 Gorm (0018681) Спецпатч С09. Перенесена функциональность из стандартной версии
                                         (з. 18163), оставлена спец. функциональность - з. 15378.
     Modified: 16.09.2003 12:15 DEMA     (0019306) Поднято в DPL-Intesa из 41C-09
                                         для внесения изменений.
     Modified: 16.09.2003 13:50 DEMA     (0019306) Изменен алгоритм печати поля
                                         "Списано со счета плательщика": если
                                         задан допреквизит user-proc.СписСчета,
                                         поле печатается в любот случае, если
                                         пустое - подставляется op.op-date.
     Modified: 15/06/2004 kraw (0021242) Рез. поле для банков-клиентов
*/
Form "~n@(#) pp-new1.prg 1.0 Kostik 20.12.1999 Kostik 20.12.1999 Библиотека процедур для печати платежных поручений" with frame sccs-id width 250.
{get-bankname.i}
{opcertif.pro} /* Подписи документа сертификатами */

{op-ident.i}

/*    форма для печати в test.pp*/
DEFINE FRAME testprn
      Info-Store.info-id       FORMAT "x(14)"
      Info-Store.inn           FORMAT "x(14)"
      Info-Store.flag          FORMAT "x(14)"
      Info-Store.code          FORMAT "x(14)"
      Info-Store.acct          FORMAT "x(30)"
      Info-Store.corr-acct     FORMAT "x(30)"
      Info-Store.acct-type     FORMAT "x(10)"
      Info-Store.acct-cat      FORMAT "x(1)"
      Info-Store.bank-id       FORMAT ">>>>>>>>>9"
      Info-Store.name          FORMAT "x(40)"
      Info-Store.Sh-name       FORMAT "x(40)"
      Info-Store.address       FORMAT "x(60)"
      Info-Store.corr-acct1    FORMAT "x(60)"
      Info-Store.flag-rkc      FORMAT "x(60)"
      Info-Store.flag-client   FORMAT "x(60)"
      Info-Store.flag-balchinn FORMAT "x(60)"
      Info-Store.category      FORMAT "x(60)"
   WITH WIDTH 100.
/********       Добавления для инктрукции 1256 У        ***********************/

/* Использовать ли op.op-date в поле "Списано со счета" расчетных документов */
FUNCTION UseOpDate LOGICAL:
   DEFINE VARIABLE vPrName AS CHARACTER NO-UNDO.

   vPrName = program-name(1).
   vPrName = ENTRY(NUM-ENTRIES(vPrName," "),vPrName," ").
   vPrName = ENTRY(NUM-ENTRIES(vPrName,"/"),vPrName,"/").
   vPrName = ENTRY(NUM-ENTRIES(vPrName,"~\"),vPrName,"~\").
   vPrName = ENTRY(1,vPrName,".").

   FIND FIRST user-proc
      WHERE user-proc.procedure EQ vPrName
        AND user-proc.partition EQ "ПЕЧДОКУМ"
      NO-LOCK NO-ERROR.

   IF NOT AVAIL(user-proc)
      THEN RETURN NO.
      ELSE RETURN GetXAttrValue("user-proc", STRING(user-proc.public-number), "СписСчета") = "Да".
END FUNCTION.

PROCEDURE GetDopParam:
   /*Инициализация дополнительных параметров добавленных в соответствии с требованиями 1256-У*/
   ASSIGN
      mKBK    = GetXAttrValueEx("op",STRING(op.op),"КБК"," ")
      mOKATO  = GetXAttrValueEx("op",STRING(op.op),"ОКАТО-НАЛОГ","")
      mPokOp  = GetXAttrValueEx("op",STRING(op.op),"ПокОП","")
      mPokNP  = GetXAttrValueEx("op",STRING(op.op),"ПокНП","")
      mPokND  = GetXAttrValueEx("op",STRING(op.op),"ПокНД","")
      mPokDD  = GetXAttrValueEx("op",STRING(op.op),"ПокДД","")
      mPokTP  = GetXAttrValueEx("op",STRING(op.op),"ПокТП","")
      mPokST  = GetXAttrValueEx("op",STRING(op.op),"ПокСТ","")
      mSpisPl = GetXAttrValueEx("op",STRING(op.op),"СписСчета","")
   .
   mSpisPl = STRING(DATE(mSpisPl),"99.99.9999") NO-ERROR.
   IF ERROR-STATUS:ERROR THEN mSpisPl = ?.

   IF mSpisPl = ? AND UseOpDate() THEN
      mSpisPl = STRING(op.op-date, "99.99.9999").

   IF mSpisPl = ? THEN mSpisPl = "".

   &IF DEFINED(uni1) NE 0 &THEN
   IF op.user-id = "SERV" THEN
   DO:
      FIND FIRST acct WHERE acct.acct = op-entry.acct-cr NO-LOCK NO-ERROR.
      FIND FIRST _user WHERE _user._userid = acct.user-id NO-LOCK.
   END.
   ELSE
      FIND FIRST _user WHERE _user._userid = op.user-id NO-LOCK.

   FIND FIRST op-impexp OF op NO-LOCK NO-ERROR.
   ASSIGN
      theHeader = cBankName + " " +
                  "ВРЕМЯ ВВОДА " +
                  (IF AVAIL op-impexp AND op-impexp.imp-date <> ? THEN
                     STRING(op-impexp.imp-time, "hh:mm")
                  ELSE "?") + " " + "НОМЕР РЕЙСА " +
                  (IF AVAIL op-impexp THEN STRING(op-impexp.imp-batch) ELSE "?")
      theBank = cBankNameSPlat
      theBank = FILL(" ", INT((22 - LENGTH(theBank)) / 2)) + theBank
      theCity = FGetSetting("БанкГород",?,"")
      theCity = FILL(" ", INT((22 - LENGTH(theCity)) / 2)) + theCity
      .
   &ENDIF

   /*Инициализация дополнительных параметров добавленных в соответствии с требованиями ВТБ*/
   &IF DEFINED(uni2) NE 0 &THEN
   IF op.user-id = "SERV" THEN
   DO:
      FIND FIRST acct WHERE acct.acct = op-entry.acct-cr NO-LOCK NO-ERROR.
      FIND FIRST _user WHERE _user._userid = acct.user-id NO-LOCK.
   END.
   ELSE
      FIND FIRST _user WHERE _user._userid = op.user-id NO-LOCK.
   ASSIGN
      theUserName = FILL(" ", INT((22 - LENGTH(_user._user-name)) / 2)) +
                   _user._user-name
      theBank = FGetSetting("БанкСПлат",?,FGetSetting("БанкС",?,""))
      theBank = FILL(" ", INT((22 - LENGTH(theBank)) / 2)) + theBank
      theCity = FGetSetting("БанкГород",?,"")
      theCity = FILL(" ", INT((22 - LENGTH(theCity)) / 2)) + theCity.
   &ENDIF

END PROCEDURE.

FUNCTION ConvertNameINN RETURNS CHAR(INPUT iINN     AS CHARACTER,
                                     INPUT iRecSend AS LOGICAL):
   DEFINE VARIABLE vKPP AS CHARACTER INIT "" NO-UNDO. /*?*/
   &IF DEFINED(NEW_1256) EQ 0 &THEN
      ASSIGN
         vKPP = GetXAttrValueEx("op",STRING(op.op),"Kpp-send","") WHEN NOT iRecSend
         vKPP = GetXAttrValueEx("op",STRING(op.op),"Kpp-rec","")  WHEN iRecSend
      .
      IF iINN EQ ? OR iINN EQ "" THEN
      RETURN ("").
      ELSE
      RETURN ("ИНН " +
              iINN   + " " +
              (IF vKPP NE "" THEN ("КПП " + vKPP + " ") ELSE "")
             ).
   &ELSE
      ASSIGN
         PlINN = iINN WHEN NOT iRecSend
         PoINN = iINN WHEN iRecSend
         PlKPP = GetXAttrValueEx("op",STRING(op.op),"Kpp-send","")
         PoKPP = GetXAttrValueEx("op",STRING(op.op),"Kpp-rec","")

      .
      RETURN "".
   &ENDIF
END.
/******************************************************************************/
                  /* наличие описания процедуры */

FUNCTION AvailProc RETURN LOGICAL (INPUT inProc AS CHAR):
  RETURN LOOKUP(inProc, THIS-PROCEDURE:INTERNAL-ENTRIES) <> 0.
END.

/* выбор функции пользователя или по умолчанию */

FUNCTION GetProcName RETURN CHAR (INPUT inProc AS CHAR):
  RETURN (IF AvailProc("Get" + inProc) THEN "Get" ELSE (IF AvailProc("Def" + inProc) THEN "Def" ELSE "")) + inProc.
END.

FUNCTION ProcAvail RETURN LOGICAL (INPUT inProc AS CHAR, INPUT inRoot AS CHAR, OUTPUT NameProc AS CHAR):
  NameProc = "".
  IF AvailProc("Get" + inRoot + inProc) THEN  NameProc = "Get" + inRoot + inProc.
  ELSE IF AvailProc("Get" + inProc) THEN NameProc = "Get" + inProc.
  ELSE IF AvailProc("Def" + inRoot + inProc) THEN NameProc = "Def" + inRoot + inProc.
  ELSE IF AvailProc("Def" + inProc) THEN NameProc = "Def" + inProc.
  RETURN NameProc <> "".
END.

/* выполнить стандартную или пользовательскую функцию */

PROCEDURE RunAvailProc:
  DEF INPUT PARAM inProc AS CHAR NO-UNDO.
  DEF VAR Proc2Run AS CHAR NO-UNDO.
/* --- */
  Proc2Run = GetProcName(inProc).
  IF Proc2Run <> inProc THEN RUN VALUE(Proc2Run).
END PROCEDURE.

/* стандартный заголовок, дата, тип платежа */

PROCEDURE DefHeader:
  &GLOB perm-uer "1,3"
  DEF VAR is-electro AS LOGICAL NO-UNDO.
  DEF VAR mfo-code     AS CHARACTER NO-UNDO.
  DEF VAR set-electro  AS CHARACTER NO-UNDO.
  DEF VAR set-mail     AS CHARACTER NO-UNDO.
  DEF VAR set-telegraf AS CHARACTER NO-UNDO.

  DEFINE BUFFER cacct FOR acct.

  set-electro  = FGetSetting("ТехПлат","ТПЭлектронный",?).
  set-mail     = FGetSetting("ТехПлат","ТППочта",?).
  set-telegraf = FGetSetting("ТехПлат","ТПТелеграф",?).

  ASSIGN
    NameOrder  = "ПЛАТЕЖНОЕ ПОРУЧЕНИЕ N"
    NumberForm = "0401060".
  theDate = IF op.doc-date <> ? THEN STRING(op.doc-date, "99.99.9999")
                                ELSE STRING(op.op-date, "99.99.9999").
/*  is-electro = NO.
  FIND Info-Store WHERE Info-Store.Info-ID EQ "БАНКПОЛ" NO-LOCK NO-ERROR.
  IF AVAIL Info-Store AND Info-Store.code NE ? AND Info-Store.code NE "" THEN DO:
     IF Info-Store.bank-id NE ? THEN
        FIND banks WHERE banks.bank-id EQ Info-Store.bank-id NO-LOCK NO-ERROR.
     ELSE DO:
        FIND banks-code WHERE banks-code.bank-code-type EQ "МФО-9"
                          AND banks-code.bank-code      EQ Info-Store.code
                                                        NO-LOCK NO-ERROR.
        FIND banks OF banks-code NO-LOCK NO-ERROR.
     END.

     FIND FIRST signs WHERE signs.file = "banks"
                        AND signs.surr = string(banks.bank-id)
                        AND signs.code = "uer" NO-LOCK NO-ERROR.
     {get_set2.i "МЦИ" "perm-uer" "w/o check"}
     IF AVAIL signs AND (LOOKUP(signs.xattr,IF AVAIL setting THEN setting.val
                                                             ELSE {&perm-uer}) <> 0) THEN DO:
        {get_set2.i "МЦИ" "reg-mask"}
        IF AVAIL setting AND CAN-DO(setting.val, Info-Store.code) THEN
           is-electro = yes.
        ELSE DO:
           {get_set2.i "МЦИ" "dt-always"}
           IF NOT (AVAIL setting AND CAN-DO(setting.val, op.doc-type)) THEN
           is-electro=yes.
        END.
     END.
  END.*/
/*  IF NOT is-electro THEN DO:*/
     IF CAN-DO(set-mail,&IF defined(tt-op-entry) <> 0 &THEN tt-op-entry.type &ELSE op-entry.type &ENDIF) THEN PayType = "     почтой     ".
     ELSE IF CAN-DO(set-telegraf,&IF defined(tt-op-entry) <> 0 &THEN tt-op-entry.type &ELSE op-entry.type &ENDIF) THEN PayType = "   телеграфом   ".
     ELSE IF CAN-DO(set-electro,&IF defined(tt-op-entry) <> 0 &THEN tt-op-entry.type &ELSE op-entry.type &ENDIF)  THEN PayType = "   электронно   ".
     ELSE PayType = "".
/*  END.
  ELSE
     PayType = "   электронно   ".*/
  {get_set.i "ВидПлатОбяз"}
  IF (AVAIL setting AND (setting.val EQ "НЕТ" OR setting.val EQ ?)) OR NOT AVAIL setting THEN DO:
     {get_set2.i "МЦИ" "reg-mask"}
     IF  AVAIL setting
     AND CAN-DO(setting.val, PoMFO)
     AND CAN-DO(setting.val, PlMFO)
     AND TRIM(PayType) EQ "электронно" THEN
        PayType = "".
  END.
  mPPDate = "".

  FIND FIRST cacct WHERE cacct.acct     EQ op-entry.acct-cr 
                     AND cacct.currency EQ op-entry.currency
     NO-LOCK NO-ERROR.

  IF AVAILABLE cacct THEN

     IF cacct.cust-cat EQ "Б" THEN

        FOR FIRST banks WHERE banks.bank-id EQ cacct.cust-id
           AND NOT banks.flag-rkc NO-LOCK:

           IF CAN-DO(FGetSetting("НазнСчМБР", "", "*empty*"), cacct.contract) THEN
              mPPDate = STRING(op.op-value-date, "99.99.9999").
        END.
END PROCEDURE.

/* стандартный расчет суммы */

PROCEDURE DefAmt:
  DEFINE VAR in-amt  AS DECIMAL   NO-UNDO.
  DEFINE VAR in-curr AS CHARACTER NO-UNDO.

  &IF defined(tt-op-entry) = 0 &THEN
  ASSIGN
     in-amt  = IF op-entry.amt-cur EQ 0 THEN op-entry.amt-rub
                                        ELSE op-entry.amt-cur
     in-curr = IF op-entry.amt-cur EQ 0 THEN ""
                                        ELSE op-entry.currency
  .
  &ELSE
  ASSIGN
     in-amt  = IF tt-op-entry.amt-cur EQ 0 THEN tt-op-entry.amt-rub
                                        ELSE tt-op-entry.amt-cur
     in-curr = IF tt-op-entry.amt-cur EQ 0 THEN ""
                                        ELSE tt-op-entry.currency
  .
  &ENDIF

  RUN x-amtstr.p(in-amt,in-curr, TRUE, TRUE, OUTPUT amtstr[1], OUTPUT amtstr[2]).
  IF TRUNC(in-amt, 0) = in-amt THEN
    ASSIGN
      Rub       = STRING(STRING(in-amt * 100, "-zzzzzzzzzz999"), "x(12)=")
      AmtStr[2] = ''
    .
  ELSE
    ASSIGN
      Rub       = STRING(STRING(in-amt * 100, "-zzzzzzzzzz999"), "x(12)-x(2)")
      AmtStr[1] = AmtStr[1] + ' ' + AmtStr[2]
    .
  SUBSTR(AmtStr[1], 1, 1) = CAPS(SUBSTR(AmtStr[1], 1, 1)).
END PROCEDURE.

/* назначения платежа */

PROCEDURE DefDetail:
  Detail[1] = IF op.details <> ? THEN op.details ELSE "".
END PROCEDURE.

/* реквизиты плательщика */

PROCEDURE DefPayer:
   RUN for-pay("ДЕБЕТ,ПЛАТЕЛЬЩИК,БАНКПЛ,БАНКГО,БАНКФИЛ",
               "ПП",
               OUTPUT PlName[1],
               OUTPUT PlLAcct,
               OUTPUT PlRKC[1],
               OUTPUT PlCAcct,
               OUTPUT PlMFO,
	       OUTPUT PlINN).
END PROCEDURE.

/* реквизиты получателя */

PROCEDURE DefRecipient:
   RUN for-rec("КРЕДИТ,ПОЛУЧАТЕЛЬ,БАНКПОЛ,БАНКГО,БАНКФИЛ",
               "ПП",
               OUTPUT PoName[1],
               OUTPUT PoAcct,
               OUTPUT PoRKC[1],
               OUTPUT PoCAcct,
               OUTPUT PoMFO,
	       OUTPUT PoINN,
	       OUTPUT PoKPP
	       ).
END PROCEDURE.

/* всякие дествия после вычислений */

PROCEDURE DefWrap:
  {wordwrap.i &s=Detail &n=5 &l=80}
  {wordwrap.i &s=AmtStr &n=3 &l=71}
  {wordwrap.i &s=PlRKC  &n=2 &l=46}
  {wordwrap.i &s=PlName &n=5 &l=46}
  {wordwrap.i &s=PoRKC  &n=2 &l=46}
  {wordwrap.i &s=PoName &n=5 &l=46}
END PROCEDURE.

/* счета по умолчанию из проводки */

PROCEDURE DefAcct:
  DEF INPUT PARAM isPay AS LOGICAL NO-UNDO.
  DEF INPUT-OUTPUT PARAM inAcct LIKE acct.acct NO-UNDO.
/* --- */
  &IF defined(tt-op-entry) = 0 &THEN
    FIND FIRST acct WHERE acct.acct = (IF isPay THEN op-entry.acct-db ELSE op-entry.acct-cr) AND acct.currency = "" NO-LOCK NO-ERROR.
  &ELSE
    FIND FIRST acct WHERE acct.acct = (IF isPay THEN tt-op-entry.acct-db ELSE tt-op-entry.acct-cr) AND acct.currency = "" NO-LOCK NO-ERROR.
  &ENDIF
  inAcct = IF AVAIL acct THEN acct.acct ELSE "".
END PROCEDURE. /* ? */

/* МФО по умолчанию */

PROCEDURE DefMFO:
  DEF INPUT PARAM isPay AS LOGICAL NO-UNDO.
  DEF INPUT-OUTPUT PARAM inMFO AS CHAR NO-UNDO.
/* --- */
  inMFO   = bank-mfo-9.
END PROCEDURE.

/* РКЦ по умолчанию */

PROCEDURE DefRKC:
  DEF INPUT PARAM isPay AS LOGICAL NO-UNDO.
  DEF INPUT-OUTPUT PARAM inRKC AS CHAR NO-UNDO.
/* --- */
  {getbank.i bank1 bank-mfo-9}
  inRKC = IF AVAIL bank1 THEN BankNameCity(BUFFER Bank1) ELSE "".
END PROCEDURE.

/* к/с по умолчанию */

PROCEDURE DefCAcct:
  DEF INPUT PARAM isPay AS LOGICAL NO-UNDO.
  DEF INPUT-OUTPUT PARAM inCAcct AS CHAR NO-UNDO.
/* --- */
  inCAcct = bank-acct.
END PROCEDURE.

/* ИНН по умолчанию */

PROCEDURE DefINN:
  DEF INPUT PARAM isPay AS LOGICAL NO-UNDO.
  DEF INPUT-OUTPUT PARAM inINN AS CHAR NO-UNDO.
/* --- */
  IF AVAIL acct AND (acct.cust-cat = 'В' OR (AVAIL setting AND LOOKUP(STRING(acct.bal-acct), setting.val) <> 0 )) THEN DO:
    {get_set.i "ИНН"}
    inINN = setting.val.
  END.
  ELSE inINN = "".
END PROCEDURE.

/* наименование по умолчанию */

PROCEDURE DefName:
END PROCEDURE.

/* Сбор информации во временную таблицу. Если указан параметр &TEST, то
   собранная информация выводится в файл test.pp */
PROCEDURE Collection-Info:
   RUN identify-Client("SEND").
   RUN identify-Client("REC").
&IF defined(tt-op-entry) = 0 &THEN
   RUN Identify-Acct("ДЕБЕТ",op-entry.acct-db,op-entry.currency).
   RUN Identify-Acct("КРЕДИТ",op-entry.acct-cr,op-entry.currency).
&ELSE
   RUN Identify-Acct("ДЕБЕТ",tt-op-entry.acct-db,tt-op-entry.currency).
   RUN Identify-Acct("КРЕДИТ",tt-op-entry.acct-cr,tt-op-entry.currency).
&ENDIF
   RUN Identify-Banks("SEND").
   RUN Identify-Banks("REC").
   RUN Our-Bank.
   RUN General-Bank.

   &IF "{&TEST}" EQ "YES" &THEN
      FOR EACH Info-Store :
         DISP STREAM test
            Info-Store.info-id
            Info-Store.inn
            Info-Store.flag
            Info-Store.code
            Info-Store.acct
            Info-Store.corr-acct
            Info-Store.acct-type
            Info-Store.acct-cat
            Info-Store.bank-id
            Info-Store.name
            Info-Store.Sh-name
            Info-Store.address
            Info-Store.corr-acct1
            Info-Store.flag-rkc
            Info-Store.flag-client
            Info-Store.flag-balchinn
            Info-Store.category
            WITH FRAME testprn WITH 1 COL.
         DOWN STREAM test
         WITH FRAME testprn.
      END.
   &ENDIF
END.

PROCEDURE for-pay:
   DEFINE INPUT PARAMETER  in-param   AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  in-doc-type AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out-Name   AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out-Acct   AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out-RKC    AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out-CAcct  AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out-MFO    AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out-INN    AS CHARACTER NO-UNDO.

   DEF BUFFER Inf-acct    FOR Info-Store.
   DEF BUFFER Inf-acct-cr FOR Info-Store.
   DEF BUFFER Inf-cl      FOR Info-Store.
   DEF BUFFER Inf-bank    FOR Info-Store.
   DEF BUFFER Inf-fil     FOR Info-Store.
   DEF BUFFER Inf-id     FOR Info-Store.

   IF in-doc-type EQ "ПП" THEN
   FIND inf-acct-cr WHERE inf-acct-cr.info-id   EQ "КРЕДИТ"      NO-LOCK NO-ERROR.
   FIND inf-acct WHERE inf-acct.info-id   EQ ENTRY(1,in-param) NO-LOCK NO-ERROR.
   IF in-doc-type NE "ВО" THEN
   FIND inf-cl   WHERE inf-cl.info-id     EQ ENTRY(2,in-param) NO-LOCK NO-ERROR.
   IF in-doc-type NE "ВО" THEN
   FIND inf-bank WHERE inf-bank.info-id   EQ ENTRY(3,in-param)     NO-LOCK NO-ERROR.
   FIND Info-Store WHERE info-store.info-id   EQ ENTRY(4,in-param) NO-LOCK NO-ERROR.
   FIND Inf-fil WHERE inf-fil.info-id   EQ ENTRY(5,in-param) NO-LOCK NO-ERROR.
   RELEASE banks.
   IF AVAIL inf-acct AND NOT AVAIL inf-cl AND NOT AVAIL inf-bank THEN DO:
      ASSIGN
         out-RKC  = "СБЕРБАНК РОССИИ"
         out-MFO    = "044525225"
         out-CAcct  = "30101810400000000225"
         out-Acct   = "30109810400000000294"
	/* out-inn = "7708031739"
	 out-kpp = FGetSetting("БанкКПП",?,"")
         out-RKC  = Info-Store.name
         out-MFO    = Info-Store.code
         out-CAcct  = Info-Store.acct*/
      .
      out-Acct  = Inf-acct.acct.
      IF Inf-acct.acct-cat EQ "В" OR Inf-acct.flag-balchinn EQ "БалСчИНН" THEN DO:
         IF NOT AVAIL inf-fil THEN DO:
            IF in-doc-type EQ "ПП" THEN
            out-Name =  ConvertNameINN(Info-Store.inn,NO) +
                        Info-Store.Sh-Name.
            ELSE
            out-Name = ConvertNameINN(Inf-acct.inn,NO) +
                       Inf-acct.Name .
            IF  AVAIL inf-acct-cr AND inf-acct-cr.flag-client EQ "БанкКлиент" THEN DO:
               IF inf-acct-cr.category EQ "t" THEN
                  out-Name =  ConvertNameINN(Info-Store.inn,NO) +
                              Info-Store.Sh-Name + " ДОВЕРИТЕЛЬНЫЙ УПРАВЛЯЮЩИЙ".
               ELSE
                  out-Name =  ConvertNameINN(Info-Store.inn,NO) +
                              Info-Store.Sh-Name.
               ASSIGN
                  out-RKC  = Inf-acct-cr.Sh-name
                  out-MFO    = Inf-acct-cr.code
                  out-CAcct  = Inf-acct-cr.corr-acct
                  out-Acct  = Inf-acct-cr.corr-acct1
               .
            END.
         END.
         ELSE
            IF in-doc-type EQ "ПП" THEN
            out-Name = ConvertNameINN(Inf-Fil.inn,NO) +
                        Inf-Fil.Sh-Name.
            ELSE
            out-Name = ConvertNameINN(Inf-acct.inn,NO) +
                       Inf-acct.Name.
      END.
      ELSE DO:
         out-Name = ConvertNameINN(Inf-acct.inn,NO) +
                     Inf-acct.Name.
         IF NOT AVAIL Inf-Fil THEN DO:
            IF AVAIL inf-acct-cr AND inf-acct-cr.flag-client EQ "БанкКлиент" THEN DO:
               out-Name = ConvertNameINN(Inf-acct.inn,NO) +
                           Inf-acct.Name + " р/c " + inf-acct.acct + " в " +
                           Info-Store.Name.
               ASSIGN
                  out-RKC    = Inf-acct-cr.Sh-name
                  out-MFO    = Inf-acct-cr.code
                  out-CAcct  = Inf-acct-cr.corr-acct
                  out-Acct  = Inf-acct-cr.corr-acct1
               .
            END.
         END.
         ELSE
            out-Name = out-Name + " в " + inf-fil.name.
      END.
   END.
   ELSE IF AVAIL inf-acct AND AVAIL inf-cl AND NOT AVAIL inf-bank THEN DO:
      ASSIGN
         out-RKC  = Info-Store.name
         out-MFO    = Info-Store.code
         out-CAcct  = Info-Store.acct
      .
      IF inf-cl.acct EQ inf-acct.acct THEN DO:
         ASSIGN
            out-Name   = ConvertNameINN(inf-cl.inn,NO) +
                         inf-cl.name
            out-Acct  = inf-acct.acct
            out-RKC  = Info-Store.name
            out-MFO    = Info-Store.code
            out-CAcct  = Info-Store.acct
         .
         IF AVAIL inf-acct-cr AND inf-acct-cr.flag-client EQ "БанкКлиент" THEN DO:
               out-Name =  ConvertNameINN(inf-cl.inn,NO) +
                           inf-cl.name                +
                           (IF inf-cl.acct NE "" THEN (" р/c " + inf-cl.acct)
                                                 ELSE "") + " в " +
                           Info-Store.Name.
               ASSIGN
                  out-RKC    = Inf-acct-cr.Sh-name
                  out-MFO    = Inf-acct-cr.code
                  out-CAcct  = Inf-acct-cr.corr-acct
                  out-Acct   = Inf-acct-cr.corr-acct1
               .
         END.
      END.
      ELSE IF (inf-acct.acct-type EQ "МежБанк" OR (inf-acct.acct-type EQ "Филиал"
                                             AND inf-acct.code  NE ?)) AND inf-acct.flag NE "МежФилиалБезБИК"
                                            THEN DO:
          IF inf-acct.acct-cat EQ "Б" AND  inf-acct.bank-id NE ? THEN
          FIND banks WHERE banks.bank-id EQ inf-acct.bank-id NO-LOCK NO-ERROR.
          /***************************** Московские платежи */
	     out-Acct =  inf-cl.acct. /* getxattrvalueEx("op",string(op.op),"acct-send","")*/ /*inf-acct.acct*/
          IF NOT AVAIL Inf-Fil THEN DO:
                      out-Name  =  inf-cl.name. 
	               /* getxattrvalueEx("op",string(op.op),"name-send","") */
	               /* ConvertNameINN(inf-cl.inn,NO) +
                          inf-cl.name +
                          (IF inf-cl.acct NE "" THEN (" р/с " + inf-cl.acct)
                                                ELSE "") +
                          IF AVAIL banks THEN (" в " + BankNameCity(BUFFER Banks))
                                         ELSE ""*/
                      out-MFO  = Inf-acct.code.
		      out-INN  = getxattrvalueEx("op",string(op.op),"inn-send","").
                      out-CAcct  = Inf-acct-cr.corr-acct /*inf-acct.acct*/.
		      out-RKC  = inf-acct.name.
           	      /*
		      find first acct where acct.acct = out-CAcct.
		      if avail acct then out-RKC = acct.details.
		      */
		      
             IF inf-acct.acct-cat EQ "Ю" THEN DO:
                out-Name  =  ConvertNameINN(inf-cl.inn,NO) +
                             inf-cl.name +
                             (IF inf-cl.acct NE "" THEN (" р/с " + inf-cl.acct)
                                                   ELSE "") +
                             " в " +
                             Info-Store.Name.
             END.
             IF AVAIL inf-acct-cr AND inf-acct-cr.flag-client EQ "БанкКлиент" THEN DO:
                out-Name  =  ConvertNameINN(inf-cl.inn,NO) +
                             inf-cl.name +
                             (IF inf-cl.acct NE "" THEN (" р/с " + inf-cl.acct)
                                                   ELSE "") +
                             (IF inf-acct.name NE "" THEN (" в " + inf-acct.name)
                                                     ELSE "") +
                             " к/с " + inf-acct.acct + " в " +
                             Info-Store.Name.
                ASSIGN
                   out-RKC  = Inf-acct-cr.Sh-name
                   out-MFO    = Inf-acct-cr.code
                   out-CAcct  = Inf-acct-cr.corr-acct
                   out-Acct  = Inf-acct-cr.corr-acct1
                .
             END.

          END.
          ELSE DO:
             out-Name  =  ConvertNameINN(inf-cl.inn,NO) +
                          inf-cl.name +
                          (IF inf-cl.acct NE "" THEN (" р/с " + inf-cl.acct)
                                                ELSE "") +
                          IF AVAIL banks THEN (" в " + BankNameCity(BUFFER Banks))
                                         ELSE "".
             out-Name = out-Name + " в " + inf-fil.name.
          END.
      END.
      ELSE IF inf-acct.flag EQ "МежФилиалБезБИК" THEN DO:
         FIND banks WHERE banks.bank-id EQ inf-acct.bank-id NO-LOCK NO-ERROR.
         out-Name =  ConvertNameINN(inf-cl.inn,NO) +
                     inf-cl.name /* +
                     IF AVAIL banks THEN (" в " + BankNameCity(BUFFER Banks))
                                    ELSE "" */ .
         out-Acct = inf-cl.acct.
         IF AVAIL inf-acct-cr AND inf-acct-cr.flag-client EQ "БанкКлиент" THEN DO:
               out-Name =  ConvertNameINN(inf-cl.inn,NO) +
                           inf-cl.name +
                           (IF inf-cl.acct NE "" THEN (" р/c " + inf-cl.acct)
                                                 ELSE "") + " в " +
                           Info-Store.Name.
               ASSIGN
                  out-RKC  = Inf-acct-cr.Sh-name
                  out-MFO    = Inf-acct-cr.code
                  out-CAcct  = Inf-acct-cr.corr-acct
                  out-Acct  = Inf-acct-cr.corr-acct1
               .
         END.
         IF AVAIL inf-fil THEN DO: /* счет дебета - счет филиала в ГО */
            IF inf-acct.acct-cat EQ "Б"
               AND inf-acct.bank-id EQ Info-Store.bank-id THEN DO:
               out-Name =  ConvertNameINN(inf-cl.inn,NO) +
                           inf-cl.name.
            END. /***************************/
         END.
      END.
      ELSE DO:
         ASSIGN
            out-Name = ConvertNameINN(inf-cl.inn,NO) +
                       inf-cl.name
            out-Acct = inf-cl.acct
         .
         IF AVAIL inf-acct-cr AND inf-acct-cr.flag-client EQ "БанкКлиент" THEN DO:
               out-Name =  ConvertNameINN(inf-cl.inn,NO) +
                           inf-cl.name +
                           (IF inf-cl.acct NE "" THEN (" р/c " + inf-cl.acct)
                                                 ELSE "") + " в " +
                           Info-Store.Name.
               ASSIGN
                  out-RKC  = Inf-acct-cr.Sh-name
                  out-MFO    = Inf-acct-cr.code
                  out-CAcct  = Inf-acct-cr.corr-acct
                  out-Acct  = Inf-acct-cr.corr-acct1
               .
         END.
         IF AVAIL Inf-Fil THEN
         out-Name = out-Name /* + " в " + inf-fil.name */.
      END.
   END.
   ELSE IF AVAIL inf-acct AND AVAIL inf-cl AND AVAIL inf-bank THEN DO:
      IF inf-acct.acct-cat EQ "Б" AND inf-acct.flag-rkc = "РКЦ" THEN DO:
         ASSIGN
            out-Name   = ConvertNameINN(inf-cl.inn,NO) +
                         inf-cl.name

            out-Acct  = inf-cl.acct
            out-RKC  = inf-bank.name
            out-MFO    = inf-bank.code
            out-CAcct  = inf-bank.acct
         .
      END.
      ELSE IF inf-acct.bank-id NE ? AND inf-acct.bank-id EQ inf-bank.bank-id THEN DO:
         ASSIGN
            out-RKC  = Info-Store.name
            out-MFO    = Info-Store.code
            out-CAcct  = Info-Store.acct
         .
         IF (inf-acct.acct-type EQ "МежБанк" OR (inf-acct.acct-type EQ "Филиал"
                                                AND inf-acct.code  NE ?)) AND inf-acct.flag NE "МежФилиалБезБИК"
                                               THEN DO:
             IF inf-acct.acct-cat EQ "Б" AND  inf-acct.bank-id NE ? THEN
             FIND banks WHERE banks.bank-id EQ inf-acct.bank-id NO-LOCK NO-ERROR.
             out-Acct = inf-acct.acct.
             IF NOT AVAIL Inf-Fil THEN DO:
                out-Name  =  ConvertNameINN(inf-cl.inn,NO) +
                             inf-cl.name +
                             (IF inf-cl.acct NE "" THEN (" р/с " + inf-cl.acct)
                                                   ELSE "") +
                             IF AVAIL banks THEN (" в " + BankNameCity(BUFFER Banks))
                                            ELSE "".
                IF inf-acct.acct-cat EQ "Ю" THEN DO:
                   out-Name  =  ConvertNameINN(inf-cl.inn,NO) +
                                inf-cl.name +
                                (IF inf-cl.acct NE "" THEN (" р/с " + inf-cl.acct)
                                                      ELSE "") +
                                " в " +
                                Info-Store.Name.
                END.
                IF AVAIL inf-acct-cr AND inf-acct-cr.flag-client EQ "БанкКлиент" THEN DO:
                   out-Name  =  ConvertNameINN(inf-cl.inn,NO) +
                                inf-cl.name +
                                (IF inf-cl.acct NE "" THEN (" р/с " + inf-cl.acct)
                                                      ELSE "") +
                                (IF inf-acct.name NE "" THEN (" в " + inf-acct.name)
                                                        ELSE "") +
                                " к/с " + inf-acct.acct + " в " +
                                Info-Store.Name.
                   ASSIGN
                      out-RKC  = Inf-acct-cr.Sh-name
                      out-MFO    = Inf-acct-cr.code
                      out-CAcct  = Inf-acct-cr.corr-acct
                      out-Acct  = Inf-acct-cr.corr-acct1
                   .
                END.
             END.
             ELSE DO:
                out-Name  =  ConvertNameINN(inf-cl.inn,NO) +
                             inf-cl.name +
                             (IF inf-cl.acct NE "" THEN (" р/с " + inf-cl.acct)
                                                   ELSE "") +
                             IF AVAIL banks THEN (" в " + BankNameCity(BUFFER Banks))
                                            ELSE "".
                out-Name = out-Name + " в " + inf-fil.name.
             END.
         END.
         ELSE IF inf-acct.flag EQ "МежФилиалБезБИК" THEN DO:
            FIND banks WHERE banks.bank-id EQ inf-acct.bank-id NO-LOCK NO-ERROR.
            out-Name =  ConvertNameINN(inf-cl.inn,NO) +
                        inf-cl.name /* +
                        IF AVAIL banks THEN (" в " + BankNameCity(BUFFER Banks))
                                       ELSE "" */ .
            out-Acct = inf-cl.acct.
            IF AVAIL inf-acct-cr AND inf-acct-cr.flag-client EQ "БанкКлиент" THEN DO:
                  out-Name =  ConvertNameINN(inf-cl.inn,NO) +
                              inf-cl.name +
                              (IF inf-cl.acct NE "" THEN (" р/c " + inf-cl.acct)
                                                    ELSE "") + " в " +
                              Info-Store.Name.
                  ASSIGN
                     out-RKC  = Inf-acct-cr.Sh-name
                     out-MFO    = Inf-acct-cr.code
                     out-CAcct  = Inf-acct-cr.corr-acct
                     out-Acct  = Inf-acct-cr.corr-acct1
                  .
            END.
            IF AVAIL inf-fil THEN DO: /* счет дебета - счет филиала в ГО */
               IF inf-acct.acct-cat EQ "Б"
                  AND inf-acct.bank-id EQ Info-Store.bank-id THEN DO:
                  out-Name =  ConvertNameINN(inf-cl.inn,NO) +
                              inf-cl.name.
               END. /***************************/
            END.
         END.
      END.
      ELSE IF (inf-acct.acct-type EQ "МежБанк" OR inf-acct.acct-type EQ "Филиал")
         AND inf-acct.code NE ? AND NOT AVAIL inf-fil THEN DO:
         IF inf-acct.bank-id NE ? THEN DO:
            ASSIGN
               out-RKC  = Info-Store.name
               out-MFO    = Info-Store.code
               out-CAcct  = Info-Store.acct
            .
            IF (inf-bank.code EQ ? AND inf-bank.acct NE ?) OR inf-bank.corr-acct NE ? THEN DO:
               FIND banks WHERE banks.bank-id EQ inf-acct.bank-id NO-LOCK NO-ERROR.
               out-Name = ConvertNameINN(inf-cl.inn,NO) +
                        inf-cl.name +
                        (IF inf-cl.acct NE "" THEN (" р/с " + inf-cl.acct)
                                              ELSE "") +
                        (IF inf-bank.name NE "" AND inf-bank.name NE ? THEN
                        (" в " + inf-bank.name)
                        ELSE "") +
                        " к/c "  +
                        (IF inf-bank.corr-acct NE ? THEN inf-bank.corr-acct
                                                    ELSE inf-bank.acct) +
                        (IF AVAIL banks THEN (" в " + BankNameCity(BUFFER Banks))
                                        ELSE "").

               out-Acct = inf-acct.acct.
               IF AVAIL inf-acct-cr AND inf-acct-cr.flag-client EQ "БанкКлиент" THEN DO:
                  out-Name = ConvertNameINN(inf-cl.inn,NO) +
                           inf-cl.name +
                           (IF inf-cl.acct NE "" THEN (" р/с " + inf-cl.acct)
                                                 ELSE "") +
                           (IF inf-bank.name NE "" AND inf-bank.name NE ? THEN
                           (" в " + inf-bank.name)
                           ELSE "") +
                           " к/c "  +
                           (IF inf-bank.corr-acct NE ? THEN inf-bank.corr-acct
                                                       ELSE inf-bank.acct) +
                           (IF AVAIL banks THEN (" в " + BankNameCity(BUFFER Banks))
                                           ELSE "") +
                           " к/с " + inf-acct.acct + " в " + Info-Store.Name
                           .
                  ASSIGN
                     out-RKC  = Inf-acct-cr.Sh-name
                     out-MFO    = Inf-acct-cr.code
                     out-CAcct  = Inf-acct-cr.corr-acct
                     out-Acct  = Inf-acct-cr.corr-acct1
                  .
               END.
            END.
            ELSE IF inf-bank.code NE ? THEN DO:
               ASSIGN
                  out-Name   = ConvertNameINN(inf-cl.inn,NO) +
                               inf-cl.name

                  out-Acct  = inf-cl.acct
                  out-RKC  = inf-bank.name
                  out-MFO    = inf-bank.code
                  out-CAcct  = inf-bank.acct
               .

/****************
               FIND banks WHERE banks.bank-id EQ inf-acct.bank-id NO-LOCK NO-ERROR.
               out-Name = (IF inf-cl.inn NE "" THEN ("ИНН" + " " + inf-cl.inn + " ")
                                               ELSE "") +
                        inf-cl.name +
                        (IF inf-cl.acct NE "" THEN (" р/с " + inf-cl.acct)
                                              ELSE "") +
                        (IF inf-bank.name NE "" AND inf-bank.name NE ? THEN
                        (" в " + inf-bank.name)
                        ELSE "") +
                        (IF AVAIL banks THEN (" в " + BankNameCity(BUFFER Banks))
                                        ELSE "").
               out-Acct = inf-acct.acct. */
               IF AVAIL inf-acct-cr AND inf-acct-cr.flag-client EQ "БанкКлиент" THEN DO:
                  out-Name = ConvertNameINN(inf-cl.inn,NO) +
                           inf-cl.name +
                           (IF inf-cl.acct NE "" THEN (" р/с " + inf-cl.acct)
                                                 ELSE "") +
                           (IF inf-bank.name NE "" AND inf-bank.name NE ? THEN
                           (" в " + inf-bank.name)
                           ELSE "") +
                           (IF AVAIL banks THEN (" в " + BankNameCity(BUFFER Banks))
                                           ELSE "") +
                           " к/с " + inf-acct.acct + " в " + Info-Store.Name
                           .
                  ASSIGN
                     out-RKC  = Inf-acct-cr.Sh-name
                     out-MFO    = Inf-acct-cr.code
                     out-CAcct  = Inf-acct-cr.corr-acct
                     out-Acct  = Inf-acct-cr.corr-acct1
                  .
               END.

            END.
         END.
      END.
      ELSE IF inf-acct.flag EQ "МежФилиалБезБИК" THEN DO:
         IF inf-bank.code EQ ? THEN DO:
            IF NOT AVAIL inf-fil THEN DO:
               FIND banks WHERE banks.bank-id EQ inf-acct.bank-id NO-LOCK NO-ERROR.
               ASSIGN
                  out-RKC  = Info-Store.name
                  out-MFO    = Info-Store.code
                  out-CAcct  = Info-Store.acct
               .
               out-Name =  ConvertNameINN(inf-cl.inn,NO) +
                           inf-cl.name +
                           (IF inf-cl.acct NE "" THEN (" р/с " + inf-cl.acct)
                                                    ELSE "") +
                           (IF inf-bank.name NE "" AND inf-bank.name NE ? THEN
                              (" в " + inf-bank.name)
                            ELSE "") +
                           (IF AVAIL banks THEN (" в " + BankNameCity(BUFFER Banks))
                                           ELSE "").
                           .
               out-Acct  = inf-bank.acct.
               IF AVAIL inf-acct-cr AND inf-acct-cr.flag-client EQ "БанкКлиент" THEN DO:
                  out-Name =  ConvertNameINN(inf-cl.inn,NO) +
                              inf-cl.name +
                              (IF inf-cl.acct NE "" THEN (" р/с " + inf-cl.acct)
                                                    ELSE "") +
                              (IF inf-bank.name NE "" AND inf-bank.name NE ? THEN
                                  (" в " + inf-bank.name)
                               ELSE "") +
                              (IF AVAIL banks THEN (" в " + BankNameCity(BUFFER Banks))
                                              ELSE "") +
                              (IF inf-cl.acct NE "" THEN (" к/с " + inf-bank.acct)
                                                    ELSE "") + " в " + Info-Store.Name
                              .
                     ASSIGN
                        out-RKC  = Inf-acct-cr.Sh-name
                        out-MFO    = Inf-acct-cr.code
                        out-CAcct  = Inf-acct-cr.corr-acct
                        out-Acct  = Inf-acct-cr.corr-acct1
                     .
               END.
            END.
            ELSE DO:
               FIND acct WHERE acct.acct     EQ inf-acct.acct
                           AND acct.currency EQ "" NO-LOCK NO-ERROR.
               IF acct.branch-id EQ inf-fil.code AND inf-acct.acct-cat EQ "Б"
                  AND inf-acct.bank-id EQ Info-Store.bank-id THEN DO:
                  ASSIGN
                     out-Name =  ConvertNameINN(inf-cl.inn,NO) +
                                 inf-cl.name
                     out-Acct  = inf-cl.acct
                     out-RKC  = inf-bank.name
                     out-MFO    = inf-bank.code
                     out-CAcct  = inf-bank.acct
                  .
               END.
            END.
         END.
         ELSE DO:
            ASSIGN
               out-Name = ConvertNameINN(inf-cl.inn,NO) +
                          inf-cl.name
               out-Acct  = inf-cl.acct
               out-RKC  = inf-bank.name
               out-MFO    = inf-bank.code
               out-CAcct  = inf-bank.acct
            .
         END.
      END.
      ELSE DO:
         ASSIGN
            out-Name   = ConvertNameINN(inf-cl.inn,NO) +
                         inf-cl.name

            out-Acct  = inf-cl.acct
            out-RKC  = inf-bank.name
            out-MFO    = inf-bank.code
            out-CAcct  = inf-bank.acct
         .
      END.
   END.
END PROCEDURE.

PROCEDURE for-rec:
   DEFINE INPUT PARAMETER  in-param   AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  in-doc-type AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out-Name   AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out-Acct   AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out-RKC    AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out-CAcct  AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out-MFO    AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out-inn    AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out-kpp    AS CHARACTER NO-UNDO.

   DEF BUFFER Inf-acct FOR Info-Store.
   DEF BUFFER Inf-cl   FOR Info-Store.
   DEF BUFFER Inf-bank FOR Info-Store.
   DEF BUFFER Inf-fil  FOR Info-Store.
   DEF BUFFER Inf-id  FOR Info-Store.

   FIND inf-acct WHERE inf-acct.info-id   EQ ENTRY(1,in-param) NO-LOCK NO-ERROR.
   IF NOT avail inf-acct THEN /* Счет не в нашем банке, но надо распечатать */
   FIND inf-acct WHERE inf-acct.info-id   EQ ENTRY(2,in-param) NO-LOCK NO-ERROR.
   IF in-doc-type NE "ВО" THEN
   FIND inf-cl   WHERE inf-cl.info-id     EQ ENTRY(2,in-param) NO-LOCK NO-ERROR.
   IF in-doc-type NE "ВО" THEN
   FIND inf-bank WHERE inf-bank.info-id   EQ ENTRY(3,in-param)     NO-LOCK NO-ERROR.
   FIND Info-Store WHERE info-store.info-id   EQ ENTRY(4,in-param) NO-LOCK NO-ERROR.
   FIND Inf-fil WHERE inf-fil.info-id   EQ ENTRY(5,in-param) NO-LOCK NO-ERROR.

   RELEASE banks.
   IF AVAIL inf-acct AND NOT AVAIL inf-cl AND NOT AVAIL inf-bank THEN DO:
      ASSIGN
         out-RKC  = "СБЕРБАНК РОССИИ"
         out-MFO    = "044525225"
         out-CAcct  = "30101810400000000225"
/*         out-Acct   = "30109810400000000294"*/
	 out-inn = "7708031739"
	 out-kpp = FGetSetting("БанкКПП",?,"")
	
      .
      out-Acct  ="30109810400000000294" /* Inf-acct.acct*/ .

      IF Inf-acct.acct-cat EQ "В" OR inf-acct.flag-balchinn EQ "БалСчИНН" THEN DO:
         IF NOT AVAIL Inf-Fil THEN
         out-Name =  ConvertNameINN(Info-Store.inn,YES) +
                     Info-Store.Sh-Name.
         ELSE
         out-Name =  ConvertNameINN(Inf-Fil.inn,YES) +
                     Inf-Fil.Sh-Name.
      END.
      ELSE DO:
         out-Name =   Info-Store.name + "        " +
		      " р/с " + inf-acct.acct + "   " 
                      + Inf-acct.Name .
         IF AVAIL Inf-Fil THEN
         out-Name = out-Name + " в " + inf-fil.name.
      END.
   END.
      
  /************************************************************/
  /************************************************************/
   IF AVAIL inf-acct AND AVAIL inf-cl AND NOT AVAIL inf-bank THEN DO:
      ASSIGN
         out-RKC  = Info-Store.name
         out-MFO    = Info-Store.code
         out-CAcct  = Info-Store.acct
      .
      
      IF inf-cl.acct EQ inf-acct.acct THEN DO:
         ASSIGN
            out-Name   = Info-Store.name
			/* ConvertNameINN(inf-cl.inn,YES)*/ + "        " +
			" р/с " + inf-acct.acct + "   " +
                         inf-cl.name
            out-Acct   = "30109810400000000294" /*inf-acct.acct*/
	    
	    out-MFO    = /*inf-acct.code */ "044525225" 
            out-RKC  =   "СБЕРБАНК РОССИИ" /*Info-Store.name*/
/*          out-MFO    = Info-Store.code*/
            out-CAcct  = "30101810400000000225" /*Info-Store.acct*/
	    out-inn = "7708031739"
	    out-kpp = FGetSetting("БанкКПП",?,"")
         .
      END.
      ELSE IF (inf-acct.acct-type EQ "МежБанк" OR (inf-acct.acct-type EQ "Филиал"
                                             AND inf-acct.code  NE ?)) AND inf-acct.flag NE "МежФилиалБезБИК"
                                            THEN DO:
         IF inf-acct.acct-cat EQ "Б" AND  inf-acct.bank-id NE ? THEN
         FIND banks WHERE banks.bank-id EQ inf-acct.bank-id NO-LOCK NO-ERROR.
         FIND banks-code OF banks WHERE banks-code.bank-code-type EQ "МФО-9"
                                                                       NO-LOCK NO-ERROR.
         FIND FIRST banks-corr WHERE banks-corr.bank-corr EQ banks.bank-id
                                 AND CAN-FIND (banks OF banks-corr WHERE banks.flag-rkc)
                                                                        NO-LOCK NO-ERROR.

         ASSIGN
            out-Name  =  ConvertNameINN(inf-cl.inn,YES) +
                         inf-cl.name
            out-Acct     = inf-cl.acct
            out-RKC    = (IF AVAIL banks THEN BankNameCity(BUFFER Banks) ELSE "")
            out-MFO      = (IF AVAIL banks-code THEN banks-code.bank-code ELSE "")
            out-CAcct    = (IF AVAIL banks-corr THEN banks-corr.corr-acct ELSE "")
         .
      END.
      ELSE IF inf-acct.flag EQ "МежФилиалБезБИК" THEN DO:
         IF NOT AVAIL Inf-Fil THEN DO:
            FIND banks WHERE banks.bank-id EQ inf-acct.bank-id NO-LOCK NO-ERROR.
            out-Name =  ConvertNameINN(inf-cl.inn,YES) +
                        inf-cl.name /* +
                        IF AVAIL banks THEN (" в " + BankNameCity(BUFFER Banks))
                                       ELSE "" */ .
         END.
         ELSE DO:
            IF inf-acct.acct-cat EQ "Б"
               AND inf-acct.bank-id EQ Info-Store.bank-id THEN DO:

               out-Name = ConvertNameINN(inf-cl.inn,YES) +
                          inf-cl.name.

            END.
         END.
         out-Acct = inf-cl.acct.
      END.
      ELSE DO:
         ASSIGN
            out-Name =  ConvertNameINN(inf-cl.inn,YES) +
                        inf-cl.name
            out-Acct    = inf-cl.acct
         .
         IF AVAIL Inf-Fil THEN DO:
            out-Name = out-Name /* + " в " + inf-fil.name */ .

         END.
      END.
   END.
   IF AVAIL inf-acct AND AVAIL inf-cl AND AVAIL inf-bank THEN DO:
      ASSIGN
         out-RKC  = Info-Store.name
         out-MFO    = Info-Store.code
         out-CAcct  = Info-Store.acct
      .
      IF inf-acct.acct-cat EQ "Б" AND inf-acct.flag-rkc EQ "РКЦ" THEN DO:
         ASSIGN
            out-Name   = ConvertNameINN(inf-cl.inn,YES) +
                         inf-cl.name
            out-Acct   = inf-cl.acct
            out-RKC    = inf-bank.name
            out-MFO    = inf-bank.code
            out-CAcct  = inf-bank.acct
         .
      END.
      ELSE IF inf-acct.bank-id EQ inf-bank.bank-id THEN DO:
         IF (inf-acct.acct-type EQ "МежБанк" OR (inf-acct.acct-type EQ "Филиал"
                                                AND inf-acct.code  NE ?)) AND inf-acct.flag NE "МежФилиалБезБИК"
                                               THEN DO:
            IF inf-acct.acct-cat EQ "Б" AND  inf-acct.bank-id NE ? THEN
            FIND banks WHERE banks.bank-id EQ inf-acct.bank-id NO-LOCK NO-ERROR.
            FIND banks-code OF banks WHERE banks-code.bank-code-type EQ "МФО-9"
                                                                NO-LOCK NO-ERROR.
            FIND FIRST banks-corr WHERE banks-corr.bank-corr EQ banks.bank-id
                                    AND CAN-FIND (banks OF banks-corr WHERE banks.flag-rkc)
                                                                           NO-LOCK NO-ERROR.

            ASSIGN
               out-Name     = ConvertNameINN(inf-cl.inn,YES) +
                              inf-cl.name
               out-Acct     = inf-cl.acct
               out-RKC      = (IF AVAIL banks THEN BankNameCity(BUFFER Banks) ELSE "")
               out-MFO      = (IF AVAIL banks-code THEN banks-code.bank-code ELSE "")
               out-CAcct    = (IF AVAIL banks-corr THEN banks-corr.corr-acct ELSE "")
            .
         END.
         ELSE IF inf-acct.flag EQ "МежФилиалБезБИК" THEN DO:
            IF NOT AVAIL Inf-Fil THEN DO:
               FIND banks WHERE banks.bank-id EQ inf-acct.bank-id NO-LOCK NO-ERROR.
               out-Name =  ConvertNameINN(inf-cl.inn,YES) +
                           inf-cl.name + 
                           IF AVAIL banks THEN (" в " + BankNameCity(BUFFER Banks))
                                          ELSE "".
            END.
            ELSE DO:
               IF inf-acct.acct-cat EQ "Б"
                  AND inf-acct.bank-id EQ Info-Store.bank-id THEN DO:
                  out-Name = ConvertNameINN(inf-cl.inn,YES) +
                             inf-cl.name.
               END.
            END.
            out-Acct = inf-cl.acct.
         END.
      END.
      ELSE DO:
         ASSIGN
            out-Name    = ConvertNameINN(inf-cl.inn,YES) +
                          inf-cl.name
            out-Acct    = inf-cl.acct
            out-RKC     = Inf-bank.name
            out-MFO     = Inf-bank.code
            out-CAcct   = IF Inf-bank.code EQ ? OR Inf-bank.code EQ ""  /* Это обработка кривой ситуации */
                        THEN ""
                        ELSE Inf-bank.acct
         .
      END.
   END.
END PROCEDURE.
