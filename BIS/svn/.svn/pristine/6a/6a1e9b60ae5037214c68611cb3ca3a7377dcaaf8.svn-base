/*ac-uni.p*/

&IF "{&OFFSET}" EQ "NO" &THEN
      &SCOP OFFSET_VAL 0
&ELSE
      &SCOP OFFSET_VAL 1000
&ENDIF

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
                                    EXTENT      7 NO-UNDO.



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
      mKindOfDoc[1]    = mKindOfDoc[1] + " " + 
                         mKindOfDoc[2]
      mExtraCond[1]    = mExtraCond[1] + " " +
                         mExtraCond[2]
      mAcctOfRec[1]    = mAcctOfRec[1] + " " +
                         mAcctOfRec[2]
   .

   {wordwrap.i &s=lzr-Amt-Rub     &n=3 &l=63}
   {wordwrap.i &s=lzr-Plat-Name   &n=5 &l=39}
   {wordwrap.i &s=lzr-Plat-Bank   &n=3 &l=39}
   {wordwrap.i &s=lzr-Pol-Name    &n=5 &l=39}
   {wordwrap.i &s=lzr-Pol-Bank    &n=3 &l=39}
   {wordwrap.i &s=lzr-Details     &n=4 &l=71}
   {wordwrap.i &s=mKindOfDoc      &n=2 &l=80}
   {wordwrap.i &s=mExtraCond      &n=3 &l=90}
   {wordwrap.i &s=mAcctOfRec      &n=2 &l=100}

   mKindOfDoc2[1] =  mKindOfDoc[2].
   {wordwrap.i &s=mKindOfDoc2     &n=3 &l=120}
   ASSIGN
      lzr-Plat-Name[5] = substring(lzr-plat-name[5], 1,39)
      lzr-Plat-Bank[3] = substring(lzr-Plat-Bank[3], 1,39)
      lzr-pol-name[5]  = substring(lzr-pol-name[5],  1,39)
      lzr-Pol-Bank[3]  = substring(lzr-Pol-Bank[3],  1,39)
   .

   IF lzr-Pol-Name[1] BEGINS "ИНН" THEN
      SUBSTRING(lzr-Pol-Name[1],1,3) = "   ".
   ELSE
      lzr-Pol-Name[1] = "   " + lzr-Pol-Name[1].

   IF lzr-Plat-Name[1] BEGINS "ИНН" THEN
      SUBSTRING(lzr-Plat-Name[1],1,3)  = "   ".
   ELSE
      lzr-Plat-Name[1]  = lzr-Plat-Name[1] + "   ".


&ENDIF
&IF DEFINED(PRINT) &THEN
    RUN PUT_PCL_STR(500,83    + {&OFFSET_VAL},op.doc-num,INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(1141,78   + {&OFFSET_VAL},theDate,INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(375,188   + {&OFFSET_VAL},lzr-Amt-Rub[1],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(375,238   + {&OFFSET_VAL},lzr-Amt-Rub[2],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(375,288   + {&OFFSET_VAL},lzr-Amt-Rub[3],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(1600,78   + {&OFFSET_VAL},PayType,INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(1505,367  + {&OFFSET_VAL},TRIM(Rub),INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,365   + {&OFFSET_VAL},lzr-Plat-Name[1],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,415   + {&OFFSET_VAL},lzr-Plat-Name[2],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,465   + {&OFFSET_VAL},lzr-Plat-Name[3],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,515   + {&OFFSET_VAL},lzr-Plat-Name[4],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,565   + {&OFFSET_VAL},lzr-Plat-Name[5],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(1505,545  + {&OFFSET_VAL},SUBSTRING(PlLAcct,1,25),INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,655   + {&OFFSET_VAL},lzr-Plat-Bank[1],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,700   + {&OFFSET_VAL},lzr-Plat-Bank[2],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,745   + {&OFFSET_VAL},lzr-Plat-Bank[3],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(1505,663  + {&OFFSET_VAL},PlMFO,INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(1505,722  + {&OFFSET_VAL},SUBSTRING(PlCAcct,1,25),INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,832   + {&OFFSET_VAL},lzr-Pol-Bank[1],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,877   + {&OFFSET_VAL},lzr-Pol-Bank[2],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,922   + {&OFFSET_VAL},lzr-Pol-Bank[3],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(1505,840  + {&OFFSET_VAL},PoMFO,INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(1505,898  + {&OFFSET_VAL},SUBSTRING(PoCAcct,1,25),INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(1505,1017 + {&OFFSET_VAL},SUBSTRING(PoAcct,1,25),INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,1017  + {&OFFSET_VAL},lzr-Pol-Name[1],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,1067  + {&OFFSET_VAL},lzr-Pol-Name[2],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,1117  + {&OFFSET_VAL},lzr-Pol-Name[3],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,1167  + {&OFFSET_VAL},lzr-Pol-Name[4],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,1217  + {&OFFSET_VAL},lzr-Pol-Name[5],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(1505,1135 + {&OFFSET_VAL},doc-type.digital,INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(1975,1135 + {&OFFSET_VAL},Due-Accredit,INPUT-OUTPUT buf-str).
/*  RUN PUT_PCL_STR(1975,1253 + {&OFFSET_VAL},"06(23)",INPUT-OUTPUT buf-str).*/
    RUN PUT_PCL_STR(435,1310  + {&OFFSET_VAL},accredit,INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(435,1360  + {&OFFSET_VAL},"",INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(435,1428  + {&OFFSET_VAL},Cond-Pay,INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(435,1478  + {&OFFSET_VAL},"",INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(135,1615  + {&OFFSET_VAL},lzr-Details[1],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,1665  + {&OFFSET_VAL},lzr-Details[2],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,1715  + {&OFFSET_VAL},lzr-Details[3],INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(130,1765  + {&OFFSET_VAL},lzr-Details[4],INPUT-OUTPUT buf-str).

    RUN PRINT_COMPRESSED(                                    INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(882,1795  + {&OFFSET_VAL},mKindOfDoc[1], INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(135,1825  + {&OFFSET_VAL},mKindOfDoc2[1], INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(135,1855  + {&OFFSET_VAL},mKindOfDoc2[2], INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(135,1885  + {&OFFSET_VAL},mKindOfDoc2[3], INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(600,1925  + {&OFFSET_VAL}, mExtraCond[1], INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(135,1955  + {&OFFSET_VAL}, mExtraCond[2], INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(135,1985  + {&OFFSET_VAL}, mExtraCond[3], INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(450,2020  + {&OFFSET_VAL}, mAcctOfRec[1], INPUT-OUTPUT buf-str).
    RUN PUT_PCL_STR(135,2070  + {&OFFSET_VAL}, mAcctOfRec[2], INPUT-OUTPUT buf-str).
    RUN PRINT_PITCH(                                          INPUT-OUTPUT buf-str).

   IF mPNumb NE 0 THEN
      RUN PUT_PCL_STR(135,2550  + {&OFFSET_VAL}, "Продолжение в приложении на 1 листе", INPUT-OUTPUT buf-str).

&ENDIF
