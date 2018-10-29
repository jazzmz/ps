{pirsavelog.p}
/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: a-rl(ln).p
      Comment: Инструменты для получения данных по карточке в отчетах и т.п.
   Parameters:
         Uses:
      Used by:
      Created: 19/07/2004 fedm
     Modified: kuntash доработка до 33 пачта код ОС
*/

DEF INPUT PARAMETER beg           AS DATE    NO-UNDO. /* нач.дата периода */
DEF INPUT PARAMETER dob           AS DATE    NO-UNDO. /* кон.дата периода */

{globals.i}

{intrface.get xclass}
{intrface.get umc}
{intrface.get date}
{intrface.get xobj}

{a-defs.i}
{a-rl(ln).def}

/* Хэндл персистентной библиотеки a-obj.p */
DEF VAR ht                        AS HANDLE  NO-UNDO.
/* Устанавливаем библиотеку парсерных функций УМЦ */
RUN a-obj.p  PERSISTENT SET ht ("Main",  "", "").


/* Расчёт показателей по карточке УМЦ */
PROCEDURE CalcCard:
   DEF INPUT PARAMETER iLnRecId   AS RECID   NO-UNDO.
   DEF INPUT PARAMETER iLevel     AS INT     NO-UNDO.
   DEF INPUT PARAMETER iPrmLst    AS CHAR    NO-UNDO.

   DEF BUFFER loan        FOR loan.
   DEF BUFFER asset       FOR asset.
   DEF BUFFER loan-acct   FOR loan-acct.
   DEF BUFFER kau-entry   FOR kau-entry.
   DEF BUFFER tt-val      FOR tt-val.

   /* Номер показателя в списке */
   DEF VAR vI                     AS INT     NO-UNDO.
   /* Дата для расчета показателя */
   DEF VAR vDate                  AS DATE    NO-UNDO.
   /* Дата начала периода для расчета показателя */
   DEF VAR vTmpDate               AS DATE    NO-UNDO.
   DEF VAR vTmpSum                AS DEC     NO-UNDO.

   /* Код функции */
   DEF VAR vFun                   AS CHAR    NO-UNDO.
   /* Код */
   DEF VAR vCod                   AS CHAR    NO-UNDO.
   /* Код */
   DEF VAR vCod2                  AS CHAR    NO-UNDO.
   /* Количество */
   DEF VAR vQty                   AS DECIMAL NO-UNDO.
   /* Количество */
   DEF VAR vQty2                  AS DECIMAL NO-UNDO.
   /* Сумма */
   DEF VAR vSum                   AS DECIMAL NO-UNDO.
   /* Сумма */
   DEF VAR vSum2                  AS DECIMAL NO-UNDO.
   /* Тип данных */
   DEF VAR vType                  AS CHAR    NO-UNDO.
   /* Код показателя для расчета */
   DEF VAR vCode                  AS CHAR    NO-UNDO.
   /* Для временного хранения нек. показателей */
   DEF VAR vStrTmp                AS CHAR    NO-UNDO.
   DEF VAR vStrTmp2               AS CHAR    NO-UNDO.
   /* Число для расчета показателя */
   DEF VAR vITmp                  AS INT     NO-UNDO.

   FOR
      FIRST loan WHERE RECID(loan) EQ iLnRecId
        NO-LOCK,
      FIRST asset OF loan
        NO-LOCK:

      IF     mNullStr
         AND GetLoan-Pos(loan.contract,
                         loan.cont-code,
                         "-учет",
                         dob) EQ 0 THEN
         NEXT.

      IF VALID-HANDLE(ht) THEN
         RUN Change IN ht (loan.contract, loan.cont-code, ?, "").

      /* Перебор показателей, которые необходимо рассчитать */
      DO vI = 1 TO NUM-ENTRIES(iPrmLst):

         FIND FIRST tt-prm   WHERE
                    tt-prm.code EQ ENTRY(vI, iPrmLst)
            NO-LOCK NO-ERROR.

         IF NOT AVAILABLE tt-prm THEN
            NEXT.

         CREATE tt-val.
         ASSIGN tt-val.code      = tt-prm.code
                tt-val.surrogate = loan.contract + "," + loan.cont-code
                tt-val.level     = iLevel.

         ASSIGN
            vCode = TRIM(tt-val.code, "#")
            vType = "CHAR".

         IF tt-val.code MATCHES "*(*)" THEN
            RUN VALUE(ENTRY(1, tt-val.code, "("))
               (OUTPUT vSum,
                       beg,
                       dob,
                       TRIM(SUBSTR(tt-val.code,
                                   INDEX(tt-val.code,
                                   "(") + 1
                                  ), ")")
                     + "|" + STRING(iLnRecId)

               ) NO-ERROR.
         ELSE
         CASE vCode:
            WHEN "№"         THEN
            DO:
               ASSIGN
                  vType      = "INT"
                  mCntLin    = mCntLin + 1
                  tt-val.val = STRING(mCntLin).

               IF GetSysConf("SUBTOT:№") EQ ?
               THEN DO:
                  RUN SetSysConf IN h_base ("SUBTOT:№" , "1").
                  RUN SetSysConf IN h_base ("SUBTYPE:№", "INT").
               END.

               ELSE
                  RUN SetSysConf IN h_base ("SUBTOT:№",
                                            STRING(INT(GetSysConf("SUBTOT:№"))
                                                 + 1)).
               IF mLastLn THEN
                  RUN SetSysConf IN h_base ("TOT:№", tt-val.val).
            END.

            WHEN "Модуль"    THEN
                tt-val.val   = loan.contract.

            WHEN "Инв№"      THEN
                tt-val.val   = loan.doc-ref.

            WHEN "КодЦенн"   THEN
                tt-val.val   = loan.cont-type.

            WHEN "НаимЦенн"  THEN
                tt-val.val   = GetObjName("asset", GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)), YES).

            WHEN "ЕдИзм"     THEN
                tt-val.val   = asset.unit.

            WHEN "ЦенаМЦ"    THEN
               ASSIGN
                  vType      = "DECIMAL"
                  tt-val.val = STRING(GetCostUMC(loan.contract + CHR(6)
                                               + loan.cont-code,
                                                 dob,
                                                 "",
                                                 ""
                                                )
                                     ).
            WHEN "НомерПрин"
            THEN DO:
              vDate          = GetInDate (loan.contract,
                                          loan.cont-code,
                                          "Б"
                                         ).
              FIND FIRST kau-entry      WHERE
                         kau-entry.op-date EQ     vDate
                     AND kau-entry.kau     BEGINS loan.contract + ","
                                                + loan.cont-code
                     AND kau-entry.debit   EQ     YES
                     AND kau-entry.kau-id  EQ     "УМЦ-учет"
                 NO-LOCK NO-ERROR.

              IF AVAILABLE kau-entry THEN
              DO:
                 FIND FIRST op OF kau-entry NO-LOCK NO-ERROR.
                 IF AVAILABLE op THEN
                    tt-val.val = op.doc-num.
              END.
            END.
            WHEN "ДатаПрих"  THEN
               ASSIGN
                  tt-val.val = STRING(GetInDate (loan.contract,
                                                 loan.cont-code,
                                                 "Б"
                                                ),
                                      "99.99.9999"
                                     ).

            WHEN "ДатаВыб"   THEN
            DO:
               RUN GetLoanDate IN h_umc (loan.contract,
                                         loan.cont-code,
                                         "-учет",
                                         "Out",
                                         OUTPUT vTmpDate,
                                         OUTPUT vTmpSum
                                        ).
               ASSIGN
                  tt-val.val = STRING(vTmpDate,
                                      "99.99.9999"
                                     ).
               IF tt-val.val EQ "01.01.0001" THEN
                  tt-val.val = STRING(loan.close-date, "99.99.9999").
            END.

            WHEN "ФкСрокЭксп2" THEN
               ASSIGN
                  vType = "INT"
                  vDate = GetInDate (loan.contract,
                                     loan.cont-code,
                                     "Б"
                                    )
                  vITmp = INT(GetXattrValue("loan",
                                            loan.contract + ","
                                          + loan.cont-code,
                                            "СрокЭкспл"
                                           )
                             )
                  vITmp = vITmp + IF    vDate EQ 01/01/0001
                                     OR vDate EQ 01/01/9999 THEN
                                     0
                                  ELSE
                                     INT(MonInPer(vDate,
                                                  DATE(GetEntries(1,
                                                                  pick-value,
                                                                  "-",
                                                                  STRING(vDate)
                                                                 ))))
                  tt-val.val = IF    vITmp EQ ?
                                  OR vITmp EQ 0
                               THEN ""
                               ELSE STRING(vITmp)
               .


            /* Темпоральный показатель из таблицы комиссий */
            WHEN "СПИБ" OR
            WHEN "СПИН" OR
            WHEN "КУБ"  OR
            WHEN "КУН"  THEN
               ASSIGN
                  vType      = (IF vCode BEGINS "СПИ"
                                THEN "INT"
                                ELSE "DECIMAL"
                               )
                  tt-val.val = STRING(GetSrokAmor(RECID(loan),
                                                  vCode,
                                                  dob
                                                 )
                                     ).

            WHEN "НАБ" OR
            WHEN "НАН" THEN
               ASSIGN
                  vType      = "DECIMAL"
                  tt-val.val = STRING(ROUND(GetAmortNorm(loan.contract,
                                                         loan.cont-code,
                                                         dob,
                                                         SUBSTR(vCode, 3, 1)
                                                        ),
                                            2
                                           )
                                     ).
            WHEN "СПИМ" OR
            WHEN "НАМ"  THEN
            DO:
               ASSIGN
                  vType      = "INT"
                  tt-val.val = GetXAttrValueEx("asset",
                                               loan.cont-type,
                                               "AmortGrMSFO",
                                               ""
                                              )
                  tt-val.val = GetCode ("МСФО_АморГр",
                                        tt-val.val
                                       ).

               IF vCode EQ "НАМ" THEN
                  ASSIGN
                     vType      = "DECIMAL"
                     tt-val.val = STRING(ROUND(100 / INT(tt-val.val), 2)).
            END.

            WHEN "СумНДС" THEN
            DO:
               ASSIGN
                  vType      = "DECIMAL"
                  tt-val.val = GetXAttrValueEx("loan",
                                               loan.contract + ","
                                             + loan.cont-code,
                                               "СуммаНДС",
                                               "?"
                                              ).
               IF tt-val.val EQ "?" THEN
                  ASSIGN
                     tt-val.val = GetXAttrValueEx("loan",
                                                  loan.contract + ","
                                                + loan.cont-code,
                                                  "НДС",
                                                  "0"
                                                 )
                     tt-val.val = STRING(GetLoan-Pos (loan.contract,
                                                      loan.cont-code,
                                                      "-учет",
                                                      01/01/0001
                                                     ) * DECIMAL(tt-val.val)
                                                / (100 + DECIMAL(tt-val.val))
                                        ).
            END.

            WHEN "ФинРез" THEN /* Цена продажи минус остаточная стоимость */
            DO:
               RUN GetLoanDate IN h_umc (loan.contract,
                                         loan.cont-code,
                                         "-учет",
                                         "Out",
                                         OUTPUT vTmpDate,
                                         OUTPUT vTmpSum
                                        ).
               RUN GetAmtUMC (loan.contract,
                              loan.cont-code,
                              vTmpDate - 1,
                              OUTPUT vSum,
                              OUTPUT vQty
                             ).
               ASSIGN
                  vType      = "DECIMAL"
                  vSum       = DECIMAL(GetXAttrValueEx("loan",
                                                       loan.contract + ","
                                                     + loan.cont-code,
                                                       "ЦенаПродажи",
                                                       "0"
                                                      )
                                      ) - vSum
                  tt-val.val = STRING(vSum).
            END.

            WHEN "КодПодр" THEN
            DO:
               vType = "CHAR".
               RUN VALUE("Отдел") IN ht (dob, OUTPUT tt-val.val)    NO-ERROR.
            END.

            WHEN "НаимПодр" THEN
            DO:
               vType = "CHAR".
               RUN VALUE("Отдел") IN ht (dob, OUTPUT tt-val.val)    NO-ERROR.
               IF ERROR-STATUS:ERROR EQ NO THEN
                  tt-val.val = GetObjName("branch", tt-val.val, NO) NO-ERROR.
            END.
            WHEN "МОЛ" THEN
            DO:
               vType = "INT".
               RUN VALUE("МатОтвет") IN ht (dob, OUTPUT vQty)       NO-ERROR.
               IF ERROR-STATUS:ERROR EQ NO THEN
                  tt-val.val = STRING(vQty) NO-ERROR.
            END.

            WHEN "Место" THEN
            DO:
               ASSIGN
                  vType      = "CHAR"
                  vStrTmp    = GetXAttrValueEx("loan",
                                               loan.contract + ","
                                             + loan.cont-code,
                                               "Место",
                                               "")
                  tt-val.val = IF vStrTmp EQ ""
                               THEN "НЕ ОПРЕДЕЛЕНО"
                               ELSE GetCodeName("Место", vStrTmp)
               .
            END.

            WHEN "МОЛФИО" THEN
            DO:
               vType = "CHAR".
               RUN VALUE("МатОтвет") IN ht (dob, OUTPUT vQty)       NO-ERROR.
               IF ERROR-STATUS:ERROR EQ NO THEN
                  tt-val.val = GetObjName("employee",
                                          shFilial + "," + STRING(vQty),
                                          NO)                       NO-ERROR.
            END.

            WHEN "СОТР" THEN
            DO:
               ASSIGN
                  vType   = "CHAR"
                  vStrTmp = GetLast-Kau(loan.contract,
                                        loan.cont-code,
                                        GetSysConf("in-dt:RoleSfx"),
                                        dob
                                       )
               .

               IF vStrTmp NE ?
               THEN DO:
                  vStrTmp2 = ENTRY(2,GetKauItem("МОЛ",
                                                vStrTmp,
                                                "УМЦ-учет"
                                               )
                                  ).
                  IF vStrTmp2 NE "?" THEN
                     ASSIGN
                        tt-val.val = GetObjName("employee",
                                                shFilial + "," + vStrTmp2, NO)
                     .
               END.
            END.

            WHEN "Зол"  THEN
                 tt-val.val = STRING(asset.precious-1).
            WHEN "Сер" THEN
                 tt-val.val = STRING(asset.precious-2).
            WHEN "Плат" THEN
                 tt-val.val = STRING(asset.precious-3).
            WHEN "Проч"  THEN
                 tt-val.val = STRING(asset.precious-4).

            WHEN "СуммаАмор" THEN
            DO:
               ASSIGN
                  vType = "DECIMAL"
                  vDate = GoMonth(FirstMonDate(dob), 1)
                  vSum  = 0
               .
               RUN VALUE("СуммаАмор") IN ht (vDate, OUTPUT vSum) NO-ERROR.

               IF    ERROR-STATUS:ERROR
                  OR vSum      EQ 0 THEN
               DO:
                  RUN GetYearAmortNorm IN h_umc (       loan.contract,
                                                        loan.cont-code,
                                                        vDate,
                                                        "Б",
                                                 OUTPUT vSum
                                                ).
                  vSum = ROUND(GetCostUMC(loan.contract + CHR(6)
                                        + loan.cont-code,
                                          dob,
                                          "",
                                          ""
                                         ) * vSum / 1200, 2).

               END.
               tt-val.val = STRING(vSum).
            END.

            WHEN "НЗавод-Цен" THEN
               ASSIGN
                  tt-val.val = GetXAttrValueEx("loan",
                                               loan.contract + ","
                                             + loan.cont-code,
                                               "НомерЗавод",
                                               loan.cont-type
                                              )
                  vType      = GetXAttrEx     (loan.class-code,
                                               vCode,
                                               "Data-Type"
                                              ).

            /* Всё остальное */
            OTHERWISE
            DO:
               ASSIGN
                  vFun  = ENTRY(1, vCode, "-")
                  vCod2 = ""
               .
               /* Действующий на дату счет, привязанный по роли
               ** Например, Сч-Учет - счет учета.
               */
               IF vFun EQ "Сч" THEN
               FOR LAST loan-acct OF loan WHERE
                        loan-acct.acct-type  EQ loan.contract + SUBSTR(vCode, 3)
                    AND loan-acct.since      LE dob
                  NO-LOCK:
                  tt-val.val  = DelFilFromAcct(loan-acct.acct).
               END.
               /* Расчет показателя по карточке
               ** {Функция}{К|С}-{Суффикс роли}[НМ|НГ]-{Доп. модификаторЫ}, где:
               ** Функция:
               ** ПС - первоначальная стоимость
               ** ОК - остаток по карточке
               ** ОС - остаточная стоимость
               ** ДО - дебетовые обороты
               ** КО - кредитовые обороты
               **
               ** Уточнение функции:
               ** К  - количество
               ** С  - сумма
               **
               ** Суффикс роли: учет, амор, пере,..
               **
               ** Доп. модификаторы
               ** Ф  - фактическое значение. Доп. реквизит "Отсутствует"
               ** П  - преобразовать цифры в слова. Используется в a-rl(ln).def
               **
               ** Модификатор даты:
               ** НМ - на начало месяца отчетной даты
               ** НГ - на начало года отчетной даты
               ** НН - на начало начал (дату первой проводки)
               */
               ELSE IF CAN-DO("ОС.,ОК.,ДО.,КО.", vFun) AND
                    vCode NE "Кол-во" THEN
               DO:
                  /* Суффикс роли по-умолчанию "-учет" */
                  vCod = IF vCode EQ vFun
                         THEN "-учет"
                         ELSE SUBSTR(vCode, LENGTH(vFun) + 2).

                  /* Сохраняем Доп. модификатор */
                  IF vCod MATCHES "*-Ф*" THEN
                     ASSIGN
                        vCod2 = vCod
                        vCod  = SUBSTR(vCod, 1, LENGTH(vCod) - 2)
                     .
                  IF      vCod MATCHES "*НМ" THEN
                     ASSIGN
                        vDate = DATE(MONTH(dob), 1, YEAR(dob))
                        vCod  = SUBSTR(vCod, 1, LENGTH(vCod) - 2).
                  ELSE IF vCod MATCHES "*НГ" THEN
                     ASSIGN
                        vDate = DATE(1, 1, YEAR(dob))
                        vCod  = SUBSTR(vCod, 1, LENGTH(vCod) - 2).
                  ELSE IF vCod MATCHES "*НП" THEN
                     ASSIGN
                        vDate = beg
                        vCod  = SUBSTR(vCod, 1, LENGTH(vCod) - 2).
                  ELSE IF vCod MATCHES "*НН" THEN
                     ASSIGN
                        vDate = 01/01/0001
                        vCod  = SUBSTR(vCod, 1, LENGTH(vCod) - 2).
                  ELSE IF vCod MATCHES "*КК" THEN
                     ASSIGN
                        vDate = ?
                        vCod  = SUBSTR(vCod, 1, LENGTH(vCod) - 2).
                  ELSE
                     ASSIGN
                        vDate = dob.

                  CASE SUBSTR(vFun, 1, 2):
                     WHEN "ОК" THEN
                       RUN VALUE("GetLoanPos" + (IF vDate = ? THEN "-" ELSE ""))
                                      (       loan.contract,
                                              loan.cont-code,
                                              vCod,
                                              vDate,
                                       OUTPUT vSum,
                                       OUTPUT vQty
                                      ).
                     WHEN "ОС" THEN DO:
                       RUN VALUE("GetLoanPos" + (IF vDate = ? THEN "-" ELSE ""))
                                      (       loan.contract,
                                              loan.cont-code,
                                              "-учет",
                                              vDate,
                                       OUTPUT vSum,
                                       OUTPUT vQty
                                      ).
                       RUN VALUE("GetLoanPos" + (IF vDate = ? THEN "-" ELSE ""))
                                      (       loan.contract,
                                              loan.cont-code,
                                              "-амор",
                                              vDate,
                                       OUTPUT vSum2,
                                       OUTPUT vQty2
                                      ).
                       vSum = vSum - vSum2.
                     END.
                     WHEN "ДО" OR
                     WHEN "КО" THEN
                        RUN GetLoanTurn(       loan.contract,
                                               loan.cont-code,
                                               vCod,
                                               "",
                                               beg,
                                               vDate,
                                               (vFun BEGINS "Д"),
                                        OUTPUT vSum,
                                        OUTPUT vQty
                                       ).
                  END CASE.

                  IF     vCod2                     MATCHES "*-Ф*"
                     AND GetSysConf("in-dt:absen") EQ      "YES"
                     AND CAN-DO("Да, Yes, True",
                                GetXattrValueEx("Loan",
                                Work-Module + ","
                              + Loan.Cont-Code,
                                "Отсутствует",
                                ""             )
                               ) THEN
                     ASSIGN
                        vQty = 0
                        vSum = 0
                     .

                  IF SUBSTR(vFun, 3, 1) EQ "К" THEN
                     ASSIGN
                        vType      = "INT"
                        tt-val.val = STRING(vQty).
                  ELSE
                     ASSIGN
                        vType      = "DECIMAL"
                        tt-val.val = STRING(vSum).
               END.

               ELSE IF CAN-DO("СОДВыб,ДДВыб,НДВыб",vCode) THEN
                  FOR EACH  kau-entry            WHERE
                            kau-entry.kau-id        EQ "УМЦ-учет"
                        AND kau-entry.kau           BEGINS loan.contract + "," +
                                                           loan.cont-code + ","
                        AND kau-entry.op-date       LE dob
                        AND kau-entry.debit         EQ NO
                     NO-LOCK,
                     FIRST op-entry OF kau-entry WHERE
                           op-entry.acct-cr         EQ     kau-entry.acct
                       AND op-entry.acct-db         BEGINS "612"
                        NO-LOCK,
                     FIRST op OF op-entry
                        NO-LOCK
                     BY kau-entry.op-date DESC
                     BY kau-entry.op      DESC:

                     ASSIGN
                        vType      = "CHAR"
                        vType      = "DATE" WHEN vCode EQ "ДДВыб"
                     .
                     CASE vCode:
                        WHEN "СОДВыб" THEN
                           RUN GetDocTypeName IN h_op
                              (
                                 INPUT op.doc-type
                              , OUTPUT tt-val.val
                              ) .
                        WHEN "ДДВыб"  THEN
                           tt-val.val = STRING(op-entry.op-date,"99/99/9999").
                        WHEN "НДВыб"  THEN
                           tt-val.val = ", " + op.doc-num.
                     END CASE.
                     LEAVE.
                  END.
               ELSE IF CAN-DO("СОДВПер,ДДВПер,НДВПер",vCode) THEN
                  FOR EACH  kau-entry      WHERE
                            kau-entry.kau-id  EQ "УМЦ-учет"
                        AND kau-entry.kau     BEGINS loan.contract + "," +
                                                     loan.cont-code + ","
                        AND kau-entry.op-date LE dob
                        AND     CAN-FIND (FIRST op       OF kau-entry NO-LOCK)
                        AND NOT CAN-FIND (FIRST op-entry OF kau-entry NO-LOCK)
                        NO-LOCK,
                     FIRST op OF kau-entry
                        NO-LOCK
                     BY kau-entry.op-date DESC
                     BY kau-entry.op      DESC:

                     ASSIGN
                        vType      = "CHAR"
                        vType      = "DATE" WHEN vCode EQ "ДДВПер"
                     .
                     CASE vCode:
                        WHEN "СОДВПер" THEN
                           RUN GetDocTypeName IN h_op
                              (
                                 INPUT op.doc-type
                              , OUTPUT tt-val.val
                              ) .
                        WHEN "ДДВПер"  THEN
                           tt-val.val = STRING(kau-entry.op-date,"99/99/9999").
                        WHEN "НДВПер"  THEN
                           tt-val.val = ", " + op.doc-num.
                     END CASE.
                     LEAVE.
                  END.
               /* Код доп.реквизита карточки:
               **    СрокЭкспл, НДС
               ** или ценности:
               **    ГрМФСО
               ** или показатель по первой дебетовой субпроводке
               */
               ELSE
               DO:
                  ASSIGN
                     tt-val.val = GetXAttrValueEx("loan",
                                                  loan.contract + ","
                                                + loan.cont-code,
                                                  vCode,
                                                  "?"
                                                 )
                     vType      = GetXAttrEx     (loan.class-code,
                                                  vCode,
                                                  "Data-Type"
                                                 ).

                  IF tt-val.val EQ "?" THEN
                     ASSIGN
                        tt-val.val = GetXAttrValueEx("asset",
                                                     loan.cont-type,
                                                     vCode,
                                                     "?"
                                                    )
                        vType      = GetXAttrEx     ("asset",
                                                     vCode,
                                                     "Data-Type"
                                                    ).

                  IF NOT CAN-DO("INTEGER,DECIMAL", vType) THEN
                     vType = "CHAR".

                  /* Расчёт показателя по первой дебетовой субпроводке */
                  IF tt-val.val EQ "?" THEN
                  DO:
                     IF mKEType EQ "спис" THEN
                     FOR EACH  kau-entry      WHERE
                               kau-entry.kau-id  EQ     "УМЦ-учет"
                           AND kau-entry.kau     BEGINS loan.contract + "," +
                                                        loan.cont-code + ","
                           AND kau-entry.debit   EQ     NO
                           AND kau-entry.op-date LE     dob
                        NO-LOCK
                        BY kau-entry.kau-id
                        BY kau-entry.op-date DESCENDING
                        BY kau-entry.op      DESCENDING:

                        RUN CalcKE IN hLn (RECID(kau-entry),
                                           iLevel + 1,
                                           tt-val.code
                                          ).
                        LEAVE.
                     END.
                     ELSE
                     FOR EACH  kau-entry      WHERE
                               kau-entry.kau-id  EQ "УМЦ-учет"
                           AND kau-entry.kau     BEGINS loan.contract + "," +
                                                        loan.cont-code + ","
                           AND kau-entry.debit   EQ YES
                           AND kau-entry.op-date LE dob
                        NO-LOCK
                        BY kau-entry.kau-id
                        BY kau-entry.op-date
                        BY kau-entry.op:

                        RUN CalcKE IN hLn (RECID(kau-entry),
                                           iLevel + 1,
                                           tt-val.code
                                          ).
                        LEAVE.
                     END.
                  END.
               END.
            END.
         END CASE.

         /* Пустые, неопределённые, неудачно вычисленные показатели удаляем */
         IF    tt-val.val EQ ""
            OR tt-val.val EQ "?"
            OR tt-val.val EQ ? THEN
            DELETE tt-val.
         ELSE
         DO:
            tt-val.type = vType.
            RELEASE tt-val.
         END.

         IF tt-prm.class EQ "" THEN
            ASSIGN
               tt-prm.class  = "loan"
               tt-prm.level  = iLevel.
      END.
   END.

   RETURN.

END PROCEDURE.

/* Расчёт показателей по субпроводке карточки УМЦ */
PROCEDURE CalcKE:
   DEF INPUT PARAMETER iKERecId   AS RECID   NO-UNDO.
   DEF INPUT PARAMETER iLevel     AS INT     NO-UNDO.
   DEF INPUT PARAMETER iPrmLst    AS CHAR    NO-UNDO.

   DEF BUFFER acct        FOR acct.
   DEF BUFFER loan        FOR loan.
   DEF BUFFER xloan       FOR loan.
   DEF BUFFER kau-entry   FOR kau-entry.
   DEF BUFFER op-entry    FOR op-entry.
   DEF BUFFER tt-val      FOR tt-val.

   DEF BUFFER op          FOR op.
   DEF BUFFER xop         FOR op.
   DEF BUFFER xkau-entry  FOR kau-entry.
   DEF BUFFER xloan-acct  FOR loan-acct.

   /* Номер показателя в списке */
   DEF VAR vI                     AS INT     NO-UNDO.
   /* Число для расчета показателя */
   DEF VAR vITmp                  AS INT     NO-UNDO.
   /* Дата для расчета показателя */
   DEF VAR vDate                  AS DATE    NO-UNDO.
   /* Код функции */
   DEF VAR vFun                   AS CHAR    NO-UNDO.
   /* Код */
   DEF VAR vCod                   AS CHAR    NO-UNDO.
   /* Количество */
   DEF VAR vQty                   AS DECIMAL NO-UNDO.
   /* Сумма */
   DEF VAR vSum                   AS DECIMAL NO-UNDO.
   DEF VAR vSum2                  AS DECIMAL NO-UNDO.
   /* Тип данных */
   DEF VAR vType                  AS CHAR    NO-UNDO.
   /* Тип субпроводки */
   DEF VAR vKEType                AS CHAR    NO-UNDO.
   /* Код показателя для расчета */
   DEF VAR vCode                  AS CHAR    NO-UNDO.
   /* Участвует в вычислении амортизации */
   DEF VAR vOp                    AS INT     NO-UNDO.

   FIND FIRST kau-entry WHERE RECID(kau-entry) EQ iKERecId
      NO-LOCK NO-ERROR.

   IF NOT AVAILABLE kau-entry THEN
      RETURN.

   vOp = kau-entry.op.

   FIND FIRST loan        WHERE
              loan.contract  EQ ENTRY(1, kau-entry.kau)
          AND loan.cont-code EQ ENTRY(2, kau-entry.kau)
      NO-LOCK NO-ERROR.

   IF NOT AVAILABLE loan THEN
      RETURN.
   FIND FIRST asset OF loan NO-LOCK NO-ERROR.

   vKEType = GetKEType(BUFFER kau-entry).

   /* Перебор показателей, которые необходимо рассчитать */
   DO vI = 1 TO NUM-ENTRIES(iPrmLst):

      FIND FIRST tt-prm   WHERE
                 tt-prm.code EQ ENTRY(vI, iPrmLst)
         NO-LOCK NO-ERROR.

      IF NOT AVAILABLE tt-prm THEN
         NEXT.

      CREATE tt-val.
      ASSIGN tt-val.code      = tt-prm.code
             tt-val.surrogate =      STRING(kau-entry.op)
                              + ","+ STRING(kau-entry.op-entry)
                              + ","+ STRING(kau-entry.kau-entry)
             tt-val.level     = iLevel.

     ASSIGN
        vCode = TRIM(tt-val.code, "#")
        vType = "CHAR".

      CASE vCode:
         WHEN "№" THEN
            ASSIGN
               vType      = "INT"
               mCntLin    = mCntLin + 1
               tt-val.val = STRING(mCntLin).

         WHEN "Тип"   THEN
             tt-val.val  = vKEType.

         WHEN "Инв№"     THEN
             tt-val.val  = loan.doc-ref.
         WHEN "Инв№ДоПер" THEN DO:
             FOR FIRST xop WHERE
                       xop.op EQ vOp
             NO-LOCK:
                tt-val.val  = GetInvNumSrc(RECID(xop)).
             END.
         END.
         WHEN "НаимЦенн" THEN
             tt-val.val  = GetObjName("asset", GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)), YES).
         WHEN "ФкСрокЭкспл" THEN
            ASSIGN
               vDate = GetInDate (loan.contract,
                                  loan.cont-code,
                                  "Б"
                                 )
               vITmp = INT(GetXattrValue("loan",
                                       loan.contract + "," + loan.cont-code,
                                       "СрокЭкспл"
                                      )
                        )
               vITmp = vITmp + IF    vDate EQ 01/01/0001
                                  OR vDate EQ 01/01/9999 THEN
                                  0
                               ELSE
                                  INT(MonInPer(vDate,kau-entry.op-date))
               tt-val.val = IF vITmp EQ ? OR vITmp EQ 0 THEN ""
                            ELSE STRING(vITmp)
            .
         WHEN "ДатаПрих" THEN
            ASSIGN
               tt-val.val  = STRING(GetInDate (loan.contract,
                                               loan.cont-code,
                                               "Б"
                                              ),
                                    "99.99.9999"
                                   ).

         WHEN "МаркаС" THEN DO:
            tt-val.val = GetXattrValue("loan",
                                       loan.contract + "," + loan.cont-code,
                                       "Марка"
                                      ).

            {additem2.i
            tt-val.val
            "GetXattrValue('loan',loan.contract + ',' + loan.cont-code,'Сорт')" ", "
            }
            ASSIGN tt-val.val = TRIM(tt-val.val)
                   tt-val.val = TRIM(tt-val.val,",")
            .
         END.
         WHEN "ЕдИзм"    THEN
             tt-val.val  = asset.unit.
         WHEN "ЦенаМЦ"    THEN
            ASSIGN
               vType      = "DECIMAL"
               tt-val.val = STRING(GetCostUMC(loan.contract + CHR(6)
                                            + loan.cont-code,
                                              dob,
                                              "",
                                              ""
                                             )
                                  ).

         WHEN "Зол"  THEN
              tt-val.val = STRING(asset.precious-1).
         WHEN "Сер" THEN
              tt-val.val = STRING(asset.precious-2).
         WHEN "Плат" THEN
              tt-val.val = STRING(asset.precious-3).
         WHEN "Проч"  THEN
              tt-val.val = STRING(asset.precious-4).
         WHEN "НаимДоп" THEN
         DO:
            IF vKEType EQ "пере" THEN
               tt-val.val  = "(переоценка)".
            ELSE IF vKEType EQ "прих" THEN
            FOR FIRST op-entry OF kau-entry
               NO-LOCK:
               IF op-entry.acct-cr BEGINS "701" THEN
                  tt-val.val  = "(получено безвозмездно)".
            END.
            tt-val.val = GetObjName("asset", loan.cont-type, YES) + tt-val.val.
         END.

         WHEN "Дата" THEN
            tt-val.val  = STRING(kau-entry.op-date, "99.99.9999").

         WHEN "Кол-во" THEN
            ASSIGN
               vType      = "DECIMAL"
               tt-val.val = STRING(kau-entry.qty).
         WHEN "Сумма"  THEN

         DO:
/*
            ASSIGN
               vType      = "DECIMAL"
               vSum       = (IF kau-entry.debit
                             THEN   kau-entry.amt-rub
                             ELSE - kau-entry.amt-rub
                            ).
            FOR FIRST acct WHERE
                      acct.acct     = kau-entry.acct
                 AND  acct.currency = kau-entry.currency
                 AND  acct.side     = "П"
               NO-LOCK:
               vSum = - vSum.
            END.
*/
            ASSIGN
               vType      = "DECIMAL"
               vSum       = ABS(kau-entry.amt-rub)
               tt-val.val = STRING(vSum)
            .
         END.

         WHEN "СуммаЕд"  THEN

         DO:
            ASSIGN
               vType      = "DECIMAL"
               vSum       = ABS(kau-entry.amt-rub / kau-entry.qty)
               tt-val.val = STRING(vSum)
            .
         END.
         WHEN "Амор"
         THEN DO:

            FIND FIRST xop WHERE xop.op EQ vOp NO-LOCK NO-ERROR.

            IF AVAIL xop THEN
               FOR
                  EACH  op                WHERE
                        op.op-trans          EQ xop.op-trans
                        NO-LOCK ,
                  LAST  xloan-acct        WHERE
                        xloan-acct.contract  EQ loan.contract
                    AND xloan-acct.cont-code EQ loan.cont-code
                    AND xloan-acct.acct-type EQ loan.contract + "-амор"
                    AND xloan-acct.since     LE op.op-date
                        NO-LOCK,

                   EACH xkau-entry OF op  WHERE
                        xkau-entry.acct      EQ xloan-acct.acct
                    AND xkau-entry.currency  EQ xloan-acct.currency
                        NO-LOCK
                  :

                  vSum2 = vSum2 + (IF xkau-entry.debit
                                   THEN
                                      xkau-entry.amt-rub
                                   ELSE
                                      (- xkau-entry.amt-rub)
                                  ).

               END.

            ASSIGN
               vType      = "DECIMAL"
               tt-val.val = STRING(vSum2)
            .

         END.

         WHEN "Ост"
         THEN DO:
            ASSIGN
               vType      = "DECIMAL"
               vSum       = vSum - vSum2
               tt-val.val = STRING(vSum)
            .

         END.

         WHEN "КфПер" THEN
         DO:
            vType = "DECIMAL".

            FIND FIRST asset OF loan NO-LOCK NO-ERROR.

            FIND FIRST instr-rate                        WHERE
                       instr-rate.instr-cat                 EQ "overcode"
                   AND ENTRY(1, instr-rate.instr-code, "/") EQ asset.commission
                   AND instr-rate.since                     GE loan.open-date
               NO-LOCK NO-ERROR.

            IF     AVAIL instr-rate
               AND NUM-ENTRIES(instr-rate.instr-code, "/") GT 1
               AND NOT CAN-DO(ENTRY(2, instr-rate.instr-code, "/"),
                              STRING(kau-entry.op)) THEN
               RELEASE instr-rate.

            IF NOT AVAIL instr-rate THEN
            FOR EACH instr-rate        WHERE
                     instr-rate.instr-cat EQ "overcode"
                 AND instr-rate.since     GE loan.open-date
               NO-LOCK:

               IF NUM-ENTRIES(instr-rate.instr-code, "/") GT 1 THEN

                  IF CAN-DO(ENTRY(1, instr-rate.instr-code, "/"),
                            asset.commission
                           ) AND
                     CAN-DO(ENTRY(2, instr-rate.instr-code, "/"),
                            STRING(kau-entry.op)
                           ) THEN
                     tt-val.val = STRING(instr-rate.rate-instr) .
            END.

            IF AVAILABLE instr-rate THEN
               tt-val.val = STRING(instr-rate.rate-instr) .
         END.

         WHEN "ВосстСтоим" THEN
         DO:
            vType = "DECIMAL".
            RUN VALUE("ВосстСтоим") IN ht (kau-entry.op-date, OUTPUT vSum) NO-ERROR.
            tt-val.val = STRING(vSum).
         END.
         WHEN "ВосстСтоим2" THEN
         DO:
            vType = "DECIMAL".
            RUN VALUE("ВосстСтоим") IN ht (DATE(GetEntries(       1,
                                                                  pick-value,
                                                                  "-",
                                                                  STRING(vDate))),
                                                           OUTPUT vSum) NO-ERROR.
            tt-val.val = STRING(vSum).
         END.

         WHEN "НЗавод-Цен" THEN
            ASSIGN
               tt-val.val = GetXAttrValueEx("loan",
                                            loan.contract + ","
                                          + loan.cont-code,
                                            "НомерЗавод",
                                            loan.cont-type
                                           )
               vType      = GetXAttrEx     (loan.class-code,
                                            vCode,
                                            "Data-Type"
                                           ).

         /* Всё остальное */
         OTHERWISE
         DO:
            vFun = ENTRY(1, vCode, "-").

            /* Расчет показателя по карточке
            ** {Функция}{К|С}-{Суффикс роли}[НМ|НГ] , где:
            ** Функция:
            ** ПС - первоначальная стоимость
            ** ОК - остаток по карточке
            ** ОС - остаточная стоимость
            ** ДО - дебетовые обороты
            ** КО - кредитовые обороты
            **
            ** Уточнение функции:
            ** К  - количество
            ** С  - сумма
            **
            ** Суффикс роли: учет, амор, пере,..
            **
            ** Модификатор даты:
            ** ДО - на дату опердня субпроводки
            */
            IF     CAN-DO("ОК.,ДО.,КО.", vFun)
               AND vKEType NE "пере"
               AND vCode   NE "Кол-во" THEN
            DO:
               vCod = SUBSTR(vCode, LENGTH(vFun) + 2).

               ASSIGN
                  vDate = kau-entry.op-date
                  vCod  = SUBSTR(vCod, 1, LENGTH(vCod) - 2).

               CASE SUBSTR(vFun, 1, 2):
                  WHEN "ОК" THEN
                     RUN GetLoanPos (       loan.contract,
                                            loan.cont-code,
                                            vCod,
                                            vDate,
                                     OUTPUT vSum,
                                     OUTPUT vQty
                                    ).
                  WHEN "ДО" OR
                  WHEN "КО" THEN
                     RUN GetLoanTurn(       loan.contract,
                                            loan.cont-code,
                                            vCod,
                                            "",
                                            beg,
                                            vDate,
                                            (vFun BEGINS "Д"),
                                     OUTPUT vSum,
                                     OUTPUT vQty
                                    ).
 /* Добавлено kuntash для вычисления остаточной стоимости */
                  WHEN "ОС" THEN 
                  		 DO:	
                       RUN GetLoanPos (       loan.contract,
                                            loan.cont-code,
                                            "Учет",
                                            vDate - 1,
                                     OUTPUT vSum,
                                     OUTPUT vQty
                                    ).
 
                      RUN GetLoanPos (       loan.contract,
                                            loan.cont-code,
                                            "Амор",
                                            vDate - 1,
                                     OUTPUT vSum2,
                                     OUTPUT vQty
                                    ).
                   		 vSum = vSum - vSum2.             
                       END.         
/* ---------------------------------------------------- */ 
               END CASE.

               IF SUBSTR(vFun, 3, 1) EQ "К" THEN
                  ASSIGN
                     vType      = "INT"
                     tt-val.val = STRING(vQty).
               ELSE
                  ASSIGN
                     vType      = "DECIMAL"
                     tt-val.val = STRING(vSum).
            END.
            ELSE DO:
               ASSIGN
                  tt-val.val = GetXAttrValueEx("loan",
                                               loan.contract + ","
                                             + loan.cont-code,
                                               vCode,
                                               "?"
                                              )
                  vType      = GetXAttrEx     (loan.class-code,
                                               vCode,
                                               "Data-Type"
                                              ).

               IF tt-val.val EQ "?" THEN
                  ASSIGN
                     tt-val.val = GetXAttrValueEx("asset",
                                                  loan.cont-type,
                                                  vCode,
                                                  "?"
                                                 )
                     vType      = GetXAttrEx     ("asset",
                                                  vCode,
                                                  "Data-Type"
                                                 ).

               IF NOT CAN-DO("INTEGER,DECIMAL", vType) THEN
                  vType = "CHAR".
            END.
         END.
      END CASE.

      /* Несуществующие, неопределённые, неудачно вычисленные показатели удаляем */
      IF    tt-val.val EQ ""
         OR tt-val.val EQ "?"
         OR tt-val.val EQ ? THEN
         DELETE tt-val.
      ELSE
      DO:
         tt-val.type = vType.
         RELEASE tt-val.
      END.

      IF tt-prm.class EQ "" THEN
         ASSIGN
            tt-prm.class  = "kau-entry"
            tt-prm.level  = iLevel.
   END.

   RETURN.

END PROCEDURE.
