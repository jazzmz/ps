/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: ap-sort.i
      Comment: Создание временной таблицы для отчётов УМЦ
   Parameters:
         Uses:
      Used by: ap-list.p ap-amort.p ap-wear.p
      Created:
     Modified: 07.04.2004 fedm
*/

{globals.i}
{a-defs.i}
{intrface.get date}

DEF TEMP-TABLE af NO-UNDO
   FIELD inv-num      LIKE loan.cont-code
   FIELD name         LIKE asset.name EXTENT 5
   FIELD unit         LIKE asset.unit
   FIELD cont-type    LIKE asset.cont-type   /*для сортировки по коду ценности*/
   FIELD commission   LIKE asset.commission FORMAT "x(9)" /* код амортизации */
   FIELD date-make    LIKE loan.open-date INITIAL ?
   FIELD qty          LIKE kau-entry.qty
   FIELD disc         LIKE kau-entry.amt-rub /* Бал.стоимость        */
   FIELD amor         LIKE kau-entry.amt-rub /* Износ,расход         */
   FIELD rest         LIKE kau-entry.amt-rub /* Отаток               */
   FIELD rest-m       LIKE kau-entry.amt-rub /* Остаток за месяц     */
   FIELD comm-rate    LIKE comm-rate.rate-comm FORMAT "->,>>>,>>9.999"
   FIELD rate-fixed   LIKE comm-rate.rate-fixed
   FIELD misc         AS CHAR EXTENT 3
   FIELD b-name       LIKE branch.name
   FIELD e-name       LIKE employee.name
   FIELD sort-value   AS CHAR                /* для сортировки таблицы      */
   FIELD sort-value2  AS CHAR                /* для сортировки таблицы      */
   FIELD GoodUse      AS INT                 /* срок полезного использования*/
                      FORMAT "zzzzzzzzzzzz"
   INDEX e-name e-name
   INDEX b-name b-name
   INDEX inv-num inv-num e-name b-name
   INDEX sort-value sort-value sort-value2 inv-num  /* для сортировки таблицы*/
.

{getdate2.i {&*}}
{wordwrap.def}
DEF VAR vTmpSum AS DATE NO-UNDO.


/* счетчик по наименованию */
DEF VAR mExt     AS INT NO-UNDO.
/* Первое число месяца */
DEF VAR mFirstMonDate  AS DATE  NO-UNDO.
DEF VAR mKartMonDate   AS DATE  NO-UNDO.
mFirstMonDate = FirstMonDate(end-date).

/* Дата последнего списания по карточке */
DEF VAR mOutDate  AS DATE  NO-UNDO.

&IF DEFINED(browser) &THEN
{tmprecid.def}        /** Используем информацию из броузера */

FOR
   EACH  tmprecid,
   FIRST loan WHERE
         RECID(loan)      = tmprecid.id
&ELSE
FOR
   EACH  loan WHERE
         loan.contract    = work-module
    AND  loan.open-date  <= end-date
    AND (loan.close-date  = ? OR
         loan.close-date >= &IF DEFINED(no-beg-date) &THEN
                               end-date
                            &ELSE
                               beg-date
                            &ENDIF
        )
&ENDIF
&IF DEFINED(wear) + DEFINED(amort) > 0 &THEN
    AND  loan.class-code <> "НМА2"
&ENDIF
      NO-LOCK,

   FIRST asset OF loan
      NO-LOCK:

   CREATE af.

   {a-calc.i
      &in-contract  = loan.contract
      &in-cont-code = loan.cont-code
      &in-date      = end-date
   }




   ASSIGN                                                   	
      af.date-make  =  DATE(GetXAttrValueEx("loan",
                                            loan.contract + "," + loan.cont-code,
                                            "ДатаИзготов",
                                            ?
                                           )
                           )
      af.rest-m     = 0
      af.inv-num    = loan.cont-code
      af.name[1]    = asset.name       WHEN AVAILABLE asset
      af.unit       = asset.unit       WHEN AVAILABLE asset
      af.cont-type  = asset.cont-type  WHEN AVAILABLE asset
      af.qty        = a-qty
      af.disc       = a-disc 
      af.amor       = a-amor
      af.rest       = a-rest
      af.misc[1]    = ""
      af.misc[2]    = asset.commission
      af.commission = asset.commission
      af.b-name     = branch.name      WHEN AVAILABLE branch
      af.e-name     = employee.name    WHEN AVAILABLE employee
   .
   {wordwrap.i
      &s = af.name
      &l = 32
      &n = EXTENT(af.name)
   }
   /* Для других подсистем нет амортизации */
  
   IF CAN-DO("ОС,НМА", loan.contract) THEN
   DO:
      /* Вычисляем месячную норму амортизации */
      RELEASE comm-rate.

      ASSIGN
         af.comm-rate  = GetAmortNorm(loan.contract,
                                      loan.cont-code,
                                      end-date,
                                      "Б"
                                     )
         af.rate-fixed = NO
         af.comm-rate  = comm-rate.rate-comm  WHEN AVAILABLE comm-rate
         af.rate-fixed = comm-rate.rate-fixed WHEN AVAILABLE comm-rate
      .

      IF af.comm-rate  = ? THEN
         af.comm-rate  = 0.

      /* Срок полезного использования */
      IF af.commission = "" THEN
      DO:
         af.GoodUse    =  GetSrokAmor(RECID(loan),
                                             "СПИБ",
                                             end-date
                                            ).
         IF af.GoodUse = ? THEN
            af.GoodUse = 0.
      END.
   END.

&IF DEFINED(wear) + DEFINED(amort) > 0 &THEN


/* чтобы выводились на экран карточки заведенные в этом месяце */
        If FirstMonDate(end-date) < loan.open-date 
	then mKartMonDate = mFirstMonDate.
	else mKartMonDate = end-date.


   /* Для отчетов по амортизации считаем бал.стоимость на начало месяца */
   RUN GetLoanPos IN h_umc (loan.contract,
                            loan.cont-code,
                            "-учет",
                            mKartMonDate,
                            OUTPUT af.disc,
                            OUTPUT af.qty
                           ).
 
   /* Остаток по амортизации на начало месяца */
   af.rest-m = GetLoan-Pos (loan.contract,
                            loan.cont-code,
                            "-амор",
                            mFirstMonDate
                           ).
            		   
   /* Остаток по амортизации на дату отчёта */
   af.amor   = GetLoan-Pos (loan.contract,
                            loan.cont-code,
                            "-амор",
                            end-date
                           ).
   /* Если остаток = 0, то получаем остаток на дату последнего списания */
   IF af.amor = 0 THEN
   DO:
      /* Дата последнего списания по карточке */
      RUN GetLoanDate IN h_umc (loan.contract,
                               loan.cont-code,
                               "-амор",
                               "Out",
                               OUTPUT mOutDate,
															 OUTPUT vTmpSum
                              ).

      IF mOutDate >= mFirstMonDate AND
         mOutDate <= end-date
      THEN
         RUN GetLoanPos- IN h_umc (loan.contract,
                                   loan.cont-code,
                                   "-амор",
                                   ?,
                                   OUTPUT af.amor,
                                   OUTPUT a-qty
                                  ).
   END.

   /* Износ за месяц */
   af.rest-m = af.amor - af.rest-m.

   /* Износ за последний месяц - сумма кредитовых оборотов
   ** по счету амортизации по карточке
   RUN GetLoanTurn IN h_umc (INPUT  loan.contract,
                             INPUT  loan.cont-code,
                             INPUT  "-амор",
                             INPUT  mFirstMonDate,
                             INPUT  end-date,
                             INPUT  NO,
                             OUTPUT af.rest-m,
                             OUTPUT a-qty
                            ).
   af.amor = GetLoan-Pos (loan.contract,
                          loan.cont-code,
                          "-амор",
                          mFirstMonDate
                         )
           + af.rest-m.

   */
   ASSIGN
      af.rest      = af.disc - af.amor
      af.date-make = loan.open-date.
&ENDIF

   /* Критерий нулевой строки */
   &IF DEFINED(EmptyLine) = 0 &THEN
      &GLOBAL-DEFINE EmptyLine    af.disc    = 0   ~
                              AND af.qty     = 0   ~
                           &IF DEFINED(obor) &THEN ~
                              AND af.turn-db = 0   ~
                              AND af.turn-cr = 0   ~
                           &ENDIF
   &ENDIF

   /* Если не печатаем нулевые строки, то удаляем нулевую строку */
   IF NOT (in-move BEGINS "all") AND {&EmptyLine} THEN
   DO:
      DELETE af.
      NEXT.
   END.

   /* Заполняем поле sort-value
   ** для дальнейшего упорядоченного вывода по данному полю
   */
   RUN set-sort-value.

END. /* FOR EACH loan */

{setdest.i}

RUN show.

{signatur.i &user-only}
{preview.i}

{intrface.del}
