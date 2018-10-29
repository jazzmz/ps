/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1998 ТОО "Банковские информационные системы"
     Filename: a-os.p
      Comment: Функции для использования в шаблоне по основным средствам
   Parameters:
         Uses:
      Used by:
      Created: kraw 03/09/2003 (0014563)
     Modified:
*/

/*
Реализованы парсерные функции:

СтруктПодр   - наименование структурного подразделения
ОКПО         - код ОКПО структурного подразделения
НомДокI      - Номер документа (запрашивается у пользователя интерактивно)
ДатДокI      - Дата документа (запрашивается у пользователя интерактивно)
ОКОФ         - ОКОФ ценности
АмрГ         - Амортизационная группа ценности
НПас         - Номер паспорта карточки
НЗвд         - Номер заводской
Мест         - Местонахождение
Изгт         - Имя изготовителя
ДВып         - Дата выпуска
ДПрн         - Дата принятия к бухучету
ДВыб         - Дата списания с бухучета
СкЭи         - Фактический срок эксплуатации
Инв          - Дата выпуска
ИмяЦенности  - Наименование ценности
Счет         - Счет учета
ДПрх         - Дата прихода
НПрх         - Номер документа прихода
Au           - Количество золота
Ag           - Количество серебра
Pt           - Количество платины
Ot           - Количество остальных драгметаллов
ОстСт        - остаточная стоимость
САморт       - Сумма амортизации
ПСт          - первоначальная стоимость
ПСтН         - Первоначальная стоимость налоговая
СПИБ         - Срок полезного использования бухгалтерский
СПИН         - Срок полезного использования налоговый
ТаблОпПереоц - Таблица операций переоценки
ТаблОпУчет   - Таблица операций перемещений и пр.
ТаблОпИзмСт  - Таблица опереций изменения стоимости

---------------------ТаблицЫ для налоговых операций ---------------------
ТаблОпНалУчет           - Таблица операций перемещений и пр.
ТаблОпНалИзмСт_ОпНалРем - Таблица операций изменения стоимости
                          и операций затрат на ремонт
*/

{globals.i}
{norm.i}
{wordwrap.def}
{intrface.get umc}
{intrface.get date}

DEFINE OUTPUT PARAM  oXresult AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAM  iXdate1  AS DATE      NO-UNDO.
DEFINE INPUT  PARAM  iXdate   AS DATE      NO-UNDO.
DEFINE INPUT  PARAM  iStrpar  AS CHARACTER NO-UNDO.

{a-os.def}

DEFINE VARIABLE mCommand AS CHARACTER NO-UNDO.
DEFINE VARIABLE mMod     AS CHARACTER NO-UNDO.
DEFINE VARIABLE mTmpChr  AS CHARACTER NO-UNDO.
DEFINE VARIABLE mTmpDate AS DATE      NO-UNDO.
DEFINE VARIABLE mCnt     AS INTEGER   NO-UNDO.
DEFINE VARIABLE mCnt2    AS INTEGER   NO-UNDO.

DEFINE VARIABLE mAmt LIKE kau-entry.amt-rub NO-UNDO.
DEFINE VARIABLE mQty LIKE kau-entry.Qty     NO-UNDO.

printres = NO.
mCommand = ENTRY(1,iStrpar).

IF NUM-ENTRIES(iStrpar) > 1 THEN
   mMod = ENTRY(2,iStrpar).

CASE mCommand:

/*
СтруктПодр - наименование структурного подразделения
*/
   WHEN "СтруктПодр" THEN
      DO:
         printtext = "".
         mTmpChr = FGetSetting("КодФил",?,?).
         FOR FIRST branch WHERE
            branch.branch-id EQ mTmpChr
            NO-LOCK :

            printtext = STRING(branch.name,"x(68)").

         END.
      END.

/*
ОКПО - код ОКПО структурного подразделения
*/
   WHEN "ОКПО" THEN
      DO:
         printtext = "           ".
         mTmpChr = FGetSetting("КодФил",?,?).
         FOR FIRST branch WHERE
            branch.branch-id EQ mTmpChr
            NO-LOCK :

            printtext = STRING(GetXAttrValueEx("branch",branch.branch-id,"ОКПО",""),"x(11)").

         END.
      END.

/*
НомДокI - Номер документа (запрашивается у пользователя интерактивно)
*/
   WHEN "НомДокI" THEN
      printtext = STRING(sDocNum,"x(11)").

/*
ДатДокI - Дата документа (запрашивается у пользователя интерактивно)
*/
   WHEN "ДатДокI" THEN
      printtext = STRING(sDocDate,"99/99/9999").

/*
ОКОФ - ОКОФ ценности
*/
   WHEN "ОКОФ" THEN
      printtext = STRING(sOKOF, "x(11)").

/*
АмрГ - Амортизационная группа ценности
*/
   WHEN "АмрГ" THEN
      printtext = STRING(sAmrGr, "x(11)").

/*
НПас - Номер паспорта карточки
*/
   WHEN "НПас" THEN
      printtext = STRING(sNPasswd, "x(11)").

/*
НЗвд - Номер заводской
*/
   WHEN "НЗвд" THEN
      printtext = STRING(sNPlant, "x(22)").

/*
Мест - Местонахождение
*/
   WHEN "Мест" THEN
      printtext = STRING(sPlace, "x(53)").

/*
Изгт - Имя изготовителя
*/
   WHEN "Изгт" THEN
      printtext = STRING(sProdus, "x(64)").

/*
ДВып - Дата выпуска
*/
   WHEN "ДВып" THEN
      printtext = STRING(sDatePr, "x(10)").

/*
ДПрн - Дата принятия к бухучету
*/
   WHEN "ДПрн" THEN
      printtext = IF sDatInBuhg EQ ? THEN "          "
                                     ELSE STRING(sDatInBuhg, "99/99/9999").

/*
ДВыб - Дата списания с бухучета
*/
   WHEN "ДВыб" THEN
      printtext = IF sDatOutBuhg EQ ? THEN "          "
                                      ELSE STRING(sDatOutBuhg, "99/99/9999").

/*
СкЭи - Фактический срок эксплуатации
*/
   WHEN "СкЭи" THEN

      printtext = STRING(DECIMAL(sExpl), ">>>>>>>>9").

/*
Инв - Дата выпуска
*/
   WHEN "Инв" THEN
      printtext = STRING(sCont-Code, "x(22)").

/*
ИмяЦенности - Наименование ценности
*/
   WHEN "ИмяЦенности" THEN
      DO:
         IF INTEGER(mMod) = 1 THEN
         DO:
            {wordwrap.i &s=sNameAsset &n=2 &l=33}
            printtext = STRING(sNameAsset[1],"x(33)").
         END.
         ELSE
            printtext = STRING(sNameAsset[2],"x(33)").

      END.

/*
Счет - Счет учета
*/
   WHEN "Счет" THEN
      printtext = STRING(sAcct, "x(20)").

/*
ДПрх - Дата прихода
*/
   WHEN "ДПрх" THEN
      printtext = IF sDatInExpl EQ ? THEN "          "
                                     ELSE STRING(sDatInExpl, "99/99/9999").

/*
НПрх - Номер документа прихода
*/
   WHEN "НПрх" THEN
      printtext = STRING(sDocNumIn, "x(8)").

/*
Au - Количество золота
*/
   WHEN "Au" THEN
      printtext = STRING(sAu, ">>9.9999").

/*
Ag - Количество серебра
*/
   WHEN "Ag" THEN
      printtext = STRING(sAg, ">>9.9999").

/*
Pt - Количество платины
*/
   WHEN "Pt" THEN
      printtext = STRING(sPt, ">>9.9999").

/*
Ot - Количество остальных драгметаллов
*/
   WHEN "Ot" THEN
      printtext = STRING(sOt, ">>9.9999").

/*
ОстСт - остаточная стоимость
*/

   WHEN "ОстСт" THEN
      DO:
         IF sDatOutBuhg EQ ? THEN
         DO:
            IF sDocDate EQ ? THEN
               printtext = "              ".
            ELSE
            DO:
               RUN GetAmtUMC IN h_umc (sContract,
                                       sContCode,
                                       sDocDate,
                                OUTPUT mAmt,
                                OUTPUT mQty).
               printtext = STRING(mAmt,">>>,>>>,>>9.99").
            END.
         END.
         ELSE
         DO:
            RUN GetAmtUMC IN h_umc (sContract,
                                    sContCode,
                                    sDatOutBuhg - 1,
                             OUTPUT mAmt,
                             OUTPUT mQty).
            printtext = STRING(mAmt,">>>,>>>,>>9.99").
         END.
      END.

/*
САморт - Сумма амортизации
*/

   WHEN "САморт" THEN
      DO:
         IF sDatOutBuhg EQ ? THEN
            mTmpDate = sDocDate.
         ELSE
            mTmpDate = sDatOutBuhg - 1.

         IF mTmpDate EQ ? THEN
            printtext = "              ".
         ELSE
         DO:
            printtext = STRING(
                               GetLoan-pos(sContract,
                                           sContCode,
                                           "-амор",
                                           mTmpDate),
                               ">>>,>>>,>>9.99").
         END.
      END.

/*
ПСт - первоначальная стоимость
*/

   WHEN "ПСт" THEN
      DO:
/*         RUN GetAmtUMC IN h_umc (sContract,
                                 sContCode,
                                 sDatInBuhg,
                          OUTPUT mAmt,
                          OUTPUT mQty).*/

         mAmt = GetLoan-pos(sContract,
                            sContCode,
                            "-учет",
                            sDatInExpl) .
         printtext = STRING(mAmt,">>>,>>>,>>9.99").
      END.

/*
ПСтН - Первоначальная стоимость налоговая
*/
   WHEN "ПСтН" THEN
      ASSIGN
         mAmt      = GetLoan-pos(sContract,
                                 sContCode,
                                 "-нал-учет",
                                 sDatInExpl)
         printtext = STRING(mAmt,">>>,>>>,>>9.99")
      .

/*
СПИБ - Срок полезного использования бухгалтерский
СПИН - Срок полезного использования налоговый
*/
   WHEN "СПИБ" OR
   WHEN "СПИН" THEN
      DO:
         sSPIB = GetSrokAmor(sLoanRid, mCommand, sDocDate).

         IF sSPIB NE ? THEN
            printtext = STRING(sSPIB, ">>>>>>>>>>9").
         ELSE
            printtext = "           ".
      END.

/*
ТаблОпПереоц - Таблица операций переоценки
*/

   WHEN "ТаблОпПереоц" THEN
      FOR EACH sAOsPere BY Numb BY ind:
         IF sAOsPere.doc-date NE ? THEN
         DO:
            PUT STREAM fil "│" sAOsPere.doc-date FORMAT "99/99/9999".
            PUT STREAM fil "│" sAOsPere.koef     FORMAT ">>>>>>>9.99".
            PUT STREAM fil "│" sAOsPere.amt      FORMAT ">>>,>>>,>>9.99".
         END.
         ELSE
         DO:
            PUT STREAM fil "│" "          ".
            PUT STREAM fil "│" "           ".
            PUT STREAM fil "│" "              ".
         END.
         PUT STREAM fil "│".
      END.


/*
ТаблОпУчет - Таблица операций перемещений и пр.
*/

   WHEN "ТаблОпУчет" THEN
      FOR EACH sAOsUch WHERE sAOsUch.isPP:
         PUT STREAM fil "│"  sAOsUch.dateN  FORMAT "x(18)".
         PUT STREAM fil "│"  sAOsUch.tran   FORMAT "x(16)".
         PUT STREAM fil "│"  sAOsUch.branch FORMAT "x(27)".
         PUT STREAM fil "│ " sAOsUch.amt    FORMAT ">>>,>>>,>>9.99".
         PUT STREAM fil "│"  sAOsUch.nTab  FORMAT "x(24)".
         PUT STREAM fil "│"  skip.
      END.

/*
ТаблОпИзмСт - Таблица опереций изменения стоимости
*/

   WHEN "ТаблОпИзмСт" THEN
      FOR EACH sAOsUch WHERE NOT sAOsUch.isPP:
         PUT STREAM fil "│"  sAOsUch.tran   FORMAT "x(9)".
         PUT STREAM fil "│         ".
         PUT STREAM fil "│"  sAOsUch.dateN  FORMAT "x(10)".
         PUT STREAM fil "│"  sAOsUch.docNum FORMAT "x(7)".
         PUT STREAM fil "│ " sAOsUch.amt    FORMAT ">>,>>>,>>9.99".
         PUT STREAM fil "│ │         │              │           │       │              │"  skip.
      END.

/* ---------------------ТаблицЫ для налоговых операций --------------------- */

/*
ТаблОпНалУчет - Таблица операций перемещений и пр.
*/
   WHEN "ТаблОпНалУчет" THEN
   DO:
      mTmpChr = "-нал-учет" + "," + "-нал-р10" + "," + "-нал-ликв" + ","
              + "-нал-реал" + "," + "-нал-расх".

      DO mCnt = 1 TO NUM-ENTRIES(mTmpChr):

         FOR EACH sAOsUch  WHERE
                  sAOsUch.sfx EQ ENTRY(mCnt,mTmpChr):
            PUT STREAM fil "│"  sAOsUch.dateN  FORMAT "x(18)".
            PUT STREAM fil "│"  sAOsUch.tran   FORMAT "x(16)".
            PUT STREAM fil "│"  sAOsUch.branch FORMAT "x(27)".
            PUT STREAM fil "│ " sAOsUch.amt    FORMAT ">>>,>>>,>>9.99".
            PUT STREAM fil "│"  sAOsUch.nTab   FORMAT "x(24)".
            PUT STREAM fil "│"  SKIP.
         END.
      END.
   END.

/*
** ТаблОпНалИзмСт_ОпНалРем - Таблица операций изменения стоимости
** и операций затрат на ремонт
*/
   WHEN "ТаблОпНалИзмСт_ОпНалРем" THEN
   DO:
      FOR LAST sAOsUch  WHERE
               sAOsUch.sfx EQ "-нал-изм"
            OR sAOsUch.sfx EQ "-нал-рем":
         mCnt2 = sAOsUch.Numb.
      END.


      DO mCnt = 1 TO mCnt2:

/* ТаблОпНалИзмСт */
         IF CAN-FIND (FIRST sAOsUch  WHERE
                            sAOsUch.sfx EQ "-нал-изм"
                     ) THEN
            FOR FIRST sAOsUch        WHERE
                      sAOsUch.sfx       EQ "-нал-изм":
               PUT STREAM fil "│"  sAOsUch.tran   FORMAT "x(9)".
               PUT STREAM fil "│         ".
               PUT STREAM fil "│"  sAOsUch.dateN  FORMAT "x(10)".
               PUT STREAM fil "│"  sAOsUch.docNum FORMAT "x(7)".
               PUT STREAM fil "│ " sAOsUch.amt    FORMAT ">>,>>>,>>9.99" "│ ".
               DELETE sAOsUch.
            END.
         ELSE
            PUT STREAM fil "│         │         │          │       │              │ ".

/* ТаблОпНалРем */
         IF CAN-FIND (FIRST sAOsUch  WHERE
                            sAOsUch.sfx EQ "-нал-рем"
                     ) THEN
            FOR FIRST sAOsUch        WHERE
                      sAOsUch.sfx       EQ "-нал-рем":
               PUT STREAM fil "│"  sAOsUch.tran   FORMAT "x(9)".
               PUT STREAM fil "│              ".
               PUT STREAM fil "│"  sAOsUch.dateN  FORMAT "x(11)".
               PUT STREAM fil "│"  sAOsUch.docNum FORMAT "x(7)".
               PUT STREAM fil "│ " sAOsUch.amt    FORMAT ">>,>>>,>>9.99" "│" SKIP.
               DELETE sAOsUch.
            END.
         ELSE
            PUT STREAM fil "│         │              │           │       │              │" SKIP.
      END.
   END.
END.