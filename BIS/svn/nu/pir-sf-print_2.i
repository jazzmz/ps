/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ЗАО "Банковские информационные системы"
     Filename: SF-PRINT.I
      Comment: Собственно печать счетов-фактур
   Parameters:
         Uses:
      Used by: sf-print.p
      Created: 27.01.2005 Dasu
     Modified: 19/06/2006 ZIAL (0060144) АХД. Доработки по счетам-фактур. Патч d15.
     Modified: 28/06/2006 ZIAL (0063001) АХД. Доработка процедур печати счета-фактуры 
               и Книги Покупок
     Modified: 06/07/2006 ZIAL (0060144) АХД. Доработки по счетам-фактур. Патч d15.
     Modified: 20.03.2007 16:26 OZMI     (0070598)
*/

PUT STREAM sfact UNFORMATTED
    PADL("Приложение N 1",mLeng) SKIP
    PADL("к постановлению Правительства",mLeng) SKIP
    PADL("Российской Федерации",mLeng) SKIP
    PADL("от 26.12.2011 №1137",mLeng) 
    SKIP.

PUT STREAM sfact UNFORMATTED
   SKIP
   SPACE(mLengBody + mLs + 19) "СЧЕТ-ФАКТУРА № " + STRING(mSFNum,"x(14)") +  " от <<" + (IF mSfDate NE ? THEN STRING(DAY(mSFDate),"99") ELSE "  ") + ">>" + (IF mSfDate NE ? THEN (STRING(ENTRY(MONTH(mSFDate),Monthes)) + "  " + STRING(YEAR(mSFDate)) + "г.") ELSE "") SKIP
   SPACE(mLengBody + mLs + 19) "               ──────────────      ──  ────────────────" SKIP 
.

IF mSFFixInfo EQ "" THEN
DO:
   PUT STREAM sfact UNFORMATTED
      SKIP
      SPACE(mLengBody + mLs + 19) 'ИСПРАВЛЕНИЕ №        -              -         -' SKIP
   SPACE(mLengBody + mLs + 19) "               ──────────────      ──  ────────────────" SKIP(1)      
   .
END.      
ELSE
DO i = 1 TO NUM-ENTRIES(mSFFixInfo,";"):
   ASSIGN
      mSFFixNum  = TRIM(ENTRY(1,ENTRY(i,mSFFixInfo,";")))  
      mSFFixDate = DATE(ENTRY(2,ENTRY(i,mSFFixInfo,";")))
   NO-ERROR.
   PUT STREAM sfact UNFORMATTED
      SKIP
      SPACE(mLengBody + mLs + 19) "ИСПРАВЛЕНИЕ №  " + STRING(mSFFixNum,"x(14)") +  " от <<" + (IF mSFFixDate NE ? THEN STRING(DAY(mSFFixDate),"99") ELSE "  ") + ">>" + (IF mSFFixDate NE ? THEN (STRING(ENTRY(MONTH(mSFFixDate),Monthes)) + "  " + STRING(YEAR(mSFFixDate)) + "г.") ELSE "") SKIP
      SPACE(mLengBody + mLs + 19) "               ──────────────      ──  ────────────────" SKIP(1) 
   .   
END.



{sf-print-wrap.i &w = "'Продавец'" &v = mStrSeller     &und = YES &d = 80}
{sf-print-wrap.i &w = "'Адрес'"    &v = mStrSellerAddr &und = YES &d = 80}
 
PUT STREAM sfact UNFORMATTED
   SPACE(mLengBody + mLs) "ИНН/КПП продавца " + mSFSellerINN + "/" + mSFSellerKPP SKIP
   SPACE(mLengBody + mLs) "                ────────────────────────────────────────────────────────────────" SKIP
.

{sf-print-wrap.i &w = "'Грузоотправитель и его адрес'" &v = mStrOtprav &und = YES &d = 80}
{sf-print-wrap.i &w = "'Грузополучатель и его адрес'"  &v = mStrPoluch &und = YES &d = 80}

PUT STREAM sfact UNFORMATTED
   SPACE(mLengBody + mLs) {&STR1} + " " + mDocNumDate  
   SPACE(mLengBody + mLs) mDocNumLine SKIP
.

{sf-print-wrap.i &w = "'Покупатель'"  &v = mStrBuyer     &und = YES &d = 80}
{sf-print-wrap.i &w = "'Адрес'"       &v = mStrBuyerAddr &und = YES &d = 80}

PUT STREAM sfact UNFORMATTED
   SPACE(mLengBody + mLs) "ИНН/КПП покупателя " + mSFBuyerINN + "/" + mSFBuyerKPP SKIP
   SPACE(mLengBody + mLs) "                  ──────────────────────────────────────────────────────────────" SKIP
.

PUT STREAM sfact UNFORMATTED
   SPACE(mLengBody + mLs) "Валюта " mSFCurrInfo SKIP
   SPACE(mLengBody + mLs) mSFCurrLine SKIP
.


IF CAN-FIND(FIRST ttServ NO-LOCK) 
THEN DO:
   PUT STREAM sfact UNFORMATTED
      /* шапка таблицы */
      SPACE(mLengBody) "┌──────────────────────────────┬───────────────────┬─────────────┬──────────────────┬──────────────────┬──────────────────┬───────────────┬──────────────────┬──────────────────┬────────────────────┬──────────┐" SKIP
      SPACE(mLengBody) "│    НАИМЕНОВАНИЕ ТОВАРА       │      ЕДИНИЦА      │ КОЛИЧЕСТВО  │  ЦЕНА (ТАРИФ)    │СТОИМОСТЬ ТОВАРОВ │    В ТОМ ЧИСЛЕ   │   НАЛОГОВАЯ   │   СУММА НАЛОГА   │СТОИМОСТЬ ТОВАРОВ │      СТРАНА        │  НОМЕР   │" SKIP
      SPACE(mLengBody) "│ (описание выполненных работ, │     ИЗМЕРЕНИЯ     │   (ОБЪЕМ)   │  ЗА ЕДИНИЦУ      │ (РАБОТ, УСЛУГ),  │    СУММА АКЦИЗ   │    СТАВКА     │  ПРЕДЪЯВЛЯЕМАЯ   │ (РАБОТ, УСЛУГ),  │    ПРОИСХОЖДЕНИЯ   │ТАМОЖЕННОЙ│" SKIP
      SPACE(mLengBody) "│       оказанных услуг),      │                   │             │  ИЗМЕРЕНИЯ       │  ИМУЩЕСТВЕННЫХ   │                  │               │    ПОКУПАТЕЛЮ    │  ИМУЩЕСТВЕННЫХ   │       ТОВАРА       │ДЕКЛАРАЦИИ│" SKIP
      SPACE(mLengBody) "│     имущественного права     ├────┬──────────────┤             │                  │ ПРАВ БЕЗ НАЛОГА, │                  │               │                  │      ПРАВ,       ├────┬───────────────┤          │" SKIP
      SPACE(mLengBody) "│                              │КОД │    УСЛОВНОЕ  │             │                  │      ВСЕГО       │                  │               │                  │ ВСЕГО С НАЛОГОМ  │ЦИФР│    КРАТКОЕ    │          │" SKIP
      SPACE(mLengBody) "│                              │    │  ОБОЗНАЧЕНИЕ │             │                  │                  │                  │               │                  │                  │ОВОЙ│  НАИМЕНОВАНИЕ │          │" SKIP
      SPACE(mLengBody) "│                              │    │(НАЦИОНАЛЬНОЕ)│             │                  │                  │                  │               │                  │                  │КОД │               │          │" SKIP
      SPACE(mLengBody) "├──────────────────────────────┼────┼──────────────┼─────────────┼──────────────────┼──────────────────┼──────────────────┼───────────────┼──────────────────┼──────────────────┼────┼───────────────┼──────────┤" SKIP
      SPACE(mLengBody) "│              1               │  2 │     2а       │      3      │        4         │        5         │        6         │       7       │        8         │        9         │ 10 │      10а      │    11    │" SKIP
      SPACE(mLengBody) "├──────────────────────────────┼────┼──────────────┼─────────────┼──────────────────┼──────────────────┼──────────────────┼───────────────┼──────────────────┼──────────────────┼────┼───────────────┼──────────┤" SKIP
      .                                                                 
   ASSIGN
      mPriceSumm = 0
      mNalogSumm = 0
      mTotalSumm = 0
   .
   FOR EACH ttServ 
      NO-LOCK
      BREAK BY ttServ.NameServ:
      ASSIGN   
         mPriceSumm = mPriceSumm + ttServ.SummOut
         mNalogSumm = mNalogSumm + ttServ.NalogSumm
         mTotalSumm = mTotalSumm + ttServ.TotalSumm
      .

      /* печатаем данные по услуге */
      PUT STREAM sfact UNFORMATTED
             SPACE(mLengBody) 
             "│" + STRING(ENTRY(1,ttServ.NameServ,'~n'),"x(30)") + 
             "│" + (IF    ttServ.Edin    NE "" 
                      AND ttServ.SummOut <> 0 and not mIsEmptyKol THEN STRING(ENTRY(1,ttServ.Edin,'~n'), "x(4)")
                                                  ELSE "  - ") +
             "│" + (IF    ttServ.Edin    NE "" 
                      AND ttServ.SummOut <> 0 and not mIsEmptyKol THEN STRING(ttServ.EdinName, "x(14)")
                                                  ELSE "      -       "/*FILL(" ",14)*/) +                                                  
             "│" + (IF    ttServ.Quant   NE 0 
                      AND ttServ.SummOut <> 0 and not mIsEmptyKol THEN STRING(ttServ.Quant,">>,>>>,>>9.99")
                                                  ELSE "      -      ") + 
             "│" + (IF    ttServ.Price NE 0 
                      AND ttServ.SummOut <> 0 and not mIsEmptyKol THEN STRING(ttServ.Price,">>>,>>>,>>>,>>9.99")
                                                  ELSE "      -           ")  +
/*             "│" + (IF loan.cont-type NE "а/о" THEN STRING(ttServ.SummOut,">>>,>>>,>>>,>>9.99") */
             "│" + (IF ttServ.SummOut <> 0 THEN STRING(ttServ.SummOut,">>>,>>>,>>>,>>9.99") 
                                               ELSE "         -        ")   +
             "│" + (IF ttServ.Akciz NE 0 THEN STRING(ttServ.Akciz,">>>,>>>,>>>,>>9.99")
                                         ELSE if loan.cont-type NE "а/о" then "   Без акциза     " ELSE "       -          ") +
             "│" + (IF ttServ.Nlog NE 0 THEN STRING(ttServ.Nlog,">>>>,>>>,>>9.99")
                                        ELSE "Без налога(НДС)") +
             "│" + (IF ttServ.Nlog NE 0 THEN STRING(ttServ.NalogSumm,">>>,>>>,>>>,>>9.99")
                                        ELSE " Без налога(НДС)  ") +
             "│" + STRING(ttServ.TotalSumm,">>>,>>>,>>>,>>9.99") +
             "│" + (IF    ttServ.Contry  NE "" 
                      AND loan.cont-type NE "а/о" THEN STRING(ttServ.Contry,"x(4)")
                                                  ELSE "  - ") +
             "│" + (IF    ttServ.ContryName NE "" 
                      AND loan.cont-type NE "а/о" THEN ENTRY(1,STRING(ttServ.ContryName,"x(15)"),"~n")
                                                  ELSE "       -       "/*FILL(" ",15)*/) +
             "│" + (IF    ttServ.GTDNum  NE "" 
                      AND loan.cont-type NE "а/о" THEN STRING(ttServ.GTDNum,"x(10)") 
                                                  ELSE "    -     ") +          
             "│" SKIP
          .
   
      /* печатаем наименование услуги на следующих строчках, 
      ** если оно оказалось длинным */
      IF    NUM-ENTRIES(ttServ.NameServ,"~n") GE 2 
         OR NUM-ENTRIES(ttServ.contryName,"~n")   GE 2
         OR NUM-ENTRIES(ttServ.Edin,"~n") GE 2
         THEN
      DO:
         mMaxRow = MAX(NUM-ENTRIES(ttServ.NameServ,"~n"),NUM-ENTRIES(ttServ.contry,"~n"),NUM-ENTRIES(ttServ.Edin,"~n")).
         DO mI = 2 TO mMaxRow:

            PUT STREAM sfact UNFORMATTED
                 SPACE(mLengBody) 
                 "│" + ( IF NUM-ENTRIES(ttServ.NameServ,"~n") GE mI THEN STRING(ENTRY(mI,ttServ.NameServ,'~n'),"x(30)")
                                                                    ELSE FILL(" ",30) ) +
                 "│" + FILL(" ",4)  +                                                    
                 "│" + FILL(" ",14) +
                 "│" + FILL(" ",13) +
                 "│" + FILL(" ",18) +
                 "│" + FILL(" ",18) +
                 "│" + FILL(" ",18) +
                 "│" + FILL(" ",15) +
                 "│" + FILL(" ",18) +
                 "│" + FILL(" ",18) +
                 "│" + FILL(" ",4)  +
                 "│" + ( IF NUM-ENTRIES(ttServ.ContryName,"~n") GE mI THEN STRING(ENTRY(mI,ttServ.ContryName,'~n'),"x(15)")
                                                                      ELSE FILL(" ",15) ) +
                 "│" + FILL(" ",10) +
                 "│" SKIP
            .
         END.
      END.
      IF NOT LAST(ttServ.NameServ) 
      THEN DO:
         PUT STREAM sfact UNFORMATTED
            SPACE(mLengBody)    "├──────────────────────────────┼────┼──────────────┼─────────────┼──────────────────┼──────────────────┼──────────────────┼───────────────┼──────────────────┼──────────────────┼────┼───────────────┼──────────┤" SKIP
            .
      END.
      ELSE DO:
            PUT STREAM sfact UNFORMATTED
               SPACE(mLengBody) "├──────────────────────────────┴────┴──────────────┴─────────────┴──────────────────┼──────────────────┼──────────────────┴───────────────┼──────────────────┼──────────────────┼────┴───────────────┴──────────┘" SKIP
               SPACE(mLengBody) "│Всего к оплате                                                                     │" + (IF mPriceSumm NE 0 then STRING(mPriceSumm,">>>,>>>,>>>,>>9.99") ELSE "                  ") + "│                                  │" + STRING(mNalogSumm,">>>,>>>,>>>,>>9.99") + "│" + STRING(mTotalSumm,">>>,>>>,>>>,>>9.99") + "│" SKIP
               SPACE(mLengBody) "└───────────────────────────────────────────────────────────────────────────────────┴──────────────────┴──────────────────────────────────┴──────────────────┴──────────────────┘" SKIP
               .
      END.
   END.
END.
          PUT STREAM sfact UNFORMATTED
SKIP(1)
SPACE(mLengBody)        "Руководитель организации _______________________ " bossFIO SPACE(65 - LENGTH(bossFIO)) "Гл.бухгалтер        _______________________ " accounterFIO SKIP
SPACE(mLengBody)        " или иное уполномоченное лицо     (подпись)       (ф.и.о.)                                                       или иное уполномоченное лицо     (подпись)        (ф.и.о.)          " SKIP.
IF accounterFIO ne FGetSetting("ФИОБух",?,"") THEN 
PUT STREAM sfact UNFORMATTED  
  SPACE(mLengBody) "(по приказу " orderInfo ")" SPACE(110 - mLengBody - LENGTH(orderInfo)) "(по приказу " orderInfo ")" SKIP(2).
                                                                                                   ELSE
PUT STREAM sfact UNFORMATTED  
  SPACE(mLengBody) "(по приказу " orderInfo ")" SKIP(1).                


PUT STREAM sfact UNFORMATTED  
SPACE(mLengBody)        " Индивидуальный предприниматель _____________________            ________________________________________________________ " SKIP
SPACE(mLengBody)        "                                                                  (реквизиты свидетельства о государственной регистрации  " SKIP
SPACE(mLengBody)        "                                                                   Индивидуального предпринимателя)                       " SKIP
        .
                                                                   


/*PUT STREAM sfact UNFORMATTED SKIP.
{signatur.i
   &stream="STREAM sfact"}*/
