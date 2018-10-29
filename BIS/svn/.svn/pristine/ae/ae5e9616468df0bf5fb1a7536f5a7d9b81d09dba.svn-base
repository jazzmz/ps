DEFINE INPUT PARAMETER iStr  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cStr         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTmp         AS CHARACTER NO-UNDO.
DEFINE VARIABLE iPID         AS INTEGER   NO-UNDO.
DEFINE VARIABLE dSince       AS DATE      NO-UNDO.
DEFINE VARIABLE cGrDog       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPersDog     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNumCard     AS CHARACTER NO-UNDO.

DEFINE VARIABLE cCrdProg     AS CHARACTER NO-UNDO.


cStr   = REPLACE(iStr, "&@", ",").
/*message cStr view-as alert-box.
*/
dSince = DATE(ENTRY(22, cStr, "^")).
cGrDog = ENTRY(23, cStr, "^").
cCrdProg = ENTRY(24, cStr, "^") .
/*
message cCrdProg view-as alert-box.
message ENTRY( 3, cStr, "^") view-as alert-box.
*/

{globals.i}
{intrface.get xclass}
{intrface.get cust}
{intrface.get card}
{intrface.get corr}

CREATE person.
iPID = person.person-id.
person.date-in     = dSince.
person.bank-code-type = "МФО-9".

cTmp = ENTRY( 1, cStr, "^").
person.name-last   = ENTRY(1, cTmp, " ").
person.first-names = SUBSTR(cTmp,INDEX(cTmp," ") + 1).
person.gender      = ENTRY(16, cStr, "^") EQ "м".
person.birthday    = DATE(ENTRY(17, cStr, "^")).

person.country-id  = ENTRY( 8, cStr, "^").
person.inn         = "".

person.phone[1]    = ENTRY(14, cStr, "^") + "," + ENTRY(15, cStr, "^").
person.address[1]  = ENTRY(11, cStr, "^").

person.document-id = ENTRY( 3, cStr, "^").
person.document    = ENTRY( 4, cStr, "^").
person.issue       = ENTRY( 6, cStr, "^").

cTmp = ENTRY( 2, cStr, "^").
/*message cTmp view-as alert-box.
*/
UpdateSigns("person", STRING(iPID), "country-id2", IF ((cTmp EQ "Россия") OR (cTmp EQ "РФ") OR (cTmp EQ "Российская Федерация")) THEN "RUS" ELSE "", YES).
UpdateSigns("person", STRING(iPID), "Document4Date_vid", ENTRY( 5, cStr, "^"), YES).
UpdateSigns("person", STRING(iPID), "КодРегГНИ"        , ENTRY( 9, cStr, "^"),  NO).
UpdateSigns("person", STRING(iPID), "КодРег"           , ENTRY(10, cStr, "^"), YES).
UpdateSigns("person", STRING(iPID), "branch-id"        , "0000"              , YES).
UpdateSigns("person", STRING(iPID), "BirthPlace"       , ENTRY(18, cStr, "^"),  NO).
UpdateSigns("person", STRING(iPID), "FirstAcctDate"    , STRING(dSince)      , YES).
UpdateSigns("person", STRING(iPID), "Гражд"            , "Резид"             , YES).
UpdateSigns("person", STRING(iPID), "Субъект"          , "ФЛ"                , YES).
UpdateSigns("person", STRING(iPID), "ДатаОбнАнкеты"    , STRING(dSince)      , YES).
UpdateSigns("person", STRING(iPID), "pirSotrObnAnk"    , USERID              ,  NO).
UpdateSigns("person", STRING(iPID), "ОценкаРиска"      , GetCode("PirОценкаРиска", "1") , NO).
UpdateSigns("person", STRING(iPID), "РискОтмыв"        , "низкий"            , YES).
UpdateSigns("person", STRING(iPID), "УНК", STRING(NewUnk("person"), GetXAttrEx("person", "УНК", "Data-Format")), YES).
cTmp = UNKg("person", STRING(iPID)).

RELEASE person.

/*
message "3" view-as alert-box.
*/

FIND FIRST cust-ident
   WHERE (cust-ident.class-code EQ "p-cust-adr")
     AND (cust-ident.cust-cat   EQ "Ч")
     AND (cust-ident.cust-id    EQ iPID)
   EXCLUSIVE-LOCK NO-ERROR.

cust-ident.open-date      = DATE(ENTRY(13, cStr, "^")).

cTmp = cust-ident.cust-code-type + "," + cust-ident.cust-code + "," + STRING(cust-ident.cust-type-num).
UpdateSigns("cust-ident", cTmp, "КодыАдреса" , ENTRY(12, cStr, "^"), NO).

RELEASE cust-ident.

FIND FIRST cust-ident
   WHERE (cust-ident.class-code EQ "p-cust-ident")
     AND (cust-ident.cust-cat   EQ "Ч")
     AND (cust-ident.cust-id    EQ iPID)
   NO-LOCK NO-ERROR.

cTmp = cust-ident.cust-code-type + "," + cust-ident.cust-code + "," + STRING(cust-ident.cust-type-num).
UpdateSigns("cust-ident", cTmp, "Подразд" , ENTRY( 7, cStr, "^"), NO).

/*
message "5" view-as alert-box.
*/

CREATE loan.
loan.class-code  = "card-loan-pers".
loan.contract    = "card-pers".
loan.cust-cat    = "Ч".
loan.cust-id     = iPID.
loan.cont-type   = "ФЛ".
loan.cont-cli    = "ЛИЧНО".
loan.trade-sys   = ENTRY(19, cStr, "^").
loan.currency    = "".
cPersDog         = GenNewLoanNumber("card-loan-pers", loan.trade-sys, "", "0", TODAY, STRING(iPID)).
loan.cont-code   = cPersDog.
loan.doc-ref     = DelFilFromLoan(loan.cont-code).

loan.since       = dSince.
loan.open-date   = dSince.
loan.end-date    = date_correct(MONTH(dSince), INT64(GetCodeMisc("КартыБанка", loan.trade-sys, 3)), 31, YEAR(dSince)).
loan.branch-id   = "0000".
loan.loan-status = "ОТКР".
loan.sec-code    = ENTRY(20, cStr, "^").

cTmp             = "card-pers," + loan.cont-code.
UpdateSigns("loan", cTmp, "lat-line1", ENTRY(21, cStr, "^"), NO).
UpdateSigns("loan", cTmp, "lat-line2", ENTRY(21, cStr, "^"), NO).

RELEASE loan.
/*
message "6" view-as alert-box.
*/
CREATE loan-cond.
loan-cond.contract   = "card-pers".
loan-cond.cont-code  = cPersDog.
loan-cond.class-code = cCrdProg.  /*"RUR_Зарплатный".*/  /* "RUR_Партнер". */
loan-cond.since      = dSince.
RELEASE loan-cond.
/*
message "7" view-as alert-box.
*/
CREATE links.
links.link-id        = 36.
links.source-id      = "card-gr,"   + cGrDog.
links.target-id      = "card-pers," + cPersDog.
links.beg-date       = dSince.
RELEASE links.
/*
message "8" view-as alert-box.
*/
RUN GenCardNumber IN h_card(ENTRY(19, cStr, "^"), OUTPUT cNumCard, OUTPUT cTmp).
IF (cTmp NE "")
THEN MESSAGE cTmp
   VIEW-AS ALERT-BOX QUESTION BUTTONS OK.

{intrface.del}
/*
message cNumCard view-as alert-box.
*/

RETURN STRING(iPID) + "," + cPersDog + "," + cNumCard.
