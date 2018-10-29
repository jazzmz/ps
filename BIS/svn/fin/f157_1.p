/*
                Банковская интегрированная система БИСквит
    Copyright:  (C) 1992-2001 ТОО "Банковские информационные системы"
     Filename:  f157_1.p
      Comment:  Отчет по 157 форме.
         Uses:
      Used by:
      Created:   16/04/04 YUSS
     Modified:  16.09.2008 Борисов А.В. - Закомментировал стр.142-144 чтобы во 2 стб. отображались имена клиентов
*/
{globals.i}
{intrface.get strng}
{wordwrap.def}

&IF DEFINED (ExpPSD) = 0 &THEN

   {norm.i}

   def output param xResult as dec         no-undo.
   def input  param beg     as date        no-undo.
   def input  param dob     as date        no-undo.
   def input  param str     as character   no-undo.


   DEFINE VARIABLE out-data-id LIKE DataBlock.Data-Id       NO-UNDO.

   RUN sv-get.p ("f157",sh-branch-id,beg, dob, OUTPUT out-data-id).
   IF out-data-id EQ ? THEN RETURN.

   FIND FIRST DataBlock WHERE DataBlock.Data-Id EQ out-data-id NO-LOCK.
   IF NOT AVAIL DataBlock THEN RETURN.

&ENDIF

DEFINE VARIABLE name            AS CHARACTER FORMAT "x(45)" EXTENT 3 NO-UNDO.
DEFINE VARIABLE i               AS INTEGER   NO-UNDO.
DEFINE VARIABLE vNnInt          AS INTEGER   NO-UNDO.
DEFINE VARIABLE num-cat         AS INTEGER   NO-UNDO.
DEFINE VARIABLE num-cust        AS CHARACTER NO-UNDO.
DEFINE VARIABLE vNnChar         AS CHARACTER NO-UNDO.
DEFINE VARIABLE vTmpInt         AS INTEGER   NO-UNDO.
DEFINE VARIABLE vOsokoChar      AS CHARACTER NO-UNDO INIT "f157_ОСОКО".

DEFINE VARIABLE vOtherSym1Char  AS CHARACTER NO-UNDO.
DEFINE VARIABLE vOtherValDec    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE vOtherCntInt    AS INTEGER   NO-UNDO.
DEFINE VARIABLE vOtherSumDec    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE vOtherSumMinDec AS DECIMAL   NO-UNDO.
DEFINE VARIABLE vOtherSumMaxDec AS DECIMAL   NO-UNDO.
DEFINE VARIABLE vSym1OldChar    AS CHARACTER NO-UNDO.
DEFINE VARIABLE vOtherGr4Dec    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE vOtherGr5Dec    AS DECIMAL   NO-UNDO.

DEFINE TEMP-TABLE ttRep NO-UNDO
   FIELD Unkg     AS CHARACTER
   FIELD GrafChar AS CHARACTER EXTENT 3
   FIELD GrafDec  AS DECIMAL   EXTENT 3
   FIELD SpravLog AS LOGICAL
   FIELD SpravDec AS DECIMAL
.

/* Формат преобразуем из целого в десятичный */
FUNCTION fDecFormat RETURNS CHAR
   (INPUT iStr AS CHAR,
    INPUT iDec AS INT):

   DEFINE VARIABLE vRetVal AS CHARACTER  NO-UNDO.

   vRetVal = SUBSTR (iStr,1,1) /* Может быть минус */
           + FILL (">",LENGTH (iStr) - iDec - 3 ) /* Тельце формата */
           + "9." /* Последний ноль */
           + FILL ("9",iDec) /* И десятичные знаки */
           .
   RETURN vRetVal.
END FUNCTION.

DEFINE QUERY  qLine FOR DataLine.

{f157#af.p &report=yes}

FIND FIRST DataLine OF DataBlock
   WHERE DataLine.Sym1 = vOsokoChar
   NO-LOCK NO-ERROR.

IF AVAIL DataLine THEN vSumObDec = ROUND(DataLine.Val[3] / 1000,0). /* ОСОКО */

IF NUM-ENTRIES(str) > 1 THEN
   vOtherValDec = DECIMAL(ENTRY(2,str)).
ELSE
   vOtherValDec = 0.

{gvk1unkg.pro &forma="форма157" }

OPEN QUERY qLine FOR
   EACH DataLine OF DataBlock WHERE
        NOT (DataLine.Sym1 BEGINS "f157")
    AND INT (ENTRY (1,DataLine.Sym1,".")) LE 10
   NO-LOCK
   BY DataLine.Sym1.

{empty ttRep}

{for_qry.i qLine}

   name = "".
   /* физ. лица с доп.рек "Предпр" = "Пред_юр" ,должны обрабатываться как юр.лица */
   /* (так по гражданскому законодательству)- это касается граф 2,3 - наименование ( поле txt1) */

	RUN ChkTTGvk (INPUT  DataLine.Sym1,
					  INPUT  DataLine.Sym2,
					  INPUT  DataLine.Sym3,
					  INPUT  ".",
					  OUTPUT mSym1,
					  OUTPUT mSym2
					  ).

	IF mSym1 = ? THEN NEXT.

   IF ENTRY(1, mSym1,".") <> vSym1OldChar THEN
      RUN pOther.

   IF ENTRY (1, mSym1, ".") <> vSym1OldChar OR           /* смена номера */
     (ENTRY (1, mSym1, ".") = vSym1OldChar AND           /* тот же номер, но с большой суммой */
      ROUND(Dataline.Val[3] / 1000,0) >= vOtherValDec ) THEN
   DO:
      ASSIGN
         vOtherCntInt    = 0
         vOtherSumDec    = 0
         vOtherSumMinDec = 0
         vOtherSumMaxDec = 0
         vOtherSym1Char  = ""
         vSym1OldChar    = ENTRY (1, mSym1, ".")
      .
      IF GetEntries(4,dataline.txt,"~n","") EQ "Вкладчик" THEN
         ASSIGN
            vNnInt = vNnInt + 1
            name[1] = "вкладчик N " + STRING(vNnInt)
         .
         ELSE
            name[1] = ENTRY (1,dataline.txt,"~n").

/*		IF mSym2 <> DataLine.Sym3 THEN /* "ГВК" */
         name[1] = mSym1.
*/
      CREATE ttRep.
      ASSIGN
         ttRep.Unkg         = DataLine.Sym3
         ttRep.GrafChar [1] = mSym1
         ttRep.GrafChar [2] = name[1]
         ttRep.GrafChar [3] = ENTRY(2,Dataline.txt,"~n")
         ttRep.GrafDec  [1] = ROUND(Dataline.Val[3] / 1000,0)
         ttRep.GrafDec  [2] = Dataline.Val[4]
         ttRep.GrafDec  [3] = Dataline.Val[5]
      .

      &IF DEFINED (ExpPSD) = 0 &THEN
         {wordwrap.i &s=name &l=45 &n=3}

         PUT STREAM fil UNFORMATTED
            "│" + STRING(ttRep.GrafChar [1],"x(12)")
          + "│" + STRING(name[1],"x(45)")
          + "│" + STRING(ttRep.GrafChar [3],"x(15)")
          + "│" + STRING(ttRep.GrafDec  [1], OutputFormat)
          + "│" + STRING(ttRep.GrafDec  [2], fDecFormat (OutputFormat,2))
          + "│" + STRING(ttRep.GrafDec  [3], fDecFormat (OutputFormat,2))
         &IF DEFINED (s01_08_2005) &THEN
          + "│" + STRING(0)
          + "│" + STRING(0)
          + "│" + STRING(0)
         &ENDIF
          + "│" SKIP.

         DO i = 2 TO 3 :
            IF name[i] > "" THEN
               PUT STREAM fil UNFORMATTED
                 "│" + STRING("","x(12)")
               + "│" + STRING(name[i],"x(45)")
               + "│" + STRING("","x(15)")
               + "│" + FILL(" ", LENGTH(OutputFormat))
               + "│" + FILL(" ", LENGTH(OutputFormat))
               + "│" + FILL(" ", LENGTH(OutputFormat))
               + "│" SKIP.
            ELSE
               LEAVE.
         END.
      &ENDIF
   END.
   ELSE           /* тот же номер, но с маленькой суммой */
      ASSIGN
         vOtherSym1Char = IF vOtherSym1Char = "" THEN mSym1 ELSE vOtherSym1Char
         vOtherCntInt   = vOtherCntInt + 1
         vOtherSumMinDec = IF vOtherCntInt = 1
                           THEN ROUND(Dataline.Val[3] / 1000,0)
                           ELSE MINIMUM(vOtherSumMinDec,ROUND(Dataline.Val[3] / 1000,0))
         vOtherSumMaxDec = MAXIMUM(vOtherSumMaxDec,ROUND(Dataline.Val[3] / 1000,0))
         vOtherSumDec   = vOtherSumDec + ROUND(Dataline.Val[3] / 1000,0)
      .
END.

RUN pOther.

&IF DEFINED (ExpPSD) = 0 &THEN

   IF ENTRY(1,str) = "Отчет" THEN
      PUT STREAM fil UNFORMATTED
   "├────────────┴─────────────────────────────────────────────┴───────────────┴───────────────────┼───────────────────┼───────────────────┤" skip.

   PUT STREAM fil UNFORMATTED
   "│Справочно: Общая сумма обязательств кредитной организации                                     │"
   STRING(vSumObDec, OutputFormat)
   "│         х         │" skip
   "└──────────────────────────────────────────────────────────────────────────────────────────────┴───────────────────┴───────────────────┘" skip.

   printres = NO.

   {intrface.del}

&ELSE

      CREATE ttRep.
      ASSIGN
         ttRep.SpravLog = TRUE
         ttRep.SpravDec = vSumObDec
      .

&ENDIF

PROCEDURE pOther:
   DEF VAR vFmt AS CHAR NO-UNDO.

   IF ENTRY(1,str) = "Отчет"
   THEN vFmt = fDecFormat (OutputFormat,2).
   ELSE vFmt = OutputFormat.

   IF vOtherCntInt <> 0 THEN
   DO:
      ASSIGN
         name[1] = "Прочие"
         vOtherGr4Dec = IF vSumObDec <> 0
                        THEN 100  * vOtherSumDec / vSumObDec
                        ELSE 0
         vOtherGr5Dec = IF capital > 0
                        THEN 100  * vOtherSumDec / capital
                        ELSE 0
      .

      CREATE ttRep.
      ASSIGN
         ttRep.GrafChar [1] = vOtherSym1Char
         ttRep.GrafChar [2] = name[1]
         ttRep.GrafChar [3] = ""
         ttRep.GrafDec  [1] = vOtherSumDec
         ttRep.GrafDec  [2] = vOtherGr4Dec
         ttRep.GrafDec  [3] = vOtherGr5Dec
      .

      &IF DEFINED (ExpPSD) = 0 &THEN
         PUT STREAM fil UNFORMATTED
            "│" + STRING(ttRep.GrafChar [1],"x(12)")
          + "│" + STRING(name[1],"x(45)")
          + "│" + STRING(ttRep.GrafChar [3],"x(15)")
          + "│" + STRING(ttRep.GrafDec  [1], OutputFormat)
          + "│" + STRING(ttRep.GrafDec  [2], fDecFormat (OutputFormat,2))
          + "│" + STRING(ttRep.GrafDec  [3], fDecFormat (OutputFormat,2))
         &IF DEFINED (s01_08_2005) &THEN
          + "│" + STRING(vOtherSumMinDec, vFmt)
          + "│" + STRING(vOtherSumMaxDec, vFmt)
          + "│" + STRING(vOtherCntInt)
         &ENDIF
          + "│" SKIP.
      &ENDIF
   END.
END PROCEDURE.

