{pirsavelog.p}
/**             ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007
                Ведомость операций в ТСП за период
                Борисов А.В.
*/

{globals.i}           /** Глобальные определения */
{tmprecid.def}        /** Используем информацию из броузера */
{intrface.get xclass} /** Функции для работы с метасхемой */
{intrface.get strng}  /** Функции для работы со строками */
{ulib.i}
{sh-defs.i}

/******************************************* Определение переменных и др. */
DEFINE VARIABLE cXL    AS CHARACTER         NO-UNDO.
DEFINE VARIABLE cTSP   AS CHARACTER         NO-UNDO.
DEFINE VARIABLE iI     AS INTEGER           NO-UNDO.
DEFINE VARIABLE iNop   AS INTEGER EXTENT 8  NO-UNDO.
DEFINE VARIABLE dSUMT  AS DECIMAL           NO-UNDO.
DEFINE VARIABLE dKMSK  AS DECIMAL           NO-UNDO.
DEFINE VARIABLE dKMSSC AS DECIMAL           NO-UNDO.
DEFINE VARIABLE dS1    AS DECIMAL EXTENT 8  NO-UNDO.
DEFINE VARIABLE dS2    AS DECIMAL EXTENT 8  NO-UNDO.
DEFINE VARIABLE dS3    AS DECIMAL EXTENT 8  NO-UNDO.
DEFINE VARIABLE dS4    AS DECIMAL EXTENT 8  NO-UNDO.
DEFINE BUFFER   ustr   FOR loan.
DEFINE VARIABLE cSyst  AS CHARACTER  INIT "VISA,MC,DC,AMEX,UP,ТК,JC" NO-UNDO.
DEFINE VARIABLE iSNum  AS INTEGER    INIT 7 NO-UNDO.
DEFINE VARIABLE dKomm  AS DECIMAL           NO-UNDO.

{pir_exf_exl.i}

{getdates.i}
{exp-path.i &exp-filename = "'TSP.xls'"}

/******************************************* Реализация */
PUT UNFORMATTED XLHead("ul", "CCNCINNNN", "400,73,63,65,63,92,92,115,96").

cXL = XLCell("Ведомость по операциям в ТСП за период с "
             + STRING(beg-date, "99.99.9999") + " по " + STRING(end-date, "99.99.9999")).
PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

cXL = XLCell("Наименование ТСП")
    + XLCell("Номер устройства")
    + XLCell("Процент комиссии")
    + XLCell("Платежная система")
    + XLCell("Кол-во операций")
    + XLCell("Сумма операций")
    + XLCell("Сумма возмещения")
    + XLCell("Сумма комиссии Банка-спонсора")
    + XLCell("Сумма комиссии ПИР")
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

FOR EACH loan
   WHERE (loan.contract   EQ "card-acq")
     AND (loan.class-code EQ "card-loan-acqcust")
     AND ((loan.close-date GE beg-date)
       OR (loan.close-date EQ ?))
   NO-LOCK,
/*
   EACH loan-cond
      WHERE (loan-cond.contract  EQ loan.contract)
        AND (loan-cond.cont-code EQ loan.cont-code)
      NO-LOCK,
*/
   EACH ustr
      WHERE (ustr.contract   EQ "card-equip")
        AND (ustr.class-code EQ "card-equip")
        AND (ustr.parent-cont-code EQ loan.cont-code)
      NO-LOCK:

   DO iI = 1 TO iSNum:
      ASSIGN
         iNop[iI] = 0
         dS1[iI]  = 0.0
         dS2[iI]  = 0.0
         dS3[iI]  = 0.0
         dS4[iI]  = 0.0
      NO-ERROR.
   END.
   cTSP  = GetLoanInfo_ULL("card-acq", loan.cont-code, "client_name", NO).

   FOR EACH pc-trans
      WHERE CAN-DO("TransAcquiring,UCSAcq,UCSCard", pc-trans.class-code)
        AND (pc-trans.sur-equip  EQ ("card-equip," + ustr.cont-code))
        AND (pc-trans.cont-date  GE beg-date)
        AND (pc-trans.cont-date  LE end-date)
      NO-LOCK
      BY pc-trans.cont-date:

      dKomm = 0.0.
      FOR EACH loan-cond
         WHERE (loan-cond.contract  EQ loan.contract)
           AND (loan-cond.cont-code EQ loan.cont-code)
           AND (loan-cond.since     LE pc-trans.cont-date)
         NO-LOCK
         BY loan-cond.since DESCENDING:

         dKomm = DECIMAL(SUBSTR(loan-cond.class-code, 4, 2)) / 10.0.
         LEAVE.
      END.

      IF (dKomm EQ 0.0)
      THEN DO:
         MESSAGE "Нет комиссии " + cTSP SKIP
            "для устройства " + ustr.doc-num + " на дату " + STRING(pc-trans.cont-date, "99.99.9999")
            VIEW-AS ALERT-BOX QUESTION BUTTONS OK.
         LEAVE.
      END.

      iI = LOOKUP(pc-trans.pl-sys, cSyst).
      IF (iI = 0)
      THEN DO:
         MESSAGE "No pl-sys = " pc-trans.pl-sys SKIP
            cTSP ustr.doc-num
            VIEW-AS ALERT-BOX QUESTION BUTTONS OK.
         NEXT.
      END.

      FOR EACH pc-trans-amt
         WHERE (pc-trans-amt.pctr-id EQ pc-trans.pctr-id)
         NO-LOCK:

         CASE pc-trans-amt.amt-code:
            WHEN "СУМТ" THEN
               dSUMT  = pc-trans-amt.amt-cur.
            WHEN "КМСК" THEN
               dKMSK  = pc-trans-amt.amt-cur.
            WHEN "КМССЧ" THEN
               dKMSSC = pc-trans-amt.amt-cur.
         END CASE.
      END.

      ASSIGN
         iNop[iI] = iNop[iI] + 1
         dS1[iI]  = dS1[iI]  + dSUMT
         dS2[iI]  = dS2[iI]  + dSUMT  - dKMSSC
         dS3[iI]  = dS3[iI]  + dKMSK
         dS4[iI]  = dS4[iI]  + dKMSSC - dKMSK
         NO-ERROR.
/*
         cXL = XLCell(cTSP)
             + XLCell(ustr.doc-num)
             + XLNumECell(dKMSSC * 100.0 / dSUMT)
             + XLCell(ENTRY(iI, cSyst))
             + XLNumCell(1)
             + XLNumECell(dSUMT)
             + XLNumECell(dKMSSC)
             + XLNumECell(dKMSK)
             .
         PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
*/
   END.

   PUT UNFORMATTED XLRow(1).
   DO iI = 1 TO iSNum:
      IF (iNop[iI] NE 0)
      THEN DO:
         cXL = XLCell(cTSP)
             + XLCell(ustr.doc-num)
             + XLNumECell(IF (iI = 3) THEN 4.0 ELSE
                         (IF (iI = 4) THEN 0.0 ELSE
                         (IF (iI = 7) THEN 1.8 ELSE dKomm)))
             + XLCell(ENTRY(iI, cSyst))
             + XLNumCell(iNop[iI])
             + XLNumECell(dS1[iI])
             + XLNumECell(dS2[iI])
             + XLNumECell(dS3[iI])
             + XLNumECell(dS4[iI])
             .
         PUT UNFORMATTED cXL XLRowEnd() XLRow(0).
      END.
   END.

   ASSIGN
      iNop[1] = iNop[1] + iNop[2] + iNop[3] + iNop[4] + iNop[5] + iNop[6] + iNop[7]
      dS1[1]  = dS1[1]  + dS1[2]  + dS1[3]  + dS1[4]  + dS1[5]  + dS1[6]  + dS1[7]
      dS2[1]  = dS2[1]  + dS2[2]  + dS2[3]  + dS2[4]  + dS2[5]  + dS2[6]  + dS2[7]
      dS3[1]  = dS3[1]  + dS3[2]  + dS3[3]  + dS3[4]  + dS3[5]  + dS3[6]  + dS3[7]
      dS4[1]  = dS4[1]  + dS4[2]  + dS4[3]  + dS4[4]  + dS4[5]  + dS4[6]  + dS4[7]
      iNop[8] = iNop[1] + iNop[8]
      dS1[8]  = dS1[1]  + dS1[8]
      dS2[8]  = dS2[1]  + dS2[8]
      dS3[8]  = dS3[1]  + dS3[8]
      dS4[8]  = dS4[1]  + dS4[8]
      NO-ERROR.

   cXL = XLCell(cTSP)
       + XLCell(ustr.doc-num)
       + XLEmptyCell()
       + XLCell("   Всего:")
       + XLNumCell(iNop[1])
       + XLNumECell(dS1[1])
       + XLNumECell(dS2[1])
       + XLNumECell(dS3[1])
       + XLNumECell(dS4[1])
       .
   PUT UNFORMATTED cXL XLRowEnd().

END.

cXL = XLCell("          ИТОГО :")
    + XLEmptyCells(3)
    + XLNumCell(iNop[8])
    + XLNumECell(dS1[8])
    + XLNumECell(dS2[8])
    + XLNumECell(dS3[8])
    + XLNumECell(dS4[8])
    .
PUT UNFORMATTED XLRow(2) cXL XLRowEnd().
PUT UNFORMATTED XLEnd().

{intrface.del}
