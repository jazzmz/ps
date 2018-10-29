/*
               Банковская интегрированная система БИСквит
    Copyright: (C) MCMXCII-MCMXCIX ТОО "Банковские информационные системы"
     Filename: ap_ln.p
      Comment: Процедура формирования отчетов по карточкам УМЦ по шаблону.
   Parameters: 
               ap_ln( {Код шаблона}                    |
                      {Тип шаблона}@{Параметры вывода} |
                      {Тип субпроводки}
                    ), где:
               Код шаблона:
                  Код_шаблона, показателя

               Тип шаблона:
                  Фильтр картотеки, карточка.
                  Примеры:
                  selected печать  по карточке
                  total    итоги   по карточке
                  subtotal подитог по карточке

               Параметры вывода:
                  1) нулевые строки: "пропускать"     - пропускать
                                     "" | "печатать"  - печатать
                  2) код шаблона для вывода подитога
                  3) число, прибавляемое к LINE-COUNTER

                  Тип субпроводки:
                  Тип субпроводки для вывода в отчет по карточке.
         Uses:
      Used by:
      Created: 30/07/2004   fedm
     Modified:
*/

DEF OUTPUT PARAM xResult AS DECIMAL NO-UNDO. /* возвращаемый результат,
                                                "?" в случае ошибки     */
DEF INPUT  PARAM beg     AS DATE    NO-UNDO. /* нач.дата периода        */
DEF INPUT  PARAM dob     AS DATE    NO-UNDO. /* кон.дата периода        */
DEF INPUT  PARAM xStr    AS CHAR    NO-UNDO. /* строка параметров       */

/* Временная таблица отметок */
{tmprecid.def}

/* Таблица используется для отчетов где требуется группировка */
{a-tmpsort.def}

/* Определение временных таблиц, разделяемых переменных и функций для расчета */
{pir-a-rl(ln).def NEW}

mCntLin = INT64(GetSysConf ("loan:npp")).
IF mCntLin = ? THEN
   mCntLin = 0.

CREATE tt-val.
ASSIGN tt-val.val       = FGetSetting("КодФил", ?, "")
       tt-val.code      = "КодФил"
       tt-val.level     = 0
       tt-val.surrogate = "".
/* ОСНОВНОЙ БЛОК */

/* Код шаблона отчета. */
DEF VAR mNorm        AS CHAR  NO-UNDO.

/* Код шаблона для вывода подитога */
DEF VAR mNorm2       AS CHAR  NO-UNDO.

/* Код пользовательской настройки. */
DEF VAR mUserConf    AS CHAR  NO-UNDO.
DEF VAR mUserConf2   AS CHAR  NO-UNDO.

/* число, прибавляемое к LINE-COUNTER */
DEF VAR mLCnt        AS INT64   NO-UNDO.

/* Класс (подсистема УМЦ). */
DEF VAR mClass-Code  AS CHAR  NO-UNDO.

/* Дата опердня */
DEF VAR mEnd-Date    AS DATE  NO-UNDO.

/* Параметры вызова browseld */
DEF VAR mBrPrms   AS CHAR  NO-UNDO EXTENT 3.

/* Количество строк в шаблоне */
DEF VAR vQty         AS INT64   NO-UNDO.
/* Счётчик строк шаблона */
DEF VAR vCnt         AS INT64   NO-UNDO.
/* Формирование списка показателей для расчёта */
DEF VAR vCodLst      AS CHAR  NO-UNDO.
/* Строка отчета */
DEF VAR vRepLin      AS CHAR  NO-UNDO.

/* Разбор строки параметров */
ASSIGN
   mNorm       =     GetEntries(1, xStr      , "|", "")    /* Код шаблона      */
   mUserConf   =     GetEntries(2, xStr      , "|", "")    /* Тип шаблона +    
                                                           ** Параметры вывода */
   mKEType     =     GetEntries(3, xStr      , "|", "")    /* Тип субпроводки  */
                                                           
   mUserConf2  =     GetEntries(2, mUserConf , "@", "")    /* Параметры вывода */
   mUserConf   =     GetEntries(1, mUserConf , "@", "")    /* Тип шаблона      */
   mNullStr    = IF  GetEntries(1, mUserConf2, ",", "печатать") EQ "пропускать"
                 THEN YES                        /* пропускать нулевые строки */
                 ELSE NO                         /* печатать   нулевые строки */

   mNorm2      =     GetEntries(2, mUserConf2, ",", "")
   mLCnt       = INT64(GetEntries(3, mUserConf2, ",", ""))
   mBrPrms[1]  = "UserConf"
   mBrPrms[2]  = mUserConf
   mBrPrms[3]  = "UserConf"
   mSort       = GetSysConf("in-dt:SortValue")
   mSort       = IF mSort EQ ?
                 THEN ""
                 ELSE mSort
.

/* Для случая когда tt-ns объявлена как NEW SHARED */
IF mSort NE "" THEN
DO:
   RUN a-rid-rest.p (OUTPUT TABLE tt-ns) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN
      RUN Fill-SysMes IN h_tmess ("", "", "0", ERROR-STATUS:GET-MESSAGE(1)).
END.

IF    mNorm     EQ ""
   OR mUserConf EQ "" THEN
   RUN Fill-SysMes IN h_tmess ("", "", "0",
      "В шаблоне указаны некорректные параметры для ap_ln~n" +
      "Формат должен быть таким:~n" +
      "ap_ln(<Код_шаблона_или_показателя>|<Фильтр_картотеки_или_карточка>)").

/* Зашивка по отчётам МСФО */
IF CAN-DO("*msfo1*,*msfo3*", mNorm) THEN
   ASSIGN
      mBrPrms[1] = mBrPrms[1] + CHR(1) + "branch-id" + CHR(1) + "close-date1"
      mBrPrms[2] = mBrPrms[2] + CHR(1) + sh-Branch-id  + CHR(1) + STRING(dob + 1, "99/99/9999")
      mBrPrms[3] = mBrPrms[1].
ELSE IF CAN-DO("*msfo2*", mNorm) THEN
   ASSIGN
      mBrPrms[1] = mBrPrms[1] + CHR(1) + "op-date1"  + CHR(1) + "close-date1"
                              + CHR(1) + "op-date2"  + CHR(1) + "close-date2"
      mBrPrms[2] = mBrPrms[2] + CHR(1) + STRING(beg, "99/99/9999") + CHR(1) + STRING(beg, "99/99/9999")
                              + CHR(1) + STRING(dob, "99/99/9999") + CHR(1) + STRING(dob, "99/99/9999")
      mBrPrms[3] = mBrPrms[1].

IF NUM-ENTRIES(mUserConf) = 4 THEN
DO:
   mClass-Code = ENTRY(4, mUserConf).

   SUBSCRIBE "AfterNavigate" ANYWHERE RUN-PROCEDURE "AfterNavigate".

   ASSIGN
      mEnd-Date = gend-date
      gend-date = dob.

   RUN browseld.p (mClass-Code,
                   mBrPrms[1],
                   mBrPrms[2],
                   mBrPrms[3],
                   4
                  ).
   gend-date = mEnd-Date.
END.

ELSE IF mUserConf = "calc_dif" THEN
   RUN SetSysConf IN h_base ("ap_ln:calc_dif", mUserConf2).

ELSE IF mUserConf = "break_by" THEN
DO:
   ASSIGN
      mNorm2     = "chkst.s"
      mNulStr    = LOGICAL(GetSysConf("in-dt:NulStr"))
   .

   FOR
      EACH tt-ns
   BREAK BY tt-ns.sort-value
         BY tt-ns.id
   :
      IF CAN-DO("mol,branch", mSort) THEN
         RUN SetSysConf IN h_base ("ap_ln:calc_val", STRING(tt-ns.idsv)).

      IF     FIRST-OF (tt-ns.sort-value) THEN
         RUN FillNameGr("head", "").

      IF LINE-COUNTER(fil) + 3 GT PAGE-SIZE(fil) THEN
      DO:
         PUT STREAM fil UNFORMATTED page_footer SKIP.
         PAGE STREAM fil.
         PUT  STREAM fil UNFORMATTED page_header SKIP.
      END.

      RUN PrintLoan (tt-ns.idln).

      IF mSort NE "no-group" THEN
         RUN SubTotalCalc.

      IF     LAST-OF(tt-ns.sort-value)
         AND mSort NE "no-group" THEN
      DO:
         PUT STREAM fil UNFORMATTED page_footer SKIP.
         RUN PrintSubTotal.

         IF NOT LAST(tt-ns.sort-value) THEN
            PUT STREAM fil UNFORMATTED
               "┌" + FILL("─", LENGTH(ENTRY(1, page_header, "~n")) - 2) + "┐"
            SKIP.
      END.
   END.
   IF mSort EQ "no-group" THEN
      PUT STREAM fil UNFORMATTED page_footer SKIP.

   RUN DeleteOldDataProtocol IN h_base ("ap_ln:").
END.

ELSE IF mUserConf = "selected" THEN
FOR
   EACH  tmprecid BREAK BY tmprecid.id:

   IF LAST(tmprecid.id) THEN
      mLastLn = YES.

   RUN PrintLoan (tmprecid.id).
END.
ELSE IF mUserConf = "total" THEN
DO:
   ASSIGN
      page_header = ""
      page_footer = ""
   .
   RUN PrintTotal.
END.
ELSE IF mUserConf = "mol" THEN
   RUN PrintMol.
ELSE
   RUN PrintLoan (INT64(GetSysConf ("loan:recid"))).

RUN EndPurge NO-ERROR.

RETURN.

/* -------------------------------------------------------------------------- */

/* Перебор карточек по фильтру */
PROCEDURE AfterNavigate:

   DEF INPUT  PARAMETER iH    AS HANDLE   NO-UNDO.
   DEF OUTPUT PARAMETER oRet  AS LOGICAL  NO-UNDO INITIAL NO.

   DEF VAR vHQ  AS HANDLE  NO-UNDO.
   DEF VAR vHB  AS HANDLE  NO-UNDO.
   /* Счётчик */
   DEF VAR vCnt AS INT64     NO-UNDO.

   RUN Open-Query IN iH.

   vHQ = DYNAMIC-FUNCTION("GetHandleQuery" IN iH).

   IF vHQ:IS-OPEN THEN
   DO:
      /* Получить хэндл буфера карточки */
      DO vCnt = 1 TO vHQ:NUM-BUFFERS:
         vHB = vHQ:GET-BUFFER-HANDLE(vCnt).
         IF vHB:NAME = "loan" THEN
            LEAVE.
      END.

      {justamin }
      /* Перебор выборки */
      RUN GetFirstRecord IN iH (vHQ).
      DO WHILE NOT vHQ:QUERY-OFF-END:
         RUN PrintLoan (vHB:RECID). /* Печать по шаблону для карточки */
         RUN GetNextRecord IN iH (vHQ).
      END.
   END.
   /* Сохраняем последний порядковый номер */
   RUN SetSysConf IN h_base ("loan:npp", mCntLin).

   RETURN.

END PROCEDURE.

/* Печать по шаблону для карточки */
PROCEDURE PrintLoan:

   DEF INPUT PARAMETER iLnRid AS RECID NO-UNDO.
   DEF BUFFER norm FOR norm.

   /* Удаление показателей по пред.карточке */
   FOR EACH tt-val WHERE
            tt-val.level > 0:
      DELETE tt-val.
   END.

   IF CAN-FIND(FIRST norm WHERE norm.norm = mNorm) THEN
   FOR EACH norm WHERE
            norm.norm = mNorm
      NO-LOCK:
     
      RUN PrintTxt(iLnRid, norm.txt).

      IF     mUserConf2               NE ""
         AND mSort                    EQ ""
         AND mLastLn                  EQ NO
         AND CAN-FIND(FIRST norm   WHERE
                            norm.norm EQ mNorm2) THEN
         RUN SubTotalCalc.

      IF CAN-FIND(FIRST norm WHERE norm.norm = ENTRY(1, mNorm, ".") + ".2") THEN
      /* Суммирование числовых параметров для строки ИТОГО */
      FOR EACH tt-val WHERE tt-val.level = 1
                        AND (tt-val.type = "INT"
                         OR  tt-val.type = "DECIMAL") NO-LOCK:
         IF tt-val.code NE "№" THEN
         DO:
            IF GetSysConf("TOT:" + tt-val.code) EQ ?
            THEN DO:
               RUN SetSysConf IN h_base ("TOT:"  + tt-val.code, tt-val.val ).
               RUN SetSysConf IN h_base ("TYPE:" + tt-val.code, tt-val.type).
            END.
            ELSE DO:
               RUN SetSysConf IN h_base
                  (
                    INPUT "TOT:" + tt-val.code
                  , INPUT STRING(DECIMAL(GetSysConf("TOT:" + tt-val.code)) +
                                 DECIMAL(tt-val.val))
                  ) .
            END.
         END.
         IF tt-val.code EQ "№" THEN
         DO:
            DEFINE VARIABLE vNpp AS CHARACTER NO-UNDO.
            vNpp = GetSysConf("TOT:№").
            IF vNpp EQ ? THEN
               vNpp  = "0".
            RUN SetSysConf IN h_base
               (
                 INPUT "TOTAL-REPORT:Total"
               , INPUT STRING(DECIMAL(vNpp) + DECIMAL(tt-val.val))
               ) .
         END.
      END.
   END.
   ELSE
   DO:
      mNorm = "[" + ENTRY(1, mNorm)
            + (IF NUM-ENTRIES(mNorm) > 1
               THEN FILL(" ", INT64(ENTRY(2, mNorm)) - LENGTH(ENTRY(1, mNorm)) - 2)
               ELSE ""
              )
            + "]".
      /* Расчёт показателей по карточке */
      RUN CalcCard IN hLn (iLnRid,
                           1,
                           fill-str(mNorm, 0)
                          ).

      /* Заменяем идентификаторы показателей на рассчитанные значения
      ** и выводим в отчёт
      */

      PUT STREAM fil UNFORMATTED
         fill-str (mNorm, 1).
   END.

   RETURN.

END PROCEDURE.

/* Печать по шаблону для карточки */
PROCEDURE PrintTxt:
   DEF INPUT PARAMETER iLnRid AS RECID NO-UNDO.
   DEF INPUT PARAMETER iTxt   AS CHAR  NO-UNDO.

   DEF VAR vLength AS INT64 NO-UNDO.

   IF PAGE-SIZE(fil) <> 0 THEN
   DO:
      IF PAGE-SIZE(fil) - LINE-COUNTER(fil) < 1 THEN
      DO:
         PUT STREAM fil UNFORMATTED page_footer SKIP.
         PAGE STREAM fil.
      END.

      IF LINE-COUNTER(fil) = 1 AND
         page_header <> ""
      THEN
         PUT STREAM fil UNFORMATTED page_header SKIP.

      IF     mUserConf2                NE ""
         AND LINE-COUNTER(fil) + mLCnt GT PAGE-SIZE(fil) THEN
         RUN PrintSubTotal.
      ELSE
      IF     mUserConf2 EQ ""
         AND LINE-COUNTER(fil) + 5 GE PAGE-SIZE(fil)
      THEN
      DO:
         vLength = LENGTH(ENTRY(1, page_header, "~n")) / 2.

         PUT STREAM fil UNFORMATTED page_footer SKIP.
         PAGE STREAM fil.
         IF mNorm2 BEGINS "chkst" THEN
            PUT STREAM fil UNFORMATTED FILL(" ",  vLength) + STRING(PAGE-NUMBER(fil)) SKIP.
         PUT STREAM fil UNFORMATTED page_header SKIP.
      END.
   END.

   vQty = NUM-ENTRIES(TRIM(iTxt,"~~"), "~~").

   /* Перебор строк шаблона */
   DO vCnt = 1 TO vQty:
      /* Очередная строка шаблона */
      vRepLin = ENTRY(vCnt, iTxt, "~~").

      IF vRepLin BEGINS "[СТРАНИЦА" THEN
         PAGE STREAM fil.

      /* Формирование списка показателей для расчёта */
      vCodLst = fill-str(vRepLin, 0).

/*           message vCodLst VIEW-AS ALERT-BOX.*/
      /* Расчёт показателей по карточке */
      RUN CalcCard IN hLn (iLnRid,
                           1,
                           vCodLst
                          ).

      /* Заменяем идентификаторы показателей на рассчитанные значения
      ** и выводим в отчёт
      */
      PUT STREAM fil UNFORMATTED
         fill-str (vRepLin, 1)
      SKIP.
   END.

   IF     mLastLn
      AND mSort                    EQ ""
      AND mNorm2                   NE ""
      AND CAN-FIND(FIRST norm   WHERE
                         norm.norm EQ mNorm2)
   THEN DO:
      RUN SubTotalCalc.
      RUN PrintSubTotal.
   END.

   RETURN.

END PROCEDURE.

/* Печать по шаблону для строки ИТОГО */
PROCEDURE PrintTotal:
   FOR EACH norm   WHERE
            norm.norm EQ mNorm
      NO-LOCK:
      vQty = NUM-ENTRIES(TRIM(norm.txt,"~~"), "~~").

      /* Перебор строк шаблона */
      DO vCnt = 1 TO vQty:
         /* Очередная строка шаблона */
         vRepLin = ENTRY(vCnt, norm.txt, "~~").

         fill-str(vRepLin, 0).

         PUT STREAM fil UNFORMATTED
            fill-str (vRepLin, 2)
            SKIP.
      END.
   END.

   RUN DeleteOldDataProtocol IN h_base ("TOT:").
   RUN DeleteOldDataProtocol IN h_base ("TYPE:").

END PROCEDURE.

PROCEDURE PrintSubTotal:
   DEFINE VARIABLE vLength AS INT64 NO-UNDO.

   FOR EACH norm   WHERE
            norm.norm EQ mNorm2
      NO-LOCK:

      vQty = NUM-ENTRIES(TRIM(norm.txt,"~~"), "~~").
   
      /* Перебор строк шаблона */
      DO vCnt = 1 TO vQty:
         /* Очередная строка шаблона */
         vRepLin = ENTRY(vCnt, norm.txt, "~~").

         IF     NOT CAN-DO(",no-group", mSort)
            AND vRepLin MATCHES "*Итого по*"
            AND vRepLin MATCHES "*//*//*" THEN
         DO:
            RUN FillNameGr("SubTotal", ENTRY(3, RIGHT-TRIM(vRepLin, "//"), "//")).
            vRepLin = ENTRY(1, vRepLin, "//") + RETURN-VALUE.
         END.

         PUT STREAM fil UNFORMATTED
            fill-str (vRepLin, 3)
         SKIP.
      END.

/* Если это не последняя карточка, то нет смысла начинать новую страницу */
      IF     mLastLn  EQ NO
         AND mSort    EQ ""
      THEN DO:
         vLength = LENGTH(ENTRY(1, page_header, "~n"))
                 - LENGTH("Стр. " + STRING(PAGE-NUMBER(fil))).
         PAGE STREAM fil.
         IF mNorm2 BEGINS "mbpinv" THEN
            PUT STREAM fil UNFORMATTED FILL(" ",  vLength) + "Стр. " + STRING(PAGE-NUMBER(fil)) SKIP.
         PUT  STREAM fil UNFORMATTED page_header SKIP.
      END.

      /* Для отчетов с подгруппами */
      ELSE IF mSort NE ""
      THEN DO:
         IF LINE-COUNTER(fil) + 5 GT PAGE-SIZE(fil) THEN
         DO:
            vLength = LENGTH(ENTRY(1, page_header, "~n"))
                    - LENGTH("Стр. " + STRING(PAGE-NUMBER(fil))).
            PAGE STREAM fil.
            IF mNorm2 BEGINS "mbpinv" THEN
               PUT STREAM fil UNFORMATTED FILL(" ",  vLength) + "Стр. " + STRING(PAGE-NUMBER(fil)) SKIP.
            PUT  STREAM fil UNFORMATTED page_header SKIP.
         END.
      END.
   END.

   RUN DeleteOldDataProtocol IN h_base ("SUBTOT:").
   RUN DeleteOldDataProtocol IN h_base ("SUBTYPE:").

END PROCEDURE.

/* Суммирование подитогов */
PROCEDURE SubTotalCalc:
   /* Суммирование числовых параметров для подитога */
   FOR EACH tt-val    WHERE
            tt-val.level EQ 1
       AND  tt-val.code  = "ОКК-учет-Ф" OR tt-val.code  = "ОКК-учет"
       AND (tt-val.type  EQ "INT"
            OR
            tt-val.type  EQ "DECIMAL")
      NO-LOCK:
      tt-val.type = "DECIMAL".
   end.
    
   FOR EACH tt-val    WHERE
            tt-val.level EQ 1
       AND  tt-val.code  NE "№"
       AND (tt-val.type  EQ "INT"
            OR
            tt-val.type  EQ "DECIMAL")
      NO-LOCK:
/*      message tt-val.code tt-val.val VIEW-AS ALERT-BOX.*/
      IF GetSysConf("SUBTOT:" + tt-val.code) EQ ?
      THEN DO:
         RUN SetSysConf IN h_base ("SUBTOT:"  + tt-val.code, tt-val.val).
         RUN SetSysConf IN h_base ("SUBTYPE:" + tt-val.code, tt-val.type).
/*      message tt-val.code tt-val.val tt-val.type VIEW-AS ALERT-BOX.*/
      END.

      ELSE
         RUN SetSysConf IN h_base ("SUBTOT:" + tt-val.code,
                                   STRING(DECIMAL(GetSysConf("SUBTOT:"
                                                           + tt-val.code
                                                            )
                                                 )
                                        + DECIMAL(tt-val.val)
                                         )
                                  ).
   END.
END PROCEDURE.

/* Печать МОЛ(ов) */
PROCEDURE PrintMol:
   DEF VAR vFill AS CHAR NO-UNDO.

   FOR EACH norm   WHERE
            norm.norm EQ mNorm
      NO-LOCK:

      vQty = NUM-ENTRIES(TRIM(norm.txt,"~~"), "~~").

      /* Перебор строк шаблона */
      DO vCnt = 1 TO vQty:
         vFill = "".

         /* Очередная строка шаблона */
         vRepLin = ENTRY(vCnt, norm.txt, "~~").

         vFill = fill-str (vRepLin, 4).

         IF vFill NE "" THEN
            PUT STREAM fil UNFORMATTED vFill SKIP.
         ELSE
            PUT STREAM fil UNFORMATTED " " SKIP.
      END.
   END.

END PROCEDURE.

/* Заполнить строку наименванием группы */
PROCEDURE FillNameGr:
   DEF INPUT PARAM iMode   AS CHAR  NO-UNDO.
   DEF INPUT PARAM iRetVal AS CHAR  NO-UNDO.

   DEF VAR vLen    AS INT64  NO-UNDO.
   DEF VAR vName   AS CHAR NO-UNDO.
   DEF VAR vNam2   AS CHAR NO-UNDO.
   DEF VAR vCnt    AS INT64  NO-UNDO.
   DEF VAR vLength AS INT64  NO-UNDO.

   DEF BUFFER loan-acct FOR loan-acct.
   DEF BUFFER employee  FOR employee.
   DEF BUFFER branch    FOR branch.
   DEF BUFFER asset     FOR asset.

   vLen    = LENGTH(ENTRY(1, page_header, "~n")) - 2.

   IF iRetVal NE "" THEN
   DO vCnt = 1 TO NUM-ENTRIES(iRetVal):
      ASSIGN
         vName = vName + "," + ENTRY(1,ENTRY(vCnt,iRetVal), "(")
         vNam2 = vNam2 + "," + ENTRY(2,ENTRY(vCnt,iRetVal), "(")
         vNam2 = TRIM(vNam2, ")")
      .
   END.

   CASE mSort:
      WHEN "asset"  THEN
      DO:
         FIND FIRST asset WHERE RECID(asset) EQ tt-ns.idsv
         NO-LOCK NO-ERROR.
         IF AVAIL asset THEN
            ASSIGN
               vNam2 = ENTRY(LOOKUP(mSort, vName), vNam2) WHEN vNam2 NE ""
               vName = GetCodeName("asset", tt-ns.sort-value)
               vName = vNam2 + " " + vName
            .
      END.

      WHEN "acct"  THEN
      DO:
         FIND FIRST loan-acct WHERE RECID(loan-acct) EQ tt-ns.idsv
         NO-LOCK NO-ERROR.
         IF AVAIL loan-acct THEN
            ASSIGN
               vNam2 = ENTRY(LOOKUP(mSort, vName), vNam2) WHEN vNam2 NE ""
               vName = loan-acct.acct + " " + (IF iMode EQ "head" THEN GetCodeName("loan-acct", loan-acct.acct-type) ELSE "")
               vName = vNam2 + " " + vName WHEN iRetVal NE ""
            .
      END.

      WHEN "mol"  THEN
      DO:
         FIND FIRST employee WHERE RECID(employee) EQ tt-ns.idsv
         NO-LOCK NO-ERROR.
         IF AVAIL employee THEN
            ASSIGN
               vNam2 = ENTRY(LOOKUP(mSort, vName), vNam2) WHEN vNam2 NE ""
               vName = employee.name
               vName = vNam2 + " " + vName WHEN iRetVal NE ""
            .
            
      END.

      WHEN "branch"  THEN
      DO:
         FIND FIRST branch WHERE RECID(branch) EQ tt-ns.idsv
         NO-LOCK NO-ERROR.
         IF AVAIL branch THEN
            ASSIGN
               vNam2 = ENTRY(LOOKUP(mSort, vName), vNam2) WHEN vNam2 NE ""
               vName = branch.name
               vName = vNam2 + " " + vName WHEN iRetVal NE ""
            .
      END.
   END CASE.

   IF iMode EQ "head" THEN
   DO:
      PUT STREAM fil UNFORMATTED
         "│" + vName + FILL(" ", vLen - LENGTH(vName)) + "│"
      SKIP.
      PUT STREAM fil UNFORMATTED
         ENTRY(NUM-ENTRIES(page_header, "~n"), page_header, "~n")
      SKIP.

      IF     mUserConf2 EQ ""
         AND LINE-COUNTER(fil) + 5 GE PAGE-SIZE(fil) THEN
      DO:
         vLength = LENGTH(ENTRY(1, page_header, "~n")) / 2.

         PUT STREAM fil UNFORMATTED page_footer SKIP.
         PAGE STREAM fil.
         PUT STREAM fil UNFORMATTED FILL(" ",  vLength) + STRING(PAGE-NUMBER(fil)) SKIP.
         PUT STREAM fil UNFORMATTED page_header SKIP.
      END.
   END.
   ELSE
      RETURN vName.

   RETURN.
END PROCEDURE.
