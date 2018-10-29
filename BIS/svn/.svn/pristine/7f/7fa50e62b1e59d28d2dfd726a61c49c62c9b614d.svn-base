/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1998 ТОО "Банковские информационные системы"
     Filename: a-obj.p
      Comment: Объект-карточка
   Parameters:
         Uses:
      Used by:
      Created: 30.09.1999 Peter
     Modified: 03/07/2003 kraw (0015092) КолКартU, СуммаКартU
     Modified: 16/07/2003 kraw (0017960) НДСМЦ
     Modified: 19/08/2003 kraw (0017960) НДСМЦ удалено
     Modified:
*/
FORM "~n@(#) a-obj.p 1.0 Peter 30.09.1999 Peter 30.09.1999 Объект-карточка" WITH
   FRAME sccs-id STREAM-IO WIDTH-CHARS 250.

DEF INPUT PARAMETER iPrvData   AS CHAR  NO-UNDO.
DEF INPUT PARAMETER iContract  AS CHAR  NO-UNDO.
DEF INPUT PARAMETER iContCode  AS CHAR  NO-UNDO.

{a-defs.i
   &a-defs-shared = SHARED
}

DEF VAR iFace        LIKE employee.tab-no  NO-UNDO INITIAL ?.
DEF VAR iBranch      LIKE branch.branch-id NO-UNDO.

DEF VAR misc         AS CHAR               NO-UNDO EXTENT 5.

DEF VAR savePrvData  AS CHAR               NO-UNDO.
DEF VAR saveContract AS CHAR               NO-UNDO.
DEF VAR saveContCode AS CHAR               NO-UNDO.
DEF VAR saveFace     AS INT                NO-UNDO.
DEF VAR saveBranch   AS CHAR               NO-UNDO.

{globals.i}

{sh-defs.i}
{intrface.get umc}
{intrface.get date}
{intrface.get asset}    /* Инструмент услуг/ценностей */
{intrface.get db2l}

THIS-PROCEDURE:PRIVATE-DATA = iPrvData.

PROCEDURE Change:
   DEF INPUT PARAMETER iiContract  AS CHAR  NO-UNDO.
   DEF INPUT PARAMETER iiContCode  AS CHAR  NO-UNDO.
   DEF INPUT PARAMETER iiFace      AS INT   NO-UNDO.
   DEF INPUT PARAMETER iiBranch    AS CHAR  NO-UNDO.

   ASSIGN
      iContract = iiContract
      iContCode = iiContcode
      iFace     = iiFace
      iBranch   = iiBranch
      res1      = 0
      res2      = 0
      res21     = 0
      res3      = 0
      res4      = 0
      res5      = 0
      res1nal   = 0
      res2nal   = 0
      res3nal   = 0
      res4nal   = 0
      res5nal   = 0.

   RETURN.
END PROCEDURE.

PROCEDURE SAVE:
   ASSIGN
      savePrvData  = THIS-PROCEDURE:PRIVATE-DATA
      saveContract = iContract
      saveContCode = iContCode
      saveFace     = iFace
      saveBranch   = iBranch.

   RETURN.
END PROCEDURE.

PROCEDURE Restore:
   ASSIGN
      THIS-PROCEDURE:PRIVATE-DATA = savePrvData
      iContract                   = saveContract
      iContCode                   = saveContCode
      iFace                       = saveFace
      iBranch                     = saveBranch.

   RETURN.
END PROCEDURE.

PROCEDURE SetMisc:
   DEF INPUT PARAMETER idx     AS INT   NO-UNDO.
   DEF INPUT PARAMETER iMisc   AS CHAR  NO-UNDO.

   misc[idx] = iMisc.

   RETURN.
END PROCEDURE.

PROCEDURE GetMisc:
   DEF INPUT  PARAMETER idx    AS INT   NO-UNDO.
   DEF OUTPUT PARAMETER oMisc  AS CHAR  NO-UNDO.

   oMisc = misc[idx].

   RETURN.
END PROCEDURE.

PROCEDURE GetContCode:
   DEF OUTPUT PARAMETER oContract  AS CHAR  NO-UNDO.
   DEF OUTPUT PARAMETER oContCode  AS CHAR  NO-UNDO.

   ASSIGN
      oContract = iContract
      oContCode = iContcode.

   RETURN.
END.

PROCEDURE ОстатСтоим:
   DEF INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   IF res5 = 0 THEN
   DO:
      RUN ВосстСтоим (       iDate,
                      OUTPUT res1
                     ).
      RUN НачАмор    (       iDate,
                      OUTPUT res2
                     ).
   /*
      RUN ФондПер    (       iDate,
                      OUTPUT res3
                     ).
   */
      res5 = res1 - res2. /*- res3*/
   END.

   RESULT = res5.

   RETURN.
END PROCEDURE.

PROCEDURE ОстатСтоимНал:
   DEF INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   IF res5nal = 0 THEN
   DO:
      RUN ПервСтоимНал (       iDate,
                         OUTPUT res1nal
                        ).
      RUN НачАморНал    (       iDate,
                         OUTPUT res2nal
                        ).
      RUN ИзмНалСтоим   (       iDate,
                         OUTPUT res3nal
                        ).

      res5nal = res1nal - res2nal + res3nal.
   END.

   RESULT = res5nal.

   RETURN.
END PROCEDURE.

PROCEDURE ВосстСтоим:
   DEF INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   IF res1 = 0 THEN
      res1 = GetLoan-Pos (iContract,
                          iContCode,
                          "учет",
                          iDate
                         ).
   RESULT = res1.

   RETURN.
END PROCEDURE.

PROCEDURE ПервСтоимНал:
   DEF INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   IF res1nal = 0 THEN
      res1nal = GetLoan-Pos (iContract,
                             iContCode,
                             "нал-учет",
                             iDate
                            ).
   RESULT = res1nal.

   RETURN.
END PROCEDURE.

PROCEDURE НачАмор:
   DEF INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   IF res2 = 0 THEN
      res2 = GetLoan-Pos (iContract,
                          iContCode,
                          "амор",
                          iDate
                         ).
   RESULT = res2.

   RETURN.
END PROCEDURE.

PROCEDURE НачАмор1:
   DEF INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   IF res21 = 0 THEN
      res21 = GetLoan-Pos (iContract,
                          iContCode,
                          "амор",
                          DATE("01/01/" + STRING(YEAR(iDate)))
                         ).
   RESULT = res21.

   RETURN.
END PROCEDURE.


PROCEDURE НачАморНал:
   DEF INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   IF res2nal = 0 THEN
      res2nal = GetLoan-Pos (iContract,
                             iContCode,
                             "нал-амор",
                             iDate
                            ).
   RESULT = res2nal.

   RETURN.
END PROCEDURE.


PROCEDURE ФондПер:
   DEF INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   IF res3 = 0 THEN
      res3 = GetLoan-Pos (iContract,
                          iContCode,
                          "пере",
                          iDate
                         ).
   RESULT = res3.

   RETURN.
END PROCEDURE.

PROCEDURE ИзмНалСтоим:
   DEF INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   IF res3nal = 0 THEN
      res3nal = GetLoan-Pos (iContract,
                             iContCode,
                             "нал-изм",
                             iDate
                            ).
   RESULT = res3nal.

   RETURN.
END PROCEDURE.

PROCEDURE Отдел:
   DEF INPUT  PARAMETER iDate  AS DATE  NO-UNDO.
   DEF OUTPUT PARAMETER RESULT AS CHAR  NO-UNDO INITIAL ?.

   DEF VAR vKau AS CHAR NO-UNDO.

   vKau = GetLastKau (iContract,
                      iContCode,
                      iDate
                     ).

   IF NUM-ENTRIES(vKau) >= 4 THEN
      vKau = ENTRY(4, vKau).
   ELSE
      vKau = ?.

   IF vKau > "" THEN
      RESULT = vKau NO-ERROR.

   RETURN.
END PROCEDURE.

PROCEDURE МатОтвет:
   DEF INPUT  PARAMETER iDate  AS DATE  NO-UNDO.
   DEF OUTPUT PARAMETER RESULT AS INT   NO-UNDO INITIAL ?.

   DEF VAR vKau AS CHAR NO-UNDO.

   vKau = GetLastKau (iContract,
                      iContCode,
                      iDate
                     ).

   IF NUM-ENTRIES(vKau) >= 3 THEN
      vKau = ENTRY(3, vKau).
   ELSE
      vKau = ?.

   IF vKau > "" THEN
      RESULT = INT(vKau) NO-ERROR.

   RETURN.
END PROCEDURE.

PROCEDURE ЦенаМЦ:
   DEF INPUT  PARAMETER iDate  AS DATE  NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO INITIAL ?.

   DEF BUFFER loan  FOR loan.
   DEF BUFFER asset FOR asset.

   FOR
      FIRST loan  WHERE
            loan.contract   = iContract
        AND loan.cont-code  = iContCode
         NO-LOCK,

      FIRST asset OF loan
         NO-LOCK:

      RESULT = GetCostUMC(loan.contract + CHR(6) + loan.cont-code,
                          iDate,
                          "",
                          ""
                         ).
   END.

   RETURN.
END PROCEDURE.

PROCEDURE НДС:
   DEF INPUT  PARAMETER iDate  AS DATE    NO-UNDO.
   DEF OUTPUT PARAMETER RESULT AS DECIMAL NO-UNDO INITIAL ?.

   DEF BUFFER loan  FOR loan.
   DEF BUFFER asset FOR asset.

   DEF VAR vNdsCm AS CHAR NO-UNDO.
   DEF VAR vNds   AS CHAR NO-UNDO.

   FOR
      FIRST loan  WHERE
            loan.contract   = iContract
        AND loan.cont-code  = iContCode
         NO-LOCK,

      FIRST asset OF loan
         NO-LOCK:

      vNdsCm = GetXattrValueEx("asset",
                               GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)),
                               "nds_cm",
                               "").
      IF vNdsCm > "" THEN
          RUN GetNDSValue(vNdsCm,
                          iDate,
                          OUTPUT vNds).
      IF vNds NE "" THEN
         RESULT = DEC(vNds) NO-ERROR.
   END.

   RETURN.
END PROCEDURE.

PROCEDURE КоэфПереоценки:
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   DEF VAR vLoanDate AS DATE NO-UNDO.

   vLoanDate = GetInDate(iContract,
                         iContCode,
                         "Б").

   DEF BUFFER bloan  FOR loan.
   DEF BUFFER basset FOR asset.

   FIND FIRST bloan WHERE
              bloan.contract  = iContract
          AND bloan.cont-code = iContCode
   NO-LOCK NO-ERROR.

   IF AVAILABLE bloan THEN
   DO:
      FIND FIRST basset OF bloan
      NO-LOCK NO-ERROR.

      IF AVAILABLE basset THEN
      DO:
         FIND FIRST instr-rate WHERE
                    instr-rate.instr-cat  = "overcode"
                AND instr-rate.rate-type  =   misc[1]
                AND ENTRY(1, instr-rate.instr-code, "/") = basset.commission
                AND instr-rate.since     >= vLoanDate
         NO-LOCK NO-ERROR.

         IF NOT AVAILABLE instr-rate THEN
         FOR EACH instr-rate WHERE
                  instr-rate.instr-cat = "overcode"
              AND instr-rate.rate-type = misc[1]
              AND instr-rate.since    >= vLoanDate
            NO-LOCK:

            IF CAN-DO(ENTRY(1, instr-rate.instr-code, "/"),
                      basset.commission
                     ) THEN
            DO:
               RESULT = instr-rate.rate-instr.
               RETURN.
            END.
         END.

         IF AVAILABLE  instr-rate THEN
         DO:
            RESULT = instr-rate.rate-instr.
            RETURN.
         END.
         ELSE
         DO:
            {message
               "Нет ни одного коэффициента переоценки для ОС ""  + bloan.doc-ref + string(basset.name) + "" !"
            }
         END.
      END.
   END.

   RETURN.
END PROCEDURE.

PROCEDURE checkcoff:
   DEF INPUT  PARAMETER op-code  AS INT      NO-UNDO.
   DEF OUTPUT PARAMETER RESULT   AS DECIMAL  NO-UNDO.

   DEF BUFFER bloan        FOR loan.
   DEF BUFFER basset       FOR asset.
   DEF BUFFER b-instr-rate FOR instr-rate.

   DEF VAR vLoanDate AS DATE NO-UNDO.

   vLoanDate = GetInDate(iContract,
                         iContCode,
                         "Б").

   FIND FIRST bloan WHERE
              bloan.contract  = iContract
          AND bloan.cont-code = iContCode
   NO-LOCK NO-ERROR.

   IF AVAILABLE bloan THEN
   DO:
      FIND FIRST basset OF bloan
      NO-LOCK NO-ERROR.

      IF AVAILABLE basset THEN
      DO:
         FIND FIRST b-instr-rate WHERE
                    b-instr-rate.instr-cat  = "overcode"
                AND b-instr-rate.rate-type  = misc[1]
                AND ENTRY(1, b-instr-rate.instr-code, "/") = basset.commission
                AND b-instr-rate.since     >= vLoanDate
         EXCLUSIVE-LOCK NO-ERROR.

         IF NOT AVAILABLE b-instr-rate THEN
         FOR EACH instr-rate WHERE
                  instr-rate.instr-cat  = "overcode"
              AND instr-rate.rate-type  = misc[1]
              AND instr-rate.since     >= vLoanDate
            NO-LOCK:

            IF CAN-DO(ENTRY(1, instr-rate.instr-code, "/"),
                      basset.commission
                     ) THEN
            DO:
               FIND b-instr-rate WHERE
                    RECID(b-instr-rate) = RECID(instr-rate)
               EXCLUSIVE-LOCK.

               RESULT = b-instr-rate.rate-instr.

               IF NUM-ENTRIES(b-instr-rate.instr-code, "/") > 1 THEN
                  b-instr-rate.instr-code =       b-instr-rate.instr-code
                                          + "," + STRING(op-code).
               ELSE
                  b-instr-rate.instr-code =       b-instr-rate.instr-code
                                          + "/" + STRING(op-code).
               RETURN.
            END.
         END.

         IF AVAILABLE  b-instr-rate THEN
         DO:
            IF NUM-ENTRIES(b-instr-rate.instr-code, "/") > 1 THEN
               b-instr-rate.instr-code =       b-instr-rate.instr-code
                                       + "," + STRING(op-code).
            ELSE
               b-instr-rate.instr-code =       b-instr-rate.instr-code
                                       + "/" + STRING(op-code).

            RESULT = b-instr-rate.rate-instr.

            RETURN.
         END.
         ELSE
         DO:
            {message
               "Нет ни одного коэффициента переоценки для ОС ""  + bloan.doc-ref + string(basset.name) + "" !"
            }
         END.
      END.
   END.

   RETURN.
END PROCEDURE.

PROCEDURE СуммаАмор:
   DEF INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   DEF BUFFER loan      FOR loan.

   /* Суффикс кода комиссии: Б - бухгалтерский, Н - налоговый. */
   DEF VAR iBuh-Nal     AS CHAR    NO-UNDO INITIAL "Б".

   /* Первоначальная/остаточная стоимость          */
   DEF VAR vInvCost     AS DECIMAL NO-UNDO.
   /* Норма амортизации месячная в %%              */
   DEF VAR vAmortNorm   AS DECIMAL NO-UNDO INITIAL ?.
   /* Метод начисления амортизации                 */
   DEF VAR vAmortMeth   AS CHAR    NO-UNDO.
   /* Дата для расчёта остаточной стоимости */
   DEF VAR vOstDate     AS DATE    NO-UNDO INITIAL ?.
   DEF VAR vInDate2     AS DATE    NO-UNDO.
   DEF VAR vTmpDate     AS DATE    NO-UNDO.
   

   IF res4 = 0 THEN
   FOR
      FIRST loan WHERE
            loan.contract  = iContract
        AND loan.cont-code = iContCode
      NO-LOCK:

      /* Амортизацию считаем на первое число месяца!  */
      vInDate2 = iDate.
      IF loan.class-code <> "НМА2" THEN
         iDate = FirstMonDate(iDate) - 1.

      /* Это важно: Если указана фиксированная сумма амортизации,
      ** то GetYearAmortNorm возвращает RETURN-VALUE = "FIXED"
      ** и норму = месячной фиксированной сумме амортизации.
      */
      RUN GetYearAmortNorm IN h_umc (       iContract,
                                            iContCode,
                                            iDate,
                                            iBuh-Nal,
                                     OUTPUT vAmortNorm
                                    ).

      /* Если указана фиксированная сумма амортизации (месячная) */
      IF RETURN-VALUE = "FIXED" THEN
         res4 = vAmortNorm.
      ELSE IF vAmortNorm > 0 THEN
      DO:
         /* При наличии модернизаций GetYearAmortNorm возвращает
         ** в RETURN-VALUE дату, с которой надо считать
         ** амортизацию от остаточной стоимости
         ** (как для нелинейного метода, но от остаточной стоимости.
         ** 82040 - считаем на первое число месяца).
         */
         IF RETURN-VALUE <> "" THEN
            vOstDate = DATE(RETURN-VALUE) NO-ERROR.

         IF vOstDate <> ? THEN
            vAmortMeth = "Модернизация".
         ELSE
            /* Метод начисления амортизации */
            vAmortMeth = GetXAttrValueEx ("loan",
                                          loan.contract + "," + loan.cont-code,
                                          "МетНачАморт",
                                          "Линейный"
                                         ).
         IF vAmortMeth = "Линейный" THEN
            /* Первоначальная стоимость */
            RUN ВосстСтоим (       iDate,
                            OUTPUT vInvCost
                           ).

         /* Остаточная стоимость на 1-е число расчетного месяца */
         ELSE
         IF vAmortMeth EQ "Модернизация" THEN
            RUN ОстатСтоим (       iDate,
                            OUTPUT vInvCost
                           ).

         ELSE
         DO:
            IF vOstDate = ? THEN
               vOstDate = DATE(1, 1, YEAR(vInDate2)) - 1.

            /* Остаточная бал.стоимость на начало года */
            RUN ОстатСтоим (       vOstDate,
                            OUTPUT vInvCost
                           ).
            IF vInvCost EQ 0 AND
               YEAR(vInDate2) EQ 
               YEAR(GetInDate(iContract,
                              iContCode,
                              "Б"
                             )
                   ) THEN
               RUN GetLoanDate IN h_umc (iContract,
                                         iContCode,
                                         "-учет",
                                         "InDate",
                                         OUTPUT vTmpDate,
                                         OUTPUT vInvCost
                                        ).

            /* Расчитали на другую дату - нужно все обнулить. */
            RUN Change (iContract,
                        iContCode,
                        iFace,
                        iBranch
                       ).
         END.
         res4 = ROUND(vInvCost * vAmortNorm / 1200, 2).
      END.
   END.

   IF res4 > 0 THEN
   DO:
      /* Остаточная бал.стоимость на текущую дату */
      RUN ОстатСтоим (       iDate,
                      OUTPUT res5
                     ).

      res4 = MIN(res4, res5).
   END.

   ASSIGN
     res4   = MAX(0, res4)
     RESULT = res4.

   RETURN.
END PROCEDURE.

/* Сумма налоговой амортизации за месяц по карточке УМЦ */
PROCEDURE СуммаАморНал:
   DEF INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   DEF BUFFER loan      FOR loan.
   DEF BUFFER comm-rate FOR comm-rate.
   DEF BUFFER asset     FOR asset.

   /* Суффикс кода комиссии: Б - бухгалтерский, Н - налоговый. */
   DEF VAR iBuh-Nal     AS CHAR    NO-UNDO INITIAL "Н".

   /* Норма амортизации месячная в %%              */
   DEF VAR vAmortNorm   AS DECIMAL NO-UNDO INITIAL ?.
   /* Метод начисления амортизации                 */
   DEF VAR vAmortMeth   AS CHAR    NO-UNDO.

   /* Первоначальная/остаточная стоимость          */
   DEF VAR vInvCost     AS DECIMAL NO-UNDO.
   /* Изменение первоначальной стоимости           */
   DEF VAR vInvCostChng AS DECIMAL NO-UNDO.
   /* Остаточная стоимость                         */
   DEF VAR vDeprCost    AS DECIMAL NO-UNDO.
   /* Дата для расчёта остаточной стоимости        */
   DEF VAR vOstDate     AS DATE    NO-UNDO INITIAL ?.
   /* Дата приходования в НУ                       */
   DEF VAR vInDate      AS DATE    NO-UNDO.
   DEF VAR vInDate2     AS DATE    NO-UNDO.
   /*Даты начала и окончания договора аренды       */
   DEF VAR vDogADate1   AS DATE    NO-UNDO.
   DEF VAR vDogADate2   AS DATE    NO-UNDO.
   /* Первое число текущего месяца                 */
   DEF VAR v1Date       AS DATE    NO-UNDO.
   /* Срок полезного использования                 */
   DEF VAR vUsefulLife  AS INT     NO-UNDO.
   /* Коэффициент ускорения амортизации            */
   DEF VAR vAmorAcclr   AS DECIMAL NO-UNDO INITIAL 1.
   /* Срок эксплуатации (ДР карточки СрокЭкспл)    */
   DEF VAR vExplPer     AS INT     NO-UNDO.
   DEF VAR mModernAmort AS DECIMAL NO-UNDO.
   /** Buryagin added this at 18/02/2009 */
   DEF VAR vInvCost2 AS DECIMAL NO-UNDO.

   IF res4nal = 0 THEN
   FOR FIRST loan WHERE
             loan.contract  = iContract
         AND loan.cont-code = iContCode
      NO-LOCK,
      FIRST asset Of loan NO-LOCK:
      /**/
      ASSIGN
         vDogADate1 = DATE(GetXattrValue("loan", iContract + "," + iContCode, "ДогАрендыНач"))
         vDogADate1 = DATE(GetXattrValue("loan", iContract + "," + iContCode, "ДогАрендыНач"))
         mModernAmort = DEC(GetXattrValue("loan", iContract + "," + iContCode, "СуммаАморНУ"))

      .
      IF (vDogADate1 NE ? AND
          vDogADate2 NE ?
         ) AND
         (iDate < LastMonDate(vDogADate1) + 1 OR
          iDate > LastMonDate(vDogADate2) + 1
         ) THEN LEAVE.

      /* Амортизацию считаем на первое число месяца!  */
      vInDate2 = iDate.
      IF loan.class-code <> "НМА2" THEN
         iDate = FirstMonDate(iDate) - 1.
      /* Это важно: Если указана фиксированная сумма амортизации,
      ** то GetYearAmortNorm возвращает RETURN-VALUE = "FIXED"
      ** и норму = месячной фиксированной сумме амортизации.
      */
      RUN GetYearAmortNorm IN h_umc (       iContract,
                                            iContCode,
                                            iDate,
                                            iBuh-Nal,
                                     OUTPUT vAmortNorm
                                    ).
/*      message RETURN-VALUE vAmortNorm VIEW-AS ALERT-BOX. */
      /* Если указана фиксированная сумма амортизации (месячная) */
      IF RETURN-VALUE = "FIXED" THEN
         res4nal = vAmortNorm.
      ELSE IF vAmortNorm > 0 THEN
      DO:
         /* При наличии модернизаций GetYearAmortNorm возвращает
         ** в RETURN-VALUE дату, с которой надо считать
         ** амортизацию от остаточной стоимости
         ** (как для нелинейного метода, но от остаточной стоимости
         ** на дату модернизации, а не на начало года).
         */

         IF RETURN-VALUE <> "" THEN
            vOstDate = DATE(RETURN-VALUE) NO-ERROR.

         IF vOstDate <> ? THEN
            vAmortMeth = "Модернизация".
         ELSE
         /* Метод начисления амортизации */
         vAmortMeth = GetXAttrValueEx ("loan",
                                       loan.contract + "," + loan.cont-code,
                                       "НалМетНачАмор",
                                       "Линейный"
                                      ).

         IF    vOstDate   EQ ?
            OR vAmortMeth EQ "Модернизация" THEN
            vOstDate = iDate.

         /* Остаточная налоговая стоимость */
         RUN ОстатСтоимНал (       vOstDate,
                            OUTPUT vDeprCost
                           ).
         /* Первоначальная налоговая стоимость */
         RUN ПервСтоимНал (       iDate,
                            OUTPUT vInvCost
                           ).

		/** PIRBANK: buryagin added this code at 18/02/2009 */
	
		/* если карточка заведена позднее 01/01/2006,
		тогда амортизация считается за минусом 10% от первоначальной стоимости */
	 	 vInvCost2 = vInvCost.
	     if (GetInDate(loan.contract,
                      loan.cont-code,
                      "Б"
                      ) > 01/01/2006) or (loan.open-date > 01/01/2006) then
         DO:
		      
		   		vInvCost = vInvCost - (vInvCost * 0.1).
		      
		 END.
		 
		 
		 /** с 2009 года все ОС с 3 по 7 группу "премируются" 30% */
	     if (GetInDate(loan.contract,
                      loan.cont-code,
                      "Б"
                      ) > 01/01/2009) or (loan.open-date > 01/01/2009) then
         DO:
         
		          	IF can-do("03,04,05,06,07", GetXAttrValueEx("asset", 
                            GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)),
                            "AmortGr",
                            ?
                           )) 
            		THEN
		   				vInvCost = vInvCost2 - (vInvCost2 * 0.3).
		 END.
 
		      
		/** PIRBANK: buryagin end */

         /* Утверждается, что проверки "группа = 99" достаточно,
         ** но можно ещё проверить, что введена в эксплуатацию до 01.01.2002:
         ** GetInDate(loan.contract,
         **           loan.cont-code,
         **           "Б"
         **          ) < 01/01/2002
         */

         IF GetXAttrValueEx("asset", /* 99-я группа амортизации */
                            GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)),
                            "AmortGr",
                            ?
                           ) = "99" THEN
            vAmortMeth = "Линейный".

         IF vAmortMeth = "Линейный" THEN
            /* Изменение первоначальной стоимости */
            RUN ИзмНалСтоим   (       iDate,
                               OUTPUT vInvCostChng
                              ).
         ELSE
         DO:
            /* Если остаточная стоимость достигла 20% от первоначальной */
            IF vDeprCost <= 0.2 * vInvCost THEN
            DO:
               ASSIGN
                  /* Срок полезного использования */
                  vUsefulLife = INT(GetSrokAmor(RECID(loan),
                                                "СПИ" + iBuh-Nal,
                                                iDate
                                               )
                                   )
                  /* Дата, с которой начали амортизацию */
                  vInDate     = LastMonDate(GetInDate(loan.contract,
                                                      loan.cont-code,
                                                      iBuh-Nal
                                                     )
                                           ) + 1

                  /* Первое число текущего месяца      */
                  v1Date      = FirstMonDate(iDate)

                  vUsefulLife = MAX(0,
                                    vUsefulLife - INT(MonInPer(vInDate,
                                                               v1Date
                                                              )
                                                     )
                                   )
                  vAmortNorm  = 100 / vUsefulLife.
            END.

            vInvCost = vDeprCost.
         END.

		IF    fGetSetting("УчетМодернНУ", ?, ?) EQ "Да"
              OR vAmortMeth                        EQ "Нелинейный" THEN
        DO:
            
            res4nal = MIN(vDeprCost,
                          ROUND((vInvCost + vInvCostChng /*-
                                 GetLoan-Pos ( iContract,
                                               iContCode,
                                               "нал-р10",
                                               (IF GetLoan-Pos (iContract,
                                                                iContCode,
                                                                'нал-амор',
                                                                iDate
                                                               ) > 0 THEN
                                                   iDate
                                               ELSE vInDate2)
                                             ) */
                                ) * vAmortNorm / 1200, 2
                               )
                         ).
        END.
        ELSE 
        DO:
            res1nal = 0.

            /* Первоначальная налоговая стоимость */
            RUN ПервСтоимНал (       iDate,
                               OUTPUT vInvCost
                              ).

            RUN ИзмНалСтоим   (       iDate,
                               OUTPUT vInvCostChng
                              ).

            vExplPer = INT(GetXAttrValueEx("loan",
                                           loan.contract + "," + loan.cont-code,
                                           "СрокЭкспл",
                                           "0"
                                          )
                          ) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
               vExplPer = 0.

            ASSIGN
               /* Срок полезного использования */
               vUsefulLife = INT(GetSrokAmor(RECID(loan),
                                             "СПИ" + iBuh-Nal,
                                             vInDate2
                                            )
                                )



               /* Коэффициент ускорения амортизации */
               vAmorAcclr  = GetSrokAmor(RECID(loan),
                                         "КУ" + iBuh-Nal,
                                         vInDate2
                                        )

               /* Дата, с которой начали амортизацию */
               vInDate     = LastMonDate(GetInDate(loan.contract,
                                                   loan.cont-code,
                                                   iBuh-Nal
                                                  )
                                        ) + 1

               vUsefulLife = vUsefulLife - vExplPer

               vAmortNorm  = 1 / vUsefulLife

               res4nal     = ROUND((vInvCost
                                  - GetLoan-Pos (iContract,
                                                 iContCode,
                                                 "нал-р10",
                                                 (IF GetLoan-Pos (iContract,
                                                                  iContCode,
                                                                  'нал-амор',
                                                                  iDate
                                                                 ) > 0
                                                  THEN iDate
                                                  ELSE vInDate2
                                                 )
                                                )
                                  + vInvCostChng
                                   ) *  vAmortNorm
                                     * (IF    vAmorAcclr  EQ ?
                                           OR vAmorAcclr  LE 0
                                        THEN 1
                                        ELSE vAmorAcclr
                                       ), 2
                                  )
            .
         END.
      END.
    END.

   if mModernAmort > 0 then res4nal = mModernAmort.

   ASSIGN
      res4nal = MAX(0, res4nal)
      RESULT  = res4nal.

   RETURN.
END PROCEDURE.

PROCEDURE СуммаАморСолид:
   DEF INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   DEF VAR  aDisc  AS DECIMAL  NO-UNDO.

   RUN ЦенаМЦ (iDate,OUTPUT aDisc).

   FIND FIRST loan WHERE
              loan.contract  = iContract
          AND loan.cont-code = iContCode
   NO-LOCK NO-ERROR.

   FIND FIRST asset OF loan NO-LOCK.

   FIND LAST loan-acct OF loan WHERE
             loan-acct.acct-type = loan.contract + "-учет"
   NO-LOCK.

   FIND LAST comm-rate WHERE
             comm-rate.commission = asset.commission
         AND comm-rate.acct       = loan-acct.acct
         AND comm-rate.currency   = loan-acct.currency
         AND comm-rate.since     <= iDate
   NO-LOCK NO-ERROR.

   IF NOT AVAILABLE comm-rate THEN
      FIND LAST comm-rate WHERE
                comm-rate.commission = asset.commission
            AND comm-rate.acct       = "0"
            AND comm-rate.currency   = ""
            AND comm-rate.since     <= iDate
      NO-LOCK NO-ERROR.

   IF FGetSetting("norm-amort",?,?) = "Г" THEN
   DO:
      RESULT = IF AVAILABLE comm-rate THEN (IF comm-rate.rate-fixed THEN
         comm-rate.rate-comm ELSE (aDisc * comm-rate.rate-comm / 1200)) ELSE 0.
   END.
   ELSE
   DO:
      RESULT = IF AVAILABLE comm-rate THEN (IF comm-rate.rate-fixed THEN
         comm-rate.rate-comm ELSE (aDisc * comm-rate.rate-comm / 100)) ELSE 0.
   END.

   RETURN.
END PROCEDURE.


PROCEDURE Кау:
   DEF OUTPUT PARAMETER RESULT  AS CHAR  NO-UNDO.

   RESULT =       iContract
          + "," + iContCode
          + "," + (IF iFace = ?
                   THEN ","
                   ELSE STRING(iFace) + "," + iBranch
                  ).
   RETURN.
END PROCEDURE.

PROCEDURE СуммаКарт:
   DEF INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   DEF VAR v-tmpchar  AS CHAR  NO-UNDO.

   v-tmpchar =       iContract
             + "," + iContCode
             + "," + STRING(iFace)
             + "," + iBranch.

   {a-calc.i
      &no-amor = YES
      &no-over = YES
      &kau     = v-tmpchar
      &in-date = iDate
   }

   RESULT = a-disc.

   RETURN.
END PROCEDURE.

PROCEDURE КолКарт:
   DEF INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEF OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   DEF VAR v-tmpchar  AS CHAR  NO-UNDO.

   v-tmpchar =       iContract
             + "," + iContCode
             + "," + STRING(iFace)
             + "," + iBranch.

   {a-calc.i
      &no-amor      = YES
      &no-over      = YES
      &kau          = v-tmpchar
      &in-date      = iDate
   }

   RESULT = a-qty.

   RETURN.
END PROCEDURE.


PROCEDURE СуммаКартU:
   DEFINE INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEFINE OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   DEFINE VARIABLE vSum      AS DECIMAL EXTENT 2          NO-UNDO.

   RUN GetKauPos IN h_umc (INPUT             iContract
                                     + "," + iContCode
                                     + "," + STRING(iFace)
                                     + "," + iBranch,
                           INPUT  "авто",
                           INPUT  iDate,
                           OUTPUT vSum[1],
                           OUTPUT vSum[2]
                                   ).
   RESULT = vSum[1].

   RETURN.
END PROCEDURE.

PROCEDURE КолКартU:
   DEFINE INPUT  PARAMETER iDate   AS DATE     NO-UNDO.
   DEFINE OUTPUT PARAMETER RESULT  AS DECIMAL  NO-UNDO.

   DEFINE VARIABLE vSum      AS DECIMAL EXTENT 2          NO-UNDO.

   RUN GetKauPos IN h_umc (INPUT              iContract
                                     + "," + iContCode
                                     + "," + STRING(iFace)
                                     + "," + iBranch,
                           INPUT  "авто",
                           INPUT  iDate,
                           OUTPUT vSum[1],
                           OUTPUT vSum[2]
                                   ).
   RESULT = vSum[2].

   RETURN.
END PROCEDURE.

