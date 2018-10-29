/*pt-uni.p*/
/* Платежное требование */
&IF "{&OFFSET}" EQ "NO" &THEN
      &SCOP OFFSET_VAL 0
&ELSE
      &SCOP OFFSET_VAL 1000
&ENDIF

&SCOP KOEF 2

&IF DEFINED(SET_DATA) &THEN
   DEFINE VAR lzr-Cond-Pay       AS CHARACTER
                                    EXTENT      3 NO-UNDO.
   DEFINE VAR lzr-Amt-Rub        AS CHARACTER
                                    EXTENT      3 NO-UNDO.
   DEFINE VAR lzr-Plat-Name      AS CHARACTER
                                    EXTENT      6 NO-UNDO.
   DEFINE VAR lzr-Plat-Bank      AS CHARACTER
                                    EXTENT      3 NO-UNDO.
   DEFINE VAR lzr-Pol-Name       AS CHARACTER
                                    EXTENT      6 NO-UNDO.
   DEFINE VAR lzr-Pol-Bank       AS CHARACTER
                                    EXTENT      3 NO-UNDO.
   DEFINE VAR lzr-Details        AS CHARACTER
                                    EXTENT      7 NO-UNDO.

   DEFINE VARIABLE vIsLongPolName AS LOGICAL NO-UNDO.
   DEFINE VARIABLE vIsLongPlaName AS LOGICAL NO-UNDO.

   DEFINE VARIABLE cUserID AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cUserNAME AS CHARACTER NO-UNDO.

   ASSIGN
      lzr-Cond-Pay[1]  = Cond-Pay[1] + " " +
                         Cond-Pay[2] + " " +
                         Cond-Pay[3].
      lzr-Amt-Rub[1]   = AmtStr[1] + " " +
                         AmtStr[2] + " " +
                         AmtStr[3].
      lzr-Plat-Name[1] = PlName[1] + " " +
                         PlName[2] + " " +
                         PlName[3] + " " +
                         PlName[4] + " " +
                         PlName[5].
      lzr-Plat-Bank[1] = PlRKC[1] + " " +
                         PlRKC[2].
      lzr-Pol-Bank[1]  = PoRKC[1] + " " +
                         PoRKC[2].
      lzr-Pol-Name[1]  = PoName[1] + " " +
                         PoName[2] + " " +
                         PoName[3] + " " +
                         PoName[4] + " " +
                         PoName[5].
      lzr-Details[1] =   op.details
   .

   IF lzr-Pol-Name[1] BEGINS "ИНН " THEN
      SUBSTRING(lzr-Pol-Name[1],1,3) = "~001~001~001".
   ELSE
      lzr-Pol-Name[1] = "~001~001~001" + lzr-Pol-Name[1].

   IF lzr-Plat-Name[1] BEGINS "ИНН " THEN
      SUBSTRING(lzr-Plat-Name[1],1,3)  = "~001~001~001".
   ELSE
      lzr-Plat-Name[1] = "~001~001~001" + lzr-Plat-Name[1].

   {wordwrap.i &s=lzr-Cond-Pay    &n=3 &l=51}
   {wordwrap.i &s=lzr-Amt-Rub     &n=3 &l=63}
   {wordwrap.i &s=lzr-Plat-Name   &n=6 &l=39}
   {wordwrap.i &s=lzr-Plat-Bank   &n=3 &l=39}
   {wordwrap.i &s=lzr-Pol-Name    &n=6 &l=39}
   {wordwrap.i &s=lzr-Pol-Bank    &n=3 &l=39}
   {wordwrap.i &s=lzr-Details     &n=7 &l=71}

   vIsLongPolName = NO.
   vIsLongPlaName = NO.

   IF LENGTH(TRIM(lzr-Plat-Name[6])) GT 0 THEN
   DO:
      vIsLongPlaName = YES.
      lzr-Plat-Name[1] = "~001~001~001" + lzr-Plat-Name[1] + " " +
                         lzr-Plat-Name[2] + " " +
                         lzr-Plat-Name[3] + " " +
                         lzr-Plat-Name[4] + " " +
                         lzr-Plat-Name[5] + " " +
                         lzr-Plat-Name[6].
      {wordwrap.i &s=lzr-Plat-Name    &n=5 &l=64}
      lzr-Plat-Name[5] = substring(lzr-plat-name[5], 1,64).
   END.
   ELSE
   DO:
      lzr-Plat-Name[5] = substring(lzr-plat-name[5], 1,39).
   END.

   IF LENGTH(TRIM(lzr-Pol-Name[6])) GT 0 THEN
   DO:
      vIsLongPolName = YES.
      lzr-Pol-Name[1]  = "~001~001~001" + lzr-Pol-Name[1] + " " +
                         lzr-Pol-Name[2] + " " +
                         lzr-Pol-Name[3] + " " +
                         lzr-Pol-Name[4] + " " +
                         lzr-Pol-Name[5] + " " +
                         lzr-Pol-Name[6].
      {wordwrap.i &s=lzr-Pol-Name    &n=5 &l=64}
      lzr-pol-name[5]  = substring(lzr-pol-name[5],  1,64).
   END.
   ELSE
   DO:
      lzr-pol-name[5]  = substring(lzr-pol-name[5],  1,39).
   END.

   ASSIGN
      lzr-Plat-Bank[3] = substring(lzr-Plat-Bank[3], 1,39)
      lzr-Pol-Bank[3]  = substring(lzr-Pol-Bank[3],  1,39)
   .

&ENDIF

lzr-Pol-Name[1] = REPLACE(lzr-Pol-Name[1], "~001", " ").
lzr-Plat-Name[1] = REPLACE(lzr-Plat-Name[1], "~001", " ").

&IF DEFINED(PRINT) &THEN
   RUN PUT_PCL_STR(190 * {&KOEF},(17 + {&OFFSET_VAL}) * {&KOEF},IF op.ins-date EQ ? OR PoMFO NE bank-mfo-9 THEN "" ELSE STRING(op.ins-date,"99.99.9999"),INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1055 * {&KOEF},( 20 +   {&OFFSET_VAL}) * {&KOEF}, mSpisPl,         INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(620 * {&KOEF},(17 + {&OFFSET_VAL}) * {&KOEF},IF can-find(first signs where signs.file-name eq 'op' and
	                              signs.surr eq string(op.op) and
	                              signs.code eq 'УслОпл' and
                                signs.xattr-val begins 'С акцеп') then STRING(op.Due-Date,"99.99.9999") else "",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(780 * {&KOEF},(200 + {&OFFSET_VAL}) * {&KOEF},op.doc-num,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1125 * {&KOEF},(195 + {&OFFSET_VAL}) * {&KOEF},TheDate,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1510 * {&KOEF},(195 + {&OFFSET_VAL}) * {&KOEF},PayType,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(375 * {&KOEF},(308 + {&OFFSET_VAL}) * {&KOEF},lzr-Cond-Pay[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(375 * {&KOEF},(358 + {&OFFSET_VAL}) * {&KOEF},lzr-Cond-Pay[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(375 * {&KOEF},(408 + {&OFFSET_VAL}) * {&KOEF},lzr-Cond-Pay[3],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(2145 * {&KOEF},(308 + {&OFFSET_VAL}) * {&KOEF},Num-Day,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(375 * {&KOEF},(488 + {&OFFSET_VAL}) * {&KOEF},lzr-Amt-Rub[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(375 * {&KOEF},(538 + {&OFFSET_VAL}) * {&KOEF},lzr-Amt-Rub[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(375 * {&KOEF},(588 + {&OFFSET_VAL}) * {&KOEF},lzr-Amt-Rub[3],INPUT-OUTPUT buf-str).

   IF vIsLongPlaName THEN
      RUN PRINT_COMPRESSED(                                   INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(662 + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Name[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(712 + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Name[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(762 + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Name[3],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(812 + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Name[4],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(862 + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Name[5],INPUT-OUTPUT buf-str).

   IF vIsLongPlaName THEN
      RUN PRINT_PITCH(                                        INPUT-OUTPUT buf-str).

   RUN PUT_PCL_STR(1505 * {&KOEF},(660 + {&OFFSET_VAL}) * {&KOEF},TRIM(Rub),INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(838 + {&OFFSET_VAL}) * {&KOEF},SUBSTRING(PlLAcct,1,25),INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(950  + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Bank[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1000 + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Bank[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1045 + {&OFFSET_VAL}) * {&KOEF},lzr-Plat-Bank[3],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(958 + {&OFFSET_VAL}) * {&KOEF},PlMFO,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(1015 + {&OFFSET_VAL}) * {&KOEF},SUBSTRING(PlCAcct,1,25),INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1130 + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Bank[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1175 + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Bank[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1220 + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Bank[3],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(1137 + {&OFFSET_VAL}) * {&KOEF},PoMFO,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(1195 + {&OFFSET_VAL}) * {&KOEF},SUBSTRING(PoCAcct,1,25),INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(1312 + {&OFFSET_VAL}) * {&KOEF},SUBSTRING(PoAcct,1,25),INPUT-OUTPUT buf-str).

   IF vIsLongPolName THEN
      RUN PRINT_COMPRESSED(                                   INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1312 + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Name[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1362 + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Name[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1412 + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Name[3],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1462 + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Name[4],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1512 + {&OFFSET_VAL}) * {&KOEF},lzr-Pol-Name[5],INPUT-OUTPUT buf-str).

   IF vIsLongPolName THEN
      RUN PRINT_PITCH(                                        INPUT-OUTPUT buf-str).

   RUN PUT_PCL_STR(1505 * {&KOEF},(1430 + {&OFFSET_VAL}) * {&KOEF},IF AVAIL doc-type THEN
                                             doc-type.digital
                                             ELSE
                                             op.doc-type,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(1490 + {&OFFSET_VAL}) * {&KOEF},"",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1505 * {&KOEF},(1550 + {&OFFSET_VAL}) * {&KOEF},"",INPUT-OUTPUT buf-str).

   IF INT64(op.order-pay) GT 0 THEN
      RUN PUT_PCL_STR(1975 * {&KOEF},(1460 + {&OFFSET_VAL}) * {&KOEF},IF SUBSTRING(op.order-pay,1,1) EQ "0" THEN SUBSTRING(op.order-pay,2,1)
                                                                                      ELSE op.order-pay,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1975 * {&KOEF},(1550 + {&OFFSET_VAL}) * {&KOEF},"",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1655 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[1],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1705 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[2],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1755 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[3],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1805 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[4],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1855 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[5],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1905 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[6],INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(1955 + {&OFFSET_VAL}) * {&KOEF},lzr-Details[7],INPUT-OUTPUT buf-str).

   RUN PUT_PCL_STR(1900 * {&KOEF},(2075 + {&OFFSET_VAL}) * {&KOEF},mDataMarkDBank,INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1900 * {&KOEF},(2483 + {&OFFSET_VAL}) * {&KOEF},mDataCartIn,   INPUT-OUTPUT buf-str).
   /*
   RUN PUT_PCL_STR(1345 * {&KOEF},(2020 + {&OFFSET_VAL}) * {&KOEF},"12.13.(37)",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(2605 + {&OFFSET_VAL}) * {&KOEF},"(64)",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(255 * {&KOEF},(2605 + {&OFFSET_VAL}) * {&KOEF},"12(65)",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(445 * {&KOEF},(2605 + {&OFFSET_VAL}) * {&KOEF},"12.13(66)",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(725 * {&KOEF},(2605 + {&OFFSET_VAL}) * {&KOEF},"1234567.(67)",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1080 * {&KOEF},(2605 + {&OFFSET_VAL}) * {&KOEF},"1234567.(68)",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(2655 + {&OFFSET_VAL}) * {&KOEF},"02",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(2705 + {&OFFSET_VAL}) * {&KOEF},"03",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(2755 + {&OFFSET_VAL}) * {&KOEF},"04",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(2805 + {&OFFSET_VAL}) * {&KOEF},"05",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(2855 + {&OFFSET_VAL}) * {&KOEF},"06",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(2905 + {&OFFSET_VAL}) * {&KOEF},"07",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(2955 + {&OFFSET_VAL}) * {&KOEF},"08",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(3005 + {&OFFSET_VAL}) * {&KOEF},"09",INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(130 * {&KOEF},(3055 + {&OFFSET_VAL}) * {&KOEF},"10",INPUT-OUTPUT buf-str).
   */

   RUN PRINT_ELITE(                                             INPUT-OUTPUT buf-str).
   RUN PUT_PCL_STR(1730 * {&KOEF}, ( 2860 + {&OFFSET_VAL} ) * {&KOEF}, STRING(op.op-date, "99.99.9999"), INPUT-OUTPUT buf-str).
   cUserID = OP.user-id.
   FIND FIRST _user WHERE _user._userid EQ cUserID NO-LOCK NO-ERROR. 
      cUserNAME = _user._user-name. 
          RUN PUT_PCL_STR(1530 * {&KOEF}, ( 2930 + {&OFFSET_VAL} ) * {&KOEF}, cUserNAME,     INPUT-OUTPUT buf-str). 


   RUN PRINT_PITCH(                                           INPUT-OUTPUT buf-str).


&ENDIF
