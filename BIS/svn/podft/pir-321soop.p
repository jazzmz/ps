{pirsavelog.p}
/*
                Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1996 ТОО "Банковские информационные системы"
     Filename: pir-321soop.p
      Comment: Печать реестра из класса Legal321
               согласно положению 321-П (отмывание доходов)
         Uses:
      Used BY:
       Edited: 12/01/2009 Borisov
*/
/******************************************************************************/
DEFINE INPUT PARAMETER ipDataID  AS INTEGER NO-UNDO.

{globals.i}
{repinfo.i}
{norm.i NEW}

{intrface.get xclass}
{intrface.get strng}

{leg321p.def}
{leg321p.fun}
{pir_anketa.fun}

DEFINE VAR mErrCount   AS  INTEGER    NO-UNDO.
DEFINE VAR mError      AS  INTEGER    NO-UNDO.
DEFINE VAR cTD         AS  CHARACTER  NO-UNDO.
DEFINE VAR cA1         AS  CHARACTER  NO-UNDO.
DEFINE VAR cA2         AS  CHARACTER  NO-UNDO.
DEFINE VAR cA3         AS  CHARACTER  NO-UNDO.
DEFINE VAR cA4         AS  CHARACTER  NO-UNDO.
DEFINE VAR cA5         AS  CHARACTER  NO-UNDO.
DEFINE VAR cA6         AS  CHARACTER  NO-UNDO.
DEFINE VAR cDatDoc     AS  CHARACTER  NO-UNDO.
DEFINE VAR cDatMigr1   AS  CHARACTER  NO-UNDO.
DEFINE VAR cDatMigr2   AS  CHARACTER  NO-UNDO.
DEFINE VAR cTmp        AS  CHARACTER  NO-UNDO.
DEFINE VAR str         AS  CHARACTER EXTENT 100  NO-UNDO. /** Текст сообщения */
DEFINE VAR i           AS  INTEGER    NO-UNDO. /** Итератор */
DEFINE VAR j           AS  INTEGER    NO-UNDO.
DEFINE VAR lOurSnd     AS  LOGICAL    NO-UNDO.
DEFINE VAR lOurRcv     AS  LOGICAL    NO-UNDO.
DEFINE VAR cKlSnd      AS  CHARACTER  NO-UNDO.
DEFINE VAR cKlRcv      AS  CHARACTER  NO-UNDO.
DEFINE VAR cKlntStr    AS  CHARACTER  NO-UNDO.
DEFINE VAR cKlntPl     AS  CHARACTER  NO-UNDO.
DEFINE VAR cDocNum     AS  CHARACTER
   LABEL "Номер документа" FORMAT "x(61)" NO-UNDO.
DEFINE VAR lIsPred     AS  LOGICAL    NO-UNDO.

/** Визуальный элемент, с помощью которого в случае необходимости
    можно выбрать клиента, который попадет в сообщение */
DEFINE VAR needClient AS CHAR LABEL "Нужный клиент" FORMAT "x(59)"
   VIEW-AS COMBO-BOX LIST-ITEM-PAIRS "","" INNER-LINES 2.

DEFINE FRAME frmMessage
   cDocNum   SKIP
   needClient
   WITH SIDE-LABELS CENTERED OVERLAY TITLE "Реквизиты".

DEFINE BUFFER Data0 FOR DataLine.
DEFINE BUFFER Data1 FOR DataLine.
DEFINE BUFFER Data2 FOR DataLine.

FUNCTION GetDat0Txt RETURN CHAR    (INPUT ipItem   AS INTEGER) forward.
FUNCTION GetDat1Txt RETURN CHAR    (INPUT ipItem   AS INTEGER) forward.
FUNCTION GetDat2Txt RETURN CHAR    (INPUT ipItem   AS INTEGER) forward.
/*============================================================================*/
{fexp-chk.i &DataID = ipDataID}

FIND FIRST setting
   WHERE setting.code     EQ "Legal207"
     AND setting.sub-code EQ "НомерПП"
   SHARE-LOCK NO-ERROR.

IF NOT AVAILABLE(setting) THEN DO:
   MESSAGE
      "Данные в КФМ экспортируются другим пользователем." SKIP
      "Попробуйте позже."                                 SKIP
      VIEW-AS ALERT-BOX INFORMATION.
   RETURN.
END.

FIND current DataBlock
   SHARE-LOCK NO-ERROR.

IF NOT AVAILABLE(DataBlock) THEN DO:
   MESSAGE
      "Блок данных изменяется другим пользователем." SKIP
      "Попробуйте позже."                            SKIP
      VIEW-AS ALERT-BOX INFORMATION.
   RETURN.
END.

FOR EACH Data0
   WHERE Data0.Data-ID EQ ipDataID
     AND Data0.Sym2    EQ {&MAIN-LINE}
   NO-LOCK:

   j = needClient:NUM-ITEMS.
   DO i = 1 TO j:
      needClient:DELETE(1).
   END.

   cKlntStr = "".

   /* получаем данные о плательщике */
   FIND FIRST Data1
      WHERE Data1.Data-ID EQ ipDataID
        AND Data1.Sym1    EQ Data0.Sym1
        AND Data1.Sym2    EQ {&SEND-LINE}
      NO-LOCK NO-ERROR.

   IF (AVAIL Data1)
   THEN DO:
      ASSIGN
         lOurSnd = (Data0.Val[4] EQ 1)
         cKlSnd  = Data1.Sym3
         NO-ERROR.

/*
      needClient:ADD-LAST((IF (NUM-ENTRIES(cKlSnd) GT 2) THEN ENTRY(3, cKlSnd) ELSE "                    ")
*/
      needClient:ADD-LAST(STRING(GetDat1Txt(38), "x(20)")
                         + "-" + REPLACE(SUBSTRING(GetDat1Txt(3), 1, 59), ",", "_"), {&SEND-LINE}).
   END.
   ELSE
      lOurSnd = NO.

   /* получаем данные о получателе */
   FIND FIRST Data1
      WHERE Data1.Data-ID EQ ipDataID
        AND Data1.Sym1    EQ Data0.Sym1
        AND Data1.Sym2    EQ {&RECV-LINE}
      NO-LOCK NO-ERROR.

   IF (AVAIL Data1)
   THEN DO:
      ASSIGN
         lOurRcv = (Data0.Val[5] EQ 1)
         cKlRcv  = Data1.Sym3
         NO-ERROR.
/*
      needClient:ADD-LAST((IF (NUM-ENTRIES(cKlRcv) GT 2) THEN ENTRY(3, cKlRcv) ELSE "                    ")
*/
      needClient:ADD-LAST(STRING(GetDat1Txt(38), "x(20)")
                         + "-" + REPLACE(SUBSTRING(GetDat1Txt(3), 1, 59), ",", "_"), {&RECV-LINE}).
   END.
   ELSE
      lOurRcv = NO.

   /* Если кто-то из участников клиент банка */
   IF (lOurSnd OR lOurRcv)
   THEN DO:
      /* Если только Отправитель клиент банка */
      IF (lOurSnd AND NOT lOurRcv)
      THEN
         cKlntStr = {&SEND-LINE}.
      ELSE
      /* Если только Получатель клиент банка */
      IF (NOT lOurSnd AND lOurRcv)
      THEN
         cKlntStr = {&RECV-LINE}.
      ELSE DO:
         /* Если Отправитель и Получатель один и тот же*/
/*
         IF     (ENTRY(1, cKlSnd) EQ ENTRY(1, cKlRcv))
            AND (ENTRY(2, cKlSnd) EQ ENTRY(2, cKlRcv))
         THEN DO:
            /* У кого указан реальный счет */
            IF (NUM-ENTRIES(cKlRcv) GT 2)
            THEN
               cKlntStr = {&RECV-LINE}.
            ELSE
               cKlntStr = {&SEND-LINE}.
         END.
         /* Если участники разные - запрос оператору */
         ELSE DO:
*/
            PAUSE 0.
            DISPLAY
               cDocNum
               needClient
               WITH FRAME frmMessage.

            SET needClient
               WITH FRAME frmMessage.
            cKlntStr = needClient:SCREEN-VALUE.
            HIDE FRAME frmMessage.
/*
         END.
*/
      END.

      /* получаем данные о выбранном клиенте */
      FIND FIRST Data1
         WHERE Data1.Data-ID EQ ipDataID
           AND Data1.Sym1    EQ Data0.Sym1
           AND Data1.Sym2    EQ cKlntStr
         NO-LOCK NO-ERROR.

      cKlntStr = GetDat1Txt(1).
   END.
   ELSE DO:
      /* Если не наши клиенты, выбираем отправителя */
      FIND FIRST Data1
         WHERE Data1.Data-ID EQ ipDataID
           AND Data1.Sym1    EQ Data0.Sym1
           AND Data1.Sym2    EQ {&SEND-LINE}
         NO-LOCK NO-ERROR.

      cKlntStr = GetDat1Txt(1).
   END.

   {setdest.i}

   CASE cKlntStr:
      WHEN "1" OR WHEN "4" THEN
         PUT UNFORMATTED
            SPACE(30) "СООБЩЕНИЕ об операции юридического лица." SKIP
         .
      WHEN "2" THEN
         PUT UNFORMATTED
            SPACE(30) "СООБЩЕНИЕ об операции физического лица." SKIP
         .
      WHEN "3" THEN
         PUT UNFORMATTED
            SPACE(30) "СООБЩЕНИЕ об операции индивидуального предпринимателя." SKIP
         .
   END CASE.

   PUT UNFORMATTED 
      "┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐" SKIP
      "│Сведения об операции (сделке)                                                                                         │" SKIP
      "├───────────────────────────────────────────────┬──────────────────────────────────────────────────────────────────────┤" SKIP
   .

   IF (Data0.Sym3 EQ "6001")
   THEN
      PUT UNFORMATTED 
         "│   Необычная сделка                            │" SPACE(34) "X" SPACE(35)                                            "│" SKIP
         "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
      .
   ELSE
      PUT UNFORMATTED 
         "│   Операция, подлежащая обязательному контролю │" SPACE(34) "X" SPACE(35)                                            "│" SKIP
         "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
      .

   cDocNum = TRIM(STRING(Data0.Val[7], ">>>>>9")).
   PUT UNFORMATTED 
      "│Документ, на основании которого осуществляется │" cDocNum FORMAT "x(70)"                                             "│" SKIP
      "│операция (сделка)                              │                                                                      │" SKIP
      "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
   .
   /** Содержание операции нужно разбить по строкам */
   str[1] = GetDat0Txt(12).
   str[1] = GetDat0Txt(11) + (IF (str[1] NE "0") THEN str[1] ELSE "").
   {wordwrap.i &s=str &n=10 &l=70}

   PUT UNFORMATTED
      "│   Содержание операции (сделки)                │" str[1] FORMAT "x(70)"                                              "│" SKIP
   .
   DO i = 2 TO 10:
      IF (str[i] NE "")
      THEN DO:
         PUT UNFORMATTED
            "│                                               │" str[i] FORMAT "x(70)"                                              "│" SKIP
         .
         str[i] = "".
      END.
   END.

   cTmp = string(GetDat0Txt(10), "x(3)").
   cTmp = cTmp + (IF (cTmp EQ "643") THEN "" ELSE " / 643").
   PUT UNFORMATTED
      "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
      "│   Код валюты операции (сделки)                │" cTmp FORMAT "x(70)"                                                "│" SKIP
      "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
   .
   cTmp = IF (cTmp EQ "643")
          THEN (TRIM(string(Data0.Val[2],   "->>>,>>>,>>>,>>>,>>9.99")))
          ELSE (TRIM(string(Data0.Val[3],   "->>>,>>>,>>>,>>>,>>9.99")) + " / "
              + TRIM(string(Data0.Val[2],   "->>>,>>>,>>>,>>>,>>9.99"))).
   PUT UNFORMATTED 
      "│   Сумма операции (сделки)                     │" cTmp FORMAT "x(70)"                                                "│" SKIP
      "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
   .
   cTmp = STRING(DATE(GetEntries( 9, Data0.Txt, "~n", {&E-DATE})), "99.99.9999").
   PUT UNFORMATTED 
      "│   Дата совершения операции (сделки)           │" cTmp FORMAT "x(70)"                                                "│" SKIP
      "├───────────────────────────────────────────────┴──────────────────────────────────────────────────────────────────────┤" SKIP
   .

   CASE cKlntStr:
      WHEN "2" OR WHEN "3" THEN DO:
         str[1] = GetDat1Txt(22).   /* ОГРН */
         cTmp   = GetDat1Txt(20).   /* документ */

         FIND FIRST code
            WHERE (code.class   EQ "КодДокум")
              AND (code.parent  EQ "КодДокум")
              AND (code.misc[6] EQ cTmp)
            NO-LOCK NO-ERROR.
         cTmp = IF (AVAIL code) THEN code.name ELSE "".

         str[1] = (IF (str[1] NE "0") THEN (str[1] + ", ") ELSE "")
                + (IF ((cTmp EQ "") OR (cTmp EQ "0")) THEN ""
                   ELSE (cTmp + ", N " + GetDat1Txt(21)
                        + (IF (GetDat1Txt(24) EQ "0") THEN "" ELSE (" " + GetDat1Txt(24)))
                        + ", выдан " + STRING(DATE(GetDat1Txt(26)), "99.99.9999") + ", " + GetDat1Txt(25))).
         {wordwrap.i &s=str &n=3 &l=70}

         PUT UNFORMATTED
            "│Сведения о лице (лицах), проводящих операцию (совершающих сделку)                                                     │" SKIP
            "├───────────────────────────────────────────────┬──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   Ф.И.О.                                      │" GetDat1Txt( 3) FORMAT "x(70)"                                      "│" SKIP
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   ИНН                                         │" GetDat1Txt(23) FORMAT "x(70)"                                      "│" SKIP
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   ОГРН для ИП,Данные документа,удостоверяющего│" str[1] FORMAT "x(70)"                                              "│" SKIP
            "│   личность (тип,серия,номер,кем и когда выдан)│" str[2] FORMAT "x(70)"                                              "│" SKIP
         .

         IF (str[3] NE "")
         THEN
            PUT UNFORMATTED
               "│                                               │" str[3] FORMAT "x(70)"                                              "│" SKIP
            .

         PUT UNFORMATTED
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
         .
         cTmp   = "," /* index */
                + (IF (GetDat1Txt( 7) NE "0") THEN GetDat1Txt( 7) ELSE "") + ","
                + (IF (GetDat1Txt( 8) NE "0") THEN GetDat1Txt( 8) ELSE "") + ",,"
                + (IF (GetDat1Txt( 9) NE "0") THEN GetDat1Txt( 9) ELSE "") + ","
                + (IF (GetDat1Txt(10) NE "0") THEN GetDat1Txt(10) ELSE "") + ","
                + (IF (GetDat1Txt(11) NE "0") THEN GetDat1Txt(11) ELSE "") + ","
                + (IF (GetDat1Txt(12) NE "0") THEN GetDat1Txt(12) ELSE "") + ",".
         str[1] = Kladr(  (IF (GetDat1Txt(4) EQ "64300") THEN "RUS" ELSE "-") + ","
                        + (IF (GetDat1Txt(6) NE "0") THEN ("000" + GetDat1Txt(6)) ELSE ""),
                          cTmp).
         {wordwrap.i &s=str &n=3 &l=70}

         PUT UNFORMATTED
            "│   Адрес регистрации                           │" (IF (str[1] NE "") THEN str[1] ELSE "0") FORMAT "x(70)"            "│" SKIP
         .
         IF (str[2] NE "")
         THEN
            PUT UNFORMATTED
               "│                                               │" str[2] FORMAT "x(70)"                                              "│" SKIP
            .

         PUT UNFORMATTED
            "├───────────────────────────────────────────────┴──────────────────────────────────────────────────────────────────────┤" SKIP
            "│Сведения о счете, с использованием которого проводится операция или сделка (кроме случаев осуществления               │" SKIP
            "│переводов без открытия счета):                                                                                        │" SKIP
            "├───────────────────────────────────────────────┬──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   № счета                                     │" GetDat1Txt(38) FORMAT "x(70)"                                      "│" SKIP
            "├───────────────────────────────────────────────┴──────────────────────────────────────────────────────────────────────┤" SKIP
         .
         
      END.
      WHEN "1" OR WHEN "4" THEN DO:
         PUT UNFORMATTED 
            "│Сведения о лице (лицах), проводящих операцию (совершающих сделку)                                                     │" SKIP
            "├───────────────────────────────────────────────┬──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   Наименование                                │" GetDat1Txt( 3) FORMAT "x(70)"                                      "│" SKIP
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   ИНН                                         │" GetDat1Txt(23) FORMAT "x(70)"                                      "│" SKIP
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   Регистрационный номер                       │" GetDat1Txt(22) FORMAT "x(70)"                                      "│" SKIP
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
         .
         cTmp   = "," /* index */
                + (IF (GetDat1Txt( 7) NE "0") THEN GetDat1Txt( 7) ELSE "") + ","
                + (IF (GetDat1Txt( 8) NE "0") THEN GetDat1Txt( 8) ELSE "") + ",,"
                + (IF (GetDat1Txt( 9) NE "0") THEN GetDat1Txt( 9) ELSE "") + ","
                + (IF (GetDat1Txt(10) NE "0") THEN GetDat1Txt(10) ELSE "") + ","
                + (IF (GetDat1Txt(11) NE "0") THEN GetDat1Txt(11) ELSE "") + ","
                + (IF (GetDat1Txt(12) NE "0") THEN GetDat1Txt(12) ELSE "") + ",".
         str[1] = Kladr(  (IF (GetDat1Txt(4) EQ "64300") THEN "RUS" ELSE "-") + ","
                        + (IF (GetDat1Txt(6) NE "0") THEN ("000" + GetDat1Txt(6)) ELSE ""),
                          cTmp).
         {wordwrap.i &s=str &n=3 &l=70}

         PUT UNFORMATTED
            "│   Место регистрации юридического лица         │" (IF (str[1] NE "") THEN str[1] ELSE "0") FORMAT "x(70)"            "│" SKIP
         .
         IF (str[2] NE "")
         THEN
            PUT UNFORMATTED
               "│                                               │" str[2] FORMAT "x(70)"                                              "│" SKIP
            .

         PUT UNFORMATTED
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
         .
         cTmp   = "," /* index */
                + (IF (GetDat1Txt(14) NE "0") THEN GetDat1Txt(14) ELSE "") + ","
                + (IF (GetDat1Txt(15) NE "0") THEN GetDat1Txt(15) ELSE "") + ",,"
                + (IF (GetDat1Txt(16) NE "0") THEN GetDat1Txt(16) ELSE "") + ","
                + (IF (GetDat1Txt(17) NE "0") THEN GetDat1Txt(17) ELSE "") + ","
                + (IF (GetDat1Txt(18) NE "0") THEN GetDat1Txt(18) ELSE "") + ","
                + (IF (GetDat1Txt(19) NE "0") THEN GetDat1Txt(19) ELSE "") + ",".
         str[1] = Kladr(  (IF (GetDat1Txt(5) EQ "64300") THEN "RUS" ELSE "-") + ","
                        + (IF (GetDat1Txt(13) NE "0") THEN ("000" + GetDat1Txt(13)) ELSE ""),
                          cTmp).
         {wordwrap.i &s=str &n=3 &l=70}

         PUT UNFORMATTED
            "│   Место нахождения юридического лица          │" (IF (str[1] NE "") THEN str[1] ELSE "0") FORMAT "x(70)"            "│" SKIP
         .
         IF (str[2] NE "")
         THEN
            PUT UNFORMATTED
               "│                                               │" str[2] FORMAT "x(70)"                                              "│" SKIP
            .

         PUT UNFORMATTED
            "├───────────────────────────────────────────────┴──────────────────────────────────────────────────────────────────────┤" SKIP
            "│Сведения о счете, с использованием которого проводится операция или сделка (кроме случаев осуществления               │" SKIP
            "│переводов без открытия счета):                                                                                        │" SKIP
            "├───────────────────────────────────────────────┬──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   № счета                                     │" GetDat1Txt(38) FORMAT "x(70)"                                     "│" SKIP
            "├───────────────────────────────────────────────┴──────────────────────────────────────────────────────────────────────┤" SKIP
         .
         
      END.
   END CASE.

   PUT UNFORMATTED
      "│Описание возникших затруднений квалификации операции как подлежащей обязательному контролю или причины,               │" SKIP
      "│по которым сделка квалифицируется как необычная                                                                       │" SKIP
      "├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤" SKIP
   .

   str[1] = GetDat0Txt(17)
          + (IF (GetDat0Txt(18) NE "0") THEN GetDat0Txt(18) ELSE "").
   {wordwrap.i &s=str &n=10 &l=115}

   DO i = 1 TO 10:
      IF str[i] <> ""
      THEN 
         PUT UNFORMATTED
            "│   " str[i] FORMAT "x(115)" "│" SKIP.
   END.

   PUT UNFORMATTED
      "├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤" SKIP
      "│Сведения о сотруднике, составившем сообщение                                                                          │" SKIP
      "├───────────────────────────────────────────────┬──────────────────────────────────────────────────────────────────────┤" SKIP
      "│   Ф.И.О.                                      │                                                                      │" SKIP
      "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
      "│   Должность                                   │                                                                      │" SKIP
      "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
      "│   Подпись                                     │                                                                      │" SKIP
      "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
      "│   Дата, время                                 │                                                                      │" SKIP
      "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
      "│ПОДПИСЬ РУКОВОДИТЕЛЯ ПОДРАЗДЕЛЕНИЯ             │                                                                      │" SKIP
      "├───────────────────────────────────────────────┴──────────────────────────────────────────────────────────────────────┤" SKIP
      "│Отметка сотрудника отдела ПОД/ФТ о получении Сообщения:                                                               │" SKIP
      "├───────────────────────────────────────────────┬──────────────────────────────────────────────────────────────────────┤" SKIP
      "│   Дата, время                                 │                                                                      │" SKIP
      "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
      "│   Подпись                                     │                                                                      │" SKIP
      "├───────────────────────────────────────────────┴──────────────────────────────────────────────────────────────────────┤" SKIP
      "│Отметка Ответственного сотрудника о принятом решении:                                                                 │" SKIP
      "├───────────────────────────────────────────────┬──────────────────────────────────────────────────────────────────────┤" SKIP
      "│   Принято решение                             │                                                                      │" SKIP
      "│                                               │                                                                      │" SKIP
      "│                                               │                                                                      │" SKIP
      "│                                               │                                                                      │" SKIP
      "│                                               │                                                                      │" SKIP
      "│                                               │                                                                      │" SKIP
      "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
      "│   Дата                                        │                                                                      │" SKIP
      "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
      "│Подпись Руководителя Банка                     │                                                                      │" SKIP
      "└───────────────────────────────────────────────┴──────────────────────────────────────────────────────────────────────┘" SKIP
   .

   /* Печать информации о представителях */
   lIsPred = NO.

   FOR EACH Data1
      WHERE Data1.Data-ID EQ ipDataID
        AND Data1.Sym1    EQ Data0.Sym1
        AND (Data1.Sym2   EQ {&SPRX-LINE}
          OR Data1.Sym2   EQ {&RPRX-LINE})
      NO-LOCK:

      IF (GetDat1Txt(1) NE "0")
      THEN DO:
         lIsPred = YES.
         LEAVE.
      END.
   END.

   IF lIsPred
   THEN DO:
      PAGE.
      PUT UNFORMATTED
         SPACE(30) "СВЕДЕНИЯ о представителях." SKIP
         "┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐" SKIP
      .
      /* получаем данные о представителе плательщика */
      FIND FIRST Data1
         WHERE Data1.Data-ID EQ ipDataID
           AND Data1.Sym1    EQ Data0.Sym1
           AND Data1.Sym2    EQ {&SPRX-LINE}
         NO-LOCK NO-ERROR.

      cKlntStr = "0".
      IF (AVAIL Data1)
      THEN cKlntStr = GetDat1Txt(1).

      IF (cKlntStr NE "0")
      THEN DO:
         cTmp   = GetDat1Txt(20).   /* документ */

         FIND FIRST code
            WHERE (code.class   EQ "КодДокум")
              AND (code.parent  EQ "КодДокум")
              AND (code.misc[6] EQ cTmp)
            NO-LOCK NO-ERROR.
         cTmp = IF (AVAIL code) THEN code.name ELSE "".

         str[1] = (IF ((cTmp EQ "") OR (cTmp EQ "0")) THEN ""
                   ELSE (cTmp + ", N " + GetDat1Txt(21)
                        + (IF (GetDat1Txt(24) EQ "0") THEN "" ELSE (" " + GetDat1Txt(24)))
                        + ", выдан " + STRING(DATE(GetDat1Txt(26)), "99.99.9999") + ", " + GetDat1Txt(25))).
         {wordwrap.i &s=str &n=3 &l=70}

         PUT UNFORMATTED
            "│Сведения о представителе плательщика                                                                                  │" SKIP
            "├───────────────────────────────────────────────┬──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   Ф.И.О.                                      │" GetDat1Txt( 3) FORMAT "x(70)"                                      "│" SKIP
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   ИНН                                         │" GetDat1Txt(23) FORMAT "x(70)"                                      "│" SKIP
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   Данные документа,удостоверяющего личность   │" str[1] FORMAT "x(70)"                                              "│" SKIP
            "│   (тип,серия,номер,кем и когда выдан)         │" str[2] FORMAT "x(70)"                                              "│" SKIP
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
         .
         /** Адрес регистрации нужно разбить по строкам */
         str[1] = TRIM(
                  (IF (GetDat1Txt( 7) NE "0") THEN              GetDat1Txt( 7)  ELSE "")
                + (IF (GetDat1Txt( 8) NE "0") THEN (", "      + GetDat1Txt( 8)) ELSE "")
                + (IF (GetDat1Txt( 9) NE "0") THEN (", "      + GetDat1Txt( 9)) ELSE "")
                + (IF (GetDat1Txt(10) NE "0") THEN (", д."    + GetDat1Txt(10)) ELSE "")
                + (IF (GetDat1Txt(11) NE "0") THEN (", корп." + GetDat1Txt(11)) ELSE "")
                + (IF (GetDat1Txt(12) NE "0") THEN (", кв."   + GetDat1Txt(12)) ELSE ""), ",")
         .
         {wordwrap.i &s=str &n=10 &l=70}

         PUT UNFORMATTED
            "│   Адрес регистрации                           │" str[1] FORMAT "x(70)"                                              "│" SKIP
         .
         DO i = 2 TO 10:
            IF (str[i] NE "")
            THEN DO:
               PUT UNFORMATTED
                  "│                                               │" str[i] FORMAT "x(70)"                                              "│" SKIP
               .
               str[i] = "".
            END.
         END.
         PUT UNFORMATTED
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   Дата и место рождения                       │" (GetDat1Txt(34) + ", " + GetDat1Txt(35)) FORMAT "x(70)"            "│" SKIP
         .
      END.

      /* получаем данные о представителе получателя */
      FIND FIRST Data1
         WHERE Data1.Data-ID EQ ipDataID
           AND Data1.Sym1    EQ Data0.Sym1
           AND Data1.Sym2    EQ {&RPRX-LINE}
         NO-LOCK NO-ERROR.

      cKlntPl  = cKlntStr.
      cKlntStr = "0".
      IF (AVAIL Data1)
      THEN cKlntStr = GetDat1Txt(1).

      IF (cKlntStr NE "0")
      THEN DO:
         cTmp   = GetDat1Txt(20).   /* документ */

         FIND FIRST code
            WHERE (code.class   EQ "КодДокум")
              AND (code.parent  EQ "КодДокум")
              AND (code.misc[6] EQ cTmp)
            NO-LOCK NO-ERROR.
         cTmp = IF (AVAIL code) THEN code.name ELSE "".

         str[1] = (IF ((cTmp EQ "") OR (cTmp EQ "0")) THEN ""
                   ELSE (cTmp + ", N " + GetDat1Txt(21)
                        + (IF (GetDat1Txt(24) EQ "0") THEN "" ELSE (" " + GetDat1Txt(24)))
                        + ", выдан " + STRING(DATE(GetDat1Txt(26)), "99.99.9999") + ", " + GetDat1Txt(25))).
         {wordwrap.i &s=str &n=3 &l=70}

         IF (cKlntPl NE "0")
         THEN
            PUT UNFORMATTED
               "├───────────────────────────────────────────────┴──────────────────────────────────────────────────────────────────────┤" SKIP
            .


         PUT UNFORMATTED
            "│Сведения о представителе получателя                                                                                   │" SKIP
            "├───────────────────────────────────────────────┬──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   Ф.И.О.                                      │" GetDat1Txt( 3) FORMAT "x(70)"                                      "│" SKIP
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   ИНН                                         │" GetDat1Txt(23) FORMAT "x(70)"                                      "│" SKIP
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   Данные документа,удостоверяющего личность   │" str[1] FORMAT "x(70)"                                              "│" SKIP
            "│   (тип,серия,номер,кем и когда выдан)         │" str[2] FORMAT "x(70)"                                              "│" SKIP
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
         .
         /** Адрес регистрации нужно разбить по строкам */
         str[1] = TRIM(
                  (IF (GetDat1Txt( 7) NE "0") THEN              GetDat1Txt( 7)  ELSE "")
                + (IF (GetDat1Txt( 8) NE "0") THEN (", "      + GetDat1Txt( 8)) ELSE "")
                + (IF (GetDat1Txt( 9) NE "0") THEN (", "      + GetDat1Txt( 9)) ELSE "")
                + (IF (GetDat1Txt(10) NE "0") THEN (", д."    + GetDat1Txt(10)) ELSE "")
                + (IF (GetDat1Txt(11) NE "0") THEN (", корп." + GetDat1Txt(11)) ELSE "")
                + (IF (GetDat1Txt(12) NE "0") THEN (", кв."   + GetDat1Txt(12)) ELSE ""), ",")
         .
         {wordwrap.i &s=str &n=10 &l=70}

         PUT UNFORMATTED
            "│   Адрес регистрации                           │" str[1] FORMAT "x(70)"                                              "│" SKIP
         .
         DO i = 2 TO 10:
            IF (str[i] NE "")
            THEN DO:
               PUT UNFORMATTED
                  "│                                               │" str[i] FORMAT "x(70)"                                              "│" SKIP
               .
               str[i] = "".
            END.
         END.
         PUT UNFORMATTED
            "├───────────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────┤" SKIP
            "│   Дата и место рождения                       │" (GetDat1Txt(34) + ", " + GetDat1Txt(35)) FORMAT "x(70)"            "│" SKIP
         .
      END.

      PUT UNFORMATTED
         "└───────────────────────────────────────────────┴──────────────────────────────────────────────────────────────────────┘" SKIP
      .
   END.

   {preview.i}
END.

{intrface.del}
/*----------------------------------------------------------------------------*/
FUNCTION GetDat0Txt RETURN CHAR (INPUT ipItem AS INTEGER):
   RETURN ClearExtSym(GetEntries(ipItem,Data0.Txt,"~n","0")).
END FUNCTION.
/*----------------------------------------------------------------------------*/
FUNCTION GetDat1Txt RETURN CHAR (INPUT ipItem AS INTEGER):
   RETURN ClearExtSym(GetEntries(ipItem,Data1.Txt,"~n","0")).
END FUNCTION.
