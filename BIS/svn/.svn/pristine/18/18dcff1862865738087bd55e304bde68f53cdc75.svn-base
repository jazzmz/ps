/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2005 ТОО "Банковские информационные системы"
     Filename: pir_f316r1t#.p
      Comment: <comment>
   Parameters:
         Uses:
      Used by:
      Created: 16/10/08  13:38:07  SALN (0100051) ф.316 (ежемесячная). 
                                                  по указанию 2055-У; на 01.01.09
                                                  Раздел 1
     Modified: 29/01/08 SALN (0104462) ф.316.  тесты для проверки расчета 
     Modified: 16.05/12 SSV версия ПИР -- Изменены агрегация, нужен именно последний КД, тогда мы пройдем по всем выдачам и будем знать
*/

{sv-calc.i}

{intrface.get strng} 
{intrface.get date}
{intrface.get loan}
{intrface.get xclass}

&GLOBAL-DEFINE NO-BASE-PROC YES                                              

{f302n#.pro &F302_SYS=YES}

DEFINE VARIABLE mSrcID  AS INT64 NO-UNDO.
DEFINE VARIABLE mIsTest AS LOGICAL NO-UNDO.
DEFINE VARIABLE mDate-Year-Beg AS DATE NO-UNDO. 
DEFINE VARIABLE mDate-Year-End AS DATE NO-UNDO. 
DEFINE BUFFER bDataBlock FOR DataBlock.

DEFINE TEMP-TABLE ttDataLine NO-UNDO LIKE DataLine
    USE-INDEX data-id-sym
    USE-INDEX data-id-sym2.

RUN normdbg IN h_debug (0,"",STRING (TIME,"hh:mm:ss") + " Начало расчета класса '" + DataClass.DataClass-Id + "'").

MAIN:
DO ON ERROR UNDO, RETRY:
   {do-retry.i MAIN}

   RUN pInitCalc.

   RUN SaveBlock(mSrcID). 
   
   RUN SaveSpr(mSrcID).
    
END.

RUN normdbg IN h_debug (0,"",STRING (TIME,"hh:mm:ss") + " Окончание расчета класса '" + DataClass.DataClass-Id + "'").
   
{intrface.del}
RETURN "".

/*-----------------------------------------------------------------------------------------------------------
  Purpose:    Инициализация расчета
  Parameters:    
  Notes:     
----------------------------------------------------------------------------------------------------------- */
PROCEDURE pInitCalc.

   /* расчет (NO)/ тест (YES)*/
   mIsTest = (GetSysConf("f316r1ts") EQ "YES").

   IF mIsTest THEN DO:
      FIND FIRST bDataBlock WHERE bDataBlock.DataClass-Id EQ ENTRY(1,DataClass.Depends)
                            AND   bDataBlock.Branch-ID    EQ dataBlock.Branch-ID
                            AND   bDataBlock.Beg-Date     EQ DataBlock.Beg-Date
                            AND   bDataBlock.End-Date     EQ DataBlock.End-Date
         NO-LOCK NO-ERROR.
  
     IF NOT AVAIL bDataBlock THEN RETURN.
     mSrcID = bDataBlock.Data-Id.
  
   END.
   ELSE
      /* Поиск исходного блока */
      RUN sv-get.p (       ENTRY(1,DataClass.Depends),
                           dataBlock.Branch-ID,
                           dataBlock.Beg-Date,
                           dataBlock.End-Date,
                    OUTPUT mSrcID).

   RUN pgetPeriod_f302(DataBlock.End-Date, OUTPUT mDate-Year-Beg, OUTPUT mDate-Year-End).

END PROCEDURE.

/*-----------------------------------------------------------------------------------------------------------
  Purpose:    Сохранение блока расчета
  Parameters:               
  Notes:     
----------------------------------------------------------------------------------------------------------- */
&IF DEFINED(Instr2470-U) &THEN
PROCEDURE SaveBlock .
   DEFINE INPUT PARAMETER in-DataID AS INT64 NO-UNDO.

   DEFINE VARIABLE vCurr      AS CHARACTER NO-UNDO. 
   DEFINE VARIABLE vSrok      AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vProc      AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vSumm      AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vNewCred   AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vRest      AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vOutRest   AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vSym4      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vI         AS INT64   NO-UNDO.
   DEFINE VARIABLE vFind      AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE vPrevSrok  AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vPrevProc  AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vZnSrok    AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vZnProc    AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vBefChange AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE vBegDateCh AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vEndDateCh AS CHARACTER NO-UNDO.
   
   DEFINE VARIABLE vLoanSrok   AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vLoanProc   AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vLoanZnSrok AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE vLoanZnProc AS DECIMAL   NO-UNDO.
   
   DEFINE VARIABLE vAcctCalc   AS LOGICAL NO-UNDO.
   DEFINE VARIABLE vVal        AS DECIMAL NO-UNDO EXTENT 4.

   DEFINE BUFFER bDataLine FOR DataLine.
   ASSIGN
      vBegDateCh = STRING(YEAR(mDate-Year-Beg), "9999")
                   + STRING(MONTH(mDate-Year-Beg), "99")
                   + STRING(DAY(mDate-Year-Beg), "99").

   /* если нет даты в Sym4, то добавляем в Sym4 к номеру договора дату начала блока(строка с процентной ставкой на начало периода) */
   FOR EACH DataLine WHERE DataLine.Data-ID = in-DataID NO-LOCK:
      CREATE ttDataLine.
      BUFFER-COPY DataLine TO ttDataLine.
      IF INDEX(ttDataLine.Sym4, '#') = 0 THEN
         ttDataLine.Sym4 = ttDataLine.Sym4 + "#" + vBegDateCh.
   END.

DEF VAR vWasThisPeriodNewTrans AS DEC NO-UNDO.

   
   /* сортировка: терр. + строка + автономия + валюта */
   FOR EACH ttDataLine WHERE
            ttDataLine.Data-ID = in-DataID
        AND ttDataLine.Sym1    <> "Spr"
        AND ttDataLine.Sym2    <> "Справочно"
      BREAK BY ENTRY(1,ttDataLine.Sym1,";")	/* автономия */
            BY ttDataLine.Sym2			/* строка */
            BY ENTRY(2,ttDataLine.Sym1,";")
            BY (ENTRY(2,ttDataLine.Sym3) EQ "")      
            BY ENTRY(1, ENTRY(1, ttDataLine.Sym4, "#"), " ") /* номер охв. договора */
	    BY ENTRY(1, ttDataLine.Sym4, "#")

            BY ENTRY(1,ttDataLine.Sym3)
            BY ttDataLine.Sym4:
      vAcctCalc = ENTRY(1, ttDataLine.Sym4, "#") = "". /* расчет по счетам */
/* отладка
RUN normdbg IN h_debug (0,"", 
STRING(vVal[1]) + " " +
" НУЛ:"  + STRING(FIRST-OF((ENTRY(2,ttDataLine.Sym3) EQ ""))) +
" СУМ:" + STRING(FIRST-OF(ENTRY(1, ENTRY(1, ttDataLine.Sym4, "#"), " "))) +
" КОЛ:" + STRING(ttDataLine.Val[1]) +
" " +        ENTRY(1,ttDataLine.Sym1,";")	/* код терр. */
+ '|' + STRING (ttDataLine.Sym2)        /* строка */
+ '|' + ENTRY(2,ttDataLine.Sym1,";")
+ '|' + ENTRY(2,ttDataLine.Sym3)        /* валюта */
+ '|' + ENTRY(1, ENTRY(1, ttDataLine.Sym4, "#"), " ") /* номер договора */
+ '|' + ENTRY(1, ttDataLine.Sym4, "#") /* ЛС */
+ '|' + ENTRY(1,ttDataLine.Sym3)
+ '|' + STRING (ttDataLine.Sym4)
).
*/
      /* для автономии + валюта */            
      IF FIRST-OF((ENTRY(2,ttDataLine.Sym3) EQ "")) THEN DO: /* это в оригинале */
/*      IF FIRST-OF(ENTRY(1,ttDataLine.Sym1,";")) THEN DO: */
         ASSIGN
            vSrok   = 0
            vProc   = 0
            vZnSrok = 0
            vZnProc = 0
            vVal[1] = 0
            vVal[2] = 0
            vVal[3] = 0
            vVal[4] = 0
	 .
      END.
      /* Кредитная линия с траншами считается как один кредит */
      IF FIRST-OF(ENTRY(1, ENTRY(1, ttDataLine.Sym4, "#"), " "))	/* новый номер договора */
	THEN vWasThisPeriodNewTrans = 0.

      IF ttDataLine.Val[1] > 0 /* по КД есть вновь выданные транши */
        THEN vWasThisPeriodNewTrans = ttDataLine.Val[1].

      IF FIRST-OF(ENTRY(1, ttDataLine.Sym4, "#")) THEN DO:
         ASSIGN
            vPrevSrok   = ?
            vPrevProc   = ?
            vLoanSrok   = 0
            vLoanZnSrok = 0
            vLoanProc   = 0
            vLoanZnProc = 0
            .
         vNewCred = IF LAST-OF(ENTRY(1, ttDataLine.Sym4, "#")) THEN /* если не было изменений срока/ставки */
                       ROUND(ttDataLine.Val[10] / 1000, 0)
                    ELSE
                       ROUND(ttDataLine.Val[8] / 1000, 0).
      END.
      
      IF vAcctCalc THEN
         ASSIGN
            vNewCred = ROUND(ttDataLine.Val[2] / 1000, 0)
            vRest    = ROUND(ttDataLine.Val[3] / 1000,0)
            vOutRest = vRest
            .
      ELSE
         ASSIGN
            vOutRest = ROUND(ttDataLine.Val[10] / 1000,0) /* исходящий остаток */
            vRest    = ROUND(ttDataLine.Val[3] / 1000,0)
            .
      IF vAcctCalc OR FIRST-OF(ENTRY(1, ttDataLine.Sym4, "#")) AND LAST-OF(ENTRY(1, ttDataLine.Sym4, "#"))
      THEN DO: /* если не было изменений срока/ставки */
         ASSIGN
            vLoanSrok   = vLoanSrok + ttDataLine.Val[5] * vNewCred
            vLoanZnSrok = vLoanZnSrok + vNewCred
            vLoanProc   = vLoanProc + ttDataLine.Val[6] * ttDataLine.Val[5] * vNewCred
            vLoanZnProc = vLoanZnProc + ttDataLine.Val[5] * vNewCred
            .
      END.
      ELSE DO:
         /* Изменение срока */                                   
         IF ttDataLine.Val[9] <> vPrevSrok THEN /* Общий срок по договору */
            ASSIGN
               vLoanSrok   = vLoanSrok + (IF vPrevSrok = ? THEN ttDataLine.Val[9] ELSE ttDataLine.Val[5]) /* для 1-ой строки срок берем из Val[9] */
                                         * (IF vPrevSrok = ? THEN vNewCred ELSE vOutRest)
               vLoanZnSrok = vLoanZnSrok + (IF vPrevSrok = ? THEN vNewCred ELSE vOutRest)
               .
         
         /* Изменение ставки */                                                   
         IF ttDataLine.Val[6] <> vPrevProc THEN
            ASSIGN
               vLoanProc   = vLoanProc + ttDataLine.Val[6] * ttDataLine.Val[5] * (IF vPrevProc = ? THEN vNewCred ELSE vRest)
               vLoanZnProc = vLoanZnProc + ttDataLine.Val[5] * (IF vPrevProc = ? THEN vNewCred ELSE vRest)
               .
         ELSE /* Если ставка не менялась, то собираем оставшиеся сроки в Val5 */
            ASSIGN
               vLoanProc   = vLoanProc + ttDataLine.Val[6] * ttDataLine.Val[5] * vNewCred
               vLoanZnProc = vLoanZnProc + ttDataLine.Val[5] * vNewCred
               .
      END.

      IF mIsTest THEN
         PUBLISH "pcallFromCalcDetail"(ttDataLine.Sym1, 
                                       ttDataLine.Sym2, 
                                       ttDataLine.Sym3, 
                                       ttDataLine.Sym4,
                                       ttDataLine.Val[5],
                                       ttDataLine.Val[6],
                                       vRest,
                                       vOutRest).
      ASSIGN
         vPrevSrok = ttDataLine.Val[9]
         vPrevProc = ttDataLine.Val[6]
         .

      IF LAST-OF(ENTRY(1, ttDataLine.Sym4, "#")) OR (vAcctCalc AND LAST-OF(ENTRY(1,ttDataLine.Sym3))) AND mIsTest THEN
         /* передача результатов для тестового отчета */
         PUBLISH "pcallFromCalc" (FALSE,
                                  mDate-Year-Beg,
                                  mDate-Year-End,
                                  ttDataLine.Sym1, 
                                  ttDataLine.Sym2, 
                                  ttDataLine.Sym3, 
                                  ENTRY(1, ttDataLine.Sym4, "#"),
                                  ttDataLine.Txt,
                                  (IF ENTRY(2,ttDataLine.Sym3) EQ "" THEN "РФ" ELSE "инв"),
                                  vNewCred,
                                  vLoanSrok,
                                  vLoanZnSrok,
                                  vLoanProc,
                                  vLoanZnProc).
      IF LAST-OF(ENTRY(1, ttDataLine.Sym4, "#")) THEN DO: /* в оригинале номер транша */
         ASSIGN
            vSrok   = vSrok   + vLoanSrok
            vZnSrok = vZnSrok + vLoanZnSrok
            vProc   = vProc   + vLoanProc
            vZnProc = vZnProc + vLoanZnProc
            .
      END.

       /* Кредитная линия с траншами считается как один кредит */
/*      IF FIRST-OF(ENTRY(1, ENTRY(1, ttDataLine.Sym4, "#"), " ")) THEN было в оригинале */
      IF LAST-OF(ENTRY(1, ENTRY(1, ttDataLine.Sym4, "#"), " ")) THEN /* номер договора -- последний транш скорее всего вновь выданный */
         vVal[1] = vVal[1] + /* ttDataLine.Val[1] */ vWasThisPeriodNewTrans. /* количество выданных. нужен именно последний, тогда мы пройдем по всем выдачам */

      ASSIGN
         vVal[2] = vVal[2] + ttDataLine.Val[2]
         vVal[4] = vVal[4] + ttDataLine.Val[4]
         .
      /* Если первая строка по договору или расчет по счетам */
      IF FIRST-OF(ENTRY(1, ttDataLine.Sym4, "#")) OR vAcctCalc THEN
          vVal[3] = vVal[3] + ttDataLine.Val[3].

      /* по автономии + валюта */
      IF LAST-OF((ENTRY(2,ttDataLine.Sym3) EQ "")) THEN  
/*      IF LAST-OF(ENTRY(1,ttDataLine.Sym1,";")) THEN */
      DO:
         IF mIsTest THEN 
            PUBLISH "pcallFromCalc" (TRUE, /* Итоговая строка */
                                     mDate-Year-Beg,
                                     mDate-Year-End,
                                     ttDataLine.Sym1, 
                                     ttDataLine.Sym2, 
                                     ?, 
                                     ?,
                                     ?,  
                                     (IF ENTRY(2,ttDataLine.Sym3) = "" THEN "РФ" ELSE "инв"),
                                     ?,
                                     vSrok,
                                     vZnSrok,
                                     vProc,
                                     vZnProc).
         ELSE DO:
            CREATE TDataLine.
            ASSIGN TDataLine.Data-ID = DataBlock.Data-ID
                   TDataLine.Sym1    = ENTRY (1, ttDataLine.Sym1, ";")
                   TDataLine.Sym2    = ENTRY (2, ttDataLine.Sym1, ";")
                   TDataLine.Sym3    = ttDataLine.Sym2  
                   TDataLine.Sym4    = IF ENTRY(2,ttDataLine.Sym3) EQ "" THEN "РФ" ELSE "инв"         
                   TDataLine.Val[1]  = vVal[1]
                   TDataLine.Val[2]  = ROUND(vVal[2] / 1000,0)
                   TDataLine.Val[3]  = ROUND(vVal[3] / 1000,0)
                   TDataLine.Val[4]  = ROUND(vVal[4] / 1000,0)
            .            
            /* средневзвешенные значения */
            ASSIGN TDataLine.Val[5] = vSrok
                   TDataLine.Val[6] = vProc
                   TDataLine.Val[7] = vZnSrok
                   TDataLine.Val[8] = vZnProc
            .   
            RELEASE TDataLine.    
         END.
      END.   
   END.
END PROCEDURE.   
&ELSE   
PROCEDURE SaveBlock .
DEFINE INPUT PARAMETER in-DataID AS INT64 NO-UNDO.

DEFINE VARIABLE vCurr  AS CHARACTER NO-UNDO. 
DEFINE VARIABLE vSrok  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE vProc  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE vSumm  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE vLS    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE vSym4  AS CHARACTER NO-UNDO.
DEFINE VARIABLE vI     AS INT64   NO-UNDO.
DEFINE VARIABLE vFind  AS LOGICAL   NO-UNDO.

DEFINE BUFFER bDataLine FOR DataLine.

   /* сортировка: терр. + строка + автономия + валюта */
   FOR EACH DataLine WHERE dataLine.Data-ID EQ in-DataID
                     AND   DataLine.Sym1    <> "Spr"
                     AND   dataLine.Sym2    NE "Справочно"
      BREAK BY ENTRY(1,DataLine.Sym1,";")
            BY DataLine.Sym2
            BY ENTRY(2,DataLine.Sym1,";")
            BY (ENTRY(2,DataLine.Sym3) EQ ""): 

      /* для автономии + валюта */            
      IF FIRST-OF((ENTRY(2,DataLine.Sym3) EQ "")) 
      THEN {assvar.i 0 vSrok vProc vSumm} 
      
      /*  ttDataLine.Sym4 =  "" расчет по счетам 
              - # -       <> "" расчет по договорам
      */
      IF INDEX(dataLine.Sym4,"#") EQ 0 THEN ASSIGN vLS = ROUND(DataLine.Val[2] / 1000,0)
                                                   vSumm = vSumm + vLS
                                            .
      ELSE DO:
         FIND FIRST bDataLine WHERE bDataLine.Data-ID EQ dataLine.Data-ID 
                              AND   bDataLine.Sym1    EQ dataLine.Sym1
                              AND   bDataLine.Sym2    EQ dataLine.Sym2
                              AND   bDataLine.Sym4    EQ ENTRY(1,dataLine.Sym4,"#")
         NO-LOCK NO-ERROR.
         vLS = IF AVAIL bDataLine THEN
                  ROUND(bDataLine.Val[2] / 1000,0)
               ELSE 0.0 .
      END.

      /* передача результатов для тестового отчета */
      IF mIsTest THEN 
         PUBLISH "pcallFromCalc" (FALSE,
                                  mDate-Year-Beg,
                                  mDate-Year-End,
                                  DataLine.Sym1, 
                                  DataLine.Sym2, 
                                  DataLine.Sym3, 
                                  DataLine.Sym4,
                                  DataLine.Txt,
                                  (IF ENTRY(2,DataLine.Sym3) EQ "" THEN "РФ" ELSE "инв"),
                                  DataLine.Val[2],
                                  DataLine.Val[5],
                                  DataLine.Val[6],
                                  vLS,
                                  DataLine.Val[5] * vLS,
                                  DataLine.Val[5] * DataLine.Val[6] * vLS).

      ASSIGN vSrok = vSrok + DataLine.Val[5] * vLS
             vProc = vProc + DataLine.Val[5] * DataLine.Val[6] * vLS
      .

IF TDataLine.Sym2 = '45' THEN
MESSAGE "ADD"
                TDataLine.Sym1    
                TDataLine.Sym2
                TDataLine.Sym3    
                TDataLine.Sym4    
view-as alert-box.


      /* убираем дубль строки Sym4 = <номер договора>#<дата расчета %> */
      IF INDEX(dataLine.Sym4,"#") EQ 0 THEN DO:
         ACCUMULATE DataLine.Val[1] (TOTAL BY (ENTRY(2,DataLine.Sym3) EQ ""))
                    DataLine.Val[2] (TOTAL BY (ENTRY(2,DataLine.Sym3) EQ ""))
                    DataLine.Val[3] (TOTAL BY (ENTRY(2,DataLine.Sym3) EQ ""))
                    DataLine.Val[4] (TOTAL BY (ENTRY(2,DataLine.Sym3) EQ ""))
         .   
      END.

      /* по автономии + валюта */
      IF LAST-OF((ENTRY(2,DataLine.Sym3) EQ "")) THEN 
      DO:
         IF mIsTest THEN 
            PUBLISH "pcallFromCalc" (TRUE,
                                     mDate-Year-Beg,
                                     mDate-Year-End,
                                     DataLine.Sym1, 
                                     DataLine.Sym2, 
                                     ?, 
                                     ?,
                                     ?,  
                                     ?,
                                     ?,
                                     ?,
                                     ?,
                                     vSumm,
                                     vSrok,
                                     vProc).
         ELSE DO:

            CREATE TDataLine.
            ASSIGN TDataLine.Data-ID = DataBlock.Data-ID
                   TDataLine.Sym1    = ENTRY (1, DataLine.Sym1, ";")
                   TDataLine.Sym2    = ENTRY (2, DataLine.Sym1, ";")
                   TDataLine.Sym3    = DataLine.Sym2  
                   TDataLine.Sym4    = IF ENTRY(2,DataLine.Sym3) EQ "" THEN "РФ" ELSE "инв"         
                   TDataLine.Val[1]  = ACCUM TOTAL BY (ENTRY(2,DataLine.Sym3) EQ "") DataLine.Val[1]
                   TDataLine.Val[2]  = ROUND((ACCUM TOTAL BY (ENTRY(2,DataLine.Sym3) EQ "") DataLine.Val[2]) / 1000,0)
                   TDataLine.Val[3]  = ROUND((ACCUM TOTAL BY (ENTRY(2,DataLine.Sym3) EQ "") DataLine.Val[3]) / 1000,0)
                   TDataLine.Val[4]  = ROUND((ACCUM TOTAL BY (ENTRY(2,DataLine.Sym3) EQ "") DataLine.Val[4]) / 1000,0)
            .            
MESSAGE "2"
                TDataLine.Sym1    
                TDataLine.Sym2    
                TDataLine.Sym3    
                TDataLine.Sym4    
view-as alert-box.
            /* средневзвешенные значения */
            ASSIGN TDataLine.Val[5] = vSrok
                   TDataLine.Val[6] = vProc       
                   TDataLine.Val[7] = vSumm
                   TDataLine.Val[8] = vSrok
            .   
            RELEASE TDataLine.    
         END.
      END.   

   END.

END PROCEDURE.
&ENDIF

PROCEDURE SaveSpr:
   DEFINE INPUT PARAMETER iDataID AS INTEGER NO-UNDO.
   FOR FIRST DataLine WHERE
             DataLine.Data-ID = iDataID
         AND DataLine.Sym1    = "Spr"
   NO-LOCK:
      CREATE TDataLine.
      ASSIGN
         TDataLine.Data-ID = DataBlock.Data-ID
         TDataLine.Sym1    = DataLine.Sym1
         TDataLine.Val[9]  = ROUND(DataLine.Val[7] / 1000,0)
         TDataLine.Val[10] = ROUND(DataLine.Val[8] / 1000,0)
         .
   END.
   RELEASE TDataLine.
END PROCEDURE.