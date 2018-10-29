{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2005 ЗАО "Банковские информационные системы"
     Filename: BUYPRN.P
      Comment: Печать книги покупок
   Parameters:
         Uses: 
      Used by:
      Created: 27.01.2005 Dasu 0041881
     Modified: 28/06/2006 ZIAL (0063001) АХД. Доработка процедур печати счета-фактуры 
               и Книги Покупок
     Modified: Бурягин 12.04.2007 16:59
               Заменил стандартные подписи на подписи, необходимые нашей бухгалтерии.
*/

{globals.i}
{intrface.get xclass}
{intrface.get instrum}
{intrface.get tparam}
{intrface.get axd}
{intrface.get asset}
{intrface.get strng }
{intrface.get tmess }

{bookprn.i }

DEF VAR mVal AS DECIMAL NO-UNDO EXTENT 9.
DEF VAR mValStr AS CHAR NO-UNDO.

/*ШАПКА КНИГИ*/
PUT STREAM sfact UNFORMATTED
   FILL(" ",40) + "КНИГА ПОКУПОК" SKIP(3)
   "Покупатель " + STRING(mBuyer,"x(35)") SKIP
   "           " + FILL("─",35) SKIP(2)
   "Идентификационный номер и код причины постановки на учет налогоплательщика-покупателя " + TRIM(STRING(mINN)) + "/" + STRING(mKPP,"x(15)") SKIP
   "                                                                                      " + FILL("─",35) SKIP(2)
   "Покупка за период с " + string(bDB.Beg-Date,"99/99/9999") + " по " + STRING(bDB.end-Date,"99/99/9999") SKIP
   "                    ──────────    ──────────" SKIP(3)
.
/*ШАПКА ТАБЛИЧКИ*/
PUT STREAM sfact UNFORMATTED
   "┌─────┬───────────────┬──────────┬──────────┬─────────────────────┬──────────────┬──────────────┬─────────────────┬─────────────┬───────────────────────────────────────────────────────────────────────────────────────────────────────────────┐" SKIP
   "│ №   │ Дата и номер  │  Дата    │   Дата   │Наименование продавца│ ИНН продавца │ КПП продавца │      Страна     │   Всего     │                                        В том числе                                                            │" SKIP
   "│     │ счета-фактуры │ оплаты   │ принятия │                     │              │              │  происхождения  │  покупок,   ├─────────────────────────────────────────────────────────────────────────────────────────────────┬─────────────┤" SKIP
   "│п/п  │   продавца    │ счета-   │ на учет  │                     │              │              │  товара. Номер  │ включая НДС │                 покупки, облагаемые налогом по ставке                                           │  покупки    │" SKIP
   "│     │               │ фактуры  │ товаров  │                     │              │              │    таможенной   │             ├───────────────────────────┬───────────────────────────┬─────────────┬───────────────────────────┤освобождаемые│" SKIP
   "│     │               │ продавца │ (работ,  │                     │              │              │    декларации   │             │       18 процентов        │       10 процентов        │ 0 процентов │       20 процентов*       │  от налога  │" SKIP   
   "│     │               │          │  услуг), │                     │              │              │                 │             ├─────────────┬─────────────┼─────────────┬─────────────┼─────────────┼─────────────┬─────────────┤             │" SKIP
   "│     │               │          │ имущест- │                     │              │              │                 │             │стоимость по-│ сумма НДС   │стоимость по-│ сумма НДС   │             │стоимость по-│ сумма НДС   │             │" SKIP
   "│     │               │          │ твенных  │                     │              │              │                 │             │купки без НДС│             │купки без НДС│             │             │купки без НДС│             │             │" SKIP
   "│     │               │          │   прав   │                     │              │              │                 │             │             │             │             │             │             │             │             │             │" SKIP
   "├─────┼───────────────┼──────────┼──────────┼─────────────────────┼──────────────┼──────────────┼─────────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┤" SKIP
   "│(1)  │      (2)      │    (3)   │   (4)    │         (5)         │      (5а)    │     (5б)     │       (6)       │     (7)     │     (8а)    │     (8б)    │     (9а)    │    (9б)     │     (10)    │    (11а)    │    (11б)    │     (12)    │" SKIP
   "├─────┼───────────────┼──────────┼──────────┼─────────────────────┼──────────────┼──────────────┼─────────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┤" SKIP
.
/*ДАННЫЕ ПО СТРОКАМ*/
mStrNum = 0.
FOR EACH bDL
   WHERE bDL.Data-ID EQ INTEGER(iDataBlock)
   NO-LOCK
   BREAK BY bDl.Data-ID
    BY bDl.Date1
    BY bDl.Date2:
   
   IF num-entries(bDL.Txt,"~n") < 9 or entry(9,bDL.Txt,"~n") <> "Исправ" THEN
   DO:
      ASSIGN
         mStrNum     = mStrNum + 1   
         mNamePostav = SplitStr(ENTRY(1,bDL.Txt,"~n"),
                                21,
                                "~n")

         mNums       = SplitStr(ENTRY(6,bDL.Txt,"~n") + " " 
                              + ENTRY(8,bDL.Txt,"~n"),
                                15,
                                "~n")
   
         mAmt        = SplitStr(STRING(bDL.Val[11],">>,>>>,>>9.99") + " " 
                              + ENTRY(7,bDL.Txt,"~n"),
                                13,
                                "~n")
      .
   
      PUT STREAM sfact UNFORMATTED
         "│" +
         STRING(mStrNum,"99999") + "│" +
         STRING(ENTRY(1,mNums,"~n"),"x(15)") + "│" +
         STRING(bDL.Sym2,"x(10)") + "│" +
         STRING(bDL.Sym1,"x(10)") + "│" +
         STRING(ENTRY(1,mNamePostav,"~n"),"x(21)") + "│" +
         STRING(ENTRY(2,bDL.Txt,"~n"),"x(14)") + "│" +
         STRING(ENTRY(3,bDL.Txt,"~n"),"x(14)") + "│" +
         STRING(ENTRY(4,bDL.Txt,"~n"),"x(10)") + " " + 
         STRING(ENTRY(5,bDL.Txt,"~n"),"x(6)") + "│" +
         STRING(ENTRY(1,mAmt,"~n"),"x(13)") + "│" +
         STRING(bDL.Val[1],">>,>>>,>>9.99") + "│" +
         STRING(bDL.Val[2],">>,>>>,>>9.99") + "│" +
         STRING(bDL.Val[3],">>,>>>,>>9.99") + "│" +
         STRING(bDL.Val[4],">>,>>>,>>9.99") + "│" +
         STRING(bDL.Val[5],">>,>>>,>>9.99") + "│" +
         STRING(bDL.Val[7],">>,>>>,>>9.99") + "│" +
         STRING(bDL.Val[8],">>,>>>,>>9.99") + "│" +
         STRING(bDL.Val[9],">>,>>>,>>9.99") + "│"
         SKIP
      .
      IF MAX(NUM-ENTRIES(mNamePostav,"~n"),
            NUM-ENTRIES(mNums,"~n"),
            NUM-ENTRIES(mAmt,"~n")) GE 2 
      THEN DO i = 2 TO MAX(NUM-ENTRIES(mNamePostav,"~n"),
                           NUM-ENTRIES(mNums,"~n"),
                           NUM-ENTRIES(mAmt,"~n")):
         PUT STREAM sfact UNFORMATTED
            "│" +
            STRING("     ") + "│" +
            STRING((IF i LE NUM-ENTRIES(mNums,"~n") 
                    THEN ENTRY(i,mNums,"~n") 
                    ELSE " "),"x(15)") + "│" +
            STRING(" ","x(10)") + "│" +
            STRING(" ","x(10)") + "│" +
            STRING((IF i LE NUM-ENTRIES(mNamePostav,"~n") 
                    THEN ENTRY(i,mNamePostav,"~n") 
                    ELSE " "),"x(21)") + 
            "│              │              │                 │" + 
            STRING((IF i LE NUM-ENTRIES(mAmt,"~n") 
                    THEN ENTRY(i,mAmt,"~n") 
                    ELSE " "),"x(13)") +
            "│             │             │             │             │             │             │             │             │"
         
         
            SKIP
         .
      END.
      ACCUMULATE bDL.Val[11] (TOTAL).
      ACCUMULATE bDL.Val[1] (TOTAL).
      ACCUMULATE bDL.Val[2] (TOTAL).
      ACCUMULATE bDL.Val[3] (TOTAL).
      ACCUMULATE bDL.Val[4] (TOTAL).
      ACCUMULATE bDL.Val[5] (TOTAL).
      ACCUMULATE bDL.Val[7] (TOTAL).
      ACCUMULATE bDL.Val[8] (TOTAL).
      ACCUMULATE bDL.Val[9] (TOTAL).
   
      IF NOT LAST-OF(bDl.Data-ID) 
         THEN PUT STREAM sfact UNFORMATTED
            "├─────┼───────────────┼──────────┼──────────┼─────────────────────┼──────────────┼──────────────┼─────────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┤" SKIP
         .   
   
   END.
END.
/*ИТОГО*/
PUT STREAM sfact UNFORMATTED
   "├─────┴───────────────┴──────────┴──────────┴─────────────────────┴──────────────┴──────────────┴─────────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┤" SKIP
   "│                                                                                                           Всего:│" + 
   STRING((ACCUM TOTAL bDL.Val[11]),">>,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[1]),">>,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[2]),">>,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[3]),">>,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[4]),">>,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[5]),">>,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[7]),">>,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[8]),">>,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[9]),">>,>>>,>>9.99") + "│" skip
   "└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┘" SKIP
.

ASSIGN
   mVal[1] = ACCUM TOTAL bDL.Val[11]
   mVal[2] = ACCUM TOTAL bDL.Val[1]
   mVal[3] = ACCUM TOTAL bDL.Val[2]
   mVal[4] = ACCUM TOTAL bDL.Val[3]
   mVal[5] = ACCUM TOTAL bDL.Val[4]
   mVal[6] = ACCUM TOTAL bDL.Val[4]
   mVal[7] = ACCUM TOTAL bDL.Val[7]
   mVal[8] = ACCUM TOTAL bDL.Val[8]
   mVal[9] = ACCUM TOTAL bDL.Val[9]
   mValStr = STRING(mVal[1]) + "," + STRING(mVal[2]) + "," + STRING(mVal[3]) + "," + 
             STRING(mVal[4]) + "," + STRING(mVal[5]) + "," + STRING(mVal[6]) + "," + 
             STRING(mVal[7]) + "," + STRING(mVal[8]) + "," + STRING(mVal[9])
.
/*ПОДВАЛ*/
/** Buryagin commented at 12.04.2007 16:54
&UNDEFINE signatur_i
{signatur.i 
   &stream="STREAM sfact"}
*/
   
/** Buryagin add at 12.04.2007 16:55 */
/*ПОДВАЛ*/
PUT STREAM sfact UNFORMATTED
   SKIP(3)
   "Главный бухгалтер                      " + mBuhName SKIP
   "                  ──────────────────── ───────────────────────────────────────" SKIP
   "                      (подпись)                        (ф. и. о.)             " SKIP(2)
   "Индивидуальный предприниматель ____________________ _______________________________________" SKIP 
   "                                     (подпись)                        (ф. и. о.)             " SKIP(2)
   "Реквизиты свидетельства о государственной" SKIP
   "регистрации индивидуального предпринимателя ____________________________________________________" SKIP(3)
   "_________________________" SKIP
   "* До завершения расчетов по товарам (работам, услугам), отгруженным (выполненным, оказаным) до 1 января 2004 г." SKIP
.
/** Buryagin end */

IF CAN-FIND(FIRST bDl WHERE entry(9,bDL.Txt,"~n") EQ "Аннулир") THEN
DO:

   pick-value = 'yes'. /* поведение по умолчанию */
   RUN Fill-SysMes IN h_tmess (
      "", "", "4",
      "Печатать аннулированные счет-фактуры?"
   ).
   IF pick-value EQ "yes" THEN 
   DO:
      PAGE.
      run BuyAddPage(iDataBlock,mValStr,PAGE-NUMBER(sfact)).
   END.
END.
{preview.i &STREAM="STREAM sfact"}
{intrface.del}
