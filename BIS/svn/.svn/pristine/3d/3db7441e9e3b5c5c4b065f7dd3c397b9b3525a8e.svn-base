/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ЗАО "Банковские информационные системы"
     Filename: SF-PRINT.i
      Comment: Собственно печать счетов-фактур
   Parameters:
         Uses:
      Used by: sf-print.p
      Created: 27.01.2005 Dasu
     Modified: 19/06/2006 ZIAL (0060144) АХД. Доработки по счетам-фактур. Патч d15.
     Modified: 28/06/2006 ZIAL (0063001) АХД. Доработка процедур печати счета-фактуры 
               и Книги Покупок
     Modified: 06/07/2006 ZIAL (0060144) АХД. Доработки по счетам-фактур. Патч d15.
     Modified: 16.01.2007 14:44 Бурягин Е.П. (ПИРБанк) 
     											1. Закоментировал печать горизонтальных линий в шапке СФ.
     											2. В определение выборки FOR EACH... в условии BREAK BY и вызове LAST-OF изменил поле.
     Modified: 17.01.2007 11:36 Бурягин Е.П. (ПИРБанк)
     											1. Заменил вызов signatur.i кодом формирования подписей.											
     											2. Закоментировал вывод текста "Приложение 1"
*/

/** Buryagin commented at 17.01.2007 11:39
PUT STREAM sfact UNFORMATTED
    PADL("Приложение N 1",mLeng) SKIP
    PADL("к Правилам ведения журналов учета",mLeng) SKIP
    PADL("полученных и выставленных счетов-фактур,",mLeng) SKIP
    PADL("книг покупок и книг продаж при расчетах по",mLeng) SKIP
    PADL("налогу на добавленную стоимость,",mLeng) SKIP
    PADL("утвержденным постановлением Правительства",mLeng) SKIP
    PADL("Российской Федерации от 2 декабря 2000 г. N 914",mLeng) SKIP
    PADL("(в редакции постановления Правительства",mLeng) SKIP
    PADL("Российской Федерации от 15 марта 2001 г. N 189)",mLeng) SKIP
    PADL("(с изменениями от 27 июля 2002 г., 16 февраля 2004 г., 11 мая 2006 г.)",mLeng) 
    SKIP(2).
*/

IF CAN-FIND(FIRST ttServ NO-LOCK) 
THEN DO:
  FOR EACH ttServ 
      NO-LOCK
      BREAK BY ttServ.Quant:
IF trim(ttServ.Edin) ne "шт" and trim(mSFOtprav) eq "ОН ЖЕ" THEN mSFOtprav = "──".
IF trim(ttServ.Edin) ne "шт" and ((trim(mSFPoluch) eq "ОН ЖЕ") 
                                   or 
                                  (trim(mSFPoluch) eq trim(mSFBuyer))
                                 ) THEN assign mSFPoluch = "──" 
                                               mSFPoluchAddr = "".
END.
END.

PUT STREAM sfact UNFORMATTED
   SKIP(2)
   SPACE(mLengBody + mLs) "СЧЕТ-ФАКТУРА № " + STRING(mSFNum,"x(14)") +  ' от "' + (IF mSfDate NE ? THEN STRING(DAY(mSFDate),"99") ELSE "  ") + '"' + (IF mSfDate NE ? THEN (STRING(ENTRY(MONTH(mSFDate),Monthes)) + "  " + STRING(YEAR(mSFDate)) + "г.") ELSE "") SKIP
   /* SPACE(mLengBody + mLs) "               ──────────────      ──  ──────────────────────────────────────────" SKIP(2) */
   SPACE(mLengBody + mLs) "Продавец " + mSFSeller SKIP
   /* SPACE(mLengBody + mLs) "        ─────────────────────────────────────────────────────────────────────────" SKIP */
   SPACE(mLengBody + mLs) "Адрес " + mSFSellerAddr  SKIP
   /* SPACE(mLengBody + mLs) "     ────────────────────────────────────────────────────────────────────────────" SKIP */
   SPACE(mLengBody + mLs) "ИНН/КПП продавца " + mSFSellerINN + "/" + mSFSellerKPP SKIP
   /* SPACE(mLengBody + mLs) "                ─────────────────────────────────────────────────────────────────" SKIP */
   SPACE(mLengBody + mLs) "Грузоотправитель и его адрес " + mSFOtprav + " " + mSFOtpravAddr SKIP
   /* SPACE(mLengBody + mLs) "                            ─────────────────────────────────────────────────────" SKIP */
   SPACE(mLengBody + mLs) "Грузополучатель и его адрес " + mSFPoluch + " " + mSFPoluchAddr SKIP
   /* SPACE(mLengBody + mLs) "                           ──────────────────────────────────────────────────────" SKIP */
   SPACE(mLengBody + mLs) "К платёжно-расчётному документу № " + STRING(mOpNum,"x(10)") + " от " + (IF mOpDate NE ? THEN STRING(mOpDate,"99/99/9999") ELSE " ") SKIP
   /* SPACE(mLengBody + mLs) "                                 ──────────    ──────────────────────────────────" SKIP */
   SPACE(mLengBody + mLs) "Покупатель " + mSFBuyer SKIP
   /* SPACE(mLengBody + mLs) "          ───────────────────────────────────────────────────────────────────────" SKIP */
   SPACE(mLengBody + mLs) "Адрес " + mSFBuyerAddr  SKIP
   /* SPACE(mLengBody + mLs) "     ────────────────────────────────────────────────────────────────────────────" SKIP */
   SPACE(mLengBody + mLs) "ИНН/КПП покупателя " + mSFBuyerINN + "/" + mSFBuyerKPP SKIP(2)
   /* SPACE(mLengBody + mLs) "                  ───────────────────────────────────────────────────────────────" SKIP */
.

IF CAN-FIND(FIRST ttServ NO-LOCK) 
THEN DO:

   PUT STREAM sfact UNFORMATTED
      /*шапка таблички*/                                                                   
      SPACE(mLengBody) "┌──────────────────────────────┬─────────┬─────────────┬──────────────────┬──────────────────┬──────────────────┬───────────┬──────────────────┬──────────────────┬────────────┬──────────┐" SKIP
      SPACE(mLengBody) "│    НАИМЕНОВАНИЕ ТОВАРА       │ЕДИНИЦА  │ КОЛИЧЕСТВО  │  ЦЕНА (ТАРИФ)    │СТОИМОСТЬ ТОВАРОВ │    В ТОМ ЧИСЛЕ   │ НАЛОГОВАЯ │   СУММА НАЛОГА   │СТОИМОСТЬ ТОВАРОВ │   СТРАНА   │  НОМЕР   │" SKIP
      SPACE(mLengBody) "│ (описание выполненных работ, │ИЗМЕРЕНИЯ│             │  ЗА ЕДИНИЦУ      │ (РАБОТ, УСЛУГ),  │       АКЦИЗ      │  СТАВКА   │                  │ (РАБОТ, УСЛУГ),  │ ПРОИСХОЖ-  │ТАМОЖЕННОЙ│" SKIP
      SPACE(mLengBody) "│       оказанных услуг),      │         │             │  ИЗМЕРЕНИЯ       │  ИМУЩЕСТВЕННЫХ   │                  │           │                  │  ИМУЩЕСТВЕННЫХ   │    ДЕНИЯ   │ДЕКЛАРАЦИИ│" SKIP
      SPACE(mLengBody) "│     имущественного права     │         │             │                  │      ПРАВ,       │                  │           │                  │      ПРАВ,       │            │          │" SKIP
      SPACE(mLengBody) "│                              │         │             │                  │ ВСЕГО БЕЗ НАЛОГА │                  │           │                  │ ВСЕГО С УЧЕТОМ   │            │          │" SKIP
      SPACE(mLengBody) "│                              │         │             │                  │                  │                  │           │                  │      НАЛОГА      │            │          │" SKIP      
      SPACE(mLengBody) "│──────────────────────────────┼─────────┼─────────────┼──────────────────┼──────────────────┼──────────────────┼───────────┼──────────────────┼──────────────────┼────────────┼──────────│" SKIP
      SPACE(mLengBody) "│              1               │    2    │      3      │        4         │        5         │        6         │     7     │        8         │        9         │     10     │    11    │" SKIP
      SPACE(mLengBody) "├──────────────────────────────┼─────────┼─────────────┼──────────────────┼──────────────────┼──────────────────┼───────────┼──────────────────┼──────────────────┼────────────┼──────────┤" SKIP
   .                                                        
   ASSIGN
      mNalogSumm = 0
      mTotalSumm = 0
   .
   FOR EACH ttServ 
      NO-LOCK
      /** Buryagin comment at 16.01.2007 14:58 
      BREAK BY ttServ.NameServ:
      */
      /** Buryagin added at 16.01.2007 14:58 */
      BREAK BY ttServ.Quant:
      /** Buryagin end */
      ASSIGN   
         mNalogSumm = mNalogSumm + ttServ.NalogSumm
         mTotalSumm = mTotalSumm + ttServ.TotalSumm
      .


      /* печатаем данные по услуге */
      PUT STREAM sfact UNFORMATTED
             SPACE(mLengBody) 
             "│" + STRING(ENTRY(1,ttServ.NameServ,'~n'),"x(30)") + 
             "│" + (IF length(ttServ.Edin) > 0 THEN STRING(ttServ.Edin, "x(9)") ELSE "       ──") +
             "│" + (IF ttServ.Quant > 0     THEN STRING(ttServ.Quant,">>>>>>>>>9.99")          ELSE "           ──") +
             "│" + (IF ttServ.Price > 0     THEN STRING(ttServ.Price,">>>,>>>,>>>,>>9.99")     ELSE "                ──") +
             "│" + (IF ttServ.SummOut > 0   THEN STRING(ttServ.SummOut,">>>,>>>,>>>,>>9.99")   ELSE "                ──") +
             "│" + (IF ttServ.Akciz > 0     THEN STRING(ttServ.Akciz,">>>,>>>,>>>,>>9.99")     ELSE "                ──") +
             "│" + (IF ttServ.Nlog > 0      THEN STRING(ttServ.Nlog,">>>>,>>9.99")             ELSE "         ──") +
             "│" + (IF ttServ.NalogSumm > 0 THEN STRING(ttServ.NalogSumm,">>>,>>>,>>>,>>9.99") ELSE "                ──") +
             "│" + (IF ttServ.TotalSumm > 0 THEN STRING(ttServ.TotalSumm,">>>,>>>,>>>,>>9.99") ELSE "                ──") +
             "│" + (IF length(ttServ.Contry) > 0 THEN STRING(ttServ.Contry,"x(12)") ELSE "          ──") +
             "│" + (IF length(ttServ.GTDNum) > 0 THEN STRING(ttServ.GTDNum,"x(10)") ELSE "        ──") + 
             "│" SKIP
          .
   
      /* печатаем наименование услуги на следующих строчках, 
      ** если оно оказалось длинным */
      
      
      IF NUM-ENTRIES(ttServ.NameServ,"~n") GE 2 
         THEN DO mI = 2 TO NUM-ENTRIES(ttServ.NameServ,"~n"):

          PUT STREAM sfact UNFORMATTED
                 SPACE(mLengBody) 
                 "│" + STRING(ENTRY(mI,ttServ.NameServ,'~n'),"x(30)") + 
                 "│" + FILL(" ",9)  +
                 "│" + FILL(" ",13) +
                 "│" + FILL(" ",18) +
                 "│" + FILL(" ",18) +
                 "│" + FILL(" ",18) +
                 "│" + FILL(" ",11) +
                 "│" + FILL(" ",18) +
                 "│" + FILL(" ",18) +
                 "│" + FILL(" ",12) + 
                 "│" + FILL(" ",10) + 
                 "│" SKIP
          .

      END.
      /** Buryagin comment this at 16.01.2007 14:55 
      IF NOT LAST(ttServ.NameServ) 
      */
      /** Buryagin added at 16.01.2007 14:55 */
      IF NOT LAST(ttServ.Quant)
      /** Buryagin end */
      THEN DO:
         PUT STREAM sfact UNFORMATTED 
      SPACE(mLengBody)  "├──────────────────────────────┼─────────┼─────────────┼──────────────────┼──────────────────┼──────────────────┼───────────┼──────────────────┼──────────────────┼────────────┼──────────┤" SKIP
         .

      END.
      ELSE DO:
         PUT STREAM sfact UNFORMATTED 
      SPACE(mLengBody)  "├──────────────────────────────┴─────────┴─────────────┴──────────────────┴──────────────────┴──────────────────┴───────────┼──────────────────┼──────────────────┼────────────┴──────────┘" SKIP
      SPACE(mLengBody)  "│Всего к оплате                                                                                                             │" + STRING(mNalogSumm,">>>,>>>,>>>,>>9.99") + "│" + STRING(mTotalSumm,">>>,>>>,>>>,>>9.99") + "│" SKIP
      SPACE(mLengBody)  "└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┴──────────────────┴──────────────────┘" SKIP
         .
      END.
   END.
END.



PUT STREAM sfact UNFORMATTED
   SKIP(2)
.
/** Buryagin commented at 17.01.2007 11:40
{signatur.i
   &stream="STREAM sfact"}
*/

/** Buryagin added at 17.01.2007 11:40 */
PUT STREAM sfact UNFORMATTED
	SPACE(mLengBody) "Руководитель организации _______________________ " bossFIO SPACE(65 - LENGTH(bossFIO)) "Гл.бухгалтер        _______________________ " accounterFIO SKIP
	SPACE(mLengBody) "                               (подпись)                 (ф.и.о)                                                                          (подпись)             (ф.и.о)" SKIP.

/** pir kuntash add 19.11.2007 */
IF accounterFIO ne FGetSetting("ФИОБух",?,"") THEN 
PUT STREAM sfact UNFORMATTED  
  SPACE(mLengBody) "(по приказу " orderInfo ")" SPACE(110 - mLengBody - LENGTH(orderInfo)) "(по приказу " orderInfo ")" SKIP(2).
  												 ELSE
PUT STREAM sfact UNFORMATTED  
  SPACE(mLengBody) "(по приказу " orderInfo ")" SKIP(2).		
/* kuntash end */  										 

PUT STREAM sfact UNFORMATTED
  SPACE(mLengBody) "Индивидуальный предприниматель _______________________        _______________________         ______________________________________________________________" SKIP
  SPACE(mLengBody) "                                     (подпись)                       (ф.и.о)                      (реквизиты свидетельства о государственной регистрации" SKIP
  SPACE(mLengBody) "                                                                                                               индивидуального предпринимателя)" SKIP.