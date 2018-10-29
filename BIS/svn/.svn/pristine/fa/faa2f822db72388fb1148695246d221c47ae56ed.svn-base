/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2008 ЗАО "Банковские информационные системы"
     Filename: f711_3p.p
      Comment: Для печати данных Подраздела 1.3 формы 711
   Parameters:
         Uses:
      Used by:
      Created: 24.11.2008 17:34 TSL     
     Modified: 24.11.2008 17:34 TSL     
     Modified: 06.02.09 ler 105714 - ф.711. Экспорт в Клико 2055-У 01.01.2009 
                                     Для <SECL_KLN> и <SECL_KON> 
                                     поля B26A,B29A и B44A,B47A вставл в шаблон и F711_3P.P
     Modified: 09.06.09 ler 105724 - Экспорт в ПТК ПСД 2055-У 01.02.2009
*/
/******************************************************************************/
DEFINE OUTPUT PARAMETER oResult  AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER iBegDate AS DATE       NO-UNDO.
DEFINE INPUT  PARAMETER iEndDate AS DATE       NO-UNDO.
DEFINE INPUT  PARAMETER iStrPar  AS CHARACTER  NO-UNDO.

{globals.i}             /* Глобальные переменные сессии. */
{intrface.get strng}    /* Библиотека для работы со строками. */
{norm.i}
{wordwrap.def}

&GLOBAL-DEFINE STREAM STREAM fil
&GLOBAL-DEFINE IfExp  (GetSysConf("ModeExport") EQ "ExpКЛИКО" OR GetSysConf("ModeExport") EQ "ExpPTK")

DEFINE VARIABLE mClassId  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mSym1     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mDataID   AS INT64     NO-UNDO.
DEFINE VARIABLE vI        AS INT64     NO-UNDO.
DEFINE VARIABLE mCustName AS CHARACTER   NO-UNDO EXTENT 2.
DEFINE VARIABLE mOrgName  AS CHARACTER NO-UNDO EXTENT 2.
DEFINE VARIABLE vNoZero   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE vuser-proc-id AS INT64     NO-UNDO.
DEFINE VARIABLE vii        AS INT64     NO-UNDO.
DEFINE VARIABLE vDec      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE vExtNoZero AS LOGICAL     NO-UNDO INIT FALSE.
DEFINE VARIABLE vExtNoZero2 AS LOGICAL     NO-UNDO INIT FALSE.
DEFINE VARIABLE mTxt        AS CHARACTER NO-UNDO EXTENT 12.

DEFINE TEMP-TABLE ttDataLine LIKE DataLine 
   FIELD TxtExt AS CHARACTER EXTENT 12
.
DEFINE VARIABLE mK AS INT64 EXTENT 6 NO-UNDO
   INIT [1,7,9,10,11,12].
DEFINE VARIABLE vJ       AS INT64     NO-UNDO.
DEFINE VARIABLE mTxt5Dec AS DECIMAL     NO-UNDO.

printres = NO.
vuser-proc-id =  INT64(GetSysConf ("user-proc-id")).
FIND FIRST user-proc WHERE  RECID(user-proc) EQ vuser-proc-id  NO-LOCK NO-ERROR.
ASSIGN
   mClassId = ENTRY(1,iStrPar)
   mSym1    = ENTRY(2,iStrPar) 
   vNoZero = AVAIL user-proc AND CAN-DO(REPLACE(user-proc.Params,";",","), mSym1) 
   vii = NUM-ENTRIES(user-proc.Params,";")
   vExtNoZero = AVAIL user-proc AND vii GT 1 AND CAN-DO(ENTRY(vii,user-proc.Params,";"),"txt5") 
   vExtNoZero2 = AVAIL user-proc AND vii GT 1 AND CAN-DO(ENTRY(vii,user-proc.Params,";"),"notxt5")
    NO-ERROR.
IF ERROR-STATUS:ERROR THEN
DO:
   PUT {&STREAM} UNFORMATTED
      "Неверные параметры процедуры " + PROGRAM-NAME(1) + "!" SKIP.
   RETURN "".
END.

RUN sv-get.p (       mClassId,
                     sh-Branch-ID,
                     iBegDate,
                     iEndDate,
              OUTPUT mDataID).
IF mDataID NE ? THEN
DO:
   FOR EACH DataLine WHERE DataLine.Data-Id EQ mDataID
                       AND DataLine.Sym1    EQ mSym1
      NO-LOCK:
      IF vNoZero THEN
      DO:
          IF NOT vExtNoZero2 THEN vDec = ABS(DEC(GetEntries(5,DataLine.Txt,"~n",""))).
          ELSE vDec = 0.
          IF NOT vExtNoZero THEN
          DO vii = 1 TO 12:

             vDec = vDec + ABS(DataLine.Val[vii]).
          END.
          IF vDec EQ 0 THEN NEXT.
      END.

      /* закладные физических лиц выводятся суммой , собираем информацию и не выводим */
      IF mSym1 EQ "1.3.2" AND
         GetEntries(1,DataLine.Txt,"~n","") EQ "Физические лица" AND 
         GetEntries(6,DataLine.Txt,"~n","") EQ "ENC" THEN 
      DO:
         DO vJ = 1 TO 6:
            IF DataLine.Val[mK[vJ]] GT 0 THEN
            DO:
               FIND FIRST ttDataLine WHERE ttDataLine.Val[mK[vJ]] GT 0
                                       AND ENTRY(4,ttDataLine.Txt,"~n") EQ ENTRY(4,DataLine.Txt,"~n")
                                       AND ENTRY(1,ttDataLine.Txt,"~n") EQ "Физические лица"
                                       AND ENTRY(6,ttDataLine.Txt,"~n") EQ "ENC"
                  NO-ERROR.
               IF NOT AVAILABLE ttDataLine THEN
               DO:
                  CREATE ttDataLine.
                  BUFFER-COPY DataLine TO ttDataLine. 
               END.
               ELSE
               DO:
                  ASSIGN 
                     ttDataLine.Val[mK[vJ]] = ttDataLine.Val[mK[vJ]] + DataLine.Val[mK[vJ]]
                     mTxt5Dec = DEC(GetEntries(5,ttDataLine.Txt,"~n","")).
                  ENTRY(5,ttDataLine.Txt,"~n") = STRING(mTxt5Dec + DEC(GetEntries(5,DataLine.Txt,"~n",""))).
               END.
                  
               LEAVE.
            END.
         END.
      END.
      ELSE
      DO:
         &IF DEFINED(Instr2332-U) > 0 &THEN
         IF mSym1 = "1.3.2" THEN DO:
            DO vJ = 1 TO EXTENT(mTxt):
               mTxt[vJ] = GetEntries(vJ, DataLine.Txt, "~n", "").
            END.
            FIND FIRST ttDataLine WHERE
                       ttDataLine.TxtExt[1] = mTxt[1] /* Наименование эмитента */
                   AND ttDataLine.TxtExt[2] = mTxt[2] /* ИНН эмитента */
                   AND ttDataLine.TxtExt[6] = mTxt[6] /* Код типа ЦБ */
                   AND ttDataLine.TxtExt[3] = mTxt[3] /* Идентификационный номер ЦБ */
                   AND ttDataLine.TxtExt[5] = mTxt[5] /* Номинал*/
                   AND ttDataLine.TxtExt[9] = mTxt[9] /* Место учета */
            NO-ERROR.
            IF NOT AVAIL ttDataLine THEN DO:
               CREATE ttDataLine.
               BUFFER-COPY DataLine TO ttDataLine
                  ASSIGN
                     ttDataLine.TxtExt[1] = mTxt[1]
                     ttDataLine.TxtExt[2] = mTxt[2]
                     ttDataLine.TxtExt[6] = mTxt[6]
                     ttDataLine.TxtExt[3] = mTxt[3]
                     ttDataLine.TxtExt[5] = mTxt[5]
                     ttDataLine.TxtExt[9] = mTxt[9]
                     .
            END.
            ELSE DO:
               ASSIGN
                  ttDataLine.Val[1]  = ttDataLine.Val[1]  + DataLine.Val[1]
                  ttDataLine.Val[7]  = ttDataLine.Val[7]  + DataLine.Val[7]
                  ttDataLine.Val[9]  = ttDataLine.Val[9]  + DataLine.Val[9]
                  ttDataLine.Val[10] = ttDataLine.Val[10] + DataLine.Val[10]
                  ttDataLine.Val[11] = ttDataLine.Val[11] + DataLine.Val[11]
                  ttDataLine.Val[12] = ttDataLine.Val[12] + DataLine.Val[12]
                  .
            END.
         END.
         ELSE DO:
            vI = vI + 1.
            RUN PrintString (vI, (BUFFER DataLine:HANDLE)). /* вывод строки */
         END.
         &ELSE
         vI = vI + 1.
         RUN PrintString (vI, (BUFFER DataLine:HANDLE)). /* вывод строки */
         &ENDIF
      END.
   END.

   /* закладные физических лиц */
   IF mSym1 EQ "1.3.2" THEN
   FOR EACH ttDataLine:
      vI = vI + 1.
      IF GetEntries(1, ttDataLine.Txt, "~n", "") = "Физические лица" AND GetEntries(6, ttDataLine.Txt, "~n", "") = "ENC" THEN 
         ASSIGN
            ENTRY(2,ttDataLine.Txt,"~n") = ""
            ENTRY(3,ttDataLine.Txt,"~n") = ""
            .
      RUN PrintString (vI, (BUFFER ttDataLine:HANDLE)).  /* вывод строки */
   END.

END.

{intrface.del}          /* Выгрузка инструментария. */ 
RETURN "".
/******************************************************************************/
PROCEDURE PrintString. 
   DEFINE INPUT  PARAMETER iCount AS INT64     NO-UNDO.
   DEFINE INPUT  PARAMETER iBuf   AS HANDLE      NO-UNDO.

   IF GetSysConf("ModeExport") EQ "ExpPTK" THEN
   DO:
      IF mSym1 EQ "1.3.1" AND
         DEC(iBuf::Val(1)) EQ 0 AND
         DEC(iBuf::Val(2)) EQ 0 AND
         DEC(iBuf::Val(3)) EQ 0 AND
         DEC(iBuf::Val(4)) EQ 0 AND
         DEC(iBuf::Val(5)) EQ 0 AND
         DEC(iBuf::Val(6)) EQ 0 AND
         DEC(iBuf::Val(7)) EQ 0 AND
         DEC(iBuf::Val(8)) EQ 0 AND
         DEC(iBuf::Val(9)) EQ 0 AND
         DEC(iBuf::Val(10)) EQ 0 AND
         DEC(iBuf::Val(11)) EQ 0 AND
         DEC(iBuf::Val(12)) EQ 0 
         THEN RETURN.
      IF mSym1 EQ "1.3.2" AND
         DEC(iBuf::Val(1)) EQ 0 AND
         DEC(iBuf::Val(7)) EQ 0 AND
         DEC(iBuf::Val(9)) EQ 0 AND
         DEC(iBuf::Val(10)) EQ 0 AND
         DEC(iBuf::Val(11)) EQ 0 AND
         DEC(iBuf::Val(12)) EQ 0 
         THEN RETURN.
   END.
      
   mCustName[1] = GetEntries(1,iBuf::Txt,"~n","").

   IF NOT {&IfExp} THEN
   DO:       
      {wordwrap.i &s=mCustName &l=30 &n=2 }
   END.
   
   &IF DEFINED(Instr2627-U) GT 0 &THEN
   mOrgName[1] = GetEntries(9, iBuf::Txt, "~n", "").
   IF NOT {&IfExp} THEN
   DO:       
      {wordwrap.i &s=mOrgName &l=30 &n=2 }
   END.
   &ENDIF
   
   PUT {&STREAM} UNFORMATTED delimver
      STRING(iCount, &IF DEFINED(Instr2332-U) &THEN ">>>>>9" &ELSE ">>>>9" &ENDIF)                        delimver  /* 30 */
      IF {&IfExp} 
      THEN mCustName[1]
      ELSE STRING(mCustName[1], "x(30)")
                                                     delimver  /* 31 */
IF GetSysConf("ModeExport") EQ "ExpКЛИКО" THEN "1-КЛИКО" + delimver ELSE ""
      GetEntries(2,iBuf::Txt,"~n","") FORMAT "x(15)" delimver  /* 32 */
      GetEntries(IF GetSysConf("ModeExport") EQ "ExpPTK" THEN 8 ELSE 6,iBuf::Txt,"~n","") FORMAT "x(6)"  delimver  /* 33 */
      GetEntries(3,iBuf::Txt,"~n","") FORMAT "x(20)" delimver  /* 34 */
IF GetSysConf("ModeExport") EQ "ExpКЛИКО" THEN (GetEntries(7,iBuf::Txt,"~n","") + delimver ) ELSE ""
      "  " GetEntries(4,iBuf::Txt,"~n","") FORMAT "x(3)" " " delimver
&IF DEFINED(Instr2332-U) GT 0 &THEN
      STRING(DEC(GetEntries(5,iBuf::Txt,"~n","")), ">>>>>>>>>>>>>>>>>>>>>>>9.99")
&ELSE
IF GetSysConf("ModeExport") EQ "ExpКЛИКО" 
THEN STRING(DEC(GetEntries(5,iBuf::Txt,"~n","")), ">>>>>>>>>>>>>>>>>>>>>>>9.99")
ELSE STRING(DEC(GetEntries(5,iBuf::Txt,"~n","")), ">>>>>>>>>9.9999")
&ENDIF
                                                     delimver
   .
   IF mSym1 EQ "1.3.1" THEN
      PUT {&STREAM} UNFORMATTED
         DEC(iBuf::Val(1))  FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(2))  FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(3))  FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(4))  FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(5))  FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(6))  FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(7))  FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(8))  FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(9))  FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(10)) FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(11)) FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(12)) FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         SKIP.
   ELSE
      PUT {&STREAM} UNFORMATTED
         DEC(iBuf::Val(1))  FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(7))  FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(9))  FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(10)) FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(11)) FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         DEC(iBuf::Val(12)) FORMAT ">>>>>>>>>>>>>>9.9999" delimver 
         &IF DEFINED(Instr2627-U) GT 0 &THEN
         mOrgName[1]                         FORMAT "x(30)" delimver
         GetEntries(10, iBuf::Txt, "~n", "") FORMAT "x(17)" delimver
         GetEntries(11, iBuf::Txt, "~n", "") FORMAT "x(30)" delimver
         GetEntries(12, iBuf::Txt, "~n", "") FORMAT "x(16)" delimver
         &ENDIF
         SKIP.

   DO WHILE mCustName[2] GT ""
      &IF DEFINED(Instr2627-U) GT 0 &THEN
      OR mOrgName[2] > ""
      &ENDIF
      :
      mCustName[1] = mCustName[2].
      {wordwrap.i &s=mCustName &l=30 &n=2 }

      &IF DEFINED(Instr2627-U) GT 0 &THEN
      mOrgName[1] = mOrgName[2].
      {wordwrap.i &s=mOrgName &l=30 &n=2 }
      &ENDIF

      PUT {&STREAM} UNFORMATTED delimver
         FILL(" ",&IF DEFINED(Instr2332-U) &THEN 6 &ELSE 5 &ENDIF) delimver
         mCustName[1] FORMAT "x(30)" delimver
         FILL(" ",15) delimver
         FILL(" ",6) delimver
         FILL(" ",20) delimver
         FILL(" ",6) delimver 
         FILL(" ",&IF DEFINED(Instr2332-U) &THEN 27 &ELSE 15 &ENDIF) delimver 
         .
      IF mSym1 EQ "1.3.1" THEN
         PUT {&STREAM} UNFORMATTED
            FILL(" ",20) delimver 
            FILL(" ",20) delimver
            FILL(" ",20) delimver
            FILL(" ",20) delimver
            FILL(" ",20) delimver
            FILL(" ",20) delimver
            FILL(" ",20) delimver
            FILL(" ",20) delimver
            FILL(" ",20) delimver
            FILL(" ",20) delimver
            FILL(" ",20) delimver
            FILL(" ",20) delimver
            SKIP.
      ELSE
         PUT {&STREAM} UNFORMATTED
            FILL(" ",20) delimver 
            FILL(" ",20) delimver
            FILL(" ",20) delimver
            FILL(" ",20) delimver
            FILL(" ",20) delimver
            FILL(" ",20) delimver
            &IF DEFINED(Instr2627-U) &THEN
            mOrgName[1]   FORMAT "x(30)" delimver
            FILL(" ", 17) delimver
            FILL(" ", 30) delimver
            FILL(" ", 16) delimver
            &ENDIF
            SKIP.

   END.

END PROCEDURE. /* PrintString  */
