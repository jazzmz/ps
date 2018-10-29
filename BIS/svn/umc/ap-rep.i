{intrface.get xclass}
{intrface.get umc}

&IF DEFINED(HeadEnd) = 0 &THEN
   &SCOPED-DEFINE HeadEnd 5
&ENDIF

&IF DEFINED(ReceiptFull) = 0 &THEN
   &SCOPED-DEFINE ReceiptFull NO
&ENDIF

/* Наименование получателя из ДР receipt */
FUNCTION ReceiptName RETURNS CHAR
   (iRole AS LOGICAL):

   DEF VAR vReceipt    AS CHAR  NO-UNDO.
   DEF VAR vRole       AS CHAR  NO-UNDO.
   DEF VAR vStr        AS CHAR  NO-UNDO.

   DEF BUFFER employee FOR employee.

   IF NOT AVAILABLE op THEN
      RETURN "".

   vReceipt = TRIM(GetXAttrValueEx("op",
                                   STRING(op.op),
                                   "receipt",
                                   ""
                                  ),
                   "."
                  ).

   IF vReceipt > "" THEN
      ASSIGN
         vReceipt = shFilial + "," + vReceipt
         vRole    = GetXAttrValueEx("employee",
                                    vReceipt,
                                    "role",
                                    ""
                                   )
         vStr     = GetObjName     ("employee",
                                    vReceipt,
                                    {&ReceiptFull}
                                   ).
   IF vStr > "" THEN
      vReceipt = vStr.

   IF iRole THEN
      vReceipt = TRIM(vReceipt + " " + vRole).
   ELSE IF iRole = ? THEN
   DO:

      vRole = IF vRole = ""
              THEN FILL("_", 15)
              ELSE STRING(vRole, "x(15)").

      vReceipt = TRIM(vRole + " ______________ " + vReceipt).
   END.

   RETURN vReceipt.

END FUNCTION.

/* Наименование подразделения из ДР for-branch */
FUNCTION For-BranchName RETURNS CHAR:

   IF NOT AVAILABLE op THEN
      RETURN "".

   DEF VAR vFor-Branch  AS CHAR  NO-UNDO.

   vFor-Branch = GetObjName("branch",
                            GetXAttrValueEx("op",
                                            STRING(op.op),
                                            "for-branch",
                                            ?
                                           ),
                            NO
                           ).

   RETURN vFor-Branch.

END FUNCTION.

/* Дата прописью в родительном падеже */
FUNCTION Date2StrR RETURNS CHAR
   (iDate AS DATE):

   /* Наименования месяцев */
   DEF VAR vMonName    AS CHAR     NO-UNDO EXTENT 12 INITIAL
   [ "января" , "февраля", "марта"   ,
     "апреля" , "мая"    , "июня"    ,
     "июля"   , "августа", "сентября",
     "октября", "ноября" , "декабря"
   ].

   DEF VAR vStr   AS CHAR NO-UNDO.

   vStr = '" ' + STRING  ( DAY  (iDate),   "99") + ' "'
        + " "  + vMonName[ MONTH(iDate)        ]
        + " "  + STRING  ( YEAR (iDate), "9999") + " г."
   NO-ERROR.

   RETURN vStr.

END FUNCTION.

/* Разбивать на несколько отчетов по одной строке */
&IF DEFINED(BREAK-REP) = 0 &THEN
   &GLOBAL-DEFINE BREAK-REP mBreak
   DEF VAR {&BREAK-REP} AS LOGICAL NO-UNDO.
&ENDIF

/* Количество */
DEF VAR mQty        AS DECIMAL  NO-UNDO.
/* Сумма      */
DEF VAR mSum        AS DECIMAL  NO-UNDO.
/* Номер по порядку */
DEF VAR mNPP        AS INT      NO-UNDO.
/* Сумма НДС  */
DEF VAR mSumNDS     AS DECIMAL  NO-UNDO.
/* Сумма без НДС */
DEF VAR mSumObl     AS DECIMAL  NO-UNDO.
/* Сумма вместе с НДС */
DEF VAR mSumTot     AS DECIMAL  NO-UNDO.
/* Цена МЦ */
DEF VAR mCost       AS DECIMAL  NO-UNDO.

/* Признак формирования отчета с НДС или без */
DEF VAR mNDS-Fl     AS LOGICAL NO-UNDO.
/* Расшифровки подписей членов комиссии */
DEF VAR mSigns      AS CHAR     NO-UNDO EXTENT 4.

FIND FIRST op WHERE
     RECID(op) = rid
NO-LOCK NO-ERROR.

IF NOT AVAILABLE op THEN
   RETURN.

RUN InitProc.

{strtout3.i}

&IF DEFINED(tmprecid) &THEN
IF NOT {&BREAK-REP} THEN
&ENDIF
/* Вывод заголовка отчета c шапкой */
RUN PutHead.

&IF DEFINED(tmprecid) &THEN
FOR
   EACH  atmprecid,

   FIRST op WHERE
         RECID(op) = atmprecid.id
      NO-LOCK:
&ENDIF

   ASSIGN
      mQty    = 0
      mSum    = 0
      mCost   = 0
      mSumObl = 0
      mSumNDS = 0
      mSumTot = 0.

   FOR
      EACH  kau-entry OF op WHERE
            kau-entry.debit = {&debit}
         NO-LOCK,
      FIRST op-entry WHERE op-entry.op       = kau-entry.op       AND
                           op-entry.op-entry = kau-entry.op-entry
         NO-LOCK,
      FIRST loan WHERE
            loan.contract  = ENTRY(1, kau-entry.kau)
        AND loan.cont-code = ENTRY(2, kau-entry.kau)
         NO-LOCK,

      FIRST asset OF loan
         NO-LOCK

      BREAK BY kau-entry.kau:

   &IF DEFINED(tmprecid) &THEN
     /* Вывод заголовка отчета c шапкой */
     IF {&BREAK-REP} AND
        FIRST(kau-entry.kau) THEN
        RUN PutHead.
   &ENDIF
      IF op.acct-cat = "u" THEN
         ASSIGN
            mCost   = DECIMAL(GetXAttrValueEx("op",
                                              STRING(op.op),
                                              "ЦенаМЦ",
                                              "0"
                                             )
                             )
            mSumObl = DECIMAL(GetXAttrValueEx("op",
                                              STRING(op.op),
                                             "ОблСумм",
                                              "0"
                                             )
                             )
            mSumNDS = DECIMAL(GetXAttrValueEx("op",
                                               STRING(op.op),
                                              "СумНДС",
                                              "0"
                                             )
                             )
         NO-ERROR.

     IF op.acct-cat = "b" THEN
        ASSIGN
           mCost   = DECIMAL(GetXAttrValueEx("op-entry",
                                             STRING(op-entry.op) + "," + STRING(op-entry.op-entry),
                                             "ЦенаМЦ",
                                             "0"
                                             )
                          )
           mSumObl = DECIMAL(GetXAttrValueEx("op-entry",
                                             STRING(op-entry.op) + "," + STRING(op-entry.op-entry),
                                             "ОблСумм",
                                             "0"
                                            )
                            )
           mSumNDS = DECIMAL(GetXAttrValueEx("op-entry",
                                             STRING(op-entry.op) + "," + STRING(op-entry.op-entry),
                                             "СумНДС",
                                             "0"
                                            )
                          )
      NO-ERROR.
      ASSIGN
         mSum = mSum + kau-entry.amt-rub
      mQty = mQty + kau-entry.qty.

      IF LAST-OF(kau-entry.kau) THEN
      DO:
         mNPP = mNPP + 1.

         IF mCost = 0 THEN
            mCost = asset.cost.
         IF mSumObl = 0 THEN
            mSumObl = mSum.
         mSumTot = mSumObl + mSumNDS.

         RUN PutLine (RepTempl[{&HeadEnd} + 1]).

         ACCUMULATE
            mSumNDS (TOTAL)
            mSumObl (TOTAL)
            mSumTot (TOTAL)
            mQty    (TOTAL).

         &IF DEFINED(tmprecid) &THEN
           /* Вывод подвала отчета */
           IF {&BREAK-REP} AND
              LAST(kau-entry.kau) THEN
              RUN PutFoot.
         &ENDIF

         ASSIGN
            mCost = 0
            mQty  = 0
            mSum  = 0.
      END.
   END.
&IF DEFINED(tmprecid) &THEN
END.

IF NOT {&BREAK-REP} THEN
&ENDIF
/* Вывод подвала отчета */
DO:
   ASSIGN
      mSumNDS = (ACCUM TOTAL mSumNDS)
      mSumObl = (ACCUM TOTAL mSumObl)
      mSumTot = (ACCUM TOTAL mSumTot)
      mQty    = (ACCUM TOTAL mQty).

   RUN PutFoot.
END.

{endout3.i}

/* Процедура формирования детальной строки отчета */
PROCEDURE PutLine:
   DEF INPUT PARAMETER iRepTempl AS CHAR NO-UNDO.

   DEF VAR vCnt  AS INT   NO-UNDO.
   DEF VAR vLen  AS INT   NO-UNDO.
   DEF VAR vItm  AS CHAR  NO-UNDO.
   DEF VAR vVal  AS CHAR  NO-UNDO.
   DEF VAR vStr  AS CHAR  NO-UNDO.

   vStr = iRepTempl.

   DO vCnt = 2 TO NUM-ENTRIES(iRepTempl, "│"):

      ASSIGN
         vItm = ENTRY(vCnt, iRepTempl, "│")
         vLen = LENGTH(vItm).

      CASE TRIM(vItm):
         WHEN "" THEN
            NEXT.
         WHEN "N"        THEN
            vVal = STRING(mNPP).
         WHEN "ИНВ.N"    THEN
            vVal = loan.cont-code.
         WHEN "НОМ.N"    THEN
            vVal = loan.cont-type.
         WHEN "name"     THEN
            vVal = asset.name.
         WHEN "unt"      THEN
            vVal = asset.unit.
         WHEN "unitname" THEN
            vVal = GetCodeName("Unit", asset.unit).
         WHEN "qty"      THEN
            vVal = STRING(mQty).
         WHEN "nds"      THEN
            vVal = STRING(mSumNDS, "zzzzzzzzzzzzz9.99").
         WHEN "sum-nds"  THEN
            vVal = STRING(mSumObl, "zzzzzzzzzzzzz9.99").
         WHEN "sum"      THEN
            vVal = STRING(mSumTot, "zzzzzzzzzzzzz9.99").
         WHEN "cost"     THEN
            vVal = STRING(mCost,   "zzzzzzzzzzzzz9.99").
         WHEN "qtr" OR
         WHEN "qta"      THEN
            vVal = "".
         WHEN "ГВ"       THEN
            vVal = STRING(YEAR(DATE(GetXAttrValueEx("loan",
                                                    loan.contract + "," +
                                                    loan.cont-code,
                                                    "ДатаИзготов",
                                                    ?
                                                   )
                                   )
                              )
                         ) NO-ERROR.
         OTHERWISE
            CASE ENTRY(1, TRIM(vItm), ":"):
               WHEN "ДРК"       THEN
                  vVal = GetXAttrValueEx("loan",
                                         loan.contract + "," + loan.cont-code,
                                         ENTRY(2, TRIM(vItm), ":"),
                                         ""
                                        ) NO-ERROR.
               WHEN "Ком"       THEN
                  vVal = STRING(GetSrokAmor(RECID(loan),
                                            ENTRY(2, TRIM(vItm), ":"),
                                            op.op-date
                                           )
                               ) NO-ERROR.
               OTHERWISE
                  NEXT.
            END CASE.
      END CASE.

      IF vVal = ? THEN
         vVal = "".

      vVal = TRIM(vVal).

      IF      vItm BEGINS " "
          AND SUBSTR(vItm, vLen) = " "
      THEN
         vVal = PADC(vVal, vLen).
      ELSE IF vItm BEGINS " " THEN
         vVal = PADL(vVal, vLen).
      ELSE
         vVal = PADR(vVal, vLen).

      ENTRY(vCnt, vStr, "│") = vVal.
   END.

   PUT UNFORMATTED
      RepTempl[{&HeadEnd} + IF INDEX(iRepTempl, "ИТОГО") > 0 THEN 2 ELSE 0] SKIP
      vStr
   SKIP.

   RETURN.

END PROCEDURE.

/* Процедура вывода заголовка отчета c шапкой */
PROCEDURE PutHead:

   DEF VAR vCnt AS INT NO-UNDO.

   mNPP = 0.

   RUN PutHeader.

   DO vCnt = 1 TO {&HeadEnd} - 1:
      PUT UNFORMATTED
         RepTempl[vCnt]
      SKIP.
   END.

END PROCEDURE.

/* Процедура вывода подвала отчета c итогами */
PROCEDURE PutFoot:

   FIND FIRST op WHERE
      RECID(op) = rid
   NO-LOCK NO-ERROR.

   RUN PutLine (RepTempl[{&HeadEnd} + 3]).

   PUT UNFORMATTED
      RepTempl[{&HeadEnd} + 4] SKIP.

   /* Вывод подвала отчета */
   RUN PutFooter.

   &IF DEFINED(tmprecid) &THEN
      PAGE.
   &ENDIF

END PROCEDURE.

/* Инициализация подписей */
PROCEDURE InitProc:

   DEF VAR vCnt         AS INT    NO-UNDO.
   DEF VAR vSignsList   AS CHAR   NO-UNDO.

   DEF BUFFER user-proc FOR user-proc.

   RUN proc-get.p (       op.doc-type,
                   BUFFER user-proc
                  ).

   IF AVAILABLE user-proc THEN
   DO:
      /* Для автономного склада определяем, с НДС или без */
      IF op.acct-cat = "u" OR op.acct-cat = "b" THEN
         mNDS-Fl = (INDEX(user-proc.name-proc, "без НДС") = 0).
      ASSIGN
         vSignsList = GetXattrValueEx("user-proc",
                                      STRING(user-proc.public-number),
                                      "Подписи",
                                      ""
                                     )
         vSignsList = vSignsList
                    + FILL(",БезПодп",
                           EXTENT(mSigns) - NUM-ENTRIES(vSignsList)
                          )
         vSignsList = TRIM(vSignsList).

      DO vCnt = 1 TO MIN(EXTENT(mSigns), NUM-ENTRIES(vSignsList)):
         mSigns[vCnt] = GetCode("Подписи", ENTRY(vCnt, vSignsList)).
         IF mSigns[vCnt] = ? THEN
            mSigns[vCnt] = "".
      END.
   END.
END PROCEDURE.
