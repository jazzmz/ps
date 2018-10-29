{pirsavelog.p}
/** 
   ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2011

   Заявление на погашение.
   Борисов А.В., 27.04.2011
*/

{globals.i}           /** Глобальные определения */
{date.fun}
{intrface.get tmess}  /** Служба системных сообщений */
{ulib.i}
{wordwrap.def}
{tmprecid.def}
/*
{intrface.get date}
*/
{pir_anketa.fun}
{get-bankname.i}
/* *************************************************** */
FUNCTION ValPropis RETURNS CHARACTER
   (INPUT idSumm AS DECIMAL,
    INPUT icEnd  AS CHARACTER):

   DEFINE VARIABLE iDig1   AS INTEGER NO-UNDO.
   DEFINE VARIABLE iDig2   AS INTEGER NO-UNDO.

   iDig1 = TRUNCATE(idSumm,      0) MODULO 10.
   iDig2 = TRUNCATE(idSumm / 10, 0) MODULO 10.

   RETURN ENTRY(IF ((iDig1 LT 5) AND (iDig2 NE 1)) THEN (iDig1 + 1) ELSE 1, icEnd).
END FUNCTION.
/* *************************************************** */
DEFINE VARIABLE cDRAcct AS CHARACTER          NO-UNDO.
DEFINE VARIABLE cDogTmp AS CHARACTER          NO-UNDO.
DEFINE VARIABLE str     AS CHARACTER EXTENT 3 NO-UNDO.
DEFINE VARIABLE I       AS INTEGER            NO-UNDO.
DEFINE BUFFER   rperson FOR person.

def var mLengBody as INT INIT 15 NO-UNDO.
DEFINE VARIABLE daDat   AS DATE        LABEL "Дата    "
   FORMAT "99.99.9999"         NO-UNDO.
DEFINE VARIABLE dSumm   AS DECIMAL     LABEL "Сумма   "
   FORMAT ">>>,>>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE cPropis AS CHARACTER   LABEL "Прописью"
   FORMAT "x(165)"             NO-UNDO VIEW-AS EDITOR SIZE 55 BY 3.
DEFINE VARIABLE cVidPog AS CHARACTER   LABEL "Вид погашения"
   FORMAT "x(240)"             NO-UNDO VIEW-AS COMBO-BOX SIZE 33 BY 1
   LIST-ITEM-PAIRS "","" INNER-LINES 4.
DEFINE VARIABLE cPogash AS CHARACTER
   FORMAT "x(240)"             NO-UNDO VIEW-AS EDITOR SIZE 65 BY 2.
DEFINE VARIABLE cPodp   AS CHARACTER   LABEL "Подпись"
   FORMAT "x(30)"              NO-UNDO VIEW-AS COMBO-BOX
   LIST-ITEM-PAIRS "","" INNER-LINES 3.

DEFINE FRAME fParam
   daDat    SKIP
   dSumm    SKIP
   cPropis  SKIP
   cVidPog  SKIP
   cPogash  NO-LABEL SKIP
   cPodp    SKIP
   WITH SIDE-LABELS CENTERED OVERLAY
        AT COL 5 ROW 5
        TITLE " Заявление Заемщика на погашение "
        SIZE 67 BY 11.

ON VALUE-CHANGED OF cVidPog
DO:
   cPogash:SCREEN-VALUE = cVidPog:SCREEN-VALUE.
END.

ON LEAVE OF cPogash
DO:
   cPogash = cVidPog:SCREEN-VALUE.
END.

ON LEAVE OF dSumm
DO:
   dSumm = DECIMAL(dSumm:SCREEN-VALUE).
   {strval.i dSumm cPropis}
   SUBSTRING(cPropis, 1, 1) = CAPS(SUBSTRING(cPropis, 1, 1)).
   cPropis = "(" + SUBSTRING(cPropis, 1, R-INDEX(cPropis, " ", LENGTH(cPropis) - 15))
           + "и " + STRING(dSumm * 100 MODULO 100, "99") + "/100) "
           + (IF (loan.currency EQ "840") THEN ("доллар" + ValPropis(dSumm, "ов,,а,а,а") + " США") ELSE
             (IF (loan.currency EQ "810") THEN ("рубл"   + ValPropis(dSumm, "ей,ь,я,я,я")) ELSE "Евро")).
   cPropis:SCREEN-VALUE = cPropis.
END.

ON LEAVE OF daDat
DO:
   daDat = DATE(daDat:SCREEN-VALUE).

   FOR EACH cust-role
      WHERE (cust-role.file-name   EQ "person")
        AND (cust-role.surrogate   EQ STRING(loan.cust-id))
        AND (cust-role.cust-cat    EQ "Ч")
        AND (cust-role.class-code  EQ "Право_дов_подписи")
        AND (cust-role.open-date   LE daDat)
        AND ((cust-role.close-date GE daDat)
          OR (cust-role.close-date EQ ?))
      NO-LOCK,
      FIRST rperson
         WHERE (rperson.person-id EQ INTEGER(cust-role.cust-id))
      NO-LOCK:

      cDRAcct = GetXAttrValue("cust-role", STRING(cust-role.cust-role-id), "acct-list").

      IF    (cDRAcct EQ "")
         OR (INDEX(cDRAcct, loan-acct.acct) NE 0)
      THEN DO:
         cDRAcct = SUBSTRING(ENTRY(1, rperson.first-names, " "), 1, 1) + "."
                 + (IF (NUM-ENTRIES(rperson.first-names, " ") GE 2) THEN (SUBSTRING(ENTRY(2, rperson.first-names, " "), 1, 1) + ".") ELSE "")
                 + rperson.name-last.
         cPodp:ADD-LAST(cDRAcct, cDRAcct + "," + STRING(cust-role.open-date, "99.99.9999")).
      END.
   END.
END.

/* =************************************************** */

FOR FIRST tmprecid
   NO-LOCK,
   FIRST loan
      WHERE (RECID(loan)   EQ tmprecid.id)
/*
        AND (loan.cust-cat EQ "Ч")
*/
      NO-LOCK,
   LAST loan-acct OF loan
      WHERE (loan-acct.acct-type EQ "КредРасч")
      NO-LOCK:

   IF (loan.cust-cat EQ "Ч")
   THEN
      FIND FIRST person
         WHERE (person.person-id EQ loan.cust-id)
         NO-LOCK NO-ERROR.
   ELSE
      FIND FIRST person
         WHERE (person.person-id EQ 6605) /* Сагателов Артур Сергеевич, 19/08 */
         NO-LOCK NO-ERROR.


   cDogTmp = REPLACE(GetXAttrValue("loan", loan.contract + "," + loan.cont-code, "ДатаСогл"), "/", ".")
           + (IF (loan.cust-cat EQ "Ч") THEN "" ELSE
                ' за ООО "СтройАртПроект" согласно Договору поручительства № 19-08/1 от 20.03.08').
   cVidPog:ADD-LAST("1. Погашение задолженности" , "В счет погашения задолженности по кредиту по Кредитному договору № "
                   + loan.cont-code + " от " + cDogTmp).
   cVidPog:ADD-LAST("2. Выплата процентов"       , "В счет уплаты процентов по Кредитному договору № "
                   + loan.cont-code + " от " + cDogTmp).
   cVidPog:ADD-LAST("3. Погашение комиссии"      , "В счет погашения комиссии за выделенный лимит по Кредитному договору № "
                   + loan.cont-code + " от " + cDogTmp).
   cVidPog:ADD-LAST("4. Выплата пеней", "В счет уплаты пеней по Кредитному договору № "
                   + loan.cont-code + " от " + cDogTmp).
   cVidPog:ADD-LAST("5. Выплата проср. процентов", "В счет уплаты просроченных процентов по Кредитному договору № " + loan.cont-code + " от " + cDogTmp).
   cVidPog:ADD-LAST("6. В счет проср. задолженности", "В счет погашения просроченной задолженности по кредиту  по Кредитному договору № " + loan.cont-code + " от " + cDogTmp).
   cVidPog:ADD-LAST("7. В счет %% по проср. задолженности", "В счет уплаты процентов по просроченному Кредитному договору № " + loan.cont-code + " от " + cDogTmp).


 

   daDat = TODAY.
   cPogash = cVidPog:SCREEN-VALUE.

   cDRAcct = SUBSTRING(ENTRY(1, person.first-names, " "), 1, 1) + "."
           + (IF (NUM-ENTRIES(person.first-names, " ") GE 2) THEN (SUBSTRING(ENTRY(2, person.first-names, " "), 1, 1) + ".") ELSE "")
           + person.name-last.
   cPodp:ADD-LAST(cDRAcct, cDRAcct + ",").
   pause(0).
   UPDATE
      daDat   dSumm   cPropis
      cVidPog cPogash cPodp
      WITH FRAME fParam.

/*
  THEN cPr-id[1] = REPLACE(cPrPlN, "_", ",").
   ELSE lPr[1]    = NO.

   IF lPr[2]
   THEN cPr-id[2] = cPrPoN:SCREEN-VALUE.
*/

{setdest.i}
   PUT UNFORMATTED
      '                                                               Приложение № 17' SKIP SPACE(mLengBody)
      '                             к Положению о порядке кредитования физических лиц' SKIP SPACE(mLengBody)
      '                                              в валюте РФ и иностранной валюте' SKIP SPACE(mLengBody)
      '                                                   в ' + cBankName SKIP(1) SPACE(mLengBody)
      '                                  ЗАЯВЛЕНИЕ' SKIP(1) SPACE(mLengBody)
      '                           Дата "' + STRING(DAY(daDat), "99") + '" ' + getMonthString(MONTH(daDat)) + ' ' + STRING(YEAR(daDat), "9999") + 'г.' SKIP(2) SPACE(mLengBody)
      'Ф.И.О. : ' + person.name-last + ' ' + person.first-names SKIP(1) SPACE(mLengBody)
      (IF (person.country-id EQ "RUS") THEN 'Резидент' ELSE 'Нерезидент')  SKIP(1) SPACE(mLengBody)
      'Адрес : ' + Kladr(person.country-id + "," + GetXAttrValue("person", STRING(person.person-id), "КодРегГНИ"),
                         TRIM(person.address[1] + " " + person.address[2])) SKIP(1) SPACE(mLengBody)

/*      'Счет № ' + loan-acct.acct + '  в '  + cBankName SKIP(3)*/
      'Счет № ' + loan-acct.acct + '  в '  + cBankName SKIP(3) SPACE(mLengBody)
      'Прошу Вас:' SKIP(1) SPACE(mLengBody)
   .
   str[1] = 'Списать с моего счета  '
          + REPLACE(REPLACE(dSumm:SCREEN-VALUE, ",", " "), ".", "-") + "  "
          + cPropis.
   {wordwrap.i &s=str &n=3 &l=78}
   DO I = 1 TO 3:
      IF (str[I] NE "")
      THEN PUT UNFORMATTED str[I]  SKIP(1) SPACE(mLengBody).
   END.

   str[1] = cPogash:SCREEN-VALUE + ".".
   {wordwrap.i &s=str &n=3 &l=78}
   DO I = 1 TO 3:
      IF (str[I] NE "")
      THEN PUT UNFORMATTED str[I]  SKIP(1) SPACE(mLengBody).
   END.

   cDogTmp = IF (ENTRY(2, cPodp:SCREEN-VALUE) EQ '') THEN '' ELSE
     ('                              (по доверенности б/н от ' + ENTRY(2, cPodp:SCREEN-VALUE) + ')').

   PUT UNFORMATTED
      '                              _______________________ ' + ENTRY(1, cPodp:SCREEN-VALUE) SKIP SPACE(mLengBody)
      cDogTmp SKIP(1) SPACE(mLengBody)
      '______________________________________________________________________________' SKIP SPACE(mLengBody)
      '                                 Отметки банка' SKIP(2) SPACE(mLengBody)
      'Сальдо счета позволяет' SKIP(2) SPACE(mLengBody)
      'Операционист             _________________' SKIP(1) SPACE(mLengBody)
      '                  м.п.' SKIP(1) SPACE(mLengBody)
      'Бухгалтер                _________________' SKIP(1) SPACE(mLengBody)
/*
      '                 Бухгалтер ' SKIP(1) SPACE(mLengBody)
      '__________________' SKIP SPACE(mLengBody)
*/
   .

   HIDE FRAME fParam.
END.

{preview.i}
{intrface.del}
