{pirsavelog.p}

/*
                Банковская интегрированная система БИСквит
    Copyright:  (C) 1992-1997 ТОО "Банковские информационные системы"
     Filename:  op-lenta.p
      Comment:  Печать ведомости проводок

         Uses:  -
      Used by:  op-en(s1.p,op-en(s2.p
      Created:  05/05/1996 eagle
     Modified:  20/10/1999 Stepanov S.V. from op-enpr2.p 
     Modified:  22/10/2003 kraw (0012130) чтобы полупроводки представлялись
                                          "как в бухгалтерском журнале" (op-enbu2)
*/

DEFINE INPUT  PARAMETER cAcc AS CHARACTER  NO-UNDO.

{op-entmp.i}

DEFINE VARIABLE adb          AS CHARACTER FORMAT 'x(25)' NO-UNDO.
DEFINE VARIABLE acr          AS CHARACTER FORMAT 'x(25)' NO-UNDO.
DEFINE VARIABLE vNum         AS INTEGER                  NO-UNDO.
DEFINE VARIABLE nNumCur      AS INTEGER                  NO-UNDO.
DEFINE VARIABLE nNumAll      AS INTEGER                  NO-UNDO.
DEFINE VARIABLE nSumCur      AS DECIMAL                  NO-UNDO.
DEFINE VARIABLE nSumAll      AS DECIMAL                  NO-UNDO.
DEFINE VARIABLE nNumPage     AS INTEGER                  NO-UNDO.
DEFINE VARIABLE nCurPage     AS INTEGER                  NO-UNDO.
DEFINE VARIABLE amt          AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   NO-UNDO.
DEFINE VARIABLE vamt         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   NO-UNDO.

DEFINE BUFFER xop-entry FOR op-entry.

DEFINE TEMP-TABLE xentry NO-UNDO
   FIELD num      AS INTEGER
   FIELD op-date  AS DATE 
   FIELD doc-num  LIKE op.doc-num
   FIELD op       LIKE op-entry.op
   FIELD currency AS CHARACTER
   FIELD doc-type LIKE op.doc-type
   FIELD acct-db  AS CHARACTER
   FIELD acct-cr  AS CHARACTER
   FIELD damt     LIKE op-entry.amt-rub
   FIELD dvamt    LIKE op-entry.amt-cur
   FIELD kamt     LIKE op-entry.amt-rub
   FIELD kvamt    LIKE op-entry.amt-cur
   FIELD user-id  LIKE op.user-id
   FIELD polupr   AS CHARACTER
   FIELD podft    AS CHARACTER
   INDEX acct-db doc-type acct-db
   INDEX op op polupr

.

RUN getnum.p("КОЛ-ВО ДОКУМЕНТОВ",OUTPUT vNum).

/***************************************************************************/
function GetCBDocType1 returns char /* Возвращает ЦБ-шный код документа     */
         (input in-doc-type as char): /* doc-type.doc-type */
  find first doc-type where doc-type.doc-type = in-doc-type no-lock no-error.
  return if avail doc-type then doc-type.digital else in-doc-type.
end function.
/***************************************************************************/

{setdest.i &cols=124}

FOR EACH tmprecid NO-LOCK,
   FIRST op-entry WHERE RECID(op-entry) = tmprecid.id NO-LOCK,
   op OF op-entry NO-LOCK
   BREAK BY op-entry.op-date
         BY op-entry.currency
         BY op-entry.amt-rub
   ON ERROR UNDO, LEAVE:

   {on-esc leave}
   adb = ?. acr = ?.
   IF op-entry.acct-cr eq ? THEN
   DO:
      FIND FIRST xop-entry WHERE xop-entry.op = op.op 
                             AND xop-entry.acct-db eq ? 
         USE-INDEX op-entry NO-LOCK.
      ASSIGN
         adb = op-entry.acct-db
         acr = xop-entry.acct-cr
      .
   END.
   ELSE IF op-entry.acct-db EQ ? THEN
   DO:
      FIND FIRST xop-entry WHERE xop-entry.op = op.op
                             AND xop-entry.acct-cr eq ? 
         USE-INDEX op-entry NO-LOCK.
      ASSIGN
         adb = xop-entry.acct-db
         acr = op-entry.acct-cr
      .
   END.
   ELSE
      ASSIGN
         adb = op-entry.acct-db
         acr = op-entry.acct-cr
      .

          
   IF adb NE ? AND acr NE ? THEN
   DO:
      CREATE xentry.
      xentry.doc-type = GetCBDocType1(op.doc-type).
      ASSIGN
         xentry.acct-db  = adb
         xentry.acct-cr  = acr
         xentry.currency = op-entry.currency
         xentry.doc-num  = op.doc-num
         xentry.op       = op.op
         xentry.damt      = IF TRIM(cAcc)="" THEN op-entry.amt-rub ELSE IF SUBSTR(adb,1,5) EQ "30102" THEN op-entry.amt-rub ELSE 0
         xentry.dvamt     = IF TRIM(cAcc)="" THEN op-entry.amt-cur ELSE IF SUBSTR(adb,1,5) EQ "30102" THEN op-entry.amt-cur ELSE 0
         xentry.kamt      = IF TRIM(cAcc)="" THEN 0 ELSE IF SUBSTR(acr,1,5) EQ "30102" THEN op-entry.amt-rub ELSE 0
         xentry.kvamt     = IF TRIM(cAcc)="" THEN 0 ELSE IF SUBSTR(acr,1,5) EQ "30102" THEN op-entry.amt-cur ELSE 0
         xentry.polupr   = IF op-entry.acct-db EQ ? THEN "d"
                           ELSE IF op-entry.acct-cr EQ ? THEN "c" ELSE ""
         xentry.user-id  = op.user-id
	.

	IF   GetXAttrValue("op",STRING(op.op),"КодОпОтмыв") EQ ? OR GetXAttrValue("op",STRING(op.op),"КодОпОтмыв") EQ "" 
        THEN xentry.podft   =  "". ELSE xentry.podft = "c/c" . 
      
   END.
END.
   
FOR EACH xentry BREAK BY xentry.op BY xentry.damt BY xentry.currency DESCENDING:
   IF last-of(xentry.op) AND xentry.polupr <> "" THEN
      DELETE xentry.
END.
   
FOR EACH xentry BREAK BY xentry.op:
   xentry.num = IF first-of(xentry.op) THEN 1 ELSE 0.
END.


ASSIGN nNumCur = 0 nNumAll = 0 nSumCur = 0 nSumAll = 0 nNumPage = 0 nCurPage=0.

FOR EACH xentry NO-LOCK
   BREAK BY xentry.op-date
         BY xentry.damt
         BY xentry.kamt
         BY xentry.acct-cr
   ON ERROR UNDO, LEAVE:

   FORM header
      "ОПИСЬ ДОКУМЕНТОВ"
      (IF in-op-date-beg = in-op-date-end THEN
          "ЗА " + (IF in-op-date-end = ? THEN "?" ELSE STRING(in-op-date-end))
       ELSE
          "С "   + (IF in-op-date-beg = ? THEN "?" ELSE STRING(in-op-date-beg))
          + " ПО " + (IF in-op-date-end = ? THEN "?" ELSE STRING(in-op-date-end))
      )
      FORMAT "x(45)"
      (nCurPage + 1) FORM "Листzz9" TO 104 SKIP(2)
   .

   FIND FIRST op-bank OF op NO-LOCK NO-ERROR. 

   IF adb <> ? or acr <> ? THEN 
   DO:
      IF xentry.damt<>0 THEN 
	ASSIGN 
	   amt = xentry.damt 
	   vamt = xentry.dvamt 
	.
      ELSE 
	ASSIGN 
	   amt = xentry.kamt 
	   vamt = xentry.kvamt 
	.
      DISPLAY
         GetCBDocType1(xentry.doc-type) @ xentry.doc-type
         xentry.doc-num
         REPLACE(xentry.acct-db, '-', '') FORMAT "x(20)" column-label 'ДЕБЕТ'
         REPLACE(xentry.acct-cr, '-', '') FORMAT "x(20)" column-label 'КРЕДИТ'
         vamt when vamt <> 0 column-label 'СУММА В ВАЛЮТЕ'
         amt                 column-label 'СУММА В РУБЛЯХ'
         xentry.user-id
         REPLACE(xentry.podft, '-', '') FORMAT "x(5)" column-label 'ПОДФТ'
         with no-box width 120
      .
      ASSIGN 
           nNumCur = nNumCur + 1
           nNumAll = nNumAll + 1 
           nSumCur = nSumCur + amt
           nSumAll = nSumAll + amt
           nCurPage = page-number - nNumPage
      .
   END.

  IF (nNumCur >= vNum) THEN 
  DO:
     DOWN.
     UNDERLINE xentry.doc-num amt.
     DISPLAY
        nNumCur FORMAT ">>>>9" @ xentry.doc-num
        nSumCur @ amt.
     ASSIGN 
           nNumCur = 0
           nSumCur = 0
           nNumPage = page-number
           nCurPage = page-number - nNumPage.
     .
     PAGE.
  END. 

  IF LAST-OF(xentry.op-date) THEN 
  DO:
    DOWN.
    UNDERLINE xentry.doc-num amt.
    DISPLAY
        nNumCur FORMAT ">>>>9" @ xentry.doc-num
        nSumCur @ amt.
  END.
END.


{signatur.i &user-only=yes}
{preview.i}
