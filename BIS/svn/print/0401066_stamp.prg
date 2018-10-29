/*po-uni.p*/
&IF "{&OFFSET}" EQ "NO" &THEN
      &SCOP OFFSET_VAL 0
&ELSE
      &SCOP OFFSET_VAL 1703
&ENDIF

&SCOP KOEF 2

&IF DEFINED(SET_DATA) &THEN
   DEFINE VAR lzr-Cond-Pay       AS CHARACTER
                                    EXTENT      3 NO-UNDO.
   DEFINE VAR lzr-Amt-Rub        AS CHARACTER
                                    EXTENT      3 NO-UNDO.
   DEFINE VAR lzr-Plat-Name      AS CHARACTER
                                    EXTENT      5 NO-UNDO.
   DEFINE VAR lzr-Plat-Bank      AS CHARACTER
                                    EXTENT      3 NO-UNDO.
   DEFINE VAR lzr-Pol-Name       AS CHARACTER
                                    EXTENT      5 NO-UNDO.
   DEFINE VAR lzr-Pol-Bank       AS CHARACTER
                                    EXTENT      3 NO-UNDO.
   DEFINE VAR lzr-Details        AS CHARACTER
                                    EXTENT      8 NO-UNDO.
   DEFINE VAR vInnPl             AS CHARACTER     NO-UNDO.
   DEFINE VAR vInnPo             AS CHARACTER     NO-UNDO.
   DEFINE VAR vKppPl             AS CHARACTER     NO-UNDO.
   DEFINE VAR vKppPo             AS CHARACTER     NO-UNDO.
   DEFINE VAR vI                 AS INT64       NO-UNDO.

   DEFINE VARIABLE vIsLongPolName AS LOGICAL NO-UNDO.
   DEFINE VARIABLE vIsLongPlaName AS LOGICAL NO-UNDO.


   DEFINE VARIABLE cUserID AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cUserNAME AS CHARACTER NO-UNDO.

   ASSIGN
      lzr-Amt-Rub[1]   = AmtStr[1] + " " +
                         AmtStr[2] + " " +
                         AmtStr[3]
      lzr-Plat-Name[1] = PlName[1] + " " +
                         PlName[2] + " " +
                         PlName[3] + " " +
                         PlName[4] + " " +
                         PlName[5]
      lzr-Plat-Bank[1] = PlRKC[1] + " " +
                         PlRKC[2]
      lzr-Pol-Bank[1]  = PoRKC[1] + " " +
                         PoRKC[2]
      lzr-Pol-Name[1]  = PoName[1] + " " +
                         PoName[2] + " " +
                         PoName[3] + " " +
                         PoName[4] + " " +
                         PoName[5]
      lzr-Details[1]   = Detail[1] + " " +
                         Detail[2] + " " +
                         Detail[3] + " " +
                         Detail[4] + " " +
                         Detail[5]
      lzr-Details[1]   = op.details WHEN AVAIL op
   .

   {wordwrap.i &s=lzr-Amt-Rub     &n=2 &l=63}
   {wordwrap.i &s=lzr-Plat-Bank   &n=2 &l=39}
   {wordwrap.i &s=lzr-Pol-Bank    &n=2 &l=39}

&IF {&FORM-DOC} EQ 66 &THEN
   {wordwrap.i &s=lzr-Details     &n=7 &l=45}

   IF lzr-Pol-Name[1] BEGINS "ˆ " THEN
      SUBSTRING(lzr-Pol-Name[1],1,3) = "   ".
   ELSE
      lzr-Pol-Name[1] = "   " + lzr-Pol-Name[1].

   IF lzr-Plat-Name[1] BEGINS "ˆ " THEN
      SUBSTRING(lzr-Plat-Name[1],1,3)  = "   ".
   ELSE
      lzr-Plat-Name[1]  = lzr-Plat-Name[1] + "   ".

   vIsLongPolName = NO.
   vIsLongPlaName = NO.

   IF LENGTH(lzr-Plat-Name[1]) GT 110 THEN
   DO:
      vIsLongPlaName = YES.
      {wordwrap.i &s=lzr-Plat-Name    &n=5 &l=64}
   END.
   ELSE
   DO:
      {wordwrap.i &s=lzr-Plat-Name    &n=5 &l=39}
   END.

   IF LENGTH(lzr-Pol-Name[1]) GT 110 THEN
   DO:
      vIsLongPolName = YES.
      {wordwrap.i &s=lzr-Pol-Name    &n=5 &l=64}
   END.
   ELSE
   DO:
      {wordwrap.i &s=lzr-Pol-Name    &n=5 &l=39}
   END.
&ELSE
/*“ª § ­¨¥ 1256*/
   IF lzr-Plat-Name[1] BEGINS "ˆ " THEN
   DO:
      vI = 4.

      DO WHILE SUBSTRING(lzr-Plat-Name[1],vI,1) EQ " ":
         vI = vI + 1.
      END.

      DO WHILE LOOKUP(SUBSTRING(lzr-Plat-Name[1],vI,1),"0,1,2,3,4,5,6,7,8,9") > 0 :
         vI = vI + 1.
      END.

      ASSIGN
         vInnPl           = trim(substring(lzr-Plat-Name[1],5,vI - 5))
         lzr-Plat-Name[1] = trim(substring(lzr-Plat-Name[1],vI))
      .
   END.

   IF lzr-Pol-Name[1] BEGINS "ˆ " THEN
   DO:
      vI = 4.

      DO WHILE SUBSTRING(lzr-Pol-Name[1],vI,1) EQ " " :
         vI = vI + 1.
      END.

      DO WHILE LOOKUP(SUBSTRING(lzr-Pol-Name[1],vI,1),"0,1,2,3,4,5,6,7,8,9") > 0 :
         vI = vI + 1.
      END.

      ASSIGN
         vInnPo           = trim(substring(lzr-Pol-Name[1],5,vI - 5))
         lzr-Pol-Name[1] = trim(substring(lzr-Pol-Name[1],vI))
      .
   END.

   IF lzr-Plat-Name[1] BEGINS "Š" THEN
   DO:
      vI = 4.

      DO WHILE SUBSTRING(lzr-Plat-Name[1],vI,1) EQ " ":
         vI = vI + 1.
      END.

      DO WHILE LOOKUP(SUBSTRING(lzr-Plat-Name[1],vI,1),"0,1,2,3,4,5,6,7,8,9") > 0 :
         vI = vI + 1.
      END.

      ASSIGN
         vKppPl           = trim(substring(lzr-Plat-Name[1],5,vI - 5))
         lzr-Plat-Name[1] = substring(lzr-Plat-Name[1],vI)
      .
   END.

   IF lzr-Pol-Name[1] BEGINS "Š" THEN
   DO:
      vI = 4.

      DO WHILE SUBSTRING(lzr-Pol-Name[1],vI,1) EQ " " :
         vI = vI + 1.
      END.

      DO WHILE LOOKUP(SUBSTRING(lzr-Pol-Name[1],vI,1),"0,1,2,3,4,5,6,7,8,9") > 0 :
         vI = vI + 1.
      END.

      ASSIGN
         vKppPo           = trim(substring(lzr-Pol-Name[1],5,vI - 5))
         lzr-Pol-Name[1] = substring(lzr-Pol-Name[1],vI)
      .
   END.
   {wordwrap.i &s=lzr-Details     &n=8 &l=45}
   vIsLongPolName = NO.
   vIsLongPlaName = NO.

   IF LENGTH(lzr-Plat-Name[1]) GT 110 THEN
   DO:
      vIsLongPlaName = YES.
      {wordwrap.i &s=lzr-Plat-Name    &n=5 &l=64}
   END.
   ELSE
   DO:
      {wordwrap.i &s=lzr-Plat-Name    &n=5 &l=39}
   END.

   IF LENGTH(lzr-Pol-Name[1]) GT 110 THEN
   DO:
      vIsLongPolName = YES.
      {wordwrap.i &s=lzr-Pol-Name    &n=5 &l=64}
   END.
   ELSE
   DO:
      {wordwrap.i &s=lzr-Pol-Name    &n=5 &l=39}
   END.
&ENDIF
   ASSIGN
      lzr-Plat-Name[3] = substring(lzr-plat-name[3], 1,39)
      lzr-Plat-Bank[2] = substring(lzr-Plat-Bank[2], 1,39)
      lzr-pol-name[5]  = substring(lzr-pol-name[5],  1,39)
      lzr-Pol-Bank[2]  = substring(lzr-Pol-Bank[2],  1,39)
   .

&ENDIF

&IF DEFINED(PRINT) &THEN
&IF {&FORM-DOC} EQ 66 &THEN
   RUN PRINT_PITCH(                                           INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(650 * {&KOEF},60    + {&OFFSET_VAL},op.doc-num,INPUT-OUTPUT buf-str).




   RUN PUT_PCL_STR(1025 * {&KOEF},(55   + {&OFFSET_VAL}) * {&KOEF},TheDate,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(380 * {&KOEF},(160   + {&OFFSET_VAL}) * {&KOEF},lzr-Amt-Rub[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(380 * {&KOEF},(210   + {&OFFSET_VAL}) * {&KOEF},lzr-Amt-Rub[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1565 * {&KOEF},(55   + {&OFFSET_VAL}) * {&KOEF},PayType,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(285  + {&OFFSET_VAL}) * {&KOEF},TRIM(Rub),INPUT-OUTPUT buf-str).

   IF vIsLongPlaName THEN
      RUN PRINT_COMPRESSED(                                   INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(284   + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Name[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(329   + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Name[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(374   + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Name[3],INPUT-OUTPUT buf-str).

   IF vIsLongPlaName THEN
      RUN PRINT_PITCH(                                        INPUT-OUTPUT buf-str).

   RUN PUT_PCL_STR(1505 * {&KOEF},(415  + {&OFFSET_VAL}) * {&KOEF},SUBSTRING(PlLAcct,1,25),INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(470   + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Bank[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(515   + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Bank[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(489  + {&OFFSET_VAL}) * {&KOEF},PlMFO,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(553  + {&OFFSET_VAL}) * {&KOEF},SUBSTRING(PlCAcct,1,25),INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(610   + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Bank[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(655   + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Bank[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(630  + {&OFFSET_VAL}) * {&KOEF},PoMFO,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(696  + {&OFFSET_VAL}) * {&KOEF},SUBSTRING(PoCAcct,1,25),INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(767  + {&OFFSET_VAL}) * {&KOEF},SUBSTRING(PoAcct,1,25),INPUT-OUTPUT buf-str).

   IF vIsLongPolName THEN
      RUN PRINT_COMPRESSED(                                   INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(757   + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Name[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(802   + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Name[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(847   + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Name[3],INPUT-OUTPUT buf-str).

   IF vIsLongPolName THEN
      RUN PRINT_PITCH(                                        INPUT-OUTPUT buf-str).

   RUN PUT_PCL_STR(140 * {&KOEF},(998   + {&OFFSET_VAL}) * {&KOEF},numPartPayment,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(383 * {&KOEF},(998   + {&OFFSET_VAL}) * {&KOEF},codePayDoc,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(680 * {&KOEF},(998   + {&OFFSET_VAL}) * {&KOEF},numPayDoc,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(975 * {&KOEF},(998   + {&OFFSET_VAL}) * {&KOEF},STRING(DatePayDoc,"99.99.9999"),INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(828  + {&OFFSET_VAL}) * {&KOEF},IF AVAIL doc-type THEN
                                             doc-type.digital
                                             ELSE
                                             op.doc-type,INPUT-OUTPUT buf-str).
/*   RUN PUT_PCL_STR(1505 * {&KOEF},(888  + {&OFFSET_VAL}) * {&KOEF},"(20)",INPUT-OUTPUT buf-str).*/
/*   RUN PUT_PCL_STR(1505 * {&KOEF},(947  + {&OFFSET_VAL}) * {&KOEF},"(21)",INPUT-OUTPUT buf-str).*/

   IF INT64(op.order-pay) GT 0 THEN
      RUN PUT_PCL_STR(1975 * {&KOEF},(858  + {&OFFSET_VAL}) * {&KOEF},IF SUBSTRING(op.order-pay,1,1) EQ "0" THEN SUBSTRING(op.order-pay,2,1) 
                                                                                      ELSE op.order-pay,INPUT-OUTPUT buf-str).
/*   RUN PUT_PCL_STR(1975 * {&KOEF},(947  + {&OFFSET_VAL}) * {&KOEF},IF AVAIL doc-type THEN
                                             doc-type.doc-type
                                             ELSE
                                             op.doc-type,INPUT-OUTPUT buf-str).*/
   RUN PUT_PCL_STR(1505 * {&KOEF},(1005 + {&OFFSET_VAL}) * {&KOEF},sum-balance-str,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(580 * {&KOEF},(1064  + {&OFFSET_VAL}) * {&KOEF},DestPay,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1155  + {&OFFSET_VAL}) * {&KOEF},lzr-Details[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1205  + {&OFFSET_VAL}) * {&KOEF},lzr-Details[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1255  + {&OFFSET_VAL}) * {&KOEF},lzr-Details[3],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1305  + {&OFFSET_VAL}) * {&KOEF},lzr-Details[4],INPUT-OUTPUT buf-str).
RUN PUT_PCL_STR(130 * {&KOEF},(1355     + {&OFFSET_VAL}) * {&KOEF},lzr-Details[5],INPUT-OUTPUT buf-str).
RUN PUT_PCL_STR(130 * {&KOEF},(1405     + {&OFFSET_VAL}) * {&KOEF},lzr-Details[6],INPUT-OUTPUT buf-str).
RUN PUT_PCL_STR(130 * {&KOEF},(1455     + {&OFFSET_VAL}) * {&KOEF},lzr-Details[7],INPUT-OUTPUT buf-str).
   RUN PRINT_PITCH(                                           INPUT-OUTPUT buf-str).
&ELSE
/*“ª § ­¨¥ 1256*/
   RUN PRINT_PITCH(                                           INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(650 * {&KOEF}, (158  + {&OFFSET_VAL}) * {&KOEF},op.doc-num,      INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1025 * {&KOEF},(153  + {&OFFSET_VAL}) * {&KOEF},TheDate,         INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1465 * {&KOEF},(153  + {&OFFSET_VAL}) * {&KOEF},PayType,         INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(380 * {&KOEF}, (235  + {&OFFSET_VAL}) * {&KOEF},lzr-Amt-Rub[1],  INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(380 * {&KOEF}, (285  + {&OFFSET_VAL}) * {&KOEF},lzr-Amt-Rub[2],  INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(365  + {&OFFSET_VAL}) * {&KOEF},TRIM(Rub),       INPUT-OUTPUT buf-str).
/*   RUN PUT_PCL_STR(245 * {&KOEF}, (360  + {&OFFSET_VAL}) * {&KOEF},PlINN,           INPUT-OUTPUT buf-str).*/
   RUN PUT_PCL_STR(245 * {&KOEF}, (360  + {&OFFSET_VAL}) * {&KOEF},vInnPl,           INPUT-OUTPUT buf-str).
/*   RUN PUT_PCL_STR(825 * {&KOEF}, (360  + {&OFFSET_VAL}) * {&KOEF},PlKPP,           INPUT-OUTPUT buf-str).*/
RUN PUT_PCL_STR(825 * {&KOEF}, (360  + {&OFFSET_VAL}) * {&KOEF},vKppPl,           INPUT-OUTPUT buf-str).


   IF vIsLongPlaName THEN
      RUN PRINT_COMPRESSED(                                   INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (405  + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Name[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (450  + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Name[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (495  + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Name[3],INPUT-OUTPUT buf-str).

   IF vIsLongPlaName THEN
      RUN PRINT_PITCH(                                        INPUT-OUTPUT buf-str).

   RUN PUT_PCL_STR(1505 * {&KOEF},(485  + {&OFFSET_VAL}) * {&KOEF},SUBSTRING(PlLAcct,1,25),
                                                              INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (595  + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Bank[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (640  + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Bank[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(595  + {&OFFSET_VAL}) * {&KOEF},PlMFO,           INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(660  + {&OFFSET_VAL}) * {&KOEF},SUBSTRING(PlCAcct,1,25),
                                                              INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (775  + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Bank[1], INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (820  + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Bank[2], INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(775  + {&OFFSET_VAL}) * {&KOEF},PoMFO,           INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(835  + {&OFFSET_VAL}) * {&KOEF},SUBSTRING(PoCAcct,1,25),
                                                              INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(955  + {&OFFSET_VAL}) * {&KOEF},SUBSTRING(PoAcct,1,25),
                                                              INPUT-OUTPUT buf-str).


/*   RUN PUT_PCL_STR(245 * {&KOEF}, (950  + {&OFFSET_VAL}) * {&KOEF},PoINN ,          INPUT-OUTPUT buf-str).*/
   RUN PUT_PCL_STR(245 * {&KOEF}, (950  + {&OFFSET_VAL}) * {&KOEF},vInnPo ,          INPUT-OUTPUT buf-str).
/*   RUN PUT_PCL_STR(825 * {&KOEF}, (950  + {&OFFSET_VAL}) * {&KOEF},PoKPP,           INPUT-OUTPUT buf-str).*/
   RUN PUT_PCL_STR(825 * {&KOEF}, (950  + {&OFFSET_VAL}) * {&KOEF},vKppPo,           INPUT-OUTPUT buf-str).

   IF vIsLongPolName THEN
      RUN PRINT_COMPRESSED(                                   INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (1000 + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Name[1], INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (1045 + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Name[2], INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (1090 + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Name[3], INPUT-OUTPUT buf-str).

   IF vIsLongPolName THEN
      RUN PRINT_PITCH(                                        INPUT-OUTPUT buf-str).

   RUN PUT_PCL_STR(140 * {&KOEF}, (1240 + {&OFFSET_VAL}) * {&KOEF},numPartPayment,  INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(383 * {&KOEF}, (1240 + {&OFFSET_VAL}) * {&KOEF},codePayDoc,      INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(680 * {&KOEF}, (1240 + {&OFFSET_VAL}) * {&KOEF},numPayDoc,       INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(975 * {&KOEF}, (1240 + {&OFFSET_VAL}) * {&KOEF},STRING(DatePayDoc,"99.99.9999"),INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(1075 + {&OFFSET_VAL}) * {&KOEF},IF AVAIL doc-type THEN doc-type.digital
                                                               ELSE op.doc-type,
                   INPUT-OUTPUT buf-str).

   IF INT64(op.order-pay) GT 0 THEN
      RUN PUT_PCL_STR(1975 * {&KOEF},(1075 + {&OFFSET_VAL}) * {&KOEF},IF SUBSTRING(op.order-pay,1,1) EQ "0"
                                                THEN SUBSTRING(op.order-pay,2,1)
                                                ELSE op.order-pay,
                   INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(1255 + {&OFFSET_VAL}) * {&KOEF},sum-balance-str, INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(580 * {&KOEF}, (1310 + {&OFFSET_VAL}) * {&KOEF},DestPay,         INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (1455 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[1],  INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (1500 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[2],  INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (1545 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[3],  INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (1590 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[4],  INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (1635 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[5],  INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (1680 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[6],  INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (1725 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[7],  INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF}, (1770 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[8],  INPUT-OUTPUT buf-str).
/* ­®¢ë¥ ¯®«ï */
   RUN PUT_PCL_STR(2185 * {&KOEF}, (153  + {&OFFSET_VAL}) * {&KOEF}, mPokST,        INPUT-OUTPUT buf-str).
   RUN PRINT_ELITE(                                           INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(150 * {&KOEF},  (1365 + {&OFFSET_VAL}) * {&KOEF}, mKBK,          INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(690 * {&KOEF},  (1365 + {&OFFSET_VAL}) * {&KOEF}, mOKATO,        INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1030 * {&KOEF}, (1365 + {&OFFSET_VAL}) * {&KOEF}, mPokOp,        INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1157 * {&KOEF}, (1365 + {&OFFSET_VAL}) * {&KOEF}, mPokNP,        INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1440 * {&KOEF}, (1365 + {&OFFSET_VAL}) * {&KOEF}, mPokND,        INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1855 * {&KOEF}, (1365 + {&OFFSET_VAL}) * {&KOEF}, mPokDD,        INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(2170 * {&KOEF}, (1365 + {&OFFSET_VAL}) * {&KOEF}, mPokTP,        INPUT-OUTPUT buf-str).
   RUN PRINT_ELITE(                                             INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1710 * {&KOEF}, ( 1890 + {&OFFSET_VAL} ) * {&KOEF}, STRING(op.op-date, "99.99.9999"), INPUT-OUTPUT buf-str).
   cUserID = OP.user-id.
   FIND FIRST _user WHERE _user._userid EQ cUserID NO-LOCK NO-ERROR. 
      cUserNAME = _user._user-name. 

       RUN PUT_PCL_STR(1520 * {&KOEF}, ( 1960 + {&OFFSET_VAL} ) * {&KOEF}, cUserNAME,     INPUT-OUTPUT buf-str). 


   RUN PRINT_PITCH(                                           INPUT-OUTPUT buf-str).
&ENDIF
&ENDIF
