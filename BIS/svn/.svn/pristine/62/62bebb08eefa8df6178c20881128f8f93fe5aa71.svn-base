{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
                Отчет ПОДФТ по крупным клиентам
	23/01/12 SStepanov версия для ПОДФТ всегда показывает дату открытия счета
*/

{globals.i}           /** Глобальные определения */
{tmprecid.def}        /** Используем информацию из броузера */
{intrface.get xclass} /** Функции для работы с метасхемой */
{intrface.get strng}  /** Функции для работы со строками */

{sh-defs.i}

/******************************************* Определение переменных и др. */
/*
DEFINE INPUT PARAM icPorog AS CHAR         NO-UNDO.
*/
DEFINE VARIABLE cXL     AS CHARACTER NO-UNDO.
/*
DEFINE VARIABLE iMes    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iGod    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iMes1   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iGod1   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iYM     AS INTEGER   NO-UNDO.
DEFINE VARIABLE daBegY  AS DATE      NO-UNDO.
DEFINE VARIABLE daBegM  AS DATE      NO-UNDO.
DEFINE VARIABLE daBegYP AS DATE      NO-UNDO.
DEFINE VARIABLE daEndM  AS DATE      NO-UNDO.
*/
DEFINE VARIABLE cMesStr AS CHARACTER INIT "Январь,Февраль,Март,Апрель,Май,Июнь,Июль,Август,Сентябрь,Октябрь,Ноябрь,Декабрь"  NO-UNDO.

DEFINE TEMP-TABLE ttCl NO-UNDO
   FIELD iRate   AS INTEGER
   FIELD iRateM  AS INTEGER
   FIELD iRateP  AS INTEGER
   FIELD cClName AS CHARACTER
   FIELD cClType AS CHARACTER
   FIELD cFlUlIp AS CHARACTER
   FIELD cClINN  AS CHARACTER
   FIELD dYDb    AS DECIMAL
   FIELD dYCr    AS DECIMAL
   FIELD dMDb    AS DECIMAL
   FIELD dMCr    AS DECIMAL
   FIELD dYPDb   AS DECIMAL
   FIELD dYPCr   AS DECIMAL
   FIELD daFAcc  AS DATE
   FIELD daLAcc  AS DATE
.
DEFINE VARIABLE cFstAcct  AS CHARACTER NO-UNDO.
DEFINE VARIABLE daFirstCl AS DATE      NO-UNDO.
DEFINE VARIABLE cUsrFirst AS CHARACTER NO-UNDO.
DEFINE VARIABLE iR        AS INTEGER   NO-UNDO.

DEFINE VARIABLE dSYDb     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSYCr     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSY20Db   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSY20Cr   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSY30Db   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSY30Cr   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSMDb     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSMCr     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSM20Db   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSM20Cr   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSM30Db   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSM30Cr   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE iVR 	  AS INTEGER FORMAT "9" INITIAL 1 NO-UNDO. 
DEFINE VARIABLE cVA       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cVN       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cVV       AS CHARACTER NO-UNDO.

/*******************************************  */
/*
dPorog = DECIMAL(icPorog).
*/

pause 0.
{pir_krupnye2.frm}
{pir_anketa.fun}
{pir_exf_exl.i}

FORM
   "1 - Все включая транзитные счета;"
   "2 - Все без транзитных счетов;"
   "3 - Только валютные счета без транзитных счетов ;"
   "4 - Только рублевые счета."
   iVR LABEL "ВАРИАНТ" VALIDATE ( iVR < 5 and iVR <> 0, "Несуществующий вариант !!!")
   WITH FRAME fVR 
   OVERLAY
   SIDE-LABELS
   1 COL
   CENTERED
   ROW 3 
   TITLE COLOR BRIGHT-WHITE "[ Введите вариант расчета: ]"
   WIDTH 60.

DO 
   ON ENDKEY UNDO , RETURN
   ON ERROR  UNDO , RETRY
:
   UPDATE iVR WITH FRAME fVR.
END.
HIDE FRAME fVR.


cXL = "/home2/bis/quit41d/imp-exp/users/" + LC(UserID("bisquit")) + "/BigCred2.xls".
REPEAT:
   {getfile.i &filename = cXL &mode = create} 
   LEAVE.
END.

/*******************************************  */
PUT UNFORMATTED XLHead("Тест на " + STRING(TODAY, "99.99.9999"),
                       "CCCCNNNNNNDD", "215,70,92,150,110,110,110,110,110,110,71,71").

cXL = XLCell("Наименование Клиента")
    + XLCell("УНК")
    + XLCell("ИНН")
    + XLCell("Acct")
    + XLCell("Пред.Год. Оборот по Дебету")
    + XLCell("Пред.Год. Оборот по Кредиту")
    + XLCell("Годовой Оборот по Дебету")
    + XLCell("Годовой Оборот по Кредиту")
    + XLCell("Месячный Оборот по Дебету")
    + XLCell("Месячный Оборот по Кредиту")
    + XLCell("Дата откр. р/с")
    + XLCell("Дата закрытия счета")
    .

PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

/*******************************************  */
FOR EACH cust-corp
   WHERE (cust-corp.date-out EQ ?)

/* AND name-corp = '"Максима"'  !!! */

   NO-LOCK
   BY cust-corp.name-corp:

   put screen col 1 row 24 "Обрабатывается " + STRING(cust-corp.name-corp) + FILL(" ", 60).

   CREATE ttCl.
   ASSIGN
      ttCl.cClName = cust-corp.cust-stat + " " + cust-corp.name-corp
      ttCl.cClType = (IF ((cust-corp.cust-stat EQ "ИП")
                       OR (cust-corp.cust-stat EQ "ПБОЮЛ")
                       OR (cust-corp.cust-stat EQ "Адвокат")
                       OR (cust-corp.cust-stat EQ "Нотариус")
                       OR (cust-corp.cust-stat EQ "ГКХ")
                         ) THEN  "Ч" ELSE  "Ю")
      ttCl.cFlUlIp = (IF ((cust-corp.cust-stat EQ "ИП")
                       OR (cust-corp.cust-stat EQ "ПБОЮЛ")
                       OR (cust-corp.cust-stat EQ "Адвокат")
                       OR (cust-corp.cust-stat EQ "Нотариус")
                       OR (cust-corp.cust-stat EQ "ГКХ")
                         ) THEN "ИП" ELSE "ЮЛ")
/*      ttCl.cClINN  = (IF (cust-corp.country-id EQ "RUS") THEN cust-corp.inn
                      ELSE GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "ИИН"))
*/    
      /* #3358 */
      ttCl.cClINN  = (IF (cust-corp.inn <> "") THEN cust-corp.inn
                      ELSE GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "ИИН"))
      ttCl.dMDb    = 0
      ttCl.dMCr    = 0
      ttCl.dYDb    = 0
      ttCl.dYCr    = 0
      ttCl.dYPDb   = 0
      ttCl.dYPCr   = 0
      NO-ERROR.

   /*#3305 начало. список транз. счетов сформирован в результате совещания с Кузьминой Н. и Красковым А.*/
   if iVR eq 1 then do:
           cVA = "405*,406*,407*,40807*,40802*,40804*,40805*,40814*,40815*". /*список счетов взят из письма от Капитановой #1142 */
           cVN = "*".
	   cVV = "*".	
   end.
   if iVR eq 2 then do:
	   cVA = "!*7......,!*7.....,405*,406*,407*,40807*,40802*,40804*,40805*,40814*,40815*".
	   cVN = "!Транз*,*".
	   cVV = "*".	
   end.
   if iVR eq 3 then do:
	   cVA = "!*7......,!*7.....,405*,406*,407*,40807*,40802*,40804*,40805*,40814*,40815*".
	   cVN = "!Транз*,*".
	   cVV = "!,*".	
   end.
   if iVR eq 4 then do:
	   cVA = "405*,406*,407*,40807*,40802*,40804*,40805*,40814*,40815*".
	   cVN = "*".
	   cVV = "".	
   end.
   /*#3305 конец*/

   FOR EACH acct
      WHERE (acct.cust-cat EQ "Ю")
        AND (acct.cust-id  EQ cust-corp.cust-id)
        AND can-do(cVA,acct.acct)    
        AND CAN-DO(cVN, acct.contract)
        AND CAN-DO(cVV, acct.currency)
        AND ((acct.close-date GT daBegYP)
          OR (acct.close-date EQ ?))
      NO-LOCK:

      cXL = XLCell(ttCl.cClName)
          + XLCell(GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "УНК"))
          + XLCell(ttCl.cClINN)
          + XLCell(acct.acct)
          .

      RUN acct-pos IN h_base(acct.acct, acct.currency, daBegYP, daEndYP, cXL).
      ttCl.dYPDb = ttCl.dYPDb + sh-db.
      ttCl.dYPCr = ttCl.dYPCr + sh-cr.
      cXL = cXL
          + XLNumCell(sh-db)
          + XLNumCell(sh-cr)
          .

      RUN acct-pos IN h_base(acct.acct, acct.currency, daBegY, daEndY, cXL).
      ttCl.dYDb  = ttCl.dYDb  + sh-db.
      ttCl.dYCr  = ttCl.dYCr  + sh-cr.
      cXL = cXL
          + XLNumCell(sh-db)
          + XLNumCell(sh-cr)
          .

      RUN acct-pos IN h_base(acct.acct, acct.currency, daBegM, daEndM, cXL).
      ttCl.dMDb  = ttCl.dMDb  + sh-db.
      ttCl.dMCr  = ttCl.dMCr  + sh-cr.
      cXL = cXL
          + XLNumCell(sh-db)
          + XLNumCell(sh-cr)
          + XLDateCell(acct.open-date)
          + XLDateCell(acct.close-date)
          .

      PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
   END.


   IF (ttCl.cClType EQ "Ю")
   THEN
      RUN FirstKlAcctPODFT("ЮЛ", cust-corp.cust-id, OUTPUT cFstAcct, OUTPUT ttCl.daFAcc, OUTPUT daFirstCl, OUTPUT cUsrFirst).
   ELSE
      RUN FirstKlAcctPODFT("ИП", cust-corp.cust-id, OUTPUT cFstAcct, OUTPUT ttCl.daFAcc, OUTPUT daFirstCl, OUTPUT cUsrFirst).

   IF (daFirstCl NE ?)
   THEN DO:
      ttCl.daLAcc  = daFirstCl.

      FOR EACH acct
         WHERE (acct.cust-cat EQ "Ю")
           AND (acct.cust-id  EQ cust-corp.cust-id)
           AND can-do(cVA,acct.acct)    
           AND CAN-DO(cVN, acct.contract)
           AND CAN-DO(cVV, acct.currency)
           AND (acct.close-date GT daFirstCl)
         NO-LOCK
         BY acct.close-date DESCENDING:
 
         ttCl.daLAcc  = acct.close-date.
         LEAVE.
      END.
   END.
END.

/*******************************************  */
FOR EACH person
   WHERE (person.date-out EQ ?)
/* AND person.name-last = "" / * !!! */
   NO-LOCK
   BY person.name-last:

   put screen col 1 row 24 "Обрабатывается " + person.name-last + " " + person.first-names + FILL(" ", 60).

   CREATE ttCl.
   ASSIGN
      ttCl.cClName = person.name-last + " " + person.first-names
      ttCl.cClType = "Ч"
      ttCl.cFlUlIp = "ФЛ"
      ttCl.cClINN  = (IF ((person.inn EQ "000000000000") OR (person.inn = "0")) THEN "" ELSE person.inn)
      ttCl.dMDb    = 0
      ttCl.dMCr    = 0
      ttCl.dYDb    = 0
      ttCl.dYCr    = 0
      ttCl.dYPDb   = 0
      ttCl.dYPCr   = 0
      NO-ERROR.

   /*#3305 начало. */
   if iVR eq 1 then do:
           cVA = "40817*,40820*,42301*,42601*". /*список счетов взят из письма от Капитановой #1142 */
           cVN = "*".
	   cVV = "*".	
   end.
   if iVR eq 2 then do:
	   cVA = "!*7......,!*7.....,40817*,40820*,42301*,42601*".
	   cVN = "!Транз*,*".
	   cVV = "*".	
   end.
   if iVR eq 3 then do:
	   cVA = "!*7......,!*7.....,40817*,40820*,42301*,42601*".
	   cVN = "!Транз*,*".
	   cVV = "!,*".	
   end.
   if iVR eq 4 then do:
	   cVA = "40817*,40820*,42301*,42601*".
	   cVN = "*".
	   cVV = "".	
   end.
   /*#3305 конец*/

   FOR EACH acct
      WHERE (acct.cust-cat EQ "Ч")
        AND (acct.cust-id  EQ person.person-id)
        AND can-do(cVA,acct.acct)    
        AND CAN-DO(cVN, acct.contract)
        AND CAN-DO(cVV, acct.currency)
        AND ((acct.close-date GT daBegYP)
          OR (acct.close-date EQ ?))
      NO-LOCK:

      cXL = XLCell(ttCl.cClName)
          + XLCell(GetXAttrValue("person", STRING(person.person-id), "УНК"))
          + XLCell(ttCl.cClINN)
          + XLCell(acct.acct)
          .

      RUN acct-pos IN h_base(acct.acct, acct.currency, daBegYP, daEndYP, cXL).
      ttCl.dYPDb = ttCl.dYPDb + sh-db.
      ttCl.dYPCr = ttCl.dYPCr + sh-cr.
      cXL = cXL
          + XLNumCell(sh-db)
          + XLNumCell(sh-cr)
          .

      RUN acct-pos IN h_base(acct.acct, acct.currency, daBegY, daEndY, cXL).
      ttCl.dYDb  = ttCl.dYDb  + sh-db.
      ttCl.dYCr  = ttCl.dYCr  + sh-cr.
      cXL = cXL
          + XLNumCell(sh-db)
          + XLNumCell(sh-cr)
          .

      RUN acct-pos IN h_base(acct.acct, acct.currency, daBegM, daEndM, cXL).
      ttCl.dMDb  = ttCl.dMDb  + sh-db.
      ttCl.dMCr  = ttCl.dMCr  + sh-cr.

      cXL = cXL
          + XLNumCell(sh-db)
          + XLNumCell(sh-cr)
          + XLDateCell(acct.open-date)
          + XLDateCell(acct.close-date)
          .

      PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
   END.

   /* находим первый открытый счет */
   RUN FirstKlAcctPODFT("ФЛ", person.person-id, OUTPUT cFstAcct, OUTPUT ttCl.daFAcc, OUTPUT daFirstCl, OUTPUT cUsrFirst).

   /* если первый открытый счет закрыт, то идем по счетам, которые закрыты после первого счета */
   IF (daFirstCl NE ?)
   THEN DO:
      ttCl.daLAcc  = daFirstCl. /* дата закрытия первого открытого счета */

      FOR EACH acct
         WHERE (acct.cust-cat EQ "Ч")
           AND (acct.cust-id  EQ person.person-id)
           AND can-do(cVA,acct.acct)    
           AND CAN-DO(cVN, acct.contract)
           AND CAN-DO(cVV, acct.currency)
           AND (acct.close-date GT daFirstCl)
         NO-LOCK
         BY acct.close-date DESCENDING:

         ttCl.daLAcc  = acct.close-date.
         LEAVE.
      END.
   END.
END.

put screen col 1 row 24 FILL(" ", 80).

/*******************************************  */
ASSIGN
   iR    = 0
   dSYDb = 0
   dSYCr = 0
   dSMDb = 0
   dSMCr = 0
   NO-ERROR.

FOR EACH ttCl
   NO-LOCK
   BY ttCl.dYDb DESCENDING
   BY ttCl.dYCr DESCENDING:

   ASSIGN
      iR         = iR + 1
      ttCl.iRate = (IF ((ttCl.dYDb + ttCl.dYCr) NE 0) THEN iR ELSE 0)
      dSYDb = dSYDb + ttCl.dYDb
      dSYCr = dSYCr + ttCl.dYCr
      dSMDb = dSMDb + ttCl.dMDb
      dSMCr = dSMCr + ttCl.dMCr
      NO-ERROR.
END.

iR = 0.
FOR EACH ttCl
   NO-LOCK
   BY ttCl.dYPDb DESCENDING
   BY ttCl.dYPCr DESCENDING:

   iR          = iR + 1.
   ttCl.iRateP = IF ((ttCl.dYPDb + ttCl.dYPCr) NE 0) THEN iR ELSE 0.
END.

iR = 0.
FOR EACH ttCl
   NO-LOCK
   BY ttCl.dMDb DESCENDING
   BY ttCl.dMCr DESCENDING:

   iR          = iR + 1.
   ttCl.iRateM = IF ((ttCl.dMDb + ttCl.dMCr) NE 0) THEN iR ELSE 0.
END.

/*******************************************  */
PUT UNFORMATTED XLNextList(cListN, "IICCCNNNNINNCCCCDD", "53,53,215,30,92,110,110,110,110,53,110,110,50,50,50,50,71,71").

IF lNeStnd
THEN
   cXL = XLCell("ОТДЕЛ ПОД/ФТ:  Список крупных Клиентов Банка на " + STRING(daEndM + 1, "99.99.9999") + " года."
              + " (Период 1 : " + STRING(daBegYP, "99.99.9999") + " - " + STRING(daEndYP, "99.99.9999")
              + ", Период 2 : " + STRING(daBegY,  "99.99.9999") + " - " + STRING(daEndY,  "99.99.9999")
              + ", Период 3 : " + STRING(daBegM,  "99.99.9999") + " - " + STRING(daEndM,  "99.99.9999") + ")").
ELSE
   cXL = XLCell("ОТДЕЛ ПОД/ФТ:  Список крупных Клиентов Банка на " + STRING(daEndM + 1, "99.99.9999")
              + " года. Годовой период:  " + STRING(daBegY, "99.99.9999") + " - " + STRING(daEndM, "99.99.9999")
              + ". Месяц - " + ENTRY(iMes, cMesStr) + " " + STRING(iGod, "9999")).
PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

cXL = XLCell("Пред. рейтинг (год)")
    + XLCell("Рейтинг (год)")
    + XLCell("Наименование Клиента")
    + XLCell("Тип")
    + XLCell("ИНН")
    + XLCell("2-й Годовой Оборот по Дебету")
    + XLCell("Прирост к 1-му периоду")
    + XLCell("2-й Годовой Оборот по Кредиту")
    + XLCell("Прирост к 1-му периоду")
    + XLCell("Рейтинг за " + ENTRY(iMes, cMesStr))
    + XLCell("3-й (Месячный) Оборот по Дебету")
    + XLCell("3-й (Месячный) Оборот по Кредиту")
    + XLCell("")
    + XLCell("")
    + XLCell("")
    + XLCell("")
    + XLCell("Дата откр.первого р/с")
    + XLCell("Дата закрытия последнего счета")
    .

PUT UNFORMATTED XLRow(1) cXL XLRowEnd().

FOR EACH ttCl
   WHERE (MAX(ttCl.dYDb, ttCl.dYCr) GE dPorog)
/*
   WHERE (ttCl.cClType EQ "Ю")
*/
   NO-LOCK
   BY ttCl.iRate:

   ASSIGN
      dSY30Db = dSY30Db + ttCl.dYDb
      dSY30Cr = dSY30Cr + ttCl.dYCr
      dSM30Db = dSM30Db + ttCl.dMDb
      dSM30Cr = dSM30Cr + ttCl.dMCr
      NO-ERROR.

   cXL = XLNumCell(ttCl.iRateP)
       + XLNumCell(ttCl.iRate)
       + XLCell(ttCl.cClName)
       + XLCell(ttCl.cFlUlIp)
       + XLCell(ttCl.cClINN)
       + XLNumCell(ttCl.dYDb)
       + XLNumCell(ROUND(ttCl.dYDb / ttCl.dYPDb * 100, 4))
       + XLNumCell(ttCl.dYCr)
       + XLNumCell(ROUND(ttCl.dYCr / ttCl.dYPCr * 100, 4))
       + (IF (ttCl.iRateM NE 0) THEN XLNumCell(ttCl.iRateM) ELSE XLCell("--"))
       + XLNumCell(ttCl.dMDb)
       + XLNumCell(ttCl.dMCr)
       + XLEmptyCells(4)
       + XLDateCell(ttCl.daFAcc)
       + XLDateCell(ttCl.daLAcc)
       .
   PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .
END.

cXL = XLEmptyCells(2)
    + XLCell("Всего по списку:")
    + XLEmptyCell()
    + XLEmptyCell()
    + XLNumCell(dSY30Db)
    + XLEmptyCell()
    + XLNumCell(dSY30Cr)
    + XLEmptyCell()
    + XLEmptyCell()
    + XLNumCell(dSM30Db)
    + XLNumCell(dSM30Cr)
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

cXL = XLEmptyCells(2)
    + XLCell("Итого оборотов за год/месяц:")
    + XLEmptyCell()
    + XLEmptyCell()
    + XLNumCell(dSYDb)
    + XLEmptyCell()
    + XLNumCell(dSYCr)
    + XLEmptyCell()
    + XLEmptyCell()
    + XLNumCell(dSMDb)
    + XLNumCell(dSMCr)
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

cXL = XLEmptyCells(2)
    + XLCell("Доля оборотов крупных Клиентов (%):")
    + XLEmptyCell()
    + XLEmptyCell()
    + XLNumCell(ROUND(dSY30Db / dSYDb * 100, 2))
    + XLEmptyCell()
    + XLNumCell(ROUND(dSY30Cr / dSYCr * 100, 2))
    + XLEmptyCell()
    + XLEmptyCell()
    + XLNumCell(ROUND(dSM30Db / dSMDb * 100, 2))
    + XLNumCell(ROUND(dSM30Cr / dSMCr * 100, 2))
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

/*******************************************  */

PUT UNFORMATTED XLEnd().

{intrface.del}
