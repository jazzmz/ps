/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ТОО "Банковские информационные системы"
     Filename: p14-9bas.p
      Comment: Переходник для запуска отчета Приложение 9. из базового модуля
   Parameters:
         Uses:
      Used by:
      Created: 19/05/2003 YUSS
     Modified: 15/10/2006 SALN 0064703
     Modified: 22/12/2008 kraw (0103426) определение длины страницы до начала печати
     Modified: 26.03.12 ler 0163333 - Форма 1100. Раздел 5.Б. Экспорт для ФСФР
*/
/******************************************************************************/
DEFINE INPUT  PARAMETER iParRep AS CHARACTER  NO-UNDO.
/* Глобальные определения */
{ globals.i }
{ norm.i NEW }
{ intrface.get xclass }
{ intrface.get acct }
{ intrface.get date }

&glob beg-date in-beg-date
/* Локальные переменные */
{ wordwrap.def }
{ r-prl9.def NEW }
{ p14-9.def &workplan=yes }
{ r-tp.def &p14-9=yes}
{signature.pro}

DEFINE VARIABLE mClass       AS INT64     NO-UNDO.
DEFINE VARIABLE mDataID      AS INT64     NO-UNDO.
DEFINE VARIABLE mResult      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE mNoZero      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE vWidthChar   AS CHARACTER NO-UNDO.

DEFINE VARIABLE mSeqRepChar  AS CHARACTER NO-UNDO INIT "bpos,opos,fpos,dpos,tpos".
DEFINE VARIABLE mSeqInt      AS INT64     NO-UNDO.
DEFINE VARIABLE mSeqCntInt   AS INT64     NO-UNDO.
DEFINE VARIABLE mHeaderLog   AS LOGICAL   NO-UNDO. /* есть печать данных хотя бы одного класса */
DEFINE VARIABLE mGrClassLog  AS LOGICAL   NO-UNDO EXTENT 2.
DEFINE VARIABLE mMaxCols     AS INT64     NO-UNDO.
DEFINE VARIABLE vText        AS CHARACTER NO-UNDO.
DEFINE VARIABLE vCount       AS INT64     NO-UNDO.
DEFINE VARIABLE vPrcInt AS INT64 NO-UNDO.

&IF DEFINED(ExpXML2) EQ 0 &THEN
   &IF DEFINED(ExpXML1) EQ 0 &THEN          /* Инициализация */
   { norm-beg.i
      &nobeg     = YES
      &hibeg     = YES
      &IS-BRANCH = YES
      &NOFIL     = YES
      &DEFS      = YES
      &TITLE     = "'ГЕНЕРАЦИЯ ОТЧЕТА'"
   }
   &ELSE     /* ExpXML1 */
   { norm-beg.i
      &IS-BRANCH = YES
      &NOFIL     = YES
      &DEFS      = YES
      &TITLE     = "'ГЕНЕРАЦИЯ ОТЧЕТА (для .xml)'"
   }
   &ENDIF
&ELSE     /* ExpXML2 ***************************************************/
DEFINE VARIABLE vTmp            AS CHARACTER NO-UNDO.
DEFINE VARIABLE in-Beg-Date     AS DATE      NO-UNDO.
DEFINE VARIABLE in-End-Date     AS DATE      NO-UNDO.
DEFINE VARIABLE in-Branch-ID    AS CHARACTER NO-UNDO.
DEFINE VARIABLE in-DataClass-Id AS CHARACTER NO-UNDO.

/* {norm-beg.i &nodate=yes &defs=yes } */
   ASSIGN
      in-Branch-ID    = ENTRY(2, GetSysConf("DateExpXML")) /* in-Branch-ID, */
      vTmp            = ENTRY(1, ENTRY(1, GetSysConf("DateExpXML")), ";")
      in-beg-date     = DATE(INT(ENTRY(2, vTmp, "/")), INT(ENTRY(1, vTmp, "/")), INT(ENTRY(3, vTmp, "/")) )
      vTmp            = ENTRY(2, ENTRY(1, GetSysConf("DateExpXML")), ";")
      in-End-Date     = DATE(INT(ENTRY(2, vTmp, "/")), INT(ENTRY(1, vTmp, "/")), INT(ENTRY(3, vTmp, "/")) )
      in-dataclass-id = "" /*DataBlock.DataClass-Id  */
      sh-branch-id    = in-branch-id
   .
   FIND FIRST branch WHERE branch.branch-id EQ in-Branch-ID NO-LOCK NO-ERROR.

   run startdebug in h_debug.
   {setdest.i &stream="stream fil"}
   PrinterWidth = printer.page-cols.
&ENDIF                        /* ExpXML2 */

/* -------------------------------------------------------------------------- */
IF GetSysConf("ExpXML") NE "YES" THEN  /* для экспорта в ФСФР нач. дата нужна */
   in-Beg-Date = in-End-Date.          /* т.к. начальная дата не задается     */
ELSE
   RUN SetSysConf IN h_base ("DateExpXML", STRING(in-Beg-Date, "99/99/9999") + ";"
                                         + STRING(in-End-Date, "99/99/9999") + ","
                                         + in-Branch-ID).
/* num-pril.i Печатать по указанию> 302-П */
&IF DEFINED (p14-8) &THEN
   {num-pril.i 8 "БАЛАНС||КРЕДИТНОЙ_ОРГАНИЗАЦИИ_РОССИЙСКОЙ_ФЕДЕРАЦИИ||НА_&2"}
&ELSE
   { num-pril.i 9 "БАЛАНС||КРЕДИТНОЙ_ОРГАНИЗАЦИИ_РОССИЙСКОЙ_ФЕДЕРАЦИИ||НА_&2"}
&ENDIF

&IF DEFINED(ExpXML2) EQ 0 &THEN
{ p14-9par.i }
&ENDIF

&IF DEFINED(ExpXML2) GT 0 &THEN
DEFINE VARIABLE vDelNullRazLog AS LOGICAL   NO-UNDO.
&ENDIF

&IF DEFINED(ExpXML1) GT 0 &THEN
   IF GetSysConf("ExpXML") EQ "YES" THEN
      RUN SetSysConf IN h_base ("ParamExpXML", STRING(vDelNullRazLog) + ","
                                             + STRING(vWorkPlanLog  ) + ","
                                             + STRING(vAllAcctLog   ) + ","
                                             + STRING(vDelNullStrLog) + ","
                                             + STRING(vInfoRestsLog ) ).
&ENDIF

&IF DEFINED(ExpXML2) GT 0 &THEN
ASSIGN
   vDelNullRazLog = LOGICAL (ENTRY(1, GetSysConf("ParamExpXML"))) /* LOGICAL(GetValAutoTest("Разд.РАБ")).     */
   vWorkPlanLog   = LOGICAL (ENTRY(2, GetSysConf("ParamExpXML"))) /* Использовать рабочий план                */
   vAllAcctLog    = LOGICAL (ENTRY(3, GetSysConf("ParamExpXML"))) /* По всем/По действующим балансовым счетам */
   vDelNullStrLog = LOGICAL (ENTRY(4, GetSysConf("ParamExpXML"))) /* Подавлять нулевые строки                 */
   vInfoRestsLog  = LOGICAL (ENTRY(5, GetSysConf("ParamExpXML"))) /* Выводить строку согласов. по остаткам сч.*/
.
&ENDIF

/* { modhead.i &out = "vHdrPril" &enddate = "in-end-date" } */
&IF DEFINED(ExpXML1) EQ 0 AND DEFINED(ExpXML2) EQ 0 &THEN
   { modhead.i &out = "vHdrPril" &enddate = "in-end-date" }
&ENDIF

mHeaderLog = NO.
iParRep    = REPLACE(iParRep," ","").
mMaxCols = 0.

DO mSeqInt = 1 TO NUM-ENTRIES (mSeqRepChar): /* "bpos,opos,fpos,dpos,tpos" */

   mClass = LOOKUP(ENTRY (mSeqInt,mSeqRepChar),iParRep).
   IF mClass = 0 THEN NEXT. /* не нужен */

   CASE SUBSTR (TRIM(ENTRY (mSeqInt,mSeqRepChar)), 1, 1):
      WHEN "b" THEN /* Баланс */
         mMaxCols = MAX(mMaxCols, 164).
      WHEN "o" THEN /* Внебаланс */
         mMaxCols = MAX(mMaxCols, 101).
      OTHERWISE    /* Все остальные категории */
         mMaxCols = MAX(mMaxCols, 96).
   END CASE.

END.

IF mMaxCols EQ 164 THEN
DO:
   { setdest.i &cols=164}
END.
ELSE IF mMaxCols EQ 101 THEN
DO:
   { setdest.i &cols=101}
END.
ELSE IF mMaxCols EQ 96 THEN
DO:
   { setdest.i &cols=96}
END.
ELSE
DO:
   { setdest.i }
END.

/* Главный цикл */
DO mSeqInt = 1 TO NUM-ENTRIES (mSeqRepChar):

   mClass = LOOKUP(ENTRY (mSeqInt,mSeqRepChar),iParRep).

   IF mClass NE 0 THEN
   DO:
      IF mSeqInt LE 4 THEN mGrClassLog [1] = YES.
      IF mSeqInt EQ 5 THEN mGrClassLog [2] = YES.

      CASE SUBSTR (TRIM(ENTRY (mSeqInt,mSeqRepChar)), 1, 1):
         WHEN "b" THEN /* Баланс */
            vWidthChar = "164".
         WHEN "o" THEN /* Внебаланс */
            vWidthChar = "101".
         OTHERWISE    /* Все остальные категории */
            vWidthChar = "96".
      END CASE.

      IF NOT mHeaderLog THEN
      DO:
/*закоментировал Красков А.С. по заявке #2809*/
/*         &IF DEFINED (p14-8) &THEN
            run stdhdr_u.p (output mResult, in-beg-date,in-end-date,
                           vWidthChar + ","
                           + vNumPril
                           + "Seq=PNZ"
                           + "TextP=" + "к_Правилам_ведения_бухгалтерского_учета|"
                                      + "в_кредитных_организациях;_расположенных|"
                                      + "на_территории_Российской_Федерации_____"
                           + ",{&in-LA-NCN1}," + vHdrPril + ",,YES").
         &ELSE */
            run stdhdr_p.p (output mResult,
                                   in-beg-date,
                                   in-end-date,
                                   vWidthChar + "," + vNumPril + "TOP" + ",{&in-LA-NCN1}," + vHdrPril + ",,YES").
/*         &ENDIF */                           /*закоментировал по заявке #2809*/
         mHeaderLog = YES.
      END.

      /* Текущий класс */
      in-DataClass-Id = ENTRY (mSeqInt,mSeqRepChar).
      RUN sv-get.p (       in-DataClass-ID + (IF GetSysConf("ExpXML") EQ "YES" AND GetSysConf("ExpXMLrub") NE "YES"
                                              THEN "t"
                                              ELSE ""),
                           in-Branch-ID,
                           in-Beg-Date,
                           in-End-Date,
                    OUTPUT mDataID).

      CASE SUBSTR (in-DataClass-ID, 1, 1):          /* Запуск процедуры печати */
         /* Баланс */
         WHEN "b" THEN
         DO:
            IF vAllAcctLog THEN                     /* По всем/По действующим балансовым счетам */
               &IF DEFINED (p14-8) &THEN
                  RUN p14-8b0.p
               &ELSE
                  RUN p14-9b0.p
               &ENDIF
                     (mDataID,vWorkPlanLog).
            ELSE
               &IF DEFINED (p14-8) &THEN
                  RUN p14-8b.p
               &ELSE
                  RUN p14-9b.p
               &ENDIF
                     (mDataID,vWorkPlanLog,vDelNullStrLog,vDelNullRazLog).

            RUN p14-9chk.p (mDataID).
         END.
         /* Внебаланс */
         WHEN "o" THEN
         DO:
            &IF DEFINED (p14-8) &THEN
              RUN p14-8v1.p
            &ELSE
              RUN p14-9v1.p
            &ENDIF
                 (mDataID,vWorkPlanLog,vAllAcctLog,vDelNullStrLog).
            RUN p14-9chk.p (mDataID).
         END.
         /* Все остальные категории */
         OTHERWISE
            IF GetSysConf("ExpXML") EQ "YES"
            THEN RUN r-rep1b_xml.p (mDataID,vWorkPlanLog,vAllAcctLog,vDelNullStrLog).
            ELSE
               &IF DEFINED (p14-8) &THEN
                  RUN p14-81b_1.p
               &ELSE
                  RUN p14-91b_1.p
               &ENDIF
                     (mDataID,vWorkPlanLog,vAllAcctLog,vDelNullStrLog).
      END CASE.
   END.

   IF (mSeqInt EQ 4 AND mGrClassLog [1] )  OR   /* 1 печать подписей после - bpos,opos,fpos */
      (mSeqInt EQ 5 AND mGrClassLog [2] )  THEN /* 2 печать подписей после - tpos */
   DO:
      /* строка согласования остатков */
      if vInfoRestsLog then
         put {&stream} skip
             "Остатки по счетам второго порядка, отраженным в балансе, соответствуют" skip
             "остаткам, показанным в оборотной ведомости и ведомости остатков по счетам;" skip
             "остатки по счетам второго порядка, отраженным в ведомости остатков по" skip
             "счетам, соответствуют остаткам, показанным в ведомости остатков размещенных" skip
             "(привлеченных) средств." skip(1).

      vPrcInt = INT64(GetSysConf("user-proc-id")).
      FIND FIRST user-proc WHERE RECID(user-proc) EQ vPrcInt
      NO-LOCK NO-ERROR.
      IF NOT AVAILABLE user-proc OR
         GetXAttrValueEx("user-proc",string(user-proc.public-number),"Подписи","") EQ ""
      THEN DO:
         RUN GetRepFioByRef("p14-9bas",in-Branch-ID,?,?).
         vText = "(наименование должности),(личная подпись),(фамилия и инициалы)".
         DO vCount = 1 TO mTotalSign:
            {printfioandpost.i
               &stream = "stream fil "
               &fio = mFioInRep[vCount]
               &post = mPostInRep[vCount]
               &size = "0"
               &lowertext = vText
            }
         END.
      END.
      ELSE DO:
         {signp8p9.i &stream = "stream fil " &department = branch }
         {signatur.i &stream = "stream fil " &department = branch  &f101=yes}
      END.
   END.

END. /* Главный цикл */

/* очистка памяти */
{ intrface.del acct }
{ intrface.del date }

{ norm-end.i
   &NOFIL = YES
}
IF GetSysConf("ExpXML") NE "YES" THEN
DO:
   { preview.i }     /* Просмотр готового отчета */
END.
/******************************************************************************/
