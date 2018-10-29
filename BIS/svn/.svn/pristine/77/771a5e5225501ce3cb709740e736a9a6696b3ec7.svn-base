{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
                Отчет ПОДФТ по крупным клиентам
		сделан из pir_krupnye.p - добавлен выбор счетов,
		подключается Ctrl-G в браузере счетов
Доработал 09/02/12 SStepanov новая группа для новых клиентов с другим
cust-id и person-id
		#843 задача на стыке интересов ПОДФТ(pir_krupnye*.p) и открытие счетов и платстики(pir_anketa.p)
		ПОДФТ запросило, чтобы у них была другая функциональность по версия для ПОДФТ всегда показывает дату открытия счета
		PROCEDURE FirstKlAcctPODFT :
		версия для всех кроме ПОДФТ не показывает дату открытия счета если он закрыт PROCEDURE FirstKlAcct :
*/

{globals.i}           /** Глобальные определения */
{tmprecid.def}        /** Используем информацию из броузера */
{intrface.get xclass} /** Функции для работы с метасхемой */
{intrface.get strng}  /** Функции для работы со строками */

{tmprecid.def}        /** Используем информацию из броузера */

{sh-defs.i}

/******************************************* Определение переменных и др. */
DEFINE INPUT PARAM icPorog AS CHAR         NO-UNDO.

DEFINE VARIABLE dPorog  AS DECIMAL   NO-UNDO.
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

/*******************************************  */
dPorog = DECIMAL(icPorog).

{pir_krupnye.frm}
{pir_anketa.fun}
{pir_exf_exl.i}

cXL = "/home2/bis/quit41d/imp-exp/users/" + LC(UserID("bisquit")) + "/BigCred.xls".
REPEAT:
   {getfile.i &filename = cXL &mode = create} 
   LEAVE.
END.
/*
{exp-path.i &exp-filename = "'BigCred.xls'"}
iMes = MONTH(end-date).
iGod = YEAR(end-date).
iYM  = 12 * iGod + iMes.

daBegM  = DATE(iMes, 1, iGod).
daBegYP = DATE(iMes, 1, iGod - 1).
iMes1   = (iYM MODULO 12) + 1.
iGod1   = INTEGER(TRUNCATE(iYM / 12, 0)).
daEndM  = DATE(iMes1, 1, iGod1) - 1.
daBegY  = DATE(iMes1, 1, iGod1 - 1).
*/

/*******************************************  */
PUT UNFORMATTED XLHead("Тест на " + STRING(TODAY, "99.99.9999"),
                       "CCCNNNNNNDD", "215,92,150,110,110,110,110,110,110,71,71").

cXL = XLCell("Наименование Клиента")
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
/*
FOR EACH cust-corp
   WHERE (cust-corp.date-out EQ ?)
   NO-LOCK
   BY cust-corp.name-corp
   BY cust-corp.cust-id
:

   put screen col 1 row 24 "Обрабатывается " + STRING(cust-corp.name-corp) + FILL(" ", 60).

   CREATE ttCl.
   ASSIGN
      ttCl.cClName = cust-corp.cust-stat + " " + cust-corp.name-corp
      ttCl.cClType = (IF ((cust-corp.cust-stat EQ "ИП")
                       OR (cust-corp.cust-stat EQ "ПБОЮЛ")
                       OR (cust-corp.cust-stat EQ "Адвокат")
                       OR (cust-corp.cust-stat EQ "Нотариус")
                       OR (cust-corp.cust-stat EQ "ГКХ")
                         ) THEN "Ч" ELSE "Ю")
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

   FOR EACH acct
      WHERE (acct.cust-cat EQ "Ю")
        AND (acct.cust-id  EQ cust-corp.cust-id)
        AND (acct.acct BEGINS "40")
        AND NOT CAN-DO("Накоп,Спец", acct.contract)
        AND ((acct.close-date GT daBegYP)
          OR (acct.close-date EQ ?))
*/

DEF BUFFER bacct FOR acct.
FOR EACH tmprecid NO-LOCK
	, FIRST acct
		WHERE RECID(acct) 	= tmprecid.id
		      AND acct.cust-cat 	= "Ю"
		NO-LOCK
	, FIRST cust-corp
   	  	WHERE cust-corp.cust-id = acct.cust-id
   		NO-LOCK
   BREAK BY cust-corp.name-corp
      	 BY cust-corp.cust-id
:

  IF    FIRST-OF(cust-corp.name-corp) 
     OR FIRST-OF(cust-corp.cust-id)   THEN DO:

   put screen col 1 row 24 "Обрабатывается " + STRING(cust-corp.name-corp) + FILL(" ", 60).

   CREATE ttCl.
   ASSIGN
      ttCl.cClName = cust-corp.cust-stat + " " + cust-corp.name-corp
      ttCl.cClType = (IF ((cust-corp.cust-stat EQ "ИП")
                       OR (cust-corp.cust-stat EQ "ПБОЮЛ")
                       OR (cust-corp.cust-stat EQ "Адвокат")
                       OR (cust-corp.cust-stat EQ "Нотариус")
                       OR (cust-corp.cust-stat EQ "ГКХ")
                         ) THEN "Ч" ELSE "Ю")
      ttCl.cClINN  = (IF (cust-corp.country-id EQ "RUS") THEN cust-corp.inn
                      ELSE GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "ИИН"))
      ttCl.dMDb    = 0
      ttCl.dMCr    = 0
      ttCl.dYDb    = 0
      ttCl.dYCr    = 0
      ttCl.dYPDb   = 0
      ttCl.dYPCr   = 0
      NO-ERROR.

  END. /* IF FIRST-OF(cust-corp.name-corp) THEN DO: */

      cXL = XLCell(ttCl.cClName)
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
/*   END. */

  IF    LAST-OF(cust-corp.name-corp)
     OR LAST-OF(cust-corp.cust-id)  THEN DO:
/* PUT UNFORMATTED "RUN FirstKlAcct(ЮЛ" cust-corp.cust-id SKIP. */
   IF (ttCl.cClType EQ "Ю")
   THEN
      RUN FirstKlAcctPODFT("ЮЛ", cust-corp.cust-id, OUTPUT cFstAcct, OUTPUT ttCl.daFAcc, OUTPUT daFirstCl, OUTPUT cUsrFirst).
   ELSE
      RUN FirstKlAcctPODFT("ИП", cust-corp.cust-id, OUTPUT cFstAcct, OUTPUT ttCl.daFAcc, OUTPUT daFirstCl, OUTPUT cUsrFirst).

   IF (daFirstCl NE ?)
   THEN DO:
      ttCl.daLAcc  = daFirstCl.

      FOR EACH bacct
         WHERE (bacct.cust-cat EQ "Ю")
           AND (bacct.cust-id  EQ cust-corp.cust-id)
           AND (bacct.acct BEGINS "40")
           AND NOT CAN-DO("Накоп,Спец", bacct.contract)
           AND NOT (bacct.close-date GT daFirstCl)
         NO-LOCK
         BY bacct.close-date DESCENDING:

         ttCl.daLAcc  = bacct.close-date.
         LEAVE.
      END.
   END.
  END. /* IF LAST-OF(cust-corp.name-corp) THEN DO: */
END. /* FOR EACH tmprecid NO-LOCK */

/*******************************************  */
/*
FOR EACH person
   WHERE (person.date-out EQ ?)
   NO-LOCK
   BY person.name-last
   BY person.person-id
:

   put screen col 1 row 24 "Обрабатывается " + person.name-last + " " + person.first-names + FILL(" ", 60).

   CREATE ttCl.
   ASSIGN
      ttCl.cClName = person.name-last + " " + person.first-names
      ttCl.cClType = "Ч"
      ttCl.cClINN  = (IF ((person.inn EQ "000000000000") OR (person.inn = "0")) THEN "" ELSE person.inn)
      ttCl.dMDb    = 0
      ttCl.dMCr    = 0
      NO-ERROR.

   FOR EACH acct
      WHERE (acct.cust-cat EQ "Ч")
        AND (acct.cust-id  EQ person.person-id)
        AND (acct.acct BEGINS "40")
        AND NOT CAN-DO("Накоп,Спец", acct.contract)
        AND ((acct.close-date GT daBegYP)
          OR (acct.close-date EQ ?))
      NO-LOCK:
*/
FOR EACH tmprecid NO-LOCK
	, FIRST acct
		WHERE RECID(acct) 	= tmprecid.id
		      AND acct.cust-cat 	= "Ч"
		NO-LOCK
	, FIRST person
   	  	WHERE person.person-id = acct.cust-id
   		NO-LOCK
   BREAK BY person.name-last
         BY person.person-id
:

  IF    FIRST-OF(person.name-last)
     OR FIRST-OF(person.person-id) /* SSV вернул вновь 24/02/12 */
  THEN DO:
   put screen col 1 row 24 "Обрабатывается " + person.name-last + " " + person.first-names + FILL(" ", 60).

   CREATE ttCl.
   ASSIGN
      ttCl.cClName = person.name-last + " " + person.first-names
      ttCl.cClType = "Ч"
      ttCl.cClINN  = (IF ((person.inn EQ "000000000000") OR (person.inn = "0")) THEN "" ELSE person.inn)
      ttCl.dMDb    = 0
      ttCl.dMCr    = 0
      NO-ERROR.
  END. /* IF FIRST-OF(person.name-last) THEN DO: */

      cXL = XLCell(ttCl.cClName)
          + XLCell(ttCl.cClINN)
          + XLCell(acct.acct)
          + XLEmptyCells(2)
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
/*   END. */

/* PUT UNFORMATTED "RUN FirstKlAcct(ЮЛ" cust-corp.cust-id SKIP. */
   RUN FirstKlAcctPODFT("ФЛ", person.person-id, OUTPUT cFstAcct, OUTPUT ttCl.daFAcc, OUTPUT daFirstCl, OUTPUT cUsrFirst).

  IF    LAST-OF(person.name-last)
     OR LAST-OF(person.person-id)
THEN DO:
   IF (daFirstCl NE ?)
   THEN DO:
      ttCl.daLAcc  = daFirstCl.

      FOR EACH bacct
         WHERE (bacct.cust-cat EQ "Ч")
           AND (bacct.cust-id  EQ person.person-id)
           AND (bacct.acct BEGINS "40")
           AND NOT CAN-DO("Накоп,Спец", bacct.contract)
           AND NOT (bacct.close-date GT daFirstCl)
         NO-LOCK
         BY bacct.close-date DESCENDING:

         ttCl.daLAcc  = bacct.close-date.
         LEAVE.
      END.
   END.
  END. /* IF LAST-OF(person.name-last) THEN DO: */
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
   WHERE (ttCl.cClType EQ "Ю")
   NO-LOCK
   BY ttCl.dYDb DESCENDING:

   ASSIGN
      iR         = iR + 1
      ttCl.iRate = iR
      dSYDb = dSYDb + ttCl.dYDb
      dSYCr = dSYCr + ttCl.dYCr
      dSMDb = dSMDb + ttCl.dMDb
      dSMCr = dSMCr + ttCl.dMCr
      NO-ERROR.
END.

iR = 0.
FOR EACH ttCl
   WHERE (ttCl.cClType EQ "Ю")
   NO-LOCK
   BY ttCl.dYPDb DESCENDING:

   iR          = iR + 1.
   ttCl.iRateP = iR.
END.

iR = 0.
FOR EACH ttCl
   WHERE (ttCl.cClType EQ "Ю")
   NO-LOCK
   BY ttCl.dMDb DESCENDING:

   iR          = iR + 1.
   ttCl.iRateM = IF (ttCl.dMDb NE 0) THEN iR ELSE 0.
END.

/*******************************************  */
PUT UNFORMATTED XLNextList(cListN, "IICCNNINNCCCCDD", "53,53,215,92,110,110,53,110,110,50,50,50,50,71,71").

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
    + XLCell("ИНН")
    + XLCell("Годовой Оборот по Дебету")
    + XLCell("Годовой Оборот по Кредиту")
    + XLCell("Рейтинг за " + ENTRY(iMes, cMesStr))
    + XLCell("Месячный Оборот по Дебету")
    + XLCell("Месячный Оборот по Кредиту")
    + XLCell("Дата последнего отчета")
    + XLCell("Анализ (план на " + ENTRY(iMes1, cMesStr) + ")")
    + XLCell("ПМН")
    + XLCell("Справка по ПМН")
    + XLCell("Дата откр.первого р/с")
    + XLCell("Дата закрытия последнего счета")
    .

PUT UNFORMATTED XLRow(1) cXL XLRowEnd().

FOR EACH ttCl
   WHERE (ttCl.cClType EQ "Ю")
   NO-LOCK
   BY ttCl.iRate
   iR = 1 TO 30 :

   ASSIGN
      dSY30Db = dSY30Db + ttCl.dYDb
      dSY30Cr = dSY30Cr + ttCl.dYCr
      dSM30Db = dSM30Db + ttCl.dMDb
      dSM30Cr = dSM30Cr + ttCl.dMCr
      ttCl.cClType = "30"
      NO-ERROR.

   IF (iR LE 20)
   THEN
      ASSIGN
         dSY20Db = dSY20Db + ttCl.dYDb
         dSY20Cr = dSY20Cr + ttCl.dYCr
         dSM20Db = dSM20Db + ttCl.dMDb
         dSM20Cr = dSM20Cr + ttCl.dMCr
         NO-ERROR.

   cXL = XLNumCell(ttCl.iRateP)
       + XLNumCell(ttCl.iRate)
       + XLCell(ttCl.cClName)
       + XLCell(ttCl.cClINN)
       + XLNumCell(ttCl.dYDb)
       + XLNumCell(ttCl.dYCr)
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
    + XLCell("Всего по 20:")
    + XLEmptyCell()
    + XLNumCell(dSY20Db)
    + XLNumCell(dSY20Cr)
    + XLEmptyCell()
    + XLNumCell(dSM20Db)
    + XLNumCell(dSM20Cr)
    .
PUT UNFORMATTED XLRow(2) cXL XLRowEnd() .

cXL = XLEmptyCells(2)
    + XLCell("Всего по 30:")
    + XLEmptyCell()
    + XLNumCell(dSY30Db)
    + XLNumCell(dSY30Cr)
    + XLEmptyCell()
    + XLNumCell(dSM30Db)
    + XLNumCell(dSM30Cr)
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

cXL = XLEmptyCells(2)
    + XLCell("Итого оборотов за год/месяц:")
    + XLEmptyCell()
    + XLNumCell(dSYDb)
    + XLNumCell(dSYCr)
    + XLEmptyCell()
    + XLNumCell(dSMDb)
    + XLNumCell(dSMCr)
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

cXL = XLEmptyCells(2)
    + XLCell("Доля оборотов 20 крупных Клиентов (%):")
    + XLEmptyCell()
    + XLNumCell(ROUND(dSY20Db / dSYDb * 100, 2))
    + XLNumCell(ROUND(dSY20Cr / dSYCr * 100, 2))
    + XLEmptyCell()
    + XLNumCell(ROUND(dSM20Db / dSMDb * 100, 2))
    + XLNumCell(ROUND(dSM20Cr / dSMCr * 100, 2))
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

/*******************************************  */
cXL = XLCell("Другие Клиенты, имеющие обороты свыше " + STRING(dPorog / 1000000) + " млн. рублей за "
            + ENTRY(iMes, cMesStr) + " " + STRING(iGod, "9999") + " года").
PUT UNFORMATTED XLRow(2) XLRowEnd() XLRow(0) cXL XLRowEnd().

cXL = XLEmptyCell()
    + XLCell("N п/п")
    + XLCell("Наименование Клиента")
    + XLCell("ИНН")
    + XLCell("Годовой Оборот по Дебету")
    + XLCell("Годовой Оборот по Кредиту")
    + XLCell("Рейтинг за " + ENTRY(iMes, cMesStr))
    + XLCell("Месячный Оборот по Дебету")
    + XLCell("Месячный Оборот по Кредиту")
    + XLCell("Дата последнего отчета")
    + XLCell("Анализ (план на " + ENTRY(iMes1, cMesStr) + ")")
    + XLCell("ПМН")
    + XLCell("Справка по ПМН")
    + XLCell("Дата откр.первого р/с")
    + XLCell("Дата закрытия последнего счета")
    .

PUT UNFORMATTED XLRow(1) cXL XLRowEnd().

ASSIGN
   iR    = 0
   dSYDb = 0
   dSYCr = 0
   dSMDb = 0
   dSMCr = 0
   NO-ERROR.

FOR EACH ttCl
   WHERE (ttCl.cClType NE "30")
     AND (ttCl.dMDb    GE dPorog)
   NO-LOCK
   BY ttCl.dMDb DESCENDING:

   ASSIGN
      iR         = iR + 1
      dSYDb = dSYDb + ttCl.dYDb
      dSYCr = dSYCr + ttCl.dYCr
      dSMDb = dSMDb + ttCl.dMDb
      dSMCr = dSMCr + ttCl.dMCr
      NO-ERROR.

   cXL = XLEmptyCell()
       + XLNumCell(iR)
       + XLCell(ttCl.cClName)
       + XLCell(ttCl.cClINN)
       + XLNumCell(ttCl.dYDb)
       + XLNumCell(ttCl.dYCr)
       + (IF (ttCl.cClType EQ "Ю") THEN XLNumCell(ttCl.iRateM) ELSE XLCell("--"))
       + XLNumCell(ttCl.dMDb)
       + XLNumCell(ttCl.dMCr)
       + XLEmptyCells(4)
       + XLDateCell(ttCl.daFAcc)
       + XLDateCell(ttCl.daLAcc)
       .
   PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
END.

cXL = XLEmptyCells(2)
    + XLCell("Итого:")
    + XLEmptyCell()
    + XLNumCell(dSYDb)
    + XLNumCell(dSYCr)
    + XLEmptyCell()
    + XLNumCell(dSMDb)
    + XLNumCell(dSMCr)
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

PUT UNFORMATTED XLEnd().

{intrface.del}
