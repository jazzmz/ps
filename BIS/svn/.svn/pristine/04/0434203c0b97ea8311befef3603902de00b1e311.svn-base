/*
               Банковская интегрированная система БИСквит
    copyright: (c) 1992-1998 ТОО "Банковские информационные системы"
     filename: NAMEACLB.P
      comment: Персистентная процедура для обработки наименования внутреннего
               счета договора.
   parameters:
         uses:
      used by:
      created: 12/05/01 kostik
     Modified: 12.10.2002 11:44 GORM     (0007334)    Добавлены функции
                          ТипДог         - наименование типа договора
                          ДатаОткрДог    - дата открытия договора
                          ДатаОкончДог   - дата окончания договора
                          СрокДог        - срок действия договора (в днях)
                          ГрРискаДог     - группа риска
     Modified: 27/12/2002  kraw (0011991) вызов GetCustName с input-output параметром
     Modified: 21.11.2007 jadv (0069015) Добавлены функции:
                          ИмяКлиентаКр   - Краткое наименование клиента            
                          ИмяПоручит     - Наименование субъекта, указанного в
                                           договоре обеспечения
                          ИмяПоручитКр   - Краткое наименование субъекта, указанного в
                                           договоре обеспечения
                          ПрСтавка       - Процентная ставка договора
*/

{globals.i}
{def-wf.i}
{pick-val.i}
{nameaclb.i}
{intrface.get pbase}
{intrface.get tmess}
{intrface.get i254}
{intrface.get bill}
{intrface.get xclass}

ASSIGN THIS-PROCEDURE:PRIVATE-DATA =
   "parssen library,НаимКонтр,НомДог,НомДогов,ИмяКлиента,ТипДог,ДатаОткрДог,ДатаОкончДог,СрокДог,ГрРискаДог,~
НазвМЦ,ВидДогОбесп,ВидОбесп,НппОбесп,НомДогОбесп,ДЗаклОбесп,ДОконОбесп,ДПостОбесп,~
ДВыбОбесп,КатОбесп,ВалОбесп,СумОбесп,ИмяКлиентаКр,ИмяПоручит,ИмяПоручитКр,СсудСчет,ПрСтавка,~
ВЕКС_СЕРНОМ,ВЕКС_ЭМИТ,ВЕКС_ТИП,СДЕЛКА_НОМ,СДЕЛКА_ОСН,СДЕЛКА_СОД,СДЕЛКА_КОНТР,ДогДР,ПИРНомОхДог,ПИРОхДогДатаСогл".
RETURN.

/* ф-ция возвращающая параметр, передаваемый в процедуру */
/* после разбора строки  параметров парсером             */
{getprm.lib}

/* g-bill.p */
PROCEDURE ВЕКС_СЕРНОМ:
   {g-bill.i ВЕКС}
   IF {assigned sec-code.series} THEN
      pick-value = sec-code.series + " " + SUBSTRING(sec-code.number, LENGTH(sec-code.series) + 1).
   ELSE
      pick-value = sec-code.number.
END PROCEDURE. /* ВЕКС_СЕРНОМ */

PROCEDURE ВЕКС_ЭМИТ:
   {g-bill.i ВЕКС}

   DEFINE BUFFER cust-role FOR cust-role.

   FIND FIRST cust-role
        WHERE cust-role.file-name  EQ "sec-code"
          AND cust-role.surrogate  EQ sec-code.sec-code
          AND cust-role.class-code EQ "Bill_Issuer"
      NO-LOCK NO-ERROR.
   IF AVAILABLE cust-role THEN
      pick-value = cust-role.cust-name.
END PROCEDURE. /* ВЕКС_ЭМИТ */

PROCEDURE ВЕКС_ТИП:
   {g-bill.i ВЕКС}
   RUN GetBillInfo IN h_bill (sec-code.sec-code,
                              OUTPUT pick-value).
END PROCEDURE. /* ВЕКС_ТИП */

PROCEDURE СДЕЛКА_НОМ:
   {g-bill.i СДЕЛКА}
   pick-value = deal-loan.doc-num.
END PROCEDURE. /* СДЕЛКА_НОМ */

PROCEDURE СДЕЛКА_ОСН:
   {g-bill.i СДЕЛКА}

   DEFINE VARIABLE vCodeCode AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE vClass    AS CHARACTER   NO-UNDO.

   vClass    = "ОсновОп".
   vCodeCode = GetXAttrValueEx("loan",
                               deal-loan.contract + "," + deal-loan.cont-code,
                               vClass,
                               "").
   pick-value = GetCodeNameEx(vClass, vCodeCode, "").
END PROCEDURE. /* СДЕЛКА_ОСН */

PROCEDURE СДЕЛКА_СОД:
   {g-bill.i СДЕЛКА}
   pick-value = deal-loan.comment.
END PROCEDURE. /* СДЕЛКА_СОД */

PROCEDURE СДЕЛКА_КОНТР:
   {g-bill.i СДЕЛКА}

   DEFINE VARIABLE vName     AS CHARACTER   NO-UNDO EXTENT 2.
   DEFINE VARIABLE vCustInn  AS CHARACTER   NO-UNDO.

   RUN GetCustName IN h_base
      (deal-loan.cust-cat,
       deal-loan.cust-id,
       ?,
       OUTPUT vName[1],
       OUTPUT vName[2],
       INPUT-OUTPUT vCustInn
      ).
   pick-value = TRIM(vName[1] + " " + vName[2]).
END PROCEDURE. /* СДЕЛКА_КОНТР */
/* g-bill.p -- E n d */

/* Получить  договор обеспечения */
PROCEDURE  GetNumG .
  DEF INPUT PARAM iAcctType AS CHAR NO-UNDO .
  DEF PARAM BUFFER b-term-obl FOR term-obl .

  DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
  DEFINE VAR vVidOb    AS CHARACTER NO-UNDO. /* вид договора обеспечения */
  DEFINE VAR vNumPP    AS CHARACTER NO-UNDO.

  DEFINE BUFFER buf-loan FOR loan.

  /* ищем кредитный договор */
   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").
   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ vCOntCode
   NO-LOCK NO-ERROR.
   IF NOT AVAIL buf-loan THEN RETURN .
   FOR EACH b-term-obl WHERE
            b-term-obl.contract  = buf-loan.contract
        AND b-term-obl.cont-code = buf-loan.cont-code
        AND b-term-obl.idnt      = 5
     NO-LOCK:

     ASSIGN
         vVidOb = GetXAttrValueEx ("term-obl",
                                   b-term-obl.contract + ","
                                 + b-term-obl.Cont-Code + ",5,"
                                 + STRING(b-term-obl.end-date) + ","
                                 + STRING(b-term-obl.nn),
                                   "ВидДогОб",
                                   "")
         vNumPP = GetXAttrValueEx ("term-obl",
                                   b-term-obl.contract + ","
                                 + b-term-obl.Cont-Code + ",5,"
                                 + STRING(b-term-obl.end-date) + ","
                                 + STRING(b-term-obl.nn),
                                   "НомерПП",
                                   "").
        IF vVidOb + (IF vNumPP = "0" THEN "" ELSE vNumPP ) = iAcctType
        THEN LEAVE .
  END.
END PROCEDURE .

PROCEDURE НаимКонтр:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vFIO        AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vClName     AS CHARACTER NO-UNDO EXTENT 3.

   DEFINE BUFFER buf-loan FOR loan.
   
   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "Ошибочное количество параметров передано в функцию ""НомДог"":" param-count "(должно быть не больше 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "соглаш"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.

   IF AVAIL buf-loan THEN
   DO:
      RUN GetCustName IN h_base ( buf-loan.cust-cat, buf-loan.cust-id, "",
                                  OUTPUT       vClName[1],
                                  OUTPUT       vClName[2],
                                  INPUT-OUTPUT vClName[3] ).
      pick-value = vClName[1] + " " + vClName[2].
   END.
END PROCEDURE.

PROCEDURE НомДог:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.
   
   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "Ошибочное количество параметров передано в функцию ""НомДог"":" param-count "(должно быть не больше 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "соглаш"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN pick-value = buf-loan.doc-ref.
END PROCEDURE.

PROCEDURE НомДогов:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER loan FOR loan.

   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "Ошибочное количество параметров передано в функцию ""НомДогов"":" param-count "(должно быть не больше 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND loan WHERE loan.contract  EQ vContract
               AND loan.cont-code EQ IF getparam(1,param-str) NE "соглаш"
                                     THEN vCOntCode
                                     ELSE ENTRY(1,vCOntCode," ")
      NO-LOCK NO-ERROR.
   IF AVAIL loan THEN pick-value = loan.doc-num.
END PROCEDURE.

PROCEDURE ИмяКлиента:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vName1      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vName2      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vInn        AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.
   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "Ошибочное количество параметров передано в функцию ""ИмяКлиента"":" param-count "(должно быть не больше 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").
   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "соглаш"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN DO:
      RUN GetCustName IN h_base (buf-loan.cust-cat,
                                 buf-loan.cust-id,
                                 ?,
                                 OUTPUT vName1,
                                 OUTPUT vName2,
                                 INPUT-OUTPUT vInn).
      pick-value = (IF vName1 NE ? THEN (vName1 + " ")
                                   ELSE "") +
                   (IF vName2 NE ? THEN vName2
                                   ELSE "").
   END.
END PROCEDURE.

PROCEDURE ТипДог:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.

   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "Ошибочное количество параметров передано в функцию ""ТипДог"":" param-count "(должно быть не больше 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "соглаш"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN DO:
      FOR FIRST code WHERE 
            (   code.class = "ТипДогА" 
            AND code.code  = buf-loan.cont-type )
         OR (   code.class = "ТипДогП"
            AND code.code  = buf-loan.cont-type )
         NO-LOCK: 
      END.
      IF AVAILABLE code THEN pick-value = code.name.
   END.
END PROCEDURE.

PROCEDURE СсудСчет:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.

   DEFINE BUFFER buf-loan  FOR loan.
   DEFINE BUFFER loan-acct FOR loan-acct.

   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "Ошибочное количество параметров передано в функцию ""СсудСчет"":" param-count "(должно быть не больше 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan WHERE 
        buf-loan.contract  EQ vContract
    AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "соглаш"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN DO:
      FIND FIRST loan-acct WHERE 
                 loan-acct.Contract  EQ "Кредит"
             AND loan-acct.cont-code EQ vContCode 
             AND loan-acct.acct-type EQ "Кредит"
      NO-LOCK NO-ERROR.  
   IF AVAIL loan-acct THEN pick-value = loan-acct.acct.
   END.
END PROCEDURE.

PROCEDURE ДатаОткрДог:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.

   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "Ошибочное количество параметров передано в функцию ""ДатаОткрДог"":" param-count "(должно быть не больше 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "соглаш"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN pick-value = String(buf-loan.open-date).
END PROCEDURE.

PROCEDURE ДатаОкончДог:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.

   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "Ошибочное количество параметров передано в функцию ""ДатаОкончДог"":" param-count "(должно быть не больше 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "соглаш"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN pick-value = String(buf-loan.end-date).
END PROCEDURE.

PROCEDURE СрокДог:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.

   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "Ошибочное количество параметров передано в функцию ""СрокДог"":" param-count "(должно быть не больше 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "соглаш"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN pick-value = String(buf-loan.end-date - buf-loan.open-date).
END PROCEDURE.

PROCEDURE ГрРискаДог:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.

   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "Ошибочное количество параметров передано в функцию ""ГрРискаДог"":" param-count "(должно быть не больше 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "соглаш"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN pick-value = String(buf-loan.gr-riska).
END PROCEDURE.

/*Возвращае название МЦ*/
PROCEDURE НазвМЦ:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
        DEFINE VARIABLE vName1      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vName2      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vInn        AS CHARACTER NO-UNDO.

   DEFINE BUFFER buf-loan  FOR loan.
        DEFINE BUFFER buf-asset FOR asset.

   pick-value = "".
   IF param-count NE 0 THEN DO:
      MESSAGE "Ошибочное количество параметров передано в функцию ""НазвМЦ"":" param-count "(должно быть 0) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").
   FIND buf-loan WHERE
        buf-loan.contract  EQ vContract
    AND buf-loan.cont-code EQ vCOntCode NO-LOCK NO-ERROR.
     IF AVAIL buf-loan THEN DO:
        FIND FIRST buf-asset OF buf-loan NO-LOCK NO-ERROR.
        IF AVAILABLE buf-asset THEN pick-value = buf-asset.NAME.
     END.
END PROCEDURE.

/* ОБЕСПЕЧЕНИЕ */
/*  Получить номер договора обеспечения   */

PROCEDURE НомДогОбесп.
        DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

        DEFINE VAR iAcctType AS CHAR NO-UNDO .
        DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
        IF param-count NE 1 THEN DO:
                MESSAGE "Ошибочное количество параметров передано в функцию ""НомДог"":" param-count "(должно быть 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
        END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   /* найден договор обеспечения для роли iAcctType */
     pick-value = GetXAttrValueEx ("term-obl",
                                       b-term-obl.contract + ","
                                     + b-term-obl.Cont-Code + ",5,"
                                     + STRING(b-term-obl.end-date) + ","
                                     + STRING(b-term-obl.nn),
                                       "НомДогОб",
                                       "").

END PROCEDURE .

PROCEDURE ВидДогОбесп:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VAR iAcctType AS CHARACTER NO-UNDO.
   DEF BUFFER  b-term-obl FOR term-obl .
   DEF BUFFER code FOR code .


   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "Ошибочное количество параметров передано в функцию ""НомДог"":" param-count "(должно быть 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   iAcctType = getparam(1,param-str).

   FOR EACH code WHERE code.class  = "ВидДогОб" AND
                       code.parent = "ВидДогОб"
   NO-LOCK:
      IF iAcctType BEGINS code.code THEN
      DO:
         pick-value = code.name.
         RETURN.
      END.
   END.

END PROCEDURE.

PROCEDURE ВидОбесп:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.
   DEFINE VAR vObKind   AS CHARACTER NO-UNDO. /* вид обеспечения */
   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   DEF BUFFER code FOR code .
    pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "Ошибочное количество параметров передано в функцию ""НомДог"":" param-count "(должно быть 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   vObKind  = GetXAttrValueEx ("term-obl",
                                        b-term-obl.contract + ","
                                      + b-term-obl.Cont-Code + ",5,"
                                      + STRING(b-term-obl.end-date) + ","
                                      + STRING(b-term-obl.nn),
                                        "ВидОб",
                                        "") .
   IF   vObKind  =  ''
   THEN RETURN .
   FOR EACH code WHERE code.class = "ВидОб" AND code.parent = "ВидОб"
   NO-LOCK:
      IF code.code = vObKind THEN
      DO:
         pick-value = code.name.
         RETURN.
      END.
   END.

END PROCEDURE.

PROCEDURE НппОбесп:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "Ошибочное количество параметров передано в функцию ""НомДог"":" param-count "(должно быть 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   pick-value = GetXAttrValueEx ("term-obl",
                                   b-term-obl.contract + ","
                                 + b-term-obl.Cont-Code + ",5,"
                                 + STRING(b-term-obl.end-date) + ","
                                 + STRING(b-term-obl.nn),
                                   "НомерПП",
                                   "").

 END PROCEDURE .

PROCEDURE ДЗаклОбесп:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "Ошибочное количество параметров передано в функцию ""НомДог"":" param-count "(должно быть 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   pick-value = STRING(b-term-obl.fop-date,"99/99/9999").

END PROCEDURE .

PROCEDURE ДОконОбесп:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "Ошибочное количество параметров передано в функцию ""НомДог"":" param-count "(должно быть 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   pick-value = STRING(b-term-obl.end-date,"99/99/9999").

END PROCEDURE .

PROCEDURE ДПостОбесп:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.


   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "Ошибочное количество параметров передано в функцию ""НомДог"":" param-count "(должно быть 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   pick-value = GetXAttrValueEx ("term-obl",
                                       b-term-obl.contract + ","
                                     + b-term-obl.cont-code + ",5,"
                                     + STRING(b-term-obl.end-date) + ","
                                     + STRING(b-term-obl.nn),
                                       "ДатаПост",
                                       "").

END PROCEDURE.

PROCEDURE ДВыбОбесп:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.


   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "Ошибочное количество параметров передано в функцию ""НомДог"":" param-count "(должно быть 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   pick-value = STRING(b-term-obl.sop-date,"99/99/9999").

END PROCEDURE.

PROCEDURE КатОбесп:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.


   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "Ошибочное количество параметров передано в функцию ""НомДог"":" param-count "(должно быть 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   /* найден договор обеспечения для роли iAcctType */
   pick-value =  Get_QualityGar ("comm-rate",
                                 b-term-obl.contract + "," + 
                                 b-term-obl.cont-code + ",5," + 
                                 STRING(b-term-obl.end-date) + "," + 
                                 STRING(b-term-obl.nn), 
                                 in-op-date).
   IF    pick-value EQ "?"
      OR pick-value EQ ?
   THEN
      pick-value = "".

END PROCEDURE.

PROCEDURE ВалОбесп:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VAR vKeepCurr AS CHARACTER NO-UNDO.
   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .

   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "Ошибочное количество параметров передано в функцию ""НомДог"":" param-count "(должно быть 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   /* найден договор обеспечения для роли iAcctType */
       vKeepCurr = GetXAttrValueEx ("term-obl",
                                          b-term-obl.contract + ","
                                        + b-term-obl.cont-code + ",5,"
                                        + STRING(b-term-obl.end-date) + ","
                                        + STRING(b-term-obl.nn),
                                          "ВалУчетаОбесп",
                                          ?)    .

            pick-value = IF (vKeepCurr = ? OR vKeepCurr = "") AND
                            b-term-obl.currency <> "" AND
                            b-term-obl.currency <> ?
                         THEN b-term-obl.currency
                         ELSE FGetSetting("КодНацВал",?,"")    .


END PROCEDURE.

PROCEDURE СумОбесп:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VAR vKeepCurr AS CHARACTER NO-UNDO.
   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "Ошибочное количество параметров передано в функцию ""НомДог"":" param-count "(должно быть 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   /* найден договор обеспечения для роли iAcctType */
    vKeepCurr = GetXAttrValueEx ("term-obl",
                                       b-term-obl.contract + ","
                                     + b-term-obl.cont-code + ",5,"
                                     + STRING(b-term-obl.end-date) + ","
                                     + STRING(b-term-obl.nn),
                                       "ВалУчетаОбесп",
                                       ?).

         IF vKeepCurr = ? OR vKeepCurr = ""  or b-term-obl.currency = '' THEN
            pick-value = STRING(b-term-obl.amt-rub).
         ELSE
            IF vKeepCurr = "810" OR vKeepCurr = "RUR" THEN
               pick-value = GetXAttrValueEx ("term-obl",
                                             b-term-obl.contract + ","
                                           + b-term-obl.cont-code + ",5,"
                                           + STRING(b-term-obl.end-date) + ","
                                           + STRING(b-term-obl.nn),
                                             "СуммаНацВал",
                                             ?).

END PROCEDURE.


/* Получение краткого наименования клиента */
PROCEDURE ИмяКлиентаКр:
   DEFINE INPUT PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vCustName AS CHARACTER NO-UNDO.

   DEFINE BUFFER buf-loan FOR loan.

   ASSIGN
      pick-value = ""
      vContract  = GetCustomField("ContractCreateLoan")
      vContCode  = GetCustomField("ContCodeCreateLoan").

   IF param-count NE 0 THEN DO:
      RUN Fill-SysMes IN h_tmess ("","","-1","Ошибочное количество параметров "
         + "передано в функцию ~"ИмяКлиентаКр~": param-count (должно быть 0).").
      RETURN.
   END.

   FIND buf-loan WHERE buf-loan.contract  EQ vContract
                   AND buf-loan.cont-code EQ vContCode
                   NO-LOCK NO-ERROR.
   IF NOT AVAIL buf-loan THEN DO:
      RUN Fill-SysMes IN h_tmess ("","","-1","Не найден кредитный договор " + 
          vContCode + ".").
      RETURN.
   END.

   RUN GetCustNameShort IN h_base (buf-loan.cust-cat,
                                   buf-loan.cust-id,
                                   OUTPUT vCustName).
   ASSIGN
      pick-value = vCustName.

END PROCEDURE.

/* Наименование субъекта, указанного в договоре обеспечения */
PROCEDURE ИмяПоручит:
   DEFINE INPUT PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VAR iAcctType AS CHAR NO-UNDO.
   DEFINE VAR vName1    AS CHAR NO-UNDO.
   DEFINE VAR vName2    AS CHAR NO-UNDO.
   DEFINE VAR vInn      AS CHAR NO-UNDO.

   DEF BUFFER b-term-obl FOR term-obl.

   ASSIGN
      pick-value = ""
      iAcctType = getparam(1, param-str).

   IF param-count NE 1 THEN DO:
      RUN Fill-SysMes IN h_tmess ("","","-1","Ошибочное количество параметров "
         + "передано в функцию ~"ИмяПоручит~": param-count (должно быть 1).").
      RETURN.
   END.

   /* Поиск договора обеспечения для роли iAcctType */
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl THEN DO:
      RUN Fill-SysMes IN h_tmess ("","","-1","Не найден договор обеспечения для "
         + " роли " + iAcctType + ".").
      RETURN.
   END.

   RUN GetCustName IN h_base (b-term-obl.symbol,
                              b-term-obl.fop,
                              ?,
                              OUTPUT vName1,
                              OUTPUT vName2,
                              INPUT-OUTPUT vInn).
   ASSIGN
      pick-value = (IF vName1 NE ? THEN vName1 + " " ELSE "") + 
                   (IF vName2 NE ? THEN vName2       ELSE "").

END PROCEDURE.


/* Краткое наименование субъекта, указанного в договоре обеспечения */
PROCEDURE ИмяПоручитКр:
   DEFINE INPUT PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE iAcctType AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vCustName AS CHARACTER NO-UNDO.

   DEF BUFFER b-term-obl FOR term-obl.

   ASSIGN
      pick-value = ""
      iAcctType = getparam(1, param-str).

   IF param-count NE 1 THEN DO:
      RUN Fill-SysMes IN h_tmess ("","","-1","Ошибочное количество параметров " + 
          "передано в функцию ~"ИмяПоручитКр~": param-count (должно быть 1).").
      RETURN.
   END.

   /* Поиск договора обеспечения для роли iAcctType */
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl THEN DO:
      RUN Fill-SysMes IN h_tmess ("","","-1","Не найден договор обеспечения для "
         + "роли " + iAcctType + ".").
      RETURN.
   END.

   RUN GetCustNameShort IN h_base (b-term-obl.symbol,
                                   b-term-obl.fop,  
                                   OUTPUT vCustName).
   ASSIGN 
      pick-value = vCustName.

END PROCEDURE.
   

/* Процентная ставка договора */
PROCEDURE ПрСтавка:
   DEFINE INPUT PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vCodeCom  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vClLoanDr AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vPosCCode AS INT64   NO-UNDO.

   DEFINE BUFFER buf-loan      FOR loan.
   DEFINE BUFFER buf-loan-cond FOR loan-cond.
   DEFINE BUFFER buf-comm-rate FOR comm-rate.

   ASSIGN
      pick-value = ""
      vContract  = GetCustomField("ContractCreateLoan")
      vContCode  = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan WHERE buf-loan.contract  EQ vContract
                   AND buf-loan.cont-code EQ vContCode
                   NO-LOCK NO-ERROR.
   IF NOT AVAIL buf-loan THEN DO:
      RUN Fill-SysMes IN h_tmess ("","","-1","Не найден кредитный договор " 
         + vContCode + ".").
      RETURN.
   END.

   /* Тип кода комиссии, если "Кредит", то "%Кред", если "Депоз", то "%Деп" */
   ASSIGN
      vCodeCom = IF (TRIM(buf-loan.contract) EQ "Кредит") THEN "%Кред" ELSE "%Деп".

   /* Если код договора состоит из двух частей */
   ASSIGN
      vPosCCode = INDEX(vContCode, " ").

   IF vPosCCode GT 0 THEN DO:
      /* Определяем начальное значение ДР класса текущего кредитного договора */
      vClLoanDr = GetXAttrValue("loan", vContract + "," + vContCode, "КодКомНач").

      /* Если код комиссии входит в нач.значение ДР класса договора 
      ** то поиск ставки продолжаем на текущем договоре иначе: */
      IF LOOKUP(vCodeCom, vClLoanDr) EQ 0 THEN DO:

         /* Производим поиск вышестоящего договора
         ** т.к. начальное значение "КодКомНач" не содержит главного кода комиссии,
         ** и это означает, что начисление процентов по договору не должно выполняться */
         ASSIGN
            vContCode = SUBSTRING(vContCode, 1, vPosCCode - 1). 
         FIND buf-loan WHERE buf-loan.contract  EQ vContract
                         AND buf-loan.cont-code EQ vContCode
                         NO-LOCK NO-ERROR.
         IF NOT AVAIL buf-loan THEN DO:
            RUN Fill-SysMes IN h_tmess ("","","-1","Не найден кредитный договор " 
               + vContCode + ".").
            RETURN.
         END.
      END.
   END.
   
   /* Ищем первое условие по договору */
   FOR EACH buf-loan-cond WHERE buf-loan-cond.contract  EQ vContract
                            AND buf-loan-cond.cont-code EQ vContCode
                            NO-LOCK 
                            BY  buf-loan-cond.since:
      /* Первая ставка по первому условию договора */
      FOR EACH buf-comm-rate WHERE buf-comm-rate.commi EQ vCodeCom
                               AND buf-comm-rate.kau   EQ vContract + "," + vContCode
                               AND buf-comm-rate.since GE buf-loan-cond.since 
                               NO-LOCK 
                               BY  buf-comm-rate.since:
         pick-value = STRING(buf-comm-rate.rate-comm).
         LEAVE.
      END.
      LEAVE.
   END.

END PROCEDURE.

/* Возвращает ДР с договора */
PROCEDURE ДогДР:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.

   pick-value = "".
   IF param-count NE 1 THEN DO:
      MESSAGE "Ошибочное количество параметров передано в функцию ""ДогДР"":" param-count "(должн быть 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   ASSIGN
      vContract = GetCustomField("ContractCreateLoan")
      vContCode = GetCustomField("ContCodeCreateLoan").
      
    pick-value = GetXattrValueEx("loan",vContract + "," + vContCode,getparam(1,param-str),"").

END PROCEDURE.


/**
 * SSitov: #1192
 * Возвращает номер охватывающего договора
 **/

PROCEDURE ПИРНомОхДог:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.
   
   pick-value = "".

   IF param-count GT 0 THEN DO:
      MESSAGE "Ошибочное количество параметров передано в функцию ""ПИРНомОхДог"":" param-count "(должно быть не больше 0) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   IF NUM-ENTRIES(vContCode," ") > 1 THEN 
	vContCode = ENTRY(1,vCOntCode," ") .
   ELSE 
	vContCode =  vCOntCode .

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ vCOntCode
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN pick-value = buf-loan.doc-ref.  

END PROCEDURE.


/**
 * SSitov: #1192
 * Возвращает ДатаСогл с охватывающего договора 
 **/
PROCEDURE ПИРОхДогДатаСогл:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.
   
   pick-value = "".

   IF param-count GT 0 THEN DO:
      MESSAGE "Ошибочное количество параметров передано в функцию ""ПИРОхДогДатаСогл"":" param-count "(должно быть ранен 0) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   IF NUM-ENTRIES(vContCode," ") > 1 THEN 
	vContCode = ENTRY(1,vCOntCode," ") .
   ELSE 
	vContCode =  vCOntCode .

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ vCOntCode
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN 
	pick-value = GetXattrValueEx("loan",vContract + "," + vContCode,"ДатаСогл","").

END PROCEDURE.
