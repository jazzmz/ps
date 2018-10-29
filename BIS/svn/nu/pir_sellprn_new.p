/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2005 ЗАО "Банковские информационные системы"
1     Filename: SELLPRN.P
      Comment: Печать книги продаж
   Parameters:
         Uses:
      Used by:
      Created: 21.02.2005 Dasu 0041882
*/
{globals.i}
{intrface.get xclass }
{intrface.get tmess }

DEF VAR mStrOfList AS INT64    NO-UNDO INIT   29.   /* Номер строки при печати */
DEF VAR mAdvance   AS LOGICAL    NO-UNDO.
def var bdlVal as CHAR EXTENT 9 NO-UNDO.  

def var mSurrOp as char no-undo.
def var mI as INT no-undo.

DEFINE VAR temp-amt-rub     AS DEC NO-UNDO.     /*стоимость*/
DEFINE VAR temp-amt-rub-nds AS DEC NO-UNDO. /*стоимость без ндс*/
DEFINE VAR temp-ao          as LOG NO-UNDO.


{bookprn-new.i }


PROCEDURE Sign-Prn.
/*   /*ПОДВАЛ*/
   &UNDEFINE signatur_i
   {signatur.i
      &stream="STREAM sfact"}           */

PUT STREAM sfact UNFORMATTED
"Руководитель организации                          Шлогина Е.Г.       " skip
"или иное уполномоченное лицо   ___________   _______________________ " skip
"                                 (подпись)           (ф.и.о.)        " skip
"Индивидуальный предприниматель ___________   _____________________   " skip
"                                 (подпись)          (ф.и.о.)         " skip
"Реквизиты свидетельства о государственной                            " skip
"регистрации индивидуального предпринимателя  ______________________  " skip(2)

"--------------------------------" skip
"<*> До завершения расчетов по товарам (работам, услугам), отгруженным (выполненным, оказанным) до 1 января 2004 г." skip.


END PROCEDURE.
PUT STREAM sfact UNFORMATTED
    PADL("Приложение N 5",220) SKIP
    PADL("к постановлению Правительства",220) SKIP
    PADL("Российской Федерации",220) SKIP
    PADL("от 26.12.11  № 1137",220) SKIP
    PADL("────────    ────",220) SKIP
    SKIP(2).

/*ШАПКА КНИГИ*/
PUT STREAM sfact UNFORMATTED
   FILL(" ",60) + "КНИГА ПРОДАЖ" SKIP(2)
   FILL(" ",40) + "Продавец " + STRING(mBuyer,"x(230)") SKIP
   FILL(" ",40) + "         " + FILL("─",LENGTH(mBuyer)) SKIP(0)
   FILL(" ",40) + "Идентификационный номер и код причины постановки "  SKIP
   FILL(" ",40) + "на учет налогоплательщика-продавца " + TRIM(STRING(mINN)) + "/" + STRING(mKPP,"x(15)") SKIP
   FILL(" ",40) + "                                   " + FILL("─",20) SKIP(0)
   FILL(" ",40) + "Продажа за период с " + string(bDB.Beg-Date,"99/99/9999") + " по " + STRING(bDB.end-Date,"99/99/9999") SKIP
   FILL(" ",40) + "                    ──────────    ──────────" SKIP(1)
.
/*ШАПКА ТАБЛИЧКИ*/
PUT STREAM sfact UNFORMATTED
   "┌───────────────┬───────────────┬───────────────┬───────────────┬─────────────────────┬────────────┬────────────┬────────┬───────────────┬───────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐" SKIP
   "│ Дата и номер  │ Номер и дата  │ Номер и дата  │ Номер и дата  │    Наименование     │    ИНН     │    КПП     │ Дата   │ Стоимость     │                                          В том числе                                                              │" SKIP
   "│ счета-фактуры │ исправления   │ корректиро-   │ исправления   │     покупателя      │ покупателя │ покупателя │оплаты  │ продаж,       ├─────────────────────────────────────────────────────────────────────────────────────────────────────┬─────────────┤" SKIP
   "│   продавца    │ счета-фактуры │ вочного       │ корректиро-   │                     │            │            │счета-  │ включая НДС,- │                            стоимость продаж, облагаемых налогом по ставке                           │стоимость    │" SKIP
   "│               │ продавца      │ счета-фактуры │ вочного       │                     │            │            │фактуры │ всего         ├───────────────────────────────┬───────────────────────────┬─────────────┬───────────────────────────┤продаж,      │" SKIP
   "│               │               │ продавца      │ счета-фактуры │                     │            │            │продавца│               │         18 процентов          │       10 процентов        │ 0 процентов │       20 процентов*       │освобождаемых│" SKIP
   "│               │               │               │ продавца      │                     │            │            │        │               ├───────────────┬───────────────┼─────────────┬─────────────┼─────────────┼─────────────┬─────────────┤от налога    │" SKIP
   "│               │               │               │               │                     │            │            │        │               │ стоимость     │  сумма НДС    │  стоимость  │ сумма НДС   │             │  стоимость  │ сумма НДС   │             │" SKIP
   "│               │               │               │               │                     │            │            │        │               │  продаж       │               │   продаж    │             │             │   продаж    │             │             │" SKIP
   "│               │               │               │               │                     │            │            │        │               │  без НДС      │               │   без НДС   │             │             │   без НДС   │             │             │" SKIP
   "├───────────────┼───────────────┼───────────────┼───────────────┼─────────────────────┼────────────┼────────────┼────────┼───────────────┼───────────────┼───────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┤" SKIP
   "│     (1)       │     (1а)      │     (1б)      │     (1в)      │         (2)         │    (3)     │    (3а)    │  (3б)  │      (4)      │      (5а)     │      (5б)     │     (6а)    │     (6б)    │     (7)     │     (8а)    │     (8б)    │     (9)     │" SKIP
   "├───────────────┼───────────────┼───────────────┼───────────────┼─────────────────────┼────────────┼────────────┼────────┼───────────────┼───────────────┼───────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┤" SKIP
.
def var ispr as char no-undo.
def var mKorr1 as char no-undo.
def var mKorr2 as char no-undo.
def var mKorr3 as char no-undo.
def buffer sf for loan .
def buffer t1 for term-obl.
def buffer t2 for term-obl.
def var amt1 as dec no-undo.
def var nds1 as dec no-undo.
def var amt2 as dec no-undo.
def var nds2 as dec no-undo.
def var tot1 as dec no-undo.
def var tot2 as dec no-undo.
def buffer b_dl for bdl.
/*ДАННЫЕ ПО СТРОКАМ*/
FOR EACH bDL
   WHERE bDL.Data-ID EQ INT64(iDataBlock)
   NO-LOCK,
   first sf where sf.contract = "sf-out" and sf.cont-code = bDl.sf no-lock 
   BREAK BY bDl.Data-ID
         BY sf.doc-num
	 BY bDl.Date2
/*         BY bDl.Date1*/

         :

/*

   IF ( NUM-ENTRIES(bDL.Txt,"~n") < 9 OR ENTRY(9,bDL.Txt,"~n") <> "Исправ") AND
      /* Или 13 есть и пустой,  или его нет */
      ( NUM-ENTRIES(bDL.Txt,"~n") < 13  OR
       ( NUM-ENTRIES(bDL.Txt,"~n") >= 13  AND  ENTRY(13,bDL.Txt,"~n") EQ "" ))
      THEN
*/
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
         mAmt        = SplitStr(STRING(bDL.Val[11],">>>>,>>>,>>9.99") + " "
                              + ENTRY(7,bDL.Txt,"~n"),
                                15,
                                "~n")
         mAdvance    = ENTRY(4,bDL.Txt,"~n") EQ "Аванс"
      .
/*      find first sf where sf.contract = "sf-out" and sf.cont-code = bDl.sf no-lock no-error.*/
      ispr = GetXattrValue("loan","sf-out," + bDl.sf,"Исправ").
      
      find loan where loan.contract = entry(1,ispr) and loan.cont-code = entry(2,ispr) no-lock no-error.
      mKorr1 = "".
      mKorr2 = "".
      mKorr3 = "".
      if avail loan then
      do:

         mNums       = SplitStr(string(loan.conf-date,"99/99/99") + " " + loan.doc-num,15,"~n").
         mKorr1      = SplitStr(GetXattrValueEx("loan",sf.contract + "," + sf.cont-code,"НомДатКорр",""),15,"~n").
         mKorr2      = SplitStr(string(sf.conf-date,"99/99/99") + " " + sf.doc-num,15,"~n").
         if loan.loan-status = "Аннулир" then
         do:
            ispr = GetXattrValue("loan",sf.contract + "," + sf.cont-code,"Исправ").
            mKorr3      = SplitStr(GetXattrValueEx("loan",ispr,"НомДатКорр",""),15,"~n").
         end.

         for each t1 of sf no-lock:
             accumulate t1.amount-of-payment (total).
             accumulate t1.int-amt (total).
         end.
         for each t2 of loan  no-lock:
             accumulate t2.amount-of-payment (total).
             accumulate t2.int-amt (total).
         end.
	         bDL.Val[11] = (accum total t1.amount-of-payment) + (accum total t1.int-amt) - (accum total t2.amount-of-payment) - (accum total t2.int-amt).
         mAmt        = SplitStr(STRING(bDL.Val[11],"->>>,>>>,>>9.99") + " "
                              + ENTRY(7,bDL.Txt,"~n"),
                                15,
                                "~n").
         for each t1 of sf where t1.rate = 18 no-lock:
             accumulate t1.amount-of-payment (total).
             accumulate t1.int-amt (total).
         end.
         for each t2 of loan where t2.rate = 18  no-lock:
             accumulate t2.amount-of-payment (total).
             accumulate t2.int-amt (total).
         end.

         bDL.Val[1] = (accum total t1.amount-of-payment) - (accum total t2.amount-of-payment).
         bDL.Val[2] = (accum total t1.int-amt) - (accum total t2.int-amt).

         for each t1 of sf where t1.rate = 10 no-lock:
             accumulate t1.amount-of-payment (total).
             accumulate t1.int-amt (total).
         end.
         for each t2 of loan where t2.rate = 10  no-lock:
             accumulate t2.amount-of-payment (total).
             accumulate t2.int-amt (total).
         end.
         bDL.Val[3] = (accum total t1.amount-of-payment) - (accum total t2.amount-of-payment).
         bDL.Val[4] = (accum total t1.int-amt) - (accum total t2.int-amt).

         for each t1 of sf where t1.rate = 20 no-lock:
             accumulate t1.amount-of-payment (total).
             accumulate t1.int-amt (total).
         end.
         for each t2 of loan where t2.rate = 20  no-lock:
             accumulate t2.amount-of-payment (total).
             accumulate t2.int-amt (total).
         end.
         bDL.Val[7] = (accum total t1.amount-of-payment) - (accum total t2.amount-of-payment).
         bDL.Val[8] = (accum total t1.int-amt) - (accum total t2.int-amt).

         for each t1 of sf where t1.rate = 0 no-lock:
             accumulate t1.amount-of-payment (total).
             accumulate t1.int-amt (total).
         end.
         for each t2 of loan where t2.rate = 0  no-lock:
             accumulate t2.amount-of-payment (total).
             accumulate t2.int-amt (total).
         end.
         bDL.Val[9] = (accum total t1.amount-of-payment) - (accum total t2.amount-of-payment).
      end.
      /*  
      else
      do:

         temp-ao = false.
         temp-amt-rub-nds = 0.


         for each t1 of sf where t1.rate = 18 no-lock:
             accumulate t1.amount-of-payment (total).
             accumulate t1.int-amt (total).
  if mAdvance then do:
                 DO mI=1 TO NUM-ENTRIES(mSurrOp,";"):

                       
         	 if Entry(2,(GetXAttrValueEx("op", ENTRY(1,ENTRY(mI,mSurrOp,";")), "PIRSFInfo", ""))) = 'а/о' /*если документ по авансовой оплате то смотрим */
    	            then do:
 	              	   if DEC(GetXAttrValueEx("op", ENTRY(1,ENTRY(mI,mSurrOp,";")), "PIRSFAmount", "")) = t1.amt-rub then temp-amt-rub-nds = temp-amt-rub-nds + t1.amount-of-payment.
/*                      MESSAGE sf.doc-num bDL.Val[1] (accum total t1.amount-of-payment) (accum total t1.int-amt) VIEW-AS ALERT-BOX.*/
 	            end. 
 	            temp-ao = true.
    end.             	
            END.



        END.

         bDL.Val[1] = (accum total t1.amount-of-payment) - (accum total t1.int-amt) - temp-amt-rub-nds.





      end.
      */

 temp-ao = false.
 mSurrOp = "".
 temp-amt-rub-nds = 0.

 if mAdvance then do:
      mSurrOp = GetLinks(sf.class-code,             /* ID класса     */
                sf.contract + "," + sf.cont-code, /* ID(cуррогат) объекта   */
                ?,                                    /* Направление связи: s | t | ?         */
                "sf-op-pay",                          /* Список кодов линков в CAN-DO формате */
                ";",                                  /* Разделитель результирующего списка   */
                ?).

         If mSurrOp <> "" and mSurrOp <> ? then do:
                 DO mI=1 TO NUM-ENTRIES(mSurrOp,";"):
                  
         	   if Entry(2,(GetXAttrValueEx("op", ENTRY(1,ENTRY(mI,mSurrOp,";")), "PIRSFInfo", ""))) = 'а/о' /*если документ по авансовой оплате то смотрим */
    	            then do:
    	                   find first op-entry where op-entry.op = INT(ENTRY(1,ENTRY(mI,mSurrOp,";"))) NO-LOCK NO-ERROR.
 	              	   temp-amt-rub-nds = temp-amt-rub-nds + op-entry.amt-rub.
                           temp-ao = true.

 	            end. 
 	        end.   
	       end.          	
     end.
   
     bDL.VAL[1] = bDL.VAL[1] - temp-amt-rub-nds.

     if bDL.VAL[1] < 0 then message sf.doc-num mSurrOp VIEW-AS ALERT-BOX.


/*
message sf.doc-num 
bDL.Val[6] bDL.Val[7] bDL.Val[8]
view-as alert-box.
*/ 

      if bDL.VAL[1] = 0 then bdlval[1] = "               ". else bdlval[1] = STRING(bDL.Val[1],"->>>,>>>,>>9.99").

      if bDL.VAL[2] = 0 then bdlval[2] = "               ". else bdlval[2] = STRING(bDL.Val[2],"->>>,>>>,>>9.99").

      if bDL.VAL[3] = 0 then bdlval[3] = "             ". else bdlval[3] = STRING(bDL.Val[3],"->,>>>,>>9.99").

      if bDL.VAL[4] = 0 then bdlval[4] = "             ". else bdlval[4] = STRING(bDL.Val[4],"->,>>>,>>9.99").

      if bDL.VAL[5] = 0 then bdlval[5] = "             ". else bdlval[5] = STRING(bDL.Val[5],"->,>>>,>>9.99").
/*      if bDL.VAL[6] = 0 then bdlval[6] = "             ". else bdlval[6] = STRING(bDL.Val[6],"->,>>>,>>9.99").*/

      if bDL.VAL[7] = 0 then bdlval[7] = "             ". else bdlval[7] = STRING(bDL.Val[7],"->,>>>,>>9.99").

      if bDL.VAL[8] = 0 then bdlval[8] = "             ".   else bdlval[8] = STRING(bDL.Val[8],"->,>>>,>>9.99").

      if bDL.VAL[9] = 0 then bdlval[9] = "             ". else bdlval[9] = STRING(bDL.Val[9],"->,>>>,>>9.99").

      IF mAdvance and not temp-ao THEN ASSIGN
         bDL.Val[1] = 0
         bDL.Val[3] = 0
      .
      PUT STREAM sfact UNFORMATTED
         "│" +
         STRING(ENTRY(1,mNums,"~n"),"x(15)") + "│" +

         STRING(ENTRY(1,mKorr1,"~n"),"x(15)") + "│" +
         STRING(ENTRY(1,mKorr2,"~n"),"x(15)") + "│" +
         STRING(ENTRY(1,mKorr3,"~n"),"x(15)") + "│" +


         STRING(ENTRY(1,mNamePostav,"~n"),"x(21)") + "│" +
         (if TRIM(REPLACE(STRING(ENTRY(2,bDL.Txt,"~n"),"x(12)"),"0"," ")) <> "" THEN 
         STRING(ENTRY(2,bDL.Txt,"~n"),"x(12)") else
         FILL(" ",12))
         + "│" +
         (if TRIM(REPLACE(STRING(ENTRY(3,bDL.Txt,"~n"),"x(12)"),"0"," ")) <> "" THEN 
         STRING(ENTRY(3,bDL.Txt,"~n"),"x(12)") else
         FILL(" ",12)) + "│" +
         STRING(bDL.Sym2,"x(8)") + "│" +
         STRING(ENTRY(1,mAmt,"~n"),"x(15)") + "│" +

         (IF mAdvance and not temp-ao
          THEN (" " + FILL(" ",13) + " ")
          ELSE 
          (bDLVal[1])) + "│" +
         (bDLVal[2]) + "│" +

         (IF mAdvance
          THEN (" " + FILL(" ",11) + " ")
          ELSE 
          (bDLVal[3])) + "│" +
          (bDLVal[4]) + "│" +
          (bDLVal[5]) + "│" +
          (bDLVal[7]) + "│" +
          (bDLVal[8]) + "│" +
          (bDLVal[9]) + "│"
         SKIP
      .
      RUN CalcStrike(mStrOfList + 1, 63, NO, OUTPUT mStrOfList).

      IF MAX(NUM-ENTRIES(mNamePostav,"~n"),

             NUM-ENTRIES(mKorr1,"~n"),
             NUM-ENTRIES(mKorr2,"~n"),
             NUM-ENTRIES(mKorr3,"~n"),

             NUM-ENTRIES(mNums,"~n"),
             NUM-ENTRIES(mAmt,"~n")) GE 2
      THEN DO i = 2 TO MAX(NUM-ENTRIES(mNamePostav,"~n"),

                           NUM-ENTRIES(mKorr1,"~n"),
                           NUM-ENTRIES(mKorr2,"~n"),
                           NUM-ENTRIES(mKorr3,"~n"),

                           NUM-ENTRIES(mNums,"~n"),
                           NUM-ENTRIES(mAmt,"~n")):
         PUT STREAM sfact UNFORMATTED
            "│" +
            STRING((IF i LE NUM-ENTRIES(mNums,"~n")
                   THEN ENTRY(i,mNums,"~n")
                   ELSE " "),"x(15)") + "│" +


            STRING((IF i LE NUM-ENTRIES(mKorr1,"~n")
                   THEN ENTRY(i,mkorr1,"~n")
                   ELSE " "),"x(15)") + "│" +
            STRING((IF i LE NUM-ENTRIES(mKorr2,"~n")
                   THEN ENTRY(i,mkorr2,"~n")
                   ELSE " "),"x(15)") + "│" +
            STRING((IF i LE NUM-ENTRIES(mKorr3,"~n")
                   THEN ENTRY(i,mkorr3,"~n")
                   ELSE " "),"x(15)") + "│" +



            STRING((IF i LE NUM-ENTRIES(mNamePostav,"~n")
                   THEN ENTRY(i,mNamePostav,"~n")
                   ELSE " "),"x(21)") +
            "│            │            │        │" +
            STRING((IF i LE NUM-ENTRIES(mAmt,"~n")
                   THEN ENTRY(i,mAmt,"~n")
                   ELSE " "),"x(15)") +
            "│               │               │             │             │             │             │             │             │" SKIP
            SKIP
         .
         RUN CalcStrike(mStrOfList + 1, 63, NO, OUTPUT mStrOfList).
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

      IF NOT LAST-OF(bDl.Data-ID) THEN DO:
         PUT STREAM sfact UNFORMATTED
            "├───────────────┼───────────────┼───────────────┼───────────────┼─────────────────────┼────────────┼────────────┼────────┼───────────────┼───────────────┼───────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┤" SKIP
         .
         RUN CalcStrike(mStrOfList + 1, 63, NO, OUTPUT mStrOfList).
      END.
   END.
END.
/*ИТОГО*/
PUT STREAM sfact UNFORMATTED
            "├───────────────┴───────────────┴───────────────┴───────────────┴─────────────────────┴────────────┴────────────┴────────┼───────────────┼───────────────┼───────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┤" SKIP.
RUN CalcStrike(mStrOfList + 1, 63, NO, OUTPUT mStrOfList).
PUT STREAM sfact UNFORMATTED
            "│                                                                                                                  Всего:│" +
   STRING((ACCUM TOTAL bDL.Val[11]),"->>>,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[1]),"->>>,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[2]),"->>>,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[3]),"->,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[4]),"->,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[5]),"->,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[7]),"->,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[8]),"->,>>>,>>9.99") + "│" +
   STRING((ACCUM TOTAL bDL.Val[9]),"->,>>>,>>9.99") + "│" SKIP.
RUN CalcStrike(mStrOfList + 1, 63, NO, OUTPUT mStrOfList).
PUT STREAM sfact UNFORMATTED
            "└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┴───────────────┴───────────────┴───────────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┘" SKIP
.
RUN CalcStrike(mStrOfList + 1, 63, NO, OUTPUT mStrOfList).

IF printer.page-lines < mStrOfList + 14 THEN DO:
   RUN EndStrike(mStrOfList + 2, 63, YES, OUTPUT mStrOfList).
   RUN Sign-Prn.
/*   RUN EndStrike(mStrOfList + 15, 63, YES, OUTPUT mStrOfList). /* Возможно здесь - задница */*/
END.
ELSE DO:
   RUN Sign-Prn.
   RUN EndStrike(mStrOfList + 15, 63, YES, OUTPUT mStrOfList).
END.
/*
IF CAN-FIND(FIRST bDl WHERE entry(9,bDL.Txt,"~n") EQ "Аннулир") THEN
DO:
   pick-value = 'yes'. /* поведение по умолчанию */
   RUN Fill-SysMes IN h_tmess (
      "", "", "4",
      "Печатать аннулированные счет-фактуры?"
   ).
   IF pick-value EQ "yes" THEN
   DO:
      RUN SellAddPage(iDataBlock, PAGE-NUMBER(sfact)).
   END.
END.
*/
{preview.i &STREAM="STREAM sfact"}
{intrface.del}
