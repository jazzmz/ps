/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2007 ЗАО "Банковские информационные системы"
     Filename: f155_2_3_print.p
      Comment: Форма 155. Разделы 2,3. Визуализация печатной формы.
   Parameters:
         Uses:
      Used by:
      Created: 15.01.2008 20:55 TSL
     Modified: 31.01.2008 18:24 TSL      88726
     Modified: 20.02.08 ler 88726 - ф.155. выгрузка в клико новый формат с 01.01.2008.
     Modified: 22.09.08 ler 96575 - Ф.155. Экспорт в ПТК ПСД (01.08.08)
     Modified: 01.12.08 ler 101272 - ф.155. Обновление формата по F155_08.ARJ с 01.11.2008.
     Modified: 26.04.12 ler 0166365 - ф.155. Экспорт в программу KLIKO 2742-У 01.01.12
     Modified: 10.05.12 ler 0171679 - ф.155.
     Modified: 24.08.12 ler 0177895 - ф.155. Экспорт в программу KLIKO 2835-У на 01.08.12 (F155_11.PAK)
     Modified: 23.08.13 ler 0204764 - Ф.155. Экспорт в программу KLIKO 3006-У 01.08.13 F155_16.pak (версия от 30.07.2013)
*/
/******************************************************************************/
{globals.i}
{norm.i}
{done}
&GLOBAL-DEFINE STREAM STREAM fil

{wordwrap.def}

DEFINE VARIABLE mFirstTime AS LOGICAL     NO-UNDO INIT YES.

/**************************************************************************************/
/* Структура отчета                                                                   */
/**************************************************************************************/
PROCEDURE doPrint.
   DEFINE INPUT  PARAMETER iDml    AS HANDLE     NO-UNDO.
   DEFINE INPUT  PARAMETER iDataID AS INT64    NO-UNDO.

   SUBSCRIBE TO "beginReport" IN iDml.
   SUBSCRIBE TO "beginBlock"  IN iDml.
   SUBSCRIBE TO "recordData"  IN iDml.
   SUBSCRIBE TO "endBlock"    IN iDml.
   SUBSCRIBE TO "beginSprav"  IN iDml.
   SUBSCRIBE TO "recordSprav" IN iDml.
   &IF DEFINED(D01-07-12) GT 0 &THEN
      SUBSCRIBE TO "beginSprav2"  IN iDml.
      SUBSCRIBE TO "recordSprav2" IN iDml.
      SUBSCRIBE TO "recordSepSprav2" IN iDml.
      SUBSCRIBE TO "endSprav2" IN iDml.
   &ENDIF
   &IF DEFINED(D01-07-13) GT 0 &THEN
      SUBSCRIBE TO "Sprav3-5"  IN iDml.
   &ENDIF

   RUN doPrint IN iDml.

   RUN endReport.

   UNSUBSCRIBE TO ALL IN iDml.

END PROCEDURE. /* doPrint */
/**************************************************************************************/
/* начало отчета. Печать заголовка                                                    */
/**************************************************************************************/
PROCEDURE beginReport.
   DEFINE INPUT  PARAMETER iBegDate AS DATE       NO-UNDO.
   DEFINE INPUT  PARAMETER iEndDate AS DATE       NO-UNDO.

   {setdest.i
       &cols = 250
       &nodef = {comment}
       &APPEND = APPEND}

END PROCEDURE. /* beginReport */
/**************************************************************************************/
/* Печать заголовков                                                                  */
/**************************************************************************************/
PROCEDURE beginBlock.
   DEFINE INPUT  PARAMETER iPartNum AS INT64     NO-UNDO.

IF GetSysConf("ModeExport") NE "ExpКЛИКО" THEN
DO:
   &IF DEFINED(D01-01-12) EQ 0 &THEN
      &IF DEFINED(InstrNNNN-U) GT 0 &THEN
         IF iPartNum EQ 2 THEN
            PUT {&stream} UNFORMATTED
               SKIP(1)
               "                                Раздел 2. Срочные сделки, предусматривающие поставку базисного актива " SKIP(1)
               "                                                                                                                            тыс.руб." SKIP(1)
               "┌──────┬────────────────────────────────────────────┬───────────────┬───────────────┬───────────────┬───────────────┬───────────────┐" SKIP
               "│Номер │         Наименование инструмента           │     Сумма     │     Сумма     │Нереализованные│Нереализованные│    Резерв     │" SKIP.
         ELSE
            PUT {&stream} UNFORMATTED
               SKIP(1)
               "                                        Раздел 3. Срочные сделки расчетные (беспоставочные) " SKIP(1)
               "                                                                                                                            тыс.руб." SKIP(1)
               "┌──────┬────────────────────────────────────────────┬───────────────┬───────────────┬───────────────┬───────────────┬───────────────┐" SKIP
               "│Номер │        Виды беспоставочных сделок          │     Сумма     │     Сумма     │Нереализованные│Нереализованные│    Резерв     │" SKIP.
      &ELSE
         IF iPartNum EQ 2 THEN
            PUT {&stream} UNFORMATTED
               SKIP(1)
               "                                Раздел 2. Срочные сделки, предусматривающие поставку базисного актива " SKIP(1)
               "                                                                                                                            тыс.руб." SKIP(1)
               "┌─────┬────────────────────────────────────────────┬───────────────┬───────────────┬───────────────┬───────────────┬───────────────┐" SKIP
            &IF DEFINED(Instr2055-U) GT 0 &THEN
               "│Номер│         Наименование инструмента           │     Сумма     │     Сумма     │Нереализованные│Нереализованные│    Резерв     │" SKIP.
            &ELSE
               "│Номер│           Название инструмента             │     Сумма     │     Сумма     │     Сумма     │     Сумма     │    Резерв     │" SKIP.
            &ENDIF
         ELSE
            PUT {&stream} UNFORMATTED
               SKIP(1)
               "                                        Раздел 3. Срочные сделки расчетные (беспоставочные) " SKIP(1)
               "                                                                                                                            тыс.руб." SKIP(1)
               "┌─────┬────────────────────────────────────────────┬───────────────┬───────────────┬───────────────┬───────────────┬───────────────┐" SKIP
            &IF DEFINED(Instr2055-U) GT 0 &THEN
               "│Номер│        Виды беспоставочных сделок          │     Сумма     │     Сумма     │Нереализованные│Нереализованные│    Резерв     │" SKIP.
            &ELSE
               "│Номер│        Виды беспоставочных сделок          │     Сумма     │     Сумма     │     Сумма     │     Сумма     │    Резерв     │" SKIP.
            &ENDIF
      &ENDIF
   &ENDIF
END.
ELSE
DO:
   IF iPartNum EQ 2 THEN
      PUT {&stream} UNFORMATTED
         SKIP(1)
         "                                Раздел 2. Срочные сделки, предусматривающие поставку базисного актива " SKIP(1)
         SKIP.
   ELSE
      PUT {&stream} UNFORMATTED
         SKIP(1)
         "                                        Раздел 3. Срочные сделки расчетные (беспоставочные) " SKIP(1)
         SKIP.
END.

IF GetSysConf("ModeExport") NE "ExpКЛИКО" THEN
   &IF DEFINED(D01-01-12) GT 0 &THEN
      IF iPartNum EQ 2 THEN
         PUT {&stream} UNFORMATTED
            SKIP(1)
            "                                                        Раздел 2. Срочные сделки" SKIP(1)
            "                                                                                                                             тыс.руб." SKIP(1)
            "┌──────┬────────────────────────────────────────────┬───────────────┬───────────────┬───────────────┬───────────────┬───────────────┐" SKIP
            "│Номер │         Наименование инструмента           │     Сумма     │     Сумма     │Нереализованные│Нереализованные│    Резерв     │" SKIP
            "│строки│                                            │   требований  │  обязательств │    курсовые   │    курсовые   │ на возможные  │" SKIP
            "│      │                                            │               │               │    разницы    │    разницы    │    потери     │" SKIP
            "│      │                                            │               │               │(положительные)│(отрицательные)│               │" SKIP
            "├──────┼────────────────────────────────────────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────┤" SKIP
            "│  1   │                    2                       │       3       │       4       │       5       │       6       │       7       │" SKIP
            "├──────┼────────────────────────────────────────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────┤" SKIP.
      ELSE
         PUT {&stream} UNFORMATTED
            SKIP(1)
            "                                              Раздел 3. Производные финансовые инструменты "                                                           SKIP(1)
            "                                                                                                                                             тыс.руб." SKIP(1)
            "┌──────┬────────────────────────────────────────────┬───────────────────────────────┬───────────────┬───────────────┬───────────────┬───────────────┐" SKIP
            "│Номер │         Наименование инструмента           │   Справедливоя  стоимость     │     Сумма     │     Сумма     │Нереализованные│Нереализованные│" SKIP
            "│строки│                                            ├───────────────┬───────────────┤   требований  │  обязательств │    курсовые   │    курсовые   │" SKIP
            "│      │                                            │     актив     │     пассив    │               │               │    разницы    │    разницы    │" SKIP
            "│      │                                            │               │               │               │               │(положительные)│(отрицательные)│" SKIP
            "├──────┼────────────────────────────────────────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────┤" SKIP
            "│  1   │                    2                       │       3       │       4       │       5       │       6       │       7       │       8       │" SKIP
            "├──────┼────────────────────────────────────────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────┤" SKIP.
   &ELSE
      PUT {&stream} UNFORMATTED
      &IF DEFINED(InstrNNNN-U) GT 0 &THEN
         "│строки│                                            │   требований  │  обязательств │    курсовые   │    курсовые   │ на возможные  │" SKIP
         "│      │                                            │               │               │    разницы    │    разницы    │    потери     │" SKIP
         "│      │                                            │               │               │(положительные)│(отрицательные)│               │" SKIP
         "├──────┼────────────────────────────────────────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────┤" SKIP
         "│  1   │                    2                       │       3       │       4       │       5       │       6       │       7       │" SKIP
         "├──────┼────────────────────────────────────────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────┤" SKIP
      &ELSEIF DEFINED(Instr2055-U) GT 0 &THEN
         "│ п/п │                                            │   требований  │  обязательств │    курсовые   │    курсовые   │ на возможные  │" SKIP
         "│     │                                            │               │               │    разницы    │    разницы    │    потери     │" SKIP
         "│     │                                            │               │               │(положительные)│(отрицательные)│               │" SKIP
      &ELSE
         "│ п/п │                                            │   требований  │  обязательств │ положительных │ отрицательных │ на возможные  │" SKIP
         "│     │                                            │               │               │   переоценок  │   переоценок  │    потери     │" SKIP
      &ENDIF
         "├─────┼────────────────────────────────────────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────┤" SKIP
         "│  1  │                    2                       │       3       │       4       │       5       │       6       │       7       │" SKIP
         "├─────┼────────────────────────────────────────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────┤" SKIP.
   &ENDIF
END PROCEDURE. /* beginBlock */
/**************************************************************************************/
/* Печать заголовков                                                                  */
/**************************************************************************************/
PROCEDURE beginData.
END PROCEDURE. /* beginBlock */
/**************************************************************************************/
/* Печать данных                                                                      */
/**************************************************************************************/
PROCEDURE recordData.
   DEFINE INPUT  PARAMETER iBuff AS HANDLE      NO-UNDO.
   &IF DEFINED(D01-01-12) GT 0 &THEN
      DEFINE INPUT  PARAMETER iPartNum AS INT64     NO-UNDO.
   &ENDIF

   DEFINE VARIABLE vInstrName AS CHARACTER EXTENT 3 NO-UNDO.

   IF NOT mFirstTime THEN
      PUT {&stream} UNFORMATTED
      &IF DEFINED(D01-01-12) GT 0 &THEN
            "├──────┼────────────────────────────────────────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────" + (IF iPartNum EQ 3 THEN "┼───────────────┤" ELSE "┤") SKIP.
      &ELSE
         &IF DEFINED(InstrNNNN-U) GT 0 &THEN
            "├──────┼────────────────────────────────────────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────┤" SKIP.
         &ELSE
            "├─────┼────────────────────────────────────────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────┤" SKIP.
         &ENDIF
      &ENDIF
   ELSE
      mFirstTime = NO.

   vInstrName[1] = iBuff:BUFFER-FIELD("InstrName"):BUFFER-VALUE.
IF GetSysConf("ModeExport") NE "ExpКЛИКО" THEN DO:
   {wordwrap.i &s=vInstrName &l=44 &n=2 &tail=vInstrName[3]}
   vInstrName[2] = vInstrName[3].   /* <- без этого не работает принудительный перевод строки */

   PUT {&stream} UNFORMATTED
      "│ "
      iBuff:BUFFER-FIELD("StrNum"):BUFFER-VALUE FORMAT "x(3)" &IF DEFINED(InstrNNNN-U) GT 0 &THEN "  │" &ELSE " │" &ENDIF
      vInstrName[1] FORMAT "x(44)" "│" .
   &IF DEFINED(D01-01-12) GT 0 &THEN
   IF iPartNum EQ 3 THEN
      PUT {&stream} UNFORMATTED
         DEC(iBuff:BUFFER-FIELD("SumSsa") :BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "│"
         DEC(iBuff:BUFFER-FIELD("SumSsp") :BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "│".
   &ENDIF
   PUT {&stream} UNFORMATTED
      DEC(iBuff:BUFFER-FIELD("SumOb")  :BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "│"
      DEC(iBuff:BUFFER-FIELD("SumTreb"):BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "│"
      DEC(iBuff:BUFFER-FIELD("SumPPer"):BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "│"
      DEC(iBuff:BUFFER-FIELD("SumOPer"):BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "│" .
   &IF DEFINED(D01-01-12) GT 0 &THEN
      IF iPartNum EQ 2 THEN
         PUT {&stream} UNFORMATTED
            DEC(iBuff:BUFFER-FIELD("SumReserv"):BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "│".
         PUT {&stream} UNFORMATTED
            SKIP.
   &ELSE
      &IF DEFINED(Instr2055-U) EQ 0 &THEN
      IF iBuff:BUFFER-FIELD("StrNum"):BUFFER-VALUE BEGINS "2" THEN
         PUT {&stream} UNFORMATTED "       X       │" SKIP.
      ELSE
      &ENDIF
       PUT {&stream} UNFORMATTED
         DEC(iBuff:BUFFER-FIELD("SumReserv"):BUFFER-VALUE) FORMAT "->>>>>>>,>>9.99" "│" SKIP.
   &ENDIF
END.
ELSE  /* -------------------------------------------- ExpКЛИКО -------------- */
DO:
   PUT {&stream} UNFORMATTED
      "│ " REPLACE(vInstrName[1], "|", "")  "│".
   &IF DEFINED(D01-01-12) GT 0 &THEN
      IF iPartNum EQ 3 THEN
         PUT {&stream} UNFORMATTED
            DEC(iBuff:BUFFER-FIELD("SumSsa") :BUFFER-VALUE) FORMAT "->>>>>>>>>9.99" "│"
            DEC(iBuff:BUFFER-FIELD("SumSsp") :BUFFER-VALUE) FORMAT "->>>>>>>>>9.99" "│".
   &ENDIF

   PUT {&stream} UNFORMATTED
      DEC(iBuff:BUFFER-FIELD("SumOb")  :BUFFER-VALUE) FORMAT "->>>>>>>>>9.99" "│"
      DEC(iBuff:BUFFER-FIELD("SumTreb"):BUFFER-VALUE) FORMAT "->>>>>>>>>9.99" "│"
      DEC(iBuff:BUFFER-FIELD("SumPPer"):BUFFER-VALUE) FORMAT "->>>>>>>>>9.99" "│"
      DEC(iBuff:BUFFER-FIELD("SumOPer"):BUFFER-VALUE) FORMAT "->>>>>>>>>9.99" "│" .
&IF DEFINED(D01-01-12) GT 0 &THEN
   IF iPartNum EQ 2 THEN
      PUT {&stream} UNFORMATTED
         DEC(iBuff:BUFFER-FIELD("SumReserv"):BUFFER-VALUE) FORMAT "->>>>>>>>>9.99" "│".
&ELSEIF DEFINED(Instr2055-U) EQ 0 &THEN
   IF iBuff:BUFFER-FIELD("StrNum"):BUFFER-VALUE BEGINS "2" THEN
      PUT {&stream} UNFORMATTED "       X       │".
   ELSE
&ENDIF

   PUT {&stream} UNFORMATTED
      iBuff:BUFFER-FIELD("StrNum"):BUFFER-VALUE FORMAT "x(3)" " │" SKIP.
END.

IF GetSysConf("ModeExport") NE "ExpКЛИКО" THEN
   DO WHILE vInstrName[2] GT "":
      vInstrName[1] = vInstrName[2].
      {wordwrap.i &s=vInstrName &l=44 &n=2 &tail=vInstrName[3]}
      vInstrName[2] = vInstrName[3].   /* <- без этого не работает принудительный перевод строки */
      PUT {&stream} UNFORMATTED
      &IF DEFINED(D01-01-12) GT 0 &THEN
         "│      │" vInstrName[1] FORMAT "x(44)" "│               │               │               │               │               │" + (IF iPartNum EQ 3 THEN "               │" ELSE "") SKIP.
      &ELSE
         &IF DEFINED(InstrNNNN-U) GT 0 &THEN
         "│      │" vInstrName[1] FORMAT "x(44)" "│               │               │               │               │               │" SKIP.
         &ELSE
         "│     │" vInstrName[1] FORMAT "x(44)" "│               │               │               │               │               │" SKIP.
         &ENDIF
      &ENDIF
   END.

END PROCEDURE.  /* recordData */
/**************************************************************************************/
/* Конец данных.                                                                      */
/**************************************************************************************/
PROCEDURE endData.
END PROCEDURE. /*   */
/**************************************************************************************/
/* Конец блока.                                                                       */
/**************************************************************************************/
PROCEDURE endBlock.
   &IF DEFINED(D01-01-12) GT 0 &THEN
      DEFINE INPUT  PARAMETER iPartNum AS INT64     NO-UNDO.
   &ENDIF

   PUT {&stream} UNFORMATTED
   &IF DEFINED(D01-01-12) GT 0 &THEN
      "└──────┴────────────────────────────────────────────┴───────────────┴───────────────┴───────────────┴───────────────┴───────────────" + (IF iPartNum EQ 3 THEN "┴───────────────┘" ELSE "┘")SKIP.
   &ELSE
      &IF DEFINED(InstrNNNN-U) GT 0 &THEN
      "└──────┴────────────────────────────────────────────┴───────────────┴───────────────┴───────────────┴───────────────┴───────────────┘" SKIP.
      &ELSE
      "└─────┴────────────────────────────────────────────┴───────────────┴───────────────┴───────────────┴───────────────┴───────────────┘" SKIP.
      &ENDIF
   &ENDIF

   mFirstTime = YES.

END PROCEDURE. /*   */
/**************************************************************************************/
/* Раздел Справочно                                                                   */
/**************************************************************************************/
PROCEDURE beginSprav.

   PUT {&stream} UNFORMATTED SKIP(1)
      '                                              Раздел "Справочно:"' SKIP(1)
   &IF DEFINED(D01-07-12) GT 0 &THEN
      " 1. Положительная переоценка по хеджирующим сделкам, принятая в уменьшение резервов на возможные потери по срочным сделкам," SKIP
      "    отраженным в разделе 2 отчета, в соответствии с требованиями главы 5 Положения Банка России № 283-П:" .
   &ELSE
      &IF DEFINED(Instr2055-U) GT 0 &THEN
      " Положительная переоценка по хеджирующим сделкам, принятая в уменьшение резервов на возможные потери в соответствии " SKIP
      " с требованиями главы 5 Положения Банка России № 283-П:" SKIP.
      &ELSE
      " Уменьшающая резерв на возможные потери положительная переоценка по хеджирующим сделкам, осуществлянемая в соответствии " SKIP
      " с главой 5 Положения Банка России № 283-П:" SKIP.
      &ENDIF
   &ENDIF
END PROCEDURE. /*   */

PROCEDURE beginSprav2.

IF GetSysConf("ModeExport") NE "ExpКЛИКО" THEN
   PUT {&stream} UNFORMATTED SKIP(1)
      " 2. Информация о ценных бумагах, принятых в обеспечение по размещенным средствам и полученных по операциям, совершаемым на возвратной основе,                     " SKIP
      "                                                 права на которые удостоверяются организациями (депозитариями)                                                    " SKIP
      "┌──────┬────────────────────────────────────────┬───────────────┬──────────────────────────────┬────────────────────┬─────────────────┬───────────────────────┬─────────────────┐" SKIP
      "│Номер │       Наименование организации         │      ИНН      │        Номеp лицензии        │    Количество      │Стоимость ценных │Текущая (справедливая) │  Сформированный │" SKIP
      "│строки│             (депозитария)              │  организации  │         организации          │    ценных бумаг,   │бумаг, принятых  │стоимость ценных бумаг,│     резерв      │" SKIP
      "│      │                                        │ (депозитария) │        (депозитария)         │                    │в обеспечение по │полученных по опера-   │  на возможные   │" SKIP
      "│      │                                        │               │                              │                    │размещенным      │циям, совершенным на   │     потери      │" SKIP
      "│      │                                        │               │                              │                    │    средствам    │возвратной основе      │                 │" SKIP
      "│      │                                        │               │                              │        шт.         │     тыс.руб.    │        тыс.руб.       │     тыс.руб.    │" SKIP
      "├──────┼────────────────────────────────────────┼───────────────┼──────────────────────────────┼────────────────────┼─────────────────┼───────────────────────┼─────────────────┤" SKIP
      "│  1   │                    2                   │       3       │              4               │         5          │        6        │           7           │        8        │" SKIP
      "├──────┼────────────────────────────────────────┼───────────────┼──────────────────────────────┼────────────────────┼─────────────────┼───────────────────────┼─────────────────┤" SKIP.
ELSE
   PUT {&stream} UNFORMATTED SKIP(1) " 2. Информация о ценных бумагах" SKIP.

END PROCEDURE. /*   */

PROCEDURE Sprav3-5.
   DEFINE INPUT  PARAMETER iSumm3   AS DECIMAL     NO-UNDO.
   DEFINE INPUT  PARAMETER iSumm4   AS DECIMAL     NO-UNDO.
   DEFINE INPUT  PARAMETER iSumm5   AS DECIMAL     NO-UNDO.

   IF GetSysConf("ModeExport") NE "ExpКЛИКО" THEN
   DO:
      PUT {&stream} UNFORMATTED SKIP(1)
        "3. Общая сумма условных обязательств кредитного характера, включая     " SKIP
        "   сгруппированные в однородные портфели, которые могут быть безусловно" SKIP 
        "   аннулированы в любой момент времени без предварительного уведомления" SKIP
        "   контрагента, по балансовой стоимости, " iSumm3 " тыс. руб. ".
      
      PUT {&stream} UNFORMATTED SKIP(1)
        "4. Величина фактически сформированного резерва на возможные потери по   " SKIP
        "   общей сумме условных обязательств кредитного характера, включая      " SKIP
        "   сгруппированные в однородные портфели, которые могут быть безусловно " SKIP
        "   аннулированы в любой момент времени без предварительного уведомления " SKIP
        "   контрагента, по балансовой стоимости, " iSumm4 " тыс. руб. ".
      
      PUT {&stream} UNFORMATTED SKIP(1)
        "5. Величина, подверженная кредитному риску по срочным сделкам и       " SKIP
        "   производным финансовым инструментам, заключенным на биржевом и     " SKIP
        "   внебиржевом рынках, рассчитанная на основании методики,            " SKIP
        "   предусмотренной приложением 3 к Инструкции Банка России № 139-И, за" SKIP
        "   исключением положений пункта 1, подпункта 8.1 пункта 8, пунктов    " SKIP
        "   9 - 12 указанного приложения, "  iSumm5 " тыс. руб. ".
   END.
   ELSE
   DO:
      PUT {&stream} UNFORMATTED SKIP(1) "<NF1554_SP345>".
      PUT {&stream} UNFORMATTED SKIP(1) "│ 3 │" iSumm3 "│ ".
      PUT {&stream} UNFORMATTED SKIP(1) "│ 4 │" iSumm4 "│ ".
      PUT {&stream} UNFORMATTED SKIP(1) "│ 5 │" iSumm5 "│ ".
      PUT {&stream} UNFORMATTED SKIP(1) "".
   END.
END PROCEDURE. /* Sprav3-5 */
/**************************************************************************************/
/* Данные раздела Справочно                                                           */
/**************************************************************************************/
PROCEDURE recordSprav.
   DEFINE INPUT  PARAMETER iPartNum AS INT64     NO-UNDO.
   DEFINE INPUT  PARAMETER iSumm    AS DECIMAL     NO-UNDO.

IF GetSysConf("ModeExport") NE "ExpКЛИКО" THEN
DO:
   IF iPartNum EQ 2 THEN
      PUT {&stream} UNFORMATTED
      &IF DEFINED(D01-07-12) EQ 0 &THEN
         &IF DEFINED(D01-01-12) GT 0 &THEN
         "     1. По срочным сделкам, отраженным в разделе 2:                                       "
         &ELSE
         "     1. По срочным сделкам, предусматривающим поставку базисного актива, отраженным в разделе 2: "
         &ENDIF
      &ENDIF
         iSumm FORMAT "->>>>>>>,>>9.99"  " тыс.руб." SKIP.
   ELSE
      PUT {&stream} UNFORMATTED
      &IF DEFINED(D01-01-12) GT 0 &THEN
         "     2. По производным финансовым инструментам, отраженным в разделе 3:                   "
      &ELSE
         "     2. По срочным расчетным (беспоставочным) сделкам, отраженным в разделе 3:                   "
      &ENDIF
         iSumm FORMAT "->>>>>>>,>>9.99" " тыс.руб." SKIP.
END.
ELSE
DO:                                            /* ExpКЛИКО */
   IF iPartNum EQ 2 THEN
      &IF DEFINED(D01-01-12) GT 0 &THEN
         PUT {&stream} UNFORMATTED "│" iSumm FORMAT "->>>>>>>>>9" "│" .
      &ELSE
         PUT {&stream} UNFORMATTED "│" iSumm FORMAT "->>>>>>>>>9" .
      &ENDIF

   ELSE
      PUT {&stream} UNFORMATTED "│" iSumm FORMAT "->>>>>>>>>9" "│" SKIP.
END.

END PROCEDURE.

PROCEDURE recordSprav2.
   DEFINE INPUT  PARAMETER iCol1    AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER iCol2    AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER iCol3    AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER iCol4    AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER iCol5    AS DECIMAL     NO-UNDO.
   DEFINE INPUT  PARAMETER iCol6    AS DECIMAL     NO-UNDO.
   DEFINE INPUT  PARAMETER iCol7    AS DECIMAL     NO-UNDO.
   DEFINE INPUT  PARAMETER iCol8    AS DECIMAL     NO-UNDO.

   DEFINE VARIABLE vI AS INTEGER NO-UNDO.
   DEFINE VARIABLE vOrgName AS CHARACTER NO-UNDO EXTENT 10.

   vOrgName[1] = iCol2.

IF GetSysConf("ModeExport") NE "ExpКЛИКО" THEN
DO:

   {wordwrap.i &s=vOrgName &l=40 &n=EXTENT(vOrgName)}

   PUT {&stream} UNFORMATTED
      "│" iCol1       FORMAT "x(6)"
      "│" vOrgName[1] FORMAT "x(40)"
      "│" iCol3       FORMAT "x(15)"
      "│" iCol4       FORMAT "x(30)"
      "│" iCol5       FORMAT ">>>>>>>>>>>>>>9.9999"
      "│" iCol6       FORMAT ">>>>>>>>>>>>>9.99"
      "│" iCol7       FORMAT "      >>>>>>>>>>>>>9.99"
      "│" iCol8       FORMAT ">>>>>>>>>>>>>9.99"
      "│" SKIP.

   DO vI = 2 TO EXTENT(vOrgName):
      IF vOrgName[vI] = "" THEN LEAVE.
      PUT {&stream} UNFORMATTED
         "│" SPACE(6)
         "│" vOrgName[vI] FORMAT "x(40)"
         "│" SPACE(15)
         "│" SPACE(30)
         "│" SPACE(20)
         "│" SPACE(17)
         "│" SPACE(23)
         "│" SPACE(17)
         "│" SKIP.
   END.
END.
ELSE  /* -------------------------------------------- ExpКЛИКО -------------- */
DO:
   PUT {&stream} UNFORMATTED
      "│" iCol1       FORMAT "x(6)"
      "│" vOrgName[1] /* FORMAT "x(40)" */
      "│" iCol3       FORMAT "x(15)"
      "│" iCol4       FORMAT "x(30)"
      "│" iCol5       FORMAT ">>>>>>>>>>>>>>9.9999"
      "│" iCol6       FORMAT ">>>>>>>>>>>>>9.99"
      "│" iCol7       FORMAT "      >>>>>>>>>>>>>9.99"
      "│" iCol8       FORMAT ">>>>>>>>>>>>>9.99"
      "│" SKIP.

END.

END PROCEDURE.

PROCEDURE recordSepSprav2.
   PUT {&stream} UNFORMATTED
      "├──────┼────────────────────────────────────────┼───────────────┼──────────────────────────────┼────────────────────┼─────────────────┼───────────────────────┼─────────────────┤"
   SKIP.
END PROCEDURE.

PROCEDURE endSprav2.
   PUT {&stream} UNFORMATTED
      "└──────┴────────────────────────────────────────┴───────────────┴──────────────────────────────┴────────────────────┴─────────────────┴───────────────────────┴─────────────────┘" SKIP.
END PROCEDURE. /*   */
/**************************************************************************************/
/* Конец отчета                                                                       */
/**************************************************************************************/
PROCEDURE endReport.
IF GetSysConf("ModeExport") NE "ExpКЛИКО" AND
   GetSysConf("ModeExport") NE "ExpПТК"
THEN DO:
   {signatur.i}
   {preview.i}
END.
END PROCEDURE.
/******************************************************************************/
