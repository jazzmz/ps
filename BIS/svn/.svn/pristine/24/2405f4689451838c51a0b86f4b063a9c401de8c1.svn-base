/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2012 ПИРбанк
     Filename: rep-exp-passp_ip.p
      Comment: Отчет "Сведения о ЮРИДИЧЕСКИХ ЛИЦАХ(физических лицах), у которых истекает
               срок действия паспорта"
      Created: 27.02.2012 Сергей Степанов
*/
/******************************************************************************/
DEFINE INPUT PARAMETER iParms AS CHARACTER NO-UNDO.

{globals.i}
{intrface.get tmess}
{parsin.def}
{prn-doc.def &with_proc=YES}
{tmprecid.def}

DEFINE VAR mSortList     AS CHAR    NO-UNDO.
DEFINE VAR mCounter      AS INT64 NO-UNDO.
DEFINE VAR mBirth20      AS DATE    NO-UNDO.
DEFINE VAR mBirth45      AS DATE    NO-UNDO.
DEFINE VAR mType         AS INT64 NO-UNDO.
DEFINE VAR mDatePasp     AS DATE    NO-UNDO.
DEFINE VAR mSortCnt      AS INT64 NO-UNDO.
DEFINE VAR mSortType     AS INT64 NO-UNDO.
DEFINE TEMP-TABLE ttRep NO-UNDO
   FIELD SortStr    AS CHAR
   FIELD ExpireDate AS DATE
   FIELD FIO        AS CHAR
   FIELD CliCode    LIKE person.person-id
INDEX BySortStr IS PRIMARY SortStr
INDEX ByCliCode CliCode
.
/* DEFINE BUFFER xperson FOR person. */
DEFINE BUFFER xcust-corp FOR cust-corp.

/* --- Инициализация --- */
mSortList = GetParamByNameAsChar(iParms, "Сортировка", "2,3,4").

beg-date = TODAY.
end-date = TODAY + 90.
{getdates.i
   &noinit=YES
   &TitleLabel="ПАРАМЕТРЫ ОТЧЕТА"
   &BegLabel="Начало периода"
   &BegHelp="Введите дату начала периода (F1 - календарь)"
   &EndLabel="Конец периода"
   &EndHelp="Введите дату окончания периода (F1 - календарь)"
}

/* --- Расчет --- */
FOR EACH tmprecid NO-LOCK,
   FIRST xcust-corp WHERE RECID(xcust-corp) = tmprecid.id NO-LOCK:
   mType = 3.
   /* Если день рождения не задан, то в отчет попадает всегда */
/*   IF xperson.birthday <> ? THEN DO: */
   DEF VAR vBirthday AS DATE NO-UNDO.
   vBirthday = DATE(GetXAttrValueEx("cust-corp", STRING(xcust-corp.cust-id), "BirthDay", "?")) NO-ERROR.
   IF vBirthday <> ? THEN DO:
      mDatePasp = ?.
/*      mDatePasp = DATE(GetXAttrValueEx("person",STRING(xperson.person-id),"Document4Date_vid","?")) NO-ERROR. */
      mDatePasp = DATE(GetXAttrValueEx("cust-corp", STRING(xcust-corp.cust-id), "Document4Date_vid","?")) NO-ERROR.
      /* Если дата выдачи паспорта не задана, то в отчет попадает всегда */
      IF mDatePasp <> ? THEN DO:
         /* Рассчитываем дату замены паспорта через 20 и 45 лет */
         ASSIGN
            mBirth20 = DATE(MONTH(vBirthday),
                            DAY  (vBirthday),
                            YEAR (vBirthday) + 20)
            mBirth45 = DATE(MONTH(vBirthday),
                            (IF   DAY(vBirthday)   = 29
                             AND  MONTH(vBirthday) = 2
                             THEN DAY  (vBirthday) - 1
                             ELSE DAY  (vBirthday)),
                                  YEAR (vBirthday) + 45)
         .
         /* Один из дней замены паспорта должен входить в отчетный период 
            и дата выдачи паспорта должна быть ранее даты замены паспорта */
         IF  mBirth20 >= beg-date
         AND mBirth20 <= end-date
         AND mDatePasp < mBirth20
         THEN mType = 1.
         ELSE IF  mBirth45 >= beg-date
              AND mBirth45 <= end-date
              AND mDatePasp < mBirth45
              THEN mType = 2.
              ELSE NEXT.
      END.
   END.
   /* Выводим в отчет */
   CREATE ttRep.
   ASSIGN
      ttRep.ExpireDate = (IF mType = 3
				THEN ?
				ELSE (IF mType = 1
					THEN mBirth20
					ELSE mBirth45))
      ttRep.FIO        = xcust-corp.name-short /* + " " + xcust-corp.first-names */
      ttRep.CliCode    = xcust-corp.cust-id
   .
END.

mSortCnt = NUM-ENTRIES(mSortList).
IF mSortCnt > 0
THEN FOR EACH ttRep EXCLUSIVE-LOCK USE-INDEX ByCliCode:
   DO mType = 1 TO mSortCnt:
      mSortType = INT64(ENTRY(mType,mSortList)) NO-ERROR.
      CASE mSortType:
         WHEN 2 THEN ttRep.SortStr = ttRep.SortStr
                                   + STRING( (IF ttRep.ExpireDate = ? THEN 0 ELSE YEAR(ttRep.ExpireDate)) , "9999")
                                   + STRING( (IF ttRep.ExpireDate = ? THEN 0 ELSE MONTH(ttRep.ExpireDate)) , "99")
                                   + STRING( (IF ttRep.ExpireDate = ? THEN 0 ELSE DAY(ttRep.ExpireDate)) , "99").
         WHEN 3 THEN ttRep.SortStr = ttRep.SortStr + STRING(ttRep.FIO,"x(120)").
         WHEN 4 THEN ttRep.SortStr = ttRep.SortStr + STRING(ttRep.CliCode,">>>>>>>>>>>>>9").
      END CASE.
   END.
END.

/* --- Печать --- */
RUN Insert_TTName ("BegDate", STRING(beg-date,"99/99/9999")).
RUN Insert_TTName ("EndDate", STRING(end-date,"99/99/9999")).
mCounter = 0.
FOR EACH ttRep NO-LOCK BY ttRep.SortStr:
   mCounter = mCounter + 1.
   RUN Insert_TTName ("PP",         STRING(mCounter,">>>>>9") + " ").
   RUN Insert_TTName ("ExpireDate", STRING(ttRep.ExpireDate,"99/99/9999")).
   RUN Insert_TTName ("FIO",        ttRep.FIO).
   RUN Insert_TTName ("CliCode",    STRING(ttRep.CliCode)).
END.
IF mCounter = 0 THEN RUN Insert_TTName ("PP", "       ").

FIND _user WHERE _user._userid = USERID("bisquit") NO-LOCK NO-ERROR.
RUN Insert_TTName ("Signature", "Уполномоченный сотрудник:  "
                              + STRING( ( IF AVAIL _user THEN _user._user-name ELSE "" ), "x(46)")
                              + STRING(TODAY,"99/99/9999")
                              + "   " + STRING(TIME,"hh:mm:ss")
                  ).

RUN printvd.p("СВЕДФЛУКОТИСТСРОКПАСП", INPUT TABLE ttnames).

{intrface.del}
